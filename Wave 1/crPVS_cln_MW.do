* People's Voice Survey data cleaning for Malawi - Wave 1
* Date of last update: July 2025
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Malawi. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** MALAWI ***********************

* Import raw data 
use "$data/Malawi/01 raw/Malawi_PVS_data_2025-06-20.dta",clear

*Label as wave 2 data:
gen wave = 2

* data cleaning:
drop interviewer_name Phone_Number_of_client q1 q1a cell1 cell1_1 cell2 cell3 cell3_1 ///
	 var104 var105 var106 var107 var108 var109 var110 var111 var112 var113 var114 var115 ///
	 var116 var117 var118 var119 var120 var121 var122 var123 agecat

*incorrectly coded:
drop ageband q15_other_001 //incorrectly has a response for 'other' even though other,specify wasn't selected. also the other q15_other has the same data

*confirm with Todd if ok to drop, we wouldn't use this:
drop q37_specify_hours q23a

*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

gen str respondent_id = "MW" + string(_n, "%03.0f")

gen reccountry = 6
lab def country 6 "Malawi"
lab values reccountry country

gen recmode = .
replace recmode = 1 if mode == "Phone"
replace recmode = 2 if mode == "Face to Face"
drop mode

lab def mode 1 "CATI" 2 "F2F"
lab var recmode mode

encode form_language, gen(language) 
drop form_language

rename q1b q1

ren q2 q2_mw
gen q2 = . 
replace q2 = 1 if q1 >= 18 & q1<30
replace q2 = 2 if q1 >= 30 & q1<40
replace q2 = 3 if q1 >= 40 & q1<50
replace q2 = 4 if q1 >= 50 & q1<60
replace q2 = 5 if q1 >= 60 & q1<70
replace q2 = 6 if q1 >= 70 & q1<80
replace q2 = 7 if q1 >= 80

replace q2 = 6 if q2_mw == "70 to 79"
replace q2 = 7 if q2_mw == "80 or older"

lab def q2_label 1 "18 to 29" 2	"30-39" 3 "40-49" 4	"50-59" 5 "60-69" 6	"70-79" 7 "80 or older"
lab val q2 q2_label
drop q2_mw

gen recq3 = .
replace recq3 = 0 if q3 == "Male"
replace recq3 = 1 if q3 == "Female"
drop q3

lab def q3_label 0 "Male" 1 "Female"
lab val recq3 q3_label

encode q4, gen(q4_mw) 
drop q4
encode q4_1, gen(q4) //confirm with team that they agree
drop q4_1

encode q5, gen(recq5) 
drop q5

encode q6, gen(recq6)
recode recq6 (1 = 0) (2 = .r) (3 = 1)
lab def q6_label 0 "No" 1 "Yes" .r "Refused"
lab val recq6 q6_label
drop q6

encode q7, gen(recq7)
drop q7

encode q8, gen(recq8)
drop q8

encode q50, gen(q47_mw)
drop q50
recode q47_mw (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q47_mw_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused" .a "NA"
lab val q47_mw q47_mw_label

encode q8a, gen(q50)
drop q8a

rename Q8a_other q50_other //confirm these recodings

encode q8b, gen(q51)
drop q8b

encode q9, gen(recq9)
recode recq9 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
drop q9
lab def q9_label 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" .r "Refused"
lab val recq9 q9_label

encode q10, gen(recq10)
recode recq10 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
drop q10
lab def q10_label 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" .r "Refused"
lab val recq10 q10_label

encode q11, gen(recq11)
recode recq11 (1 = 0) (2 = .r) (3 = 1)
drop q11
lab def q11_label 0 "No" 1 "Yes" .r "Refused"
lab val recq11 q11_label

encode q12a, gen(q12_a)
recode q12_a (1 = 0) (2 = 1) (3 = .r) (4 = 2) (5 = 3)
drop q12a
lab def q12_a_label 3 "Very confident" 2 "Somewhat confident" 1 "Not too confident" 0 "Not at all confident"
lab val q12_a q12_a_label

encode q12b, gen(q12_b)
recode q12_b (1 = 0) (2 = 1) (3 = .r) (4 = 2) (5 = 3)
drop q12b
lab def q12_b_label 3 "Very confident" 2 "Somewhat confident" 1 "Not too confident" 0 "Not at all confident"
lab val q12_b q12_b_label

encode q13, gen(recq13)
recode recq13 (1 = 0) (2 = 1)
drop q13
lab def q13_label 0 "No" 1 "Yes"
lab val recq13 q13_label

encode q14, gen(recq14_multi)
recode recq14_multi (4 = 1) (3 = 2) (1 = 3) (2 = 4)
drop q14
lab def q14_label 1	"Public" 2 "Private (for-profit)" 3	"NGO/Faith-based" 4 "Other, specify" .a "NA"
lab val recq14_multi q14_label

encode q15, gen(recq15)
recode recq15 (9 = .r) (6 = 10)
lab def recq15 10 "Other" .a "NA", modify
drop q15

encode q16, gen(recq16)
recode recq16 (1 = 8) (2 = 4) (3 = 1) (4 = 6) (5 = 7) (6 = 9) (7 = 2) (8 = 3) (9 = 5)
drop q16
lab def q16_label 1	"Low cost" 2 "Short distance" 3	"Short waiting time" 4 "Good healthcare provider skills" ///
				  5	"Staff shows respect" 6	"Medicines and equipment are available" 7 "Only facility available" ///
				  8	"Covered by insurance" 9 "Other, specify" .a "NA"
lab val recq16 q16_label

encode q17, gen(recq17)
recode recq17 (1 = 4) (2 = 1) (3 = 2) (4 = .a) (5 = 0) (6 = .r) (7 = 3)
drop q17
lab def q17_label 4 "Excellent"  3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" .a "NA" .r "Refused"
lab val recq17 q17_label

encode q19, gen(recq19)
recode recq19 (1 = 0) (2 = 1) (3 = 3) (4 = 2) (5 = .r)
drop q19
lab def q19_label 0	"0" 1 "1-4" 2 "5-9" 3 "10 or more" .a "NA" .r "Refused"
lab val recq19 q19_label

encode q20, gen(recq20)
recode recq20 (1 = 0) (2 = 1)
drop q20
lab def q20_label 0 "No" 1 "Yes" .a "NA"
lab val recq20 q20_label

encode q24, gen(recq24)
recode recq24 (4 = .r)
drop q24
lab def recq24 .r "Refused" .a "NA", modify

encode q25, gen(recq25)
recode recq25 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
drop q25
lab def q25_label 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" .r "Refused" .a "NA"
lab val recq25 q25_label

encode q26, gen(recq26)
recode recq26 (1 = 0) (2 = .r) (3 = 1)
drop q26 
lab def q26_label 0 "No" 1 "Yes" .r "Refused"
lab val recq26 q26_label

encode q27a, gen(recq27_a)
recode recq27_a (1 = 0) (2 = 1)
drop q27a
lab def q27a_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_a q27a_label

encode q27b, gen(recq27_b)
recode recq27_b (1 = 0) (2 = 1)
drop q27b
lab def q27b_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_b q27b_label

encode q27c, gen(recq27_c)
recode recq27_c (1 = 0) (2 = 1)
drop q27c
lab def q27c_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_c q27c_label

encode q27d, gen(recq27_d)
recode recq27_d (1 = 0) (2 = 1)
drop q27d
lab def q27d_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_d q27d_label

encode q27e, gen(recq27_e)
recode recq27_e (1 = 0) (2 = 1)
drop q27e
lab def q27e_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_e q27e_label
 
encode q27f, gen(recq27_f)
recode recq27_f (1 = 0) (2 = 1)
drop q27f
lab def q27f_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_f q27f_label
 
encode q27g, gen(recq27_g)
recode recq27_g (1 = 0) (2 = 1)
drop q27g
lab def q27g_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_g q27g_label

encode q27h, gen(recq27_h)
recode recq27_h (1 = 0) (2 = .r) (3 = 1)
drop q27h
lab def q27h_label 0 "No" 1 "Yes" .a "NA"
lab val recq27_h q27h_label
 
encode q28a, gen(recq28_a) 
recode recq28_a (1 = 0) (2 = .r) (3 = 1)
drop q28a 
lab def q28a_label 0 "No" 1 "Yes" .r "Refused" .a "NA"
lab val recq28_a q28a_label

encode q28b, gen(recq28_b) 
recode recq28_b (1 = 0) (2 = .r) (3 = 1)
drop q28b 
lab def q28b_label 0 "No" 1 "Yes" .r "Refused" .a "NA"
lab val recq28_b q28b_label

encode q29, gen(recq29) 
recode recq29 (1 = 0) (2 = .r) (3 = 1)
drop q29 
lab def q29_label 0 "No" 1 "Yes" .r "Refused" 
lab val recq29 q29_label

encode q30, gen(recq30) 
recode recq30 (1 = 2) (2 = 1) (3 = 7) (4 = 3) (5 = 6) (6 = 10) (7 = 4) (8 = .r) (9 = 5)
drop q30
lab def q30_label 1	"High cost (e.g., high out of pocket payment, not covered by insurance)" ///
				  2	"Far distance (e.g., too far to walk or drive, transport not readily available)" ///
				  3	"Long waiting time (e.g., long line to access facility, long wait for the provider)" ///
				  4	"Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)" ///
				  5	"Staff don't show respect (e.g., staff is rude, impolite, dismissive)" ///
				  6	"Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)" ///
				  7	"Illness not serious enough" 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)" 10 "Other" .a "NA"
lab val recq30 q30_label

encode q31a, gen(recq31a) 
drop q31a
recode recq31a (1 = 0) (2 = .r) (3 = 1)
lab def q31a_label 0 "No" 1 "Yes" .r "Refused"
lab val recq31a q31a_label

encode q31b, gen(recq31b) 
drop q31b
recode recq31b (1 = 0) (2 = .r) (3 = 1)
lab def q31b_label 0 "No" 1 "Yes" .r "Refused"
lab val recq31b q31b_label

encode q32, gen(recq32_multi) 
drop q32
recode recq32_multi (1 = 3) (2 = 2) (3 = 1) (4 = .r)
lab def q32_label 1	"Public" 2 "Private (for-profit)" 3	"NGO/Faith-based" .r "Refused" .a "NA"
lab val recq32_multi q32_label


encode q33, gen(recq33) 
drop q33
recode recq33 (9 = .r) (6 = 10)
lab def recq33 .r "Refused" 10 "Other (Specify)" .a "NA",modify


encode q34, gen(recq34) 
drop q34 
recode recq34 (4 = 3) (3 = 4) (5 = .r)
lab def q34_label 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)" ///
				  2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)" ///
				  3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)" ///
				  4 "Other, specify" .a "NA" .r "Refused"
lab val recq34 q34_label		  

encode q35, gen(recq35) 
drop q35
recode recq35 (2 = 0) (3 = .r)
lab def q35_label 0 "No, I did not have an appointment" 1 "Yes, the visit was scheduled, and I had an appointment" .r "Refused" .a "NA"
lab val recq35 q35_label	

encode q36, gen(recq36) 
drop q36
recode recq36 (9 = 1) (3 = 2) (2 = 3) (5 = 4) (1 = 5) (4 = 6) (6 = 7) (7 = 8) (8 = .r)
lab def q36_label 1	"Same or next day" 2 "2 days to less than one week" 3 "1 week to less than 2 weeks" ///
				  4	"2 weeks to less than 1 month" 5 "1 month to less than 2 months" 6 "2 months to less than 3 months" ///
				  7	"3 months to less than 6 months" 8	"6 months or more" .r "Refused" .a "NA"
lab val recq36 q36_label

encode q37, gen(recq37) 
drop q37
recode recq37 (6 = 1) (2 = 1) (5 = 3) (1 = 4) (3 = 5) (4 = 6) (7 = 7) (8 = .r)
lab def q37_label 1	"Less than 15 minutes" 2 "15 minutes to less than 30 minutes" 3	"30 minutes to less than 1 hour" ///
				  4	"1 hour to less than 2 hours" 5	"2 hours to less than 3 hours" 6 "3 hours to less than 4 hours" ///
				  7	"More than 4 hours (specify))" .a "NA" .r "Refused"
lab val recq37 q37_label
				  
encode q38a, gen(recq38_a)
drop q38a 
recode recq38_a (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q38_label 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair"  0 "Poor" .a "NA" .r "Refused"
lab val recq38_a q38_label      

encode q38b, gen(recq38_b)
drop q38b 
recode recq38_b (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_b q38_label
 
encode q38c, gen(recq38_c)
drop q38c 
recode recq38_c (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_c q38_label
 
encode q38d, gen(recq38_d)
drop q38d 
recode recq38_d (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_d q38_label

encode q38e, gen(recq38_e)
drop q38e 
recode recq38_e (1 = 4) (2 = 1) (3 = 2) (4 = .a) (5 = 0) (6 = .r) (7 = 3)
lab def q38_label2 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" ///
				   .a "NA or I have not had prior visits or tests" ///
				   .r "Refused" .a "NA"
lab val recq38_e q38_label2
 
encode q38f, gen(recq38_f)
drop q38f 
recode recq38_f (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_f q38_label
 
encode q38g, gen(recq38_g)
drop q38g 
recode recq38_g (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_g q38_label
 
encode q38h, gen(recq38_h)
drop q38h 
recode recq38_h (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_h q38_label
 
 
encode q38i, gen(recq38_i)
drop q38i 
recode recq38_i (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab val recq38_i q38_label
 
encode q38j, gen(recq38_j)
drop q38j 
recode recq38_j (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = .a) (7 = 3)
lab def q38_label3 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" ///
				   .a "NA or The clinic had no other staff" ///
				   .r "Refused"
lab val recq38_j q38_label3
 
encode q38k, gen(recq38_k)
drop q38k 
recode recq38_k (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = 3)
lab val recq38_k q38_label
 
encode q40a, gen(recq40_a)
drop q40a
recode recq40_a (1 = 4) (2 = 1) (3 = 2) (4 = .d) (5 = 0) (6 = .r) (7 = 3)
lab def q40_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" ///
				  .d "I am unable to judge" .r "Refused"
lab val recq40_a q40_label

encode q40b, gen(recq40_b)
drop q40b
recode recq40_b (1 = 4) (2 = 1) (3 = 2) (4 = .d) (5 = 0) (6 = .r) (7 = 3)
lab val recq40_b q40_label

encode q40c, gen(recq40_c)
drop q40c
recode recq40_c (1 = 4) (2 = 1) (3 = 2) (4 = .d) (5 = 0) (6 = .r) (7 = 3)
lab val recq40_c q40_label

encode q40d, gen(recq40_d)
drop q40d
recode recq40_d (1 = 4) (2 = 1) (3 = 2) (4 = .d) (5 = 0) (6 = .r) (7 = 3)
lab val recq40_d q40_label

encode q41a, gen(recq41_a)
drop q41a
recode recq41_a (1 = 0) (2 = 1) (3 = .r) (4 = 2) (5 = 3)
lab def q41_label 3	"Very confident" 2	"Somewhat confident" 1 "Not too confident" ///
				  0	"Not at all confident" .r "Refused"
lab val recq41_a q41_label

encode q41b, gen(recq41_b)
drop q41b
recode recq41_b (1 = 0) (2 = 1) (3 = .r) (4 = 2) (5 = 3)
lab val recq41_b q41_label

encode q41c, gen(recq41_c)
drop q41c
recode recq41_c (1 = 0) (2 = 1) (3 = .r) (4 = 2) (5 = 3)
lab val recq41_c q41_label

encode q42, gen(recq42)
drop q42
recode recq42 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q42_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq42 q42_label

encode q43, gen(recq43)
drop q43
recode recq43 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q43_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq43 q43_label

encode q44, gen(recq44_multi)
drop q44
recode recq44_multi (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q44_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq44_multi q44_label

encode q45, gen(recq45)
drop q45
recode recq45 (1 = 2) (2 = 0) (3 = .r) (4 = 1)
lab def q45_label 2	"Getting better" 1 "Staying the same" 0	"Getting worse" .r "Refused"
lab val recq45 q45_label

encode q46, gen(recq46)
drop q46
recode recq46 (4 = .r)
lab def recq46 .r "Refused", modify

encode q47, gen(recq47)
drop q47
recode recq47 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q47_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq47 q47_label

encode q48, gen(recq48)
drop q48
recode recq48 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q48_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq48 q48_label

encode q49, gen(recq49)
drop q49
recode recq49 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
lab def q49_label 4	"Excellent" 3 "Very good" 2	"Good" 1 "Fair" 0 "Poor" .r	"Refused"
lab val recq49 q49_label

ren rec* *

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = country*1000 + language  

gen recq4 = country*1000 + q4
*replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
*replace recq5 = .r if q5 == 999

gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 999

gen recq8 = country*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
*replace recq15 = .r if q15== 999
*replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
replace recq33 = .r if q33== 999 
*replace recq33 = .d if q33== 998

gen recq50 = country*1000 + q50 
*replace recq50 = .r if q50== 999

gen recq51 = country*1000 + q51
replace recq51 = .r if q51== 6

* Relabel some variables now so we can use the orignal label values
label define country_short 6 "MW" 
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l q4
local q5l recq5
local q7l recq7
local q8l recq8
local q15l recq15
local q33l recq33
local q50l q50
local q51l q51

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

	forvalues i = 1/``q'n' {
		local recvalue`q' = 6000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 6000+`: word `i' of ``q'val'') ///
									    (`"MW: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}




*****************************

drop q4 q5 q7 q8 q15 q33 q50 q51 language
ren rec* *

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables (Ask todd if i should create a date var using start and end)

* Interview length:
	* Remove the timezone 
	gen str23 start_clean = substr(start, 1, 23)
	gen str23 end_clean   = substr(end, 1, 23)

	* Replace "T" with a space to match Stata format 
	replace start_clean = subinstr(start_clean, "T", " ", 1)
	replace end_clean   = subinstr(end_clean, "T", " ", 1)

	* Convert string to %tc
	gen double start_dt = clock(start_clean, "YMDhms#")
	gen double end_dt   = clock(end_clean, "YMDhms#")

	* Format
	format start_dt %tc
	format end_dt %tc

	* Calculate duration (in milliseconds)
	gen double interview_duration_ms = end_dt - start_dt

	* Convert to minutes
	gen double int_length = interview_duration_ms / 60000

	drop start end start_clean end_clean start_dt interview_duration_ms 
	
	gen double date = dofc(end_dt) //confirm with Todd we want to use this var
	format date %tdDDmonCCYY 

* q18/q19 mid-point var 
	gen q18_q19 = q18 // con firm with Todd how we should create the rest
	/*recode q18_q19 (. = 0) if q19 == 0
	recode q18_q19 (. = 1) if q19 == 1
	recode q18_q19 (. = 2.5) if q19 == 2
	recode q18_q19 (. = 7) if q19 == 3
	recode q18_q19 (. = 10) if q19 == 4 */
	   
*------------------------------------------------------------------------------*
* Check for implausible values 

* Q17. Overall respondent's rating of the quality received in this facility
* Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)
* Q20. Were all of the visits you made to the same healthcare facility? 
* Q21. How many different healthcare facilities did you go to? 
* Q22. How many visits did you have with a healthcare provider at your home?
* Q23. How many virtual or telemedicine visits did you have?

* Q20, Q21
list q18_q19 q19 q21 if q21 > q18_q19 & q21 < . 
*replace q21 = q18_q19 if q21 > q18_q19 & q21 < . // Ask todd what to do about discrepant info between q18 and q19

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . // N=6
replace q21 = . if q20 ==1 // * confirm how to recode 

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .

recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=0 changes

drop visits_total

*------------------------------------------------------------------------------*
* Recode missing values to NA for intentionally skipped questions (q14, q32 missing in this dataset)

*q1/q2 - no missing data

* q7 
recode q7 (. = .a) if q6 !=1
recode q7 (nonmissing = .a) if q6 == 0

*q14-17
recode q14_multi q15 q16 q17 (. = .a) if q13 !=1

* NA's for q19-21 
*recode q19 (. = .a) if q18 != .d | q18 !=.r

recode q20 (. = .a) if q18 <1 | q18 == .d | q18 == .r | q19 != 2 | q19 != 3 | q19 != 4

recode q21 (. = .a) if q20 !=0 

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0  | q23 == .d | q23 == .r
replace q24_other = .a if q24 !=4
tostring q24_other,replace

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=1 

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 1 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (. = .a) if q29 !=1

* q32
replace q32_other = .a if q32_multi !=4
tostring q32_other,replace

* q33-38
recode q32_multi q33 q34 q35 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 != 2 | q19 != 3 | q19 != 4
													 
replace q38_e = .a if q38_e == 5  // I have not had prior visits or tests or The clinic had no other staff
replace q38_j = .a if q38_j == 5  // I have not had prior visits or tests or The clinic had no other staff													 

recode q36 q38_k (. = .a) if q35 !=1	
			
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

lab def lang 6001 "Chichewa" 6002 "English" 6003 "Tumbuka"
lab val language lang

lab def q7_label .a "NA", modify

lab def q21_label .a "NA"
lab val q21 q21_label

lab def q39_label .a "NA"
lab val q39 q39_label

lab def q51_label .r "Refused", modify

*------------------------------------------------------------------------------*
* Renaming variables 

*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
label copy q50_label q50_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label q33_label q50_label q51_label

*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other"

gen q14_other_original = q14_other
label var q14_other_original "Q14. Other"	
	
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
	
gen q34_other_original = q34_other
label var q34_other_original "Q34. Other"	

gen q50_other_original = q50_other 
label var q50_other_original "Q50. Other"	

foreach i in 6 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q14_other q15_other q16_other q24_other q30_other q32_other q34_other q50_other
	 
ren q7_other_original q7_other
ren q14_other_original q14_other
ren q15_other_original q15_other
ren q16_other_original q16_other
ren q24_other_original q24_other
ren q30_other_original q30_other
ren q32_other_original q32_other
ren q34_other_original q34_other
ren q50_other_original q50_other

*------------------------------------------------------------------------------*/

* Reorder variables

	order q*, sequential
	order respondent_id wave country language mode date int_length // weight

*------------------------------------------------------------------------------*

* Save data
 save "$data_mc/02 recoded data/input data files/pvs_mw.dta", replace

*------------------------------------------------------------------------------*

