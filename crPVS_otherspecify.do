* Other specify recode file 
* Date of last update: July 2023
* Last updated by: N Kapoor, S Sabwa

/* Purpose of code file: 
	
	This file creates the "dq_out" other specify file. Aftw
*/

clear all
set more off

*============================= Other Specify ===============================* 
 
* This command lists all other, specify values
* This command requires an input file that lists all the variables with other, specify text 

use "$data_mc/02 recoded data/pvs_appended.dta", clear

*The code below generates a non-relevant interviewer id for the code to run, however it is not accurate because the interviewer id is deleted at a previous stage of data cleaning.
gen interviewer_id = respondent_serial
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


foreach i in 2 3 4 5 7 9 10 11 12 13 14 15 16 17 18 {
 preserve
 keep if country == `i'
  
 ipacheckspecify using "$data_mc/03 test output/Input/dq_inputs/dq_inputs_`i'.xlsm",   ///
 id(${id})         ///
 enumerator(${enum})       /// 
 date(${date})         ///
 sheet("other specify")      ///
    outfile("$output/dq_output/dq_output_`i'.xlsx")      ///
 outsheet1("other specify")     ///
 outsheet2("other specify (choices)")  ///
 sheetreplace
 
 loc childvars "`r(childvarlist)'"
 
 restore 
 
}	




