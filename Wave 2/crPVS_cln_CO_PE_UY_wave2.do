* People's Voice Survey data cleaning for Colombia, Peru, Uruguay  
* Date of last update: April 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Colombia, Uruguay, Peru. 

Cleaning includes:
	- Recoding implausible values 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

*************************** Colombia, Peru, Uruguay ****************************

clear all

* Import raw data 

import spss using "$data/LAC wave2/01 raw data/PVS_LATAM_wave2_weighted.sav", case(lower)


*Label as wave 2 data:
gen wave = 2

*dropping interviewer vars:
drop respondent_serial_sourcefile intro intro_repregunta pa pa_repregunta red_quest control_calidad ///	
	 p1_codes 

*dropping country specific vars:
drop p4_col p4_per p4_uru p5_col p5_per p5_uru p6_latam_col1 p6_latam_col2 p6_latam_col3 p6_latam_col4 p6_latam_col5 p6_latam_col6 p6_latam_col7 p6_latam_col8 p6_latam_col9 p6_latam_col_9 p6_latam_per1 p6_latam_per2 p6_latam_per3 p6_latam_per4 p6_latam_per5 p6_latam_per6 p6_latam_per_6 p6_latam_uru1 p6_latam_uru2 p6_latam_uru3 p6_latam_uru4 p6_latam_uru5 p6_latam_uru6 p6_latam_uru_6 p7_latam_col p7_latam_col_9 p7_latam_per p7_latam_per_6 respondio_p6col todas_na_p6col p6_col_all respondio_p6per todas_na_p6per p6_per_all respondio_p6uru todas_na_p6uru p6_uru_all p7_latam_uru p8_col p8_per p8_uru p13_a_col p13_a_col_4 p13_a_per p13_a_per_4 p13_a_uru_4 p13_a_uru p14_col p14_col_3 p14_per p14_per_5 p14_uru p14_uru_4 p15a_col p15a_col_3 p15a_col_4 p15a_per p15a_per_4 p15a_per_5 p15a_uru p15a_uru_3 p15a_uru_4 p15b_col p15b_col_3 p15b_col_4 p15b_per p15b_per_5 p15b_per_6 p15b_uru p15b_uru_3 p15b_uru_4 p15b_uru_5 p15c_col p15c_col_1 p15c_col_2 p15c_per p15c_per_4 p15c_per_5 p15c_uru p15c_uru_3 p15c_uru_4 p15c_uru_5 p15d_per p15d_per_3 p15d_per_4 p15d_uru p15d_uru_1 p15d_uru_2 p15e_per p15e_per_1 p15e_per_2 p15_col p15_per p15_uru p16_col p16_col_10 p16_per p16_per_10 p16_uru p16_uru_10 p19 p21_codes p24_col p24_col_4 p24_per p24_per_4 p24_uru p24_uru_4 p27c_col p27c_per p27c_uru p30_col p30_col_10 p30_per p30_per_10 p30_p0 p30_uru p30_uru_10 p31_c p32_col p32_col_3 p32_per p32_per_5 p32_uru p32_uru_4  p33_col p33_per p33_uru p33a_col p33a_col_4 p33a_col_5 p33a_per p33a_per_4 p33a_per_5 p33a_uru p33a_uru_4 p33a_uru_5 p33b_col p33b_col_4 p33b_col_5 p33b_per p33b_per_5 p33b_per_6 p33b_uru p33b_uru_4 p33b_uru_5 p33c_col p33c_col_1 p33c_col_2 p33c_per p33c_per_4 p33c_per_5 p33c_uru p33c_uru_4 p33c_uru_5 p33d_per p33d_per_3 p33d_per_4 p33d_uru p33d_uru_1 p33d_uru_2 p33e_per p33e_per_1 p33e_per_2 p34_col p34_col_4 p34_per p34_per_4 p34_uru p34_uru_4 p35_col p35_per p35_uru p36_col p36_uru p36_per p37_7 p38_k_col p38_k_per p38_k_uru p40a_col p40a_per p40a_uru p40b_col p40b_per p40b_uru p40c_col p40c_per p40c_uru p40d_col p40d_per p40d_uru p42_col p42_per p42_uru p43_col p43_per p43_uru p44_col p44_per p44_uru p50_col p50_per p51_col p51_per p51_uru cell2_codes

drop p2_2 p2_3 p4_col_2 p4_per_2 p4_uru_2 p4_2 p5_2 p7_total p7_total2 p8_2 p9_2 p10_2 _v1 _v2 p13_g p13_g2 p13_2 p15_2 p22_2 p23_2 p27a_2 p27a_3 p27b_2 p27c_2 p27d_2 p27f_2 p27g_2 p27h_2 p27h_3 p31_2 p31_3 _v3 p33_2 p36_2 p37_2 p38a_2 p38b_2 p38c_2 p38d_2 p38e_2 p38f_2 p38g_2 p38h_2 p38i_2 p38j_2 p38k_2 p39_2 p41_2 p_user p_consult_all p_expect p51_2 p2_pesos p4_col_pesos p4_per_pesos p4_uru_pesos p4_pesos p8_pesos categorias_pesos newpeso

*confirm dropping these:
drop p12_all p19_all2 dia1 mes1 anio1 fecha1 tipo_base nombre_encuestador enc total wtvar hhini hhfin p1n p18n p21n p22n p23n cell2n zona region_per pond_edad originalrespondentserial originalfile region_col region_uru minutos segundos duracion_humana peso p50_2 p50_3 p6_1
 
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

recode pais (1 = 2 "CO") (2 = 7 "Peru") (3 = 10 "Uruguay"), gen(country) 


rename (p1 p2) (q1 q2)

rename p3_a q3 // double check which q3 var is sex vs gender
rename p3 q3a_co_pe_uy_ar // similar to how we coded q3 for wave 1 because of the gender and mammogram derived vars

rename p4_all q4
rename p5_all q5

rename p7_all q7
rename p8_all q8
rename p9 q9
rename p10 q10
rename p11 q11
rename p12a q12_a
rename p12b q12_b
rename p13 q13
rename p13a_all q13a_co_pe_uy
rename p14_all q14
rename p15_all q15
rename p16_all q16
rename p17 q17

rename p18 q18
replace q18 = .d if p18_codes =="998. (NO LEER) No sabe"
replace q18 = .r if p18_codes == "999. (NO LEER)No responde"
drop p18_codes

recode p19_all (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"),gen(q19) label(q19_label)

rename p20 q20
rename p21 q21

rename p22 q22
replace q22 = .d if p22_codes == "998. (NO LEER) No sabe"
replace q22 = .r if p22_codes == "999. (NO LEER)No responde"
drop p22_codes

rename p23 q23
replace q23 = .d if p23_codes == "998. (NO LEER) No sabe"
replace q23 = .r if p23_codes == "999. (NO LEER)No responde"
drop p23_codes

rename p24_all q24
rename p25 q25
rename p26 q26
rename p27a q27_a
rename p27b q27_b
rename p27c_all q27_c
rename p27d q27_d
rename p27e q27_e
rename p27f q27_f
rename p27g q27_g
rename p27h q27_h
rename p28a q28_a
rename p28b q28_b
rename p29 q29
rename p30_all q30
rename p31a q31_a
rename p31b q31_b
rename p31c q31_c
rename p32_all q32
rename p33_all q33
rename p34_all q34
rename p35_all q35
rename p36_all q36
rename p37 q37
rename p38a q38_a
rename p38b q38_b
rename p38c q38_c
rename p38d q38_d
rename p38e q38_e
rename p38f q38_f
rename p38g q38_g
rename p38h q38_h
rename p38i q38_i
rename p38j q38_j
rename p38k q38_k
rename p39 q39
rename p40a q40_a
rename p40b q40_b
rename p40c q40_c
rename p40d q40_d
rename p41a q41_a
rename p41b q41_b
rename p41c q41_c
rename p42_all q42
rename p43_all q43
rename p44_all q44
rename p45 q45
rename p46 q46
rename p47 q47
rename p48 q48
rename p49 q49
rename p50_all q50
rename p51_all q51
rename duracion int_length
			  
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

*gen reclanguage = country*1000 + language  
*gen recinterviewer_id = country*1000 + interviewer_id *interviewer_id in a string fmt

gen recq4 = country*1000 + q4
*replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 4

gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 22

gen recq8 = country*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
replace recq15 = .r if q15== 16
*replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
replace recq33 = .r if q33== 16 
*replace recq33 = .d if q33== 998

gen recq50 = country*1000 + q50 
replace recq50 = .r if q50== 15

gen recq51 = country*1000 + q51
replace recq51 = .r if q51== 16
*replace recq51 = .d if q51== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 1 "EC" 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l labels142
local q5l labels143
local q7l labels145
local q8l labels147
local q15l labels153
local q33l labels164
local q50l labels176
local q51l labels177


foreach q in q4 q5 q7 q8 q15 q33 q50 q51{
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

drop q4 q5 q7 q8 q15 q33 q50 q51 
ren rec* *

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

* NA

*------------------------------------------------------------------------------*
* Generate variables 

* q18/q19 mid-point var 

gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* Don't know
recode q27_a q27_b q27_d q27_e q27_f q27_g q27_h q28_a q28_b q29 (4 = .d)

* Refused
recode q9 q10 q25 q38_k (6 = .r)
recode q11 q13 q20 q27_a q27_c q27_d q27_e q27_f q28_a q28_b q29 q35 (3 = .r)
recode q14 q32 q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j (8 = .r)
recode q16 q30 (11 = .r)	  
recode q17 (7 = .r)
recode q24 q34 (5 = .r)
recode q36 (9 = .r)
recode q38_a (7 = .r)
recode q39 (12 = .r)

* NA or The clinic had no other staff
recode  (7 = .a) 
	  
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
* None
*replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q18_q19 q22 q23) 

list visits_total q17 if q17 == 6 & visits_total > 0 & visits_total < . | q17 == 6 & visits_total > 0 & visits_total < .

recode q17 (6 = .r) if visits_total > 0 & visits_total < . 
*N=15 with issues

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions

*q1/q2 - no missing data

* q6 was not asked, all respondents were asked q7
recode q6 (. = .a)

*q14-17
recode q14 q15 q16 q17 (. = .a) if q13 !=1

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

* q32-33
recode q32 q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r

recode q36 q38_k (. = .a) if q35 !=1		

recode cell1 (. = .a) if mode !=1

recode cell2 (. = .a) if cell1 !=1
									 
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

* q2

label define labels1 1 "18 to 29" 2	"30-39" 3 "40-49" 4	"50-59" 5 "60-69" ///
					 6 "70-79" 7 "80 or older" .a "NA" .r "Refused", modify 
					 
* All Yes/No questions
recode q11 q13 /// 
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (.a = .a "NA"), ///
	   pre(rec) label(yes_no)					 

* All Excellent to Poor scales

recode q9 q10  ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") .r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor)
	   
recode q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) ///
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") ///
	   (7 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)	
	   
recode q38_k ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused), pre(rec) label(exc_poor_staff)	
	   
recode q38_b  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	    /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)

recode q40_a ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)	   
	   
* All Very Confident to Not at all Confident scales 
	   
recode q12_a q12_b  ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (5 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)		
		
* Miscellaneous questions with unique answer options
		
* SS: confirm translation of 10	
recode q16 (1 = 1 "Low cost") (2 = 2 "Short distance") (3 = 3 "Short waiting time") ///
			(4 = 4 "Good healthcare provider skills") (5 = 5 "Staff shows respect") ///
			(6 = 6 "Medicines and equipment are available") (7 = 7 "Only facility available") ///
			(8 = 8 "Covered by insurance") (9 = 10 "Short waiting time to get appointments") ///
			(10 = 9 "Other, specify") (.a = .a "NA") (.d = .d "Don't know") (11 = .r "Refused"), ///
			pre(rec) label(q16_label)
		
		
		
recode q49 ///
	(1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") ///
	(7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), pre(rec) label(prom_score)	
	
	
	