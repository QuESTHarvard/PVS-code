* People's Voice Survey data cleaning for Somaliland
* Date of last update: September 11,2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Somaliland. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** SOMALILAND ***********************

* Import data 
import spss "$data/Somaliland/01 raw data/IpsosKY_Somaliland_PVS_F2F_CATI_Fulldata_V2.sav" // used spss data because time vars were off in .dta file
rename *, lower
 
notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

gen reccountry = 22
lab def country 22 "Somaliland"
lab values reccountry country

*ren weight2 weight_educ //for appending purpose - SS: not in current dataset

* Rename some variables, and some recoding if variable will be dropped 

ren q12a q12_a
ren q12b q12_b
ren q15a q15a_so
ren q15b q15b_so
ren q15c q15c_so
ren q27a q27_a
ren q27b q27_b
ren q27c q27_c
ren q27d q27_d
ren q27e q27_e
ren q27f q27_f
ren q27g q27_g
ren q27h q27_h
ren q28a q28_a
ren q28b q28_b
ren q33a q33a_so 
ren q33b q33b_so
ren q33c q33c_so
ren q38a q38_a
ren q38b q38_b
ren q38c q38_c
ren q38d q38_d
ren q38e q38_e
ren q38f q38_f
ren q38g q38_g
ren q38h q38_h
ren q38i q38_i
ren q38j q38_j
ren q38k q38_k
ren q40a q40_a
ren q40b q40_b
ren q40c q40_c
ren q40d q40_d
ren q40e q40_e
ren q40f q40_f
ren q41a q41_a
ren q41b q41_b
ren q41c q41_c

ren duration int_length

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 999

*gen reclanguage = reccountry*1000 + language  // SS: missing from dataset
*gen recinterviewer_id = reccountry*1000 + interviewer_id // SS: missing from dataset

gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 998

gen recq5 = reccountry*1000 + q5  
replace recq5 = .r if q5 == 999

gen recq7 = reccountry*1000 + q7
replace recq7 = .r if q7== 999

gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8== 999

gen recq33 = reccountry*1000 + q33
replace recq33 = .r if q33== 999 

gen recq50 = reccountry*1000 + q50
replace recq50 = .r if q50== 999

gen recq51 = reccountry*1000 + q51
replace recq51 = .r if q51== 999

* Relabel some variables now so we can use the orignal label values

*lab def lang 22001 "SO: Somali" 22002 "SO: Arabic" 22003 "SO: English" 20004 "SO: Others (specify)" 
*lab values reclanguage lang

local q4l labels3
local q5l labels4
local q7l labels6
local q8l labels7
local q33l labels32
local q50l labels46
local q51l labels47

foreach q in q4 q5 q7 q8 q33 q50 q51 {
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
		local recvalue`q' = 22000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 22000+`: word `i' of ``q'val'') ///
									    (`"SO: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}



*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

*generate recdate = dofc(date)
*format recdate %td // SS: date is missing from dataset

*format start_time %tcHH:MM:SS
*format end_time %tcHH:MM:SS

* Converting interview length to minutes so it can be summarized
*format intlength %tcHH:MM:SS
*gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60)

*------------------------------------------------------------------------------*
* Fix mode variable
recode mode (2 = 4)
label define labels0 4 "CAPI",modify // SS: confirm with Todd CAPI = 4
*label values mode mode 

*------------------------------------------------------------------------------*
* Fix q58 labels to match the survey instrument
label define labels45 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it" 2 "There are some good things in our healthcare system, but major changes are needed to make it work better" 3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better" 999 "Refused", replace
*------------------------------------------------------------------------------*
* Generate variables 
*gen respondent_id = "SO" + string(respondent_serial) // SS: respondent_serial missing from dataset

gen q52 = .a

* q18/q19 mid-point var 
gen q18_q19 = q18 
recode q18_q19 (999 = 0) (998 = 0) if q19 == 1
recode q18_q19 (999 = 2.5) (998 = 2.5) if q19 == 2
recode q18_q19 (999 = 7) (998 = 7) if q19 == 3
recode q18_q19 (999 = 10) (998 = 10) if q19 == 4
recode q18_q19 (998 = .r) if q19 == 999

*------------------------------------------------------------------------------*

* Recode refused and don't know values 
recode q14 q18 q21 q22 q23 q27_a q27_b q27_c q27_d q27_f q27_g q27_h cell1 (998 = .d)
	
recode q8 q10 q12_a q12_b q13 q18 q19 q20 q22 q23 q24 q25 q27_a q27_b q27_c q28_a ///
	   q28_b q30 q31b q32 q34 q35 q37 q38_a q38_b q38_c q38_d q38_e q38_g q38_i ///
	   q38_j q39 q40_a q40_b q40_c q40_d q40_e q40_f q41_a q41_b q41_c q42 q43 q45 ///
	   q46 q47 q48 q49 q51 cell2 (999 = .r)

recode q33 (995 = .a)

*------------------------------------------------------------------------------*
* Check for implausible values - review

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
* None

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 country if q20 == 1 & q21 > 0 & q21 < .
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q18_q19 q22 q23) 

list q18_q19 q28_a q28_b if q28_a == 3 & visits_total > 0 & visits_total < . /// 
							  | q28_b == 3 & visits_total > 0 & visits_total < .
* None

* Recoding q28_a and q28_b to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q28_a q28_b (. = .r) if visits_total > 0 & visits_total < . // 0 changes

* list if it is .a but they have visit values in past 12 months 
list q18_q19 q28_a q28_b if q28_a == .a & visits_total > 0 & visits_total < . | q28_b == .a & visits_total > 0 & visits_total < .
* None
  							  			 
* list if they chose other than "I did not get healthcare in past 12 months" but visits_total == 0 
list q18_q19 q28_a q28_b if q28_a != 3 & visits_total == 0 | q28_b != 3 & visits_total == 0
							  					  
* Recoding q28_a and q28_b to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (0 = .a) (1 = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* 275 changes made to q28_a
* 275 changes made to q28_b		
				
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (.r = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* No changes

drop visits_total

recode q28_a q28_b (. = .r) // Added 7-12 SS: N=617 missing for both, highly likely these are participants who refused to answer the questions  

*------------------------------------------------------------------------------*
 
* Recode missing values to NA for intentionally skipped questions 
* do some of these have to be the rec version?

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 
* Note: Some missing values in q1 that should be refused 

* q7 
recode recq7 (. = .a) if q6 == 2 | q6 == .r | q6 == .
recode recq7 (nonmissing = .a) if q6 == 2

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15 (. = .a) if inrange(q14,3,5) | q14== .r 

*q19-22
recode q19_ng recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19_ng == 4 | q19_ng == .r

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
recode q43_ng recq44 q45 recq46 q46_refused recq47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
	   
recode q43_ng recq44 q45 recq46 q46_refused recq47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (nonmissing = .a) if q23 == 0 | q24 == 1
	   	   
recode recq44 (. = .a) if q43_ng == 4 | q43_ng == .r | q43_ng == .a

*q46/q47 refused
recode recq46  (. = .r) if q46_refused == 1
recode recq47  (. = .r) if q47_refused == 1

* add the part to recode q46_refused q47_refused to match other programs
recode q46_refused (. = 0) if recq46 != .
recode q47_refused (. = 0) if recq47 != .

*q65
recode q65 (. = .a) if q64 != 1

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions
recode q6 q11 q13 q18 q25_a q26 q29 q41 ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (.a = .a "NA"), ///
	   pre(rec) label(yes_no)

lab val q46_refused q47_refused yes_no

recode q12 q30 q31 q32 q33 q34 q35 q36 q37_ng q38 ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (3 .d = .d "Don't know") /// 
	   (.a = .a "NA"), ///
	   pre(rec) label(yes_no_dk)
	   
recode q39 q40 /// 
	   (1 = 1 "Yes") (2 = 0 "No") ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r "Refused"), ///
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
	   
recode q50_a q50_b q50_c q50_d q50_e_ng ///
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

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
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
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b recq46 recq47 q65 na_rf	

* Add value labels for q19_ng/q21/q42/q43_ng/q45
label define labels22 .a "NA" .r "Refused",add
label define labels24 .a "NA" .r "Refused",add
label define labels35 .a "NA" .r "Refused",add
label define labels36 .a "NA" .r "Refused",add
label define labels37 .a "NA" .r "Refused",add
	
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop date q2 q3 q6 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q22 q24 q25_a ///
	 q26 q29 q41 q30 q31 q32 q33 q34 q35 q36 q37_ng q38 q39 q40 q41 ///
	 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i ///
	 q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q50_e_ng q51 q52 q53 q54 q55 q56_ng q57 q59 q60 q61 interviewer_gender
	 
ren rec* *

*Reorder variables

order respondent_serial mode respondent_id country weight_educ
order q*, sequential
	
*------------------------------------------------------------------------------*

* Other, specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen q7_other_original = q7_other
label var q7_other_original "Q7. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"	

gen q62_other_original = q62_other
label var q62_other_original "62. Other"	


*Remove "" from responses for macros to work
replace q21_other = subinstr(q21_other,`"""',  "", .)
replace q42_other = subinstr(q42_other,`"""',  "", .)
replace q45_other = subinstr(q45_other,`"""',  "", .)


ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_20.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_serial)	
	
drop q7_other q21_other q42_other q45_other q62_other
	 
ren q7_other_original q7_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q45_other_original q45_other
ren q62_other_original q62_other

*------------------------------------------------------------------------------*

* Country-specific vars for append 
ren q19_ng q19_multi
ren q43_ng q43_multi
ren q56_ng q56_multi

*------------------------------------------------------------------------------*
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
lab var q19_multi "Q19. ET/IN/KE/RO/ZA/NG only: Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q20 "Q20. What type of healthcare facility is this?"
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
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q37_ng "Q37. NG only: Had sexual or reproductive health care such as family planning in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_multi "Q43. ET/IN/KE/RO/ZA/NG only: Is this a public, private, or NGO/faith-based facility?"
lab var q44 "Q44. What type of healthcare facility is this?"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46_refused "Q46. Refused"
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
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q50_e_ng "Q50_E. NG only: How would you rate the quality of care provided for sexual or reproductive health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private healthcare?"
lab var q56_multi "Q56. ET/GR/IN/KE/ZA/NG only: How would you rate quality of NGO/faith-based healthcare?"
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

* Save data
save "$data_mc/02 recoded data/input data files/pvs_ng.dta", replace
