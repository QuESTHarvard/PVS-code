* People's Voice Survey data cleaning and appending
* Date of last update: February 2023
* Last updated by: N Kapoor

/*
This file cleans data by country and appends data into a multi-country dataset.

Cleaning includes:
	- Dropping any unusable records 
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ETHIOPIA, KENYA, SOUTH AFRICA, & India ***********************

* NOTE: Ipsos has been sharing combined data in different ways. These are interim 
*		work-arounds to obtain complete data until we receive final data (late March)

* Import raw data 

* Kenya: import latest data / weight 
u "$data_mc/01 raw data/PVS_ET and KE weighted_22.12.22.dta"
keep if Country == 5

* Add back QC_short from previous data 
merge 1:1 ECS_ID Country using "$data/Kenya/01 raw data/HARVARD_Main KE CATI and F2F_weighted_171122.dta", keepusing(QC_short)

* Drop interviews that are short and could be low-quality 
* Ipsos provided qc_short var that identifies short interviews that might be low-quality 
* for Kenya data (dropped 165 interviews previously with QC_short, 197 with qc_short2)
drop if QC_short == 2
drop QC_short _merge  

* Ethiopia: import latest data / weight
append using "$data_mc/01 raw data/PVS_ET weighted_03.02.23.dta"

drop Respondent_ID mode2
ren ECS_ID Respondent_ID 

* Mia: Save to merge later so we won't lose ZA's value labels for some questions
tempfile label0
label save Q7 Q20 Q44 using `label0'
label drop Q7 Q8 Q20 Q44

* South Africa 
append using "$data_mc/01 raw data/PVS_SA weighted_03.02.23.dta"
qui do `label0'
* Mia: correct some value labels
label define Q8 1 "None" 2 "No formal education" 3 "Primary school (Grades 1-8)" 4 "Secondary school (Grades 9-12)", modify
	
*Shalom- edited income orders
recode Q63 (1 = 1 "< Ksh 15,572") ///
		   (2 = 2 "Ksh 15,573 - 23,500") ///
		   (3 = 3 "Ksh 23,501- 50,000") ///
		   (4 = 4 "Ksh 50,001-75,000") ///
		   (5 = 5 "Ksh 75,001- 120,000") ///
		   (6 = 6 "Ksh 120,001-250,000") ///
		   (7 = 7 ">Ksh 250,000") ///
		   (9 = 9 "Less than 1000 Eth.Birr") ///
		   (10 = 10 "1000 - 3000  Eth.Birr") ///
		   (11 = 11 "3001 – 5000 Eth.Birr") ///
		   (12 = 12 "5001 – 10000 Eth.Birr") ///
		   (13 = 13 "10001 - 20000 Eth.Birr") ///
		   (14 = 14 "Greater than 20000 Eth.Birr") ///
		   (23 = 15 "No income") ///
		   (15 = 16 "<R750") ///
		   (16 = 17 "R751-R1500") ///
		   (17 = 18 "R1501-R3000") ///
		   (18 = 19 "R3001-R6000") ///
		   (19 = 20 "R6001-R11000") ///
		   (20 = 21 "R11001-R27000") ///
		   (21 = 22 "R27001-R45000") ///
		   (22 = 23 "R>45000") ///
		   (996 = 996 "Refused") (997 = 997 "Don't know"), gen(q63)
		   
drop Q63

*Change all variable names to lower case
rename *, lower //Mia: move this early

* India - load in India data 

* Fix append issues
* Mia: changed to 16 since 16 is mobile clinic
recode q20 q44 (23 = 16) if country == 9 

*** Mia changed this part ***
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 996
gen reclanguage = country*1000 + language 
gen interviewer_id = country*1000 + interviewerid_recoded
gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 996
gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == 996
gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 996
gen recq8 = country*1000 + q8
replace recq8 = .r if q8== 996
gen recq20 = country*1000 + q20
replace recq20 = .r if q20== 996
gen recq44 = country*1000 + q44
replace recq44 = .r if q44== 996
gen recq62 = country*1000 + q62
replace recq62 = .r if q62== 996
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== 996
replace recq63 = .d if q63== 997

* Mia: relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 5 "KE" 7 "PE" 9 "ZA" 10 "UY"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l Q4
local q5l Q5
local q7l Q7
local q8l Q8
local q20l Q20
local q44l Q44
local q62l Q62
local q63l q63

foreach q in q4 q5 q7 q8 q20 q44 q62 q63{
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

	forvalues o = 1/`countryn' {
		forvalues i = 1/``q'n' {
			local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of ``q'val''
			foreach lev in ``q'level'{
				if strmatch("`lev'", "`recvalue`q''") == 1{
					elabel define `q'_label (= `: word `o' of `countryval''*1000+`: word `i' of ``q'val'') ///
									        (`"`: word `o' of `countrylab'': `gr`i''"'), modify			
				}	
			}                 
		}
	}
	
	label val rec`q' `q'_label
}
*****************************

label define q63_label .r "Refused" .d "Don't Know", add

*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*

* Fix interview length variable and other time variables 

* Converting interview length to minutes so it can be summarized
gen int_length = intlength / 60

* Converting Q46 and Q47 to minutes so it can be summarized
gen q46_min = q46 / 60
gen q47_min = q47 / 60

format date %tdD_M_CY

*------------------------------------------------------------------------------*

* Drop any unwanted/empty variables
* Generate any new needed variables

* Drop respondents under 18 
drop if q2 == 1 | q1 < 18


* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (997 = 0) (996 = 0) if q24 == 1
recode q23_q24 (997 = 2.5) (996 = 2.5) if q24 == 2
recode q23_q24 (997 = 7) (996 = 7) if q24 == 3
recode q23_q24 (997 = 10) (996 = 10) if q24 == 4
recode q23_q24 (997 = 996) if q24 == 996

* Generate new var for insurance in ZA since question asked differently
gen q6_za = q6 if country == 9
replace q6 = .a if country == 9

*------------------------------------------------------------------------------*

*NOTE: May update and remove this code in the future, as it could be recoded in
*	   section below  

* Recode all Refused and Don't know responses

* In raw data, 997 = "don't know" 
* Mia: dropped q63 since we already recoded it
recode q23 q25_a q25_b q27 q28 q28_new q30 q31 q32 q33 q34 q35 q36 q38 ///
	   q66 q67 (997 = .d)
	   
*NOTE: currently in data q37_za "don't know" is category 3  

* In raw data, 996 = "refused" 
* Mia: dropped q4 q5 q7 q8 q44 q62 q63 since we already recoded them
recode q1 q2 q3 q6 q6_za q9 q10 q11 q12 q13 q14_new q15_new q16 q17 /// 
	   q18 q19 recq20 q21 q22 q23 q23_q24 q24 q25_a q25_b q26 q27 q28 q28_new q29 q30 /// 
	   q31 q32 q33 q34 q35 q36 q37_za q38 q39 q40 q41 q42 q43 q45 q46 q47 ///
	   q46_refused q47_refused q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
	   q56 q57 q58 q59 q60 q61 q66 q67 (996 = .r)	

*------------------------------------------------------------------------------*

* Check for implausible values 

list q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . 
* Note: okay in these data

list q23_q24 q27 country if q27 > q23_q24 & q27 < . 
* Note: okay in these data (2.5 is mid-point value)

list q26 q27 country if q27 == 0 | q27 == 1
* Some implasuible values of 0 and 1
* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
recode q26 (2 = 1) if q27 == 0
recode q27 (0 = .a)  
recode q27 (1 = 2) 

* Mia: added this check even though it looks fine for this dataset
list q26 q27 country if q26 == 1 & q27 > 0 & q27 < .

*** Mia changed this part ***
* list if they say "I did not get healthcare in past 12 months"
* but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28 q28_new)

list q23_q24 q39 q40 country if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
							  
* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months"
* but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* Mia: total of 38 changes made to q39 and 36 changes made to q40

* list if it is .a but they have visit values in past 12 months 
list q23_q24 q39 q40 country if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* this is fine
							  
* list if they chose other than "I did not get healthcare in past 12 months"
* but visits_total == 0 

list q23_q24 q39 q40 country if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no
* but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* Mia: total of 1477 changes made to q39, 1482 changes made to q40

drop visits_total
* did not check if q39 == 3 but q40 not since the previous steps should have changed 3 to .r if have visit.  
*****************************

*------------------------------------------------------------------------------*

* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //Mia: change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 
* Note: Some missing values in q1 that should be refused 

* q7 
recode recq7 (. = .a) if q6 == 2 | q6 == .r | q6_za == 2 | q6_za == .r

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15_new (. = .a) if inrange(q14_new,3,5) | q14_new == .r 

*q19-22
recode q19 recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19 == 4 | q19 == .r

*** Mia changed this part ***
* NA's for q24-27 
recode q24 (. = .a) if q23 != .d | q23 != .r | q23 != . // Mia: add the case that q23 == . to be consistant with other programs
recode q25_a (. = .a) if q23 != 1 & q23 != . // Mia: add the case that q23 == .
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r // Mia: add the case that q26 == .r
*****************************

*** Mia changed this part ***
* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r //dropped q1 == .r, and make it so that question is asked only if q3 == 2 (female)
recode q32 (. = .a) if q3 != 2 | q2 == .r //dropped q1 == .r, and make it so that question is asked only if q3 == 2 (female)
*****************************

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
* Mia: there is one case where both q23 and q24 are missing, but they answered q43-49
recode q43 recq44 q45 q46 q46_min q46_refused q47 q47_min q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
	   
recode recq44 (. = .a) if q43 == 4 | q43 == .r

recode q45 (995 = 4)

*q46/q47 refused
recode q46 q46_min (. = .r) if q46_refused == 1
recode q47 q47_min (. = .r) if q47_refused == 1

*** Mia changed this part ***
* add the part to recode q46_refused q47_refused to match other programs
recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .
*****************************

*q66/67
recode q67 (. = .a) if q66 == 2 | q66 == .d | q66 == .r 
recode q66 q67 (. = .a) if mode == 2

*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q6 q6_za q11 q12 q13 q18 q25_a q26 q29 q41 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)
	   
* Mia: moved q46_refused q47_refused here
lab val q46_refused q47_refused yes_no

recode q30 q31 q32 q33 q34 q35 q36 q38 q37_za q66 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (3 .d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)
	   
*Note: Added "3" for q37_za 

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
* All Excellent to Poor scales

recode q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 ///
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
	   (5 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
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

recode interviewer_gender ///
	(1 = 0 Male) (2 = 1 Female), ///
	pre(rec) label(int_gender)

* Note: Without relabeling (removing the appostrophe) next command will not run 
lab var q2 
recode q2 (2 = 0 "18-29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14_new ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

* Mia: q15_new instead of q15
recode q15_new /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

	
recode q49 ///
	(1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") ///
	(7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)

* Numeric questions needing NA and Refused value labels 
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28 q28_new q46 q46_min q47 q47_min q67 na_rf 

*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
* Mia: q15_new instead of q15
* Mia: added language, q5, q4, q7, q8, q20, q44, q62, and q63
drop interviewer_gender q2 q3 q6 q6_za q11 q12 q13 q18 q25_a q26 q29 q41 q30 q31 /// 
	 q32 q33 q34 q35 q36 q38 q66 q39 q40 q9 q10 q22 q37_za q48_a q48_b q48_c q48_d ///
	 q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 q48_e q48_j q50_a q50_b ///
	 q50_c q50_d q16 q17 q51 q52 q53 q3 q14_new q15_new q24 q49 q57 q46 q47 ///
	 language q5 q4 q8 q44 q62 q63 q20 q7

ren rec* *
 
ren q14_new q14
ren q15_new q15
ren q19_4 q19_other
ren q21_9 q21_other
ren q28 q28_a
ren q28_new q28_b
ren q42_10 q42_other
ren q43_4 q43_other
ren q66 q64
ren q67 q65
ren time_new time
ren (q46_min q47_min) (q46 q47)
* ren ecs_id respondent_id
* Check ID variable and interviewer ID variable in other data 

*Reorder variables
order q*, sequential
order q*, after(interviewer_id) //Mia: changed to interviewer_id since we already dropped interviewer_gender


* Drop other unecessary variables 
drop intlength 
* Note: mode2 seems to be missing for Kenya data, but there is mode var 


*------------------------------------------------------------------------------*

* Labeling variables 
* Mia: dropped interviewer_gender since we already dropped the variable above
lab var country "Country"
lab var respondent_id "Respondent ID"
lab var interviewer_id "Interviewer ID"
lab var int_length "Interview length (in minutes)"
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
lab var q6_za "Q6. ZA only: Do you have medical aid?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7_other. Other type of health insurance"
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
lab var q19 "Q19. Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q19_other "Q19. Other"
lab var q20 "Q20. What type of healthcare facility is this?"
lab var q20_other "Q20. Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q37_za "Q37. ZA only: Had a test for HIV in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43 "Q43. Last healthcare visit in a public, private, or NGO/faith-based facility?"
lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46_refused "Q46. Refused"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q47_refused "Q47. Refused"
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
lab var q56 "Q56. How would you rate the quality of the NGO or faith-based healthcare?"
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

*------------------------------------------------------------------------------*

* Save data

save "$data_mc/02 recoded data/pvs_et_ke_za.dta", replace


*------------------------------------------------------------------------------*

************************************* LAC **************************************

clear all

* Import raw data 

import spss using "/$data_mc/01 raw data/LATAM(Co_Pe_Ur)_v1_completes_backcoded_weighted 122222.sav", clear
*------------------------------------------------------------------------------*
*Change all variable names to lower case

rename *, lower

*------------------------------------------------------------------------------*

* Fix interview length variable and other time variables 
* Converting interview length to minutes so it can be summarized

gen int_length = (hh(intlength)*3600 + mm(intlength)*60 + ss(intlength)) / 60

* Converting Q46 and Q47 to minutes so it can be summarized

gen q46_min = (hh(q46)*3600 + mm(q46)*60 + ss(q46)) / 60

gen q47_min = (hh(q47)*3600 + mm(q47)*60 + ss(q47)) / 60

gen recdate = dofc(date)
format recdate %tdD_M_CY

*------------------------------------------------------------------------------*

*Shalom added: reoder "income" values to make "no income" the first category
ren q63 Q63
recode Q63 (38 = 31 "No income") (31 = 32 "Less than S/.1.000") (32 = 33 "S/. 1.000 – 2.500") (33 = 34 "S/. 2.501 – 3.500") (34 = 35 "S/. 3.501 – 5.500") (35 = 36 "S/. 5.501 – 7.500") (36 = 37 "S/. 7.501 – 10.000") (37 = 38 "Greater than S/.10.000") ///
		   (48 = 39 "No income") (39 = 40 "Less than 75,000 pesos") (40 = 41 "75,000 to 200,000") (41 = 42 "200,000 to 400,000") (42 = 43 "400,000 to 600,000") (43 = 44 "600,000 to 800,000") (44 = 45 "800,000 to 10,000,000") (45 = 48 "More than 10,000,000") ///
		   (61 = 49 "No income") (49 = 50 "1,200 pesos or less") (50 = 51 "1,200 to 14,000") (51 = 52 "14,000 to 30,000") (52 = 53 "30,000 to 40,000") (53 = 54 "40,000 to 50,000") (54 = 55 "50,000 to 65,000") (55 = 61 "More than 65,000") (996 = 996 "Refused"), gen(q63)
		   
drop Q63

*------------------------------------------------------------------------------*

* Drop any unwanted/empty variables
* Generate any new needed variables

drop if q2 == 1 | q1 < 18

gen mode = 1	

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (997 = 0) (996 = 0) if q24 == 1
recode q23_q24 (997 = 2.5) (996 = 2.5) if q24 == 2
recode q23_q24 (997 = 7) (996 = 7) if q24 == 3
recode q23_q24 (997 = 10) (996 = 10) if q24 == 4
recode q23_q24 (997 = 996) if q24 == 996
	 
*** Mia changed this part ***
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 996
gen language = country*1000 + 11 //Mia: moved the recode language (. = 11) if country == 2 | country == 7 | country == 10  to here by just genenrating the language variable 
gen interviewer_id = country*1000 + interviewerid_recoded
* Note: 16 seems like a low number of interviewers across all three countries
*		I think this is an error
* 		I drop interviewer_id later anyways
gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 996
gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == 996
gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 996
gen recq8 = country*1000 + q8
replace recq8 = .r if q8== 996
gen recq20 = country*1000 + q20
replace recq20 = .r if q20== 996
gen recq44 = country*1000 + q44
replace recq44 = .r if q44== 996
recode q62 (998 = 995) // Mia: move this to here
gen recq62 = country*1000 +q62
replace recq62 = .r if q62== 996
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== 996
replace recq63 = .d if q63== 997

* Mia: relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 5 "KE" 7 "PE" 9 "ZA" 10 "UY"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l labels6
local q5l labels7
local q7l labels9
local q8l labels10
local q20l labels25
local q44l labels25
local q62l labels51
local q63l q63

foreach q in q4 q5 q7 q8 q20 q44 q62 q63{
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

	forvalues o = 1/`countryn' {
		forvalues i = 1/``q'n' {
			local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of ``q'val''
			foreach lev in ``q'level'{
				if strmatch("`lev'", "`recvalue`q''") == 1{
					elabel define `q'_label (= `: word `o' of `countryval''*1000+`: word `i' of ``q'val'') ///
									        (`"`: word `o' of `countrylab'': `gr`i''"'), modify			
				}	
			}         
		}
	}
	
	label val rec`q' `q'_label
}

*****************************

label define q5_label .r "Refused", add
label define q4_label .r "Refused", add
label define q7_label .r "Refused", add
label define q8_label .r "Refused", add
label define q20_label .r "Refused", add
label define q44_label .r "Refused", add
label define q62_label .r "Refused", add
label define q63_label .r "Refused", add

*------------------------------------------------------------------------------*

* Recode all Refused and Don't know

* Don't know is 997 in these raw data 
* Mia: dropped q63 since we alreayd recoded it
recode q13b q13e q23 q25_a q25_b q27 q28 q28_new q30 q31 q32 q33 q34 q35 q36 ///
	   q38 q66 q67 (997 = .d)

* Refused is 996 in these raw data 
* Mia: dropped q4 q5 q7 q8 q44 q62 q63 since we already recoded them
recode q1 q2 q3 q3a q6 q9 q10 q11 q12 q13 q13b q13e q14_new /// 
	   q15_new q16 q17 q18 q19_pe q19_uy q19_co recq20 q21 q22 q23 q24 q23_q24 q25_a /// 
	   q25_b q26 q27 q28 q28_new q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 /// 
	   q41 q42 q43_pe q43_uy q43_co q45 q46 q47 q48_a q48_b q48_c q48_d /// 
	   q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 /// 
	   q52 q53 q54 q55 q56_uy q56_pe q57 q58 q59 q60 q61 q66 q67 /// 
	   (996 = .r)	
	
*------------------------------------------------------------------------------*
			
* Check for implausible values 

list q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . 
* Note: okay in LAC data

list q23_q24 q27 country if q27 > q23_q24 & q27 < . 
* Note: okay in LAC data (2.5 is mid-point value)

list q26 q27 country if q27 == 0 | q27 == 1
* Note: okay in LAC data 

* Mia: added this check even though it looks fine for this dataset
list q26 q27 country if q26 == 1 & q27 > 0 & q27 < .

*** Mia changed this part ***
* list if they say "I did not get healthcare in past 12 months"
* but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28 q28_new)

list q23_q24 q39 q40 country if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
							  
* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months"
* but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* Mia: total of 38 changes made to q39 and 36 changes made to q40

* list if it is .a but they have visit values in past 12 months  
list q23_q24 q39 q40 country if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* this is fine

* list if they chose other than "I did not get healthcare in past 12 months"
* but visits_total == 0 

list q23_q24 q39 q40 country if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no
* but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* Mia: total of 1477 changes made to q39, 1482 changes made to q40

drop visits_total
* did not check if q39 == 3 but q40 not since the previous steps should have changed 3 to .r if have visit.  
*****************************


*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked due to skip patterns

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //Mia: change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q6 was not asked, all respondents were asked q7
recode q6 (. = .a)

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 
recode q13b (. = .a) if q12 == 2 | q12 == .r 
recode q13e (. = .a) if q13b == .a | q13b == 1 | q13b == .d | q13b == .r
* Note: Changed these to .a for all other countries after merge

* q15
recode q15_new (. = .a) if inrange(q14_new,3,5) | q14_new == .r

* q19-22
recode q19_pe q19_uy q19_co recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode q19_pe (. = .a) if country != 7
recode q19_uy (. = .a) if country != 10
recode q19_co (. = .a) if country != 2
* Note: Other, specify functioning differently here than other data 

* Note: UY appears to have NGO when it should be other
recode q19_uy (3 = 995)
* Mia: drop two value label to avoid confusion
label define labels23 3 "" 4 "" 995 "Other", modify

recode recq20 (. = .a) if q19_pe == .r | q19_uy == .r | q19_co  == .r

*** Mia changed this part ***
* NA's for q24-27 
recode q24 (. = .a) if q23 != .d | q23 != .r | q23 != . // Mia: add the case that q23 == . to be consistant with other programs
recode q25_a (. = .a) if q23 != 1 & q23 != . // Mia: add the case that q23 == .
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r // Mia: add the case that q26 == .r
*****************************

*** Mia changed this part ***
* q31 & q32
recode q31 (. = .a) if q3a == 1 | q1 < 50 | inrange(q2,1,4) | q2 == .r //dropped q1 == .r
recode q32 (. = .a) if q3a == 1 | q2 == .r //dropped q1 == .r
*****************************

* NOTE: q3a was assigned sex at birth, used for skip pattern in LAC

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r


* q43-49 NA's
recode q43_co q43_pe q43_uy recq44 q45 q46 q46_min q46_996 q47 q47_min q47_996  q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
	   
recode q43_pe (. = .a) if country != 7
recode q43_uy (. = .a) if country != 10
recode q43_co (. = .a) if country != 2
recode recq44 (. = .a) if q43_pe == .r | q43_uy == .r | q43_co  == .r //Mia: changed to recq44

*q46/q47 refused
recode q46_min (. = .r) if q46_996 == 1 
recode q47_min (. = .r) if q47_996 == 1
recode q46_996 (. = 0) if q46 != .
recode q47_996 (. = 0) if q47 != .
* Note: This refusal var has a lot of missing
*		Still some missing values in Q46 and Q47 that are not noted in the refusal var

* q56_pe, q56_uy
recode q56_pe (. = .a) if country != 7
recode q56_uy (. = .a) if country != 10

*q62
recode recq62 (. = .a) if country == 10

* NOTE: q62 was not asked in UY

*q66/67
recode q67 (. = .a) if q66 == 2 | q66 == .d | q66 == .r

*------------------------------------------------------------------------------*

* Recode value labels 
* Recode values and value labels so that their values and direction make sense

* Relabeling - some labels that prevent commands from running
* Generally due to the appostrophes in the label
* Add any other variables if needed

lab var q2
lab var q13e 
lab var q48_f 
lab var q53 

* All Yes/No questions
* Mia: added q46_996 and q47_996 so that labels are consistant after appending
recode q6 q11 q12 q13 q18 q25_a q26 q29 q41 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

* Mia: relabel q46_996 and q47_996 to be consistant
lab val q46_996 q47_996 yes_no

recode q13b q30 q31 q32 q33 q34 q35 q36 q38 q66 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk) 

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
* All Excellent to Poor scales

recode q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q54 q55 q56_pe q56_uy q59 q60 q61 ///
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
	   (5 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
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
	   
recode q16 q17 q51 q52 q53  ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options

recode interviewer_gender ///
	(1 = 0 Male) (2 = 1 Female), ///
	pre(rec) label(int_gender)

recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode q3a ///
	(1 = 0 Man) (2 = 1 Woman) (.r = .r Refused) (.a = .a "NA"), ///
	pre(rec) label(gender2)

recode q14_new ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)
	
* Mia: q15_new instead of q15	
recode q15_new ///
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA) (.d = .d "Don't know"), /// Don't know included in some countries
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

recode q45 ///
	(13 = 1 "Care for an urgent or acute health problem (accident or injury, fever, diarrhea, or a new pain or symptom)" ) ///
	(14 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes; mental health conditions") ///
	(15 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") ///
	(.a = .a "NA") (995 = 4 "Other, specify") (.r = .r "Refused"), ///
	pre(rec) label(main_reason)
	
	
recode q49 ///
	(1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") ///
	(7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)

* Numeric questions needing NA and Refused value labels 
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28 q28_new q46 q46_min q47 q47_min q67 na_rf 


*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

* Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
* Mia: added q5, q4, q7, q8, q20, q44, q62, and q63
drop interviewer_gender q2 q3 q3a q6 q11 q12 q13 q13b q18 q25_a q26 q29 q41 /// 
	 q30 q31 q32 q33 q34 q35 q36 q38 q66 q39 q40 q9 q10 q22 q45 q48_a q48_b q48_c ///
	 q48_d q48_f q48_g q48_h q48_i q54 q55 q56_pe q56_uy q59 q60 q61 q48_e /// 
	 q48_j q50_a q50_b q50_c q50_d q16 q17 q51 q52 q53 q3 q14_new q15 q24 q49 q57 ///
	 q46 q47 date q5 q4 q7 q8 q44 q62 q63 q20
	 

ren rec* *
 
ren q7_995 q7_other
* Mia: added _ar to the name
ren (q3a q13b q13e) (q3a_co_pe_uy_ar q13b_co_pe_uy_ar q13e_co_pe_uy_ar) 
ren q13e_10 q13e_other_co_pe_uy_ar 
ren q14_new q14
ren q15_new q15
ren q19_4 q19_other
ren q21_9 q21_other
ren q28 q28_a
ren q28_new q28_b
ren q42_10 q42_other
ren q43_4 q43_other
ren q45_11 q45_other
ren q66 q64
ren q67 q65
ren time_new time
ren (q46_996 q47_996) (q46_refused q47_refused)
ren (q46_min q47_min) (q46 q47)

* Reorder variables
order q*, sequential
order q*, after(interviewer_id)

* Drop other unecessary variables 
drop intlength interviewerid_recoded

*** Mia added this part ***
*combining q19_pe/q19_co
clonevar q19_co_pe = q19_co
replace q19_co_pe = q19_pe if country == 7
drop q19_co q19_pe
*combining q19_pe/q19_co
clonevar q43_co_pe = q43_co
replace q43_co_pe = q43_pe if country == 7
drop q43_co q43_pe

label define labels24 3 "" 4 "" 5 "", modify //Mia: add this line to match codebook
*****************************
*------------------------------------------------------------------------------*

* Labeling variables 
* Mia: dropped interviewer_gender since we already dropped the variable above
lab var country "Country"
lab var respondent_serial "Respondent Serial (unique within country)"
lab var respondent_id "Respondent ID (unique ID)"
lab var interviewer_id "Interviewer ID"
lab var date "Date of interview"
lab var int_length "Interview length (in minutes)"
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q3a_co_pe_uy_ar "Q3A. CO/PE/UY/AR only: Are you a man or a woman?"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7_other. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q13b_co_pe_uy_ar "Q13B. CO/PE/UY/AR only: Did you seek health care for COVID-19?"
lab var q13e_co_pe_uy "Q13E. CO/PE/UY only: Why didnt you receive health care for COVID-19?"
lab var q13e_other_co_pe_uy "Q13E. CO/PE/UY only: Other"
lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"
lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var q19_co_pe "Q19. CO/PE only: Is this a public or private healthcare facility?" // Mia: changed to CO/PE
lab var q19_uy "Q19. UY only: Is this a public, private, or mutual healthcare facility?"
lab var q19_other "Q19. Other"
lab var q20 "Q20. What type of healthcare facility is this?"
lab var q20_other "Q20. Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
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
lab var q43_co_pe "Q43. CO/PE only: Is this a public or private healthcare facility?" // Mia: changed to CO/PE
lab var q43_uy "Q43. UY only: Is this a public, private, or mutual healthcare facility?"
lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q46_refused "Q46. Refused"
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
lab var q56_pe "Q56. PE only: How would you rate the quality of the social security system?"
lab var q56_uy "Q56. UY only: How would you rate the quality of the mutual healthcare system?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62 "Q62. Respondent's mother tongue or native language"
*lab var q62_other "q62. Other"
lab var q63 "Q63. Total monthly household income"
lab var q64 "Q64. Do you have another mobile phone number besides this one?"
lab var q65 "Q65. How many other mobile phone numbers do you have?"

* Note: Variables not in these data: PSU_ID Interviewer_Language Language, and others 

save "$data_mc/02 recoded data/pvs_co_pe_uy.dta", replace

*------------------------------------------------------------------------------*

********************************* Append data *********************************

u "$data_mc/02 recoded data/pvs_co_pe_uy.dta", clear

tempfile label1
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label1'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label 

append using "$data_mc/02 recoded data/pvs_et_ke_za.dta"

qui do `label1'

tempfile label2
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label2'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/pvs_la.dta"

qui do `label2'

tempfile label3
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label3'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/pvs_it_mx_us.dta"

qui do `label3'

tempfile label4
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label q66_label using `label4'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label q66_label

append using "$data_mc/02 recoded data/pvs_kr.dta"

qui do `label4'

tempfile label5
label save q4_label q5_label q7_label q8_label q20_label q44_label q63_label using `label5'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q63_label

append using "$data_mc/02 recoded data/pvs_ar.dta"

qui do `label5'

* Country
lab def labels0 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" 15 "Republic of Korea" 16 "Argentina (Mendoza)", modify


* Kenya/Ethiopia variables 
ren q19 q19_et_ke_za
lab var q19_et_ke_za "Q19. ET/KE/ZA only: Is this a public, private, or NGO/faith-based facility?"
ren q43 q43_et_ke_za_la
lab var q43_et_ke_za_la "Q43. ET/KE/ZA/LA only: Is this a public, private, or NGO/faith-based facility?"
* NOTE: Q43 also asked like this in Laos
ren q56 q56_et_ke_za 
lab var q56_et_ke_za "Q56. ET/KE/ZA only: How would you rate quality of NGO/faith-based healthcare?"

* Mode
recode mode (3 = 1) (4 = 3)
lab def mode 1 "CATI" 2 "F2F" 3 "CAWI", replace
label val mode mode
lab var mode "Mode of interview (CATI, F2F, or CAWI)"

* Country-specific skip patterns - check this 
recode q19_et_ke_za q56_et_ke_za (. = .a) if country != 5 | country != 3  | country != 9  
recode q43_et_ke_za_la (. = .a) if country != 5 | country != 3  | country != 9 | country != 11
recode q19_uy q43_uy q56_uy (. = .a) if country != 10
recode q56_pe (. = .a) if country != 7
recode q19_co_pe q43_co_pe (. = .a) if country != 2 & country != 7 
recode q6_za q37_za (. = .a) if country != 9
recode q6_la q14_la q15_la q18a_la q19_q20a_la q18b_la q19_q20b_la ///		
		(. = .a) if country != 11
recode q14 q15 (. = .a) if country == 11 //Mia: 4/5 added this line
recode q18 q20 q64 q65 (. = .a) if country == 11 //Mia: dropped q6 since we will do it later with other countries
recode q6_it q19_it q43_it (. = .a) if country != 14
recode q19_mx q43_mx q56a_mx q56b_mx q62_mx (. = .a) if country != 13
recode q62a_us q62b_us q66a_us q66b_us (. = .a) if country != 12
recode q28_c q46a q46b q46b_refused q48_k ///
	   (. = .a) if country != 12 | country != 13 | country != 14	   
recode q66 (. = .a) if country != 13 | country != 14 | country != 15
recode q6_kr q7_kr q19_kr q43_kr (. = .a) if country != 15
recode q7 (. = .a) if country == 15 //Mia: dropped q6 since we will do it later with other countries
* Mia: add the line to recode q6 to .a if the country has country specific q6
*      This might have been done in each individual cleaning program but do it again here to be sure
recode q6 (. = .a) if inlist(country,9,11,14,15) 
recode q3a_co_pe_uy_ar q13b_co_pe_uy_ar q13e_co_pe_uy_ar (. = .a) if country != 2 | country != 7 |  country != 11 | country != 16 
recode q19_ar q43_ar q56a_ar q56b_ar q56c_ar (. = .a) if country != 16 
recode q64 q65 q46_refused q47_refused (. = .a) if country == 15 //Mia: 4/5 added
	   
* Country-specific value labels -edit for ssrs-
lab def Language 2011 "CO: Spanish" 3003 "ET: Amharic" 3004 "ET: Oromo" 3005 "ET: Somali" ///
				 5001 "KE: English" 5002 "KE: Swahili" 7011 "PE: Spanish" 9001 "ZA: English" ///
				 9006 "ZA: Sesotho" 9007 "ZA: isiZulu" 9008 "ZA: Afrikaans" ///
				 9009 "ZA: Sepedi" 9010 "ZA: isiXhosa" 10011 "UY: Spanish" 11001 "LA: Lao" ///
				 11002 "LA: Khmou" 11003 "LA: Hmong" 12009 "US: English" 12010 "US: Spanish" ///
				 13058 "MX: Spanish" 14016 "IT: Italian" 15001 "KR: Korean" 16001 "AR: Spanish"
				 
				 
lab val language Language
lab var language "Language"

* Other value label modifcations
lab def q4_label .a "NA" .r "Refused", modify
lab def q5_label .a "NA" .r "Refused", modify
lab def q6_kr .a "NA" , modify
lab def q7_label .a "NA" .r "Refused", modify
lab def q8_label .a "NA" .r "Refused", modify
lab def covid_vacc_la .a "NA" , modify
lab def q20_label .a "NA" .r "Refused", modify
lab def q44_label .a "NA" .r "Refused", modify
lab def q62_label .a "NA" .r "Refused", modify
lab def q63_label .a "NA" .r "Refused" .d "Don't know", modify
lab def labels16 .a "NA" .r "Refused", modify
lab def labels24 .a "NA" .r "Refused", modify
lab def labels22 .a "NA" .r "Refused", modify
lab def labels23 .a "NA" .r "Refused", modify
lab def labels26 .a "NA" .r "Refused", modify
lab def labels37 11 " AR: Delay to get a turn " .a "NA" .r "Refused", modify
lab def labels39 .a "NA" .r "Refused", modify
lab def labels40 .a "NA" .r "Refused", modify
lab def labels50 .r "Refused", modify
lab def Q19 .a "NA" .r "Refused", modify
lab def Q43 .a "NA" .r "Refused", modify
lab def place_type .a "NA" .r "Refused", modify
lab def fac_owner .a "NA" .r "Refused", modify
lab def fac_type1 .a "NA" .r "Refused", modify
lab def fac_type3 .a "NA" .r "Refused", modify
lab def gender2 3 "AR: Other gender", modify
lab def labels26 10 "AR: Short waiting time to get appointments", modify
 
*** weights ***
drop weight
ren weight_educ weight
lab var weight "Final weight (based on gender, age, region, education)"

*** Code for survey set ***
gen respondent_num = _n 
sort mode psu_id respondent_num
gen short_id = _n if mode == 1 | mode == 3
replace psu_id = subinstr(psu_id, " ", "", .) if mode == 1 | mode == 3
encode psu_id, gen(psu_id_numeric) // this makes a numeric version of psu_id; an integer with a value label 
gen long psu_id_for_svy_cmds = cond(mode==1 | mode==3, 1e5+short_id, 2e5+psu_id_numeric) 
drop short_id psu_id_numeric
label variable psu_id_for_svy_cmds "PSU ID for every respondent (100 prefix for CATI/CAWI and 200 prefix for F2F)"
 
* This will have values 100001 up to 102006 for the Kenya data CATI folks and (if there were 20 PSUs) 200002 to 200021 for F2F  (200001 is skipped because Stata thinks of psu_id_numeric == 1 as being the CATI respondents.
* Each person will have their own PSU ID for CATI and each sampled cluster will have a unique ID for the F2F.
 
* Now the svyset syntax will simply be:
* svyset psu_id_for_svy_cmds [pw=weight], strata(mode)
* or equivalently
* svyset psu_id_for_svy_cmds , strata(mode) weight(weight)

* Keep variables relevant for data sharing and analysis  
* Dropping q37_in and time for now 
drop rim1_gender rim2_age rim3_region w_des w_des_uncapped rim4_educ ///
interviewer_language psu_id interviewer_gender interviewer_id ///
time respondent_num q1_codes

drop region_stratum kebele matrix sum_size_region total dw_psu n_unit dw_unit n_elig dw_ind dw_overall dw_overall_relative rim_region_et rim_age province county sublocation rim_region_ke rim_educ ecs_id rim_gender rim_region rim_education rim_eduction interviewerid_recoded


**** Other Specify Recode ****

* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

*All (Laos and Argentina pending)

gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other type of health insurance?"
gen q13e_other_co_pe_uy_ar_original = q13e_other_co_pe_uy_ar
label var q13e_other_co_pe_uy_ar_original "Q13E. CO/PE/UY only: Other"
	
gen q19_other_original = q19_other
label var q19_other_original "Q19. Other"

gen q19_q20a_other_original = q19_q20a_other
label var q19_q20a_other_original "Q19A. LA only: Other"

gen q19_q20b_other_original = q19_q20b_other
label var q19_q20b_other_original "Q19B. LA only: Other"

gen q20_other_original = q20_other
label var q20_other_original "Q20. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"

gen q43_other_original = q43_other
label var q43_other_original "Q43. Other"

gen q44_other_original = q44_other
label var q44_other_original "Q44. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"	

gen q62_other_original = q62_other
label var q62_other_original "Q62. Other"	

gen q62b_other_us_original = q62b_other_us
label var q62b_other_us_original "Q62B. US only: Other"	
	

*Remove "" from responses for macros to work
replace q19_other = subinstr(q19_other,`"""',  "", .)
replace q43_other = subinstr(q43_other,`"""',  "", .)
replace q45_other = subinstr(q45_other,`"""',  "", .)

foreach i in 2 3 5 7 9 10 12 13 14 15 16 {

ipacheckspecifyrecode using "$data_mc/03 test output/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 	

drop q7_other q13e_other_co_pe_uy_ar q19_other q19_q20a_other_la q19_q20b_other_la q20_other ///
	 q21_other q42_other q43_other q44_other q45_other q62_other q62b_other_us
	 
ren q7_other_original q7_other
ren q13e_other_co_pe_uy_ar_original q13e_other_co_pe_uy_ar
ren q19_other_original q19_other
ren q19_q20a_other_original q19_q20a_other_la
ren q19_q20b_other_original q19_q20b_other_la
ren q20_other_original q20_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q43_other_original q43_other
ren q44_other_original q44_other
ren q45_other_original q45_other
ren q62_other_original q62_other
ren q62b_other_us_original q62b_other_us


* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 
	
*Save recoded data
save "$data_mc/02 recoded data/pvs_appended.dta", replace


/*
*------------------------------------------------------------------------------*

* NOTE: Optional data quality checks 


***************************** Data quality checks *****************************

use "$data_mc\02 recoded data\pvs_appended.dta", clear

* Macros for these commands
gl inputfile	"$data_mc/03 test output/Input/dq_inputs.xlsm"	
gl inputfile_2	"$data_mc/03 test output/Input/dq_inputs_2.xlsm"
gl inputfile_3	"$data_mc/03 test output/Input/dq_inputs_3.xlsm"	
gl inputfile_4	"$data_mc/03 test output/Input/dq_inputs_5.xlsm"
gl inputfile_7	"$data_mc/03 test output/Input/dq_inputs_7.xlsm"		
gl inputfile_9	"$data_mc/03 test output/Input/dq_inputs_9.xlsm"	
gl inputfile_10	"$data_mc/03 test output/Input/dq_inputs_10.xlsm"	
gl inputfile_11	"$data_mc/03 test output/Input/dq_inputs_11.xlsm"	
gl inputfile_13	"$data_mc/03 test output/Input/dq_inputs_13.xlsm"
gl inputfile_14	"$data_mc/03 test output/Input/dq_inputs_14.xlsm"		
gl dq_output	"$output/dq_output.xlsx"
gl dq_output_2	"$output/dq_output_2.xlsx"	
gl dq_output_3	"$output/dq_output_3.xlsx"	
gl dq_output_4	"$output/dq_output_4.xlsx"	
gl dq_output_7	"$output/dq_output_7.xlsx"	
gl dq_output_9	"$output/dq_output_9.xlsx"	
gl dq_output_10	"$output/dq_output_10.xlsx"	
gl dq_output_11	"$output/dq_output_11.xlsx"	
gl dq_output_13	"$output/dq_output_13.xlsx"	
gl dq_output_14	"$output/dq_output_14.xlsx"						
gl id 			"respondent_id"	
gl key			"respondent_serial"	
gl enum			"interviewer_id"
gl date			"date"	
gl time			"time"
gl duration		"int_length"
gl keepvars 	"country"
global all_dk 	"q13b q13e q23 q25_a q25_b q27 q28_a q28_b q30 q31 q32 q33 q34 q35 q36 q38 q50_a q50_b q50_c q50_d q63 q64 q65"
global all_num 	"q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q19_ke_et q19_co q19_pe q19_uy q20 q21 q22 q23 q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q43_ke_et q43_co q43_pe q43_uy q44 q45 q46 q47 q46_min q46_refused q47_min q47_refused q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_ke_et q56_pe q56_uy q57 q58 q59 q60 q61 q62 q63 q64 q65"


*====================== Check start/end date of survey ======================* 


* list $id if $date < date("01-Jul-2020", "DMY") | $date > date("01-Dec-2022", "DMY") 

* list $id if Time > date("18:00:00", "07:00:00") | Time < date("18:00:00", "%tcHH:MM:SS")												
												
* NOTE: The above lines are still not working well for me. It runs - but appears to not be accurate 
* Just leaving in case we decide to add	them back 											
												
*========================== Find Survey Duplicates ==========================* 

 * This command finds and exports duplicates in Survey ID

 
ipacheckids ${id},							///
	enumerator(${enum}) 					///	
	date(${date})	 						///
	key(${key}) 							///
	outfile("${dq_output}") 				///
	outsheet("id duplicates")				///
	keep(${keepvars})	 					///
	sheetreplace							
						

    * Other methods 

	isid $id
	duplicates list $id

*=============================== Outliers ==================================* 
 
* This command checks for outliers among numeric survey variables 
* This code requires an input file that lists variables to check for outliers 

* NOTE: This should be done before dropping outliers 
* The "by" function may not be working

ipacheckoutliers using "${inputfile}",			///
	id(${id})									///
	enumerator(${enum}) 						///	
	date(${date})	 							///
	sheet("outliers")							///
    outfile("${dq_output}") 					///
	outsheet("outliers")						///
	sheetreplace

   
*============================= Other Specify ===============================* 
 
* This command lists all other, specify values
* This command requires an input file that lists all the variables with other, specify text 

use "$data_mc\02 recoded data\pvs_appended.dta", clear

gen interviewer_id = respondent_serial
replace q19_other=trim(q19_other)
replace q20_other=trim(q20_other)
replace q21_other=trim(q21_other)
replace q42_other=trim(q42_other)
replace q43_other=trim(q43_other)
replace q44_other=trim(q44_other)
replace q45_other=trim(q45_other)
replace q62_other=trim(q62_other)
replace q7_other=trim(q7_other)

foreach i in 2 3 5 7 9 10 11 12 13 14 15 {

 preserve
 keep if country == `i'
  
 ipacheckspecify using "$data_mc/03 test output/Input/dq_inputs/dq_inputs_`i'.xlsm",   ///
 id(${id})         ///
 enumerator(${enum})       /// 
 date(${date})         ///
 sheet("other specify")      ///
    outfile("$output/dq_output/dq_output_`i'.xlsx")      ///
 outsheet1("other specify")     ///
 outsheet2("other specify (choices)")  ///
 sheetreplace
 
 loc childvars "`r(childvarlist)'"
 
 restore 
 
}	

*========================= Summarizing All Missing ============================* 

* Below I summarize NA (.a), Don't know (.d), Refused (.r) and true Missing (.) 
* across the numeric variables(only questions) in the dataset by country
* This is helpful to check if cleaning commands above are working (esp skip pattern recode)
   
* Count number of NA, Don't know, and refused across the row 
ipaanycount $all_num, gen(na_count) numval(.a)
ipaanycount $all_dk, gen(dk_count) numval(.d)
ipaanycount $all_num, gen(rf_count) numval(.r)

* Count of total true missing 
egen all_missing_count = rowmiss($all_num)
gen missing_count = all_missing_count  - (na_count + dk_count + rf_count)

* Denominator for percent of NA and Refused 
egen nonmissing_count = rownonmiss($all_num)
gen total_miss = all_missing_count + nonmissing_count

* Denominator for percent of Don't know 
egen dk_nonmiss_count = rownonmiss($all_dk) 
egen dk_miss_count = rowmiss($all_dk) 
gen total_dk = dk_nonmiss_count + dk_miss_count 


preserve

collapse (sum) na_count dk_count rf_count missing_count total_miss total_dk, by(country)
gen na_perc = na_count/total_miss
gen dk_perc = dk_count/total_dk
gen rf_perc = rf_count/total_miss
gen miss_perc = missing_count/total_miss 
lab var na_perc "NA (%)" 
lab var dk_perc "Don't know (%)"
lab var rf_perc "Refused (%)"
lab var miss_perc "Missing (%)"
export exc country na_perc dk_perc rf_perc miss_perc using "$dq_output", sh(missing, replace) first(varl)

restore 

* Other options 
* misstable summarize Q28_A
