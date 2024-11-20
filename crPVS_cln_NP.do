* People's Voice Survey data cleaning for Nepal
* Date of last update: November 4 ,2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Nepal. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** NEPAL ***********************

* Import data 
use "$data/Nepal/01 raw data/Nepal_PVS_clean_weighted.dta", clear

* data cleaning:
*empty vars:
drop q28 q40 q41 q27_001 q27_header q31 q38  

*confirm with Todd we should drop these:
drop q4_1 q4_1_1 religion other_religion

drop q3 // confirm malefemale is what we want to use, it looks more cleaned up

*dropping variables used for weight calc
drop urbanrural_ed urbanrural_age malefemale_reg malefemale_ed urbanrural education 

*dropping until we figure out if we want to keep these vars (multicheckbox)
drop q052_1_1_1 q052_1_1_2 q052_1_1_17 q052_1_1_3 q052_1_1_4 q052_1_1_5 q052_1_1_6 q052_1_1_7 q052_1_1_8 q052_1_1_9 q052_1_1_10 q052_1_1_11 q052_1_1_12 q052_1_1_13 q052_1_1_14 q052_1_1_16 q052_1_1_999 q052_1_1_15 q052_1_1_1_1

*confirm if I should recode into a new var (multicheckbox)
drop q51_1 q51_2 q51_3 q51_4 q51_5 q51_6 q51_7 q51_8 q51_9 q51_10 q51_999 q51_12

*confirm ok dropping - we have a region var
drop muni muntype ward district 

*dropping their version of age/education categories (only 3 levels):
drop age_cat edu_cat

*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

gen reccountry = 23
lab def country 23 "Nepal"
lab values reccountry country

ren wgt weight

rename province q4 // confirm this is the correct var to use
rename region q5 // SS: Team created derived var, confirm this is q5

rename malefemale q3
rename SNo respondent_serial 
rename q4_3_1 language_other
rename q7_1 q7_other
rename q12_1 q12_a
rename q12_2 q12_b

rename q14 q14_np

rename q14_1 q14_other
rename q15_1 q15_other
rename q16_1 q16_other
rename q24_1 q24_other

rename q27_1 q27_a
rename q27_2 q27_d
rename q27_3 q27_e
rename q27_4 q27_f
rename q27_5 q27_g
rename q27_6 q27_b
rename q27_7 q27_c
rename q27_8 q27_h

rename q28_1 q28_a
rename q28_2 q28_b

rename q30_1 q30_other
rename q31_1 q31_a
rename q31_2 q31_b

rename q32 q32_np
rename q32_1 q32_other
rename q33_1 q33_other
rename q34_1 q34_other

rename q38_1 q38_a 
rename q38_2 q38_b
rename q38_3 q38_c
rename q38_4 q38_d
rename q38_5 q38_e
rename q38_6 q38_f
rename q38_7 q38_g
rename q38_8 q38_h
rename q38_9 q38_i
rename q38_10 q38_j
rename q38_11 q38_k

rename q40_1 q40_a
rename q40_2 q40_b
rename q40_3 q40_c
rename q40_4 q40_d

rename q41_1 q41_a
rename q41_2 q41_b
rename q41_3 q41_c

rename q44 q44_multi

rename q50 q51
rename q052 q52a_np
rename q052_1 q52b_np

/*SS: multicheckbox field, confirm with Todd best way to deal with this:
rename q052_1_1_1 q52_1_np // Federal Hospital
rename q052_1_1_2 q52_2_np // Provincial Hospital 
rename q052_1_1_17 q52_17_np // District Hospital
rename q052_1_1_3 q52_3_np // Local Hospital
rename q052_1_1_4 q52_4_np // Faith or Mission Hospital
rename q052_1_1_5 q52_5_np // Private Hospital
rename q052_1_1_6 q52_6_np // Health post
rename q052_1_1_7 q52_7_np // PHCCs
rename q052_1_1_8 q52_8_np // UHPC
rename q052_1_1_9 q52_9_np // UHC
rename q052_1_1_10 q52_10_np  // CHU
rename q052_1_1_11 q52_11_np // Clinic
rename q052_1_1_12 q52_12_np // Polyclinic
rename q052_1_1_13 q52_13_np // Medical hall
rename q052_1_1_14 q52_14_np // NGO/INGO based HFs
rename q052_1_1_16 q52_16_np // Autonomous Hospitals (like BPKIHS, PAHS, NAMS)
rename q052_1_1_999 q52_999_np // Refused
rename q052_1_1_15 q52_15_np // Other
rename q052_1_1_1_1 q52_np_other // Other, specify (string text) */

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = reccountry*1000 + language  
*gen recinterviewer_id = reccountry*1000 + interviewer_id // SS: missing from dataset

gen recq4 = reccountry*1000 + q4
*replace recq4 = .r if q4 == 998

gen recq5 = reccountry*1000 + q5  
*replace recq5 = .r if q5 == 999

gen recq7 = reccountry*1000 + q7
*replace recq7 = .r if q7== 999

gen recq8 = reccountry*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = reccountry*1000 + q15

gen recq33 = reccountry*1000 + q33
*replace recq33 = .r if q33== 999 

*gen recq50 = reccountry*1000 + q50 // confirm no q50 var
*replace recq50 = .r if q50== 999

gen recq51 = reccountry*1000 + q51
replace recq51 = .r if q51== 999

* Relabel some variables now so we can use the orignal label values

lab def lang 23001 "NP: Nepali" 23002 "NP: Maithali" 23003 "NP: Newari" 23004 "NP: Bhojpuri" ///
			 23005 "NP: Tharu"  23006 "NP: Tamang" 23007 "NP: Doteli" 23008 "NP: Other"
lab values reclanguage lang

local q4l province
local q5l region
local q7l q7
local q8l education
local q15l q15
local q33l q15
*local q50l labels46
local q51l q50

foreach q in q4 q5 q7 q8 q15 q33 q51 {
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
		local recvalue`q' = 23000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 23000+`: word `i' of ``q'val'') ///
									    (`"NP: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

drop q4 q5 q7 q8 q15 q33 q51 language 
ren rec* *

*------------------------------------------------------------------------------*
* Generate variables 
gen respondent_id = "NP" + string(respondent_serial) 

*gen q52 = .a
*gen q2 = .a

* q18/q19 mid-point var 
*SS: note, it looks like q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (. = 0) if q19 == 1
recode q18_q19 (. = 2.5) if q19 == 2
recode q18_q19 (. = 7) if q19 == 3
recode q18_q19 (. = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode refused and don't know values -NA in this dataset
*------------------------------------------------------------------------------*
* Check for implausible values - review

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
*N=6 people, ask Todd to confirm how I cleaned this:
replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
*SS: N=9 people with q21 == 1 but "no" to q20
recode q21 (1 = 0) if q20 ==2

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .
*SS: N=4 with issues, this is how we've fixed it in the past
recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=131 changes

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions - SS:check q18,q26,q41_a q41_b q41_c, q42,q43,q44,q45 q46,q47,q51,q52b_np 

*q1/q2 - no missing data

* q7 
recode q7 (. = .a) if q6 == 0 | q6 == .r | q6 == .
recode q7 (nonmissing = .a) if q6 == 0

*q14-17
recode q14_np q15 q16 q17 (. = .a) if q13 !=1

* NA's for q19-21 
recode q19 (. = .a) if q18 != .

recode q20 (. = .a) if q18 == 0 | q18 == 1 | q18 ==. | q19 == . | q19 == .a

recode q21 (. = .a) if q20 !=0 | q18 == 0 | q18 == 1 | q19 == 2 | q19 == . | q19 == .a

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0 

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=2 | q1 <30 // Female is currently coded as 2 in the dataset, will recode to 1 below.

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q19 == 0 

* q30
recode q30 (. = .a) if q29 !=1

* q32-33
recode q32_np q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == . | q19 == . | q19 == .a

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

***recode q3 values 
recode q3 (1 = 0 "Male") (2 = 1 "Female"), pre(rec) label(gender)
drop q3

lab def q16_label 1 "Low cost" 2 "Short distance" 3 "Short waiting time" ///
				  4 "Good healthcare provider skills" ///
				  5 "Staff shows respect" 6 "Medicines and equipment are available" ///
				  7 "Only facility available" ///
				  8 "Covered by insurance" 9 "Other, specify" ///
				  15 "SO: Determined by the family in the cities " .a "NA" ///
				 .d "Don't Know" .r "Refused"
lab val q16 q16_label

*fix q19
recode q19 (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
		   (998 = 998 ".d") (999 = 999 ".r"), pre(rec) label(q19_label)
drop q19

*fix order of q20/q21
recode q20 (2 = 1 "Yes") (1 = 0 "No") (.r = .r "Refused") (.a = .a "NA"), ///
	   pre(rec) label(yes_no)
drop q20 
	   
recode q30 (8 = 10)
lab def q30_label 1 "High cost (e.g., high out of pocket payment, not covered by insurance)"  ///
				 2 "Far distance (e.g., too far to walk or drive, transport not readily available)" ///
				 3 "Long wait time (e.g., long line to access facility, long wait for the provider)" ///
				 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)" ///
				 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)" ///
				 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)" ///
				 7 "Illness not serious enough" 10 "Other (specify)" .a "NA" .d "Don't Know" .r "Refused"
lab val q30 q30_label				 

* Add value labels 
label define q14 .a "NA" .d "Don't know" .r "Refused",add	
label define q15_label .a "NA" .d "Don't know" .r "Refused",add	 
label define q17 .a "NA" .d "Don't know" .r "Refused",add	
label define q19 .a "NA" .d "Don't know" .r "Refused",add	
label define q20 .a "NA" .d "Don't know" .r "Refused",add	 
label define q21 .a "NA" .d "Don't know" .r "Refused",add	
label define q24 .a "NA" .d "Don't know" .r "Refused",add	  
label define q25 .a "NA" .d "Don't know" .r "Refused",add
label define q27 .a "NA" .d "Don't know" .r "Refused",add	  
label define q28 .a "NA" .d "Don't know" .r "Refused",add
label define q33_label .a "NA" .d "Don't know" .r "Refused",add
label define q34 .a "NA" .d "Don't know" .r "Refused",add
label define q35 .a "NA" .d "Don't know" .r "Refused",add
label define q36 .a "NA" .d "Don't know" .r "Refused",add
label define q37 .a "NA" .d "Don't know" .r "Refused",add
label define q38 .a "NA" .d "Don't know" .r "Refused",add

*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q33_label q33_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
lab val q33 q33_label2
lab val q51 q51_label2

label drop q4_label q5_label q33_label q51_label

*------------------------------------------------------------------------------*
* Renaming variables 
* Rename variables to match question numbers in current survey

ren rec* *

*Reorder variables
order q*, sequential
order respondent_id weight respondent_serial country // add mode back in

*------------------------------------------------------------------------------*
* Label variables					
lab var country "Country"
lab var weight "Weight"
lab var respondent_serial "Respondent Serial #"
*lab var int_length "Interview length (minutes)" 
*lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"
*lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
*lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab var q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. By longstanding, I mean illness, health problem, or mental health problem which has lasted or is expected to last for six months or more."
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or provider's group you usually go to?" 
lab var q14_np "Q14. Is this a public, private, NGO, mission or faith-based facility?"
lab var q15 "Q15. Considering the organization of health facilities in Nepalese context, what type of facility is that?"
label variable q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
label variable q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label variable q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label variable q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label variable q20 "Q20. You said you made * visits. Were they all to the same facility?"
label variable q21 "Q21. How many different healthcare facilities did you go to in total?"
label variable q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label variable q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label variable q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
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
label variable q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label variable q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label variable q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label variable q30 "Q30. The last time this happened, what was the main reason?"
label variable q31_a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label variable q31_b "Q31b. Sell items to pay for healthcare"
label variable q32_np "Q32. Was the facility from where you utilized the services public, private, mission or faith based or NGO/INGO managed facility?"
label variable q33 "Q33. What type of healthcare facility is this?"
label variable q34 "Q34. What was the main reason you went?"
label variable q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label variable q36 "Q36. How long did you wait in days, weeks, or months between scheduling the appointment and seeing the health care provider?"
label variable q37 "Q37. At this most recent visit, once you arrived at the facility, approximately how long did you wait before seeing the provider?"
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
label variable q40_a "Q40a. How would you rate the quality of care during pregnancy and childbirth like antenatal care, postnatal care"
label variable q40_b "Q40b. How would you rate the quality of childcare such as care of healthy children and treatment of sick children"
label variable q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label variable q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label variable q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label variable q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label variable q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label variable q42 "Q42. How would you rate the quality of government or public healthcare system in your country?"
label variable q43 "Q43. How would you rate the quality of the private for-profit healthcare system in your country?"
label variable q44_multi "Q44. How would you rate quality of NGO/faith-based healthcare?"
label variable q45 "Q45. Is your country's health system is getting better, staying the same or getting worse?"
label variable q46 "Q46. Which of these statements do you agree with the most?"
label variable q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label variable q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label variable q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
*label variable q50 "Q50. What is your native language or mother tongue?"
label variable q51 "Q51. Total monthly household income"
label variable q52a_np "Q52a. How aware are you of Basic Health package of services provided free o"
label variable q52b_np "Q52b. Have you received any such Basic Health package of services availabl"

*drop until confirmed with Todd if we want to look at this data:
drop q7_other q14_other q15_other q16_other q24_other q30_other q32_other q33_other q34_other language_other

*------------------------------------------------------------------------------*
* Save data
save "$data_mc/02 recoded data/input data files/pvs_np.dta", replace
