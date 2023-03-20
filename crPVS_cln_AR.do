* People's Voice Survey data cleaning for Argentina
* Last updated: March 14 2023
* N. Kapoor, S. Sabwa

************************************* Argentina ************************************

* Import data -confirm Path
use "/Users/shs8688/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Argentina (Mendoza)/01 raw data/PVS_Mendoza_Data_23.01.27.dta", clear

* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 
*"Codes" vars need to be recoded as .r (refused) and .d (don't know) only for the participants with values in the "Code" var

ren LanguageID Language
ren P46_Minutos int_length
ren pond weight
ren P1 q1

*needs to be recoded from P1 - confirm categories:
gen q2= .
replace q2 = 0 if (q1 >= 18 & q1 <= 29)
replace q2 = 1 if (q1 >= 30 & q1 <= 39)
replace q2 = 2 if (q1 >= 40 & q1 <= 49)
replace q2 = 3 if (q1 >= 50 & q1 <= 59)
replace q2 = 4 if (q1 >= 60 & q1 <= 69)
replace q2 = 5 if (q1 >= 70 & q1 <= 79)
replace q2 = 6 if (q1 >= 80)
replace q2 = .a if (q1==.)

ren P3_A q3
ren P3_B q3a_co_pe_uy_ar
ren P4 q4
ren P5 q5

*q7 is in 6 different vars: P71, P72, P73, P74, P75, P76 - need to change yes/no, yes to name of variable
gen q7 = 1601 if P71 == 1 
replace q7 =1602 if P72 == 1
replace q7 = 1603 if P73 == 1
replace q7 = 1604 if P74 == 1
replace q7 = 1605 if P75 == 1
replace q7 = 1606 if P76 == 1
*1607 = "No insurance" - 0 people with no insurance - check no accross as well
replace q7 = 1607 if P71==. | P72==. | P73==. | P74==. | P75==. | P76==.

ren P8 q8
ren P9 q9
ren P10 q10
ren P11 q11
ren P12 q12
ren P13 q13
ren P13_B q13b_co_pe_uy_ar
ren P13_E q13e_co_pe_uy_ar
ren P13_E_10 q13e_other
ren P14 q14
ren P15 q15
ren P16 q16
ren P17 q17
ren P18 q18
ren P19 q19_ar
ren P19_4 q19_other
ren P20 q20
*q20_other 
gen q20_other = P20_3 + P20_4 + P20_8 + P20_9 + P20_13 + P20_14 + P20_16 + P20_17 + P20_21 + P20_22 + P20_25 + P20_26
ren P21 q21
ren P21_10 q21_other
ren P22 q22

*adding .r/.d to q23 based on P23_Codes
replace P23 = .d if P23_Codes == 1
replace P23 = .r if P23_Codes == 2
ren P23 q23

ren P24 q24
ren P25 q25_a

*adding .r/.d to q23 based on P25_Codes - no data
replace P25_B = .d if P25_B_Codes == 1
replace P25_B = .r if P25_B_Codes == 2
ren P25_B q25_b

ren P26 q26

*adding .r/.d to q27 based on P27_Codes1 or P27_Codes2
replace P27 = .d if P27_Codes1 == 1
*P27_Codes2 only has "No" in the data right now 
replace P27 = .r if P27_Codes2 == 1 
ren P27 q27

*adding .r/.d to q28 based on P28_Codes1 or P28_Codes2
*Codes1 only has "No" in the data right now
replace P28 = .d if P28_Codes1 == 1
replace P28 = .r if P28_Codes2 == 1 
ren P28 q28_a

*adding .r/.d to q28_b based on P28_B_Codes1 or P28_B_Codes2
replace P28_B = .d if P28_B_Codes1 == 1
replace P28_B = .r if P28_B_Codes2 == 1 
ren P28_B q28_b

ren P29 q29
ren P30 q30
ren P31 q31
ren P32 q32
ren P33 q33
ren P34 q34
ren P35 q35
ren P36 q36
ren P38 q38
ren P39 q39
ren P40 q40
ren P41 q41
ren P42 q42
ren P42_11 q42_other
ren P43 q43_ar
ren P43_4 q43_other
ren P44 q44
*q44_other:
gen q44_other = P44_3 + P44_4 + P44_8 + P44_9 + P44_13 + P44_14 + P44_16 + P44_17 + P44_21 + P44_22 + P44_25 + P44_26
ren P45 q45
ren P45_4 q45_other
ren P46 q46
ren P47 q47

*probably will have to be recoded as well - confirm with Neena/Todd -drop 
replace P47_Codes = .r if P47_Codes == 96
ren P47_Codes q47_refused

ren P48_1_C q48_a
ren P48_2_C q48_b
ren P48_3_C q48_c
ren P48_4_C q48_d
ren P48_5_C q48_e
ren P48_6_C q48_f
ren P48_7_C q48_g
ren P48_8_C q48_h
ren P48_9_C q48_i
ren P48_10_C q48_j
ren P49 q49
ren P50_1_C q50_a
ren P50_2_C q50_b
ren P50_3_C q50_c
ren P50_4_C q50_d
ren P51 q51
ren P52 q52
ren P53 q53
ren P54 q54
ren P56 q55

*q56_ar
ren P55 q56a_ar
ren P66 q56b_ar
ren P67 q56c_ar
ren P57 q57
ren P58 q58
ren P59 q59
ren P60 q60
ren P61 q61
ren P63 q63
ren P64 q64

*adding .r/.d to q65 based on P65_Codes1 or P65_Codes2
replace P65 = .d if P65_Codes1 == 1
replace P65 = .r if P65_Codes2 == 1 
ren P65 q65

*------------------------------------------------------------------------------*

* Date
generate date=mdy(CurrentMonth,CurrentDay,CurrentYear) 
format date %tdD_M_CY

*------------------------------------------------------------------------------*

* Drop unused or other variables - dropped P1_Codes because it has no data and no label as to which question it belongs to

drop P2 DataCollection_Status1 introduccion confidencial Auto_grab P2 SampleFields_SampDEPARTAMENTO SampleFields_SampZONA SampleFields_SampZONAP3A SampleFields_SampTIPO SampleFields_SampSEXO SampleFields_SampPROVINCIA_DS SampleFields_SampEDAD cr1 cr2 cr3 cr4 cr5 P29_B P71 P72 P73 P74 P75 P76 P20_3 P20_4 P20_8 P20_9 P20_13 P20_14 P20_16 P20_17 P20_21 P20_22 P20_25 P20_26 P44_3 P44_4 P44_8 P44_9 P44_13 P44_14 P44_16 P44_17 P44_21 P44_22 P44_25 P44_26 CurrentMonth CurrentDay CurrentYear P1_Codes P23_Codes P25_B_Codes P27_Codes1 P27_Codes2 P28_Codes1 P28_Codes2 P28_B_Codes1 P28_B_Codes2 P65_Codes1 P65_Codes2
 

*------------------------------------------------------------------------------*

* Recode refused and don't know values 

*6= "SIN_DATO" which translates to "WITHOUT DATA" in google translate
recode q2 (6=.a)


*"No response" vars





*------------------------------------------------------------------------------*

* Generate variables 

* Respondent ID - Already one in dataset, ignore?
gen respondent_id = "AR" + string(respondent_serial)

gen country = 16 
gen mode = 1
gen q6 = .a

*q46_refused will have to be recoded to .r if it equals something - confirm with Neena/Todd
*ren P46_Minutos_Codes q46_refused
*replace P46_Minutos_Codes = 1 if P46_Minutos_Codes == 96

*------------------------------------------------------------------------------*

* Country-specific values and value labels 

*** Mia changed this part ***
gen reclanguage = country*1000 +language
gen recq5 = country*1000 + q5  
gen recq4 = country*1000 + q4
gen interviewer_id = country*1000 + interviewerid
gen recq8 = country*1000 + q8
replace recq8 = .r if q8== .r
gen recq44 = country*1000 + q44
replace recq44 = country*1000 + 995 if q44== 4
replace recq44 = .r if q44== .r
gen recq62 = country*1000 +q62
replace recq62 = country*1000 + 995 if q62 == 4
replace recq62 = .r if q62== .r
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== .r
replace recq63 = .d if q63== .d

* Q6/Q7 - LA specific
recode q6_la (1 = 11001 "LA: Additional private insurance") (2 = 11002 "LA: Only public insurance") (99 = .r "Refused"), gen(q7) label(q7_label)
* NOTE to self: check this 

* Mia: relabel some variables now so we can use the orignal label values
local q4l place
local q5l province
local q8l educ
local q44l fac_type3
local q62l lang
local q63l income

foreach q in q4 q5 q8 q44 q62 q63{
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
		local recvalue`q' = 11000+`: word `i' of ``q'val''
		foreach lev in ``q'level' {
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 11000+`: word `i' of ``q'val'') ///
										(`"LA: `gr`i''"'), modify
			}
		}         
	}
	
	label val rec`q' `q'_label
}

label define q62_label 11995 "LA: Other", add
label define q44_label 11995 "LA: Other", add


*------------------------------------------------------------------------------*

* Check for other implausible values 

*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns
 
*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions
recode q11 q12 q13 q13b_co_pe_uy_ar q13e_co_pe_uy_ar q18 q25_a q26 q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)
	  
	   
* All Excellent to Poor scales

recode q9 q10 q22 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	 

* All Very Confident to Not at all Confident scales 
	   
recode q16 q17  ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
