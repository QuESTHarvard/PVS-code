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
ren q46_gr2 q46a
ren q46_gr q46b // double check units of raw data
ren q46_gr_refused  q46b_refused
ren q56 q56_et_gr_in_ke_za
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

drop ecs_id time_new intlength q2 q4 q5 q8 q19 q20 q20_b q20_b_other q20_c q20_c_other q20_d q20_d_other q43_gr q44 q44_b q44_b_other q44_c q44_c_other q46 q47 q63 q66_a q66_b q69 q69_codes rim_age rim_gender q4_weight rim_region q8_weight rim_education dw_overall sample_type interviewer_id interviewer_gender interviewer_language respondent_serial country language


*------------------------------------------------------------------------------*

* Generate variables 
gen q2 = .a
gen q64 = .a 

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
	   q40 q42 q43 q45 q46a q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h ///
	   q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 ///
	   q56_et_gr_in_ke_za (996 = .r)	

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

*q28_c
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r

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
