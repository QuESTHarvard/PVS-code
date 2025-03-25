* PVS data cleaning for Italy, Mexico and US
* April 2023
* N. Kapoor, T. Lewis, S. Sabwa, M. Yu 

/*

This file cleans SSRS data (US, Italy Mexico). 

Cleaning includes:
	- Recoding implausible values 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

* Import data 
import spss using "$data_mc/01 raw data/HSPH Health Systems Survey_Final US Italy Mexico Weighted Data_3.8.23_confidential.sav", clear
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
ren Q1_3_OTHER_997 q5_other_it 
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
ren Q2_11_1 q28_b 
ren Q2_11B q28_c 
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
ren Q3_4A q46a 
ren Q3_4B_1X q46b_hrs
ren Q3_4B_2X q46b_dys
ren Q3_4B_3X q46b_wks
ren Q3_4B_4X q46b_mth
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
ren Q3_6_K q48_k 
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
ren Q4_5MX_C q56b_mx //IMSS bienestar 

* NOTE: discussed q54 vs q56 with MEK and CA 

ren Q4_5IT q54_it
ren Q4_5US q54_us
ren Q4_6 q55
ren Q4_8 q57
ren Q4_9 q58
ren Q4_10 q59
ren Q4_11 q60
ren Q4_12 q61
ren Q1_6MX q62_mx 
ren Q1_6A q62a_us 
ren Q4_13US q66a_us 
ren PARTYLEAN q66b_us 
ren Q4_14IT q63_it
ren Q4_14MX q63_mx
ren Q4_14US q63_us
ren Q4_13MX q66_mx 
ren Q4_13IT q66_it 

ren WEIGHT weight_educ
ren LANGUAGE lang
ren LOIMINUTES int_length 

generate double start_time = date( INTERVIEW_START , "YMDhms")
format start_time %tdD_M_CY
generate double end_time = date( INTERVIEW_END , "YMDhms")
format end_time %tdD_M_CY

clonevar date = end_time
recast long date

order q*, sequential
order respondent_serial mode lang country weight_educ


gen reccountry = country + 11
lab def country 12 "US" 13 "Mexico" 14 "Italy"
lab val reccountry country

lab def country_short 12 "US" 13 "MX" 14 "IT"
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is 999
gen reclanguage = reccountry*1000 + lang 
recode reclanguage (15058 = 13058)
*gen interviewer_id = country*1000 + interviewerid_recoded //no interview id related var in the dataset
* only q4 since others are country specific
gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 999

qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l labels11

foreach q in q4 {
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

lab def q4_label .a "NA" .r "Refused", modify

*****************************

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

recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .
*****************************

* Q46a, Q46b 
recode q46b_dys q46b_hrs q46b_mth q46b_wks (. = 0) if q46b_dys < . | ///
														  q46b_hrs < . | ///
														  q46b_mth < . | ///
														  q46b_wks < . 
gen q46b = (q46b_hrs/24) + q46b_dys + (q46b_wks*7) + (q46b_mth*30)
recode q46b (. = .r) if q46b_refused == 1 

* Q54 (selected Secretaria de Salud in Mexico)
egen q54 = rowmax(q54_mx q54_it q54_us)
lab val q54 labels69

* Q62a, Q62b 

gen q62b_us = .
egen q62b_choice = rowtotal( Q1_6B_1 Q1_6B_2 Q1_6B_3 Q1_6B_4 Q1_6B_5 Q1_6B_6)
recode q62b_us (. = 1) if Q1_6B_1 == 1 & q62b_choice == 1
recode q62b_us (. = 2) if Q1_6B_2 == 1 & q62b_choice == 1
recode q62b_us (. = 3) if Q1_6B_3 == 1 & q62b_choice == 1
recode q62b_us (. = 4) if Q1_6B_4 == 1 & q62b_choice == 1
recode q62b_us (. = 5) if Q1_6B_5 == 1 & q62b_choice == 1
recode q62b_us (. = 995) if Q1_6B_6 == 1 & q62b_choice == 1
recode q62b_us (. = 6) if q62b_choice > 0 & q62b_choice < .
recode q62b_us (. = .r) if Q1_6B_999 == 1
drop q62b_choice

lab def race 1 "Black or African American" 2 "Asian" 3 "Native Hawaiian or Other Pacific Islander" ///
			 4 "American Indian or Alaska Native" 5 "White" 6 "Mixed race" ///
			 995 "Other" .r "Refused" .a "NA"
lab val q62b_us race
ren Q1_6B_6_OTHER q62b_other_us


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
	 HID_LOI BLANDCELL BSSRS_MATCH_CODE CATICALLTIME DIALTYPE DTYPE ///
	 RECORDTYPE BIDENT2 BSTRATA BREGION1 BREGION2 BREGION3 BREGION4 BLOCALITY ///
	 BSTATE BITALY_REGIONS BMEXICO_STATES SAMPSOURCE q46_min q46_hrs q47_min q47_hrs ///
	 q54_it q54_us q54_mx q46b_dys q46b_hrs q46b_mth q46b_wks q4 lang start_time end_time

	 
* FLAG:
* Variables in our appended dataset that we need from this data (if avaialble)
* q64 (do you have more than one phone),
* q65 (if so how many phone numbers)
* And potentially a time of interview variable (currently drop this in appended dataset, but may add back)	 
	 
*------------------------------------------------------------------------------*

* Generate variables 
gen respondent_id = "US" + string(respondent_serial) if country == 1
replace respondent_id = "MX" + string(respondent_serial) if country == 2
replace respondent_id = "IT" + string(respondent_serial) if country == 3

gen q28_a = .a 
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
	   (998 = .d) // * FLAG - potentially no don't know response option in q25_a, q27, q63, There were don't know options for these questions in other countries 

* In raw data, 999 = "refused" 
recode q1 q2 q3 q5_it q5_mx q5_us q6 q6_it q7_us q7_mx q8* q9 q10 q11 q12 ///
	   q13 q14 q15 q16 q17 q18 q19_it q19_mx q20_it q20_mx q20_us q21 q22 ///
	   q23 q24 q23_q24 q25_a q25_b q26 q27 q28_b q28_c q29 q30 q31 q32 q33 ///
	   q34 q35 q36 q38 q39 q40 q41 q42 q43_it q43_mx q44_it q44_mx q44_us ///
	   q45 q46* q47* q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54* q55 /// 
	   q56* q57 q58 q59 q60 q61 q62_mx q62a_us q63* q66* (999 = .r)	
	  
*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*------------------------------------------------------------------------------*
	 
* Check for implausible values 
list q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . 
* Note: okay in these data

list q23_q24 q27 country if q27 > q23_q24 & q27 < . 
* Note: okay in these data (2.5 is mid-point value)

* Some implasuible values of 0 and 1
* Recode 0 values for q27 to .a for q27 and "No" for q26
* Recode 1 values to 2, because respondent likely meant 1 additional facility 
list q26 q27 country if q27 == 0 | q27 == 1
recode q26 (2 = 1) if q27 == 0 
recode q27 (0 = .a)  
recode q27 (1 = 2)	 

* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q23_q24 q28_b) //used q23_q24 and q28_b only since there's no q28_a

* list if they said "I did not get healthcare in the past 12 months" but has a visit
list q23_q24 q39 q40 country if q39 == 3 & visits_total > 0 & visits_total < . /// 
							  | q40 == 3 & visits_total > 0 & visits_total < .
							   
* Recoding Q39 and Q40 to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q39 q40 (3 = .r) if visits_total > 0 & visits_total < .
* total of 17 changes made to q39 and 21 changes made to q40

* list if it is .a but they have visit values in past 12 months 
list q23_q24 q39 q40 country if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* this is fine
							  
* list if they chose other than "I did not get healthcare in past 12 months" but visits_total == 0 
list q23_q24 q39 q40 country if q39 != 3 & visits_total == 0 /// 
							  | q40 != 3 & visits_total == 0
							  
* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q39 q40 (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 387 changes made to q39, 385 changes made to q40

drop visits_total

*------------------------------------------------------------------------------*

*q1/q2 : change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q2 (. = .a) if q1 > 0 & q1 < . 
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q6/q7 
recode q7_us (. = .a) if q6 == 2 | q6 == .r 

* q6_it asked in Italy, q6 not asked in MX 

* q13 
recode q13 (. = .a) if q12 == 2  | q12==.r

* q15 - No skip pattern everyone was asked q14 and q15 

*q19-22
recode q19_it q19_mx q20_it q20_mx q20_us q21 q22 (. = .a) if q18 == 2 | q18 == .r 
* Note: In Italy, SSRS asked q20 even if q19 was other or refused, but not the case in Mexico 
recode q20_mx (. = .a) if q19_mx == 7 | q18 ! = 1
* 37 changes made to q20_mx

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r
recode q25_a (. = .a) if q23 != 1
recode q25_b q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .r | q26 == .a
* FLAG - some missing in q27
* br q23 q24 q23_q24 q26 q27 if q27 == .

*q28_c
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r 

* q31 & q32
recode q31 (. = .a) if q3 != 2 | q2 == .r 
recode q32 (. = .a) if q3 != 2 | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43_it q43_mx q44_it q44_mx q44_us q45 q46 q46_refused q46a ///
	   q46b q46b_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r 

recode q48_k (. = .a) if q46a == 2 | q46a == .r

recode q44_it (. = .a) if q43_it == 4 // different from above 
recode q44_mx (. = .a) if q43_mx == 7 
recode q46b q46b_refused (. = .a) if q46a == 2 | q46a == .r

*q64/q65 - no variarbles on number of phone numbers

* q66 for US
recode q66b_us (. = .a) if q66a_us == 1 | q66a_us == 2

* Country-specific skip pattern - may not be needed as some of these are later merged 
recode q5_it q6_it q8_it q19_it q20_it q43_it q44_it q63_it q66_it (. = .a) if country != 3
recode q5_mx q7_mx q8_mx q19_mx q20_mx q43_mx q44_mx q56a_mx q56b_mx q62_mx q63_mx q66_mx (. = .a) if country != 2
recode q5_us q6 q7_us q8_us q20_us q44_us q62a_us q62b_us q63_us q66a_us q66b_us (. = .a) if country != 1 //added q62a_us

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q6 q11 q12 q13 q18 q25_a q26 q29 q41 q62_mx ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

lab val q46_refused q47_refused yes_no

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (3 .d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
recode q46a ///
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
* NOTE: "I had no prior tests or visits" was not an option
	 
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

lab var q2
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
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b q46 q46b q47 na_rf	
	
	
******* Country-specific *******
* Mode 
recode mode (2 = 1) (1 = 4)
lab def mode 1 "CATI" 4 "CAWI"
lab val mode mode


clonevar recq5_it = q5_it
replace recq5_it = 2 if q5_other_it=="CAMPAGNIA" |	q5_other_it=="PROVINCA DI SALERNO"
replace recq5_it = 4 if q5_other_it=="CALABRIA" 
replace recq5_it = 6 if q5_other_it=="PULIA" 
replace recq5_it = 11 if q5_other_it=="PIEMONTE"	|	q5_other_it=="TORINO"	|	q5_other=="piemonte"
replace recq5_it = 14 if q5_other_it=="umbria" 
replace recq5_it = 15 if q5_other_it=="ASCOLIPICENO"
replace recq5_it = 18 if q5_other_it=="lombardia"
replace recq5_it = 20 if q5_other_it=="venzia"

replace recq5_it = reccountry*1000 + recq5_it
replace recq5_it = 14995 if recq5_it == 14997 
gen recq5_mx = reccountry*1000 + q5_mx
gen recq5_us = reccountry*1000 + q5_us
gen q5 = max(recq5_it, recq5_mx, recq5_us)
recode q5 (. = .r) if q5_it == .r | q5_mx == .r | q5_us == .r

local l14 labels9
local l13 labels8
local l12 labels7

qui levelsof q5, local(q5level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q5level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q5_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}

label define q5_label 14995 "IT: Other" .a "NA" .r "Refused", add
label val q5 q5_label


* Q6 okay - q6 is US only, q6_it, is Italy specific 
* Q7 - combine q7_us and q7_mx
* create values for Italy		

recode q6_it (1 = 1 "Additional private insurance") ///
			 (2 = 2 "Only public insurance") ///
			 (.a = .a "NA") (.r = .r "Refused"), gen(q7_it) lab(q7_it_label)
gen recq7_it = reccountry*1000 + q7_it
replace recq7_it = .a if q7_it == .a
replace recq7_it = .r if q7_it == .r

gen recq7_mx = q7_mx
replace recq7_mx = 995 if q7_mx == 6

* Recoding the "other" insurance types in Mexico
recode recq7_mx (995 = 2) if q7_other_mx=="ISSSTESH" // misspelled ISSSTE 
*"CENTR O DE SALUD O HOSPITAL" grouped with MOH services (now covered by IMSS bienestar)
recode recq7_mx (995=3) if inlist(q7_other_mx, "CENTR O DE SALUD O HOSPITAL", "CENTRO DE SALUD", "CENTRO SALUD", "CLINICA", "HOSPITAL") | ///
							inlist(q7_other_mx, "HOSPITAL DEL GOBIERNO", "ISEMIN", "ISSEMYN", "centro de salud", "hospital civil", "publico", "ss estdo de mexico")				

*14 is "You don't have insurance", used in Latin America 
recode recq7_mx (995 = 14) if inlist(q7_other_mx, "NIGUHNO", "NIGUNO", "NINGUNA", "NINGUNO", "NINGUNO.", "NO TENGO", "NO TIENE SEGURO") | ///
							  inlist(q7_other_mx, "Ninguno", "ninguno", "ninuno", "no tiene ninguno", "no tiene seguro", "MEDICO PARTICULAR", "medico particular")

recode recq7_mx (995 = 4) if inlist(q7_other_mx, "ISSAM", "ISSSAM", "SEDENA") /// different names for Marina or Army

replace recq7_mx = reccountry*1000 + recq7_mx
replace recq7_mx = .a if q7_mx == .a
replace recq7_mx = .r if q7_mx == .r

gen recq7_us = q7_us
replace recq7_us = 995 if q7_us == 7
replace recq7_us = reccountry*1000 + recq7_us
replace recq7_us = .a if q7_us == .a
replace recq7_us = .r if q7_us == .r

gen q7 = max(recq7_it, recq7_mx, recq7_us)
recode q7 (. = .r) if q7_it == .r | q7_mx == .r | q7_us == .r
recode q7 (. = .a) if q7_it == .a | q7_mx == .a | q7_us == .a 

local l14 q7_it_label
local l13 labels23
local l12 labels22

qui levelsof q7, local(q7level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q7level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q7_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}


label define q7_label 12995 "US: Other" 13995 "MX: Other" 13014 "MX: None" .a "NA" .r "Refused", add
label val q7 q7_label 

* Q7_other 
gen q7_other = q7_other_mx + q7_other_us

* Q8
gen recq8_it = reccountry*1000 + q8_it
replace recq8_it = .r if q8_it == .r
gen recq8_mx = reccountry*1000 + q8_mx
gen recq8_us = reccountry*1000 + q8_us
gen q8 = max(recq8_it, recq8_mx, recq8_us)

local l14 labels26
local l13 labels25
local l12 labels24

qui levelsof q8, local(q8level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q8level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q8_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}

label define q8_label .a "NA" .r "Refused", add
label define q8_label 14001 "IT: Mai frequentato la scuola o solo Nido e Scuola dell infanzia", add 
label val q8 q8_label

recode q8 (. = .r) if q8_it == .r | q8_mx == .r | q8_us == .r

* Q19
* Only relevant for IT and MX
* Keep IT and MX separate from other countries
lab def labels34 .a "NA" .r "Refused", modify 
lab def labels36 .a "NA" .r "Refused", modify 

gen q19_other = q19_other_it + q19_other_mx


* FLAG - values and value labels labels for US data change between q20_us and q44_us

* Q20 
gen recq20_it = reccountry*1000 + q20_it 
gen recq20_mx = reccountry*1000 + q20_mx
replace recq20_mx = 13995 if q20_mx == 21
gen recq20_us = reccountry*1000 + q20_us	
replace recq20_us = 12995 if q20_us == 8
		  
gen q20 = max(recq20_it, recq20_mx, recq20_us)
recode q20 (. = .r) if q20_it == .r | q20_mx == .r | q20_us == .r
recode q20 (. = .a) if q20_it == .a | q20_mx == .a | q20_us == .a

local l14 labels37
local l13 labels35
local l12 labels38

qui levelsof q20, local(q20level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q20level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q20_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}

label define q20_label 12995 "US: Other" 13995 "MX: Other" .a "NA" .r "Refused", add
lab val q20 q20_label

* Q20 Other

gen q20_other = q20_other_it + q20_other_mx + q20_other_us

* Q43
* Only relevant for IT and MX
* Keep IT and MX separate from other countries
lab def labels58 .a "NA" .r "Refused", modify 
lab def labels60 .a "NA" .r "Refused", modify 

gen q43_other = q43_other_it + q43_other_mx

gen recq44_it = reccountry*1000 + q44_it
gen recq44_mx = reccountry*1000 + q44_mx
replace recq44_mx = 13995 if q44_mx == 21
gen recq44_us = reccountry*1000 + q44_us
replace recq44_us = 12995 if q44_us == 8	
  
gen q44 = max(recq44_it, recq44_mx, recq44_us)
recode q44 (. = .r) if q44_it == .r | q44_mx == .r | q44_us == .r
recode q44 (. = .a) if q44_it == .a | q44_mx == .a | q44_us == .a

local l14 labels61
local l13 labels59
local l12 labels57

qui levelsof q44, local(q44level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q44level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q44_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}
label define q44_label 12995 "US: Other" 13995 "MX: Other" .a "NA" .r "Refused", add
lab val q44 q44_label

* Q44 Other

gen q44_other = q44_other_it + q44_other_mx + q44_other_us


* Q63

gen recq63_it = reccountry*1000 + q63_it
gen recq63_mx = reccountry*1000 + q63_mx
gen recq63_us = reccountry*1000 + q63_us

gen q63 = max(recq63_it, recq63_mx, recq63_us)
recode q63 (. = .r) if q63_it == .r | q63_mx == .r | q63_us == .r  

local l14 labels78
local l13 labels76
local l12 labels74

qui levelsof q63, local(q63level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q63level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q63_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}
lab val q63 q63_label
lab def q63_label .a "NA" .r "Refused", add

* Q66 - combine Mexico and Italy 
*		Keep Italy values, recode Mexico's values

gen recq66_it = reccountry*1000 + q66_it
gen recq66_mx = reccountry*1000 + q66_mx
gen q66 = max(recq66_it, recq66_mx)
recode q66 (. = .r) if q66_it == .r | q66_mx == .r 

local l14 labels77
local l13 labels75

qui levelsof q66, local(q66level)
forvalues o = 1/`countryn' {
	
	local q = `: word `o' of `countryval''
	
	qui elabel list `l`q''
	local n = r(k)
	local val = r(values)
	local lab = r(labels)
	local g 0
	foreach i in `lab'{
		local ++g
		local gr`g' `i'
	}
	
	forvalues i = 1/`n' {
		
		local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of `val''
		foreach lev in `q66level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
					
				elabel define q66_label (= `: word `o' of `countryval''*1000+`: word `i' of `val'') ///
									    (`"`: word `o' of `countrylab'': `gr`i''"'), modify		
			}	
		}                 
	}
}
lab val q66 q66_label
recode q66 (. = .a) if reccountry == 12
lab def q66_label .a "NA" .r "Refused", add

* Value labels for NA/Refused for other vars
lab def labels12 .a "NA" .r "Refused", modify
lab def labels39 .a "NA" .r "Refused", modify
lab def labels50 .a "NA" .r "Refused", modify
lab def labels62 .a "NA" .r "Refused", modify 
lab def labels65 .a "NA" .r "Refused", modify 
lab def labels72 .a "NA" .r "Refused", modify 
lab def labels73 .a "NA" .r "Refused", modify 
		  
*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey

drop country q7_it q7_mx q7_us recq7_mx recq7_us recq7_it q8_it q8_mx q8_us recq8_it ///
     recq8_mx recq8_us q5_it q5_mx q5_us ///
	 recq5_it recq5_mx recq5_us q7_other_mx q7_other_us q19_other_it q19_other_mx ///
	 q20_it q20_mx q20_us recq20_it recq20_mx recq20_us q20_other_it q20_other_mx ///
	 q20_other_us q28_c q43_other_it q43_other_mx q44_it q44_mx q44_us recq44_it ///
	 recq44_mx recq44_us q44_other_it q44_other_mx q44_other_us q46b_refused ///
	 q63_it q63_mx q63_us recq63_it recq63_mx recq63_us q66_it q66_mx recq66_it recq66_mx ///
     q6 q6_it q11 q12 q13 q18 q25_a q26 q29 q41 q30 q31 q32 q33 q34 q35 q36 q38 q39 ///
	 q40 q46a q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q56a_mx q56b_mx q55 q59 q60 q61 q22 q48_e q48_j q50_a ///
	 q50_b q50_c q50_d q16 q17 q51 q52 q53 q2 q3 q14 q15 q24 q57 q62_mx

ren rec* *


order respondent_serial mode language weight_educ respondent_id country
order q*, sequential

* Label variables 
lab var country "Country"
lab var respondent_id "Respondent ID"
* respondent_serial
lab var int_length "Interview length (in minutes)" 
lab var date "Date of interview" 
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q5_other "Q5. IT only: Other"
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
lab var q46a "Q46A. Was this a scheduled visit or did you go without an appt.?"
lab var q46b "Q46B. In days: how long between scheduling and seeing provider?"
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
lab var q55 "Q55. How would you rate the quality of private healthcare?"
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
lab var q62b_other_us "Q62B. US only: Other" 
lab var q63 "Q63. Total monthly household income"
lab var q64 "Q64. Do you have another mobile phone number besides this one?"
lab var q65 "Q65. How many other mobile phone numbers do you have?"
lab var q66a_us "Q66 US only: Republican, Democrat, an Independent, or something else?"
lab var q66b_us "Q66. US only: Do you lean more towards the Republican or Democratic Party?"
lab var q66 "Q66. Which political party did you vote for in the last election?"

*------------------------------------------------------------------------------*

* Other, specify data recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other type of health insurance?"

gen q19_other_original = q19_other
label var q19_other_original "Q19. Other"

gen q20_other_original = q20_other
label var q20_other_original "Q20. Other"

gen q21_other_original = q21_other
label var q21_other_original "Q21. Other"

gen q42_other_original = q42_other
label var q42_other_original "Q42. Other"

gen q43_other_original = q43_other
label var q43_other_original "Q43. Other"

gen q44_other_original = q44_other
label var q44_other_original "Q44. Other"
	
gen q45_other_original = q45_other
label var q45_other_original "Q45. Other"	

gen q62b_other_us_original = q62b_other_us
label var q62b_other_us_original "Q62B. US only: Other"	

replace q19_other = subinstr(q19_other, `"""',  "", .)
replace q43_other = subinstr(q43_other, `"""',  "", .)
replace q45_other = subinstr(q45_other, `"""',  "", .)

foreach i in 12 13 14 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsm",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q19_other q20_other ///
	 q21_other q42_other q43_other q44_other q45_other q62b_other_us
	 
ren q7_other_original q7_other
ren q19_other_original q19_other
ren q20_other_original q20_other
ren q21_other_original q21_other
ren q42_other_original q42_other
ren q43_other_original q43_other
ren q44_other_original q44_other
ren q45_other_original q45_other
ren q62b_other_us_original q62b_other_us

order q*, sequential
order respondent_serial respondent_id mode country language date int_length weight_educ
*------------------------------------------------------------------------------*


* Save data

save "$data_mc/02 recoded data/input data files/pvs_it_mx_us.dta", replace
 
