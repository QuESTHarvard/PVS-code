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
ren Q1_4 q3 
ren Q1_5 q4 
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
ren Q2_4 q21
ren Q2_4_9_OTHER q21_other
ren Q2_5 q22
ren Q2_6_1 q23
ren Q2_7 q24
ren Q2_8A q25_a
ren Q2_8B q25_b
ren Q2_9 q26
ren Q2_10_1 q27
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
ren Q3_4_2 q46
ren Q3_4_999 q46_refused
ren Q3_5_2 q47
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
ren Q3_7 q49
ren Q4_1_A q50_a
ren Q4_1_B q50_b
ren Q4_1_C q50_c
ren Q4_1_D q50_d
ren Q4_2_A q51
ren Q4_2_B q52
ren Q4_2_C q53
ren Q4_6 q55
ren Q4_8 q57
ren Q4_9 q58
ren Q4_10 q59
ren Q4_11 q60
ren Q4_12 q61
ren Q4_14IT q63_it
ren Q4_14MX q63_mx
ren Q4_14US q63_us


*------------------------------------------------------------------------------*

* Time variables? 


*------------------------------------------------------------------------------*

* Drop unused variables 

drop STATUS STATU2 INTERVIEW_START INTERVIEW_END LAST_TOUCHED LASTCOMPLETE ///
	 XSUSPEND QS LLINTRO LLINTRO2 CELLINTRO

*------------------------------------------------------------------------------*

* Generate variables 

*------------------------------------------------------------------------------*

* Refused values / Don't know values


* In raw data, 997 = "don't know" 
recode q30 (998 = .d)
	   
* In raw data, 996 = "refused" 
recode q4 q8_it q8_mx q8_us q63_it q63_mx q63_us (999 = .r)	


*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense


* Country-specific 

* Q4: Values above 20 available 
gen recq4 = q4 + 30
lab def q4 31 "City" 32 "Suburb of city" 33 "Small town" 34 "Rural area" .r "Refused"
lab val recq4 q4 

* Q8: Values above 50 available 
recode q8_it (2 = 52 "Scuola primaria") (3 = 53 "Scuola secondaria di primo grado") ///
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

drop q4 recq8_it recq8_mx recq8_us recq63_it recq63_mx recq63_us

ren rec* *

*------------------------------------------------------------------------------*

* Check for implausible values
* q23 q25_b q27 q28_a q28_b q46 q47
 
*------------------------------------------------------------------------------*

* Label variables 

*------------------------------------------------------------------------------*
 
* Save data

save "$data_mc/02 recoded data/pvs_it_mx_us.dta"
 