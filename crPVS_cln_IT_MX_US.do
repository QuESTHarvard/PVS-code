* PVS cleaning for appending datasets
* February 2023
* File for Italy, Mexico and US
* N. Kapoor, P. Sarma

* Import data 
import spss using "/$data_mc/01 raw data/HSPH Health Systems Survey_Final US Italy Mexico Weighted Data_2.1.23_confidential.sav", clear

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 

ren RESPID respondent_serial
* gen respondent_id var 
ren XCHANNEL mode

ren BIDENT_COUNTRY country
ren Q1_1 q1
ren Q1_2 q2
ren Q1_3US q5_us
ren Q1_3MX q5_mx
ren Q1_3IT q5_it
ren Q1_3_OTHER_997 q5_other
ren Q1_4 q3 
ren Q1_5 q4 

ren Q1_9IT q6_it
ren Q1_9US q6
ren Q1_10US q7
ren Q1_10US_7_OTHER q7_other
ren Q1_10MX q7_mx
ren Q1_10MX_6_OTHER q7_other_mx

ren Q1_11US q8_us
ren Q1_11MX q8_mx
ren Q1_11IT q8_it 

ren Q1_12 q9
ren Q1_13 q10
ren Q1_14 q11
ren Q1_19_A q16
ren Q1_19_B q17
ren Q1_17 q14
ren Q1_18 q15
ren Q1_15 q12
ren Q1_16 q13
ren Q2_1 q18

ren Q2_2MX q19_mx
ren Q2_2MX_7_OTHER q19_other_mx
ren Q2_3MX q20_mx
ren Q2_3MX_21_OTHER q20_other_mx
ren Q2_2IT q19_it
ren Q2_2IT_4_OTHER q19_other_it
ren Q2_3IT q20_it
ren Q2_3IT_5_OTHER q20_other_it
ren Q2_3US q20_us
ren Q2_3US_8_OTHER q20_other_us

ren Q2_4 q21
ren Q2_4_9_OTHER q21_other
ren Q2_5 q22
ren Q2_6_1 q23
ren Q2_7 q24
ren Q2_8A q25_a
ren Q2_8B_1 q25_b
ren Q2_9 q26
ren Q2_10_1 q27
ren Q2_11_1 q28_b // check this - may be mislabeled 
ren Q2_11B q28_c // to be added to data dictionary
ren Q2_12 q29
ren Q2_13_A q30
ren Q2_13_B q31
ren Q2_13_C q32
ren Q2_13_D q33
ren Q2_13_E q34
ren Q2_13_F q35
ren Q2_13_G q36
ren Q2_13_H q38
ren Q2_21_A q39
ren Q2_21_B q40
ren Q2_23 q41
ren Q2_24 q42
ren Q2_24_10_OTHER q42_other

ren Q3_2US q44_us
ren Q3_2US_8_OTHER q44_other_us
ren Q3_1MX q43_mx
ren Q3_1MX_7_OTHER q43_other_mx
ren Q3_2MX q44_mx
ren Q3_2MX_21_OTHER q44_other_mx
ren Q3_1IT q43_it
ren Q3_1IT_4_OTHER q43_it_other
ren Q3_2IT q44_it
ren Q3_2IT_5_OTHER q44_other_it
ren Q3_3 q45
ren Q3_3_4_OTHER q45_other

ren Q3_4A q46_a // add to data dictionary 
ren Q3_4B_1 q46_b_hrs // add to data dictionary
ren Q3_4B_2X q46_b_dys // add to data dictionary
ren Q3_4B_3X q46_b_wks // add to data dictionary
ren Q3_4B_4X q46_b_mth // add to data dictionary

ren Q3_4_1X q46_hrs
ren Q3_4_2X q46_min

ren Q3_5_1X q47_hrs
ren Q3_5_2X q47_min


ren Q3_6_A q48_a
ren Q3_6_B q48_b
ren Q3_6_C q48_c
ren Q3_6_D q48_d
ren Q3_6_E q48_e
ren Q3_6_F q48_f
ren Q3_6_G q48_g
ren Q3_6_H q48_h
ren Q3_6_I q48_i
ren Q3_6_J q48_j
ren Q3_6_K q48_k // add to data dictionary
ren Q3_7 q49
ren Q4_1_A q50_a
ren Q4_1_B q50_b
ren Q4_1_C q50_c
ren Q4_1_D q50_d
ren Q4_2_A q51
ren Q4_2_B q52
ren Q4_2_C q53
ren Q4_5MX_A q56_mx
ren Q4_5MX_B q54_mx_a
ren Q4_5MX_C q54_mx_b

* FLAG check q54 versus q56

ren Q4_5IT q54_it
ren Q4_5US q54_us
ren Q4_6 q55
ren Q4_8 q57
ren Q4_9 q58
ren Q4_10 q59
ren Q4_11 q60
ren Q4_12 q61

ren Q4_13US q66a_us // add to data dictionary
ren PARTYLEAN q66b_us // add to data dictionary

ren Q4_14IT q63_it
ren Q4_14MX q63_mx
ren Q4_14US q63_us

ren Q4_13MX q66_mx // add to data dictionary
ren Q4_13IT q66_it // add to data dictionary

ren WEIGHT weight_educ
ren LANGUAGE language

order q*, sequential
order respondent_serial mode language country weight_educ


*------------------------------------------------------------------------------*

* Time variables - others to add? 

recode q46_min q46_hrs q47_min q47_hrs (. = 0)
gen q46 = q46_hrs*60 + q46_min
gen q47 = q47_hrs*60 + q47_min


*------------------------------------------------------------------------------*

* Drop unused variables 

drop STATUS STATU2 INTERVIEW_START INTERVIEW_END LAST_TOUCHED LASTCOMPLETE ///
	 XSUSPEND QS LLINTRO LLINTRO2 CELLINTRO Q1_1_1_OTHER Q1_6A Q1_6B_1 Q1_6B_2 ///
	 Q1_6B_3 Q1_6B_4 Q1_6B_5 Q1_6B_6 Q1_6B_999 Q1_6B_6_OTHER Q1_6MX NUMOFCHILDREN ///
	 CHILD1AGE CHILD2AGE CHILD3AGE CHILD4AGE CHILD5AGE CHILD6AGE CHILD7AGE CHILD8AGE ///
	 CHILD9AGE CHILD10AGE Q1_8_1 Q1_8_2 Q1_8_3 Q1_8_4 Q1_8_5 Q1_8_6 Q1_8_7 Q1_8_8 Q1_8_9 ///
	 Q1_8_10 ATLEASTONEGENDERFOUNDFORAGES13T AGEOFYOUNGESTFEMALE Q1_21_A Q1_21_B Q1_21_C ///
	 Q2_25 Q2_28 Q2_27 Q2_26 Q2_26MX CHILD2_27 Q2_29 Q2_30_A Q2_30_B Q2_31 Q3_4B_2 Q3_4B_3 ///
	 Q2_8B Q2_8B_1_OTHER Q3_4B_4 Q3_4B_999 CELL HHCELL LANDLINE IGENDER Q3_4B_1X Q3_4_1 ///
	 Q3_4_2 Q3_4_999 Q3_5_1 Q3_5_1 Q3_5_2 Q3_5_999 Q3_7WB ILANGUAGE_1 ILANGUAGE_2 ///
	 ILANGUAGE_3 ILANGUAGE_4 ILANGUAGE_4_OTHER HRANDOM_Q1_21LOOPCHAR HRANDOM_Q3_6LOOPCHAR ///
	 XCURRENTSECTION HID_SECTIONTIME_SB HID_SECTIONTIME_SC HID_SECTIONTIME_DE ///
	 HID_SECTIONTIME_1 HID_SECTIONTIME_2 HID_SECTIONTIME_3 HID_SECTIONTIME_4 ///
	 HID_LOI BLANDCELL BSSRS_MATCH_CODE CATICALLTIME DIALTYPE DTYPE EMAIL ///
	 RECORDTYPE BIDENT2 BSTRATA BREGION1 BREGION2 BREGION3 BREGION4 BLOCALITY ///
	 BSTATE BITALY_REGIONS BMEXICO_STATES SAMPSOURCE q46_min q46_hrs q47_min q47_hrs
	 
* Add back these variables later

drop q28_c q46_a q46_b_dys q46_b_hrs q46_b_mth q46_b_wks q66_it q66_mx q66a_us q66b_us

*------------------------------------------------------------------------------*

* Generate variables 

gen respondent_id = "US" + string(respondent_serial) if country == 1
replace respondent_id = "MX" + string(respondent_serial) if country == 2
replace respondent_id = "IT" + string(respondent_serial) if country == 3

gen q28_a = .a // any others not asked? 
gen q62 = .a 


* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (999 = 0) (998 = 0) if q24 == 1
recode q23_q24 (999 = 2.5) (998 = 2.5) if q24 == 2
recode q23_q24 (999 = 7) (998 = 7) if q24 == 3
recode q23_q24 (999 = 10) (998 = 10) if q24 == 4
recode q23_q24 (998 = 999) if q24 == 999


*------------------------------------------------------------------------------*

* Refused values / Don't know values

* In raw data, 998 = "don't know" 
recode q23 q25_a q25_b q27 q28_b q30 q31 q32 q33 q34 q35 q36 q38 q63* ///
	   (998 = .d)

* Potentially no don't know in q25_a, q27, q63*

* In raw data, 999 = "refused" 	   
recode q1 q2 q3 q4 q5_it q5_mx q5_us q6 q6_it q7 q7_mx q8* q9 q10 q11 q12 q13 q14 q15 q16 q17 /// 
	   q18 q19_it q19_mx q20_it q20_mx q20_us q21 q22 q23 q24 q23_q24 q25_a q25_b q26 q27 q28_b q29 q30 /// 
	   q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q43_it q43_mx q44_it q44_mx q44_us ///
	   q45 q46* q47* q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54* q55 /// 
	    q57 q58 q59 q60 q61 q63* (999 = .r)	
	  

*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*q1/q2 
recode q2 (. = .a) if q1 != .r 

* q6/q7 - CHECK THIS
recode q7 (. = .a) if q6 == 2 | q6 == .r 

* Note - add country specific skip pattern later (q6, q8)

* q13 
recode q13 (. = .a) if q12 == 2  | q12==.r

* q15
* recode q15 (. = .a) if q14 == 3 | q14 == 4 | q14 == 5 | q14 == .r 
* FLAG: was Q15 asked to eveyone? 
* 		Should I make it a new var? Or recode those who said 0, 1, 2 doess
*		(This skip pattern was also different in Laos )


*q19-22
recode q19_it q19_mx q20_it q20_mx q20_us q21 q22 (. = .a) if q18 == 2 | q18 == .r 
* Note: In Italy, SSRS asked q20 even if q19 was other or refused, but not the case in Mexico 
recode q20_mx (. = .a) if q19_mx == 7 


* NA's for q24-27 
recode q24 (. = .a) if q23 != .d | q23 != .r
recode q25_a (. = .a) if q23 != 1
recode q25_b q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .r | q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 

* FLAG - some missing in q27 - maybe refusal? or skip pattern I missed?
* br q23 q24 q23_q24 q26 q27 if q27 == .

* q31 & q32
recode q31 (. = .a) if q3 == 1 | q1 < 50 | q2 == 1 | q2 == 2 | q2 == 3 | q2 == 4 | q1 == .r | q2 == .r 
recode q32 (. = .a) if q3 == 1 | q1 == .r | q2 == .r
* FLAG - was the skip pattern for Q32 different? some missing 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43_it q43_mx q44_it q44_mx q44_us q45 q46 q47 q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r 
recode q44_it (. = .a) if q43_it == 4 // different from above 
recode q44_mx (. = .a) if q43_mx == 7 

* FLAG add skip pattern for appointment once add back variables 

*q64/q65 - are there vars on number of phone numbers? 

* Country-specific skip pattern - may change 
recode q5_it q6_it q8_it q19_it q20_it q43_it q44_it q54_it q63_it (. = .a) if country != 3
recode q5_mx q7_mx q8_mx q19_mx q20_mx q43_mx q44_mx q54_mx_a q54_mx_b q56_mx q63_mx (. = .a) if country != 2
recode q5_us q6 q7 q8_us q20_us q44_us q54_us q63_us (. = .a) if country != 1

*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q6 q11 q12 q13 q18 q25_a q26 q29 q41 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)
	   

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (3 .d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)

* All Excellent to Poor scales

recode q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54_it ///
	   q54_mx_a q54_mx_b q54_us q55 q56 q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
* NOTE: "I had no prior tests or visits" was not an option - was the skip pattern fixed? 
* 		Can move this above if so
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)	   
	   
	   
* Country-specific 
* Mode 
recode mode (2 = 1) (1 = 4)
lab def mode 1 "CATI" 4 "CAWI"
lab val mode mode

* Country
gen reccountry = country + 11
lab def country 12 "US" 13 "Mexico" 14 "Italy"
lab val reccountry country

* Q4: Values above 20 available 
gen recq4 = q4 + 30
lab def q4 31 "City" 32 "Suburb of city" 33 "Small town" 34 "Rural area" .r "Refused"
lab val recq4 q4 country

* Q8: Values above 50 available 
recode q8_it (1 = 51 "Mai frequentato la scuola o solo Nido e Scuola dell'infanzia") ///
		(2 = 52 "Scuola primaria") ///
		(3 = 53 "Scuola secondaria di primo grado") ///
		(4 = 54 "Scuola secondaria di secondo grado") ///
		(5 = 55 "Liceo, Instituto tecnico o Instituto professionale") ///
		(6 = 56 "Universita Laurea triennale (compreso alta formazione artistica)") ///
		(7 = 57 "Universita Laurea Magistrale o ciclo unico o Dottorato") ///
		(.r = .r "Refused"), pre(rec) label(q8)

recode q8_mx (1 = 58 "Ninguno") (2 = 59 "Primaria") ///
		  (3 = 60 "Secundaria") ///
		  (4 = 61 "Preparatoria o Bachillerato") ///
		  (5 = 62 "Carrera técnica") ///
		  (6 = 63 "Licenciatura") ///
		  (7 = 64 "Postgrado"), pre(rec) label(q8)

recode q8_us (1 = 65 "Never attended school or only kindergarten") ///
		  (2 = 66 "Grades 1 through 8 (elementary)") ///
		  (3 = 67 "Grades 9 through 11 (some high school)") ///
		  (4 = 68 "Grade 12 or GED (high school graduate)") ///
		  (5 = 69 "College 1 year to 3 years (some college or technical school)") ///
		  (6 = 70 "College 4 years or more (college graduate)") ///
		  , pre(rec) label(q8)

gen q8 = max(recq8_it, recq8_mx, recq8_us)
lab val q8 q8

* Q63: Values above 107 available

recode q63_it (1 = 151 "Less than 10,000 euros") (2 = 152 "10,000-15,000 euros") ///
		  (3 = 153 "15,000-26,000 euros") ///
		  (4 = 154 "26,000-55,000 euros") ///
		  (5 = 155 "55,000-75,000 euros") ///
		  (6 = 156 "75,000-120,000 euros") ///
		  (7 = 157 "More than 120,000 euros"), pre(rec) label(q63)

recode q63_mx (1 = 158 "Less than 6,500 pesos") (2 = 159 "6,500-10,000 pesos") ///
		  (3 = 160 "10,000-15,000 pesos") ///
		  (4 = 161 "15,000-25,000 pesos") ///
		  (5 = 162 "More than 25,000 pesos") ///
		  , pre(rec) label(q63)

recode q63_us (1 = 163 "Less than $26,000") (2 = 164 "$26,000 to less than $36,000") ///
		  (3 = 165 "$36,000 to less than $65,000") ///
		  (4 = 166 "$65,000 to less than $100,000") ///
		  (5 = 167 "$100,000 or more") ///
		  , pre(rec) label(q63)		  

gen q63 = max(recq63_it, recq63_mx, recq63_us)
lab val q63 q63		  
		  
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop q4 recq8_it recq8_mx recq8_us recq63_it recq63_mx recq63_us country

ren rec* *

*------------------------------------------------------------------------------*

* Check for implausible values
* q23 q25_b q27 q28_a q28_b q46 q47
 
*------------------------------------------------------------------------------*

* Label variables 

*------------------------------------------------------------------------------*
 
* Save data

save "$data_mc/02 recoded data/pvs_it_mx_us.dta", replace
 