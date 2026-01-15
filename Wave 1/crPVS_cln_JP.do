* People's Voice Survey data cleaning for Japan - Wave 1
* Date of last update: December 2025
* Last updated by: S Islam

/*

This file cleans Ipsos data for Japan. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** JAPAN ***********************

* Import raw data
import excel "$data/Japan/01 raw data/25-055861-01 Kyushu Univ Data.xlsx", sheet("S25050491") firstrow  

*Label as wave 1 data:
gen wave = 1

* data cleaning:
* check with Todd if the following can be dropped?
drop Q0 TRP1 TRP214 TRP224 TRP234 TRP244 Q13*scale Q437confirm

*------------------------------------------------------------------------------*
* Generate variables

gen respondent_id = "JP" + string(RespondentSerial)

gen country = 8
lab def country 8 "Japan"
lab values country country

* SI Note: check that this is the correct mode
gen mode = 1
lab def mode 1 "CAWI"
lab val mode mode

gen language = 8001
lab def Language 8001 "JP: Japanese"
lab val language Language

*------------------------------------------------------------------------------*
* Rename variables  

rename RespondentSerial respondent_serial
rename (Q1 Q2 Q3) (q1 q2 q3)
rename (Q4 Q5) (q3a_jp q3b_jp)
rename (Q6 Q7 Q8 Q9) (q4 q5 q7 q8)
rename (Q10 Q11) (q9 q10)
rename (Q141scale Q142scale Q143scale Q144scale Q145scale) (q12_a q12_b q12c_jp q12d_jp q12e_jp)
rename (Q15 Q16 Q16other1) (q13 q14_jp q14_other)
rename (Q17 Q17other1 Q18 Q18other1) (q15 q15_other q16 q16_other)
rename (Q19 Q20 Q21 Q22 Q23) (q17 q18 q19 q20 q21)
* rename (Q24 Q25 Q25other1) (q21a_jp q21b_jp q21b_jp_other) // SI: check naming with Todd
rename (Q28 Q29 Q30 Q30other1) (q22 q23 q24 q24_other)
rename (Q31 Q32) (q25 q26)
rename (Q331scale Q332scale Q333scale Q334scale Q335scale Q336scale Q337scale Q338scale Q339scale Q3310scale Q3311scale Q3312scale) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_jp q27j_jp q27k_jp q27l_jp)
rename (Q341scale Q342scale Q343scale Q344scale) (q28_a q28_b q28c_jp q28d_jp)
rename (Q35 Q36 Q36other1) (q29 q30 q30_other)
rename (Q371scale Q372scale Q373scale Q374scale) (q31a q31b q31c_jp q31d_jp)
rename (Q38 Q38other1 Q39 Q39other1 Q40 Q40other1) (q32_jp q32_other q33 q33_other q34 q34_other)
rename (Q41 Q42 Q43 Q43other1) (q35 q36 q37 q37_other)
rename (Q441scale Q442scale Q443scale Q444scale Q445scale Q446scale Q447scale Q448scale Q449scale Q4410scale Q4411scale) (q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k)
rename Q45 q39
rename (Q461scale Q462scale Q463scale Q464scale Q465scale Q466scale) (q40_a q40_b q40_c q40_d q40e_jp q40f_jp)
rename (Q471scale Q472scale Q473scale Q474scale Q475scale Q476scale) (q41_a q41_b q41_c q41d_jp q41e_jp q41f_jp)
rename (Q48 Q49 Q50 Q51 Q52 Q53) (q42 q43 q45 q46 q47 q48 q49)
rename (Q55 Q55other1) (q50 q50_other)
rename (Q56 Q57 Q58 Q58other1) (q51 q52a_jp q52b_jp q52b_jp_other)

*------------------------------------------------------------------------------*
* Generate recoded variables
* SI Note: left off cleaning JP data here 12/2025

gen q2 = .
replace q2 = 0 if q1 < 18
replace q2 = 1 if q1 >= 18 & q1 <= 29
replace q2 = 2 if q1 >= 30 & q1 <= 39
replace q2 = 3 if q1 >= 40 & q1 <= 49
replace q2 = 4 if q1 >= 50 & q1 <= 59
replace q2 = 5 if q1 >= 60 & q1 <= 69
replace q2 = 6 if q1 >= 70 & q1 <= 79
replace q2 = 7 if q1 >= 80

gen q14_de = .
replace q14_de = 1 if Q14_1 == 1
replace q14_de = 2 if Q14_2 == 1
replace q14_de = 3 if Q14_3 == 1
replace q14_de = 4 if Q14_4 == 1
replace q14_de = 5 if Q14_5 == 1
replace q14_de = 6 if Q14_6 == 1
replace q14_de = .a if Q14_1 == -1 | Q14_2 == -1 | Q14_3 == -1 | Q14_4 == -1 | Q14_6 == -1

rename Q14_5_TEXT q14_other
drop Q14_1 Q14_2 Q14_3 Q14_4 Q14_5 Q14_6

gen q15a_de = .
replace q15a_de = 1 if Q15A_1 == 1
replace q15a_de = 2 if Q15A_2 == 1
replace q15a_de = 3 if Q15A_3 == 1
replace q15a_de = 4 if Q15A_4 == 1
replace q15a_de = 5 if Q15A_5 == 1
replace q15a_de = 6 if Q15A_6 == 1
replace q15a_de = 7 if Q15A_7 == 1

rename Q15A_6_TEXT q15a_de_other
drop Q15A_1 Q15A_2 Q15A_3 Q15A_4 Q15A_5 Q15A_6 Q15A_7

replace q18 = 998 if Q18_EXCLUSIVE == 1
drop Q18_EXCLUSIVE

replace q21 = 998 if Q21_EXCLUSIVE == 1
drop Q21_EXCLUSIVE

replace q22 = 998 if Q22_EXCLUSIVE == 1
drop Q22_EXCLUSIVE

replace q23 = 998 if Q23_EXCLUSIVE == 1
drop Q23_EXCLUSIVE

gen q32_de = .
replace q32_de = 1 if Q32_1 == 1
replace q32_de = 2 if Q32_2 == 1
replace q32_de = 3 if Q32_3 == 1
replace q32_de = 4 if Q32_4 == 1
replace q32_de = 5 if Q32_5 == 1
replace q32_de = 6 if Q32_6 == 1
replace q32_de = .a if Q32_1 == -1 | Q32_2 == -1 | Q32_3 == -1 | Q32_4 == -1 | Q32_6 == -1

rename Q32_5_TEXT q32_other
drop Q32_1 Q32_2 Q32_3 Q32_4 Q32_5 Q32_6

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

foreach q in q4 q5 q7 q8 q15 q33 {
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


lab def q50_label 6001 "MW: Chichewa" 6002 "MW: Other" 6003 "MW: Tumbuka" 6004 "MW: Yao" 6005 "MW: Chilomwe" 6006 "MW: Chisena"
lab val recq50 q50_label

*****************************

drop q4 q5 q7 q8 q15 q33 q50 language
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

	drop end_dt
	
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

lab def q7_label .a "NA", modify

lab def q21_label .a "NA"
lab val q21 q21_label

lab def q39_label .a "NA"
lab val q39 q39_label

label drop language
lab def language 6001 "Chichewa" 6002 "English" 6003 "Tumbuka"
lab val language language 

*------------------------------------------------------------------------------*
* Renaming variables 

*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
label copy q50_label q50_label2
label copy recq51 q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label q33_label recq50 recq51

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
 save "$data_mc/02 recoded data/input data files/pvs_jp.dta", replace

*------------------------------------------------------------------------------*

