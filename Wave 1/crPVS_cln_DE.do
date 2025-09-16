* People's Voice Survey data cleaning for Germany - Wave 1
* Date of last update: September 2025
* Last updated by: S Islam

/*

This file cleans Ipsos data for Germany. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

*********************** GERMANY ***********************

* Import raw data and append together English and German data

use "$data/Germany/01 raw data/German_8.25.2025.dta", clear
tempfile ger_labels
label save using `ger_labels'
label drop _all

tempfile german
save `german'

use "$data/Germany/01 raw data/English_8.25.2025.dta"
tempfile eng_labels
label save using `eng_labels'
label drop _all

tempfile english
save `english'

use `german', clear
gen language = 24001

append using `english'
replace language = 24002 if missing(language)

qui do `ger_labels'

*Label as wave 1 data:
gen wave = 1

*------------------------------------------------------------------------------*
* Rename variables  

rename id respondent_serial
rename (Q1 Q3) (q1 q3)
rename (Q3C Q3D) (q3c_de q3d_de) 
rename (Q4 Q5 Q6 Q7 Q8) (q4 q5 q6 q7 q8)
rename (Q8_14_TEXT Q8A) (q8_other q8a_de)
rename (Q9 Q10 Q11 Q11B Q13) (q9 q10 q11 q11_de q13)
rename (R1_Q12P R2_Q12P) (q12_a q12_b)
rename (Q15 Q15_7_TEXT) (q15 q15_other)
rename (Q16 Q16_11_TEXT) (q16 q16_other)
rename (Q17 Q17B Q17C Q17D) (q17 q17b_de q17c_de q17d_de)
rename (Q18 Q19 Q20 Q21 Q22 Q23) (q18 q19 q20 q21 q22 q23)
rename (Q24 Q24_4_TEXT) (q24 q24_other)
rename (Q25 Q26) (q25 q26)
rename (R1_Q27 R2_Q27 R3_Q27 R4_Q27 R5_Q27 R6_Q27 R7_Q27 R8_Q27 R9_Q27 R10_Q27 R11_Q27) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_de q27j_de q27k_de)
rename (R1_Q28 R2_Q28 R3_Q28 R4_Q28) (q28_a q28_b q28c_de q28d_de)
rename (Q29 Q30 Q30_9_TEXT R1_Q31 R2_Q31) (q29 q30 q30_other q31a q31b)
rename (Q33 Q33_7_TEXT Q34 Q34_4_TEXT) (q33 q33_other q34 q34_other)
rename (Q35 Q36 Q37 Q37_7_TEXT) (q35 q36 q37 q37_other)
rename (R1_Q38 R2_Q38 R3_Q38 R4_Q38 R5_Q38 R6_Q38 R7_Q38 R8_Q38 R9_Q38 R10_Q38 R11_Q38) (q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k)
rename Q39 q39
rename (R1_Q40 R2_Q40 R3_Q40 R4_Q40 R5_Q40 R6_Q40 R7_Q40 R8_Q40 R9_Q40 R10_Q40) (q40_a q40_b q40_c q40_d q40e_de q40f_de q40g_de q40h_de q40i_de q40j_de)
rename (R1_Q41 R2_Q41 R3_Q41 R4_Q41) (q41_a q41_b q41_c q41d_de)
rename (Q42 Q43 Q44 Q45 Q46 Q47 Q48 Q50) (q42 q43 q45 q46 q47 q48 q49 q51)
rename Q49_9_TEXT q50_other


*SI NOTE: responses for q3b_de (citizenship) were extracted from Q3B_1 - Q3B_196. If respondent is a citizen for multiple countries, these are appended as a response and we can discuss how to handle

ds Q3B_*
local countries `r(varlist)'
egen citizenship = rowtotal(`countries') /// Count number of citizenships (Ja == 1)

gen q3b_de = ""

* Loop through each Q3B_* variable and collapse into q3b_de
foreach var of local countries {
    local full_label : variable label `var'
    local dash_pos = strpos("`full_label'", " -")
    local cname = substr("`full_label'", 1, `dash_pos' - 1)
    local cname = strtrim("`cname'")
	
    * If multiple citizenships, append with semicolon
    replace q3b_de = cond(citizenship > 1 & `var' == 1, ///
        q3b_de + cond(q3b_de != "", "; ", "") + "`cname'", ///
        q3b_de)

    * If only 1 citizenship, assign directly from Q3_B* variable
    replace q3b_de = cond(citizenship == 1 & `var' == 1 & q3b_de == "", "`cname'", q3b_de)
}

* New variable: q3a - does respondent have German citizenship? (if yes to Q3B_1)
gen q3a = .
replace q3a = 1 if Q3B_1 == 1
replace q3a = 0 if Q3B_1 == 0
lab def q3a_label 0 "No" 1 "Yes"
lab val q3a q3a_label

* New variable: q3b - Single or multiple citizenship? (based on Q3B_1 - Q3B_196)
gen q3b = .
replace q3b = 1 if citizenship == 1
replace q3b = 2 if citizenship > 1
lab def q3b_label 1 "Single citizenship" 2 "Multiple citizenship"
lab val q3b q3b_label

drop TRP1 TRP2_1 TRP2_2 TRP2_3 TRP2_4 R1_Q12 R2_Q12 citizenship Q3B_* NUMBEROFVISITS Q20MAXVALUE Q3B

*------------------------------------------------------------------------------*
* Generate recoded variables

* Generate variables

gen respondent_id = "DE" + string(respondent_serial)

gen country = 24
lab def country 24 "Germany"
lab values country country

gen mode = 1
lab def mode 1 "CATI"
lab val mode mode

lab def Language 24001 "DE: German" 24002 "DE: English"
lab val language Language

gen q2 = .
replace q2 = 0 if q1 < 18
replace q2 = 1 if q1 >= 18 & q1 <= 29
replace q2 = 2 if q1 >= 30 & q1 <= 39
replace q2 = 3 if q1 >= 40 & q1 <= 49
replace q2 = 4 if q1 >= 50 & q1 <= 59
replace q2 = 5 if q1 >= 60 & q1 <= 69
replace q2 = 6 if q1 >= 70 & q1 <= 79
replace q2 = 7 if q1 >= 80

gen q14_de = .
replace q14_de = 1 if Q14_1 == 1
replace q14_de = 2 if Q14_2 == 1
replace q14_de = 3 if Q14_3 == 1
replace q14_de = 4 if Q14_4 == 1
replace q14_de = 5 if Q14_5 == 1
replace q14_de = 6 if Q14_6 == 1
replace q14_de = .a if Q14_1 == -1 | Q14_2 == -1 | Q14_3 == -1 | Q14_4 == -1 | Q14_6 == -1

rename Q14_5_TEXT q14_other
drop Q14_1 Q14_2 Q14_3 Q14_4 Q14_5 Q14_6

gen q15a_de = .
replace q15a_de = 1 if Q15A_1 == 1
replace q15a_de = 2 if Q15A_2 == 1
replace q15a_de = 3 if Q15A_3 == 1
replace q15a_de = 4 if Q15A_4 == 1
replace q15a_de = 5 if Q15A_5 == 1
replace q15a_de = 6 if Q15A_6 == 1
replace q15a_de = 7 if Q15A_7 == 1

rename Q15A_6_TEXT q15a_de_other
drop Q15A_1 Q15A_2 Q15A_3 Q15A_4 Q15A_5 Q15A_6 Q15A_7

*SI NOTE: vars with _EXCLUSIVE denote "I don't know response" for the previous question
replace q18 = 998 if Q18_EXCLUSIVE == 1
drop Q18_EXCLUSIVE

replace q21 = 998 if Q21_EXCLUSIVE == 1
drop Q21_EXCLUSIVE

replace q22 = 998 if Q22_EXCLUSIVE == 1
drop Q22_EXCLUSIVE

replace q23 = 998 if Q23_EXCLUSIVE == 1
drop Q23_EXCLUSIVE

gen q32_de = .
replace q32_de = 1 if Q32_1 == 1
replace q32_de = 2 if Q32_2 == 1
replace q32_de = 3 if Q32_3 == 1
replace q32_de = 4 if Q32_4 == 1
replace q32_de = 5 if Q32_5 == 1
replace q32_de = 6 if Q32_6 == 1
replace q32_de = .a if Q32_1 == -1 | Q32_2 == -1 | Q32_3 == -1 | Q32_4 == -1 | Q32_6 == -1

rename Q32_5_TEXT q32_other
drop Q32_1 Q32_2 Q32_3 Q32_4 Q32_5 Q32_6


* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

*gen recinterviewer_id = country*1000 + interviewer_id // SI: missing from dataset

gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == .

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == .

gen recq7 = country*1000 + q7
replace recq7 = .r if q7 == .

gen recq8 = country*1000 + q8
replace recq8 = .r if q8 == .

*gen recq50 = country*1000 + q50 
*replace recq50 = .r if q50== 999

gen recq51 = country*1000 + q51
replace recq51 = .r if q51== .
replace recq51 = .d if q51== 998

local q4l labels200
local q5l labels201
local q7l labels203
local q8l labels204
*local q50l labels82
local q51l labels320

foreach q in q4 q5 q7 q8 q51 {
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
		local recvalue`q' = 24000+`: word `i' of ``q'val''
		foreach lev in ``q'level' {
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 24000+`: word `i' of ``q'val'') ///
										(`"DE: `gr`i''"'), modify
			}
		}         
	}
	
	label val rec`q' `q'_label
}

drop q4 q5 q7 q8 q51
ren rec* *

*Recode q50 - Mother's Tongue
egen languages_count = rowtotal(Q49_1 Q49_2 Q49_3 Q49_4 Q49_5 Q49_6 Q49_7 Q49_8 Q49_9) /// How many languages selected

gen q50 = .
replace q50 = 10 if languages_count > 1
replace q50 = 1 if languages_count == 1 & Q49_1 == 1
replace q50 = 2 if languages_count == 1 & Q49_2 == 1
replace q50 = 3 if languages_count == 1 & Q49_3 == 1
replace q50 = 4 if languages_count == 1 & Q49_4 == 1
replace q50 = 5 if languages_count == 1 & Q49_5 == 1
replace q50 = 6 if languages_count == 1 & Q49_6 == 1
replace q50 = 7 if languages_count == 1 & Q49_7 == 1
replace q50 = 8 if languages_count == 1 & Q49_8 == 1
replace q50 = 9 if languages_count == 1 & Q49_9 == 1

* SI Note: keeping the original variables in the dataset for now but renaming
local langs "German Turkish Polish Arabic Italian French Ukrainian Russian Other"

forvalues i = 1/9 {
    local nm : word `i' of `langs'
    rename Q49_`i' language_`nm'
}
drop languages_count
*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

* Converting interview length to minutes
gen int_length = spent_time/60

*date/time pull from start_datetime
gen double datetime = clock(start_datetime, "YMDhms")
format datetime %tc
gen date = dofc(datetime)
format date %tdDDmonCCYY

drop datetime start_datetime end_datetime spent_time
*------------------------------------------------------------------------------*
* Generate variables 

* q18/q19 mid-point var 
*SI: note, q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

*q7 6 = "I don't know"
recode q7 (24006 = .d)

* q14_de 6 = "I don't know"
recode q14_de (6 = .d)

*q15 8 = "I don't know"
recode q15 (8 = .d)

*q18 -1 = "I don't know"
recode q18 (-1 = .d)

*q32_de 6 = "I don't know"
recode q32_de (6 = .d)

*q33 8 = "I don't know"
recode q33 (8 = .d)

*q36 9 = "I don't know"
recode q36 (9 = .d)

*q38a-k 8 = "I don't know"
recode q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k (8 = .d)

* q40a-j 6 = "I am unable to judge" recoded as "don't know"
recode q40_a q40_b q40_c q40_d q40e_de q40f_de q40g_de q40h_de q40i_de q40j_de (6 = .d)

* In raw data, 998 = "don't know"
recode q18 q21 q22 q23 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h ///
	   q27i_de q27j_de q27k_de (998 = .d)

* In raw data, . = "refused"
recode q1 q2 q3 q3c_de q3d_de q4 q5 q6 q7 q8 q8a_de q9 q10 q11 q11_de q12_a q12_b q13 q14_de q15 q15a_de q16 q17 q17b_de q17c_de q17d_de q18 q19 q20 q21 ///
	   q22 q23 q24 q25 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_de q27j_de q27k_de q28_a ///
	   q28_b q28c_de q28d_de q29 q30 q31a q31b q32_de q33 q34 q35 q36 q37 q38_a q38_b q38_c ///
	   q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b q40_c ///
	   q40_d q40e_de q40f_de q40g_de q40h_de q40i_de q40j_de q41_a q41_b q41_c q41d_de q45 q46 q47 q48 q49 q51 (. = .r)
	   
*------------------------------------------------------------------------------*
* Check for implausible values 

* Q17. Overall respondent's rating of the quality received in this facility
* Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)
* Q20. Were all of the visits you made to the same healthcare facility? 
* Q21. How many different healthcare facilities did you go to? 
* Q22. How many visits did you have with a healthcare provider at your home?
* Q23. How many virtual or telemedicine visits did you have?

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
*N = 12 people
replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 6 & visits_total > 0 & visits_total < .
recode q17 (6 = .r) if visits_total > 0 & visits_total < . // N=22 changes

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions
 * These are most likely denoted as -1 for skip pattern in data

*q1/q2 - no missing data

*q3d
recode q3d_de (-1 = .a) if q3c_de != 2

*q7
recode q7 (23999 = .a) if q6 != 1
recode q7 (24004 = .a) if q6 == 1

*q8a
recode q8a_de (-1 = .a) if q8 != 1

*q14-17
recode q14_de q15 q16 q17 (-1 = .a) if q13 !=2
recode q17 (6 = .a)

*q15a_de
recode q15a_de (-1 = .a) if q15 !=3

*q17b-d
recode q17b_de q17c_de q17d_de (-1 = .a) if q13 !=2 | q1 > 19

* NA's for q19-21 
recode q19 (-1 = .a) if q18 != .d | q18 !=.r
recode q19 (-1 = .r) if q18 == .d | q18 == .r
recode q18_q19 (-1 = .r)

recode q20 (-1 = .a) if q18 <1 | q18 == .d | q18 == .r | q19 != 2 | q19 != 3 | q19 != 4

recode q21 (-1 = .a) if q20 !=2 

*q24-q25 
recode q24 q25 (-1 = .a) if q23 == 0  | q23 == .d | q23 == .r

* q27_b q27_c q27j_de
recode q27_b q27_c (-1 = .a) if q3 !=2
recode q27_b q27_c (-1 = .r) if q3 == 2
recode q27j_de (-1 = .a) if q1 < 16 | q1 > 17

*q28
recode q28_a q28_b q28c_de q28d_de (-1 = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 1 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (-1 = .a) if q29 !=1

* q32-39
recode q32_de q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (-1 = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r
recode q36 (-1 = .a) if q35 !=1 
													 
recode q38_e (6 = .a)
recode q38_j (7 = .a)

recode q36 q38_k (. = .a) if q35 !=1	

*q51
recode q51 (23999 = .a) if q1 < 19	
									 
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

*Recode German to English

recode q2 (0 = 0 "Under 18") (1 = 1 "18 to 29") (2 = 2 "30-39") (3 = 3 "40-49") (4 = 4 "50-59") (5 = 5 "60-69") (6 = 6 "70-79") (7 = 7 "80 or older") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q2_label)

rename SAMPLE q2_de
clonevar q2_de_raw = q2_de
recode q2_de (1=2) (2=1) if language == 24001
label define q2_de_label 1 "Main" 2 "Boost", replace
label values q2_de q2_de_label

recode q3 (1 = 0 "Male") (2 = 1 "Female") (3 = 2 "Another gender"), pre(rec) label(gender)

recode q3d_de (1 = 1 "Less than 1 year") (2 = 2 "Between 1 year and 3 years") (3 = 3 "Between 3 years and 10 years") (4 = 4 "More than 10 years") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q3d_de_label)

recode q4 (24001 = 24001 "DE: Baden-Württemberg") (24002 = 24002 "DE: Bavaria (Bayern)") (24003 = 24003 "DE: Berlin") (24004 = 24004 "DE: Brandenburg") ///
(24005 = 24005 "DE: Bremen") (24006 = 24006 "DE: Hamburg") (24007 = 24007 "DE: Hesse (Hessen)") (24008 = 24008 "DE: Lower Saxony (Niedersachsen)") ///
(24009 = 24009 "DE: Mecklenburg-Western Pomerania (Mecklenburg-Vorpommern)") (24010 = 24010 "DE: North Rhine-Westphalia (Nordrhein-Westfalen)") ///
(24011 = 24011 "DE: Rhineland-Palatinate (Rheinland-Pfalz)") (24012 = 24012 "DE: Saarland") (24013 = 24013 "DE: Saxony (Sachsen)") ///
(24014 = 24014 "DE: Saxony-Anhalt (Sachsen-Anhalt)") (24015 = 24015 "DE: Schleswig-Holstein") (24016 = 24016 "DE: Thuringia (Thüringen)") ///
(.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q4_label)

recode q5 (24001 = 24001 "DE: City") (24002 = 24002 "DE: Suburb of city") (24003 = 24003 "DE: Small town") (24004 = 24004 "DE: Rural area/Dorf") (.r = .r "Refused") (.a = .a "NA"), ///
pre(rec) label(q5_label)

recode q7 (24001 = 24001 "DE: Statutory health insurance – (Gesetzliche Krankenversicherung or GKV)") (24002 = 24002 "DE: Private health insurance (Private Krankenversicherung or PKV) - This does not refer to private supplementary insurance to statutory health insurance") ///
(24003 = 24003 "DE: Other entitlement to health care, e.g. foreign health insurance") (24004 = 24004 "DE: No health insurance, self-payer using cash or card") ///
(24005 = 24005 "DE: Other (specify)") (.a = .a "NA" ) (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q7_label)

recode q8 (24001 = 24001 "DE: University or university of applied sciences degree") (24002 = 24002 "DE: Mastercraftsman (meister), technician or equivalent technical college qualification") (24003 = 24003 "DE: Graduation from a school for educators") ///
(24004 = 24004 "DE: Training at a school/academy for health and social professions") (24005 = 24005 "DE: Preparatory service for the intermediate civil service in public administration") (24006 = 24006 "DE: Apprenticeship or vocational training in the dual system completed") ///
(24007 = 24007 "DE: Apprenticeship/vocational internship, vocational preparation year") (24008 = 24008 "DE: A-levels (abitur)") ///
(24009 = 24009 "DE: Advanced technical college entrance qualification (fachhochschulreife)") (24010 = 24010 "DE: Secondary school leaving completed (mittlerer schulabschluss)") (24011 = 24011 "DE: Secondary school leaving completed (hauptschulabschluss)") (24012 = 24012 "DE: None of the mentioned school certificates, I am still a pupil") (24013 = 24013 "DE: Never attended school or only kindergarten") (24014 = 24014 "DE: Other (please specify)"), pre(rec) label(q8_label)

recode q8a_de (1 = 1 "Bachelor's degree") (2 = 2 "Master's degree") (3 = 3 "Diplom, Magister, state examination or teacher training examination") ///
(4 = 4 "Doctorate") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q8a_de_label)

recode q9 q10 (5 = 0 "Poor") (4 = 1 "Fair") (3 = 2 "Good") (2 = 3 "Very good") (1 = 4 "Excellent") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(q9q10_label)

recode q12_a q12_b (4 = 0 "Not at all confident") (3 = 1 "Not too confident") (2 = 2 "Somewhat confident") (1 = 3 "Very confident"), pre(rec) label(q12_label)

lab def q14_de_label 1 "Statutory Health Insurance (Gesetzliche Krankenversicherung or GKV)" 2 "Private Health Insurance (Private Krankenversicherung or PKV)" ///
3 "Supplementary Health Insurance (for dental insurance or alternative medicine, for instance)" 4 "No health insurance, self-payer using cash or card" 5 "Other (specify)" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q14_de q14_de_label

replace q15 = country*1000 + q15 if q15 != .a & q15 != .d & q15 != .r
lab def q15_label 24001 "DE: Medical doctor's office" 24002 "DE: Psychotherapy office" 24003 "DE: Alternative provider's office, including homeopathic, osteopathic, or other" ///
24004 "DE: Urgent care clinic (ambulatory medical services performed without admission to a hospital)" 24005 "DE: Hospital emergency room" 24006 "DE: Hospital outpatient department" 24007 "DE: Other (specify)" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q15 q15_label

lab def q15a_de_label 1 "Medical doctor's office" 2 "Psychotherapy office" 3 "Urgent care clinic (ambulatory medical services performed without admission to a hospital)" 4 "Hospital emergency room" 5 "Hospital outpatient department" ///
6 "Other (specify)" 7 "I don't use any of the above-mentioned health services routinely" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q15a_de q15a_de_label

recode q16 (1 = 1 "Low cost") (2 = 2 "Short distance") (3 = 3 "Short waiting time") (4 = 4 "Good healthcare provider skills") ///
(5 = 5 "Staff shows respect") (6 = 6 "Medicines and equipment are available") (7 = 7 "Only facility available") (8 = 8 "Covered by insurance") ///
(9 = 17 "DE: My parents chose this doctor's office or health care facility for me") (10 = 18 "DE: This doctor's office or health care facility is child-friendly/youth-friendly") (11 = 9 "Other, specify") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(q16_label)

recode q19 (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q19_label)

recode q24 (1 = 1 "Care for an urgent or new health problem such as an accident or injury or a new symptom like fever, pain, diarrhea, or depression.") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease such as hypertension or diabetes. This may include mental health conditions.") ///
		   (3 = 3 "Preventive care or a visit to check on your health, such as an annual check-up, antenatal care, or vaccination.")  ///
		   (4 = 4 "Other (specify)") (.r = .r "Refused") (.a = .a "NA") ///
		   (.d = .d "Don't know"), pre(rec) label(q24_label)
		   
recode q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_de q27j_de q27k_de (1 = 0 "No") (2 = 1 "Yes") ///
(.a = .a "NA") (3 = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q27_label)

recode q28_a q28_b q28c_de q28d_de (2 = 0 "No") (1 = 1 "Yes") (.r = .r "Refused") ///
(.a = .a "NA") (3 = .d "Don't know"), pre(rec) label(q28_label)
		   
recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") ///
		   (8 = 23 "DE: Difficulties with the language spoken by the healthcare provider") ///
		   (9 = 10 "Other (specify)") ///
		   (8 = 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)") ///
		   (9 = 9 "COVID-19 fear") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q30_label)
		   
lab def q32_de_label 1 "Statutory Health Insurance (Gesetzliche Krankenversicherung or GKV)" 2 "Private Health Insurance (Private Krankenversicherung or PKV)" ///
3 "Supplementary Health Insurance (for dental insurance or alternative medicine, for instance)" 4 "No health insurance, self-payer using cash or card" 5 "Other (specify)" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q32_de q32_de_label

replace q33 = country*1000 + q33 if q33 != .a & q33 != .d & q33 != .r
lab def q33_label 24001 "DE: Medical doctor's office" 24002 "DE: Psychotherapy office" 24003 "DE: Alternative provider's office, including homeopathic, osteopathic, or other" ///
24004 "DE: Urgent care clinic (ambulatory medical services performed without admission to a hospital)" 24005 "DE: Hospital emergency room" 24006 "DE: Hospital outpatient department" 24007 "DE: Other (specify)" ///
.a "NA" .r "Refused" .d "Don't know"
lab val q33 q33_label

recode q34 (1 = 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)") ///
		   (3 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") /// 
		   (4 = 4 "Other (specify)") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q34_label)
		   
recode q35 (2 = 0 "No, I did not have an appointment") (1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
(.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q35_label)

recode q36 (1 = 1 "Same or next day") (2 = 2 "2 days to less than one week") (3 = 3 "1 week to less than 2 weeks") ///
(4 = 4 "2 weeks to less than 1 month") (5 = 5 "1 month to less than 2 months") (6 = 6 "2 months to less than 3 months") ///
(7 = 7 "3 months to less than 6 months") (8 = 8 "6 months or more") (.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), ///
pre(rec) label(q36_label)

recode q37 (1 = 1 "Less than 15 minutes") (2 = 2 "15 minutes to less than 30 minutes") (3 = 3 "30 minutes to less than 1 hour") ///
(4 = 4 "1 hour to less than 2 hours") (5 = 5 "2 hours to less than 3 hours") (6 = 6 "3 hours to less than 4 hours") ///
(7 = 7 "More than 4 hours (specify)") (.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q37_label)

recode q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k (5 = 0 "Poor") (4 = 1 "Fair") (3 = 2 "Good") (2 = 3 "Very good") (1 = 4 "Excellent") ///
(.d = .d "Don't know") (.a = .a "NA") (.r = .r "Refused"), pre(rec) label(q38_label)

recode q39 (1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") (7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
(.d = .d "Don't know") (.a = .a "NA") (.r = .r "Refused"), pre(rec) label(q39_label)

recode q41_a q41_b q41_c q41d_de (4 = 0 "Not at all confident") (3 = 1 "Not too confident") (2 = 2 "Somewhat confident") (1 = 3 "Very confident") ///
(.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q41_label)
		   
recode q45 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	
recode q46 ///
	(1 = 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it.") ///
	(2 = 2 "There are some good things in our healthcare system, but major changes are needed to make it work better.") ///
	(3 = 3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better.") ///
	(.r = .r "Refused") , pre(rec) label(q46_label)
	
replace q50 = country*1000 + q50
lab def q50_label 24001 "DE: German" 24002 "DE: Turkish" 24003 "DE: Polish" 24004 "DE: Arabic" 24005 "DE: Italian" 24006 "DE: French" ///
24007 "DE: Ukranian" 24008 "DE: Russian" 24009 "DE: Other (specify)" 24010 "DE: More than one language" .a "NA" .r "Refused" .d "Don't know"
lab val q50 q50_label

replace q51 = .r if q51 == 24000
recode q51 ///
	(24001 = 24001 "DE: Less than €500") (24002 = 24002 "DE: €500 to less than €1,000") (24003 = 24003 "DE: €1,000 to less than €2,000") ///
	(24004 = 24004 "DE: €2,000 to less than €4,000") (24005 = 24005 "DE: €4,000 to less than €6,000") (24006 = 24006 "DE: €6,000 to less than €8,000") ///
	(24007 = 24007 "DE: €8,000 to less than €10,000") (24008 = 24008 "DE: €10,000 to less than €18,000") (24009 = 24009 "DE: More than €18,000") ///
	(.d = .d "Don't know") (.a = .a "NA") (.r = .r "Refused"), pre(rec) label(q51_label)
	
* Original language variables
recode language_German language_Turkish language_Polish language_Arabic language_Italian language_French language_Ukrainian language_Russian language_Other (0 = 0 "No") (1 = 1 "Yes") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(languages_label)

* Recoding all yes/no qs together
recode q3c_de q6 q11 q11_de q20 q26 q29 q31a q31b (2 = 0 "No") (1 = 1 "Yes") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(yesno)

*SI Note: these scales were different from the other yes/no questions so created a new label
recode q13 q17b_de q17c_de q17d_de (1 = 0 "No") (2 = 1 "Yes") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(yesno2)

* Recoding all poor-excellent rating qs together
recode q17 q25 q40_a q40_b q40_c q40_d q40e_de q40f_de q40g_de q40h_de q40i_de q40j_de q42 q43 q47 q48 q49 ///
(5 = 0 "Poor") (4 = 1 "Fair") (3 = 2 "Good") (2 = 3 "Very good") (1 = 4 "Excellent") ///
(.d = .d "Don't know") (.a = .a "NA") (.r = .r "Refused"), pre(rec) label(rating)
	
drop q2 q2_de_raw q3 q3c_de q3d_de q4 q5 q6 q7 q8 q8a_de q9 q10 q12_a q12_b q16 q19 q24 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_de q27j_de q27k_de ///
q28_a q28_b q28c_de q28d_de q30 q34 q35 q36 q37 q39 q41_a q41_b q41_c q41d_de q45 q46 q51 q11 q11_de q13 q20 q26 q29 q31a q31b q17 q17b_de q17c_de q17d_de q25 ///
q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q40_a q40_b q40_c q40_d q40e_de q40f_de q40g_de q40h_de q40i_de q40j_de q42 q43 q47 q48 q49 language_German language_Turkish language_Polish language_Arabic language_Italian language_French language_Ukrainian language_Russian language_Other

ren rec* *

*******************************************************************************

* all vars missing labels from values:
label define gender .a "NA" .d "Don't know" .r "Refused",add		
label define q6_label .a "NA" .d "Don't know" .r "Refused",add	
label define q8_label .a "NA" .d "Don't know" .r "Refused",add	
label define q12_label .a "NA" .d "Don't know" .r "Refused",add

* for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
label copy q50_label q50_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label q33_label q50_label q51_label
*------------------------------------------------------------------------------*
* Create Sampling Weights

*********************************************************Dataset Sample Size:
tab country // N=2698 completed surveys

*********************************************************Create demographic variables that align with the census variables:
** Gender
gen gender = 1 if q3==0
replace gender = 2 if q3==1
label define gender_lbl 1 "Male" 2 "Female"
label values gender gender_lbl
tab gender, m // 0 missing


** Age (4 levels)
* Based on 2022 Germany Census:
* Under 18 years = under 18 (0)
* 18 - 29 = 18 to 29 (1)
* 30 - 49 = 30 - 39 (2), 40 - 49 (3)
* 50 or more = 50 - 59 (4), 60 - 69 (5), 70-79 (6), 80 or older (7)
gen age = 1 if q2==0
replace age = 2 if q2==1
replace age = 3 if q2==2|q2==3
replace age = 4 if q2==4| q2==5 | q2==6 | q2==7
label define age 1 "Under 18" 2 "18-29" 3 "30 - 49" 4 "50+"
label values age age
tab age, m // 0 missing

/*
** Age (8 levels)
* Based on 2022 Germany Census:
* Under 18 years = under 18 (0)
* 18 - 29 = 18 to 29 (1)
* 30 - 39 = 30 - 39 (2)
* 40 - 49 = 40 - 49 (3)
* 50 - 59 = 50 - 59 (4)
* 60 - 69 = 60 - 69 (5)
* 70 - 79 = 70 - 79 (6)
* 80+ = 80 or older (7)
gen age = 1 if q2==0
replace age = 2 if q2==1
replace age = 3 if q2==2
replace age = 4 if q2==3
replace age = 5 if q2==4
replace age = 6 if q2==5
replace age = 7 if q2==6
replace age = 8 if q2==7
label define age 1 "Under 18" 2 "18-29" 3 "30 - 39" 4 "40-49" 5 "50-59" 6 "60-69" 7 "70-79" 8 "80+"
label values age age
tab age, m // 0 missing
*/

** Region (16 levels)
* Based on 2022 Germany Census:
gen Region = 1 if q4==24015
replace Region = 2 if q4==24006
replace Region = 3 if q4==24008
replace Region = 4 if q4==24005
replace Region = 5 if q4==24010
replace Region = 6 if q4==24007
replace Region = 7 if q4==24011
replace Region = 8 if q4==24001
replace Region = 9 if q4==24002
replace Region = 10 if q4==24012
replace Region = 11 if q4==24003
replace Region = 12 if q4==24004
replace Region = 13 if q4==24009
replace Region = 14 if q4==24013
replace Region = 15 if q4==24014
replace Region = 16 if q4==24016
label define Region 1 "Schleswig-Holstein" 2 "Hamburg" 3 "Niedersachsen" 4 "Bremen" 5 "Nordrhein-Westfalen" 6 "Hessen" 7 "Rheinland-Pfalz" 8 "Baden-Württemberg" 9 "Bayern" 10 "Saarland" 11 "Berlin" 12 "Brandenburg" 13 "Mecklenburg-Vorpommern" 14 "Sachsen" 15 "Sachsen-Anhalt" 16 "Thüringen"
label values Region Region
tab Region, m // 1 Refused


** Education (3 levels)
* Based on 2022 Germany Census:
* ISCED 1 (24012, 24013)
* ISCED 2 + 3 (24008, 24009, 24010, 24011)
* ISCED 4 + (24001, 24002, 24003, 24004, 24005, 24006, 24007)

gen education = .
replace education = 1 if q8==24012 | q8==24013
replace education = 2 if q8==24008| q8==24009 | q8==24010 | q8==24011
replace education = 3 if q8==24001| q8==24002| q8==24003| q8==24004 |q8==24005| q8==24006| q8==24007
label define education 1 "Primary or less" 2 "Secondary" 3 "Tertiary"
label values education education 
tab education, m // 0 missing


*********************************************************After testing, we choose age (4 levels),gender,region,education (3 levels):
ipfweight age gender Region education, gen(wgt) ///
			val(16.7 12.9 25.2 45.1 /// age (4 levels)
			 49.2 50.8 /// gender
			 3.5 2.2 9.6 0.8 21.6 7.5 4.9 13.4 15.8 1.2 4.3 3.1 1.9 4.9 2.6 2.6 /// region
			 6.8 47.9 45.5) /// education
			maxit(50) // max deviation =  percentage points
		


** Just try to keep data set clean, drop all the variables created above, except wgt
drop gender age Region education
rename wgt weight
*------------------------------------------------------------------------------*
*Reorder variables
order q*, sequential
order respondent_serial respondent_id date int_length mode country wave language weight

*------------------------------------------------------------------------------*

/* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other"

gen q14_other_original = q14_other
label var q14_other_original "Q14_other. Other"
	
gen q15_other_original = q15_other
label var q15_other_original "Q15. Other"

gen q16_other_original = q16_other
label var q16_other_original "Q16. Other"

gen q24_other_original = q24_other
label var q24_other_original "Q24. Other"

gen q30_other_original = q30_other
label var q30_other_original "Q30. Other"

gen q32_other_original = q32_other
label var q32_other_original "Q32. Other"

gen q33_other_original = q33_other
label var q33_other_original "Q33. Other"
	
gen q34_other_original = q34_other
label var q34_other_original "Q34. Other"	

gen q50_other_original = q50_other
label var q50_other_original "Q50. Other"	


foreach i in 3 4 5 9 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q14_other q15_other q16_other q24_other q30_other q32_other ///
	 q33_other q34_other q50_other
	 
ren q7_other_original q7_other
ren q14_other_original q14_other
ren q15_other_original q15_other
ren q16_other_original q16_other
ren q24_other_original q24_other
ren q30_other_original q30_other
ren q32_other_original q32_other
ren q33_other_original q33_other
ren q34_other_original q34_other
ren q50_other_original q50_other

order q*, sequential
order respondent_serial respondent_id mode country language date time int_length weight_educ

*------------------------------------------------------------------------------*/

*------------------------------------------------------------------------------*
* Label variables - double check matches the instrument					
lab var country "Country"
lab var respondent_serial "Respondent Serial #"
lab var respondent_id "Respondent ID"
lab var wave "Wave"
lab var language "Language"
lab var date "Date of the interview"
lab var int_length "Interview Length (minutes)"
lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q2_de "Q2. DE only: Sample"
lab var q3 "Q3. Respondent's gender"
lab var q3a "Q3a. Does respondent have German citizenship?"
lab var q3b "Q3b. Does respondent have single or multiple citizenship?"
lab var q3b_de "Q3b_de. DE only: Country of citizenship"
lab var q3c_de "Q3c_de. DE only: Were you born in Germany?"
lab var q3d_de "Q3d_de. DE only: How long have you lived in Germany in total?"
lab var q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you most frequently use?"
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q8_other "Q8. Other"
lab var q8a_de "Q8a_de. DE only: What is the title of your highest degree?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q11_de "Q11_de. DE only: Are you currently pregnant or have you given birth in the past 12 months?"
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?"
lab var q14_de "Q14. DE only: When receiving health services from this doctor's office or other health care facility, which of the following do you typically use to cover the costs?"
lab var q14_other "Q14. Other"
lab var q15 "Q15. What type of healthcare facility is this?"
lab var q15_other "Q15. Other"
lab var q15a_de "Q15a. DE only: In addition to the health care facility you mentioned, do you use one of the following for care?"
lab var q15a_de_other "Q15a. Other"
label var q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
lab var q16_other "Q16. Other"
label var q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label var q17b_de "Q17b. DE only: In the past 12 months, have you ever spoken with a medical doctor or any other health care provider in private without your parents?"
label var q17c_de "Q17c. DE only: Is there any doctor, nurse, or other health professional with whom you are comfortable talking about your sexual health or contraception?"
label var q17d_de "Q17d. DE only: Is there any doctor, nurse, or other health professional with whom you are comfortable speaking about your mental health?"
label var q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label var q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label var q20 "Q20. Were all of the visits you made to the same healthcare facility?"
label var q21 "Q21. How many different healthcare facilities did you go to in total?"
label var q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label var q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label var q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
label var q24_other "Q24. Other"
label var q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label var q26 "Q26. Stayed overnight at a facility in past 12 months (inpatient care)"
label var q27_a "Q27a. Blood pressure tested in the past 12 months"
label var q27_b "Q27b. Breast examination"
label var q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label var q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label var q27_e "Q27e. Had your teeth checked in the past 12 months"
label var q27_f "Q27f. Had a blood sugar test in the past 12 months"
label var q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label var q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label var q27i_de "Q27i. DE only: Had a colorectal cancer screening to detect bowel cancer"
label var q27j_de "Q27j. DE only: Had a J2 checkup (an additional preventive check-up for adolescents)"
label var q27k_de "Q27k. DE only: Received any counseling on contraception/birth control"
label var q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label var q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label var q28c_de "Q28c. DE only: Had the impression that your privacy was not adequately protected during treatment or consultation"
label var q28d_de "Q28d. DE only: Received treatment without feeling sufficiently informed about it"
label var q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label var q30 "Q30. The last time this happened, what was the main reason you did not receive healthcare?"
label var q30_other "Q30. Other"
label var q31a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label var q31b "Q31b. Sell items to pay for healthcare"
label var q32_de "Q32. DE only: In your most recent visit, which of the following did you use to cover the costs of the treatment or consultation?"
label var q32_other "Q32. Other"
label var q33 "Q33. What type of healthcare facility is this?"
label var q33_other "Q33. Other"
label var q34 "Q34. What was the main reason you went?"
label var q34_other "Q34. Other"
label var q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label var q36 "Q36. How long did you wait between making the appointment and seeing the health care provider?"
label var q37 "Q37. Approximately how long did you wait before seeing the provider?"
label var q37_other "Q37. Specify"
label var q38_a "Q38a. How would you rate the overall quality of care you received?"
label var q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
label var q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
label var q38_d "Q38d. How would you rate the level of respect your provider showed you?"
label var q38_e "Q38e. How would you rate your provider knowledge about your prior visits and test results?"
label var q38_f "Q38f. How would you rate whether your provider explained things clearly?"
label var q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
label var q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
label var q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
label var q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
label var q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
label var q39 "Q39. How likely would recommend this facility to a friend or family member?"
label var q40_a "Q40a. How would you rate the quality of care during pregnancy and childbirth like antenatal care, postnatal care"
label var q40_b "Q40b. How would you rate the quality of childcare such as care of healthy children and treatment of sick children"
label var q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label var q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label var q40e_de "Q40e. DE only: How would you rate the quality of care in the area of sexual health or contraception?"
label var q40f_de "Q40f. DE only: How would you rate the quality of care provided for dental care?"
label var q40g_de "Q40g. DE only: How would you rate the quality of care provided for preventive cancer care?"
label var q40h_de "Q40h. DE only: How would you rate the quality of care provided for rehabilitative care?"
label var q40i_de "Q40i. DE only: How would you rate the quality of care provided for nursing care such as home nursing care or care for the elderly?"
label var q40j_de "Q40j. DE only: How would you rate the quality of care provided for preventive care, for example, vaccinations?"
label var q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label var q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label var q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label var q41d_de "Q41d. DE only: How confident are you that the health care system addresses the needs of your age group, e.g., by clarifying contraceptive methods available to women of reproductive age?"
label var q42 "Q42. How would you rate the quality of government or public healthcare system in your country?"
label var q43 "Q43. How would you rate the quality of the private for-profit healthcare system in your country?"
label var q45 "Q45. Is your country's health system is getting better, staying the same or getting worse?"
label var q46 "Q46. Which of these statements do you agree with the most?"
label var q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label var q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label var q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label var q50 "Q50. What is your native language or mother tongue?"
label var q50_other "Q50. Other"
label var q51 "Q51. Total monthly household income"

*------------------------------------------------------------------------------*
* Save data

save "$data_mc/02 recoded data/input data files/pvs_de", replace

*------------------------------------------------------------------------------*

