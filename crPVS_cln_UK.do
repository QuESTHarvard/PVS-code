* People's Voice Survey data cleaning for United Kingdom
* Last updated: April 2023
* N. Kapoor, S. Sabwa, M. Yu

/*

This file cleans SSRS data for UK.
 
Cleaning includes:
	- Recoding implausible values 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

******************************** United Kingdom ************************************
* Import data 
import spss using "$data/United Kingdom/01 raw data/HSPH Health Systems Survey_UK Final_04142023.sav", clear

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

* Rename all variables, and some recoding if variable will be dropped 
ren Respondent_Serial respondent_serial
ren Surveymode mode
ren Q1_1 q1
ren Q1_3UK q5
ren Q1_4 q3 
ren Q1_5 q4 
*Neena/Todd confirmed using more granular race question and dropping Q1_6UK
ren Q1_6R q62_uk
ren Q1_9UK q6_uk
ren Q1_11 q8
ren Q1_12 q9
ren Q1_13 q10
ren Q1_14 q11
ren Q1_19_A q16
ren Q1_19_B q17
ren Q1_17 q14
ren Q1_18 q15
ren Q1_15 q12
ren Q1_16 q13
ren Q2_1 q18
ren Q2_2UK q19a_uk
ren Q2_UK_3 q19_other_uk
ren Q2_2NI q19b_uk
ren Q2_3 q20
ren Q2_4 q21
ren Q2_4_9 q21_other
ren Q2_5 q22
ren Q2_6 q23
ren Q2_7 q24
ren Q2_8a q25_a
ren Q2_8b q25_b
ren Q2_9 q26
ren Q2_10 q27 
ren Q2_11 q28_b 
lab var q28_b "q2_11 How many virtual or telemedicine visits did you have?"
ren Q2_11b q28_c 
ren Q2_12 q29
ren Q2_13_A q30
ren Q2_13_B q31
ren Q2_13_C q32
ren Q2_13_D q33
ren Q2_13_E q34
ren Q2_13_F q35
ren Q2_13_G q36
ren Q2_13_H q38
ren Q2_21_A q39
ren Q2_21_B q40
ren Q2_23 q41
ren Q2_24 q42
ren Q2_24_10 q42_other
ren Q3_1UK q43a_uk
ren Q3_1UK_3 q43_other_uk
ren Q3_1NI q43b_uk
ren Q3_2UK q44
ren Q3_3 q45
ren Q3_3_4 q45_other
ren Q3_4a q46a 
ren Q3_4B_1X q46b_hrs
ren Q3_4B_2X q46b_dys
ren Q3_4B_3X q46b_wks
ren Q3_4B_4X q46b_mth
ren Q3_4_1X q46_hrs
ren Q3_4_2X q46_min
ren Q3_5_1X q47_hrs
ren Q3_5_2X q47_min
ren Q3_4B_999 q46b_refused
ren Q3_4_999 q46_refused 
ren Q3_5_999 q47_refused 
ren Q3_6_A q48_a
ren Q3_6_B q48_b
ren Q3_6_C q48_c
ren Q3_6_D q48_d
ren Q3_6_E q48_e
ren Q3_6_F q48_f
ren Q3_6_G q48_g
ren Q3_6_H q48_h
ren Q3_6_I q48_i
ren Q3_6_J q48_j
ren Q3_6_K q48_k 
ren Q3_7 q49
ren Q4_1_A q50_a
ren Q4_1_B q50_b
ren Q4_1_C q50_c
ren Q4_1_D q50_d
ren Q4_2_A q51
ren Q4_2_B q52
ren Q4_2_C q53
ren Q4_5UK q54
ren Q4_6 q55
ren Q4_8 q57
ren Q4_9 q58
ren Q4_10 q59
ren Q4_11 q60
ren Q4_12 q61
ren Q4_14 q63
ren Q4_13 q66_uk 

ren weight weight_educ 
* 4/19: Mia added.
gen int_length = PV27_LengthInSeconds / 60
gen reclanguage = 17001
lab def lang 17001 "UK: English" 
lab values reclanguage lang

generate double start_time = dofc(DataCollection_FinishTime)
format start_time %tdD_M_CY
generate double end_time = dofc(DataCollection_StartTime)
format end_time %tdD_M_CY

clonevar date = end_time
recast long date

order q*, sequential
order respondent_serial mode weight_educ //dropped lang country

gen reccountry = 17
lab def country 17 "United Kingdom"

/*
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 999
gen reclanguage = reccountry*1000 + lang 
recode reclanguage (15058 = 13058)
*/

*gen interviewer_id = country*1000 + interviewerid_recoded //no interview id related var in the dataset
* only q4 since others are country specific
gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 999
gen recq5 = reccountry*1000 + q5
replace recq5 = .r if q5 == 999
gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8 == 999
gen recq20 = reccountry*1000 + q20
replace recq20 = .r if q20 == 999
gen recq44 = reccountry*1000 + q44
replace recq44 = .r if q44 == 999
gen recq63 = reccountry*1000 + q63
replace recq63 = .r if q63 == 999

* Mia changed this part
local q4l labels5
local q5l labels3
local q8l labels9
local q20l labels25
local q44l labels52
local q63l labels85

foreach q in q4 q5 q8 q20 q44 q63{
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
		local recvalue`q' = 17000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 17000+`: word `i' of ``q'val'') ///
									    (`"UK: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

label define q8_label .a "NA" .r "Refused" , modify
label define q20_label .a "NA" .r "Refused" , modify
label define q44_label .a "NA" .r "Refused" , modify
label define q62_label .a "NA" .r "Refused" , modify
label define q63_label .a "NA" .r "Refused" , modify
label define labels87 .a "NA" .r "Refused" , modify

*****************************

**** Combining/recoding some variables ****

* Q46, Q47 
recode q46_min q46_hrs (. = 0) if q46_min < . | ///
								  q46_hrs < . 
recode q47_min q47_hrs (. = 0) if q47_min < . | ///
								  q47_hrs < . 
gen q46 = q46_hrs*60 + q46_min
recode q46 (. = .r) if q46_refused == 1
gen q47 = q47_hrs*60 + q47_min
recode q47 (. = .r) if q47_refused == 1

recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .
*****************************

* Q46a, Q46b 
recode q46b_dys q46b_hrs q46b_mth q46b_wks (. = 0) if q46b_dys < . | ///
														  q46b_hrs < . | ///
														  q46b_mth < . | ///
														  q46b_wks < . 
gen q46b = (q46b_hrs/24) + q46b_dys + (q46b_wks*7) + (q46b_mth*30)
recode q46b (. = .r) if q46b_refused == 1 
recode q46b_refused (. = 0) if q46b != . //4/18: Mia added. Add this to IT_MX_US to?

*------------------------------------------------------------------------------*

* Drop unused variables 

drop NUMOFCHILDREN Q1_7B* CHILD*AGE DataCollection_FinishTime DataCollection_StartTime ///
     Q1_6UK Q1_21_A Q1_21_B Q1_21_C Q2_25 Q2_28 Q2_27 Q2_26 Q2_29 Q2_30_A Q2_30_B Q2_31 ///
	 Q3_4B_1 Q3_4B_2 Q3_4B_3 Q3_4B_4 Q3_4_1 Q3_4_2 Q3_5_1 Q3_5_2 ///
     q46_min q46_hrs q47_min q47_hrs ///
	 q46b_dys q46b_hrs q46b_mth q46b_wks start_time end_time strata ///
	 PV27_DataCollectionDate PV27_LengthInSeconds CS_WorkingStatus KANTARDEVICE PV27_LengthInMinutes PV27_Mode //4/18: Mia added

	 
* FLAG:
* Variables in our appended dataset that we need from this data (if avaialble)
* q64 (do you have more than one phone),
* q65 (if so how many phone numbers)
* And potentially a time of interview variable (currently drop this in appended dataset, but may add back)	 
	 
*------------------------------------------------------------------------------*

* Generate variables 
gen respondent_id = "UK" + string(respondent_serial)

gen q2 = .a
gen q28_a = .a 
gen q62 = .a // asked differently 
gen q64 = .a 
gen q65 = .a

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (999 = 0) (998 = 0) if q24 == 1
recode q23_q24 (999 = 2.5) (998 = 2.5) if q24 == 2
recode q23_q24 (999 = 7) (998 = 7) if q24 == 3
recode q23_q24 (999 = 10) (998 = 10) if q24 == 4
recode q23_q24 (998 = 999) if q24 == 999

*------------------------------------------------------------------------------*
* Refused values / Don't know values

* In raw data, 998 = "don't know" 
recode q23 q25_a q25_b q27 q28_b q30 q31 q32 q33 q34 q35 q36 q38 q63 ///
	   (998 = .d) // * FLAG - potentially no don't know response option in q25_a, q27, q63, There were don't know options for these questions in other countries 

* In raw data, 999 = "refused" 
recode q1 q3 q5 q6_uk q8 q9 q10 q11 q12 ///
	   q13 q14 q15 q16 q17 q18 q19a_uk q19b_uk q20 q21 q22 ///
	   q23 q24 q23_q24 q25_a q25_b q26 q27 q28_b q28_c q29 q30 q31 q32 q33 ///
	   q34 q35 q36 q38 q39 q40 q41 q42 q43a_uk q43b_uk q44 ///
	   q45 q46* q47 q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
	   q57 q58 q59 q60 q61 q62_uk q63 q66_uk (999 = .r)	
	  
*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*------------------------------------------------------------------------------*
	 
* Check for implausible values 
list q23_q24 q25_b if q25_b > q23_q24 & q25_b < . 
* Note: okay in these data

list q23_q24 q27 if q27 > q23_q24 & q27 < . 
* Note: okay in these data

* Some implasuible values of 0 and 1
* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
list q26 q27 if q27 == 0 | q27 == 1
* Note: okay in these data	 

* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28_b) //used q23_q24 and q28_b only since there's no q28_a

* list if they said "I did not get healthcare in the past 12 months" but has a visit
list visits_total q39 q40 if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
							   
* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* total of 20 changes made to q39 and 13 changes made to q40 

* list if it is .a but they have visit values in past 12 months 
list visits_total q39 q40 if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* this is fine
							  
* list if they chose other than "I did not get healthcare in past 12 months" but visits_total == 0 
list visits_total q39 q40 if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 120 changes made to q39, 116 changes made to q40
* 3 people left (all visits total ==0): 2 refused both q39 and q40, one person said they didn't have visits in 12months and refused q40

drop visits_total

*------------------------------------------------------------------------------*
* 4/18 Mia add this
list q1 if q1 < 18

recode q1 (0 = .r) 

* q13 
recode q13 (. = .a) if q12 == 2  | q12==.r

* q15 - No skip pattern everyone was asked q14 and q15 
* recode q15 (. = .a) if q14 == 3 | q14 == 4 | q14 == 5 | q14 == .r 

*q19-22
recode q19a_uk q19b_uk q20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 

* 4/18 Mia add this
recode q19a_uk (. = .a) if q5 == 12
recode q19b_uk (. = .a) if q5 != 12

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r
recode q25_a (. = .a) if q23 != 1
recode q25_b q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r
recode q27 (. = .a) if q26 == 1 | q26 == .r | q26 == .a

*q28_c
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r

* q31 & q32
* Mia added q1 == .r 
recode q31 (. = .a) if q3 != 2 | q1 == .r 
recode q32 (. = .a) if q3 != 2 | q1 == .r

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43a_uk q43b_uk q44 q45 q46 q46_refused q46a ///
	   q46b q46b_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r 

* 4/18 Mia add this
recode q43a_uk (. = .a) if q5 == 12
recode q43b_uk (. = .a) if q5 != 12

recode q48_k (. = .a) if q46a == 2 | q46a == .r

recode q46b q46b_refused (. = .a) if q46a == 2 | q46a == .r

*q64/q65 - are there variarbles on number of phone numbers? 

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q11 q12 q13 q18 q25_a q26 q29 q41 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

lab val q46_refused q47_refused yes_no

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (3 .d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
recode q46a ///
		(1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
		(2 = 0 " No, I did not have an appointment") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_appt)

recode q46b_refused ///
		(1 = 1 "Yes") ///
		(0 = 0 " No") ///
		(.a = .a "NA") ///
		, pre(rec) label(yes_no)		
		
recode q6_uk ///
		(1 = 1 "Yes, have private insurance") ///
		(2 = 0 "No, do not have private insurance") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_ins)		
		
* All Excellent to Poor scales

recode q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54 ///
	   q55 q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
* NOTE: "I had no prior tests or visits" was not an option - was the skip pattern different? 
* 		Can move q48_e to above recode if so
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)	   
	   
* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options
	   
recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (3 = .d "Not sure") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

* q49 - no recode needed 
	
recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b q46 q46b q47 na_rf	
	
	
******* Country-specific *******
* Mode 
*UK specific: category 2 is "CATI (CAWI to CATI)"
recode mode (2 3 = 1) (1 = 4)
lab def mode 1 "CATI" 4 "CAWI"
lab val mode mode
	
recode q6_uk (1 = 1 "Additional private insurance") ///
			 (2 = 2 "Only public insurance") ///
			 (.a = .a "NA") (.r = .r "Refused"), gen(q7_uk) lab(q7_uk_label)

gen recq7 = reccountry*1000 + q7_uk
replace recq7 = .a if q7_uk == .a
replace recq7 = .r if q7_uk == .r
label def q7_label 17001 "UK: Additional private insurance" 17002 "UK: Only public insurance" .a "NA" .r "Refused"
label values recq7 q7_label

lab def labels23 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels24 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels26 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels41 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels50 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels51 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels53 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels69 .a "NA" .r "Refused" .d "Don't know",modify
		  
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop q7_uk q4 q5 q8 q20 q44 q63 q11 q12 q13 q18 q25_a q26 q29 q6_uk ///
	 q41 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q46a q46b_refused ///
	 q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q16 q17 q51 q52 q53 q3 q14 q15 q24 q57
	 
ren rec* *


order respondent_serial mode weight_educ respondent_id country
order q*, sequential

* Label variables
* Mia added
lab var country "Country"
lab var int_length "Interview length (in minutes)" 
lab var date "Date of interview"
lab var respondent_id "Respondent ID"
*
lab var q1 "Q1. Respondent еxact age"
*lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6_uk "Q6. UK only: In addition to the NHS, do you have private health insurance...?"
lab var q7 "Q7. What type of health insurance do you have?"
*lab var q7_other "Q7_other. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"
lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var q19a "Q19a. UK only: Is it a National Health Service (NHS) facility or a private health facility?"
lab var q19b "Q19b. UK only: Is it a Health and Social Care (HSC) facility or a private health facility?"
lab var q19_other_uk "Q19. Other"
lab var q20 "Q20. What type of healthcare facility is this?"
*lab var q20_other "Q20. Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q28_c "Q28_C. How would you rate the overall quality of your last telemedicine visit?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43a_uk "Q43a. UK only: Did you go to a NHS facility or a private health care facility?"
lab var q43b_uk "Q43a. UK only: Did you go to a HSC facility or a private health care facility?"
lab var q43_other_uk "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
*lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46_refused "Q46. Refused"
lab var q46b_refused "Q46B. Refused"
lab var q47_refused "Q47. Refused"
lab var q46a "Q46A. Was this a scheduled visit or did you go without an appt.?"
lab var q46b "Q46B. In days: how long between scheduling and seeing provider?"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q48_a "Q48_A. How would you rate the overall quality of care you received?"
lab var q48_b "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var q48_c "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var q48_d "Q48_D. How would you rate the level of respect your provider showed you?"
lab var q48_e "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var q48_f "Q48_F. How would you rate whether your provider explained things clearly?"
lab var q48_g "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var q48_h "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var q48_i "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var q48_j "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var q48_k "Q48_K. How would you rate how long it took for you to get this appointment?"
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private healthcare?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62_uk "Q62. UK only: What is your race?"
lab var q63 "Q63. Total monthly household income"
lab var q64 "Q64. Do you have another mobile phone number besides this one?"
lab var q65 "Q65. How many other mobile phone numbers do you have?"
lab var q66_uk "Q66. Which political party did you vote for in the last election?"

*------------------------------------------------------------------------------*
* Mia added
*Dropping the following value labels so the dataset won't get messed up when merging
label copy labels23 q19a_uk_label
label drop labels23  
label value q19a_uk q19a_uk_label
label copy labels24 q19b_uk_label
label drop labels24  
label value q19b_uk q19b_uk_label
label copy labels50 q43a_uk_label
label drop labels50   
label value q43a_uk q43a_uk_label

*------------------------------------------------------------------------------*

* Other, specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q19_other_original = q19_other_uk
label var q19_other_original "Q19. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"

gen q43_other_original = q43_other_uk
label var q43_other_original "Q43. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"	


*Remove "" from responses for macros to work
replace q21_other = subinstr(q21_other,`"""',  "", .)
replace q42_other = subinstr(q42_other,`"""',  "", .)
replace q45_other = subinstr(q45_other,`"""',  "", .)


ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_17.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_serial)	
	
drop q19_other_uk q21_other q42_other q43_other_uk q45_other
	 
ren q19_other_original q19_other_uk
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q43_other_original q43_other_uk
ren q45_other_original q45_other

order q*, sequential
order respondent_serial respondent_id mode country language date int_length weight_educ
*------------------------------------------------------------------------------*

* Save data
save "$data_mc/02 recoded data/pvs_uk.dta", replace
 
