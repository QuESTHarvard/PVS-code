* People's Voice Survey data cleaning for Romania
* Date of last update: August 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Romania. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ROMANIA ***********************

* Import data 
import spss using "$data/Romania/01 raw data/PVS_Romania_Final weighted.sav", case(lower)

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

* Rename all variables, and some recoding if variable will be dropped 

ren q14_new q14
ren q15_new q15
ren q19 q19_ro

*change q21 for additional RO var:
recode q21 (1 = 1 "Low cost") /// 
			(2 = 2 "Short distance") ///
			(3 = 3 "Short waiting time") ///
			(4 = 4 "Good healthcare provider skills") ///
			(5 = 5 "Staff shows respect") ///
			(6 = 6 "Medicines and equipment are available") ///
			(7 = 7 "Only facility available") ///
			(8 = 8 "Covered by insurance") ///
			(995 = 9 "Other, specify") ///
			(12 = 13 "RO: Recommended by family or friends") ///
			(996 = .r "Refused"), gen(recq21)

ren q28_new q28_b
ren q28_a q28_c
ren q28 q28_a
ren q37 q37_ro

recode q42 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance)") /// 
			(2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
			(3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
			(4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
			(5 = 5 "Staff didn't show respect (e.g., staff is rude, impolite, dismissive)") ///
			(6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
			(7 = 7 "Illness not serious enough") ///
			(8 = 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)") ///
			(995 = 10 "Other, specify") ///
			(12 = 13 "RO: Fear of examination/medical procedure") ///
			(13 = 14 "RO: Lack of trust in doctors/procedures") ///
			(14 = 15 "RO: Concern about informal payments/gifts") ///
			(996 = .r "Refused"), gen(recq42)


ren q43 q43_ro

recode q45 (1 = 1 "Care for an urgent or new health problem") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease") ///
		   (3 = 3 "Preventive care or a visit to check on your health") ///
		   (11 = 4 "Other,specify") ///
		   (996 = .r "Refused"), gen(recq45)

ren q46_a q46a
ren q46_b q46b
ren q56 q56_ro
ren q66 q64
ren q67 q65
ren q68 q66

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables

generate recdate = dofc(date)
format recdate %td

format intlength %tcHH:MM:SS
gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60) 

*confirm the format for q46 and q47 instrument word doc says HH:MM
format q46 %tcHH:MM
gen recq46 = (hh(q46)*60 + mm(q46))

* confirm that format for q46b is in HH:MM:SS even though question asks days, hours, minutes
format q46b %tcHH:MM:SS
gen recq46b = (hh(q46b)*60 + mm(q46b) + ss(q46b)/60) 

format q47 %tcMM:SS
gen recq47 = (mm(q47)+ ss(q47)/60) 

*------------------------------------------------------------------------------*

gen reclanguage = 19000 + language 
lab def lang 19002 "RO: Romanian" 
lab values reclanguage lang

order q*, sequential
order respondent_id date int_length mode weight weight_educ //dropped country and lang

drop country
gen reccountry = 19
lab def country 19 "Romania"
lab values reccountry country 

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is "Refused"

gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 996
gen recq5 = reccountry*1000 + q5
replace recq5 = .r if q5 == 996
gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8 == 996
gen recq20 = reccountry*1000 + q20
replace recq20 = .r if q20 == 996
gen recq44 = reccountry*1000 + q44
replace recq44 = .r if q44 == 999
gen recq62 = reccountry*1000 + q62
replace recq62 = .r if q62== 996
gen recq63 = reccountry*1000 + q63
replace recq63 = .r if q63 == 996

local q4l labels8
local q5l labels9
local q8l labels12
local q20l labels23
local q44l labels23
local q62l labels53
local q63l labels54

foreach q in q4 q5 q8 q20 q44 q62 q63{
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
									    (`"RO: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

label define q4_label .a "NA" .r "Refused" , modify
label define q5_label .a "NA" .r "Refused" , modify
label define q8_label .a "NA" .r "Refused" , modify
label define q20_label .a "NA" .r "Refused" , modify
label define q44_label .a "NA" .r "Refused" , modify
label define q62_label .a "NA" .r "Refused" , modify
label define q63_label .a "NA" .r "Refused" , modify

* add label for "Refused"

label define labels52 .r "Refused", add


*****************************

**** Combining/recoding some variables ****

recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .

* no q46b_refused in RO data
*recode q46b (. = .r) if q46b_refused == 1 
*recode q46b_refused (. = 0) if q46b != .

*------------------------------------------------------------------------------*

* Drop unused variables 

drop respondent_id ecs_id time_new intlength q2 q4 q5 q8 q20 q21 q45 q42 q44 q46 q46b q47 q62 q63 q66 rim_age rim_gender rim_region rim_eduction dw_overall interviewer_id interviewer_gender interviewer_language language

*------------------------------------------------------------------------------*

* Generate variables 
gen respondent_id = "RO" + string(respondent_serial)
gen q2 = .a
gen q66 = .a 

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (996 = 0) (997 = 0) if q24 == 1
recode q23_q24 (996 = 2.5) (997 = 2.5) if q24 == 2
recode q23_q24 (996 = 7) (997 = 7) if q24 == 3
recode q23_q24 (996 = 10) (997 = 10) if q24 == 4
recode q23_q24 (997 = .r) if q24 == 996

*Q7
gen recq7 = reccountry*1000 + q7
*replace recq7 = .a if q7 == .a
replace recq7 = .r if q7 == 996
label def q7_label 19031 "RO: Mandatory social health insurance only (CAS)" ///
				   19032 "RO: Both mandatory social health insurance and private health insurance" ///
				   19033 "RO: Both mandatory social health insurance and private medical subscription" ///
				   19995 "RO: Other" .a "NA" .r "Refused"
label values recq7 q7_label

drop q7

*------------------------------------------------------------------------------*

* Recode refused and don't know values 
recode q23 q25_b q27 q28_a q28_b q37_ro (997 = .d)

recode q32 q33 q35 q36 q38 (3 = .d)

* In raw data, 996 = "refused" 	  
recode q6 recq7 q11 q12 q14 q15 q16 q17 q19_ro recq21 q22 q23 q24 q25_b q38 q43_ro ///
	   q39 q41 recq45 q46a q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j ///
	   q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_ro q57 q58 q59 q60 ///
	   q61 q64 q65 (996 = .r)
	   
recode recq44 (19996 = .r)

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
* Note: This is fine because 10 is a mid-pint value

list q26 q27 if q27 == 0 | q27 == 1
* Some implasuible values of 0 and 1
* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
recode q27 (0 = .a) 
recode q27 (1 = 2) 

* Q39, Q40 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28_a q28_b) 

* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
list visits_total q39 q40 if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .

* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* 10 changes to q39 and 6 changes to q40							  
							  
				 
* List if missing for q39/q40 but does have a visit
list visits_total q39 q40 if q39 == .a & visits_total > 0 & visits_total < . /// 
						   | q40 == .a & visits_total > 0 & visits_total < .
							  *Ok in data							 
							  
list visits_total q39 q40 if q39 != 3 & visits_total == 0 /// 
						   | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 214 changes made to q39, 218 changes made to q40
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (.r = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 1 change to q39 and 0 changes to q40

drop visits_total

*------------------------------------------------------------------------------*
 
* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q7 
recode recq7 (. = .a) if q6 == 2 | q6 == .r 
recode recq7 (nonmissing = .a) if q6 == 2

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15 (. = .a) if inrange(q14,3,5) | q14== .r 

*q19-22
recode q19_ro recq20 recq21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19_ro == 4 | q19_ro == .r

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r 
recode q25_a (. = .a) if q23 != 1

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
recode recq42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
* There is one case where both q23 and q24 are missing, but they answered q43-49
recode q43_ro recq44 recq45 recq46 recq46b q46_refused q46a recq47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 q48_k (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
	   
recode q43_ro recq44 recq45 recq46 recq46b q46_refused q46a recq47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (nonmissing = .a) if q23 == 0 | q24 == 1
	      
recode recq44 (. = .a) if q43_ro == 4 | q43_ro == .r

recode recq45 (995 = 4)

*q46/q47 refused
recode recq46  (. = .r) if q46_refused == 1
recode recq47  (. = .r) if q47_refused == 1

recode q46_refused (. = 0) if recq46 != .
recode q47_refused (. = 0) if recq47 != .

recode q48_k (. = .a) if q46a == 2 | q46a == .r

recode recq46b (. = .a) if q46a == 2 | q46a == .r

*q65
recode q65 (. = .a) if q64 != 1

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

recode q12 q30 q31 q32 q33 q34 q35 q36 q37_ro q38 ///
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
* Please note that in Greece: "Neither bad nor good" was recoded to "Fair"

recode q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54 ///
	   q55 q56_ro q59 q60 q61 ///
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
	
*q64 
recode q64 ///
	(1 = 1 "Yes") (2 = 0 "No / No other numbers") ///
	(.r = .r "Refused"), pre(rec) label(q64)

	
*NA/Refused/DK
	
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b recq46 recq46b recq47 q66 na_rf	


******* Country-specific *******
label define labels22 .a "NA" .r "Refused" .d "Don't know",modify
label define labels38 .a "NA" .r "Refused" .d "Don't know",modify
label define labels13 .a "NA" .r "Refused" .d "Don't know",modify
label define recq21 .a "NA" .r "Refused" .d "Don't know",modify
label define recq42 .a "NA",modify
label define recq45 .a "NA",modify
label define labels46 .a "NA" .r "Refused",modify
label define labels26 .a "NA" .r "Refused" .d "Don't know",modify


*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop date q3 q6 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q22 q24 q25_a ///
	 q26 q28_c q29 q41 q30 q31 q32 q33 q34 q35 q36 q37_ro q38 q39 q40 q41 q46a ///
	  q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_ro q57 q59 q60 q61 q64 weight
	 
ren rec* *

*Reorder variables
order respondent_serial mode weight_educ respondent_id country
order q*, sequential

* Country-specific vars for append 
ren q37_ro q37_gr_in_ro
ren q19_ro q19_et_in_ke_ro_za
ren q43_ro q43_et_in_ke_ro_za
ren q56_ro q56_et_gr_in_ke_ro_za

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
*lab var q8_other "Q8. Other"
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
lab var q19_et_in_ke_ro_za "Q19. ET/IN/KE/RO/ZA only: Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q19_other "Q19. ET/IN/KE/RO/ZA only: Other"
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
lab var q37_gr_in_ro "Q37. IN/GR/RO only: Have you received any of the following health services in the past 12 months?"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_et_in_ke_ro_za "Q43. ET/IN/KE/RO/ZA only: Is this a public, private, or NGO/faith-based facility?"
lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
*lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46_refused "Q46. Refused"
lab var q46a "Q46A. Was this a scheduled visit or did you go to the facility without an appointment?"
*Does this one var have hours, days, and weeks in it?
lab var q46b "Q46B. How long did you wait in hours, days, or weeks, between scheduling the appointment and seeing the health care provider?"
*lab var q46b_refused "Q46B. Refused"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
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
lab var q56_et_gr_in_ke_ro_za "Q56. ET/GR/IN/KE/RO/ZA only: How would you rate quality of NGO/faith-based healthcare?"
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

*label copy labels24 q19_gr_label
*label drop labels24  
*label value q19_gr q19_gr_label

*------------------------------------------------------------------------------*

/*
**# PVS ROMANIA - CATEGORIZATION OF "OTHER, SPECIFY" RESPONSES
**# Stata Version 18.0, 07-AUG-2023 

*****************************************************************************************************************
**# (a) q7 & q7_other:  					
*****************************************************************************************************************

* ===== CLASSIFICATION OF  "OTHER, SPECIFY" RESPONSES (Q7_OTHER)
* Kindly be aware that the option "Private insurance" was not a Q7 predefined category. 

*Private insurance
replace q7_other="Private Insurance" if  ///
	q7_other=="asigurare de sanatate privata"| ///
	q7_other=="Privat"| ///
	q7_other=="asigurare de sanatate privata"| ///
	q7_other=="Asigurare AOK"| ///
	q7_other=="Asigurare privata"| ///
	q7_other=="Privata"| ///
	q7_other=="Privata"| ///
	q7_other=="Asigurare de sanatate privata."| ///
	q7_other=="de la stat, privat si abonament"| ///
	q7_other=="de stat, privata si abonament in sistemul privat"| ///
	q7_other=="Privata"| ///
	q7_other=="privata de la locul de munca"| ///
	q7_other=="asigurare de sanatate de stat, privata si abonament medical in sistemul privat"| ///
	q7_other=="Asigurare privata"| ///
	q7_other=="privata"| ///
	q7_other=="asigurare privata"| ///
	q7_other=="asigurare de stat, privata si abonament la privat"| ///
	q7_other=="de stat, privata si abonament medical la privat"| ///
	q7_other=="Privata"| ///
	q7_other=="Asigurare privata"| ///
	q7_other=="asigurare privata"

* ===== CLASSIFICATION OF  "OTHER, SPECIFY" RESPONSES UNDER Q7 CATEGORIES

*Both mandatory social health insurance and private health insurance
replace q7=19032 if q7_other=="asig de sanat cu acumulare de capital+CAS" 
replace q7=19032 if q7_other=="CAS+ o alta in strainatate" 
replace q7=19032 if q7_other=="proaspat pensionat luna trecuta, nu stie care e situatia asig sale de sanata CAS+ pvt la Tiriac (de la servici ambele)"


*Both mandatory social health insurance and private medical subscription
replace q7=19033 if q7_other=="CAS+pvt+ abonam"

*Mandatory social health insurance only (CAS) 
replace q7=19031 if q7_other=="casa de asigurare de sanatate a armatei OPSNAJ" | ///
	q7_other=="CAS+ asig europeana" | ///
	q7_other=="CAS+asig de sanat ca studenta (?!)"
 
*****************************************************************************************************************
**# (b) q19_gr & q19_gr_other: Is this a public, private, contracted to public, or NGO healthcare facility?  
*****************************************************************************************************************
* ===== CLASSIFICATION OF  "OTHER, SPECIFY" RESPONSES UNDER Q19 CATEGORIES

* Private healthcare facility
replace q19_et_in_ke_ro_za=2 if q19_other=="PIVAT DAR LUCREAZA SI CU CAS-UL"
										
*****************************************************************************************************************	
**# (d) q21 & q21_other: Why did you choose this healthcare facility? 				*****************************************************************************************************************	

* ===== CLASSIFICATION OF  "OTHER, SPECIFY" RESPONSES UNDER Q21 CATEGORIES

*Covered by my healthcare insurance 
replace q21= 8 if 	q21_other=="Inclus la aceasta unitate prin locul de munca" 
replace q21= 8 if 	q21_other=="abonament oferit prin firma" 	
replace q21= 8 if 	q21_other=="beneficiez de abonament din partea angajatorului" 
replace q21= 8 if 	q21_other=="abonament de la firma" 	
replace q21= 8 if 	q21_other=="acoperit de abonamentul medical in sistemul privat" 	
replace q21= 8 if 	q21_other=="Am abonament medical privat de la servici" 	
replace q21= 8 if 	q21_other=="angajatorul meu mi-a facut abonament in perioada cand lucram." 	
replace q21= 8 if 	q21_other=="Pentru ca am abonament la acea clinica." 
replace q21= 8 if 	q21_other=="Asigurare de sanatate oferita de catre angajatorul meu."
replace q21= 8 if 	q21_other=="Abonament platit de companie"
replace q21= 8 if 	q21_other=="nu am acum asig de sanat pt ca nu mai lucrez, dar am ales aceasta unitaste pt ca era acop de asig de sanat"
replace q21= 8 if 	q21_other=="primul lucru e la medicul de familie, deoarece acesta ofera trimitre" 
replace q21= 8 if 	q21_other=="colaborare cu locul meu de mubnca"
replace q21= 8 if 	q21_other=="oferta companiei"


*Good healthcare provider skills 
replace q21=4 if ///
	q21_other=="Am incredere in deciziile loate de acest medic"| ///	
	q21_other=="pentru ca medicul ma cunoaste de mult timp"| ///	
	q21_other=="Deoarece lucreaza medicul meu."| ///	
	q21_other=="Comunicare buna cu medicul"| ///	
	q21_other=="Personal bine pregatit"| ///	
	q21_other=="Cunosc medicul de familie de multi si am incredere in acesta."| ///		
	q21_other=="Increderea in acest furnizor de servicii medicale."| ///	 
	q21_other=="increderea in cadrul medical"| ///	
	q21_other=="Medicul imi cunoaste problema medicala de 20 ani"| ///	
	q21_other=="am incredere in doctorul de familie"| ///	
	q21_other=="Medicul meu specialist este la aceasta unitate"| ///	 
	q21_other=="Deoarece acolo este cabinetul Diabetologului meu"| ///	
	q21_other=="cunosc medicul din liceu, am fost colegi, am incredere in dansa."| ///	 
	q21_other=="medicul face parte din reteaua sanitara militara pe care o utilizam"| ///	
	q21_other=="medicul meu profeseaza acolo si merg dupa el"| ///	
	q21_other=="am incredere in personal/medici"| ///	
	q21_other=="Personalul imi inspira incredere, iar tratamentul este eficient, ma simt mai bine urmand tratamentul indicat."


*Only facility available
replace q21=7 if ///	
	q21_other=="este singurul spital pneumologgic care se ocupa de boala mea"| ///	
	q21_other=="Acolo ma primeste pt pb, caci nu am medic de familie"| ///	
	q21_other=="Unica unitate sanitara șla care poate fii tratata problemamea de sanatate"| ///	
	q21_other=="Este singurul medic din localitate"	
	

*Short distance
replace q21=2 if q21_other=="aprope de casa"

	
*Short waiting time
replace q21=3 if ///
	q21_other=="Raspuns repede"| ///	
	q21_other=="birocratie redusa comparativ cu alt tip de unitati sanitare"| ///	
	q21_other=="Rapiditatea serviciilor din unitate"| ///	
	q21_other=="Disponibilitatea mecicilor"| ///	
	q21_other=="Disponiobilitatea medicului"| ///	
	q21_other=="merg la privat pentru ca este mai rapid decat daca merg la o unitate sanitara de stat"| ///	
	q21_other=="rapiditatea rezolvarii"	

*Staff shows respect
replace q21=5 if ///
	q21_other=="seriozitate"| ///	
	q21_other=="Dipsonibilitatea angajatilor"| ///	
	q21_other=="Seriozitate"| ///	
	q21_other=="amabilitatea amabil"| ///	
	q21_other=="Imi place faptul ca sunt tratrata cu respect."


*****************************************************************************************************************
**# (e) q42_other. The last time this happened what was the main reason? 
*****************************************************************************************************************	

* ===== CLASSIFICATION OF  "OTHER, SPECIFY" RESPONSES UNDER Q42 CATEGORIES
*Far distance
replace q42=2 if q42_other=="Nu a ajuns ambulanta la timp"	

*High cost
replace q42=1 if ///
	q42_other=="Cardul de sanatate nu este valid si nu am putut beneficia de asistenta medicala." | ///
	q42_other=="Lipsa cardului de sanatate" | ///
	q42_other=="Nu aveam asigurarea de sanatate." | ///
	q42_other=="Nu am asigurare medicala" | ///
	q42_other=="Nu este asigurata" | ///
	q42_other=="Fara asigurare."	


*Illness perceived as not serious enough
replace q42=7 if ///
	q42_other=="Nu a fost necesar"	| ///
	q42_other=="nu a fost cazul" 

*Lack of trust
replace q42=14 if q42_other=="Lipsa de incredere fata de sistem"	

*Long waiting time
replace q42=3 if q42_other=="programare peste un termen lung"	

*Staff don't show respect
replace q42=5 if q42_other=="personalul medical nu a dorit sa ma consulte" 
replace q42=5 if q42_other=="personalul medical a afirmat ca invoc stari de rau doar pentru a fi internata si ca acest comportament este specific persoanelor in varsta care doresc atentie" 
replace q42=5 if q42_other=="Am cfost trimis acasa pe motivul ca nu am nimic"	

	
*****************************************************************************************************************	
**# (f) q43 & q43_other   	
*****************************************************************************************************************	

* Categorization not possible without uncertainty. It is reported "don't know" in most of the open-ended fields.
	
	
*****************************************************************************************************************	
**# (f) q45 & q45_other What was the main reason you went?  	
*****************************************************************************************************************	

*CLASSIFICATION OF "OTHER, SPECIFY" RESPONSES UNDER Q45 CATEGORIES

*Urgent or new health problem
replace q45=1 if q45_other=="dureri foarte mari in zona abdomenului"	

* Follow=up care
replace q45=2 if ///
	q45_other=="monitorizare Covid -19" | ///
	q45_other=="Consultatie pentru o afectiune mai veche" | ///
	q45_other=="gimnastica pentru recuperare" | ///
	q45_other=="Recuperare dupa operatia la coloana" | ///
	q45_other=="Control medical dupa o interventie chirurgicala" | ///
	q45_other=="infertilitate"

* Preventive care
replace q45=3 if q45_other=="Ingrijiri postanatale"
*/

*------------------------------------------------------------------------------*


* Other, specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen q7_other_original = q7_other
label var q7_other_original "Q7. Other"

gen q19_other_original = q19_other
label var q19_other_original "Q19. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"

gen q43_other_original = q43_other
label var q43_other_original "Q43. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"

gen q62_other_original = q62_other
label var q62_other_original "Q62. Other"	

*Remove "" from responses for macros to work
replace q21_other = subinstr(q21_other,`"""',  "", .)
replace q42_other = subinstr(q42_other,`"""',  "", .)
replace q45_other = subinstr(q45_other,`"""',  "", .)


ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_19.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_serial)	
	
drop q7_other q19_other q21_other q42_other q43_other q45_other
	
ren q7_other_original q7_other	
ren q19_other_original q19_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q43_other_original q43_other
ren q45_other_original q45_other

*------------------------------------------------------------------------------*

order q*, sequential
order respondent_serial respondent_id country language date int_length mode weight_educ weight

*------------------------------------------------------------------------------*

* Save data - need to do other specify checks

save "$data_mc/02 recoded data/pvs_ro.dta", replace

*------------------------------------------------------------------------------*



