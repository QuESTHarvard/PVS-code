* People's Voice Survey data append  
* Date of last update: March 2025
* Last updated by: S Sabwa

/*

	This file appends PVS datasets cleaned separately. 
	Country-specific or dataset-specific variables or values are modified as needed. 

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

* Country-specific value labels -edit for ssrs-
lab def Language 1001 "EC: Spanish" 2011 "CO: Spanish" 3003 "ET: Amharic" 3004 "ET: Oromo" 3005 "ET: Somali" ///
				 4001 "IN: English" 4011 "IN: Hindi" 4012 "IN: Kannada" 4013 "IN: Tamil" 4014 "IN: Bengali" 4015 "IN: Telugu" ///
				 5001 "KE: English" 5002 "KE: Swahili" 7011 "PE: Spanish" 9001 "ZA: English" ///
				 9006 "ZA: Sesotho" 9007 "ZA: isiZulu" 9008 "ZA: Afrikaans" ///
				 9009 "ZA: Sepedi" 9010 "ZA: isiXhosa" 10011 "UY: Spanish" 11001 "LA: Lao" ///
				 11002 "LA: Khmou" 11003 "LA: Hmong" 12009 "US: English" 12010 "US: Spanish" ///
				 13058 "MX: Spanish" 14016 "IT: Italian" 15001 "KR: Korean" 16001 "AR: Spanish" ///
				 17001 "UK: English" 18002 "GR: Greek" 19002 "RO: Romanian" ///
				 20001 "NG: English" 20030 "NG: Hausa" 20031 "NG: Igbo" 20032 "NG: Pidgin" 20033 "NG: Yoruba" ///
				 21001 "CN: Mandarin" 23001 "NP: Nepali" 23002 "NP: Maithali" 23003 "NP: Newari" 23004 "NP: Bhojpuri" ///
				 23005 "NP: Tharu"  23006 "NP: Tamang" 23007 "NP: Doteli" 23008 "NP: Other"
			 
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
lab def labels37  11 "AR: Delay to get a turn" ////
				  12 "GR: Fear or anxiety of a healthcare procedure, examination or treatment" ///
				 13 "RO: Fear of examination/medical procedure" ///
				 14 "RO: Lack of trust in doctors/procedures" ///
				 15 "RO: Concern about informal payments/gifts" ///
				 16 "SO: They are closed" ///
				 17 "SO: Was affected by conflicts" ///
				 18 "SO: Doctor was not available" 19 "LAC: Problems with coverage" 20 "LAC: Difficulty getting an appointment" 21 "EC: Insurance problems (e.g., my insurance expired, I was not eligible for it)" 22 "EC: Difficulty getting an appointment (e.g., there was no appointment, appointments were scheduled far in advance)" .a "NA" .d "Don't know" .r "Refused", modify
lab def labels44 .a "NA" .r "Refused", modify	
lab def labels65 1 "Yes" 2 "No" .d "Don't Know", modify		
label values q12 yes_no_dk
lab def q43a_gr 1 "Public" 2 "Private (for-profit)" 3 "Contracted to public" 4 "NGO" 5 "Other, specify",modify
lab val q43a_gr q43a_gr

*** weights ***
ren weight_educ weight
lab var weight "Final weight (based on gender, age, region, education)"
				
*----------- reorder V1 to V2 ------
* Starting with PVS China, the PVS question items were re-ordered, this part of the do file will:
	* Re-order V1 vars to match V2 order
	* Update variable labels to match V2 label names
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
ren q19_co_pe recq14_co_pe_v1
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
ren q43_co_pe recq32_co_pe_v1
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
ren q46b q36_v1
ren q46 q37_v1
ren q46b_refused q37b_refused_v1

ren q48_a recq38_a
ren q48_b recq38_b
ren q48_c recq38_c
ren q48_d recq38_d
ren q48_e recq38_e
ren q48_f recq38_f
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


* Trim extreme values for for q21, q37_v1 and q47_v1; q36 for IT, MX, US, KR and UK - SS 4-3: moved this from the derived file because we no longer have these vars in continuous format in V2.0
qui levelsof country, local(countrylev)

foreach i in `countrylev' {
	
	if inlist(`i',12,13,14,15,17,18,19)  {
		extremes q36_v1 country if country == `i', high
	}

	foreach var in q21 q37_v1 {
		
		extremes `var' country if country == `i', high
	}
}


clonevar q21_original = q21
clonevar q37_original = q37_v1
clonevar q36_original = q36_v1

* q21 (no issues)

* q37: Q37. In minutes: Approximately how long did you wait before seeing the provider?
* Colombia okay
* Ethiopia - 3 values recoded 
replace q37_v1 = . if q37_v1 > 600 & q37_v1 < . & country == 3
* India - 1 value recoded 
replace q37_v1 = . if q37_v1 > 730 & q37_v1 < . & country == 4 
* Kenya - 1 value recoded 
replace q37_v1 = . if q37_v1 > 720 & q37_v1 < . & country == 5
* Peru okay
* South Africa - 2 values recoded 
replace q37_v1 = . if q37_v1 > 600 & q37_v1 < . & country == 9
* Uruguay okay, Lao okay, US okay, Mexico okay, Italy okay 
* Korea - 1 value recoded 
replace q37_v1 = . if q37_v1 > 780 & q37_v1 < . & country == 15
* Mendoza - 2 values recoded
replace q37_v1 = . if q37_v1 > 540 & q37_v1 < . & country == 16
* UK - 3 values recoded
replace q37_v1 = . if q37_v1 > 780 & q37_v1 < . & country == 17
* Greece - 1 value recoded (Todd to review)
replace q37_v1 = . if q37_v1 > 600 & q37_v1 < . & country == 18
* Romania -  1 value recoded (Todd to review)
replace q37_v1 = . if q37_v1 > 600 & q37_v1 < . & country == 19
* Nigeria -  2 values recoded (Todd to review)
replace q37_v1 = . if q37_v1 > 720 & q37_v1 < . & country == 20


* q47_v1
* Colombia okay 
* Ethiopia - 6 values recoded
replace q47_v1 = . if q47_v1 >= 600 & q47_v1 < . & country == 3 
* India - 8 values recoded
replace q47_v1 = . if q47_v1 >= 600 & q47_v1 < . & country == 4 
* Kenya - 3 values recoded
replace q47_v1 = . if q47_v1 > 600 & q47_v1 < . & country == 5
* Peru okay 
* South Africa - 2 values recoded 
replace q47_v1 = . if q47_v1 > 600 & q47_v1 < . & country == 9 
* Uruguay okay, Lao okay 
* United States - 5 values recoded
replace q47_v1 = . if q47_v1 >= 600 & q47_v1 < . & country == 12
* Mexico okay 
* Italy - 2 values recoded
replace q47_v1 = . if q47_v1 >= 600 & q47_v1 < . & country == 14
* Korea - 13 values recoded
replace q47_v1 = . if q47_v1 >= 600 & q47_v1 < . & country == 15
* Mendoza okay 
* UK - 1 value recoded
replace q47_v1 = . if q47_v1 > 560 & q47_v1 < . & country == 17 
* Greece okay (Todd to review)
* Romania okay (Todd to review)


* q36
* US - 4 values recoded 
replace q36_v1 = . if q36_v1 > 365 & q36_v1 < . & country == 12
* Mexico okay 
* Italy - 2 values recoded
replace q36_v1 = . if q36_v1 > 365 & q36_v1 < . & country == 14
* Korea - 1 value recoded
replace q36_v1 = . if q36_v1 > 365 & q36_v1 < . & country == 15
* UK - 2 values recoded 
replace q36_v1 = . if q36_v1 > 365 & q36_v1 < . & country == 17
* Greece - 1 value recoded (Todd to review)
replace q36_v1 = . if q36_v1 > 720 & q36_v1 < . & country == 18
* Romania - 12 values recoded (Todd to review)
*replace q36 = . if q36 > 720 & q36 < . & country == 19
* NA for Nigeria

* Drop trimmed q21 q37 q47 and get back the orignal var
drop q21 q37_v1 q36_v1
rename q21_original q21
rename q37_original q37_v1
rename q36_original q36_v1

*adding "NA" for countries' that don't have V1.0 vars
recode q12_v1 q13_v1 q13b_co_pe_uy_ar_v1 q13e_co_pe_uy_ar_v1 q14_la_v1 ///
	   q14_v1 q15_la_v1 q15_v1 q25_a_v1 q25_b_v1 q46_refused_v1 q47_refused_v1 q47_v1  ///
	   (. = .a) if country == 21 | country == 22 | country == 23

/*
*** Political alignment***

**Import excel as updatas and save it as .dta
/*import excel "$data_mc/03 input output/Input/Policial alignment variable/Pol_align_recode_all.xlsx", sheet("pol_al") firstrow clear
destring q5 pol_align, replace float
save "$data_mc/03 input output/Input/Policial alignment variable/pol_align.dta", replace
*/

merge m:m q4 using "$data_mc/03 input output/Input/Policial alignment variable/pol_align.dta" 
drop _merge
lab def pol_align 0 "Aligned (in favor)" 1 "Not aligned (out of favor)" .a "NA"
lab val pol_align pol_align
*/

***************** For appending purposes:
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

recode q2 (0 = 1 "18 to 29") (1 = 2 "30-39") (2 = 3 "40-49" ) (3 = 4 "50-59") (4 = 5 "60-69") (5 = 6 "70-79") (6 = 7 "80+"), gen(recq2)
drop q2
 
ren rec* *
		
gen wave = 1
	
*Save recoded data
save "$data_mc/02 recoded data/input data files/pvs_appended_v1.dta", replace

********************************* PVS V2 ***************************************
* Starting with PVS China, the PVS question items were re-ordered, this part of the do file will:
	* Append V2 countries

clear all
use "$data_mc/02 recoded data/input data files/pvs_appended_v1.dta"

* Append V2 datasets:
tempfile label10
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 using `label10'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 

append using "$data_mc/02 recoded data/input data files/pvs_cn.dta"

qui do `label10'

tempfile label11
label save q4_label2 q5_label2 q7_label q8_label q33_label2 q50_label2 q51_label2 using `label11'
label drop q4_label2 q5_label2 q7_label q8_label q33_label2 q50_label2 q51_label2 

append using "$data_mc/02 recoded data/input data files/pvs_so.dta"

qui do `label11'

tempfile label12
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q51_label2 using `label12'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q51_label2 

append using "$data_mc/02 recoded data/input data files/pvs_np.dta"

qui do `label12'

tempfile label13
label save q4_label2 q5_label2 q7_label q8_label q33_label2 q51_label2 Language using `label13'
label drop q4_label2 q5_label2 q7_label q8_label q33_label2 q51_label2 Language

append using "$data_mc/02 recoded data/input data files/pvs_et_in_ke_za_wave2.dta"

qui do `label13'

tempfile label14
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 using `label14'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 

append using "$data_mc/02 recoded data/input data files/pvs_co_pe_uy_wave2.dta"

qui do `label14'

tempfile label15
label save q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2 using `label15'
label drop q4_label2 q5_label2 q7_label q8_label q15_label2 q33_label2 q50_label2 q51_label2

append using "$data_mc/02 recoded data/input data files/pvs_ec.dta"

qui do `label15'

********************************************************************************
* Country - add new countries here
lab def labels0  1 "Ecuador" 11 "Lao PDR" 12 "United States" 13 "Mexico" 14 "Italy" ///
				15 "Republic of Korea" 16 "Argentina (Mendoza)" ///
				17 "United Kingdom" 18 "Greece" 19 "Romania" 20 "Nigeria" ///
				21 "China" 22 "Somaliland" 23 "Nepal", modify	

*-------------------------------------------------------------------------------*					
* Country-specific skip patterns 

* Add the line to recode q6 to .a if the country has country specific q6. 
**This might have been done in each individual cleaning program but do it again here to be sure
recode q6 (. = .a) if inlist(country,9,11,14,15,17) 

* Ethiopia, India, Kenya, Greece, Nigeria, Romania, South Africa, Nepal
recode q14_multi q44_multi q32_multi (. = .a) if country != 3 | country != 4 | country != 5 | ///
									   country != 18 | country != 20 | country != 19 | country != 9 | country !=23

* Peru:
recode q44_pe (. = .a) if country != 7
recode q14_co_pe_v1 q32_co_pe_v1 (. = .a) if country != 2 & country != 7 

* South Africa:
recode q6_za q27i_za (. = .a) if country != 9

* Lao PDR:
recode q6_la q13a_la q13b_la q14_la_v1 q14_q15a_la q14_q15b_la ///
	   q15_la_v1 q32_la q50a_la (. = .a) if country != 11
		
recode q14_v1 q15_v1 q13 q15 CELL1 CELL2 (. = .a) if country == 11 

* Italy
recode q6_it q14_it q32_it (. = .a) if country != 14

* Mexico
recode q14_mx q32_mx q44a_mx q44b_mx q50_mx (. = .a) if country != 13

* USA
recode q50a_us q50b_us q52a_us q52b_us (. = .a) if country != 12

* USA/Mexico/Italy
recode q25 q35 q36 q37b_refused_v1 q38_k (. = .a) if country != 12 | country != 13 | country != 14	
recode q52 (. = .a) if country != 13 | country != 14 | country != 15

* Korea:
recode q6_kr q7_kr q14_kr q32_kr (. = .a) if country != 15
recode q7 (. = .a) if country == 15 
recode CELL1 CELL2 q37b_refused_v1 q47_refused_v1 (. = .a) if country == 15 

* Coolmbia/Peru/Uruguay/Argentina:
recode q3a_co_pe_uy_ar q13b_co_pe_uy_ar_v1 q13e_co_pe_uy_ar_v1 (. = .a) if ///
	   country != 2 | country != 7 |  country != 10 | country != 16 

* Uruguay:   
recode q14_uy q32_uy q44_uy (. = .a) if country !=10

* Argentina:
recode q14_ar q32_ar q44a_ar q44b_ar q44c_ar (. = .a) if country != 16 

* India/Greece/Romania:
recode q27i_gr_in_ro (. = .a) if country != 4 | country != 18 | country != 19

* United Kingdom:
recode q6_gb q14a_gb q14b_gb q32a_gb q32b_gb q50_gb q52_gb (. = .a) if country != 17

* Greece:
recode q14_gr q32a_gr q32b_gr q15a_gr q15b_gr q15c_gr q33a_gr q33b_gr q52a_gr q52b_gr ///
	   q51_gr (. = .a) if country !=18
	   
* Nigeria:	   
recode q27i_ng q40_e_ng (. = .a) if country != 20			

* China:	
recode q14_cn q27i_cn q27j_cn q32_cn q51_cn (. = .a) if country != 21

* Somaliland:
recode q14_so q15a_so q15b_so q15c_so q32_so q40a_so q40b_so q40e_so q40f_so (. = .a) if country != 22

* Nepal:
recode q14_np q32_np q52a_np q52b_np (. = .a) if country !=23

* Kenya
recode q7_ke (. = .a) if country !=5 | wave !=2

* Ecuador: 
recode q13a_ec q14_ec q31c_ec q32_ec q44_ec (. = .a) if country != 1


* All wave 2 countries plus Colombia, Ethiopia, India, Kenya, Peru, South Africa, Uruguay, Lao PDR, Argentina, Nigeria, China, Somaliland, Nepal 
recode q36_v1 (. = .a) if country == 2 | country == 3 | country == 4 | country == 5 | country == 7 ///
						 | country == 9 | country == 10 | country == 11 | country == 16 | country == 20 | ///
						 country != 21 | country != 22 | country != 23 | wave ==2	

*For V1.0 countries that didn't have the new q37 var in V2.0				 
recode q37 (. = .a) if country != 21 | country != 22 | country != 23 | wave !=2		

*LAC wave 2:
recode q6_lac q31_lac q14_lac (. = .a) if wave !=2 | country !=2 | country !=7 | country !=10	 
	
*-------------------------------------------------------------------------------*	
	
* Other value label modifcations
lab def exc_poor_judge 5 "I am unable to judge" .d "Don't know", modify
lab def exc_poor_staff 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
lab def exc_pr_hlthcare 5 "I did not receive healthcare from this provider in the past 12 months" .a "NA",modify
lab def exc_pr_visits 5 "I have not had prior visits or tests" 6 "The clinic had no other staff" .a "NA", modify
lab def labels26 14 "CN: Trust hospital" 15 "SO: Determined by the family in the cities" 16 "EC: Ease of getting appointment", modify
lab def q15_label2 5016 "Mobile clinic", modify


*** New country var based on region ***
recode country (22 = 1 "Somaliland") (3 = 2 "Ethiopia") (5 = 3 "Kenya") ///
			   (20 = 4 "Nigeria") (9 = 5 "South Africa") ///
			   (7 = 6 "Peru") (2 = 7 "Colombia") ///
			   (13 = 8 "Mexico") (10 = 9 "Uruguay") ///
			   (16 = 10 "Argentina") (1 = 11 "Ecuador") (11 = 12 "Lao PDR") (23 = 13 "Nepal") ///
			   (4 = 14 "India") (21 = 15 "China") (15 = 16 "Rep. of Korea") ///
			   (19 = 17 "Romania") (18 = 18 "Greece") ///
			   (14 = 19 "Italy") (17 = 20 "United Kingdom") ///
			   (12 = 21 "United States"), gen(country_reg)
lab var country_reg "Country (ordered by region)" 

*-------------------------------------------------------------------------------*	
*** Code for survey set: For accurate SEs when using mixed CATI/CAWI and F2F surveys ***

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
*-------------------------------------------------------------------------------*	

* Keep variables relevant for data sharing and analysis  
* Dropping time for now 
drop respondent_num interviewer_gender interviewer_id time q1_codes interviewerid_recoded psu_id ecs_id CELL1 CELL2 check cell1 cell2 q44

					
* Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country country_reg wave language date ///
	  int_length psu_id_for_svy_cmds weight 		  

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
lab var q3a_co_pe_uy_ar "Q3a. CO/PE/UY/AR/EC only: Are you a man or a woman?"
lab var q4 "Q4. County, state, region where respondent lives"
lab var q4_other_it "Q4. Other"
lab var q5 "Q5. Type of area where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
/*lab var q6_gb
lab var q6_it 
lab var q6_kr 
lab var q6_la 
lab var q6_za */ 
lab var q6_lac "Q6. LAC only: What type of health insurance do you have?" //confirm translation, found this one the change log doc
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
lab var q13a_co_pe_uy "Q13a. LAC only: Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?"
lab var q14_lac "Q14. LAC only: Usual type"
lab var q14_ec "Q14. EC only: Is this facility...?"
lab var q14_ec_other "Q14. EC only: Other"
lab var q14_ar "Q14. AR only: Is this facility Public, OSEP, Other 'obras sociales', A medical center/hospital owned by PAMI, or Private/prepaid?"
lab var q14_cn "Q14. CN only: Is this a public, private, or NGO/faith-based healthcare facility?"
lab var q14_co_pe_v1 "Q14. (V1.0) CO/PE only: Is this a public or private healthcare facility?"
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
lab var q20 "Q20. Were all of the visits you made to the same healthcare facility?"
lab var q21 "Q21. How many different healthcare facilities did you go to? "
lab var q22 "Q22. How many visits did you have with a healthcare provider at your home?"
lab var q23 "Q23. How many virtual or telemedicine visits did you have?"
lab var q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
lab var q24_other "Q24. Other"
lab var q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
lab var q25_a_v1 "Q25_A (V1.0). Was this visit for COVID-19?"
lab var q25_b_v1 "Q25_B (V1.0). How many of these visits were for COVID-19?"
lab var q26 "Q26. Did you stay overnight at a healthcare facility as a patient?"
lab var q27_a "Q27_a. Blood pressure tested in the past 12 months"
lab var q27_b "Q27_b. Received a mammogram in the past 12 months"
lab var q27_c "Q27_c. Received cervical cancer screening, like a pap test or visual inspection in the past 12 months"
lab var q27_d "Q27_d. Had your eyes or vision checked in the past 12 months"
lab var q27_e "Q27_e. Had your teeth checked in the past 12 months"
lab var q27_f "Q27_f. Had a blood sugar test in the past 12 months"
lab var q27_g "Q27_g. Had a blood cholesterol test in the past 12 months"
lab var q27_h "Q27_h. Received care for depression, anxiety, or another mental health condition"
lab var q27i_cn "Q27i. CN only: Breast colour ultrasound (B-ultrasound)"
lab var q27i_gr_in_ro "Q27. GR/IN/RO only: Have you received any of the following health services in the past 12 months?"
lab var q27i_ng "Q27. NG only: Had sexual or reproductive health care such as family planning in the past 12 months"
lab var q27i_za "Q27. ZA only: Had a test for HIV in the past 12 months"
lab var q27j_cn "Q27j. CN only: Received a mammogram (a special X-ray of the breast)"
lab var q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
lab var q28_b "Q28b. You were treated unfairly or discriminated against in the past 12 months"
lab var q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
lab var q30 "Q30. The last time this happened, what was the main reason?"
lab var q30_other "Q30. Other"
lab var q31_a "Q31a. In the past 12 months, have you ever needed to borrow money from family, friends, or another source to pay for healthcare"
lab var q31_b "Q31b. In the past 12 months, have you ever needed to sell items such as furniture or jewelry to pay for healthcare"
lab var q31_lac "Q31. LAC only: In the last 12 months, have you stopped paying any utility bills (cable, electricity, water, etc.) to pay for healthcare?"
lab var q31c_ec "Q31c. EC only: Stopped paying any utilities (cable, electricity, water, etc.) to pay for healthcare"
lab var q32_ar "Q32. AR only: Is this facility Public, OSEP, or Private?"
lab var q32_cn "Q32. CN only: Last visit facility type public/private/social security/NGO/faith-based?"
lab var q32_co_pe_v1 "Q32 (V1.0). CO/PE only: Is this a public or private healthcare facility?"
lab var q32_co_pe_uy "Q32. CO/PE/UY only: Facility ownership"
lab var q32_ec "Q32. EC only: The facility of your last face-to-face visit is ... ?"
lab var q32_ec_other "Q32. EC only: Other"
lab var q32_it "Q32. IT only: Did you go to a public facility, a private facility accredited by the Servizio Sanitario Nazionale (SSN) or a private facility not accredited by SSN?"
lab var q32_kr "Q32. KR only: Is this...public, private, or non-profit/religious medical...?"
lab var q32_la "Q32. LA only: Is this a public or private hospital?"
lab var q32_multi "Q32. ET/IN/KE/NG/RO/ZA only: Is this a public, private, or NGO/faith-based facility?"
lab var q32_mx "Q32. MX only: Who runs this healthcare facility?"
lab var q32_other "Q32. Other"
lab var q32_other_gb "Q32. GB only: Other"
lab var q32_uy "Q32. UY only: Is this a public, private, or mutual healthcare facility?"
lab var q32a_gb "Q32a. GB only: Did you go to a national health service facility (NHS) or private?"
lab var q32a_gr "Q32a. GR only: Is this a public, private, contracted to public, or NGO healthcare facility?"
lab var q32a_gr_other "Q32a. Other"
lab var q32b_gb "Q32b. GB only: Did you go to a health and social care facility (HSC) or private?"
lab var q32b_gr "Q32b. GR only: In your last visit did you pay part of the healthcare cost or did you not pay at all?"
lab var q32_cn "Q32. CN only: Is this a public or private healthcare facility?"
lab var q32_so "Q32b. SO only: Was this a public, private or another type of facility?"
lab var q33 "Q33. What type of healthcare facility is this?"
lab var q33_other "Q33. Other"
lab var q33a_gr "Q33a. GR only: Can you please tell me the specialty of your provider in your last healthcare visit?"
lab var q33a_gr_other "Q33a. Other"
lab var q33b_gr "Q33b. GR only: The healthcare provider that you saw in your last visit was the personal doctor that you have registered with?"
lab var q33b_gr_other "Q33b. Other"
lab var q34 "Q34. What was the main reason you went?"
lab var q34_other "Q34. Other"
lab var q35 "Q35. Was this a scheduled visit or did you go without an appt.?"
lab var q36 "Q36. In days: how long between scheduling and seeing provider?"
lab var q36_v1 "Q36. In days: how long between scheduling and seeing provider? (V1.0)"
lab var q37 "Q37. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q37_v1 "Q37. In minutes: Approximately how long did you wait before seeing the provider? (V1.0)"
lab var q37_v1_other "Q37_Other (V1.0). Other"
lab var q37b_refused_v1 "Q37B. Refused (V1.0- Q46B refused)"
lab var q38_a "Q38a. How would you rate the overall quality of care you received?"
lab var q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
lab var q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
lab var q38_d "Q38d. How would you rate the level of respect your provider showed you?"
lab var q38_e "Q38e. How would you rate your provider knowledge about your prior visits?"
lab var q38_f "Q38f. How would you rate whether your provider explained things clearly?"
lab var q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
lab var q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
lab var q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
lab var q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
lab var q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
lab var q39 "Q39. How likely would recommend this facility to a friend or family member?"
lab var q40_a "Q40a. How would you rate the quality of care provided for care for pregnancy?"
lab var q40_b "Q40b. How would you rate the quality of care provided for children?"
lab var q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
lab var q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
lab var q40_e_ng "Q40e. NG only: How would you rate the quality of care provided for sexual or reproductive health?"
lab var q40a_so "Q40a. SO only: Care for pregnant women and newborns, such as antenatal care, delivery care, postnatal care, and family planning"
lab var q40b_so "Q40b. SO only: Care for infections such as Malaria, Tuberculosis etc."
lab var q40e_so "Q40e. SO only: First aid and care for emergency conditions such as injuries etc."
lab var q40f_so "Q40f. SO only: Care for other non-urgent common illnesses such as skin, ear conditions, stomach problems, urinary problems, joint paints etc."
lab var q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
lab var q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
lab var q41_c "Q41c. How confident are you that the government considers the public's opinion?"
lab var q42 "Q42. How would you rate the quality of public healthcare system in your country?"
lab var q43 "Q43. How would you rate the quality of private healthcare?"
*lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_multi "Q44. ET/GR/IN/KE/NG/RO/ZA only: How would you rate quality of NGO/faith-based healthcare?"
lab var q44_ec "Q44. EC only: How would you rate quality of the social security health system (IESS)?"
lab var q44_pe "Q44. PE only: How would you rate the quality of the social security system?"
lab var q44_uy "Q44. UY only: How would you rate the quality of the mutual healthcare system?"
lab var q44a_ar "Q44a. AR only: How would you rate the quality of care provided by OSEP of Mendoza?"
lab var q44a_mx "Q44a. MX only: How would you rate the quality of services provided by IMSS?"
lab var q44b_ar "Q44b. AR only: How would you rate the quality of the other 'obras sociales' health system?"
lab var q44b_mx "Q44b. MX only: How would you rate the quality of services...IMSS BIENESTAR?"
lab var q44c_ar "Q44c. AR only: How would you rate the quality of the PAMI health system in the province of Mendoza?"
lab var q45 "Q45. Is your country's health system is getting better, same or worse?s"
lab var q46 "Q46. Which of these statements do you agree with the most?"
lab var q46_refused_v1 "Q46 (V1.0). Refused"
lab var q47 "Q47. How would you rate the government's management of the COVID-19 pandemic?"
lab var q47_refused_v1 "Q47 (V1.0). Refused"
lab var q47_v1 "Q47 (V1.0). In minutes:  Approximately how much time did the provider spend with you?"
lab var q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q50 "Q50. Respondent's mother tongue or native language"
lab var q50_gb "Q50. GB only: What is your race?"
lab var q50_mx "Q50. MX only: Do you speak any indigenous language or dialect?"
lab var q50_other "Q50. Other"
*lab var q50_other_original 
lab var q50a_la "Q50a. LA only: What is your ethnicity?"
lab var q50a_other_la "Q50a. LA only: Other"
lab var q50a_us "Q50a. US only: What is your ethnicity?"
lab var q50b_other_us "Q50b. US only: Other"
lab var q50b_us "Q50b. US only: What is your race?"
lab var q51 "Q51. Total monthly household income"
lab var q51_cn "Q51a. CN only: What is the number of people in the household, including you, who live with you permanently?" 
lab var q51_gr "Q51. GR only: Including yourself, how many people aged 18 or older currently live in your household"
*lab var CELL1 "Do you have another mobile phone number besides the one I am calling you on?"
*lab var CELL2 "How many other mobile phone numbers do you have?"
lab var q52 "Q52. Which political party did you vote for in the last election?"
lab var q52_gb "Q52. GB only: Which political party did you vote for in the last election?"
lab var q52a_gr "Q52a. GR only: Do you happen to have a mobile phone or not?" 
lab var q52a_us "Q52a. US only: Republican, Democrat, an Independent, or something else?"
lab var q52b_gr "Q52b. GR only: Is this mobile phone your only phone, or do you also have a landline telephone at home that is used to makeand receive calls?"
lab var q52b_us "Q52b. US only: Do you lean more towards the Republican or Democratic Party?"

*------------------------------------------------------------------------------*
*Save recoded data

save "$data_mc/02 recoded data/input data files/pvs_appended_v2.dta", replace

*------------------------------------------------------------------------------*
