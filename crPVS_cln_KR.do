* People's Voice Survey data cleaning for South Korea
* Last updated: March 2023
* Neena Kapoor, Hwa-Young Lee

************************************* South Korea ************************************

* Import data 
use "$data/South Korea/raw data/PVS_SK_raw.dta", clear


* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped*

* NOTE: q4 and q5 are switched
ren Q4 q5
ren Q5 q4

rename *, lower 
ren idx respondent_serial
ren time_diff time
* Note: need to fix this time var. Is it interview length? 
* Is there no date var? 

* Note: no interview_id because all online

* CAWI (web interface) is 3 in mode
ren q6 q6_kr 
ren q7 q7_kr
ren q19 q19_kr
* maybe combine with PE/CO? 
ren tq21_8 q21_other 
ren tq19_4 q19_other
ren q25a q25_a
ren q25b q25_b
ren q28a q28_a
ren q28b q28_b
ren q28c q28_c
ren tq42_10 q42_other
ren q43 q43_kr
ren tq43_4 q43_other
ren tq45_4 q45_other 
ren q46a q46a // check this - remove underscore or keep? 
* combine all q46b like in US/IT/MX, check this 
recode q46b_1 q46b_2 q46b_3 (. = 0) if q46b_1 < . | q46b_2 < . |q46b_3< .
gen q46b = (q46b_1/24) + q46b_2 + (q46b_3*7)								
recode q47_1 q47_2 (. = 0) if q47_1 < . | q47_2 < . 
gen q47 = q47_1*60 + q47_2
recode q46c_1 q46c_2 (. = 0) if q46c_1 < . | q46c_2 < . 
gen q46 = q46c_1*60 + q46c_2
* no q46/q47 refused 
ren q48_1 q48_a
ren q48_2 q48_b
ren q48_3 q48_c
ren q48_4 q48_d
ren q48_5 q48_e
ren q48_6 q48_f
ren q48_7 q48_g
ren q48_8 q48_h
ren q48_9 q48_i
ren q48_10 q48_j
ren q48_11 q48_k
ren q50_1 q50_a
ren q50_2 q50_b
ren q50_3 q50_c
ren q50_4 q50_d
* change q56 in other data 

*------------------------------------------------------------------------------*

* Drop unused or other variables 
drop agree q0 q6a qa qa_5 qb qc qd qe qf p0 q46b_1 q46b_2 q46b_3 q47_1 q47_2 ///
     q46c_1 q46c_2
	 
	 
*------------------------------------------------------------------------------*

* Recode refused and don't know values 
* In raw data, 995 = "don't know" 
recode q23 q25_a q25_b q27 q28_a q28_b q30 q31 q32 q33 q34 q35 q36 q38 q62 q63 ///
	   (995 = .d)

* In raw data, 996 = "refused" 	  
recode q1 q2 q3 q4 q5 q6_kr q7_kr q8 q9 q10 q11 q12 ///
	   q13 q14 q15 q16 q17 q18 q19_kr q20 q21 q22 ///
	   q23 q24 q25_a q25_b q26 q27 q28_a q28_b q28_c q29 q30 q31 q32 q33 ///
	   q34 q35 q36 q38 q39 q40 q41 q42 q43_kr q44 ///
	   q45 q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
	   q56 q57 q58 q59 q60 q61 q62 q63 q66 (996 = .r)	
* add back q23_q24
* what about q46* q47* ?

*------------------------------------------------------------------------------*

* Generate variables
gen respondent_id = "KR" + string(respondent_serial)
gen country=15
lab def country 15 "Republic of Korea" 
lab val country country
gen mode=3
gen language=1501
lab define lang 1501 "Korean" 
lab val language lang

* Country-specific values 
gen recq4 = country*1000 + q4
gen recq5 = country*1000 + q5 
gen recq8 = country*1000 + q8 
gen recq20 = country*1000 + q20 
gen recq44 = country*1000 + q44 
gen recq62 = country*1000 + q62 
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== .r
gen recq66 = country*1000 + q66
replace recq66 = .r if q66== .r
 

* Value labels for these 
* Q23/Q24 midpoint values

*------------------------------------------------------------------------------*
