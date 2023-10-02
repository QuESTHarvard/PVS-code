* Other specify recode file 
* Date of last update: July 2023
* Last updated by: N Kapoor, S Sabwa

/* Purpose of code file: 
	
	This file creates the "dq_out" other specify file. Aftw
*/

clear all
set more off

***************************** Data quality checks *****************************
*use "$data_mc/02 recoded data/pvs_appended.dta", clear
* Macros for these commands
gl inputfile	"$data_mc/03 input output/Input/dq_inputs.xlsm"	
gl output		"$data_mc/03 input output/Output"				
gl id 			"respondent_id"	
gl key			"respondent_serial"	
gl enum			"interviewer_id"
gl date			"date"	
gl time			"time"
gl duration		"int_length"
gl keepvars 	"country"
global all_dk 	"q13b q13e q23 q25_a q25_b q27 q28_a q28_b q30 q31 q32 q33 q34 q35 q36 q38 q50_a q50_b q50_c q50_d q63 q64 q65"
global all_num 	"q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q19_et_in_ke_za q19_co q19_pe q19_uy q20 q21 q22 q23 q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q43_et_in_ke_za q43_co q43_pe q43_uy q44 q45 q46 q47 q46_min q46_refused q47_min q47_refused q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_ke_et q56_pe q56_uy q57 q58 q59 q60 q61 q62 q63 q64 q65"

*============================= Other Specify ===============================* 
 
* This command lists all other, specify values
* This command requires an input file that lists all the variables with other, specify text 

*use "$data_mc/02 recoded data/pvs_appended.dta", clear
import spss using "$data/Nigeria/01 raw data/23-015344-01 PVS Nigeria_Weighted Data_V1_InternalUseOnly.sav", case(lower)

*The code below generates a non-relevant interviewer id for the code to run, however it is not accurate because the interviewer id is deleted at a previous stage of data cleaning.
*gen interviewer_id = respondent_serial
gen respondent_id = "NG" + string(respondent_serial)

/*
*This section trims those "other specify" responses that just have a space and should be empty
replace q19_other=trim(q19_other)
replace q20_other=trim(q20_other)
replace q21_other=trim(q21_other)
replace q42_other=trim(q42_other)
replace q43_other=trim(q43_other)
replace q44_other=trim(q44_other)
replace q45_other=trim(q45_other)
replace q62_other=trim(q62_other)
replace q7_other=trim(q7_other)

*Remove "" from responses for macros to work
replace q19_other = subinstr(q19_other,`"""',  "", .)
replace q43_other = subinstr(q43_other,`"""',  "", .)
replace q45_other = subinstr(q45_other,`"""',  "", .)
*/

foreach i in 20 {
 *preserve
 *keep if country == `i'
  
 ipacheckspecify using "$data_mc/03 input output/Input/dq_inputs/dq_inputs_`i'.xlsm", ///
 id(${id}) ///
 enumerator(${enum}) /// 
 date(${date}) ///
 sheet("other specify") ///
    outfile("$output/dq_output/dq_output_`i'.xlsx") ///
 outsheet1("other specify") ///
 outsheet2("other specify (choices)") ///
 sheetreplace
 
 loc childvars "`r(childvarlist)'"
 
 *restore 
 
}	




