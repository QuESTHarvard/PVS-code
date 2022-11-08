* PVS High Frequency Checks
* ALL COUNTRIES
* September 2022
* N. Kapoor 
* This file is based off of IPA High Frequency Checks 4_checksurvey.do file 
* This is a subset of commands from the IPACHECK package relevant to PVS for data quality checks 

clear all
set more off 

 * Import prepped data

use "$pvs01", clear 
 

 *====================== Check start/end date of survey ======================* 


   list if $date < date("$startdate", "DMY") | $date > date("$endate", "DMY") 

   list $id if time_new > date("18:00:00", "earlytime") | time_new < date("latetime", "%tcHH:MM:SS")
  

 * Q for Todd - I'm not sure why this command isn't working, I thought it was working previously. 
 *				Any suggestions for how to fix or another way to do this? TL: THAT'S WEIRD, IT WORKED FOR ME. CAN YOU CHECK AGAIN? ALSO CAN WE CREATE AND SUMMARIZE AN INDICATOR VARIABLE FOR THIS INSTEAD OF LISTING?


 *========================== Find Survey Duplicates ==========================* 

 * This command finds and exports duplicates in Survey ID

 
   if $run_ids {
	   ipacheckids ${id},								///
				enumerator(${enum}) 					///	
				date(${date})	 						///
				key(${key}) 							///
				outfile("${hfc_output}") 				///
				outsheet("id duplicates")				///
				keep(${id_keepvars})	 				///
				dupfile("${id_dups_output}")			///
				${id_nolabel}							///
				sheetreplace							
						
   }
  

		
 * Notes: 
	* Variables to be kept can be added in the globals_pvs file (id_keepvars)
	* Can add force(), randomly keeping one observation, and add save(), saving a deduplicated dataset 
	* May not need "id_nolabel" (edit in globals file)
	* This code outputs to a file and can specify sheet 
	* If there are no duplicates, stata will tell you in the results window and no sheet or dataset is output 
	
 * Other methods 

	isid $id
	duplicates list $id
	

 
 *=============================== Outliers ==================================* 
 
 * This command checks for outliers among numeric survey variables 

   if $run_outliers {
		ipacheckoutliers using "${inputfile}",			///
			id(${id})									///
			enumerator(${enum}) 						///	
			date(${date})	 							///
			sheet("outliers")							///
        	outfile("${hfc_output}") 					///
			outsheet("outliers")						///
			${ol_nolabel}								///
			sheetreplace
   }
   
 * Notes:
	* This code requires an input file that lists variables to check for outliers 
		* I added variables on number of visits and wait time variables to the input file
		* You can specify method (iqr or sd), iqr being the default, but I changed to sd for in current input file 
		* You can specify multiplier, 1.5 for iqr and 3 for sd is default
		* You can specify "by" what variable in the input sheet, so could look for outliers "by" "Country"
		* There is a "combine" option to indicate if variables should be considered as 1 variable, affects summary statistics 
		* You can specify "keepvars" in the input file - but not working for "Country"
	* May not need "ol_nolabel" (see globals file)
	* This code outputs to a file and can specify sheet 
	

 * Looking at the output, I think this command might not be correctly calculating SD !!!
 * This incorrect SD is making range too narrow, thus, identifying outliers that are not likely outliers 
 * Below, I try a different method, and output a file that flags outliers using the SD method
 * In global file, edit which variables to check for outliers 
 
 * New Note to Todd (10/16/2022) - IPA said would fix this command last week! I haven't had a chance to check it, and may take some time for it to update TL: AMAZING, MAKING CHANGE ONE OBSCURE COMMAND AT A TIME, NEENA KAPOOR!! 

	if $run_outliers {
		foreach var in $ol_var {
		
			preserve
			egen `var'_sd = sd(`var')
			egen `var'_mean = mean(`var')
			gen `var'_upper = `var'_mean + (3*`var'_sd)
			gen `var'_lower = `var'_mean - (3*`var'_sd)
			gen `var'_otl = 1 if `var' > `var'_upper & `var' < . | `var' < `var'_lower & `var' < .
			keep if `var'_otl == 1
			export exc InterviewerID_recoded Respondent_Serial Country `var' `var'_mean `var'_sd using "$output/outliers.xlsx", sh(`var', replace) first(varl)
			restore
		
	 }
	 } 
	 
* Q for TODD - Any tips on how to improve this code? TL: SADLY I DONT THINK SO. GOOD JOB. 
* Any way to get the outliers to append into the same file? Maybe this is okay though because there are more now with more data 
* I will update the output file to its own global eventually once we confirm the method 
* Do we want to look for outliers by country data or across all the data? TL: THIS IS AN EXCELLENT QUESTION. BY COUNTRY. 
* Suggested method for identifying outliers? For checking data quality? 

 *============================= Other Specify ===============================* 
 
 * This command lists all other, specify values

 
   if $run_specify {
		ipacheckspecify using "${inputfile}",			///
			id(${id})									///
			enumerator(${enum})							///	
			date(${date})	 							///
			sheet("other specify")						///
        	outfile("${hfc_output}") 					///
			outsheet1("other specify")					///
			outsheet2("other specify (choices)")		///
			${os_nolabel}								///
			sheetreplace
			
			loc childvars "`r(childvarlist)'"
   }
   

 * Notes:
	* This command requires an input file that lists all the variables with other, specify text (keepvars is required)
	* If the values are not empty it will show up in the output, which is why the loop removing the space (94-96) was added
    * May not need "os_nolabel" (see globals file)
	* This code outputs to a file and can specify sheet 


 *=========================== Survey Dashboard ==============================* 

 * This command creates a survey dashboard with rates of interviews, duration, 
 * don't know, refusal, missing, and other useful  statistics


   if $run_surveydb {
		ipachecksurveydb,			 					///
			by(${sv_by})								///
			enumerator(${enum}) 						///
			date(${date})								///
			period("${sv_period}")						///
			dontknow(.d, ${dk_str})						///
			refuse(.r, ${ref_str})						///
			otherspecify(${os_child})					///
			duration(${duration})						///
			formversion(${formversion})					///
        	outfile("${surveydb_output}")				///
			${sv_nolabel}								///			
			sheetreplace
   }
  
 * Notes
	* The missing % in the output includes all kinds of missing (including NA, Don't know, Refused) - see below another method to summarize missing 
	* This command requires a "form version", generated in the clean01_pvs file (variable equal to 1 for all values)
	* This code outputs its own file

   *========================= Enumerator Dashboard ============================* 

 * This command creates enumerator dashboard with rates of interviews, duration, don't know, refusal, missing, and other by enumerator, and variable statistics by enumerator.

     if $run_enumdb {
		ipacheckenumdb using "${inputfile}",			///
			sheetname("enumstats")						///		
			enumerator(${enum})							///
			date(${date})								///
			period("${en_period}")						///
			dontknow(.d, ${dk_str})						///
			refuse(.r, ${ref_str})						///
			otherspecify(${os_child})					///
			duration(${duration})						///
			formversion(${formversion})					///
        	outfile("${enumdb_output}")					///
			${en_nolabel}								///
			sheetreplace
   }
   
 * Notes:
   * This command requires an input file where you can specify which questions to assess by enumerator 
   * This code outputs its own file
  
 * Q for Todd - do we want to remove this enumdb? Especially if we are doing it on multi-country data, doesn't feel too useful? TL: CUT

   *========================= Summarizing All Missing ============================* 

 * The IPACheck commands above do not distinguish between missing (.) and extended missing (.a, .b, c.)
 * Below I summarize NA (.a), Don't know (.d), Refused (.r) and true Missing (.) across the numeric variables(only questions) in the dataset 

* Count number of NA, Don't know, and refused across the row 
ipaanycount $all_num, gen(na_count) numval(.a)
ipaanycount $all_dk, gen(dk_count) numval(.d)
ipaanycount $all_num, gen(rf_count) numval(.r)

* Count of total true missing 
egen all_missing_count = rowmiss($all_num)
gen missing_count = all_missing_count  - (na_count + dk_count + rf_count)

* Denominator for percent of NA and Refused 
egen nonmissing_count = rownonmiss($all_num)
gen total = all_missing_count + nonmissing_count

* Denominator for percent of Don't know 
egen dk_nonmiss_count = rownonmiss($all_dk) 
egen dk_miss_count = rowmiss($all_dk) 
gen total_dk = dk_nonmiss_count + dk_miss_count 


preserve

collapse (sum) na_count dk_count rf_count missing_count total total_dk, by(Country)
gen na_perc = na_count/total
gen dk_perc = dk_count/total_dk
gen rf_perc = rf_count/total 
gen miss_perc = missing_count/total 
lab var na_perc "NA (%)" 
lab var dk_perc "Don't know (%)"
lab var rf_perc "Refused (%)"
lab var miss_perc "Missing (%)"
export exc Country na_perc dk_perc rf_perc miss_perc using "$hfc_output", sh(missing, replace) first(varl)

restore 


* Note:
	* These percents (.d and .r) vary slightly from the survey dashboard calculations because the denominator here does not include string variables or the variables on survey characteristics (date, time, etc.)
	
* Q for TODD - any tips on how to improve this code? TL: THERE ARE WAYS TO DO SIMILAR THINGS MORE EFFICIENTLY IF WE DON'T WANT AN EXACT PERCENTAGE BUT NOT WORTH WORRYING ABOUT RN. 
* Any better way to get number of all variables in a row without using rowmiss + rownonmiss (seems silly!) TL: IT DOES! COULD PROBABLY JUST MANUALLY ADD A DENOMINATOR AS NUMBER OF VARIABLES WONT CHANGE MUCH. 
* now that I'm doing by(Country) do we want total as well? Is there a way to do with collapse or would need to just add columns? COULD PROBABLY SUMMARIZE BY COUNTRY RATHER THAN COLLAPSING. 

OPTIONS TO EXPLORE:
bys Country: mvpatterns Q17 (SHOWS MISSING BY COUNTRY BUT NOT SURE IF WE CAN SEPARATE OUT KINDS OF MISSING)
misstable summarize Q28 (SHOWS MISSING AND EXTENDED MISSING FOR SPECIFIED VARIABLES)


	
	 
	 