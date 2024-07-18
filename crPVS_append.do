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
				 20001 "NG: English" 20030 "NG: Hausa" 20031 "NG: Igbo" 20032 "NG: Pidgin" 20033 "NG: Yoruba" ///
				 21001 "CN: Mandarin"
			 
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
lab def q43a_gr 1 "Public" 2 "Private (for-profit)" 3 "Contracted to public" 4 "NGO" 5 "Other, specify",modify
lab val q43a_gr q43a_gr

*** weights ***
ren weight_educ weight
lab var weight "Final weight (based on gender, age, region, education)"
				
*----------- reorder V1 to V2 ------
* renaming questions that were dropped
ren q12 q12_v1
ren q13 q13_v1
ren q13b_co_pe_uy_ar q13b_co_pe_uy_ar_v1
ren q13e_co_pe_uy_ar q13e_co_pe_uy_ar_v1
ren q13e_other_co_pe_uy_ar q13e_other_co_pe_uy_ar_v1
ren q14 q14_v1
ren q15 q15_v1
ren q14_la q14_la_v1
ren q15_la q15_la_v1
ren q25_a q25_a_v1
ren q25_b q25_b_v1
ren q47 q47_v1
ren q47_refused q47_refused_v1
ren q46_refused q46_refused_v1

	 
ren q4 recq5
ren q5 recq4
ren q5_other_it recq4_other_it
ren q16 recq12_a
ren q17 recq12_b
ren q18 recq13 
ren q18a_la recq13a_la
ren q18b_la recq13b_la
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
label copy q44_label q33_label2
label copy q63_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q50 q50_label2
label val q33 q33_label2
label val q51 q51_label2

label drop q4_label q5_label q20_label q62_label q44_label q63_label
		
	
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
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 using `label10'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 

append using "$data_mc/02 recoded data/input data files/pvs_cn.dta"

qui do `label10'

* Country
lab def labels0 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" ///
				15 "Republic of Korea" 16 "Argentina (Mendoza)" ///
				17 "United Kingdom" 18 "Greece" 19 "Romania" 20 "Nigeria" ///
				21 "China", modify

* Country-specific skip patterns  
recode q14_cn q27i_cn q27j_cn q32_cn q51_cn (. = .a) if country != 21

* Other value label modifcations
lab def exc_poor_judge 5 "I am unable to judge" .d "Don't know", modify
lab def exc_poor_staff 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
lab def exc_pr_hlthcare 5 "I did not receive healthcare from this provider in the past 12 months" .a "NA",modify
lab def exc_pr_visits 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
lab def labels26 14 "CN: Trust hospital", modify


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

					
* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 	
order CELL1 CELL2, before(q52)	  

/*
* Label variables
lab var respondent_serial "Respondent serial"
lab var country "Country"
lab var int_length "Interview length (minutes)" 
lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"
lab var mode "mode"
lab var psu_id_for_svy_cmds "PSU ID"
lab var weight  "Weight"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab var q3a_co_pe_uy_ar "Q3a. CO/PE/UY/AR only: Are you a man or a woman?"
lab var q4 "Q4. County, state, region where respondent lives"
lab var q4_other_it "Q4. Other"
lab var q5 "Q5. Type of area where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
/*lab var q6_gb
lab var q6_it 
lab var q6_kr 
lab var q6_la 
lab var q6_za */ 
lab var q7 "Q7. What type of health insurance do you have?"
*lab var q7_kr 
lab var q7_other "Q7. Other type of health insurance" 
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q12_v1 "Q12 (V1.0). Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Is there one healthcare facility or provider's group you usually go to?"
lab var q13_v1 "Q13 (V1.0). Was it confirmed by a test?"
lab var q13a_la "Q13A. LA only: Is there one place you usually...? (incl pharm, traditional)"
lab var q13b_co_pe_uy_ar_v1 "Q13B (V1.0). CO/PE/UY/AR only: Did you seek health care for COVID-19?"
lab var q13b_la "Q13B. LA only: Is there one hospital, health center, or clinic you usually...?"
lab var q13e_co_pe_uy_ar_v1 "Q13E (V1.0). CO/PE/UY/AR only: Why didn't you receive health care for COVID-19?"
lab var q13e_other_co_pe_uy_ar_v1 "Q13E_Other (V1.0). CO/PE/UY only: Other"
lab var q14_ar "Q14. AR only: Is this facility Public, OSEP, Other 'obras sociales', A medical center/hospital owned by PAMI, or Private/prepaid?"
lab var q14_cn "Q14. CN only: Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q14_co_pe "Q14. CO/PE only: Is this a public or private healthcare facility?"
lab var q14_gr "Q14. GR only: Is this a public, private, contracted to public, or an NGO healthcare facility?"
lab var q14_gr_other "Q14. Other"
lab var q14_it "Q14. IT only: Is this facility… public, private SSN, or private not SSN?"
lab var q14_kr "Q14. KR only: Is this...public, private, or non-profit/religious medical...?"
lab var q14_la_v1 "Q14 (V1.0). LA only: How many doses of COVID-19 vaccine have you received?"
lab var q14_multi "Q14. ET/IN/KE/NG/RO/ZA only: Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q14_mx "Q14. MX only: Who runs this healthcare facility?"
lab var q14_other "Q14. Other"
lab var q14_other_gb "Q14. GB only: Other"
lab var q14_q15a_la "Q15A. LA only: What type of place is this?"
lab var q14_q15a_other_la "Q15A. LA only: Other"
lab var q14_q15b_la "Q15B. LA only: What type of healthcare facility is this?"
lab var q14_q15b_other_la "Q15B. LA only: Other"
lab var q14_uy "Q14. UY only: Is this a public, private, or mutual healthcare facility?"
lab var q14_v1 "Q14 (V1.0). How many doses of a COVID-19 vaccine have you received, or have you not"
lab var q14a_gb "Q14a. GB only: Is it a National Health Service (NHS) facility or private health?"
lab var q14b_gb "Q14b. GB only: Is it a Health and Social Care (HSC) facility or private health?"
lab var q15 "Q15. What type of healthcare facility is this?"
lab var q15_la_v1 "Q15B (V1.0). LA only: If a vaccine against COVID-19 is or becomes available to you, do you plan to get vaccinated?"
lab var q15_other "Q15. Other"
lab var q15_v1 "Q15 (V1.0). Do you plan to receive all recommended doses if they are available to you?"
lab var q15a_gr "Q15a. GR only: Can you please tell me the specialty of your main provider in this facility?"
lab var q15a_gr_other "Q15a. Other"
lab var q15b_gr "Q15b. GR only: Have you registered with a personal doctor?"
lab var q15b_gr_other "Q15b. Other"
lab var q15c_gr "Q15c. GR only: Is your usual healthcare provider the personal doctor that you have registered with?"
lab var q15c_gr_other "Q15c. Other"
lab var q16 "Q16. Why did you choose this healthcare facility?"
lab var q16_other "Q16. Other"
lab var q17 "Q17. Overall respondent's rating of the quality received in this facility"
lab var q18 "Q18. How many healthcare visits in total have you made in the past 12 months? "
lab var q18_q19 "Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)"
lab var q19 "Q19. Total number of healthcare visits in the past 12 months (range)"
lab var q20 
lab var q21 
lab var q22 
lab var q23 
lab var q24 
lab var q24_other 
lab var q25 
lab var q25_a_v1
lab var q25_b_v1 
lab var q26 
lab var q27_a 
lab var q27_b 
lab var q27_c 
lab var q27_d 
lab var q27_e 
lab var q27_f 
lab var q27_g 
lab var q27_h 
lab var q27i_cn 
lab var q27i_gr_in_ro 
lab var q27i_ng 
lab var q27i_za 
lab var q27j_cn 
lab var q28_a 
lab var q28_b 
lab var q29 
lab var q30 
lab var q30_other 
lab var q31_a 
lab var q31_b 
lab var q32_ar 
lab var q32_cn 
lab var q32_co_pe 
lab var q32_it 
lab var q32_kr 
lab var q32_la 
lab var q32_multi 
lab var q32_mx 
lab var q32_other 
lab var q32_other_gb 
lab var q32_uy 
lab var q32a_gb 
lab var q32a_gr 
lab var q32a_gr_other 
lab var q32b_gb 
lab var q32b_gr 
lab var q33 
lab var q33_other 
lab var q33a_gr 
lab var q33a_gr_other 
lab var q33b_gr 
lab var q33b_gr_other 
lab var q34 
lab var q34_other 
lab var q35 
lab var q36 
lab var q37 
lab var q37_other 
lab var q37b_refused 
lab var q38_a 
lab var q38_b 
lab var q38_c 
lab var q38_d 
lab var q38_e 
lab var q38_f 
lab var q38_g 
lab var q38_h 
lab var q38_i 
lab var q38_j 
lab var q38_k 
lab var q38f 
lab var q39 
lab var q40_a 
lab var q40_b 
lab var q40_c 
lab var q40_d 
lab var q40_e_ng 
lab var q41_a 
lab var q41_b 
lab var q41_c 
lab var q42 
lab var q43 
lab var q44 
lab var q44_multi 
lab var q44_pe 
lab var q44_uy 
lab var q44a_ar 
lab var q44a_mx 
lab var q44b_ar 
lab var q44b_mx 
lab var q44c_ar 
lab var q45 
lab var q46 
lab var q46_refused_v1 
lab var q47 
lab var q47_refused_v1 
lab var q47_v1
lab var q48 
lab var q49 
lab var q50 
lab var q50_gb 
lab var q50_mx 
lab var q50_other 
lab var q50_other_original 
lab var q50a_la 
lab var q50a_other_la 
lab var q50a_us 
lab var q50b_other_us 
lab var q50b_us 
lab var q51 
lab var q51_cn 
lab var q51_gr 
lab var CELL1 
lab var CELL2 
lab var q52 
lab var q52_gb 
lab var q52a_gr 
lab var q52a_us 
lab var q52b_gr 
lab var q52b_us 

drop check

*/
*------------------------------------------------------------------------------*
*Save recoded data

save "$data_mc/02 recoded data/input data files/pvs_appended_v2.dta", replace

*------------------------------------------------------------------------------*
