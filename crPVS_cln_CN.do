* People's Voice Survey data cleaning for China
* Date of last update: 17 April 2024
* Last updated by: Xiaohui Wang, Shalom Sabwa

/*

This file cleans Ipsos data for China. 
VERSION 2.0 of PVS 

Cleaning includes:
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction
	- Comparison with PVS V1.0 and make the changes and variable codequestionnaire for future V2.0 users
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 
*/

clear all
set more off 

*********************** CHINA ***********************

* Import data 
*use "$data/China/01 raw data/PVS_China_raw_01102024_label_recode.dta", clear
*note: This version is mainly focused on variable names and labels.

import excel "$data/China/01 raw data/PVS data_IPSOS.xlsx", sheet("常规访问数据") firstrow 

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

*change variable type to keep consistant with V1.0 varible types
* 4-22 SS edits: changed q12_a & q12_b to q12_a & q12_b, and no "language" var
destring q1code q1value q2 q3 q4region_province _1region_city _2region_couty _2region_couty_name _2other q5 q6 q7 q8 q9 q10 q11 q12a q12b q13 q14 q15 q16 q17 q18code q18value q19 q20 q21code q21value q22code q22value q23code q23value q24 q25 q26 q27a q27b q27bi q27bii q27c q27d q27e q27f q27g q27h q28a q28b q29 q30 q31a q31b q32 q33 q34 q35 q36 q37 q37other q38c q38a q38b q38d q38e q38f q38g q38h q38i q38k q38j q39code q39value q40a q40b q40c q40d q41a q41b q41c q42 q43 q45 q46 q47 q48 q49 q50 q51a q51b CELL1 CELL2, replace

* Renaming and labeling variables, and some recoding if variable will be dropped or change 
ren q12a q12_a
ren q12b q12_b

rename Interviewtimeminutes int_length
rename Interviewdate date

replace q1value = 999 if q1value == .
ren q1value q1
drop q1code

rename q4region_province q4
rename _1region_city q4_1
rename _2region_couty q4_2
rename _2region_couty_name q4_2_1
rename _2other q4_2_other
drop  q4_2_other

rename q7other q7_other

rename q14 q14_cn
rename q14other q14_other
rename q15other q15_other
rename q16other q16_other
rename q18code q18_code
rename q18value q18_value

drop q18_code
rename q18_value q18 //delete q18_code and rename q18_value, only keep variable q18

rename q21code q21_code
rename q21value q21_value

drop q21_code
ren q21_value q21

rename q22code q22_code
rename q22value q22_value

ren q22_value q22
drop q22_code

rename q23code q23_code
rename q23value q23_value

ren q23_value q23
drop q23_code

rename q24other q24_other

rename q27a q27_a
rename q27b q27i_cn
rename q27bi q27j_cn
rename q27bii q27_b
rename q27c q27_c
rename q27d q27_d
rename q27e q27_e
rename q27f q27_f
rename q27g q27_g
rename q27h q27_h

rename q28a q28_a
rename q28b q28_b

rename q30other q30_other
rename q31a q31_a
rename q31b q31_b

rename q32 q32_cn
rename q32other q32_other
rename q33other q33_other

rename q34other q34_other

rename q37other q37_other

rename q38a q38_a
rename q38b q38_b
rename q38c q38_c
rename q38d q38_d
rename q38e q38_e
rename q38f q38_f
rename q38g q38_g
rename q38h q38_h
rename q38i q38_i
rename q38j q38_j
rename q38k q38_k

drop q39code
ren q39value q39

rename q40a q40_a
rename q40b q40_b
rename q40c q40_c
rename q40d q40_d

rename q41a q41_a
rename q41b q41_b
rename q41c q41_c

*note: q44 NA in China
gen q44=.

rename q50other q50_other

rename q51a q51_cn
rename q51b q51

rename huifang retest

order q*, sequential

*------------------------------------------------------------------------------*
*Fix interview date and time variables - 

format date %td

*------------------------------------------------------------------------------*
*language data collection did in Chinese ony, which is the offical langue in China, people can communicate with Chiese"
gen language = .
replace language = 21001
lab def lang 21001 "CN: Chinese"
lab values language lang

gen country = 21
lab def country 21 "China"
lab values country country 

gen mode = 1
lab def mode 1 "CATI"
lab val mode mode

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is "Refused"

gen recq4 = country*1000 + q4

gen recq5 = country*1000 + q5
replace recq5 = .r if q5 == 999

gen recq8 = country*1000 + q8
replace recq8 = .r if q8 == 999

gen recq15 = country*1000 + q15
replace recq15 = .r if q15 == 999

gen recq33 = country*1000 + q33
replace recq33 = .r if q33 == 999

gen recq50 = country*1000 + q50

gen recq51 = country*1000 + q51
replace recq51 = .r if q51 == 999


foreach q in q4 q5 q8 q15 q33 q50 q51 {
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
		local recvalue`q' = 19000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 19000+`: word `i' of ``q'val'') ///
									    (`"CN: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

drop q4 q5 q8 q15 q33 q50 q51

*------------------------------------------------------------------------------*
* Generate variables 
gen respondent_id_cn = "CN" + ID
drop ID
rename respondent_id_cn respondent_id
label variable respondent_id "respondent ID"

* Q18/Q19 mid-point var ////ask shalom 996换成999，997换成998，最后一个997换成997不符合逻辑？

gen q18_q19 = q18 
recode q18_q19 (999 = 0) (998 = 0) if q19 == 1
recode q18_q19 (999 = 2.5) (998 = 2.5) if q19 == 2
recode q18_q19 (999 = 7) (998 = 7) if q19 == 3
recode q18_q19 (999 = 10) (998 = 10) if q19 == 4
recode q18_q19 (998 = .r) if q19 == 999

*Q7 V1.0 Q7=V2.0 Q7-insurance
gen recq7 = country*1000 + q7
replace recq7 = .a if q7 == .a
replace recq7 = .r if q7 == 999
label def q7_label 21001 "CN: Urban employee medical insurance" ///
                   21002 "CN: Urban and rural resident medical insurance (integrated urban resident medical insurance and new rural cooperative medical insurance)" ///
				   21003 "CN: Government medical insurance" ///
				   21004 "CN: Private medical insurance" ///
				   21005 "CN: Long-term care insurance" ///
				   21006 "CN: Other" .a "NA" .r "Refused"
label values recq7 q7_label
drop q7 

ren rec* *

*------------------------------------------------------------------------------*
* Recode refused and don't know values 
* In raw data, 999 = "refused" -change from V1.0 996 to 999 in V2.0 & all questions have 999

recode q18 q21 q22 q23 q27_a q27_b q27i_cn q27j_cn q27_c q27_d q27_e q27_f q27_g q27_h (998 = .d)
	  
recode q1 q2 q3 q4 q4_2 q5 q6 q7 q8 q9 q10 q11 q12_a q12_b ///
       q13 q14_cn q15 q16 q17 q18 q19 q20 q21 q22 q23 q24 q25 q26 q27_a ///
	   q27_b q27i_cn q27j_cn q27_c q27_d q27_e q27_f q27_g q27_h q28_a q28_b q29 ///
	   q30 q31_a q31_b q32_cn q33 q34 q35 q36 q37 q38_a ///
	   q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b ///
	   q40_c q40_d q41_a q41_b q41_c q42 q43 q45 q46 q47 q48 q49 q50 q51 CELL1 CELL2 (999 = .r)
	   
*------------------------------------------------------------------------------*
* Check for implausible values - review

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
*None

list q20 q21 if q21 == 0 | q21 == 1
* None

* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
* recode q21 (0 = .a) 
* recode q21 (1 = 2) 

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q18_q19 q22 q23) 

* Recoding q28_a and q28_b to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 

*SS: double check, doesn't make sense
/*
list visits_total q28_a q28_b if q28_a == 3 & visits_total > 0 & visits_total < . /// 
							  | q28_b == 3 & visits_total > 0 & visits_total < .

* Recoding q28_a and q28_b to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
*recode q28_a q28_b (3 = .r) if visits_total > 0 & visits_total < .
							  							  			 
* List if missing for q39/q40 but does have a visit
list visits_total q28_a q28_b if q28_a == .a & visits_total > 0 & ///
								 visits_total < . | ///
								 q28_b == .a & visits_total > 0 & ///
								 visits_total < .						 
							  
list visits_total q28_a q28_b if q28_a != 3 & visits_total == 0 /// 
						   | q28_b != 3 & visits_total == 0
						  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (.r = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months

*/
drop visits_total
	


*------------------------------------------------------------------------------*
* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .

recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q7 
recode q7 (. = .a) if q6 == 0 | q6 == .r 
recode q7 (nonmissing = .a) if q6 == 0

*q14-17
recode q14_cn q15 q16 q17 (. = .a) if q13 == 0 | q13 == .r 
recode q15 (. = .a) if q14_cn == 3
*0 changes made

* NA's for q19-21 
recode q19 (. = .a) if q18 != .d & q18 != .r 
*2,308 changes made to q19

recode q20 (. = .a) if q18 == 0 | q18 == 1 | q19 == 1 | q19 == .r 
recode q21 (. = .a) if q20 == 1 | q20 == .a | q20 == .r
*1,312 changes made to q20
*2,065 changes made to q21

*q25
recode q25 (. = .a) if q23 == 0 | q23 == .d | q23 == .r
*2,443 changes made

* q27j_cn & q27_c
recode q27j_cn (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r 
recode q27_c (. = .a) if q3 != 2 | q2 == .r 
*2,240 changes made to q27j_cn
*1,519 changes made to q27_c

* q30
recode q30 (. = .a) if q29 == 0 | q29 == .r
*2,523 changes made

* q43-49 na's  43=32 44=33 45=34 46=35 47=drop 48_a=38_a ...k 49=39
* There is one case where both q23 and q24 are missing, but they answered q43-49
recode q32_cn q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q19 == 1 | q19 == .r
*648 changes to all
	  	   	   
recode q32_cn q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (nonmissing = .a) if q18 == 0 | q19 == 1
* 0 changes to all	   
	      
recode q33 (. = .a) if q32_cn == 3 | q32_cn == .r

recode q36 (. = .a) if q35!=1 

recode q38_k (. = .a) if q35 == 0 | q35 == .r

*CELL2
recode CELL2 (. = .a) if CELL1 != 1

*------------------------------------------------------------------------------*
* Recode values and value labels so that their values and direction make sense

lab def q2_label 0 "under 18" 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" ///
				6 "70-79" 7 "80 +" .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q2 q2_label

lab def q3_label 0 "Male" 1 "Female" .a "NA" .d "Don't Know" .r "Refused"
lab val q3 q3_label

label define q4_label2 21001 "CN:安徽省" 21002"CN:北京市" 21003"CN:福建省" 21004"CN:甘肃省" 21005"CN:广东省" ///
					 21006"CN:广西壮族自治区" 21007 "CN:贵州省" 21008"CN:海南省" 21009"CN:河北省" 21010"CN:河南省" ///
					 21011"CN:黑龙江省" 21012"CN:湖北省" 21013 "CN:湖南省" 21014"CN:吉林省" 21015"CN:江苏省" ///
					 21016"CN:江西省" 21017"CN:辽宁省" 21018"CN:内蒙古自治区" 21019 "CN:宁夏回族自治区" 21020"青海省" ///
					 21021"CN:山东省" 21022"CN:山西省" 21023"CN:陕西省" 21024"CN:上海市" ///
					 21025 "CN:四川省" 21026"CN:天津市" 21027"CN:西藏自治区" 21028"CN:新疆维吾尔自治区" 21029"CN:云南省" ///
					 21030 "CN:浙江省" 21031"CN:重庆市" .a "NA" .d "Don't Know" .r "Refused"
label val q4 q4_label2

lab def q5_label2 21001 "CN: City" 21002 "CN: Suburb of city" 21003 "CN: Small town" 21004 "CN: Rural area" .a "NA" .d "Don't Know" .r "Refused"
lab val q5 q5_label2

*Yes, No, Refused, Don't Know, NA
lab def YNRF 0 "No" 1 "Yes" .a "NA" .d "Don't Know" .r "Refused"
lab val q6 q11 q13 q26 q27_a q27_b q27i_cn q27j_cn q27_c q27_d q27_e q27_f q27_g q27_h q28_a ///
		q28_b q29 q31_a q31_b YNRF

/*		
lab def q7_label 1 "Urban employee medical insurance" 2 "Urban and rural resident medical insurance" ///
				3 "Government medical insurance" 4 "Private medical insurance" 5 "Long-term care insurance" ///
				6 "Other" .a "NA" .d "Don't Know" .r "Refused"
lab val q7 q7_label
*/

lab def q8_label 21001 "CN:No formal education (illiterate)" 21002 "CN:Did not finish primary school" ///
				21003 "CN:Elementary school" ///
				21004 "CN:Middle school" 21005 "CN:High school" 21006 "CN:Vocational school" ///
				21007 "CN:Two-/Three-Year College/Associate degree" 21008 "CN:Four-Year College/Bachelor's degree" ///
				21009 "CN:Master's degree" 21010 "CN:Doctoral degree/Ph.D." .a "NA" .d "Don't Know" .r "Refused"
lab val q8 q8_label				

*Endorsement
lab def endorse 0 "Poor" 1 "Fair" 2 "Good" 3 "Very good" 4 "Excellent" 5 "I did not receive healthcare from this provider in the past 12 months" .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q9 q10 q17 q25 q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q42 ///
        q43 q47 q48 q49 endorse

*Confidence
lab def confidence 0 "Not at all confident" 1 "Not too confident" 2 "Somewhat confident" 3 "Very confident" .a "NA" .d "Don't Know" .r "Refused"
lab val q12_a q12_b q41_a q41_b q41_c confidence 

lab def q14_label 1 "Public" 2 "Private (for-profit)" 3 "Other, specify" .a "NA" .d "Don't Know" .r "Refused"
lab val q14_cn q14_label 

lab def q15_label2 21001 "CN: General hospital (Not including traditional chinese medicine hospital" ///
				 21002 "CN: Specialized hospital (Not including traditional chinese medicine hospital)" ///
				 21003 "CN: Chinese medicine hospital" 21004 "CN: Community healthcare center" ///
				 21005 "CN: Township hospital" ///
				 21006 "CN: Health care post" 21007 "CN: Village clinic/Private clinic" 21008 "CN: Other" .r "Refused" ///
				 .d "Don't Know" .a "NA"
lab val q15 q15_label2
				 
lab def q16_label 1 "Low cost" 2 "Short distance" 3 "Short waiting time" 4 "Good healthcare provider skills" ///
				 5 "Staff shows respect" 6 "Medicines and equipment are available" 7 "Only facility available" ///
				 8 "Covered by insurance" 9 "Other, specify" .a "NA" .d "Don't Know" .r "Refused"
lab val q16 q16_label

*NA/Refused/DK
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q18 q20 q21 q22 q23 q39 CELL2 na_rf

lab def q19_label 0 "0" 1 "1-4" 2 "5-9" 3 "10 or more" .a "NA" .d "Don't Know" .r "Refused"
lab val q19 q19_label 

lab def q24_label 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)" 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)" 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)" 4 "Other, specify" .a "NA" .d "Don't Know" .r "Refused"
lab val q24 q24_label 

lab def q30_label 1 "High cost (e.g., high out of pocket payment, not covered by insurance)" ///
				 2 "Far distance (e.g., too far to walk or drive, transport not readily available)" ///
				 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)" ///
				 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)" ///
				 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)" ///
				 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)" ///
				 7 "Illness not serious enough" /// 
				 8 "Other" .a "NA" .d "Don't Know" .r "Refused"
lab val q30 q30_label

lab def q32_label 1 "Public" 2 "Private (for-profit)" 3 "Other, specify" .a "NA" .d "Don't Know" .r "Refused"
lab val q32_cn q32_label 

lab def q33_label2 21001 "CN: General hospital (Not including traditional chinese medicine hospital" ///
				 21002 "CN: Specialized hospital (Not including traditional chinese medicine hospital)" ///
				 21003 "CN: Chinese medicine hospital" 21004 "CN: Community healthcare center" ///
				 21005 "CN: Township hospital" 21006 "CN: Health care post" 21007 "CN: Village clinic/Private clinic" ///
				 21008 "CN: Other" .a "NA" .d "Don't Know" .r "Refused"
lab val q33 q33_label2

lab def q34_label 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)" 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)" 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)" 4 "Other, specify"
lab val q34 q34_label 


lab def q35_label 0 "No, I did not have an appointment" ///
				 1 "Yes, the visit was scheduled, and I had an appointment" ///
				 .a "NA" .d "Don't Know" .r "Refused"
lab val q35 q35_label 


lab def q36_label 1 "Same or next day" 2 "2 days to less than one week" 3 "1 week to less than 2 weeks" ///
				 4 "2 weeks to less than 1 month" 5 "1 month to less than 2 months" ///
				 6 "2 months to less than 3 months" 7 "3 months to less than 6 months" 8 "6 months or more" ///
				 .a "NA" .d "Don't Know" .r "Refused"
lab val q36 q36_label 

lab def q37_label 1 "Less than 15 minutes" 2 "15 minutes to less than 30 minutes" ///
				 3 "30 minutes to less than 1 hour" 4 "1 hour to less than 2 hours" ///
				 5 "2 hours to less than 3 hours" 6 "3 hours to less than 4 hours" ///
				 7 "More than 4 hours (specify)" .a "NA" .d "Don't Know" .r "Refused"
lab val q37 q37_label

lab def YN_nojudge 0 "Poor" 1 "Fair" 2 "Good" 3 "Very good" 4 "Excellent" 5 "I am unable to judge" ///
				   .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q40_a q40_b q40_c q40_d YN_nojudge	  

lab def q45_label 1 "Getting better" 2 "Staying the same" 3 "Getting worse" .a "NA" .d "Don't Know" .r "Refused"
lab val q45 q45_label

lab def q46_label 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it." ///
				 2 "There are some good things in our healthcare system, but major changes are needed to make it work better." ///
				 3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better." ///
				 .a "NA" .d "Don't Know" .r "Refused"
lab val q46 q46_label

lab def q50_label2 21001 "CN: Mandarin Chinese" 21002 "CN: Minority languages" .a "NA" .d "Don't Know" .r "Refused"
lab val q50 q50_label2	   
		   
lab def q51_label2 21001 "CN:<700" 21002 "CN:700-1499" 21003 "CN:1500-2499" 21004 "CN:2500-3999" ///  
			   21005 "CN:4000-6999" 21006 "CN:>=7000" .a "NA" .d "Don't Know" .r "Refused"
lab val q51 q51_label2

lab def CELL1label 0 "No / No other numbers" 1 "Yes" .a "NA" .d "Don't Know" .r "Refused"
lab val CELL1 CELL1label
		   
*------------------------------------------------------------------------------*
**# PVS ROMANIA - CATEGORIZATION OF "OTHER, SPECIFY" RESPONSES

replace q7_other = "不知道" if q7_other == "不清楚" ///
                              | q7_other == "不知道." ///
							  | q7_other == "不知道。" ///
							  | q7_other == "不知道没注意，每次都是直接支付宝" ///
							  | q7_other== "不知道，不清楚" ///
							  | q7_other== "不知道，我忘了，说不清楚" ///
							  | q7_other == "不记得" ///
							  | q7_other == "家里给买的不太清楚" ///
							  | q7_other == "我不清楚，我爸帮我搞的。" ///
							  | q7_other == "我不知道这两个的区别，是公司买的" ///
							  | q7_other == "我也不知道，我没了解过这个方面" ///
							  | q7_other == "这个我不知道"
							  
replace q7_other = "社保" if q7_other == "个人买的社保" ///
                              | q7_other == "社会医保" ///
							  | q7_other == "社保。" ///
							  | q7_other == "社保，不知道是什么" 
replace q7_other = "城镇职工医疗保险和商业医疗保险" if q7_other == "城乡和商业都有，一样重要" ///
                              | q7_other == "城镇职工医疗保险和商业医疗保险都有在用，如果去私立医院就是商业医疗保险，去公立医院就是城镇职工医疗保险。" ///
							  | q7_other == "我有职工和商业险，我不知道哪个最主要" 
replace q7_other = "城乡居民医疗保险和商业医疗保险" if q7_other=="城镇职工医疗保险和商业医疗保险都有，都重要啊"  ///
							  | q7_other == "城乡居民医疗保险，和商业医疗"
replace q7= 21002 if q7_other == "每年120元"
replace q7_other = "4种保险" if q7_other == "什么都有，公费，个人都有，有四个，我不知道哪个最重要"
replace q7_other=".d" if q7_other == "不知道" ///

replace q14_other="不知道" if q14_other=="不清楚"
replace q14_other=".d" if q14_other=="不知道"

replace q15_other = "不知道" if q15_other == "不清楚" ///
                              | q15_other == "三甲医院" ///
                              | q15_other == "中西五医院" ///
							  | q15_other == "中西结合医院" ///
							  | q15_other == "保健院" ///
							  | q15_other == "天门市妇幼保健院" ///
							  | q15_other == "工人医院"
replace q15_other=".d" if q15_other == "不知道"

replace q16=8 if q16_other == "单位附属医院" ///
               | q16_other == "员工" ///
			   | q16_other == "因为我在那里上班。" ///
			   | q16_other == "在医院工作"  ///
			   | q16_other == "就在本单位工作，所以选择这家医院"  ///
			   | q16_other == "我在那工作"  ///
			   | q16_other == "我是在这个医院读书"  ///
			   | q16_other == "自己的医院"  ///
			   | q16_other == "这家医院的职工"
list q16_other if q16_other == "单位附属医院" ///
               | q16_other == "员工" ///
			   | q16_other == "因为我在那里上班。" ///
			   | q16_other == "在医院工作"  ///
			   | q16_other == "就在本单位工作，所以选择这家医院"  ///
			   | q16_other == "我在那工作"  ///
			   | q16_other == "我是在这个医院读书"  ///
			   | q16_other == "自己的医院"  ///
			   | q16_other == "这家医院的职工"
replace q16=7 if q16_other == "没得选择"
list q16_other if q16_other == "没得选择"
replace q16=6 if q16_other == "设备好"
list q16_other if q16_other == "设备好"
replace q16=5 if q16_other == "医院服务好"
list q16_other if q16_other == "医院服务好"
replace q16=3 if q16_other == "人少"
list q16_other if q16_other == "人少"
replace q16=4 if q16_other == "三甲医院" ///
               | q16_other == "出名"  ///
	           | q16_other == "因为那家医院是当地最好的" ///
			   | q16_other == "大医院比较权威"  ///
			   | q16_other == "大医院，比较有公信力"  ///
			   | q16_other == "当地名气最大"  ///
			   | q16_other == "最好的医院"  ///	
			   | q16_other == "机构比较权威。" ///
			   | q16_other == "权威" ///
			   | q16_other == "权威机构"  ///
			   | q16_other == "比较权威"  ///
			   | q16_other == "比较权威靠谱"  ///
			   | q16_other == "这是三甲医院"  ///
			   | q16_other == "医院比较大，医院等级"  ///
			   | q16_other == "医院规模比较大"  ///
			   | q16_other == "医院较大，比较专业有安全感"  ///
			   | q16_other == "因为它是市级医院，比较大一些"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "大医院，比较放心"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "最大的，安全一些"  ///
			   | q16_other == "比较正规吧大医院"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "专科"  ///
			   | q16_other == "这里最大的医院"
list q16_other if q16_other == "三甲医院" ///
               | q16_other == "出名"  ///
	           | q16_other == "因为那家医院是当地最好的" ///
			   | q16_other == "大医院比较权威"  ///
			   | q16_other == "大医院，比较有公信力"  ///
			   | q16_other == "当地名气最大"  ///
			   | q16_other == "最好的医院"  ///	
			   | q16_other == "机构比较权威。" ///
			   | q16_other == "权威" ///
			   | q16_other == "权威机构"  ///
			   | q16_other == "比较权威"  ///
			   | q16_other == "比较权威靠谱"  ///
			   | q16_other == "这是三甲医院"  ///
			   | q16_other == "医院比较大，医院等级"  ///
			   | q16_other == "医院规模比较大"  ///
			   | q16_other == "医院较大，比较专业有安全感"  ///
			   | q16_other == "因为它是市级医院，比较大一些"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "大医院，比较放心"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "最大的，安全一些"  ///
			   | q16_other == "比较正规吧大医院"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "专科" ///
			   | q16_other == "这里最大的医院"
replace q16=2 if q16_other == "乡镇医院方便" ///
               | q16_other == "综合因素，距离近公立方便多种原因"
list q16_other if q16_other == "乡镇医院方便" ///
               | q16_other == "综合因素，距离近公立方便多种原因"
replace q16_other = "相信中医" if q16_other == "中医比西医好一点" ///
               | q16_other == "中药对人体副作用伤害小" ///
			   | q16_other == "主要是想看中医" ///
			   | q16_other == "我支持中医" ///
			   | q16_other == "我相信中医这块。" ///
			   | q16_other == "更相信中医" ///
			   | q16_other == "要看中医"	   
replace q16_other = "专科" if q16_other == "专病专治" ///
               | q16_other == "这是专科医院" ///
			   | q16_other == "专业对口"
replace q16_other = "朋友推荐" if q16_other == "别人推荐的" ///
               | q16_other == "熟人介绍" 
replace q16_other = "环境好" if q16_other == "环境比较好" 
replace q16_other = "医疗条件好" if q16_other == "医疗条件有保障"
replace q16_other = "有熟人" if q16_other == "有熟人在，可以帮忙" ///
                                | q16_other == "有熟人，有认识的人" ///
								| q16_other == "有熟人。" ///
								| q16_other == "有家人在" ///
								| q16_other == "因为我老婆在那里上班。" ///
								| q16_other == "有熟人在，可以帮忙。" ///
								| q16_other == "我以前在这里工作"
								
replace q16_other = "信任医院" if q16_other == "具有安全感、靠谱" ///
								| q16_other == "口碑" ///
								| q16_other == "口碑好" ///
								| q16_other == "安心些" ///
								| q16_other == "存在时间长，从出生就在" ///
								| q16_other == "对医院的信任吧。" ///
								| q16_other == "放心" /// 
								| q16_other == "正规医疗机构比较放心" ///
								| q16_other == "正规医院" ///
								| q16_other == "比较规范" ///
								| q16_other == "镇医院有保障撒。" ///
								| q16_other == "放心一点不会乱收费"
replace q16_other = "公立医院" if q16_other == "公立医院有保障" ///
                                | q16_other == "公立医院，比较可靠" ///
								| q16_other == "国家医院，正规" ///
								| q16_other == "当地时间最早的公立医院" ///
								| q16_other == "是公立医院，上公立医院方便"
replace q16_other="习惯了" if q16_other == "习惯" ///
                            | q16_other == "习惯性。" ///
							| q16_other == "我去习惯了。" ///
							| q16_other == "已经习惯去这家医院" ///
							| q16_other == "长期调理" ///
							| q16_other == "全家人都在这家机构打疫苗" ///
							| q16_other == "长期看病的地方"
replace q16_other = "信任医院" if q16_other == "习惯了"
replace q16_other = "信任医院" if q16_other == "公立医院"
*听录音能否这样归类
replace q16_other="综合原因" if q16_other == "三甲医院.距离近可以报销等综合因素" ///
                            | q16_other == "就是综合方面比较好" ///
							| q16_other == "医疗资源好" ///
							| q16_other == "医疗有保障" ///
							| q16_other == "医疗条件好" ///
							| q16_other == "环境好"

replace q24 = 1 if q24_other == "体检后，发现有问题去检查。"
list q24_other if q24_other == "体检后，发现有问题去检查。"
replace q24_other = "" in 526 //526 is the result of "list"
replace q24 = 1 if q24_other == "无明确病症，健康咨询"
list q24_other if q24_other == "无明确病症，健康咨询"
replace q24_other = "" in 947 //947 is the result of "list"
replace q24 = 1 if q24_other == "就是开药"
list q24_other if q24_other == "就是开药"
replace q24_other = "" in 2045 //2045 is the result of "list"
replace q24 = 1 if q24_other == "用药咨询"
list q24_other if q24_other == "用药咨询"
replace q24_other = "" in 1679 //1679 is the result of "list"
							
							
replace q30 = 1 if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"
list q30_other if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"
replace q30_other = "" if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"	
	
replace q30=3 if q30_other=="不好挂号"  ///
	 | q30_other == "人员满了，没排上号"  ///
	 | q30_other == "人太多，医生太少了"  ///
	 | q30_other == "医护人员不足"  ///
	 | q30_other == "医院人满为患，排不了队了" | ///
     | q30_other == "挂不上号" ///
	 | q30_other == "排不上号"  ///
	 | q30_other == "没挂上号。"  ///
	 | q30_other == "没有挂到号"  
replace q30_other = "" if q30_other == "不好挂号"  ///
	 | q30_other == "人员满了，没排上号"  ///
	 | q30_other == "人太多，医生太少了"  ///
	 | q30_other == "医护人员不足"  ///
	 | q30_other == "医院人满为患，排不了队了" | ///
     | q30_other == "挂不上号" ///
	 | q30_other == "排不上号"  ///
	 | q30_other == "没挂上号。"  ///
	 | q30_other == "没有挂到号"  
replace q30 = 7 if q30_other == "自己在家吃药"
replace q30_other = "" if q30_other == "自己在家吃药"
replace q30_other = "COVID (COVID restritions or COVID fear)" if q30_other == "因为新冠疫情，医院科室停诊" ///
      | q30_other == "因为新冠的时候出不去。" ///
	  | q30_other == "新冠期间" ///
	  | q30_other == "新冠期间，就诊比较困难。"  ///
	  | q30_other == "新冠肺炎" ///
	  | q30_other == "疫情期间医护人员不够" ///
      | q30_other == "疫情期间，医院不接诊，需要转移到别的医院" ///
      | q30_other == "隔离。" 
replace q30_other = "没有时间" if q30_other == "工作原因" ///
      | q30_other == "没时间" ///
	  | q30_other == "工作忙。" ///
	  | q30_other == "没有时间去" ///
	  | q30_other == "家里走不开。"							
							
replace q32_other = "不知道" if q32_other == "不知道。" ///
	  | q32_other == "没记住。"  ///
	  | q32_other == "单位固定医疗机构体检"  ///
	  | q32_other == "农村的诊所，不知道是公立还是私立" 
replace q32_cn = 2 if q32_other == "国际"
replace q32_other = "" if q32_other == "国际"
replace q32_other = ".d" if q32_other == "不知道"							

replace q33_other = "不知道" if q33_other == "不清楚" ///
                | q33_other == "不清楚。" /// 
				| q33_other=="忘记了。" ///
				|q33_other=="私人医院不清楚" 
replace q33_other = "体检机构" if q33_other == "不知道名字，就是一个体检机构" ///
                | q33_other == "体检中心" /// 
				| q33_other=="体检医院" ///
				| q33_other=="公司的体检中心" /// 
				| q33_other=="和谐健康体检中心" ///
				| q33_other=="实名体检中心" ///
				| q33_other=="美兆体检中心" 
replace q33_other = "妇幼保健医院" if q33_other == "天门市妇幼保健院" ///
                | q33_other == "妇幼保健院" 
replace q33 = 21001 if q33_other == "中西结合医院" | q33_other == "工人医院"
replace q33_other = "" if q33_other == "中西结合医院" | q33_other == "工人医院"							
							
replace q34 = 1 if q34_other == "内分泌不调" ///
	| q34_other == "去医院做手术"  ///
	| q34_other == "囊肿"  ///
	| q34_other == "拔牙"  ///
	| q34_other == "消化不良"  ///
	| q34_other == "看牙"  ///
	| q34_other == "箍牙"  ///
	| q34_other == "补牙"  ///
	| q34_other == "补牙齿"  ///
	| q34_other == "没事儿干，去医院溜达。我也不知道啥原因了，感觉有点疼，B超，ct,检查后，医生说没什么问题。"  ///
	| q34_other == "配假牙"
replace q34_other = ""  if q34_other == "内分泌不调" ///
	| q34_other == "去医院做手术"  ///
	| q34_other == "囊肿"  ///
	| q34_other == "拔牙"  ///
	| q34_other == "消化不良"  ///
	| q34_other == "看牙"  ///
	| q34_other == "箍牙"  ///
	| q34_other == "补牙"  ///
	| q34_other == "补牙齿" ///
	| q34_other == "没事儿干，去医院溜达。我也不知道啥原因了，感觉有点疼，B超，ct,检查后，医生说没什么问题。"  ///
	| q34_other == "配假牙"
replace q34 = 2 if q34_other == "调理身体"
replace q34_other = "" if q34_other == "调理身体"
replace q34_other = "生孩子"  if q34_other == "生产" | ///
	q34_other == "生孩子去的" | ///
	q34_other == "生小孩" 
replace q34_other=".d" if q34_other=="不清楚" ///
      | q34_other=="不知道" ///
	  | q34_other=="我也不知道，搞不懂"							


/* SS: This needs to be fixed, not working	  
replace q37=.r if q37_other=="不清楚"
*replace q37_other = "" in 2259 // SS: confirm with Xiaohui this line of code
replace q37_other = "24" if q37_other == "第二天"
replace q37_other = "5" if q37_other == "4-5小时内"
replace q37_other = "48" if q37_other == "48小时" | q37_other = "两天"
replace q37_other = "9" if q37_other == "9小时"
destring q37_other, replace	  	  
*/
	  
replace q50_other = "蒙古族" if q50_other == "蒙族" | q50_other == "蒙古"
replace q50_other = "维吾尔族" if q50_other == "新疆维吾尔族"
replace q50 = 21001 if q50_other == "闽南语"
replace q50_other = "" if q50_other == "闽南语"		

*------------------------------------------------------------------------------*
* Label variables					
lab var country "Country"
lab var int_length "Interview length (minutes)" 
lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"
lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab variable q4 "Q4. What Province do you live in?"
lab variable q4_1 "q4_1.region_city"
lab variable q4_2 "q4_2. region_couty"
lab variable q4_2_1 "q4_2_1.region_couty_name"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7. Other type of health insurance" 
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. By longstanding, I mean illness, health problem, or mental health problem which has lasted or is expected to last for six months or more."
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or provider's group you usually go to?" 
lab var q14_cn "Q14. CN only: Is this a public, private, or NGO/faith-based healthcare facility?"
label variable q14_other "Q14_Other. if the respondent do not know public/private"
lab var q15 "Q15. What type of healthcare facility is this?"
label variable q15_other "Q15_Other. Other"
label variable q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
label variable q16_other "Q16. Other reasons"
label variable q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label variable q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label variable q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label variable q20 "Q20. You said you made * visits. Were they all to the same facility?"
label variable q21 "Q21. How many different healthcare facilities did you go to in total?"
label variable q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label variable q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label variable q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
label variable q24_other "Q24_other reasons of virtual or telemedicine visit."
label variable q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label variable q26 "Q26. Stayed overnight at a facility in past 12 months (inpatient care)"
label variable q27_a "Q27a. Blood pressure tested in the past 12 months"
label variable q27_b "Q27b. Breast examination"
label variable q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label variable q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label variable q27_e "Q27e. Had your teeth checked in the past 12 months"
label variable q27_f "Q27f. Had a blood sugar test in the past 12 months"
label variable q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label variable q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label variable q27i_cn "Q27i. CN only: Breast colour ultrasound (B-ultrasound)"
label variable q27j_cn "Q27j. CN only: Received a mammogram (a special X-ray of the breast)"
label variable q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label variable q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label variable q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label variable q30 "Q30. The last time this happened, what was the main reason?"
label variable q30_other "Q30_Other. Other"
label variable q31_a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label variable q31_b "Q31b. Sell items to pay for healthcare"
label variable q32_cn "q32_cn. Last visit facility type public/private/social security/NGO/faith-based?"
label variable q32_other "q32_Other. other last visit facility type"
label variable q33 "Q33. What type of healthcare facility is this?"
label variable q33_other "Q33_Other. Other type of healthcare facility"
label variable q34 "Q34. What was the main reason you went?"
label variable q34_other "Q34_Other. Other reasons"
label variable q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label variable q36 "Q36. How long did you wait in days, weeks, or months between scheduling the appointment and seeing the health care provider?"
label variable q37 "Q37. At this most recent visit, once you arrived at the facility, approximately how long did you wait before seeing the provider?"
label variable q37_other "Q37_Other. Other"
label variable q38_a "Q38a. How would you rate the overall quality of care you received?"
label variable q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
label variable q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
label variable q38_d "Q38d. How would you rate the level of respect your provider showed you?"
label variable q38_e "Q38e. How would you rate your provider knowledge about your prior visits and test results?"
label variable q38_f "Q38f. How would you rate whether your provider explained things clearly?"
label variable q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
label variable q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
label variable q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
label variable q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
label variable q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
label variable q39 "Q39. How likely would recommend this facility to a friend or family member?"
label variable q40_a "Q40a. How would you rate the quality of care provided for care for pregnancy?"
label variable q40_b "Q40b. How would you rate the quality of care provided for children?"
label variable q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label variable q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label variable q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label variable q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label variable q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label variable q42 "Q42. How would you rate the quality of public healthcare system in your country?"
label variable q43 "Q43. How would you rate the quality of private healthcare system in your country?"
label variable q45 "Q45. Is your country's health system is getting better, same or worse?"
label variable q46 "Q46. Which of these statements do you agree with the most?"
label variable q47 "Q47. How would you rate the government's management of the COVID-19 pandemic?"
label variable q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label variable q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label variable q50 "Q50. What is your native language or mother tongue?"
label variable q50_other "Q50_Other. Other languages"
label variable q51 "Q51. Total monthly household income"
label variable q51_cn "Q51a. CN only: What is the number of people in the household?"
label variable CELL1 "CELL1. Do you have another mobile phone number besides the one I am calling. "
label variable CELL2 "CELL2. How many other mobile phone numbers do you have?"
label variable retest "retest after two weeks"
label variable int_length "Interview length"

*------------------------------------------------------------------------------*

order q*, sequential
order respondent_id country language date int_length mode 

drop Operator ContactRecords CELL1 CELL2 retest InterviewerID Interviewlanguage Interviewscore ///
	 q4_1 q4_2 q4_2_1

*------------------------------------------------------------------------------*

* Save data 

save "$data_mc/02 recoded data/input data files/pvs_cn.dta", replace

*------------------------------------------------------------------------------*