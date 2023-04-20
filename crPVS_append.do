* People's Voice Survey data append  
* Date of last update: April 2023
* Last updated by: N Kapoor, S Sabwa, M Yu

/*

	This file appends PVS datasets cleaned separately. 
	Country-specific or dataset-specific variables or values are modified as needed. 
	It also recodes other, specify values using IPA check command. 

*/

********************************* Append data *********************************

u "$data_mc/02 recoded data/pvs_co_pe_uy.dta", clear

tempfile label1
label save q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label using `label1'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q62_label q63_label 

append using "$data_mc/02 recoded data/pvs_et_in_ke_za.dta"

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

tempfile label6
label save q4_label q5_label q7_label q8_label q20_label q44_label q63_label using `label6'
label drop q4_label q5_label q7_label q8_label q20_label q44_label q63_label

append using "$data_mc/02 recoded data/pvs_uk.dta"

qui do `label6'


* Country
lab def labels0 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" 15 "Republic of Korea" 16 "Argentina (Mendoza)" ///
				17 "United Kingdom", modify

* Mode
recode mode (3 = 1) (4 = 3)
lab def mode 1 "CATI" 2 "F2F" 3 "CAWI", replace
label val mode mode
lab var mode "Mode of interview (CATI, F2F, or CAWI)"

* Country-specific skip patterns - check this 
recode q19_et_in_ke_za q56_et_in_ke_za (. = .a) if country != 5 | country != 3  | country != 9  
recode q43_et_in_ke_za_la (. = .a) if country != 5 | country != 3  | country != 9 | country != 11
recode q19_uy q43_uy q56_uy (. = .a) if country != 10
recode q56_pe (. = .a) if country != 7
recode q19_co_pe q43_co_pe (. = .a) if country != 2 & country != 7 
recode q6_za q37_za (. = .a) if country != 9
recode q6_la q14_la q15_la q18a_la q19_q20a_la q18b_la q19_q20b_la q62a_la ///		
		(. = .a) if country != 11
recode q14 q15 (. = .a) if country == 11 
recode q18 q20 q64 q65 (. = .a) if country == 11 
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
recode q37_in (. = .a) if country != 4
recode q64 q65 q46_refused q47_refused (. = .a) if country == 15 
recode q6_uk q19a_uk q19b_uk q43a_uk q43b_uk q62_uk q66_uk (. = .a) if country != 17

	   
* Country-specific value labels -edit for ssrs-
lab def Language 2011 "CO: Spanish" 3003 "ET: Amharic" 3004 "ET: Oromo" 3005 "ET: Somali" ///
				 4001 "IN: English" 4011 "IN: Hindi" 4012 "IN: Kannada" 4013 "IN: Tamil" 4014 "IN: Bengali" 4015 "IN: Telugu" ///
				 5001 "KE: English" 5002 "KE: Swahili" 7011 "PE: Spanish" 9001 "ZA: English" ///
				 9006 "ZA: Sesotho" 9007 "ZA: isiZulu" 9008 "ZA: Afrikaans" ///
				 9009 "ZA: Sepedi" 9010 "ZA: isiXhosa" 10011 "UY: Spanish" 11001 "LA: Lao" ///
				 11002 "LA: Khmou" 11003 "LA: Hmong" 12009 "US: English" 12010 "US: Spanish" ///
				 13058 "MX: Spanish" 14016 "IT: Italian" 15001 "KR: Korean" 16001 "AR: Spanish" ///
				 17001 "UK: English"
				 
				 
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
lab def Q19 .a "NA" .r "Refused", modify
lab def Q43 .a "NA" .r "Refused", modify
lab def place_type .a "NA" .r "Refused", modify
lab def fac_owner .a "NA" .r "Refused", modify
lab def fac_type1 .a "NA" .r "Refused", modify
lab def fac_type3 .a "NA" .r "Refused", modify
lab def gender2 3 "AR: Other gender", modify
lab def labels26 10 "AR: Short waiting time to get appointments", modify
 
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


* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country language date ///
	  int_length psu_id_for_svy_cmds weight 
	
*Save recoded data
save "$data_mc/02 recoded data/pvs_appended.dta", replace

