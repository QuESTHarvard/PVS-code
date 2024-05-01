* People's Voice Survey data append  
* Date of last update: August 2023
* Last updated by: N Kapoor, S Sabwa, M Yu

/*

	This file appends PVS datasets cleaned separately. 
	Country-specific or dataset-specific variables or values are modified as needed. 
	It also recodes other, specify values using IPA check command. 

*/

********************************* PVS V1 *********************************

u "$data_mc/02 recoded data/input data files/pvs_co_pe_uy.dta", clear

tempfile label1
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label1'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label 

append using "$data_mc/02 recoded data/input data files/pvs_et_in_ke_za.dta"

qui do `label1'

tempfile label2
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label2'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_la.dta"

qui do `label2'

tempfile label3
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label3'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_it_mx_us.dta"

qui do `label3'

tempfile label4
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label q66_label using `label4'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label q66_label

append using "$data_mc/02 recoded data/input data files/pvs_kr.dta"

qui do `label4'

tempfile label5
label save q4_label q5_label q7_label q8_label q20_label q44_label q63_label using `label5'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_ar.dta"

qui do `label5'

tempfile label6
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label6'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_gb.dta"

qui do `label6'

tempfile label7
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label7'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_gr.dta"

qui do `label7'

tempfile label8
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label8'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_ro.dta"

qui do `label8'

tempfile label9
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label9'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label

append using "$data_mc/02 recoded data/input data files/pvs_ng.dta"

qui do `label9'

* Country
lab def labels0 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" 15 "Republic of Korea" 16 "Argentina (Mendoza)" ///
				17 "United Kingdom" 18 "Greece" 19 "Romania" 20 "Nigeria", modify

* Mode
recode mode (3 = 1) (4 = 3)
lab def mode 1 "CATI" 2 "F2F" 3 "CAWI", replace
label val mode mode
lab var mode "Mode of interview (CATI, F2F, or CAWI)"

* Country-specific skip patterns - check this 
recode q19_multi q56_multi (. = .a) if country != 3  | country != 18 | country != 4 | ///
															country != 5 | country != 19 | country != 9 | country != 20
recode q43_multi (. = .a) if country != 3 | country != 4 | country != 5 | country != 19 | country != 9 | country != 20
recode q56_pe (. = .a) if country != 7
recode q19_co_pe q43_co_pe (. = .a) if country != 2 & country != 7 
recode q6_za q37_za (. = .a) if country != 9
recode q6_la q14_la q15_la q18a_la q19_q20a_la q18b_la q19_q20b_la q43_la q62a_la ///		
		(. = .a) if country != 11
recode q14 q15 q18 q20 q64 q65 (. = .a) if country == 11 
recode q6_it q19_it q43_it (. = .a) if country != 14
recode q19_mx q43_mx q56a_mx q56b_mx q62_mx (. = .a) if country != 13
recode q62a_us q62b_us q66a_us q66b_us (. = .a) if country != 12
recode q28_c q46a q46b q46b_refused q48_k ///
	   (. = .a) if country != 12 | country != 13 | country != 14	   
recode q66 (. = .a) if country != 13 | country != 14 | country != 15
recode q6_kr q7_kr q19_kr q43_kr (. = .a) if country != 15
recode q7 (. = .a) if country == 15 
* Add the line to recode q6 to .a if the country has country specific q6. This might have been done in each individual cleaning program but do it again here to be sure
recode q6 (. = .a) if inlist(country,9,11,14,15,17) 
recode q3a_co_pe_uy_ar q13b_co_pe_uy_ar q13e_co_pe_uy_ar (. = .a) if country != 2 | country != 7 |  country != 11 | country != 16 
recode q19_ar q43_ar q56a_ar q56b_ar q56c_ar (. = .a) if country != 16 
recode q37_gr_in_ro (. = .a) if country != 4 | country != 18 | country != 19
recode q64 q65 q46_refused q47_refused (. = .a) if country == 15 
recode q6_gb q19a_gb q19b_gb q43a_gb q43b_gb q62_gb q66_gb (. = .a) if country != 17
recode q19_gr (. = .a) if country !=18
recode q43a_gr (. = .a) if country !=18
recode q43b_gr (. = .a) if country !=18
recode q20a_gr q20b_gr q20c_gr q44a_gr q44b_gr q66a_gr q66b_gr q69_gr (. = .a) if country != 18
recode q37_ng q50_e_ng (. = .a) if country != 20

* Country-specific value labels -edit for ssrs-
lab def Language 2011 "CO: Spanish" 3003 "ET: Amharic" 3004 "ET: Oromo" 3005 "ET: Somali" ///
				 4001 "IN: English" 4011 "IN: Hindi" 4012 "IN: Kannada" 4013 "IN: Tamil" 4014 "IN: Bengali" 4015 "IN: Telugu" ///
				 5001 "KE: English" 5002 "KE: Swahili" 7011 "PE: Spanish" 9001 "ZA: English" ///
				 9006 "ZA: Sesotho" 9007 "ZA: isiZulu" 9008 "ZA: Afrikaans" ///
				 9009 "ZA: Sepedi" 9010 "ZA: isiXhosa" 10011 "UY: Spanish" 11001 "LA: Lao" ///
				 11002 "LA: Khmou" 11003 "LA: Hmong" 12009 "US: English" 12010 "US: Spanish" ///
				 13058 "MX: Spanish" 14016 "IT: Italian" 15001 "KR: Korean" 16001 "AR: Spanish" ///
				 17001 "UK: English" 18002 "GR: Greek" 19002 "RO: Romanian" ///
				 20001 "NG: English" 20030 "NG: Hausa" 20031 "NG: Igbo" 20032 "NG: Pidgin" 20033 "NG: Yoruba"
			 
lab val language Language
lab var language "Language of interview"

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
lab def q62a_la_label .a "NA" .r "Refused", modify
lab def q63_label .a "NA" .r "Refused" .d "Don't know", modify
lab def labels16 .a "NA" .r "Refused", modify
lab def labels24 .a "NA" .r "Refused", modify
lab def labels22 .a "NA" .r "Refused", modify
lab def labels23 .a "NA" .r "Refused", modify
lab def labels26 .a "NA" .r "Refused", modify
lab def labels37 11 "AR: Delay to get a turn " .a "NA" .r "Refused", modify
lab def labels39 .a "NA" .r "Refused", modify
lab def labels40 .a "NA" .r "Refused", modify
lab def labels84 .a "NA" .r "Refused", modify
lab def labels50 .r "Refused", modify
lab def Q19 .a "NA" .r "Refused" .d "Don't know", modify
lab def Q43 .a "NA" .r "Refused" .d "Don't know", modify
lab def place_type .a "NA" .r "Refused", modify
lab def fac_owner .a "NA" .r "Refused", modify
lab def fac_type1 .a "NA" .r "Refused", modify
lab def fac_type3 .a "NA" .r "Refused", modify
lab def gender2 3 "AR: Other gender", modify
lab def labels26 10 "AR: Short waiting time to get appointments" ///
				 11 "GR: Preferred provider by other family members" ///
				 12 "GR: Referred from another provider" ///
				 13 "RO: Recommended by family or friends", modify
lab def labels27 .a "NA",modify
lab def labels37 12 "GR: Fear or anxiety of a healthcare procedure, examination or treatment" ///
				 13 "RO: Fear of examination/medical procedure" ///
				 14 "RO: Lack of trust in doctors/procedures" ///
				 15 "RO: Concern about informal payments/gifts", modify
lab def labels44 .a "NA" .r "Refused", modify	
lab def labels65 1 "Yes" 2 "No" .d "Don't Know", modify		
label values q12 yes_no_dk
				
*** weights ***
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
* Dropping time for now 
drop respondent_num interviewer_gender interviewer_id time q1_codes interviewerid_recoded psu_id ecs_id  


*----------- reorder V1 to V2 ------
drop q12 q13 q13b_co_pe_uy_ar q13e_co_pe_uy_ar q13e_other_co_pe_uy_ar ///
     q14 q15 q14_la q15_la q25_a q25_b q47 q47_refused // questions that were dropped
	 
ren q4 recq5
*label val recq5 q5_label

ren q5 recq4
*label val recq4 q4_label

ren q5_other_it recq4_other_it
ren q16 recq12_a
ren q17 recq12_b

ren q18 recq13 
ren q18a_la recq13a_la
ren q18b_la recq13b_la

*ren q19 recq14
ren q19_ar recq14_ar
ren q19_co_pe recq14_co_pe
ren q19_gr recq14_gr
ren q19_gr_other recq14_gr_other
ren q19_it recq14_it
ren q19_kr recq14_kr
ren q19_multi recq14_multi
ren q19_mx recq14_mx
ren q19_other recq14_other
ren q19_other_gb recq14_other_gb
ren q19_q20a_la recq14_q15a_la
ren q19_q20a_other_la recq14_q15a_other_la
ren q19_q20b_la recq14_q15b_la
ren q19_q20b_other_la recq14_q15b_other_la
ren q19_uy recq14_uy
ren q19a_gb recq14a_gb
ren q19b_gb recq14b_gb

ren q20 recq15
ren q20_other recq15_other
ren q20a_gr recq15a_gr
ren q20a_gr_other recq15a_gr_other
ren q20b_gr recq15b_gr
ren q20b_gr_other recq15b_gr_other
ren q20c_gr recq15c_gr
ren q20c_gr_other recq15c_gr_other

ren q21 recq16
ren q21_other recq16_other
ren q22 recq17
ren q23 recq18
ren q23_q24 recq18_q19

ren q24 recq19
ren q26 recq20
ren q27 recq21
ren q28_a recq22
ren q28_b recq23
ren q28_c recq25
ren q29 recq26
ren q30 recq27_a
ren q31 recq27_b
ren q32 recq27_c
ren q33 recq27_d
ren q34 recq27_e
ren q35 recq27_f
ren q36 recq27_g

ren q37_gr_in_ro recq27i_gr_in_ro
ren q37_ng recq27i_ng
ren q37_za recq27i_za

ren q38 recq27_h
ren q39 recq28_a
ren q40 recq28_b
ren q41 recq29
ren q42 recq30
ren q42_other recq30_other

ren q43_ar recq32_ar
ren q43_co_pe recq32_co_pe
ren q43_it recq32_it
ren q43_kr recq32_kr
ren q43_la recq32_la
ren q43_multi recq32_multi
ren q43_mx recq32_mx
ren q43_other recq32_other
ren q43_other_gb recq32_other_gb
ren q43_uy recq32_uy
ren q43a_gb recq32a_gb
ren q43a_gr recq32a_gr
ren q43a_gr_other recq32a_gr_other
ren q43b_gb recq32b_gb
ren q43b_gr recq32b_gr
*ren q43_other recq32_other
*ren q43_other_original recq32_other_original

ren q44 recq33
ren q44_other recq33_other
ren q44a_gr recq33a_gr
ren q44a_gr_other recq33a_gr_other
ren q44b_gr recq33b_gr
ren q44b_gr_other recq33b_gr_other

ren q45 recq34 
ren q45_other recq34_other
ren q46a recq35
ren q46b recq36 
ren q46 recq37
ren q46_refused recq37_refused // this specific question isn't in V2.0
ren q46b_refused recq37b_refused

ren q48_a recq38_a
ren q48_b recq38_b
ren q48_c recq38_c
ren q48_d recq38_d
ren q48_e recq38_e
ren q48_f recq38f
ren q48_g recq38_g
ren q48_h recq38_h
ren q48_i recq38_i
ren q48_j recq38_j
ren q48_k recq38_k

ren q49 recq39
ren q50_a recq40_a
ren q50_b recq40_b
ren q50_c recq40_c
ren q50_d recq40_d
ren q50_e_ng recq40_e_ng
ren q51 recq41_a
ren q52 recq41_b
ren q53 recq41_c
ren q54 recq42 
ren q55 recq43

ren q56_multi recq44_multi
ren q56_pe recq44_pe
ren q56_uy recq44_uy
ren q56a_ar recq44a_ar
ren q56a_mx recq44a_mx
ren q56b_ar recq44b_ar
ren q56b_mx recq44b_mx
ren q56c_ar recq44c_ar

ren q57 recq45
ren q58 recq46 
ren q59 recq47
ren q60 recq48
ren q61 recq49

ren q62 recq50
ren q62_gb recq50_gb
ren q62_mx recq50_mx
ren q62_other recq50_other
ren q62_other_original recq50_other_original
ren q62a_la recq50a_la
ren q62a_other_la recq50a_other_la
ren q62a_us recq50a_us
ren q62b_other_us recq50b_other_us
ren q62b_us recq50b_us
ren q63 recq51

ren q64 CELL1
ren q65 CELL2

ren q66 recq52
ren q66_gb recq52_gb
ren q66a_gr recq52a_gr
ren q66a_us recq52a_us
ren q66b_gr recq52b_gr
ren q66b_us recq52b_us

ren q69_gr recq51_gr

ren rec* *

label copy q4_label q5_label2
label copy q5_label q4_label2
label copy q20_label q15_label2
label copy q62_label q50_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q50 q50_label2

label drop q4_label q5_label q20_label q62_label 

* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 
		
	
*Save recoded data
save "$data_mc/02 recoded data/input data files/pvs_appended_v1.dta", replace


********************************* PVS V2 *********************************
* Starting with PVS China, the PVS question items were re-ordered, this part of the do file will:
	* Re-order V1 vars to match V2 order
	* Update variable labels to match V2 label names
	* Append V2 countries

clear all
use "$data_mc/02 recoded data/input data files/pvs_appended_v1.dta"

* Update CN data labels:
recode q45 (0 = 1 "Getting worse") (1 = 2 "Staying the same") (2 = 3 "Getting better"), gen(recq45)
drop q45

recode q2 (0 = 1 "18 to 29") (1 = 2 "30-39") (2 = 3 "40-49" ) (3 = 4 "50-59") (4 = 5 "60-69") (5 = 6 "70-79") (6 = 7 "80+"), gen(recq2)
drop q2
 
ren rec* *

* Append V2 datasets:
tempfile label10
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q44_label q50_label2 q63_label using `label10'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q44_label q50_label2 q63_label 

append using "$data_mc/02 recoded data/input data files/pvs_cn.dta"

qui do `label10'

* Country
lab def labels0 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" ///
				15 "Republic of Korea" 16 "Argentina (Mendoza)" ///
				17 "United Kingdom" 18 "Greece" 19 "Romania" 20 "Nigeria" ///
				21 "China", modify

* Country-specific skip patterns - check this 
recode q27i_cn q27j_cn q51_cn (. = .a) if country != 21

* Other value label modifcations // SS: confirm with Todd these are not China specifc options
lab def exc_poor_judge 5 "I am unable to judge" .d "Don't know", modify
lab def exc_poor_staff 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
lab def exc_pr_hlthcare 5 "I did not receive healthcare from this provider in the past 12 months" .a "NA",modify
lab def exc_pr_visits 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
					
* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 	
order CELL1 CELL2, before(q52)	  


* Label variables					
lab var country "Country"
lab var int_length "Interview length (minutes)" 
lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"
lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab variable q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7. Other type of health insurance" 
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12_a "Q12a. How confident are you that you are the person who is responsible for managing your overall health?"
lab var q12_b "Q12b. How confident are you can tell a healthcare provider concerns you have even when he or she does not ask??"
lab var q13 "Q13. Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?" 
lab var q14 "Q14. Is this a public, private, social security, NGO, or faith-based facility?"
label variable q14_other "Q14_Other. Other (specify)"
lab var q15 "Q15. What type of healthcare facility is this?"
label variable q15_other "Q15_Other. Other"
label variable q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
label variable q16_other "Q16. Other reasons"
label variable q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label variable q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label variable q19 "Q19. Total number of healthcare visits in the past 12 months"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label variable q20 "Q20. You said you made * visits. Were they all to the same facility?"
label variable q21 "Q21. How many different healthcare facilities did you go to in total?"
label variable q22 "Q22. How many visits did you have with a healthcare provider at your home in the past 12 months?"
label variable q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label variable q24 "Q24. What was the main reason for the last virtual or telemedicine visit?"
label variable q24_other "Q24_Other. Other reasons of virtual or telemedicine visit."
label variable q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label variable q26 "Q26. In the past 12 months did you stay overnight at a healthcare facility as a patient?"
label variable q27_a "Q27a. Blood pressure tested in the past 12 months"
label variable q27_b "Q27b. Breast examination (received a mammogram) in the past 12 months"
label variable q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label variable q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label variable q27_e "Q27e. Had your teeth checked in the past 12 months"
label variable q27_f "Q27f. Had a blood sugar test in the past 12 months"
label variable q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label variable q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label variable q27i_cn "Q27i. CN only: Breast colour ultrasound (B-ultrasound)"
label variable q27j_cn "Q27j. CN only: Received a mammogram (a special X-ray of the breast)"
label variable q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label variable q28_b "Q28b. Been treated unfairly or discriminated against by a doctor, nurse, or another healthcare provider"
label variable q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label variable q30 "Q30. The last time this happened, what was the main reason you did not receive healthcare?"
label variable q30_other "Q30_Other. Other"
label variable q31_a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label variable q31_b "Q31b. Sell items to pay for healthcare"
label variable q32 "Q32. Last visit facility type public/private/social security/NGO/faith-based?"
label variable q32_other "Q32_Other. other last visit facility type"
label variable q33 "Q33. What type of healthcare facility was this?"
label variable q33_other "Q33_Other. Other type of healthcare facility"
label variable q34 "Q34. What was the main reason you went?"
label variable q34_other "Q34_Other. Other reasons"
label variable q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label variable q36 "Q36. How long did you wait in days, weeks, or months between scheduling the appointment and seeing the health care provider?"
label variable q37 "Q37. At this most recent visit, once you arrived at the facility, approximately how long did you wait before seeing the provider?"
label variable q37_other "Q37_Other. Other"
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
label variable q40_a "Q40a. How would you rate the quality of care provided for care for pregnancy?"
label variable q40_b "Q40b. How would you rate the quality of care provided for children?"
label variable q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label variable q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label variable q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label variable q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label variable q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label variable q42 "Q42. How would you rate the quality of public healthcare system in your country?"
label variable q43 "Q43. How would you rate the quality of private healthcare system in your country?"
label variable q44 "Q44. Overall, how would you rate the quality of the NGO or faith-based healthcare system in your country?"
label variable q45 "Q45. Is your country's health system is getting better, same or worse?"
label variable q46 "Q46. Which of these statements do you agree with the most?"
label variable q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label variable q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label variable q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label variable q50 "Q50. What is your native language or mother tongue?"
label variable q50_other "Q50_Other. Other languages"
label variable q51 "Q51. Total monthly household income"
label variable q51_cn "Q51a. What is the number of people in the household?"
label variable CELL1 "CELL1. Do you have another mobile phone number besides the one I am calling. "
label variable CELL2 "CELL2. How many other mobile phone numbers do you have?"
label variable int_length "Interview length"

*Save recoded data
save "$data_mc/02 recoded data/input data files/pvs_appended_v2.dta", replace


