* PVS cleaning for appending datasets
* February 2023
* File for Italy, Mexico and US
* N. Kapoor, T. Lewis

/*
This file cleans SSRS data (US, Italy Mexico). 
Cleaning includes:
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	- Recoding outliers to missing 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 
*/

* Import data 
import spss using "/$data_mc/01 raw data/HSPH Health Systems Survey_Final US Italy Mexico Weighted Data_2.1.23_confidential.sav", clear

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 
ren RESPID respondent_serial
ren XCHANNEL mode
ren BIDENT_COUNTRY country
ren Q1_1 q1
ren Q1_2 q2
ren Q1_3US q5_us
ren Q1_3MX q5_mx
ren Q1_3IT q5_it
ren Q1_3_OTHER_997 q5_other // this is just for Italy
ren Q1_4 q3 
ren Q1_5 q4 
ren Q1_9IT q6_it
ren Q1_9US q6
ren Q1_10US q7_us
ren Q1_10US_7_OTHER q7_other_us
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
lab var q28_b "q2_11 How many virtual or telemedicine visits did you have in the past 12 months?"
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
ren Q3_1IT_4_OTHER q43_other_it
ren Q3_2IT q44_it
ren Q3_2IT_5_OTHER q44_other_it
ren Q3_3 q45
ren Q3_3_4_OTHER q45_other
ren Q3_4A q46a_it_mx_us // add to data dictionary 
ren Q3_4B_1X q46b_hrs // add to data dictionary
ren Q3_4B_2X q46b_dys // add to data dictionary
ren Q3_4B_3X q46b_wks // add to data dictionary
ren Q3_4B_4X q46b_mth // add to data dictionary
ren Q3_4_1X q46_hrs
ren Q3_4_2X q46_min
ren Q3_5_1X q47_hrs
ren Q3_5_2X q47_min
ren Q3_4B_999 q46b_refused
ren Q3_4_999 q46_refused 
ren Q3_5_999 q47_refused 
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
ren Q4_5MX_B q54_mx // secretaria de salud (public)
ren Q4_5MX_A q56a_mx //IMSS (third system)
ren Q4_5MX_C q56b_mx //IMSS bienestar (check)

* NOTE: discussed q54 vs q56 with MEK and CA 

ren Q4_5IT q54_it
ren Q4_5US q54_us
ren Q4_6 q55
ren Q4_8 q57
ren Q4_9 q58
ren Q4_10 q59
ren Q4_11 q60
ren Q4_12 q61
ren Q1_6MX q62_mx // add to data dictionary 
ren Q4_13US q66a_us // add to data dictionary
ren PARTYLEAN q66b_us // add to data dictionary
ren Q4_14IT q63_it
ren Q4_14MX q63_mx
ren Q4_14US q63_us
ren Q4_13MX q66_mx // add to data dictionary
ren Q4_13IT q66_it // add to data dictionary

ren WEIGHT weight_educ
ren LANGUAGE lang
order q*, sequential
order respondent_serial mode lang country weight_educ

**** Combining/recoding some variables ****

* Q46, Q47 
recode q46_min q46_hrs (. = 0) if q46_min < . | ///
								  q46_hrs < . 
recode q47_min q47_hrs (. = 0) if q47_min < . | ///
								  q47_hrs < . 
gen q46 = q46_hrs*60 + q46_min
recode q46 (. = .r) if q46_refused == 1
gen q47 = q47_hrs*60 + q47_min
recode q47 (. = .r) if q47_refused == 1

* Q46a, Q46b 
recode q46b_dys q46b_hrs q46b_mth q46b_wks (. = 0) if q46b_dys < . | ///
														  q46b_hrs < . | ///
														  q46b_mth < . | ///
														  q46b_wks < . 
gen q46b_it_mx_us = (q46b_hrs/24) + q46b_dys + (q46b_wks*7) + (q46b_mth*30)
recode q46b_it_mx_us (. = .r) if q46b_refused == 1 

* Note: There are 9 values missing, after the skip pattern recoding. 
* 		Is this a recoding error or just missing data?

* Q54 (selected Secretaria de Salud in Mexico)
egen q54 = rowmax(q54_mx q54_it q54_us)
lab val q54 labels69

* Q62a, Q62b 
ren Q1_6A q62a_us
gen q62b_us = .
recode q62b_us (. = 1) if Q1_6B_1 == 1 & Q1_6B_2 == 0 & Q1_6B_3 == 0 & Q1_6B_4 == 0 ///
					 & Q1_6B_5 == 0 & Q1_6B_6 == 0
recode q62b_us (. = 2) if Q1_6B_2 == 1 & Q1_6B_1 == 0 & Q1_6B_3 == 0 & Q1_6B_4 == 0 ///
					 & Q1_6B_5 == 0 & Q1_6B_6 == 0
recode q62b_us (. = 3) if Q1_6B_3 == 1 & Q1_6B_1 == 0 & Q1_6B_2 == 0 & Q1_6B_4 == 0 ///
					 & Q1_6B_5 == 0 & Q1_6B_6 == 0	
recode q62b_us (. = 4) if Q1_6B_4 == 1 & Q1_6B_1 == 0 & Q1_6B_2 == 0 & Q1_6B_3 == 0 ///
					 & Q1_6B_5 == 0 & Q1_6B_6 == 0	
recode q62b_us (. = 5) if Q1_6B_5 == 1 & Q1_6B_1 == 0 & Q1_6B_2 == 0 & Q1_6B_3 == 0 ///
					 & Q1_6B_4 == 0 & Q1_6B_6 == 0
recode q62b_us (. = 995) if Q1_6B_6 == 1 & Q1_6B_1 == 0 & Q1_6B_2 == 0 & Q1_6B_3 == 0 ///
					 & Q1_6B_4 == 0 & Q1_6B_5 == 0	
recode q62b_us (. = 6) if Q1_6B_1 > 0 & Q1_6B_1 < . | Q1_6B_2 != 0 & Q1_6B_2 < . ///
						| Q1_6B_3 > 0 & Q1_6B_3 < . | Q1_6B_4 != 0 & Q1_6B_4 < . ///
					 	| Q1_6B_5 > 0 & Q1_6B_5 < . 
recode q62b_us (. = .r) if Q1_6B_999 == 1
lab def race 1 "Black or African American" 2 "Asian" 3 "Native Hawaiian or Other Pacific Islander" ///
			 4 "American Indian or Alaska Native" 5 "White" 6 "Mixed race" ///
			 995 "Other" .r "Refused" .a "NA"
lab val q62b_us race
ren Q1_6B_6_OTHER q62_other 
* Note - is there a better way to do this? 

* Note: other country-specific variables combined below 

*------------------------------------------------------------------------------*

* Drop unused variables 

drop STATUS STATU2 INTERVIEW_START INTERVIEW_END LAST_TOUCHED LASTCOMPLETE ///
	 XSUSPEND QS LLINTRO LLINTRO2 CELLINTRO Q1_1_1_OTHER Q1_6B_1 Q1_6B_2 ///
	 Q1_6B_3 Q1_6B_4 Q1_6B_5 Q1_6B_6 Q1_6B_999 NUMOFCHILDREN CHILD1AGE ///
	 CHILD2AGE CHILD3AGE CHILD4AGE CHILD5AGE CHILD6AGE CHILD7AGE CHILD8AGE ///
	 CHILD9AGE CHILD10AGE Q1_8_1 Q1_8_2 Q1_8_3 Q1_8_4 Q1_8_5 Q1_8_6 Q1_8_7 Q1_8_8 Q1_8_9 ///
	 Q1_8_10 ATLEASTONEGENDERFOUNDFORAGES13T AGEOFYOUNGESTFEMALE Q1_21_A Q1_21_B Q1_21_C ///
	 Q2_25 Q2_28 Q2_27 Q2_26 Q2_26MX CHILD2_27 Q2_29 Q2_30_A Q2_30_B Q2_31 Q3_4B_2 Q3_4B_3 ///
	 Q2_8B Q2_8B_1_OTHER Q3_4B_4 CELL HHCELL LANDLINE IGENDER Q3_4B_1 Q3_4_1 ///
	 Q3_4_2 Q3_5_1 Q3_5_1 Q3_5_2 Q3_7WB ILANGUAGE_1 ILANGUAGE_2 ///
	 ILANGUAGE_3 ILANGUAGE_4 ILANGUAGE_4_OTHER HRANDOM_Q1_21LOOPCHAR HRANDOM_Q3_6LOOPCHAR ///
	 XCURRENTSECTION HID_SECTIONTIME_SB HID_SECTIONTIME_SC HID_SECTIONTIME_DE ///
	 HID_SECTIONTIME_1 HID_SECTIONTIME_2 HID_SECTIONTIME_3 HID_SECTIONTIME_4 ///
	 HID_LOI BLANDCELL BSSRS_MATCH_CODE CATICALLTIME DIALTYPE DTYPE EMAIL ///
	 RECORDTYPE BIDENT2 BSTRATA BREGION1 BREGION2 BREGION3 BREGION4 BLOCALITY ///
	 BSTATE BITALY_REGIONS BMEXICO_STATES SAMPSOURCE q46_min q46_hrs q47_min q47_hrs ///
	 q54_it q54_us q54_mx q46b_dys q46b_hrs q46b_mth q46b_wks

	 
* FLAG
* Variables in our appended dataset that we need from this data (if avaialble)
* Date variable, interview length variable (in minutes), q64 (do you have more than one phone),
* q64 (if so how many phone numbers)
* And potentially a time of interview variable (currently drop this in appended dataset, but may add back)	 
	 
*------------------------------------------------------------------------------*

* Generate variables 
gen respondent_id = "US" + string(respondent_serial) if country == 1
replace respondent_id = "MX" + string(respondent_serial) if country == 2
replace respondent_id = "IT" + string(respondent_serial) if country == 3

gen q28_a = .a // any others not asked? 
gen q62 = .a // asked differently 
gen q64 = .a 
gen q65 = .a

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

* FLAG - potentially no don't know response option in q25_a, q27, q63*
*		 There were don't know options for these questions in other countries 

* In raw data, 999 = "refused" 	   
recode q1 q2 q3 q4 q5_it q5_mx q5_us q6 q6_it q7_us q7_mx q8* q9 q10 q11 q12 ///
	   q13 q14 q15 q16 q17 q18 q19_it q19_mx q20_it q20_mx q20_us q21 q22 ///
	   q23 q24 q23_q24 q25_a q25_b q26 q27 q28_b q28_c q29 q30 q31 q32 q33 ///
	   q34 q35 q36 q38 q39 q40 q41 q42 q43_it q43_mx q44_it q44_mx q44_us ///
	   q45 q46* q47* q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54* q55 /// 
	   q56* q57 q58 q59 q60 q61 q62_mx q62a_us q63* q66* (999 = .r)	
	  
*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*q1/q2 
recode q2 (. = .a) if q1 != .r 

* q6/q7 
recode q7_us (. = .a) if q6 == 2 | q6 == .r 

* q6_it asked in Italy, q6 not asked in MX 

* q13 
recode q13 (. = .a) if q12 == 2  | q12==.r

* q15
* recode q15 (. = .a) if q14 == 3 | q14 == 4 | q14 == 5 | q14 == .r 

* FLAG: was Q15 asked to eveyone? Skip pattern is different from main PVS data 
* 		Should I make it a new var? Or recode those who said 0, 1, 2 doses
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

*q28_c
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r 

* q31 & q32
recode q31 (. = .a) if q3 == 1 | q1 < 50 | q2 == 1 | q2 == 2 | q2 == 3 | q2 == 4 | q1 == .r | q2 == .r 
recode q32 (. = .a) if q3 == 1 | q1 == .r | q2 == .r
* FLAG - was the skip pattern for Q32 different? some missing 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43_it q43_mx q44_it q44_mx q44_us q45 q46 q46_refused q46a_it_mx_us ///
	   q46b_it_mx_us q46b_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r 
recode q44_it (. = .a) if q43_it == 4 // different from above 
recode q44_mx (. = .a) if q43_mx == 7 
recode q46b_it_mx_us q46b_refused (. = .a) if q46a_it_mx_us == 2


*q64/q65 - are there variarbles on number of phone numbers? 

* q66 for US
recode q66b_us (. = .a) if q66a_us == 1 | q66a_us == 2

* Country-specific skip pattern - may not be needed as some of these are later merged 
recode q5_it q6_it q8_it q19_it q20_it q43_it q44_it q63_it q66_it (. = .a) if country != 3
recode q5_mx q7_mx q8_mx q19_mx q20_mx q43_mx q44_mx q56a_mx q56b_mx q62_mx q63_mx q66_mx (. = .a) if country != 2
recode q5_us q6 q7_us q8_us q20_us q44_us q62b_us q63_us q66a_us q66b_us (. = .a) if country != 1

*------------------------------------------------------------------------------*
* Recode values and value labels:
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
	   
recode q46a_it_mx_us ///
		(1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
		(2 = 0 " No, I did not have an appointment") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_appt)

recode q46b_refused ///
		(1 = 1 "Yes") ///
		(0 = 0 " No") ///
		(.a = .a "NA") ///
		, pre(rec) label(yes_no)		
		
recode q6_it ///
		(1 = 1 "Yes, have private insurance") ///
		(2 = 0 "No, do not have private insurance") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_ins)		
		
* All Excellent to Poor scales

recode q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54 ///
	   q56a_mx q56b_mx q55 q59 q60 q61 ///
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
* NOTE: "I had no prior tests or visits" was not an option - was the skip pattern different? 
* 		Can move q48_e to above recode if so
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)	   
	   
* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options

recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)
	   
recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (3 = .d "Not sure") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

* q49 - no recode needed 
	
recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_c q28_b q46 q46b_it_mx_us q47 na_rf	
	
	
******* Country-specific *******
* Mode 
recode mode (2 = 1) (1 = 4)
lab def mode 1 "CATI" 4 "CAWI"
lab val mode mode

* Country
gen reccountry = country + 11
lab def country 12 "US" 13 "Mexico" 14 "Italy"
lab val reccountry country

* Language
recode lang (9 = 1 "English") (10 2058 = 11 "Spanish") (16 = 18 "Italian"), ///
	   gen(language) label(language)


* Q4: Values above 20 available 
gen recq4 = q4 + 30
lab def q4 31 "City" 32 "Suburb of city" 33 "Small town" 34 "Rural area" .r "Refused"
lab val recq4 q4 
recode recq4 (. = .r) if q4 == .r 

* Q5
recode q5_it (1 = 220 "Sicilia") ///
			 (2 = 221 "Campania") ///
			 (3 = 222 "Molise") ///
			 (4 = 223 "Calabria") ///
			 (5 = 224 "Basilicata") ///
			 (6 = 225 "Puglia") ///
			 (7 = 226 "Sardegna") ///
			 (8 = 227 "Liguria") ///
			 (10 = 229 "Lazio") ///
			 (11 = 230 "Piemonte") ///
			 (12 = 231 "Abruzzo") ///
			 (13 = 232 "Toscana") ///
			 (14 = 233 "Umbria") ///
			 (15 = 234 "Marche") ///
			 (16 = 235 "Friuli-Venezia Giulia") ///
			 (17 = 236 "Provincia Autonoma Trento") ///
			 (18 = 237 "Lombardia") ///
			 (19 = 238 "Emilia-Romagna") ///
			 (20 = 239 "Veneto") ///
			 (21 = 240 "Provincia Autonoma Bolzano/Bozen") ///
			 (997 = 995 "Other"), pre(rec) label(q5)
			 replace recq5_it = 221 if q5_other=="CAMPAGNIA" |	q5_other=="PROVINCA DI SALERNO"
			 replace recq5_it = 223 if q5_other=="CALABRIA" 
			 replace recq5_it = 225 if q5_other=="PULIA" 
			 replace recq5_it = 230 if q5_other=="PIEMONTE"	|	q5_other=="TORINO"	|	q5_other=="piemonte"
			 replace recq5_it = 233 if q5_other=="umbria" 
			 replace recq5_it = 234 if q5_other=="ASCOLIPICENO"
			 replace recq5_it = 237 if q5_other=="lombardia"
			 replace recq5_it = 239 if q5_other=="venzia"
			 
recode q5_mx (1 = 241 "Chiapas") ///
			 (2 = 242 "Guerrero") ///
			 (3 = 243 "Veracruz de Ignacio de la Llave") ///
			 (4 = 244 "Oaxaca") ///
			 (5 = 245 "Tlaxcala") ///
			 (6 = 246 "Puebla") ///
			 (7 = 247 "Hidalgo") ///
			 (8 = 248 "Tabasco") ///
			 (9 = 249 "Morelos") ///
			 (10 = 250 "Zacatecas") ///
			 (11 = 251 "Quintana Roo") ///
			 (12 = 252 "Michoacán de Ocampo") ///
			 (13 = 253 "Yucatán") ///
			 (14 = 254 "Campeche") ///
			 (15 = 255 "San Luis Potosí") ///
			 (16 = 256 "Guanajuato") ///
			 (17 = 257 "México") ///
			 (18 = 258 "Tamaulipas") ///
			 (19 = 259 "Durango") ///
			 (20 = 260 "Nayarit") ///
			 (21 = 261 "Coahuila de Zaragoza") /// 
			 (22 = 262 "Jalisco") ///
			 (23 = 263 "Sinaloa") ///
			 (24 = 264 "Colima") ///
			 (25 = 265 "Aguascalientes") ///
			 (26 = 266 "Chihuahua") ///
			 (27 = 267 "Querétaro") ///
			 (28 = 268 "Sonora") ///
			 (29 = 269 "Baja California Sur") ///
			 (30 = 270 "Ciudad de México") ///
			 (31 = 271 "Baja California") ///
			 (32 = 272 "Nuevo León"), pre(rec) label(q5)

			 			 
recode q5_us (1 = 273 "Alabama") ///
			 (2 = 274 "Alaska") ///
			 (3 = 275 "Arizona") ///
			 (4 = 276 "Arkansas") ///
			 (5 = 277 "California") ///
			 (6 = 278 "Colorado") ///
			 (7 = 279 "Connecticut") ///
			 (8 = 280 "Delaware") ///
			 (9 = 281 "District of Columbia") ///
			 (10 = 282 "Florida") ///
			 (11 = 283 "Georgia") ///
			 (12 = 284 "Hawaii") ///
			 (13 = 285 "Idaho") ///
			 (14 = 286 "Illinois") ///
			 (15 = 287 "Indiana") ///
			 (16 = 288 "Iowa") ///
			 (17 = 289 "Kansas") ///
			 (18 = 290 "Kentucky") ///
			 (19 = 291 "Louisiana") ///
			 (20 = 292 "Maine") ///
			 (21 = 293 "Maryland") /// 
			 (22 = 294 "Massachusetts") ///
			 (23 = 295 "Michigan") ///
			 (24 = 296 "Minnesota") ///
			 (25 = 297 "Mississippi") ///
			 (26 = 298 "Missouri") ///
			 (27 = 299 "Montana") ///
			 (28 = 300 "Nebraska") ///
			 (29 = 301 "Nevada") ///
			 (30 = 302 "New Hampshire") ///
			 (31 = 303 "New Jersey") ///
			 (32 = 304 "New Mexico") ///
			 (33 = 305 "New York") ///
			 (34 = 306 "North Carolina") /// 
			 (35 = 307 "North Dakota") ///
			 (36 = 308 "Ohio") ///
			 (37 = 309 "Oklahoma") ///
			 (38 = 310 "Oregon") ///
			 (39 = 311 "Pennsylvania") ///
			 (40 = 312 "Rhode Island") ///
			 (41 = 313 "South Carolina") ///
			 (42 = 314 "South Dakota") ///
			 (43 = 315 "Tennessee") ///
			 (44 = 316 "Texas") ///
			 (45 = 317 "Utah") ///
			 (46 = 318 "Vermont") ///
			 (47 = 319 "Virginia") ///
			 (48 = 320 "Washington") ///
			 (49 = 321 "West Virginia") ///
			 (50 = 322 "Wisconsin") ///
			 (51 = 323 "Wyoming"), pre(rec) label(q5)

gen q5 = max(recq5_it, recq5_mx, recq5_us)
lab val q5 q5
recode q5 (. = .r) if q5_it == .r | q5_mx == .r | q5_us == .r


* Q6 okay - q6 is US only, q6_it, is Italy specific 
* Q7 - combine q7_us and q7_mx
* create values for Italy		

recode q6_it (1 = 32 "Additional private insurance") ///
			 (2 = 31 "Only public insurance") ///
			 (.a = .a "NA") (.r = .r "Refused"), gen(q7_it) lab(q7)

			 
recode q7_mx (1 = 33 "Seguro Social (IMSS)") ///
		(2 = 34 "ISSSTE/ISSSTE Estatal") ///
		(3 = 35 "IMSS-Bienestar (antes Seguro Popular y INSABI)") ///
		(4 = 36 "PEMEX, Defensa o Marina") ///
		(5 = 37 "Seguro Médico Privado") ///
		(6 = 995 "Other") ///
		(14 = 14 "None") ///
		(.r = .r "Refused"), pre(rec) label(q7)

* Recoding the "other" insurance types in Mexico
recode recq7_mx (995 = 34) if q7_other_mx=="ISSSTESH" // misspelled ISSSTE 
recode recq7_mx (995=35) if q7_other_mx=="CENTR O DE SALUD O HOSPITAL" | /// grouped with MOH services (now covered by IMSS bienestar)
						    q7_other_mx=="CENTRO DE SALUD" | q7_other_mx=="CENTRO SALUD" | ///
							q7_other_mx=="CLINICA" | q7_other_mx=="HOSPITAL" | ///
							q7_other_mx=="HOSPITAL DEL GOBIERNO" | q7_other_mx=="ISEMIN" | ///
							q7_other_mx=="ISSEMYN" | q7_other_mx=="centro de salud" | ///
							q7_other_mx=="hospital civil" | q7_other_mx=="publico" | ///
							q7_other_mx=="ss estdo de mexico"						
	
recode recq7_mx (995 = 14) if q7_other_mx=="NIGUHNO" | q7_other_mx=="NIGUNO" /// 14 is "You don't have insurance", used in Latin America 
		| q7_other_mx=="NINGUNA" | q7_other_mx=="NINGUNO" | q7_other_mx=="NINGUNO." ///
		| q7_other_mx=="NO TENGO" | q7_other_mx=="NO TIENE SEGURO" |  q7_other_mx=="Ninguno" ///
		| q7_other_mx=="ninguno"| q7_other_mx=="ninuno" | q7_other_mx=="no tiene ninguno" ///
		| q7_other_mx=="no tiene seguro" | q7_other_mx=="MEDICO PARTICULAR" | q7_other_mx=="medico particular"

recode recq7_mx (995 = 36) if q7_other_mx=="ISSAM" | q7_other_mx=="ISSSAM" | q7_other_mx=="SEDENA" /// different names for Marina or Army

recode q7_us (1 = 38 "Health insurance through your or someone else's employer or union") ///
		(2 = 39 "Medicare, a government plan that pays health bills for people aged 65 or older and for some disabled people") ///
		(3 = 40 "Medicaid or any other state medical assistance plan for those with lower incomes") ///
		(4 = 41 "Health insurance plan that you or another family member bought on your own (including Obamacare)") ///
		(5 = 42 " TRICARE (formerly CHAMPUS), VA, or military") ///
		(7 = 995 "Other") ///
		(.r = .r "Refused"), pre(rec) label(q7)		

gen q7 = max(q7_it, recq7_mx, recq7_us)
lab val q7 q7
recode q7 (. = .r) if q7_it == .r | q7_mx == .r | q7_us == .r
recode q7 (. = .a) if q7_us == .a
		
* Q7_other 
gen q7_other = q7_other_mx + q7_other_us

			 
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
recode q8 (. = .r) if q8_it == .r | q8_mx == .r | q8_us == .r

* Q19
* Only relevant for IT and MX
* Keep IT and MX separate from other countries
lab def labels34 .a "NA" .r "Refused", modify 
lab def labels36 .a "NA" .r "Refused", modify 

gen q19_other = q19_other_it + q19_other_mx

* Q20 
recode q20_it (1 = 501 "General practitioner's office") ///
			  (2 = 502 "Outpatient clinic") ///
			  (3 = 503 "Hospital outpatient department (doctor's office based in hospital)") ///
			  (4 = 504 "Hospital emergency room") ///
			  , pre(rec) label(q20) 

recode q20_mx (1 = 801 "Puesto de salud") ///
			  (2 = 802 "Clinica o unidad de medicina familiar") ///
			  (3 = 803 "Hospital general") ///
			  (4 = 804 "Centro Médico Nacional o Hospitales de especialidades como hospital de ginecología y obstetricia, pediatría...") ///
			  (5 = 805 "Clínica o unidad de medicina familiar, clínica o unidad de consulta externa, módulo de medecina familiar o puesto...") ///
			  (6 = 806 "Hospital general o regional") ///
			  (7 = 807 "Centro médico Nacional o Hospital de especialidades") ///
			  (8 = 808 "Brigada móvil de salud") ///
			  (9 = 809 "Centros de salud o centro de primer contacto") ///
			  (10 = 810 "Hospital civil, municipal, general, o regional") ///
			  (11 = 811 "Institutos Nacionales con hospitales monotemáticos (por ejemplo, Instituto Nacional de salud mental") ///
			  (12 = 812 "Brigada móvil de salud o unidad médica móvil") ///
			  (13 = 813 " Unidad de salud o Unidad de Médica Rural") ///
			  (14 = 814 "Hospital general, hospital rural o centro de atención rural obstétrica") ///
			  (15 = 815 "Clínica o unidad de consulta externa") ///
			  (16 = 816 "Hospital de especialidades") ///
			  (17 = 817 "Consultorio anexo a farmacia") ///
			  (18 = 818 "Consultorio médico privado o grupos de consultorios de especialidades de atención ambulatoria") ///
			  (19 = 819 "Hospital general privado") ///
			  (20 = 820 "Hospital de especialidades privado") ///
			  (21 = 995 "Other") ///
			  , pre(rec) label(q20) 

recode q20_us (1 = 1401 "Doctor's office, clinic, or health center") ///
			  (2 = 1402 "Urgent care clinic") ///
			  (3 = 1403 "Free community clinic or health center (e.g., Planned Parenthood or other clinics that are free of charge...") ///
			  (4 = 1404 "Veteran's Affairs, Military, or Indian Health Service clinic or health center") ///
			  (5 = 1406 "Hospital emergency room") ///
			  (6 = 1407 " Hospital outpatient department (doctor's office based in hospital)") ///
			  (8 = 995 "Other") ///
			  , pre(rec) label(q20) 			  

* FLAG - values and value labels labels for US data change between q20_us and q44_us
*		 I recoded above and shifted numbers to make them match 			  
			  
gen q20 = max(recq20_it, recq20_mx, recq20_us)
recode q20 (. = .r) if q20_it == .r | q20_mx == .r | q20_us == .r
recode q20 (. = .a) if q20_it == .a | q20_mx == .a | q20_us == .a
lab val q20 q20

* Q20 Other

gen q20_other = q20_other_it + q20_other_mx + q20_other_us


* Q43
* Only relevant for IT and MX
* Keep IT and MX separate from other countries
lab def labels58 .a "NA" .r "Refused", modify 
lab def labels60 .a "NA" .r "Refused", modify 

gen q43_other = q43_other_it + q43_other_mx


* Q44
recode q44_it (1 = 501 "General practitioner's office") ///
			  (2 = 502 "Outpatient clinic") ///
			  (3 = 503 "Hospital outpatient department (doctor's office based in hospital)") ///
			  (4 = 504 "Hospital emergency room") ///
			  , pre(rec) label(q44) 

recode q44_mx (1 = 801 "Puesto de salud") ///
			  (2 = 802 "Clinica o unidad de medicina familiar") ///
			  (3 = 803 "Hospital general") ///
			  (4 = 804 "Centro Médico Nacional o Hospitales de especialidades como hospital de ginecología y obstetricia, pediatría...") ///
			  (5 = 805 "Clínica o unidad de medicina familiar, clínica o unidad de consulta externa, módulo de medecina familiar o puesto...") ///
			  (6 = 806 "Hospital general o regional") ///
			  (7 = 807 "Centro médico Nacional o Hospital de especialidades") ///
			  (8 = 808 "Brigada móvil de salud") ///
			  (9 = 809 "Centros de salud o centro de primer contacto") ///
			  (10 = 810 "Hospital civil, municipal, general, o regional") ///
			  (11 = 811 "Institutos Nacionales con hospitales monotemáticos (por ejemplo, Instituto Nacional de salud mental") ///
			  (12 = 812 "Brigada móvil de salud o unidad médica móvil") ///
			  (13 = 813 "Unidad de salud o Unidad de Médica Rural") ///
			  (14 = 814 "Hospital general, hospital rural o centro de atención rural obstétrica") ///
			  (15 = 815 "Clínica o unidad de consulta externa") ///
			  (16 = 816 "Hospital de especialidades") ///
			  (17 = 817 "Consultorio anexo a farmacia") ///
			  (18 = 818 "Consultorio médico privado o grupos de consultorios de especialidades de atención ambulatoria") ///
			  (19 = 819 "Hospital general privado") ///
			  (20 = 820 "Hospital de especialidades privado") ///
			  (21 = 995 "Other") ///
			  , pre(rec) label(q44) 

recode q44_us (1 = 1401 "Doctor's office, clinic, or health center") ///
			  (2 = 1402 "Urgent care clinic") ///
			  (3 = 1403 "Free community clinic or health center (e.g., Planned Parenthood or other clinics that are free of charge...") ///
			  (4 = 1404 "Veteran's Affairs, Military, or Indian Health Service clinic or health center") ///
			  (5 = 1405 "Veteran's Affairs, Military, or Indian Health Service Hospital") ///
			  (6 = 1406 "Hospital emergency room") ///
			  (7 = 1407 "Hospital outpatient department (doctor's office based in hospital)") ///
			  (8 = 995 "Other") ///
			  , pre(rec) label(q44) 			  
			  
gen q44 = max(recq44_it, recq44_mx, recq44_us)
recode q44 (. = .r) if q44_it == .r | q44_mx == .r | q44_us == .r
recode q44 (. = .a) if q44_it == .a | q44_mx == .a | q44_us == .a
lab val q44 q44


* Q44 Other

gen q44_other = q44_other_it + q44_other_mx + q44_other_us

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
recode q63 (. = .r) if q63_it == .r | q63_mx == .r | q63_us == .r  

* Q66 - combine Mexico and Italy 
*		Keep Italy values, recode Mexico's values

recode q66_mx (1 = 7 "MORENA") ///
			  (2 = 8 "Partido Acción Nacional") ///
			  (3 = 9 "Partido Revolucionario Institucional") ///
			  (4 = 10 "Partido de la Revolución Democrática") ///
			  (5 = 11 "Partido del Trabajo") ///
			  (6 = 12 "Partido Verde Ecologista de México") ///
			  (7 = 13 "Movimiento Ciudadano") ///
			  (. = .r "Refused") (.a = .a "NA") ///
			  , gen(recq66_mx) label(labels77)

gen q66_it_mx = max(q66_it, recq66_mx)
lab val q66_it_mx labels77		
recode q66_it_mx (. = .r) if q66_it == .r | q66_mx == .r
recode q66_it_mx (. = .a) if q66_it == .a | q66_mx == .a


* Value labels for NA/Refused for other vars
lab def labels12 .a "NA" .r "Refused", modify 
lab def labels14 .a "NA" .r "Refused", modify 
lab def labels45 .a "NA" .r "Refused", modify 
lab def labels72 .a "NA" .r "Refused", modify 
lab def labels73 .a "NA" .r "Refused", modify 
		  
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop country q4 lang q7_it q7_mx q7_us recq7_mx recq7_us q8_it q8_mx q8_us recq8_it ///
     recq8_mx recq8_us q5_it q5_mx q5_us ///
	 recq5_it recq5_mx recq5_us q7_other_mx q7_other_us q19_other_it q19_other_mx ///
	 q20_it q20_mx q20_us recq20_it recq20_mx recq20_us q20_other_it q20_other_mx ///
	 q20_other_us q43_other_it q43_other_mx q44_it q44_mx q44_us recq44_it ///
	 recq44_mx recq44_us q44_other_it q44_other_mx q44_other_us q46b_refused ///
	 q63_it q63_mx q63_us recq63_it recq63_mx recq63_us q66_it q66_mx recq66_mx ///
     q6 q6_it q11 q12 q13 q18 q25_a q26 q28_c q29 q41 q30 q31 q32 q33 q34 q35 q36 q38 q39 ///
	 q40 q46a_it_mx_us q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q56a_mx q56b_mx q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q16 q17 q51 q52 q53 q2 q3 q14 q15 q24 q57 

ren rec* *

*------------------------------------------------------------------------------*

* Check for implausible values
* q23 q25_b q27 q28_a q28_b q46 q47


 foreach var in q23 q25_b q27 q28_b q46 q46b_it_mx_us q47 {
	foreach i in 12 13 14 {
		extremes `var' country if country == `i', high 
	}				
	 }

* NOTE: We will instead trim these at the derived variables stage for q23, but just doing this here for now 
replace q23 = . if q23 > 60 & q23 < .
* 3 values in US recoded, 2 in Italy 
replace q47 = . if q47 > 300 & q47 < . & country == 14
* 9 values recoded in US, 7 in Italy
	 
* Check for other implausible values 
list q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . 
* Note: okay in these data

list q23_q24 q27 country if q27 > q23_q24 & q27 < . 
* Note: okay in these data (2.5 is mid-point value)

list q26 q27 country if q27 == 0 | q27 == 1
* Some implasuible values of 0 and 1
* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
recode q26 (0 = 1) if q27 == 0
recode q27 (0 = .a)  
recode q27 (1 = 2) 

list q23_q24 q39 q40 country if q39 == 3 & q23_q24 > 0 & q23_q24 < . /// 
							  | q40 == 3 & q23_q24 > 0 & q23_q24 < .	 
* Note: okay in these data 
	 
*------------------------------------------------------------------------------*
order respondent_serial mode language weight_educ respondent_id country
order q*, sequential

* Label variables 
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q5_other "Q5. Other"
* Note this other variable is only in Italy/US/Mexico 
lab var q6 "Q6. Do you have health insurance?"
lab var q6_it "Q6. IT only: In addition to... are you covered by private health insurance...?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_other "Q7_other. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"
lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var q19_it "Q19. IT only: Is this facility... public, private SSN, or private not SSN?"
lab var q19_mx "Q19. MX only: Who runs this healthcare facility?"
lab var q19_other "Q19. Other"
lab var q20 "Q20. What type of healthcare facility is this?"
lab var q20_other "Q20. Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q28_c "Q28_C. How would you rate the overall quality of your last telemedicine visit?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_it "Q43. IT only: Last healthcare visit... public, private SSN, or private not SSN?"
lab var q43_mx "Q43. MX only: Who runs this healthcare facility?"
lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46_refused "Q46. Refused"
lab var q46b_refused "Q46B. Refused"
lab var q47_refused "Q47. Refused"
lab var q46a_it_mx_us "Q46A IT/MX/US only: Was this a scheduled visit or did you go without an appt.?"
lab var q46b_it_mx_us "Q46B IT/MX/US only: In days: how long between scheduling and seeing provider?"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q48_a "Q48_A. How would you rate the overall quality of care you received?"
lab var q48_b "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var q48_c "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var q48_d "Q48_D. How would you rate the level of respect your provider showed you?"
lab var q48_e "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var q48_f "Q48_F. How would you rate whether your provider explained things clearly?"
lab var q48_g "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var q48_h "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var q48_i "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var q48_j "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var q48_k "Q48_K. How would you rate how long it took for you to get this appointment?"
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private for-profit healthcare?"
lab var q56a_mx "Q56a. MX only: How would you rate the quality of services provided by IMSS?"
lab var q56b_mx "Q56b. MX only: How would you rate the quality of services...IMSS BIENESTAR?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62_mx "Q62. MX only: Do you speak any indigenous language or dialect?"
lab var q62a_us "Q62A. US only: What is your ethnicity?"
lab var q62b_us "Q62B. US only: What is your race?"
lab var q62_other "Q62. Other"
lab var q63 "Q63. Total monthly household income"
lab var q64 "Q64. Do you have another mobile phone number besides this one?"
lab var q65 "Q65. How many other mobile phone numbers do you have?"
lab var q66a_us "Q66 US only: Republican, Democrat, an Independent, or something else?"
lab var q66b_us "Q66. US only: Do you lean more towards the Republican or Democratic Party?"
lab var q66_it_mx "Q66. IT/MX only: Which political party did you vote for in the last election?"

*------------------------------------------------------------------------------*
 
* Save data

save "$data_mc/02 recoded data/pvs_it_mx_us.dta", replace
 