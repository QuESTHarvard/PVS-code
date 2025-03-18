* People's Voice Survey data cleaning for Ethiopia, India, Kenya and South Africa - Wave 2
* Date of last update: March 2024
* Last updated by: S Sabwa

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
import spss using "$data/ET IN KE ZA wave2/01 raw data/24-065373-01-02_Harvard_2024_Merged_weighted_SPSS.sav", case(lower)


*Label as wave 2 data:
gen wave = 2

*Deleting unneccessary vars:
drop shell_chainid dw_overall_relative rim_age rim_sex rim_region rim_education qc_short


*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

rename (q12a q12b) (q12_a q12_b)

rename (q27a q27b q27c q27d q27e q27f q27g q27h) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h)

rename (q28a q28b) (q28_a q28_b)

rename (q38a q38b q38c q38d q38e q38f q38g q38h q38i q38j q38k) ///
	   (q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k)
	   
rename (q40a q40b q40c q40d q41a q41b q41c) (q40_a q40_b q40_c q40_d q41_a q41_b q41_c)

*Edit income var - continue from V1.0 values, add "V1.0" to labels
recode q51 (101 = 101  "< Ksh 1,000") ///
		   (102 = 102 "Ksh 1,001 – 3,000") ///
		   (103 = 103 "Ksh 3,001 - 5,000") ///
		   (104 = 104 "Ksh 5,001 – 7,000") ///
		   (105 = 105 "Ksh 7,001 - 10,000") ///
		   (106 = 106 "Ksh 10,001 – 12,000") ///
		   (107 = 107 "Ksh 12,001 - 15,000") ///
		   (4 = 108 "Ksh 15,001 - 20,000") /// 
           (5 = 109 "Ksh 20,001 - 40,000") /// 
		   (108 = 110 "> Ksh 40,000") ///
		   (9 = 111 "< 1001 Eth.Birr") /// NOTE: this was <1000 Birr in wave 1
		   (10 = 112 "1001 - 2000  Eth.Birr") /// NOTE: this was 1000-3000 Birr
		   (11 = 113 "2001 – 3000 Eth.Birr") /// NOTE: this was 3001-5000 Birr
		   (12 = 114 "3001 – 5000 Eth.Birr") /// NOTE: this was 5001–10000 Birr
		   (13 = 115 "5001 - 10000 Eth.Birr") /// NOTE: this was 10001-20000 Birr
		   (14 = 116 "10,001 - 20,000 Eth.Birr") /// NOTE: this was Greater than 20000 Birr
		   (99 = 117 "> 20,000 Eth.Birr") ///
		   (23 = 118 "No income") /// same
		   (15 = 119 "<R751") /// NOTE: this was <R750 in wave 1
		   (16 = 120 "R751 - R1500") /// same as wave 1
		   (17 = 121 "R1501 - R3000") /// same as wave 1
		   (18 = 122 "R3001 - R6000") /// same as wave 1
		   (19 = 123 "R6001 - R11000") /// same as wave 1
		   (20 = 124 "R11001 - R27000") /// same as wave 1
		   (21 = 125 "R27001 - R45000") /// same as wave 1
		   (22 = 126 "R>45000") /// same as wave 1
		   (24 = 127 "<3001 INR") /// NOTE: this was less than <3000 INR in wave 1
		   (25 = 128 "3,001 - 5,000 INR") /// NOTE: this was 3000 - 10000 INR in wave 1
		   (26 = 129 "5,001 - 10,000 INR") /// NOTE: this was 10,001-20,000 INR in wave 1
		   (27 = 130 "10,001 - 15,000 INR") /// NOTE: this was 20,001-30,000 INR in wave 1
		   (28 = 131 "15,001 - 20,000 INR") /// NOTE: this was 30,001-40,000 INR in wave 1
		   (29 = 132 "20,001 - 30,000 INR INR") /// NOTE: this was 40,001-50,000 INR in wave 1
		   (30 = 133 "30,001 - 40,000 INR") /// NOTE: this was >50,000 INR in wave 1
		   (109 = 134 "40,001 - 50,000 INR") ///
		   (110 = 135 "> 50,000 INR") ///
		   (999 = .r "Refused") (998 = .d "Don't know"), gen(recq51)
		   
drop q51
ren rec* *

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = country*1000 + language  
*gen recinterviewer_id = country*1000 + interviewer_id *interviewer_id in a string fmt

gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 999

gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 999

gen recq8 = country*1000 + q8
replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
replace recq15 = .r if q15== 999
replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
replace recq33 = .r if q33== 999 
replace recq33 = .d if q33== 998

gen recq50 = country*1000 + q50 
replace recq50 = .r if q50== 999

gen recq51 = country*1000 + q51
*replace recq51 = .r if q51== 999
*replace recq51 = .d if q51== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

** SS: eventually change wave 1/v1.0 labels to new v2.0 ordering/add labels to data dictionary?
local q4l labels9
local q5l labels8
local q7l labels11
local q8l labels13
local q15l labels21
local q33l labels48
local q50l labels80
local q51l recq51

foreach q in q4 q5 q7 q8 q15 q33 q50 q51 {
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

drop q4 q5 q7 q8 q15 q33 q50 q51 language
ren rec* *

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

* Converting interview length to minutes so it can be summarized
gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60)
drop intlength

*SS: Re-format date var? currently in %tcDD-Mon-CCYY fmt 
*format date %tdD_M_CY

* Generate new var for insurance in ZA since question asked differently - confirm with Todd
gen q6_za = q6 if country == 9
replace q6 = .a if country == 9
recode q6_za (. = .a) if country != 9

*------------------------------------------------------------------------------*
* Generate variables 

replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 

* q18/q19 mid-point var 
*SS: note, it looks like q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* In raw data, 997 = "don't know" 
recode q14 q18 q21 q22 q23 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h ///
	   q32 cell1 cell2 (998 = .d)
	   
*NOTE: currently in data q37_za "don't know" is category 3  

* In raw data, 996 = "refused" 
recode q1 q3 q6 q9 q10 q11 q12a q12b q13 q14 q16 q17 q18 q19 q20 q21 ///
	   q22 q23 q24 q25 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a ///
	   q28_b q29 q30 q31a q31b q32 q34 q35 q36 q37 q38_a q38_b q38_c ///
	   q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b q40_c ///
	   q40_d q41_a q41_b q41_c q42 q43 q44 q45 q46 q47 q48 q49 cell1 ///
	   cell2 q6_za (999 = .r)	
	   
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
*N=8 people, ask Todd to confirm how I cleaned this:
replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .
*SS: N=4 with issues, this is how we've fixed it in the past
recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=100 changes

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions

*q1/q2 - no missing data

* q7 
recode q7 (. = .a) if q6 == 0 | q6 == .r | q6 == .
recode q7 (nonmissing = .a) if q6 == 0

*q14-17
recode q14 q15 q16 q17 (. = .a) if q13 !=1

* NA's for q19-21 
recode q19 (. = .a) if q18 != .

recode q20 (. = .a) if q18 == 0 | q18 == 1 | q18 ==. | q19 == . | q19 == .a

recode q21 (. = .a) if q20 !=0 | q18 == 0 | q18 == 1 | q19 == 2 | q19 == . | q19 == .a

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0 

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=1 | q1 <30

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q19 == 0 

* q30
recode q30 (. = .a) if q29 !=1

* q32-33
recode q32 q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == . | q19 == . | q19 == .a

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:


*fix q19
recode q19 (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
		   (998 = 998 ".d") (999 = 999 ".r"), pre(rec) label(q19_label)
drop q19


*Fix: label define q38 .a "NA" .d "Don't know" .r "Refused",add

*------------------------------------------------------------------------------*
* Renaming variables 
* Rename variables to match question numbers in current survey

ren rec* *

*Reorder variables
order q*, sequential
order respondent_id weight respondent_serial country // add mode back in

*------------------------------------------------------------------------------*

* Other specify recode 
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

*------------------------------------------------------------------------------*

/* Country-specific vars for append - What happened to these variables?
ren q19_et_in_ke_za q19_multi
ren q37_in q37_gr_in_ro
ren q43_et_in_ke_za q43_multi
ren q56 q56_multi */

*------------------------------------------------------------------------------*
* Label variables - double check matches the instrument					
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
lab var q14 "Q14. Is this a public, private, NGO, mission or faith-based facility?"
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
label variable q32 "Q32. Was the facility from where you utilized the services public, private, mission or faith based or NGO/INGO managed facility?"
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

*save "$data_mc/02 recoded data/input data files/pvs_et_in_ke_za_wave2.dta", replace

*------------------------------------------------------------------------------*

