* People's Voice Survey data cleaning for Ecuador - Wave 1
* Date of last update: April 18, 2024
* Last updated by: S Islam

/*

This file cleans Ipsos data for Ecuador. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ECUADOR ***********************

* Import raw data 
import spss using "$data/Ecuador/01 raw data/EC_240175630102_GENTE_CERRADAS (1).sav", case(lower)


*Label as wave 1 data:
gen wave = 1

*Dropping consent qs:
drop f0 f1 f3

*------------------------------------------------------------------------------*
* Rename variables  

rename rango q2

rename (genero p3_a) (q3 q3a_co_pe_uy_ar)

rename (p4 p5) (q4 q5)

rename (p8 p9 p10 p11) (q8 q9 q10 q11)

rename (p12a p12b) (q12_a q12_b)

rename (p13 p13_a p13_a_4) (q13 q13a_ec q13a_ec_other)

rename (p14 p14_7) (q14_ec q14_ec_other)

rename (p16 p16_10) (q16 q16_other)

rename (p17 p20) (q17 q20)

rename (p24 p24_4) (q24 q24_other)

rename (p25 p26 p29) (q25 q26 q29)

rename (p27a p27b p27c p27d p27e p27f p27g p27h p28a p28b) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a q28_b)

rename (p30 p30_10) (q30 q30_other)

rename (p31a p31b p31c) (q31a q31b q31c_ec)

rename (p32 p32_7) (q32_ec q32_ec_other)

rename (p34 p34_4) (q34 q34_other)

rename (p35 auxp36 p37 p37_7) (q35 q36 q37 q37_other)

rename (p38a p38b p38c p38d p38e p38f p38g p38h p38i p38j p38k) (q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k)

rename (p40a p40b p40c p40d p41a p41b p41c) (q40_a q40_b q40_c q40_d q41_a q41_b q41_c)

rename (p42 p43 p44 p45 p46 p47 p48 p49 p50 p51) (q42 q43 q44_ec q45 q46 q47 q48 q49 q50 q51)

replace p1_c_0 = 999 if p1_c_0 == .
ren p1_c_0 q1
drop p1

* SI NOTE: p18 checks if the question was answered, while response values are retained in p18_c_1. If they said don't know or refused for p18, then p18_c_1 is missing so we recode those missings from p18 and keep all other response values. (Same for p21, p22, p23, p39, cell2)
replace p18_c_1 = p18 if p18_c_1 == .
rename p18_c_1 q18
drop p18 aux /// Note: aux is same as p18_c_1

rename p19 q19
drop auxa auxb auxc /// Note: these are same as q19

replace p21_c_1 = p21 if p21 == 998
rename p21_c_1 q21
drop p21

replace p22_c_1 = p22 if p22 == 998
rename p22_c_1 q22
drop p22

replace p23_c_1 = p23 if p23 == 998
rename p23_c_1 q23
drop p23

replace p39_c_1 = p39 if p39 == 999
rename p39_c_1 q39
drop p39

replace cell2_c_1 = cell1 if cell1 == 999
drop cell2
rename cell2_c_1 cell2

* Duplicate var - same as q36 with extra numbers
drop p36

*------------------------------------------------------------------------------*
* Generate recoded variables

gen country = 1
lab def country 1 "Ecuador"
lab values country country

* Generate q6 from p61 p62 p63 p64 p65 p66 p67 p68
* SI Note: response options for q6 were stored as separate variables so will recode these into q7 below
* Checked crosstabs of p61-p68 looks like if they responded p61 "I don't have coverage" as Yes they were not asked p62-p68
gen recq6 = .
replace recq6 = 0 if p61 == 1
replace recq6 = 1 if p62 == 1 | p63 == 1 | p64 == 1 | p65 == 1 | p66 == 1 | p67 == 1
replace recq6 = .r if p68 == 1

* Recode q7 
* q7 is which insurance do you use more frequently? If they chose that they have more than one source of insurance in q6, retain response for q7. If they only have one source of insurance, q7 was not asked and the response is originally coded as missing (.). We will recode these missings in q7 based on the response option chosen in q6.
gen recq7 = p7
replace recq7 = 1 if p7 == . & p62 == 1
replace recq7 = 2 if p7 == . & p63 == 1
replace recq7 = 3 if p7 == . & p64 == 1
replace recq7 = 4 if p7 == . & p65 == 1
replace recq7 = 5 if p7 == . & p66 == 1
replace recq7 = 6 if p7 == . & p67 == 1
replace recq7 = .r if p7 == . & p68 == 1
replace recq7 = .a if p7 == . & p61 == 1 /// Note: missing q7 only if they indicated they do not have insurance 

gen q7_other = p6_6
drop p61 p62 p63 p64 p65 p66 p67 p68 p6_6 p7

*Condensing q15 and q33 into one variable - need to check if this looks right?
* Recode q15
gen q15 = .
replace q15 = 1 if p15_1 == 1
replace q15 = 2 if p15_1 == 2
replace q15 = 3 if p15_1 == 3
replace q15 = 4 if p15_1 == 4
replace q15 = 5 if p15_2 == 1
replace q15 = 6 if p15_2 == 2
replace q15 = 7 if p15_2 == 3
replace q15 = 8 if p15_2 == 4
replace q15 = 9 if p15_2 == 5
replace q15 = 10 if p15_2 == 6
replace q15 = 11 if p15_3 == 1
replace q15 = 12 if p15_3 == 2
replace q15 = 13 if p15_3 == 3
replace q15 = 14 if p15_3 == 4
replace q15 = 15 if p15_4 == 1
replace q15 = 16 if p15_4 == 2
replace q15 = 17 if p15_4 == 3
replace q15 = 18 if p15_4 == 4
replace q15 = 19 if p15_5 == 1
replace q15 = 20 if p15_5 == 2
replace q15 = 21 if p15_5 == 3
replace q15 = 22 if p15_5 == 4
replace q15 = 23 if p15_6 == 1
replace q15 = 24 if p15_6 == 2
replace q15 = 25 if p15_6 == 3
replace q15 = 26 if p15_6 == 4
replace q15 = 27 if p15_7 == 7
replace q15 = 28 if p15_7 == 8
replace q15 = .r if p15_1 == 999 | p15_2 == 999 | p15_3 == 999 | p15_4 == 999 | p15_5 == 999 | p15_6 == 999 | p15_7 == 999

gen q15_other = ""
replace q15_other = p15_1_3 if p15_1 == 3
replace q15_other = p15_1_4 if p15_1 == 4
replace q15_other = p15_2_5 if p15_2 == 5
replace q15_other = p15_2_6 if p15_2 == 6
replace q15_other = p15_3_3 if p15_3 == 3
replace q15_other = p15_3_4 if p15_3 == 4
replace q15_other = p15_4_3 if p15_4 == 3
replace q15_other = p15_4_4 if p15_4 == 4
replace q15_other = p15_5_3 if p15_5 == 3
replace q15_other = p15_5_4 if p15_5 == 4
replace q15_other = p15_6_5 if p15_6 == 5
replace q15_other = p15_6_6 if p15_6 == 6
replace q15_other = p15_7_7 if p15_7 == 7
replace q15_other = p15_7_8 if p15_7 == 8

* Recode q33
gen q33 = .
replace q33 = 1 if p33_1 == 1
replace q33 = 2 if p33_1 == 2
replace q33 = 3 if p33_1 == 3
replace q33 = 4 if p33_1 == 4
replace q33 = 5 if p33_2 == 1
replace q33 = 6 if p33_2 == 2
replace q33 = 7 if p33_2 == 3
replace q33 = 8 if p33_2 == 4
replace q33 = 9 if p33_2 == 5
replace q33 = 10 if p33_2 == 6
replace q33 = 11 if p33_3 == 1
replace q33 = 12 if p33_3 == 2
replace q33 = 13 if p33_3 == 3
replace q33 = 14 if p33_3 == 4
replace q33 = 15 if p33_3 == 5
replace q33 = 16 if p33_3 == 6
replace q33 = 17 if p33_4 == 1
replace q33 = 18 if p33_4 == 2
replace q33 = 19 if p33_4 == 3
replace q33 = 20 if p33_4 == 4
replace q33 = 21 if p33_4 == 5
replace q33 = 22 if p33_4 == 6
replace q33 = 23 if p33_5 == 1
replace q33 = 24 if p33_5 == 2
replace q33 = 25 if p33_5 == 3
replace q33 = 26 if p33_5 == 4
replace q33 = 27 if p33_5 == 5
replace q33 = 28 if p33_5 == 6
replace q33 = 29 if p33_6 == 1
replace q33 = 30 if p33_6 == 2
replace q33 = 31 if p33_6 == 3
replace q33 = 32 if p33_6 == 4
replace q33 = 33 if p33_6 == 5
replace q33 = 34 if p33_6 == 6
replace q33 = 35 if p33_7 == 1
replace q33 = 36 if p33_7 == 2
replace q33 = .r if p33_1 == 999 | p33_2 == 999 | p33_3 == 999 | p33_4 == 999 | p33_5 == 999 | p33_6 == 999 | p33_7 == 999

gen q33_other = ""
replace q33_other = p33_1_3 if p33_1 == 3
replace q33_other = p33_1_4 if p33_1 == 4
replace q33_other = p33_2_5 if p33_2 == 5
replace q33_other = p33_2_6 if p33_2 == 6
replace q33_other = p33_3_3 if p33_3 == 3
replace q33_other = p33_3_4 if p33_3 == 4
replace q33_other = p33_4_3 if p33_4 == 3
replace q33_other = p33_4_4 if p33_4 == 4
replace q33_other = p33_5_3 if p33_5 == 3
replace q33_other = p33_5_4 if p33_5 == 4
replace q33_other = p33_6_5 if p33_6 == 5
replace q33_other = p33_6_6 if p33_6 == 6
replace q33_other = p33_7_1 if p33_7 == 1
replace q33_other = p33_7_2 if p33_7 == 2

drop p15_1 p15_1_3 p15_1_4 p15_2 p15_2_5 p15_2_6 p15_3 p15_3_3 p15_3_4 p15_4  ///
p15_4_3 p15_4_4 p15_5 p15_5_3 p15_5_4 p15_6 p15_6_5 p15_6_6 p15_7 p15_7_7 p15_7_8 ///
p33_1 p33_1_3 p33_1_4 p33_2 p33_2_5 p33_2_6 p33_3 p33_3_3 p33_3_4 p33_4 p33_4_3 p33_4_4 ///
p33_5 p33_5_3 p33_5_4 p33_6 p33_6_5 p33_6_6 p33_7 p33_7_1 p33_7_2             
ren rec* *

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

*gen reclanguage = country*1000 + language // SI: missing from dataset
*gen recinterviewer_id = country*1000 + interviewer_id // SI: missing from dataset

gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 999

gen recq8 = country*1000 + q8
replace recq8 = .r if q8== 999

gen recq50 = country*1000 + q50 
replace recq50 = .r if q50== 999

gen recq51 = country*1000 + q51
replace recq51 = .r if q51== 999
replace recq51 = .d if q51== 998

local q4l labels7
local q5l labels8
local q8l labels11
local q50l labels82
local q51l labels83

foreach q in q4 q5 q8 q50 q51 {
	qui elabel list ``q'l'
	local `q'n = r(k)
	local `q'val = r(values)
	local `q'lab = r(labels)
	local g 0
	foreach i in ``q'lab'{
		local ++g
		* Keep everything starting from the first letter gets rid of extra leading numbers/spaces in the label
		if regexm("`i'", "[A-Za-z].*") {
			local gr`g' = regexs(0)
		}
		else {
			local gr`g' `i'
		}
	}

	qui levelsof rec`q', local(`q'level)

	forvalues i = 1/``q'n' {
		local recvalue`q' = 1000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 1000+`: word `i' of ``q'val'') ///
									    (`"EC: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

drop q4 q5 q8 q50 q51
ren rec* *

*------------------------------------------------------------------------------*
* Generate variables 

* q18/q19 mid-point var 
*SI: note, q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* Q40a-d 6 = "I am unable to judge" "no podria juzgar" recoded as "don't know"
recode q40_a q40_b q40_c q40_d (6 = .d)

* In raw data, 998 = "don't know" "no sabe"
recode q18 q21 q22 q23 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h ///
	   q32_ec cell1 cell2 (998 = .d)

* In raw data, 999 = "refused" "no responde"
recode q1 q2 q3 q3a_co_pe_uy_ar q4 q5 q8 q9 q10 q11 q12_a q12_b q13 q13a_ec q14_ec q16 q17 q18 q19 q20 q21 ///
	   q22 q23 q25 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a ///
	   q28_b q29 q30 q31a q31b q31c_ec q32_ec q34 q35 q36 q37 q38_a q38_b q38_c ///
	   q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b q40_c ///
	   q40_d q41_a q41_b q41_c q42 q43 q44 q45 q46 q47 q48 q49 cell1 ///
	   cell2 (999 = .r)
	   
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
*None

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < .
recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=100 changes

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions

*q1/q2 - no missing data

* q7 missing recoded in code above

*q13a_ec
recode q13a_ec (. = .a) if q13 !=0

*q14_ec-17
recode q14_ec q15 q16 q17 (. = .a) if q13 !=1 | q17 == 5

* NA's for q19-21 
recode q19 (. = .a) if q18 != .d | q18 !=.r

recode q20 (. = .a) if q18 <1 | q18 == .d | q18 == .r | q19 != 2 | q19 != 3 | q19 != 4

recode q21 (. = .a) if q20 !=0 

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0  | q23 == .d | q23 == .r

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=1 

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 1 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (. = .a) if q29 !=1

* q32-39
recode q32_ec q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r

recode q36 q38_k (. = .a) if q35 !=1

recode cell2 (. = .a) if cell1 !=1		
									 
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

*Recode Spanish to English

recode q2 (1 = 1 "18 to 29") (2 = 2 "30-39") (3 = 3 "40-49") (4 = 4 "50-59") (5 = 5 "60-69") (6 = 6 "70-79") (7 = 7 "80 or older") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q2_label)

recode q3 (0 = 0 "Male") (1 = 1 "Female"), pre(rec) label(gender)

recode q3a_co_pe_uy_ar (0 = 0 "Man") (1 = 1 "Woman"), pre(rec) label(gender2)
	
recode q5 (1001 = 1001 "EC: City") (1002 = 1002 "EC: Town") (1003 = 1003 "EC: Rural area") (.r = .r "Refused") (.a = .a "NA"), ///
pre(rec) label(q5_label)

lab def q6_label 1 "Yes" 0 "No"
lab val q6 q6_label

replace q7 = country*1000 + q7 if q7 != .a
lab def q7_label 1000 "EC: There is not one that I use more frequently" 1001 "EC: IESS: Social Security" ///
1002 "EC: ISSFA: Health Insurance of the Armed Forces" 1003 "EC: ISSPOL: Health Insurance of the National Police" ///
1004 "EC: Private: Private insurance includes insurance in clinics or private insurers" 1005 "EC: More than one private insurance" ///
1006 "EC: Other"
lab val q7 q7_label

recode q8 (1001 = 1001 "EC: None") (1002 = 1002 "EC: Initial/preschool") (1003 = 1003 "EC: Primary") ///
(1004 = 1004 "EC: Baccalaureate") (1005 = 1005 "EC: Non-university higher education") (1006 = 1006 "EC: University") ///
(1007 = 1007 "EC: Postgraduate"), pre(rec) label(q8_label)

recode q9 q10 (0 = 0 "Poor") (1 = 1 "Fair") (2 = 2 "Good") (3 = 3 "Very good") (4 = 4 "Excellent"), pre(rec) label(q9q10_label)

recode q12_a q12_b (0 = 0 "Not at all confident") (1 = 1 "Not too confident") (2 = 2 "Somewhat confident") (3 = 3 "Very confident"), pre(rec) label(q12_label)

recode q13a_ec (0 = 0 "No") (1 = 1 "Yes, a pharmacy") (2 = 2 "Yes, a healer or other traditional medicine practitioner, such as sobadoras, midwives, yachacs, taitas, and shamans") ///
(3 = 3 "Yes, alternative medicine, such as acupuncture, traditional chinese medicine, and reiki") (4 = 4 "Yes, other"), pre(rec) label(q13a_ec_label)

recode q14_ec (1 = 1 "Ministry of Public Health") (2 = 2 "Private or individual") (3 = 3 "IESS: Social Security") ///
(4 = 4 "ISSFA: Health Insurance of the Armed Forces") (5 = 5 "ISSPOL: Health Insurance of the National Police") ///
(6 = 6 "Private by referral from the IESS") (7 = 7 "Other, specify") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(q14_ec_label)

replace q15 = country*1000 + q15 if q15 != .a
lab def q15_label 1001 "EC: Subcenter/Health Center" 1002 "EC: Hospital" 1003 "EC: Other primary care facility, specify" 1004 "EC: Another secondary care facility, specify" 1005 "EC: Health Center" 1006 "EC: Private Office" 1007 "EC: Clinic" 1008 "EC: Hospital" 1009 "EC: Other primary care facility, specify" 1010 "EC: Another secondary care facility, specify" 1011 "EC: Health Center/Dispensary" 1012 "Hospital" 1013 "EC: Other primary care facility, specify" 1014 "EC: Another secondary care facility, specify" 1015 "EC: Health Center" 1016 "EC: Hospital" 1017 "EC: Other primary care facility, specify" 1018 "EC: Another secondary care facility, specify" 1019 "EC: Health Center" 1020 "EC: Hospital" 1021 "EC: Other primary care facility, specify" 1022 "EC: Another secondary care facility, specify" 1023 "EC: Health Center" 1024 "EC: Hospital" 1025 "EC: Other primary care facility, specify" 1026 "EC: Another secondary care facility, specify" 1027 "EC: Other primary care facility, specify" 1028 "EC: Another secondary care facility, specify"
lab val q15 q15_label

recode q16 (1 = 1 "Low cost") (2 = 2 "Short distance") (3 = 3 "Short waiting time") (4 = 4 "Good healthcare provider skills") ///
(5 = 5 "Staff shows respect") (6 = 6 "Medicines and equipment are available") (7 = 7 "Only facility available") (8 = 8 "Covered by insurance") ///
(9 = 16 "EC: Ease of getting appointment") (10 = 9 "Other, specify") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(q16_label)

*fix q19
recode q19 (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q19_label)


recode q24 (1 = 1 "Care for an urgent or new health problem such as an accident or injury or a new symptom like fever, pain, diarrhea, or depression.") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease such as hypertension or diabetes. This may include mental health conditions.") ///
		   (3 = 3 "Preventive care or a visit to check on your health, such as an annual check-up, antenatal care, or vaccination.")  ///
		   (4 = 4 "Other (specify)") (99 = .r "Refused") (.a = .a "NA") ///
		   (.d = .d "Don't know"), pre(rec) label(q24_label)
		   
recode q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h (0 = 0 "No") (1 = 1 "Yes") ///
(.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q27_label)

recode q28_a q28_b (0 = 0 "No") (1 = 1 "Yes") (998 = .r "Refused") ///
(.a = .a "NA") (.d = .d "Don't know"), pre(rec) label(q28_label)
		   
recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") ///
		   (8 = 19 "EC: Insurance problems (e.g., my insurance expired, I was not eligible for it)") ///
		   (9 = 20 "EC: Difficulty getting an appointment (e.g., there was no appointment, appointments were scheduled far in advance)") ///
		   (8 = 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)") ///
		   (9 = 9 "COVID-19 fear") ///
		   (10 = 10 "Other") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q30_label)
		   
recode q32_ec (1 = 1 "Ministry of Public Health") (2 = 2 "Private or individual") (3 = 3 "IESS: Social Security") ///
(4 = 4 "ISSFA: Health Insurance of the Armed Forces") (5 = 5 "ISSPOL: Health Insurance of the National Police") ///
(6 = 6 "Private by referral from the IESS") (7 = 7 "Other, specify") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(q32_ec_label)

replace q33 = country*1000 + q33 if q33 != .a
/// Note: .r got dropped as . when computing country-specific response values
replace q33 = .r if q33 == .
lab def q33_label 1001 "EC: Subcenter/Health Center" 1002 "EC: Hospital" 1003 "EC: Other primary care facility, specify" 1004 "EC: Another secondary care facility, specify" 1005 "EC: Health Center" 1006 "EC: Private Office" 1007 "EC: Clinic" 1008 "EC: Hospital" 1009 "EC: Other primary care facility, specify" 1010 "EC: Another secondary care facility, specify" 1011 "EC: Health Center" 1012 "EC: Private Office" 1013 "EC: Clinic" 1014 "EC: Hospital" 1015 "EC: Other primary care facility, specify" 1016 "EC: Another secondary care facility, specify" 1017 "EC: Health Center" 1018 "EC: Private Office" 1019 "EC: Clinic" 1020 "EC: Hospital" 1021 "EC: Other primary care facility, specify" 1022 "EC: Another secondary care facility, specify" 1023 "EC: Health Center" 1024 "EC: Private Office" 1025 "EC: Clinic" 1026 "EC: Hospital" 1027 "EC: Other primary care facility, specify" 1028 "EC: Another secondary care facility, specify" 1029 "EC: Health Center" 1030 "EC: Private Office" 1031 "EC: Clinic" 1032 "EC: Hospital" 1033 "EC: Other primary care facility, specify" 1034 "EC: Another secondary care facility, specify" 1035 "EC: Other primary care facility, specify" 1036 "EC: Another secondary care facility, specify" 
lab val q33 q33_label

recode q34 (1 = 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)") ///
		   (3 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") /// 
		   (4 = 4 "Other (specify)") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused"), pre(rec) label(q34_label)
		   
recode q35 (0 = 0 "No, I did not have an appointment") (1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
(.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q35_label)

recode q36 (1 = 1 "Same or next day") (2 = 2 "2 days to less than one week") (3 = 3 "1 week to less than 2 weeks") ///
(4 = 4 "2 weeks to less than 1 month") (5 = 5 "1 month to less than 2 months") (6 = 6 "2 months to less than 3 months") ///
(7 = 7 "3 months to less than 6 months") (8 = 8 "6 months or more") (.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), ///
pre(rec) label(q36_label)

recode q37 (1 = 1 "Less than 15 minutes") (2 = 2 "15 minutes to less than 30 minutes") (3 = 3 "30 minutes to less than 1 hour") ///
(4 = 4 "1 hour to less than 2 hours") (5 = 5 "2 hours to less than 3 hours") (6 = 6 "3 hours to less than 4 hours") ///
(7 = 7 "More than 4 hours (specify)") (.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q37_label)

lab def q39_label 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" ///
.a "NA" .d "Don't know" .r "Refused"
lab val q39 q39_label

recode q41_a q41_b q41_c (0 = 0 "Not at all confident") (1 = 1 "Not too confident") (2 = 2 "Somewhat confident") (3 = 3 "Very confident") ///
(.d = .d "Don't know") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(q41_label)
		   
recode q45 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	
recode q46 ///
	(1 = 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it.") ///
	(2 = 2 "There are some good things in our healthcare system, but major changes are needed to make it work better.") ///
	(3 = 3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better.") ///
	(.r = .r "Refused") , pre(rec) label(q46_label)
	
recode q50 ///
	(1013 = 1013 "EC: Kichwa") (1014 = 1014 "EC: Other native or original language") ///
	(1015 = 1015 "EC: Español-castellano") (1017 = 1017 "Other foreign language") ///
	(.r = .r "Refused"), pre(rec) label(q50_label)
	
recode q51 ///
	(1001 = 1001 "EC: Less than USD 90") (1002 = 1002 "EC: USD 91 - USD 430") ///
	(1003 = 1003 "EC: USD 431 - USD 800") (1004 = 1004 "EC: USD 801 - USD 1300") ///
	(.r = .r "Refused"), pre(rec) label(q51_label)
	
recode cell1 (0 = 0 "No, no other numbers") (1 = 1 "Yes") (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(cell1_label)

recode cell2 (.r = .r "Refused") (.a = .a "NA"), pre(rec) label(cell2_label)

* Recoding all yes/no qs together
recode q11 q13 q20 q26 q29 q31a q31b q31c_ec (0 = 0 "No") (1 = 1 "Yes") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
pre(rec) label(yesno)

* Recoding all poor-excellent rating qs together
recode q17 q25 q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q40_a q40_b q40_c q40_d q42 q43 q44_ec q47 q48 q49 ///
(0 = 0 "Poor") (1 = 1 "Fair") (2 = 2 "Good") (3 = 3 "Very good") (4 = 4 "Excellent") ///
(.d = .d "Don't know") (.a = .a "NA") (.r = .r "Refused"), pre(rec) label(rating)
	
drop q2 q3 q3a_co_pe_uy_ar q5 q8 q9 q10 q12_a q12_b q13a_ec q14_ec q16 q19 q24 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h ///
q28_a q28_b q30 q32_ec q34 q35 q36 q37 q41_a q41_b q41_c q45 q46 q50 q51 cell1 cell2 q11 q13 q20 q26 q29 q31a q31b q31c_ec q17 q25 ///
q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q40_a q40_b q40_c q40_d q42 q43 q44_ec q47 q48 q49

label define gender .a "NA" .d "Don't know" .r "Refused",add
label define gender2 .a "NA" .d "Don't know" .r "Refused",add	
label define q4_label .a "NA" .d "Don't know" .r "Refused",add	
label define q6_label .a "NA" .d "Don't know" .r "Refused",add	
label define q7_label .a "NA" .d "Don't know" .r "Refused",add	
label define q8_label .a "NA" .d "Don't know" .r "Refused",add	
label define q9q10_label  .a "NA" .d "Don't know" .r "Refused",add	
label define q12_label .a "NA" .d "Don't know" .r "Refused",add
label define q13a_ec_label .a "NA" .d "Don't know" .r "Refused",add
label define q15_label .a "NA" .d "Don't know" .r "Refused",add
label define q33_label .a "NA" .d "Don't know" .r "Refused",add


*------------------------------------------------------------------------------*
* Renaming variables 
* Rename variables to match question numbers in current survey

ren rec* *

*Reorder variables
order q*, sequential
order respondent_serial country wave

*------------------------------------------------------------------------------*

/* Other specify recode 
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

*------------------------------------------------------------------------------*/

*------------------------------------------------------------------------------*
* Label variables - double check matches the instrument					
lab var country "Country"
lab var respondent_serial "Respondent Serial #"
lab var wave "Wave"
*lab var language "Language" - SI: missing from dataset
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab var q3a_co_pe_uy_ar "Q3A. CO/PE/UY/AR/EC only: Are you a man or a woman? (respondent gender)"
lab var q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you most frequently use?"
lab var q7_other "Q7. Other"
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?" 
lab var q13a_ec "Q13a. EC only: Are there any other places, such as pharmacies, traditional healers, or alternative medicine, that you go to most frequently for care?"
lab var q13a_ec_other "Q13a. EC only: Other"
lab var q14_ec "Q14. EC only: Is this facility...?"
lab var q14_ec_other "Q14. EC only: Other"
lab var q15 "Q15. What type of healthcare facility is this?"
lab var q15_other "Q15. Other"
label var q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
lab var q16_other "Q16. Other"
label var q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label var q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label var q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label var q20 "Q20. Were all of the visits you made to the same healthcare facility?"
label var q21 "Q21. How many different healthcare facilities did you go to in total?"
label var q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label var q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label var q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
label var q24_other "Q24. Other"
label var q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label var q26 "Q26. Stayed overnight at a facility in past 12 months (inpatient care)"
label var q27_a "Q27a. Blood pressure tested in the past 12 months"
label var q27_b "Q27b. Breast examination"
label var q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label var q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label var q27_e "Q27e. Had your teeth checked in the past 12 months"
label var q27_f "Q27f. Had a blood sugar test in the past 12 months"
label var q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label var q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label var q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label var q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label var q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label var q30 "Q30. The last time this happened, what was the main reason you did not receive healthcare?"
label var q30_other "Q30. Other"
label var q31a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label var q31b "Q31b. Sell items to pay for healthcare"
label var q31c_ec "Q31c. EC only: Stopped paying any utilities (cable, electricity, water, etc.) to pay for healthcare"
label var q32_ec "Q32. EC only: The facility of your last face-to-face visit is ... ?"
label var q32_ec_other "Q32. EC only: Other"
label var q33 "Q33. What type of healthcare facility is this?"
label var q33_other "Q33. Other"
label var q34 "Q34. What was the main reason you went?"
label var q34_other "Q34. Other"
label var q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label var q36 "Q36. How long did you wait between making the appointment and seeing the health care provider?"
label var q37 "Q37. Approximately how long did you wait before seeing the provider?"
label var q37_other "Q37. Specify"
label var q38_a "Q38a. How would you rate the overall quality of care you received?"
label var q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
label var q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
label var q38_d "Q38d. How would you rate the level of respect your provider showed you?"
label var q38_e "Q38e. How would you rate your provider knowledge about your prior visits and test results?"
label var q38_f "Q38f. How would you rate whether your provider explained things clearly?"
label var q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
label var q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
label var q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
label var q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
label var q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
label var q39 "Q39. How likely would recommend this facility to a friend or family member?"
label var q40_a "Q40a. How would you rate the quality of care during pregnancy and childbirth like antenatal care, postnatal care"
label var q40_b "Q40b. How would you rate the quality of childcare such as care of healthy children and treatment of sick children"
label var q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label var q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label var q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label var q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label var q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label var q42 "Q42. How would you rate the quality of government or public healthcare system in your country?"
label var q43 "Q43. How would you rate the quality of the private for-profit healthcare system in your country?"
label var q44_ec "Q44. EC only: How would you rate quality of the social security health system (IESS)?"
label var q45 "Q45. Is your country's health system is getting better, staying the same or getting worse?"
label var q46 "Q46. Which of these statements do you agree with the most?"
label var q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label var q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label var q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label var q50 "Q50. What is your native language or mother tongue?"
label var q51 "Q51. Total monthly household income"
label var cell1 "CELL 1: Do you have another mobile phone number besides the one I am calling you on?"
label var cell2 "CELL2. How many other mobile phone numbers do you have?"

*------------------------------------------------------------------------------*
* Save data

save "$data_mc/02 recoded data/input data files/pvs_ec", replace

*------------------------------------------------------------------------------*

