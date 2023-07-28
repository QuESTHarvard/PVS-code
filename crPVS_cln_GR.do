* People's Voice Survey data cleaning for Greece
* Date of last update: July 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Greece and Romania. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** GREECE ***********************

* Import data 
import spss using "$data/Greece/01 raw data/PVS_Greece_weighted_180723.sav", case(lower)

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

* Rename all variables, and some recoding if variable will be dropped 

*ren intlength int_length
ren q14_new q14
ren q15_new q15
ren q28 q28_a
ren q28_new q28_b
ren q28_gr q28_c // need to flip order of values
ren q37_gr q37_in_gr

*renamed q43_gr to q43 and q43 to q43_gr since the old q43_gr data isn't a part of our survey
ren q43_gr q43b
ren q43 q43_gr

ren q46_gr2 q46a
ren q46_gr q46b // double check units of raw data
ren q46_gr_refused  q46b_refused
ren q56 q56_et_gr_in_ke_za
ren q66 q64
ren q67 q65

*double check this is correct
format intlength %tcHH:MM:SS
gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60) 

*confirm the format for q46 and q47 (is it MM:SS or HH:MM) - and q46b is in  -1.19e+13?what does this mean?
format q46 %tcMM:SS
gen recq46 = (mm(q46)+ ss(q46)/60) 

format q47 %tcMM:SS
gen recq47 = (mm(q47)+ ss(q47)/60) 

gen reclanguage = 18000 + language 
lab def lang 18002 "GR: Greek" 
lab values reclanguage lang

order q*, sequential
order respondent_id date int_length mode weight weight_educ //dropped country and lang

gen reccountry = 18
lab def country 18 "Greece"

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 999

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

local q4l labels5
local q5l labels10
local q8l labels13
local q20l labels25
local q44l labels25
local q63l labels63

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
									    (`"GB: `gr`i''"'), modify			
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

*****************************

**** Combining/recoding some variables ****

recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .

recode q46b (. = .r) if q46b_refused == 1 
recode q46b_refused (. = 0) if q46b != .

*add for q47

*------------------------------------------------------------------------------*

* Drop unused variables 

drop ecs_id time_new intlength q2 q4 q5 q8 q19 q19_other q20 q20_b q20_b_other q20_c q20_c_other q20_d q20_d_other q43b q44 q44_b q44_b_other q44_c q44_c_other q46 q47 q63 q66_a q66_b q69 q69_codes rim_age rim_gender q4_weight rim_region q8_weight rim_education dw_overall sample_type interviewer_id interviewer_gender interviewer_language country language


*------------------------------------------------------------------------------*

* Generate variables 
gen q2 = .a
gen q66 = .a 

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (996 = 0) (997 = 0) if q24 == 1
recode q23_q24 (996 = 2.5) (997 = 2.5) if q24 == 2
recode q23_q24 (996 = 7) (997 = 7) if q24 == 3
recode q23_q24 (996 = 10) (997 = 10) if q24 == 4
recode q23_q24 (997 = .r) if q24 == 996

*------------------------------------------------------------------------------*

* Recode refused and don't know values 
* In raw data, 995 = "don't know" 
recode q12 q15 q23 q37_in_gr (995 = .d)

recode q23 q27 q28_a q31 q32 q33 q34 q35 q36 q38 (997 = .d)

* In raw data, 996 = "refused" 	  
recode q6 q7 q11 q14 q15 q16 q17 q18 q21 q22 q23 q24 q27 q28_a q28_c q29 q39 ///
	   q40 q42 q43_gr q45 q46a q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h ///
	   q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 ///
	   q56_et_gr_in_ke_za q57 (996 = .r)	

*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*------------------------------------------------------------------------------*
	 
* Check for implausible values - review

* Q25_b
list q23_q24 q25_b if q25_b > q23_q24 & q25_b < . 
* Note: okay in these data

* Q26, Q27 
list q23_q24 q27 if q27 > q23_q24 & q27 < . 
* Note: okay in these data (2.5 is mid-point value)

list q26 q27 if q27 == 0 | q27 == 1
* Some implasuible values of 0 and 1
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
recode q27 (1 = 2) 

* Q39, Q40 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28_a q28_b) 

* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
list visits_total q39 q40 if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
* Note: okay in these data 							  
							  
				 
* List if missing for q39/q40 but does have a visit
list visits_total q39 q40 if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
							  *Ok in data							 
							  
list visits_total q39 q40 if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months

* total of 203 changes made to q39, 204 changes made to q40
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no
* but they have no visit values in past 12 months 
recode q39 q40 (.r = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months

drop visits_total


*------------------------------------------------------------------------------*
 
* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 
* Note: Some missing values in q1 that should be refused 

* q7 
recode q7 (. = .a) if q6 == 2 | q6 == .r 
recode q7 (nonmissing = .a) if q6 == 2

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15 (. = .a) if inrange(q14,3,5) | q14== .r 

*q19-22
recode q19_gr recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19_gr == 4 | q19_gr == .r

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r 
recode q25_a (. = .a) if q23 != 1
* one person answered 2 to q23 but was asked q25_a
recode q25_a (nonmissing = .a) if q23 != 1
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r

*q28_c
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r

* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r 
recode q32 (. = .a) if q3 != 2 | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
* There is one case where both q23 and q24 are missing, but they answered q43-49
recode q43_gr recq44 q45 recq46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
recode q43_gr recq44 q45 recq46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (nonmissing = .a) if q23 == 0 | q24 == 1
	   
recode recq44 (. = .a) if q43_gr == 4 | q43_gr == .r

recode q45 (995 = 4)

*q46/q47 refused
recode recq46  (. = .r) if q46_refused == 1
recode recq47  (. = .r) if q47_refused == 1

* add the part to recode q46_refused q47_refused to match other programs
recode q46_refused (. = 0) if recq46 != .
recode q47_refused (. = 0) if recq47 != .

*q66/67
recode q66 (. = .a) if mode == 2


*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q11 q13 q18 q25_a q26 q29 q41 ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (.a = .a "NA"), ///
	   pre(rec) label(yes_no)

lab val q46_refused q47_refused yes_no

recode q12 q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (3 .d = .d "Don't know") /// 
	   (.a = .a "NA"), ///
	   pre(rec) label(yes_no_dk)

recode q6 q39 q40 /// 
	   (1 = 1 "Yes") (2 = 0 "No") ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r "Refused"), ///
	   pre(rec) label(yes_no_na)
	   
recode q46a ///
		(1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
		(2 = 0 " No, I did not have an appointment") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_appt)
		
* All Excellent to Poor scales
* Confirm it's ok to change "Neither bad nor good" to "Fair"

recode q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54 ///
	   q55 q59 q60 q61 ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") (.r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor)
	   
recode q22 ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") (5 = 0 "Poor") /// 
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r "Refused"), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r "Refused"), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode q48_j ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r "Refused") ///
	   (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor_judge)	   
	   
* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options
	   
recode q3 ///
	(1 = 0 "Male") (2 = 1 "Female") (3 = 2 "Another gender") (.r = .r "Refused"), ///
	pre(rec) label(gender)

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r "Refused") (.a = .a "NA"), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (3 = .d "Not sure") ///
	   (.r = .r "Refused") (.a = .a "NA"), ///
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
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b recq46a q46b recq47 na_rf	
	
	
******* Country-specific *******
lab def labels24 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels38 .a "NA" .r "Refused" .d "Don't know",modify
lab def labels14 .a "NA" .r "Refused" .d "Don't know",modify
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop q3 q6 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q22 q24 q25_a ///
	 q26 q28_c q29 q41 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q46a ///
	  q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q51 q52 q53 q54 q55 q57 q59 q60 q61
	 
ren rec* *


order respondent_serial mode weight_educ respondent_id country
order q*, sequential

* Label variables
lab var country "Country"
lab var int_length "Interview length (in minutes)" 
lab var date "Date of interview"
lab var respondent_id "Respondent ID"
lab var q1 "Q1. Respondent еxact age"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q8_other "Q8. Other"
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

*Need to confirm wording of q19_gr with instrument - dropped q19 and q19 other because there was no data
lab var q19_gr "Q19. GR only: Is this a public, private, contracted to public or NGO healthcare facility?"
lab var q19_gr_other "Q19. GR only: Other"

lab var q20 "Q20. What type of healthcare facility is this?"
lab var q20_other "Q20. Other"
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

*Need to confirm wording of q37_in_gr with instrument since it's cut off in stata
*lab var q37_in_gr "Q37_C. GR only: Have you received any of the following health services in the past 12 mon"

lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"

*Need to confirm wording of q43_gr with instrument since it's cut off in stata
lab var q43_gr " Q43. GR only: Thinking about your last healthcare visit for a new or ongoing health probl"

lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"

***********Need to confirm wording of q46 thru q47 with instrument, very confusing
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46_refused "Q46. Refused"
*In data: "Was this a scheduled visit or did you go to the facilit"
lab var q46a "Q46A. Was this a scheduled visit or did you go without an appt.?"
*Q46b very confusing in data "Q46_GR. How long did you wait in hours, days, or weeks, between scheduling the a",
	*Does this one var have hours, days, and weeks in it?
*lab var q46b "Q46B. In days: how long between scheduling and seeing provider?"
lab var q46b_refused "Q46B. Refused"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
* keeps dropping q47_refused above, unsure why
lab var q47_refused "Q47. Refused"

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

lab var q56_et_gr_in_ke_za "Q56. ET/GR/IN/KE/ZA only: How would you rate quality of NGO/faith-based healthcare?"

lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62 "Q62. Respondent's mother tongue or native language"
lab var q62_other "Q62. Other"
lab var q63 "Q63. Total monthly household income"
lab var q64 "Q64. Do you have another mobile phone number besides this one?"
lab var q65 "Q65. How many other mobile phone numbers do you have?"
lab var q66 "Q66.Which political party did you vote for in the last election?"


*------------------------------------------------------------------------------*
*Dropping the following value labels so the dataset won't get messed up when merging
/*
label copy labels23 q19a_gb_label
label drop labels23  
label value q19a_gb q19a_gb_label
label copy labels24 q19b_gb_label
label drop labels24  
label value q19b_gb q19b_gb_label
label copy labels50 q43a_gb_label
label drop labels50   
label value q43a_gb q43a_gb_label
*/

*------------------------------------------------------------------------------*

* Other, specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other type of health insurance?"

gen q8_other_original = q8_other
label var q8_other_original "Q8. Highest level of education completed by the respondent"
	
gen q19_gr_other_original = q19_gr_other
label var q19_gr_other_original "Q19. GR only: Other"

gen q20_other_original = q20_other
label var q20_other_original "Q20. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"

gen q44_other_original = q44_other
label var q44_other_original "Q44. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"	

gen q62_other_original = q62_other
label var q62_other_original "Q62. Other"	


*Remove "" from responses for macros to work
*replace q21_other = subinstr(q21_other,`"""',  "", .)
*replace q42_other = subinstr(q42_other,`"""',  "", .)
*replace q45_other = subinstr(q45_other,`"""',  "", .)


ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_18.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_serial)	
	
drop q7_other q8_other q19_gr_other q20_other ///
	 q21_other q42_other q44_other q45_other q62_other
	 
ren q7_other_original q7_other
ren q8_other_original q8_other
ren q19_gr_other_original q19_gr_other
ren q20_other_original q20_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q44_other_original q44_other
ren q45_other_original q45_other
ren q62_other_original q62_other

order q*, sequential
order respondent_serial respondent_id mode country language date int_length weight_educ
*------------------------------------------------------------------------------*

* Save data - need to do other specify checks

*save "$data_mc/02 recoded data/pvs_gr.dta", replace

*------------------------------------------------------------------------------*


