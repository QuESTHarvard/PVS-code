* People's Voice Survey data cleaning for Nepal
* Date of last update: November 4 ,2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Switzlerand. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************************** SWITZERLAND ********************************

* Import data 
use "$data/Switzerland/01 raw data/yougov_pvs_weighted_20260210.dta", clear

* Create country and wave vars
gen wave = 1

gen reccountry = 25
lab def country 25 "Switzerland"
lab values reccountry country

*confirm mode 
/*gen mode = 1
lab def mode 1 "CATI",modify
lab val mode mode */

* dropping variables that will not be in the harmonized dataset:
drop F131_5 // labeled 'age' with largely missing values and 'Y/N' responses
	drop F131_6 // similar issue with 'gender'
	
	* true drops:
	drop RecordNo F180_1 F180_2 F180_3 F180_4 A1 F085 _v1 // confirm _v1
	drop F003 S00 S003 hparents // consent questions?
	drop GeoPC_group_region_ch_3way // recode from postcodech for LINK regional 3 way matching on region and language

	* confirm if we should keep any of these in the dataset: 
	drop F037_1 F037_2 F037_3 F037_4 F037_5 F037_6 F037_7 F037_8 F037_777 F037_999 F037_opn // asks about problems during migration to CH
		drop F039 F040 // asks about injuries and care in CH
		drop F041_1 F041_2 // health upon arriving in CH 
		drop F036 // mode of transport 
		drop F057 F058 F058_opn // locating care upon arriving in CH 
		
	* asks about receiving care outside of Ch
	drop F088 F089_1 F089_2 F089_3 F090_1 F090_2 F090_3 F090_4 F090_5 F090_6 F090_999 F090_opn ///
		 F091_1 F091_2 F091_3 F091_4 F091_5 F091_6 F091_7 F091_999 F091_opn 

	*Question about suicide/self harm (not in mental health module) - confirm if I should add back in
	drop F048 F049

	* Adolescent modules: (how to label this?)
	*activation
	drop F050 F051 
	*sexual health
	drop F071 F072 F073 

	*specific questions about insurance coverage? - confirm drop from PVS dataset
	drop F021 // annual deductible
	drop F022 // OOP in past month
	drop F022_opn
	drop F023 // monthly premium
	drop F024_M F024_M_opn F024_N // projection of costs in 2026
	drop F026 //  TF question about deductibles/health ins 			
	drop F027 // TF about premiums in free choice model
	drop F028 // TF about deductible/premiums
	drop F029 // TF about HMO
	
	*In this country they asked about specific diseases:
	drop F052_N_1 //q11a_ch
	drop F052_N_2 //q11b_ch 
	drop F052_N_3 //q11c_ch
	drop F052_N_4 //q11d_ch
	drop F052_N_5 //q11e_ch 
	drop F052_N_6 //q11f_ch 
	drop F052_N_7 //q11g_ch
	drop F052_N_8 //q11h_ch
	drop F052_N_9 //q11i_ch
	drop F052_N_10 //q11j_ch
	drop F052_N_opn //q11j_ch_other

	*type of home care services (confirm with Todd if we want to keep these)
	drop F094_1 
	drop F094_2 
	drop F094_3 
	drop F094_4 
	drop F094_5 
	drop F094_6 
	drop F094_7 
	drop F094_8 
	drop F094_999 
	drop F094_opn

*dropping extra vars (weighting vars?):
drop education_highest gender_age gender_education linguistic_region malefemale urbanrural age_cat
	
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

rename caseid respondent_serial // what is 'RecordNo'?
rename age q1
rename wgt weight 

*citizenship question, look at Germany data (q4):
	* Ask todd if the citizenship questions should be q4 instead of q3
	
	/* Does the respondent have swiss citizenship? dropped- will need to double check this coding when we want to use this data
	gen q4a_ch = .
	replace q4a_ch = 1 if F010_1 == 169 | F010_2 == 169 | F010_3 == 169
	replace q4a_ch = 0 if F010_1 != 169 & F010_2 != 169 & F010_3 != 169 */
	drop F010_1 F010_2 F010_3
	  
	* Does respondent have single or multiple citizenship?
	*gen q3b = . // confirm

	* Country of citizenship (string)

	/* Were you born in Switzerland?
	gen q4c_ch = .
	replace q4c_ch = 1 if F011 == 1
	replace q4c_ch = 0 if F011 == 0 */
	drop F011

	/* How long have you lived in Switzerland, in years?
	gen q4d_ch = .
	replace q4d_ch = 1 if F012 == 1
	replace q4d_ch = 0 if F012 == 0 
	rename F012_opn q4d_ch_other */
	drop F012 F012_opn

	/* Which category of Swiss residence permit do you have?
	rename F013 q4e_ch 
	rename F013_opn q4e_ch_other*/ drop F013 F013_opn

rename F016 q5

*rename F017 q7
drop F017
*rename F017_opn q7_other
drop F017_opn

* Do you have any of the following other types of health insurance? If you have a combined supplementary insurance package, please indicate the individual components that it includes. (recode these with F019_999)
	*SS: confirm if we need these vars in the multi country dataset, would be used for derived. if not, drop.
rename F019_1 q7a_ch
rename F019_2 q7b_ch
rename F019_3 q7c_ch
rename F019_4 q7d_ch
rename F019_5 q7e_ch
rename F019_6 q7f_ch
rename F019_7 q7g_ch
rename F019_8 q7h_ch
rename F019_9 q7i_ch
rename F019_opn q7_ch_other 
rename F019_999 qj_ch

rename F031 q8
rename F034 q9
rename F035 q10
rename F052 q11

rename F053 q11_a
	
rename F055 q12_a
rename F056 q12_b

rename F076 q13 
rename F077 q15
rename F077_opn q15_other
rename F079 q16
rename F079_opn q16_other
rename F081 q17 

*rename F067 q17_b // dropped for now - when added back in, q17b_de: need to be renamed to remove `_de'
drop F067

rename F066 q17f_ch  // add to dd
rename F068 q17g_ch  // add to dd
rename F068_opn q17g_other

rename F060_1 q17_d
rename F060_2 q17_c
*rename F060_3 q17e_ch // dropped for now
drop F060_3

gen q18 = F083_opn
recode q18 (. = .r) if F083 == 999
drop F083 F083_opn

rename F084 q19
rename F086 q20
rename F087 q21
rename F087_opn q21_other

rename F093 q22
rename F093_opn q22_other
	
rename F096 q23 
rename F096_opn q23_other

/*
rename F097_1 q24a_ch
rename F097_2 q24b_ch
rename F097_3 q24c_ch
rename F097_4 q24d_ch
rename F097_999 q24e_ch
*rename F097_opn q24e_ch_other*/
drop F097_1
drop F097_2
drop F097_3
drop F097_4
drop F097_999
drop F097_opn

rename F099 q25
rename F100 q26

rename F103_1 q27_a
rename F103_2 q27_b
rename F103_3 q27_c
rename F103_4 q27_d
rename F103_5 q27_e
rename F103_6 q27_f
rename F103_7 q27_g
rename F103_8 q27_h
rename F103_9 q27_k
rename F103_10 q27i_ch // add to dd
rename F113 q27i_ch_de // confirm with todd

*rename F114 q28a_ch // dropped for now
drop F114
*rename F115 q28b_ch // dropped for now
drop F115
*rename F115_opn q28b_ch_other // dropped for now
drop F115_opn

rename F117 m2_ch // confirm with todd, similar to m2 in mental health module but not quite
rename F118 m3_ch // same as above, similar but not exact
rename F118_opn m3_ch_other
	
*phq variables:
rename F043_1 m1_a // matches mental health module for phq2 but confirm this is how we want to code this
rename F043_2 m1_b  // matches mental health module for phq2 but confirm this is how we want to code this
rename F043_3 m1_c_ch // doesn't match mental health module questions for phq - confirm this nomenclature is okay
rename F043_4 m1_d_ch // doesn't match mental health module questions for phq - confirm this nomenclature is okay

/*Primary care checks (new vars)
rename F120_1 q28_c1_ch 
rename F120_2 q28_c2_ch
rename F120_3 q28_c3_ch
rename F120_4 q28_c4_ch
rename F120_5 q28_c5_ch
rename F120_6 q28_c6_ch
rename F120_7 q28_c7_ch
rename F120_8 q28_c8_ch */
drop F120_1  
drop F120_2 
drop F120_3 
drop F120_4 
drop F120_5 
drop F120_6 
drop F120_7 
drop F120_8  

rename F129 q28_a
rename F130 q28_b

	/*reason for discrim:
	rename F131_1 q28b_1_ch 
	rename F131_2 q28b_2_ch
	rename F131_3 q28b_3_ch
	rename F131_4 q28b_4_ch
	rename F131_7 q28b_7_ch
	rename F131_8 q28b_8_ch
	rename F131_9 q28b_9_ch
	rename F131_10 q28b_10_ch 
	rename F131_11 q28b_12_ch
	rename F131_12 q28b_13_ch
	rename F131_999 q28b_14_ch 
	rename F131_opn q28b_15_ch*/
	drop F131_1  
	drop F131_2 
	drop F131_3 
	drop F131_4 
	drop F131_7 
	drop F131_8 
	drop F131_9 
	drop F131_10  
	drop F131_11 
	drop F131_12 
	drop F131_999  
	drop F131_opn  

rename F133 q29

gen q30 = .
rename F134 q30_other // SS: no 'q30' will have to recode open-ended answers

rename F135 q29a_ch
rename F136 q29a_other // SS: note will have to recode open-ended answers in the future

/*new vars
rename F137_N_1 q31a_ch 
rename F137_N_2 q31b_ch
rename F137_N_3 q31c_ch
rename F137_N_4 q31d_ch
rename F137_N_5 q31e_ch
rename F137_N_6 q31f_ch
rename F137_N_7 q31g_ch
rename F137_N_999 q31h_ch
rename F137_opn q31_ch_other */

drop F137_N_1  
drop F137_N_2 
drop F137_N_3 
drop F137_N_4 
drop F137_N_5 
drop F137_N_6 
drop F137_N_7 
drop F137_N_999 
drop F137_opn 

rename F139 q29b_ch // add to dd
	
	/*reason for sexual health care:
	rename F140 q31j_ch
	rename F141 q31k_ch
	rename F141_opn q31k_ch_other*/
	drop F140
	drop F141
	drop F141_opn

rename F143 q31a 
rename F144 q31b 
rename F146 q33
rename F146_opn q33_other
rename F148 q34 
rename F148_opn q34_other
rename F150 q35 
rename F151 q36
rename F152 q37   
rename F152_opn q37_other
          
rename F154_1 q38_a
rename F154_2 q38_b
rename F154_3 q38_c
rename F154_4 q38_d
rename F154_6 q38_f
rename F154_7 q38_g
rename F154_8 q38_h
rename F154_9 q38_i
rename F154_11 q38_k
rename F154_12 q38_l_ch // add to dd
  
rename F158 q38_e 
rename F163 q38_j
rename F166 q39

rename F167_1 q40_a
rename F167_2 q40_b
rename F167_3 q40_c
rename F167_4 q40_d
rename F167_5 q40e_ch_de
rename F167_6  q40h_ch_de

rename F173_1 q41_a
rename F173_2 q41_b
rename F173_3 q41_c
rename F173_4 q41d_ch_de // add to dd (similar to q41d_de)
rename F064 q41e_ch // confirm w todd to keep this (access contraception)
rename F065 q41f_ch // confirm: pay for contraception

rename F177 q42
rename F178 q45 
rename F179 q46 

*q50: respondent's native language/mother tongue-how to deal if participant has multiple answers for this var? q50 with one and then a multi var similar to citzenship?
	*can't change these variable names due to specifyrecodeinput file
rename F181_1 q50a_ch // English
rename F181_2 q50b_ch // French
rename F181_3 q50c_ch // German
rename F181_4 q50d_ch // Italian
rename F181_5 q50f_ch // Ukrainian
rename F181_6 q50h_ch // Dari
rename F181_7 q50i_ch // Pashto
rename F181_8 q50j_ch // Tigrinya
rename F181_9 q50k_ch // Other (specify) : Textfield
rename F181_999 q50_ch_dk // I don't know/ I prefer not to answer
rename F181_opn q50j_ch_other

**adding new q50a vars based on other specify text
gen q50l_ch = 0 // Spanish
gen q50m_ch = 0 // Portuguese

*questions about language barriers to care:
*rename F101 q50k_ch // dropped for now
drop F101
*rename F102 q50l_ch // dropped for now
drop F102

rename F183 q51 
rename F184 q51a
rename F184_opn q51a_other

rename F033 q51a_ch // working for pay FT, PT, or not at all

*gender question, inc non binary, ask Todd if ok to keep seperate from the other gender questions, also another reason the q3 german questions should be q4 to keep q3 about gender/sex/sexual orientiation
rename F185 q3a_ch
rename F185_opn q3a_ch_other
rename F187 q3b_ch
rename F187_opn q3b_ch_other 

rename languagepreference language
rename gender q3
rename ch_region_canton q4
rename ch_stadtraum_1_7 q4_ch 
  
* questions specific to adolescents?
rename F030 q8a_ch // add to dd

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = reccountry*1000 + language  
*gen recinterviewer_id = reccountry*1000 + interviewer_id // SS: missing from dataset

gen recq4 = reccountry*1000 + q4
*replace recq4 = .r if q4 == 998

gen recq5 = reccountry*1000 + q5  
replace recq5 = .r if q5 == 999

*gen recq7 = reccountry*1000 + q7
*replace recq7 = .r if q7== 999

gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8== 999

gen recq15 = reccountry*1000 + q15
replace recq15 = .r if q15== 999

gen recq33 = reccountry*1000 + q33
replace recq33 = .r if q33== 999 

*gen recq50 = reccountry*1000 + q50 // confirm no q50 var
*replace recq50 = .r if q50== 999

gen recq51 = reccountry*1000 + q51
replace recq51 = .r if q51== 999

* Relabel some variables now so we can use the orignal label values

lab def lang 25001 "CH: German" 25002 "CH: French" 25003 "CH: Italian"
lab values reclanguage lang

local q4l labels225
local q5l labels6
*local q7l labels7
local q8l labels29
local q15l labels75 
local q33l labels174 
local q51l labels218 

foreach q in q4 q5 q8 q15 q33 q51 { // q7
	qui elabel list ``q'l'
	local `q'n = r(k)
	local `q'val = r(values)
	local `q'lab = r(labels)
	local g 0
	foreach i in ``q'lab'{
		local ++g
		local gr`g' `i'
	}

	qui levelsof rec`q', local(`q'level)

	forvalues i = 1/``q'n' {
		local recvalue`q' = 25000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 25000+`: word `i' of ``q'val'') ///
									    (`"CH: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}



drop q4 q5 q8 q15 q33 q51 language // q7
ren rec* * 
  
*------------------------------------------------------------------------------*
* Generate variables  
 
gen respondent_id = "CH" + string(respondent_serial)  

gen mode = 1
lab def mode 1 "CATI",modify
lab val mode mode

gen date = .
 
gen q6 = .a
gen q14 = .a
 
gen q2 = .
replace q2=0 if q1 <18
replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 
replace q2 = .a if q1 == .a | q1 == .d | q1 == .r

lab def q2_label 0 "under 18" 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" ///
				6 "70-79" 7 "80 +" .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q2 q2_label
 
* q18/q19 mid-point var 
*SS: note, it looks like q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (.r = 0) if q19 == 1
recode q18_q19 (.r = 2.5) if q19 == 2
recode q18_q19 (.r = 7) if q19 == 3
recode q18_q19 (.r = 10) if q19 == 4
recode q18_q19 (.r = .r) if q19 == 999


*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* In raw data, 999 = "I don't know/ I prefer not to answer" 
*removed for now: q28a_ch q28b_ch q50k_ch q50l_ch q17e_ch q17_b q24a_ch q24b_ch q24c_ch q24d_ch q24e_ch
recode q5 q8 q51a_ch q9 q10 m1_a m1_b m1_c_ch m1_d_ch q11 q11_a q12_a q12_b q17_d /// q7
	   q17_c q12_b q41f_ch q17f_ch q17g_ch q13 q15 q16 q18 q19 q20 ///
	   q21 q22 q23 q25 q26 ///
	   q27i_ch_de q28_a q28_b  m2_ch m3_ch q29 q29a_ch q29b_ch q31a q31b q33 q34 ///
	   q35 q36 q37 q38_a q38_b q38_c q38_d q38_f q38_g q38_h q38_i q38_k q38_l_ch ///
	   q38_e q38_j q39 q40_a q40_b q40_c q40_d q40e_ch_de  q40h_ch_de q41_a q41_b ///
	   q41_c q41d_ch_de q41e_ch q42 q45 q46 q51 q51a q3b_ch (999 = .r)	

recode q8a_ch q8 q8a_ch (777 = .r) 
	   
*------------------------------------------------------------------------------*
* Check for implausible values - review

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
replace q21 = q18_q19 if q21 > q18_q19 & q21 < . // 36 changes

list q20 q21 if q20 == 0 & q21 == 1
recode q21 (1 = 0) if q20 ==0 // *SS check US/Nepal code for this - just updated it here: N=665 people with q21 == 1 but "no" to q20

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .
*SS: N=4 with issues, this is how we've fixed it in the past
recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=77 changes

drop visits_total


*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions 
 
 *NOTE: will have to update this if we introduce the dropped vars

* q8 
recode q8 (. = .a) if q8a_ch !=1

* q11_a
recode q11_a (. = .a) if q3 !=2 | q1 >=50

* q12_b
recode q12_b q41f_ch (. = .a) if q3 !=2 | q1 >=20

* q17f_ch, q17_b (add back), q17g_ch
recode q17f_ch q17g_ch (. = .a) if q1 >=20

* q15
recode q15 q16 q17 (. = .a) if q13 !=1

* q20
recode q20 (. = .a) if q18 <= 1 | q19 !=2 | q19 !=3 | q19 !=4

* q21
recode q21 (. = .a) if q20 !=2

* q24 // SS: might need to change if q23_other is recoded, removed: q24a_ch q24b_ch q24c_ch q24d_ch q24e_ch
recode q25 (. = .a) if q23 <= 0 | q23_other <= 0  | q23 == . | q23 == .a | q23 == .d | q23 == .r

* q50k_ch (F012 was dropped)
*recode q50k_ch q50l_ch (. = .a) if q5 != 2 // dropped

* q27_b
recode q27_b (. = .a) if q3 !=2 | q1 <=39

* q27_c, q27i_ch
recode q27_c q27i_ch (. = .a) if q3 !=2

* q27i_ch_de
recode q27i_ch_de (. = .a) if q1 <=49

* q28a_ch
*recode q28a_ch (. = .a) if q1 >=20
 
* q28b_ch
*recode q28b_ch (. = .a) if q28a_ch !=1 
 
* m3_ch
recode m3_ch (. = .a) if m2_ch !=1

* q28_a, q28_b
recode q28_a q28_b (. = .a) if q18 <=0 | q19 !=2 | q19 !=3 | q19 !=4 | q23 <= 0 | q26 !=1

* q30
recode q30 (. = .a) if q29 !=1

* q29b_ch
recode q29b_ch (. = .a) if q1>=20

* q31a
recode q31a q31b (. = .a) if q1<=20

* q33-25
recode q33 q34 q35 (. = .a) if q18 <=0 | q19 !=2 | q19 !=3 | q19 !=4 

* q36
recode q36 q37 (. = .a) if q35 !=1

* q38
recode q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q38_l_ch q39 (. = .a) if q18 <=0 | q19 !=2 | q19 !=3 | q19 !=4 
recode q38_k (. = .a) if q35 !=1

* q51 
recode q51 (. = .a) if q1<20
 
*------------------------------------------------------------------------------*
* Recode values and value labels:
	* SS: if we keep CH only q24 vars, use q24e_ch_other to recode: q24a_ch q24b_ch q24c_ch q24d_ch q24e_ch

*recode q3 values 
recode q3 (1 = 0 "Male") (2 = 1 "Female"), pre(rec) label(gender)
drop q3
 
recode q3a_ch (0 = 0 "Man") (1 = 1 "Woman") (2 = 2 "Other") (3 = .r "I prefer not to answer") ///
			  (4 = 4 "Non-binary"), pre(rec) label(gender2)
drop q3a_ch
 
recode q3b_ch (1 = 1 "Heterosexual/straight") (2 = 2 "Gay/lesbian") (3 = 3 "Bisexual") (4 = 4 "Other") ///
			  (5 = .d "I am not sure") (.r = .r "Refused"), pre(rec) label(sex)
drop q3b_ch
	
	*free text responses (confirm this code works):
	replace recq3b_ch = .d if q3b_ch_other == "0"
	replace recq3b_ch = 1 if q3b_ch_other == "Normal" | q3b_ch_other == "Normal (Hetero)" | ///
						  q3b_ch_other == "Normal _ Mann" | q3b_ch_other ==  "diciamo normale" | ///
						  q3b_ch_other == "normal" | q3b_ch_other == "normale Sexualität"

* q16
recode q16 (1 = 1 "Low cost") (2 = 2 "Short distance") (3 = 3 "Short waiting time") ///
		   (4 = 4 "Good healthcare provider skills") (5 = 5 "Staff shows respect") ///
		   (6 = 6 "Medicines and equipment are available") (7 = 7 "Only facility available") ///
		   (8 = 8 " Covered or assigned by insurance") (9 = 22 "Confidentiality of care") ///
		   (10 = 23 "Chosen by parents/family") (11 = 9 "Other") (.a = .a "NA"), pre(rec) label(q16_label)
drop q16
 
* q17
recode q17 (5 = .a)

* q19
recode q19 (1 = 0) (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") (.a = .a "NA") (.d = .d "Don't know") ///
		   (.r = .r "Refused"), gen(recq19) // originally 1 was seperated out
drop q19

*q21-q23 - recode based on "other" var that has the integer values - can someone review this?
gen recq21 = q21_other
recode recq21 (. = .a) if q21 == .a
recode recq21 (. = .r) if q21 == .r
recode recq21 (1 = 0) if q20 ==0 // shouldn't have a response for 1 in q21. All answers should be >1
drop q21 q21_other

gen recq22 = q22_other
recode recq22 (. = .a) if q22 == .a
recode recq22 (. = .r) if q22 == .r
drop q22 q22_other

gen recq23 = q23_other
recode recq23 (. = .a) if q23 == .a
recode recq23 (. = .r) if q23 == .r
drop q23 q23_other

* q27 
recode q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27_k q27i_ch (3 = .d)

* q45 
recode q45 (1 = 2 "Getting better") (2 = 1 "Staying the same") (3 = 0 "Getting worse") ///
		   (.a = .a "NA") (.d = .d "Don't know") ///
		   (.r = .r "Refused"), gen(recq45)
drop q45


*q51a - recode based on "other" var that has the integer values
gen recq51a = q51a_other
recode recq51a (. = .r) if q51 == .r
drop q51a q51a_other

ren rec* *

* Adding (.a, .d, .r) value labels:
label define labels222 .a "NA" .d "Don't know" .r "Refused",add
label define q5_label .a "NA" .d "Don't know" .r "Refused",add
*label define q7_label .a "NA" .d "Don't know" .r "Refused",add
label define q8_label .a "NA" .d "Don't know" .r "Refused",add
label define labels28 .a "NA" .d "Don't know" .r "Refused",add
label define labels31 .a "NA" .d "Don't know" .r "Refused",add
label define labels32 .a "NA" .d "Don't know" .r "Refused",add
label define labels56 .a "NA" .d "Don't know" .r "Refused",add
label define labels58 .a "NA" .d "Don't know" .r "Refused",add
label define labels59 .a "NA" .d "Don't know" .r "Refused",add
label define labels60 .a "NA" .d "Don't know" .r "Refused",add
label define labels74 .a "NA" .d "Don't know" .r "Refused",add
label define labels77 .a "NA" .d "Don't know" .r "Refused",add
label define q15_label .a "NA" .d "Don't know" .r "Refused",add
label define labels64 .a "NA" .d "Don't know" .r "Refused",add
label define labels63 .a "NA" .d "Don't know" .r "Refused",add
label define labels70 .a "NA" .d "Don't know" .r "Refused",add
label define labels81 .a "NA" .d "Don't know" .r "Refused",add
label define labels82 .a "NA" .d "Don't know" .r "Refused",add
label define labels118 .a "NA" .d "Don't know" .r "Refused",add
label define labels119 .a "NA" .d "Don't know" .r "Refused",add
label define labels122 .a "NA" .d "Don't know" .r "Refused",add
label define labels123 .a "NA" .d "Don't know" .r "Refused",add
label define labels124 .a "NA" .d "Don't know" .r "Refused",add
label define labels125 .a "NA" .d "Don't know" .r "Refused",add
label define labels126 .a "NA" .d "Don't know" .r "Refused",add
label define labels127 .a "NA" .d "Don't know" .r "Refused",add
label define labels128 .a "NA" .d "Don't know" .r "Refused",add
label define labels129 .a "NA" .d "Don't know" .r "Refused",add
label define labels130 .a "NA" .d "Don't know" .r "Refused",add
label define labels131 .a "NA" .d "Don't know" .r "Refused",add
label define labels132 .a "NA" .d "Don't know" .r "Refused",add
label define labels145 .a "NA" .d "Don't know" .r "Refused",add
label define labels146 .a "NA" .d "Don't know" .r "Refused",add
label define labels160 .a "NA" .d "Don't know" .r "Refused",add
label define labels161 .a "NA" .d "Don't know" .r "Refused",add
label define labels172 .a "NA" .d "Don't know" .r "Refused",add
label define labels173 .a "NA" .d "Don't know" .r "Refused",add
label define labels170 .a "NA" .d "Don't know" .r "Refused",add
label define q33_label .a "NA" .d "Don't know" .r "Refused",add
label define labels175 .a "NA" .d "Don't know" .r "Refused",add
label define labels176 .a "NA" .d "Don't know" .r "Refused",add
label define labels177 .a "NA" .d "Don't know" .r "Refused",add
label define labels178 .a "NA" .d "Don't know" .r "Refused",add
label define labels179 .a "NA" .d "Don't know" .r "Refused",add
label define labels180 .a "NA" .d "Don't know" .r "Refused",add
label define labels181 .a "NA" .d "Don't know" .r "Refused",add
label define labels182 .a "NA" .d "Don't know" .r "Refused",add
label define labels189 .a "NA" .d "Don't know" .r "Refused",add
label define labels183 .a "NA" .d "Don't know" .r "Refused",add
label define labels184 .a "NA" .d "Don't know" .r "Refused",add
label define labels185 .a "NA" .d "Don't know" .r "Refused",add
label define labels186 .a "NA" .d "Don't know" .r "Refused",add
label define labels190 .a "NA" .d "Don't know" .r "Refused",add
label define labels187 .a "NA" .d "Don't know" .r "Refused",add
label define labels188 .a "NA" .d "Don't know" .r "Refused",add
label define labels191 .a "NA" .d "Don't know" .r "Refused",add
label define labels192 .a "NA" .d "Don't know" .r "Refused",add
label define labels193 .a "NA" .d "Don't know" .r "Refused",add
label define labels194 .a "NA" .d "Don't know" .r "Refused",add
label define labels196 .a "NA" .d "Don't know" .r "Refused",add
label define labels195 .a "NA" .d "Don't know" .r "Refused",add
label define labels197 .a "NA" .d "Don't know" .r "Refused",add
label define labels198 .a "NA" .d "Don't know" .r "Refused",add
label define labels199 .a "NA" .d "Don't know" .r "Refused",add
label define labels200 .a "NA" .d "Don't know" .r "Refused",add
label define labels66 .a "NA" .d "Don't know" .r "Refused",add
label define labels67 .a "NA" .d "Don't know" .r "Refused",add
label define labels201 .a "NA" .d "Don't know" .r "Refused",add
label define labels203 .a "NA" .d "Don't know" .r "Refused",add
label define labels48 .a "NA" .d "Don't know" .r "Refused",add
label define labels49 .a "NA" .d "Don't know" .r "Refused",add
label define labels50 .a "NA" .d "Don't know" .r "Refused",add
label define labels51 .a "NA" .d "Don't know" .r "Refused",add
label define labels135 .a "NA" .d "Don't know" .r "Refused",add
label define labels136 .a "NA" .d "Don't know" .r "Refused",add

*delete this if we remove these vars (q24's):
label define labels113 .a "NA" .d "Don't know" .r "Refused",add
label define labels114 .a "NA" .d "Don't know" .r "Refused",add
label define labels115 .a "NA" .d "Don't know" .r "Refused",add
label define labels116 .a "NA" .d "Don't know" .r "Refused",add
label define labels117 .a "NA" .d "Don't know" .r "Refused",add


*------------------------------------------------------------------------------*
* Renaming variables 


*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
*label copy q50_label q50_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
*label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label q33_label q51_label // q50_label

* fix labels for mental health module:
label copy labels48 m1_a_label
label copy labels49 m1_b_label

lab val m1_a m1_a_label
lab val m1_b m1_b_label


label drop labels48 labels49 
*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q7_ch_other_original = q7_ch_other
label var q7_ch_other_original "Q7ch_other. Other"
	
gen q15_other_original = q15_other
label var q15_other_original "Q15. Other"

gen q16_other_original = q16_other
label var q16_other_original "Q16. Other"
	
gen q30_other_original = q30_other
label var q30_other_original "Q30. Other"

gen q33_other_original = q33_other
label var q33_other_original "Q33. Other"

gen q34_other_original = q34_other
label var q34_other_original "Q34. Other"	

gen q3a_ch_other_original = q3a_ch_other
label var q3a_ch_other_original "Q3a_other. Other"

gen q50j_ch_other_original = q50j_ch_other
label var q50j_ch_other_original "Q50_other. Other"

gen m3_ch_other_original = m3_ch_other
label var m3_ch_other_original "M3_other. Other"

foreach i in 25 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q15_other q16_other q24_other q30_other q33_other q34_other q37_other ///
	 q50_other q52a_us_other m2_i_other m6_j_other
	 
ren q7_ch_other_original q7_ch_other
ren q15_other_original q15_other
ren q16_other_original q16_other
ren q30_other_original q30_other
ren q33_other_original q33_other
ren q34_other_original q34_other
ren q3a_ch_other_original q3a_ch_other
ren q50j_ch_other_original q50j_ch_other
ren m3_ch_other_original m3_ch_other

*------------------------------------------------------------------------------*/

*Reorder variables
	order m1_a m1_b m1_c_ch m1_d_ch m2_ch m3_ch m3_ch_other
	order q*, sequential
	order respondent_id respondent_serial wave country weight language date mode 

*------------------------------------------------------------------------------*

* Save data
save "$data_mc/02 recoded data/input data files/pvs_ch.dta", replace


*------------------------------------------------------------------------------*
  