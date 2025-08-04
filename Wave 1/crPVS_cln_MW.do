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
	 var116 var117 var118 var119 var120 var121 var122 var123

*incorrectly coded:
drop ageband
* start end = use this to generate int_length and then drop

*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

gen reccountry = 23
lab def country 23 "Nepal"
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
lab def q14_label 1	"Public" 2 "Private (for-profit)" 3	"NGO/Faith-based" 4 "Other, specify"
lab val recq14_multi q14_label

encode q15, gen(recq15)
recode recq15 (9 = .r) (6 = 10)
lab def recq15 10 "Other", modify
drop q15

encode q16, gen(recq16)
recode recq16 (1 = 8) (2 = 4) (3 = 1) (4 = 6) (5 = 7) (6 = 9) (7 = 2) (8 = 3) (9 = 5)
drop q16
lab def q16_label 1	"Low cost" 2 "Short distance" 3	"Short waiting time" 4 "Good healthcare provider skills" ///
				  5	"Staff shows respect" 6	"Medicines and equipment are available" 7 "Only facility available" ///
				  8	"Covered by insurance" 9 "Other, specify"
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
lab def q20_label 0 "No" 1 "Yes"
lab val recq20 q20_label

encode q24, gen(recq24)
recode recq24 (4 = .r)
drop q24
lab def recq24 .r "Refused", modify

encode q25, gen(recq25)
recode recq25 (1 = 4) (2 = 1) (3 = 2) (4 = 0) (5 = .r) (6 = 3)
drop q25
lab def q25_label 4 "Excellent" 3 "Very good" 2 "Good" 1 "Fair" 0 "Poor" .r "Refused"
lab val recq25 q25_label

encode q26, gen(recq26)
recode recq26 (1 = 0) (2 = .r) (3 = 1)
drop q26 
lab def q26_label 0 "No" 1 "Yes" .r "Refused"
lab val recq26 q26_label

encode q27a, gen(recq27_a)
recode recq27_a (1 = 0) (2 = 1)
drop q27a
lab def q27a_label 0 "No" 1 "Yes"
lab val recq27_a q27a_label

encode q27b, gen(recq27_b)
recode recq27_b (1 = 0) (2 = 1)
drop q27b
lab def q27b_label 0 "No" 1 "Yes"
lab val recq27_b q27b_label

encode q27c, gen(recq27_c)
recode recq27_c (1 = 0) (2 = 1)
drop q27c
lab def q27c_label 0 "No" 1 "Yes"
lab val recq27_c q27c_label

encode q27d, gen(recq27_d)
recode recq27_d (1 = 0) (2 = 1)
drop q27d
lab def q27d_label 0 "No" 1 "Yes"
lab val recq27_d q27d_label

encode q27e, gen(recq27_e)
recode recq27_e (1 = 0) (2 = 1)
drop q27e
lab def q27e_label 0 "No" 1 "Yes"
lab val recq27_e q27e_label
 
encode q27f, gen(recq27_f)
recode recq27_f (1 = 0) (2 = 1)
drop q27f
lab def q27f_label 0 "No" 1 "Yes"
lab val recq27_f q27f_label
 
encode q27g, gen(recq27_g)
recode recq27_g (1 = 0) (2 = 1)
drop q27g
lab def q27g_label 0 "No" 1 "Yes"
lab val recq27_g q27g_label
 
encode q27h, gen(recq27_h)
recode recq27_h (1 = 0) (2 = 1)
drop q27h
lab def q27h_label 0 "No" 1 "Yes"
lab val recq27_h q27h_label
 
encode q28a, gen(recq28_a) 
recode recq28_a (1 = 0) (2 = .r) (3 = 1)
drop q28a 
lab def q28a_label 0 "No" 1 "Yes" .r "Refused"
lab val recq28_a q28a_label

encode q28b, gen(recq28_b) 
recode recq28_b (1 = 0) (2 = .r) (3 = 1)
drop q28b 
lab def q28b_label 0 "No" 1 "Yes" .r "Refused"
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
				  7	"Illness not serious enough" 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)" 10 "Other"
lab val recq30 q30_label


























 
 
 
 
 
 


