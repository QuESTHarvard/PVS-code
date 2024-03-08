* People's Voice Survey data cleaning for Ethiopia, India, Kenya and South Africa  
* Date of last update: April 2023
* Last updated by: N Kapoor, S Sabwa, M Yu

/*

This file cleans Ipsos data for Ethiopia, India, Kenya and South Africa. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ETHIOPIA, KENYA, SOUTH AFRICA, & INDIA ***********************

* Import raw data 
u "$data_mc/01 raw data/PVS_all countries_weighted_4-18-2023.dta"


/*
*Interviewer_Language is in 31 different variables - Mia to create loop here 
gen Interviewer_Language = .

forvalues i = 1/6 {
	replace Interviewer_Language = `i' if Interviewer_Language0`i' == 1
}

forvalues i = 11/31 {
	replace Interviewer_Language = `i' if Interviewer_Language`i' == 1
}
*/

*Ask Neena if we should correct this in the data dictionary
* label define Q2 2 "18-29", modify


*Edited income orders
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
		   (24 = 24 "<3000 Indian National Rupee (INR)") ///
		   (25 = 25 "3000-10,000 INR") ///
		   (26 = 26 "10,001-20,000 INR") ///
		   (27 = 27 "20,001-30,000 INR") ///
		   (28 = 28 "30,001-40,000 INR") ///
		   (29 = 29 "40,001-50,000 INR") ///
		   (30 = 30 ">50,000 INR") ///
		   (996 = 996 "Refused") (997 = 997 "Don't know"), gen(q63)
		   
drop Q63
ren q63 Q63

*Change all variable names to lower case
rename *, lower 

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

* Relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY"
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

*------------------------------------------------------------------------------*


*------------------------------------------------------------------------------*

* Fix interview length variable and other time variables 

* Converting interview length to minutes so it can be summarized
gen int_length = intlength / 60
drop intlength

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
recode q6_za (. = .a) if country != 9
*------------------------------------------------------------------------------*

*NOTE: May update and remove this code in the future, as it could be recoded in
*	   section below  

* Recode all Refused and Don't know responses

* In raw data, 997 = "don't know" 
recode q23 q25_a q25_b q27 q28 q28_new q30 q31 q32 q33 q34 q35 q36 q38 ///
	   q66 q67 (997 = .d)
	   
*NOTE: currently in data q37_za "don't know" is category 3  

* In raw data, 996 = "refused" 
recode q1 q2 q3 q6 q6_za q9 q10 q11 q12 q13 q14_new q15_new q16 q17 /// 
	   q18 q19 recq20 q21 q22 q23 q23_q24 q24 q25_a q25_b q26 q27 q28 q28_new q29 q30 /// 
	   q31 q32 q33 q34 q35 q36 q37_za q37_in q38 q39 q40 q41 q42 q43 q45 q46 q47 ///
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

* List if yes to q26: "all visits in the same facility" but q27: "how many different healthcare facilities did you go to" is more than 0
list q26 q27 country if q26 == 1 & q27 > 0 & q27 < .

* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28 q28_new)

list q23_q24 q39 q40 country if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
							  
* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* 70 changes to q39 and 63 changes to q40

* list if it is .a but they have visit values in past 12 months 
list q23_q24 q39 q40 country if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* this is fine
							  
* list if they chose other than "I did not get healthcare in past 12 months" but visits_total == 0 
list q23_q24 q39 q40 country if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* 2,244 changes to q30 and 2,255 changes to q40

drop visits_total
* did not check if q39 == 3 but q40 not since the previous steps should have changed 3 to .r if have visit.  


*cleaning up "other specify" data
**add "lic" based on prashant's comment in the other specify data that this is life insurance schemes and not health insurance
replace q6 = 2 if q7_other == "no health insurance" & country == 4 | ///
				  q7_other == "I Don't know" & country == 4 | ///
				  q7_other == "I don't know" & country == 4 | ///
				  q7_other == "I don;t know" & country == 4 | ///
				  q7_other == "LIC" & country == 4 | ///
				  q7_other == "LIC Insurance" & country == 4 | ///
				  q7_other == "LIC JEEVAN BIMA" & country == 4 | ///
				  q7_other == "LIC Jeevan Bima" & country == 4 | ///
				  q7_other == "LIC Life Insurance" & country == 4 | ///
				  q7_other == "jeevan jyoti" & country == 4 | ///
				  q7_other == "lic" & country == 4 | ///
				  q7_other == "LIFE COVER" & country == 4

*------------------------------------------------------------------------------*

* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 
* Note: Some missing values in q1 that should be refused 

* q7 
recode recq7 (. = .a) if q6 == 2 | q6 == .r | q6_za == 2 | q6_za == .r
* one person answered no to q6 but answered q7
recode recq7 (nonmissing = .a) if q6 == 2

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15_new (. = .a) if inrange(q14_new,3,5) | q14_new == .r 

*q19-22
recode q19 recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19 == 4 | q19 == .r

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r 
recode q25_a (. = .a) if q23 != 1
* one person answered 2 to q23 but was asked q25_a
recode q25_a (nonmissing = .a) if q23 != 1
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r

* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r 
recode q32 (. = .a) if q3 != 2 | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
* There is one case where both q23 and q24 are missing, but they answered q43-49
recode q43 recq44 q45 q46 q46_min q46_refused q47 q47_min q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
recode q43 recq44 q45 q46 q46_min q46_refused q47 q47_min q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (nonmissing = .a) if q23 == 0 | q24 == 1
	   
recode recq44 (. = .a) if q43 == 4 | q43 == .r

recode q45 (995 = 4)

*q46/q47 refused
recode q46 q46_min (. = .r) if q46_refused == 1
recode q47 q47_min (. = .r) if q47_refused == 1


* add the part to recode q46_refused q47_refused to match other programs
recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .


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
	   
lab val q46_refused q47_refused yes_no

recode q30 q31 q32 q33 q34 q35 q36 q38 q37_za q37_in q66 ///
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
recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14_new ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

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


label define Q45 4 "Other, specify", modify
*add .a/.r labels for q21,q42/q43/q44/q45/q19/q20
label define q4_label .a "NA" .r "Refused", add
label define q5_label .a "NA" .r "Refused", add
label define q7_label .a "NA" .r "Refused", add
label define q8_label .a "NA" .r "Refused", add
label define Q19 .a "NA" .r "Refused", add
label define q20_label .a "NA" .r "Refused", add
label define Q21 .a "NA" .r "Refused", add
label define Q42 .a "NA" .r "Refused", add
label define Q43 .a "NA" .r "Refused", add
label define q44_label .a "NA" .r "Refused", add
label define Q45 .a "NA" .r "Refused", add
*add .r for q62
label define q62_label .r "Refused", add
*add .d/.r for q63
label define q63_label .d "Don't Know" .r "Refused", add

*language loses value labels when it's being generated with country code - is there a better fix for this above?
label define language 3003 "ET: Amharic" 3004 "ET: Oromo" 3005 "ET: Somali" ///
					  4001 "IN: English" 4011 "IN: Hindi" 4012 "IN: Kannada" 4013 "IN: Tamil" 4014 "IN: Bengali" 4015 "IN: Telugu" ///
					  5001 "KE: English" 5002 "KE: Swahili" ///
					  9001 "ZA: English" 9006 "ZA: Sesotho" 9007 "ZA: isiZulu" 9008 "ZA :Afrikaans" ///
					  9009 "ZA: Sepedi" 9010 "ZA: isiXhosa"

label val reclanguage language

*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
drop interviewer_gender q2 q3 q6 q6_za q11 q12 q13 q18 q25_a q26 q29 q41 q30 q31 /// 
	 q32 q33 q34 q35 q36 q38 q66 q39 q40 q9 q10 q22 q37_za q37_in q48_a q48_b q48_c q48_d ///
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
order q*, after(interviewer_id) 

*4/13: dropping interviewer language for now until we're able to clean and recode:

drop interviewer_language01 interviewer_language02 interviewer_language03 interviewer_language04 interviewer_language05 interviewer_language06 interviewer_language21 interviewer_language22 interviewer_language23 interviewer_language24 interviewer_language25 interviewer_language26 interviewer_language27 interviewer_language28 interviewer_language29 interviewer_language11 interviewer_language12 interviewer_language13 interviewer_language14 interviewer_language15 interviewer_language16 interviewer_language17 interviewer_language18 interviewer_language19 interviewer_language20 interviewer_language30 interviewer_language31

drop weight

* adding this so other specify code can run - SS 
ren q19 q19_et_in_ke_za
ren q43 q43_et_in_ke_za

*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other type of health insurance?"
	
gen q19_other_original = q19_other
label var q19_other_original "Q19. Other"

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


foreach i in 3 4 5 9 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q19_other q20_other ///
	 q21_other q42_other q43_other q44_other q45_other q62_other
	 
ren q7_other_original q7_other
ren q19_other_original q19_other
ren q20_other_original q20_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q43_other_original q43_other
ren q44_other_original q44_other
ren q45_other_original q45_other
ren q62_other_original q62_other

order q*, sequential
order respondent_serial respondent_id mode country language date time int_length weight_educ



*------------------------------------------------------------------------------*

* Country-specific vars for append 
ren q19_et_in_ke_za q19_multi
ren q37_in q37_gr_in_ro
ren q43_et_in_ke_za q43_multi
ren q56 q56_multi

*------------------------------------------------------------------------------*

* Labeling variables 
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
lab var q19_multi "Q19. ET/IN/KE/ZA only: Is this a public, private, or NGO/faith-based facility?"
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
lab var q37_gr_in "Q37. GR/IN only: Received an oral cancer screening, like a visual inspection of the mouth"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_multi "Q43. ET/IN/KE/RO/ZA only: Is this a public, private, or NGO/faith-based facility?"
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
lab var q56_multi "Q56. ET/GR/IN/KE/ZA only: How would you rate quality of NGO/faith-based healthcare?"
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

save "$data_mc/02 recoded data/input data files/pvs_et_in_ke_za.dta", replace

*------------------------------------------------------------------------------*
