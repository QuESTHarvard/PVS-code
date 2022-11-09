* PVS Globals for data quality checks
* September 2022
* N. Kapoor 
* This file is based off of IPA High Frequency Checks Globals do-file 
* Note to Todd - eventually only relevant globals will be added to the Main file to reduce the number of files TL: LETS KEEP ALL HFC GLOBALS SEPARATE--CAN WE MERGE THIS FILE WITH THE HFC DO FILE?
* I think some globals will still be useful, but a lot of the globals that include like question numbers will just have to be removed since it might vary so much by country 

********************************************************************************

	* NB: Edit this section: Change value to 0 to turn off specific checks
	
	gl run_ids				1	//	Check Survey ID for duplicates
	gl run_outliers			1	//	Check numeric variables for outliers
	gl run_specify			1	//	Check for other specify values
	gl run_surveydb			1	//	Create survey Dashboard
	gl run_enumdb			1	//	Create enumerator Dashboard
	
	* There are more checks you can run with the IPA package, this is a subset that is relevant for PVS

	* Q for TODD - I'm considering removing lines 10-14, and not have the additional unecessary loops TL: CUT
	*			   I think it just makes it complicated/confusing, and is only useful if someone is doing only some of the checks 
	*			   But if you think I should keep it, that's fine, I should just add one for summarizing missing 
	
/* Input Files

	Description of globals for input files:
	---------------------------------------

    inputfile		Inputs file for ipacheckoutliers, ipacheckspecify and optional 
					enumstats inputs for ipacheckenumdb

*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl inputfile			"$data_mc/03 hfc/Input/hfc_inputs.xlsm"			
	

/* Datasets
	
	Description of globals for datasets:
	------------------------------------
	
	rawsurvey 			Raw Survey Data
	
	clean01survey		Prepped Survey Data after very basic cleaning is done to 
						prepare the survey for high frequency checks
						
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change filenames if neccesary
	* Currently interim data and saving to interim data folder 
	
	gl rawsurvey			"$data_mc/00 interim data/HARVARD(ET_Main,Ke_Main,Ke_F2F)_21.09.222.dta" 		
	gl pvs01			    "$data_mc/00 interim data/pvs_et_ke_01.dta"			

**# Output Date Folder
*------------------------------------------------------------------------------*	
	
	* NB: DO NOT EDIT THIS SECTION (other than the file path)
	
*	gl folder_date			= string(year(today())) + "-`:disp %tdNN today()'-`:disp %tdDD today()'"
*	cap mkdir				"$output/$folder_date"

* Q for TODD - do we want to keep the folder date? TL: NO
* I just removed it since we aren't really doing "HFCs" - and gets a little annoying having a different date any day you run it, even if it is the same data 

/* Output files

	Description of globals for output files:
	----------------------------------------
	
	id_dups_output 		[.dta]  Raw Duplicates output
			
	hfc_output			[.xlsx] Output file for HFCs 
			
	surveydb_output		[.xlsx] Output file for Surveyor Dashboard 
	
	enumdb_output		[.xlsx] Output file for Enumerator Dashboard
					
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change filenames if neccesary
	
	gl id_dups_output 		"$output/survey_duplicates.dta"	
	gl hfc_output			"$output/hfc_output.xlsx"		
	gl surveydb_output		"$output/surveydb.xlsx"			
	gl enumdb_output		"$output/enumdb.xlsx"			
	
/* Admin variables

	Description of globals for admin variables:
	-------------------------------------------
	
	Admin variables specified here are variables that will be used multiple 
	times for different checks. Users can also modify variables for specific 
	commands in the master do-file if neccesary. 
	
	* Required Variables: 
	
	key					Unique key. Variable containing unique keys for each 
						submission. Note that this is different from the Survey ID. 
	
	id 					Survey ID. Variable containing the ID for each respondent/
						observation. 
	
	enum				Enumerator variable
		
	date				Survey Date Variable. Must be a DATETIME variable
	
	time_new			Survey Time variable 
	
	keepvars 			Global keep variables. These variables will be applied as 
						keep variables for all checks. User may include or edit 
						these below at the individual sections for each check.
	
	formversion 		Form version variable. Must be a numeric variable. Note 
						that this is expected to be a numeric variable with higher 
						values representing the most recent form version.  
	
	duration			Duration variable. Must be a numeric variable. 
	
	startdate			Day of survey start in date/time format of "date" variable
	
	enddate				Day of survey end in date/time format of "date" variable
	
	earlytime			Earliest time that a survey should occur
	
	latetime			Latest time that a survey should occur 
	
	all_ref				All questions that have refused as a response option 
					    (before cleaning)
						
	all_dk				All questions that have don't know as a response option 
	
	all_num				All questions (numeric variables) in survey after cleaning 
						(some commands do not allow string variables) 

	
*/
*------------------------------------------------------------------------------*

	* NB: Edit this section: Change variable names if neccesary. 
	
	* Required Variables:
	
	gl key					"Respondent_Serial"												
	gl id 					"Unique_ID"													
	gl enum					"InterviewerID_recoded"
	gl date					"Date"	
	gl time					"time_new"
	
	* Optional Variables:
	
	gl keepvars 			"Country"	
	gl formversion			"formversion"
	gl duration				"int_length"
	gl startdate			"17-Aug-2022"
	gl enddate				"09-Sep-2022"
	gl earlytime			"07:00:00"
	gl latetime				"18:00:00"
	
* Q for TODD - what start/end times seem reasonable? TL: 7AM IS GOOD; LATE TIME MAKE 20:00 PLEASE

	* Globals for questions (no ID's or interview characteristics, or string variables (other, specify))
	* "Other, specify" variables excluded
	
	global all_ref 		"Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14_NEW Q15_NEW Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q43 Q44 Q45 Q46 Q47 Q46_refused Q47_refused Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56 Q57 Q58 Q59 Q60 Q61 Q62 Q63 Q66 Q67"

	global all_dk 		"Q23 Q25_A Q25_B Q27 Q28 Q28_NEW Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q63 Q66 Q67"
	
	global all_num 		"Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14_NEW Q15_NEW Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q43 Q44 Q45 Q46_min Q46_refused Q47_min Q47_refused Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q49_new Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56 Q57 Q58 Q59 Q60 Q61 Q62 Q63 Q66 Q67"
	
/* Missing values

	Description of globals for missing values:
	------------------------------------------
	
	Missing values specified here will be used multiple times for different checks. 
	Users can also modify missing values for specific checks in other sections below 
	or in the master do-file. 
	
	dk_num 	 		   numlist indicating survey values that represent "don't know" 
					   in numeric variables. eg. "-999 999 .999". 
					   * NB: These values will be recoded as .d in the 3_prep do-file. 
	
	dk_str 	 		   space seperated list indicating survey values that represent 
					   "don't know" in string variables. eg. "-999 999 DK". 
					   * NB: This is primarily aimed to work with select 
					   multiple type questions. 
					   
	ref_num 	 	   numlist indicating survey values that represent "refuses to answer" 
					   in numeric variables. eg. "-888 888 .888". 
					   * NB: These values will be recoded as .r in the 3_prep do-file. 
	
	ref_str 	 	   space seperated list indicating survey values that represent 
					   "refuses to answer" in string variables. eg. "-888 888 REFUSE". 
					   * NB: This is primarily aimed to work with select 
					   multiple type questions. 	
*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary. 
	* These are used in the ipachecksurveydb and ipacheckenumdb comm
	
	gl dk_num 				"997"												
	gl dk_str 				"997"												
	gl ref_num				"996"												
	gl ref_str				"996"										

	/* ipacheckids: Export duplicates in Survey ID

	Description of globals for ipacheckids:
	---------------------------------------
	
	ipacheckids finds  and exports duplicates in Survey ID. 

	id_keepvars 		Additional survey variables to show in output file.
						eg. "${keepvars} hhh_fullname"
						
	id_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values


*/
*------------------------------------------------------------------------------*
	
	* NB: Edit this section: Change values if neccesary.
	
	gl id_keepvars			"${keepvars}"										
	gl id_nolabel			""													

	
/* ipacheckoutliers: Export outliers for numeric variables

	Description of globals for ipacheckoutliers:
	--------------------------------------------
	
	ipacheckoutliers checks for outliers among numeric survey variables.
	
	NB: Set-up is required in global inputfile
	
	ol_nolabel         Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
						
	ol_var			   List of variables to check for outliers 
*/
*------------------------------------------------------------------------------*	
	
	* NB: Edit this section: Change values if neccesary.
	
	gl ol_nolabel			""
	
	gl ol_var				"Q23 Q25_B Q27 Q28 Q28_NEW Q46_min Q47_min"
	
	
	* NB: Set-up required options in the input file										

	/* ipacheckspecify: Export other specify values

	Description of globals for ipacheckspecify:
	--------------------------------------------
	
	ipacheckspecify checks for recodes of other specify variables by listing 
	all values specified
	
	NB: Set-up is required in global input file
	
	os_parent			Variable list of Other,specify "parent" variables
	
	os_parent			Variable list of Other,specify "child" variables
	
	os_nolabel			Option to apply export underlying values instead of value 
						labels. 
						* Specify "nolabel" to apply nolabel
						* leave blank to export value labels instead of values
*/
*------------------------------------------------------------------------------*
	
	
	gl os_parent			"Q7 Q19 Q20 Q21 Q42 Q43 Q44 Q62"
	gl os_child 			"Q7_other Q19_4 Q20_other Q21_9 Q42_10 Q43_4 Q44_other Q45_other Q62_other"
	gl os_nolabel			""													

	* NB: Set-up required options in the input file
	* NK Note: Q20 and Q44 have two other, specify variables? 
	
/* ipachecksurveydb: Export Survey Dashboard

	Description of globals for ipachecksurveydb:
	--------------------------------------------
	
	ipachecksurveydb creates survey dashboard with rates of interviews, duration, 
	don't know, refusal, missing, and other useful statistics.
	
	sv_period  			Interval for showing productivity (daily, weekly, monthly, auto)
	
	sv_by 				Variable for disaggregating survey statistics. eg. "treatment_status"
	
	sv_nolabel			Option to apply export underlying values instead of value labels
						* Specify "nolabel" to apply nolabel 
						* leave blank to export value labels instead 

*/
*------------------------------------------------------------------------------*
	
	gl sv_period  			"auto"												
	gl sv_by 				"Country"	
	gl sv_nolabel			""

	
/* ipacheckenumdb: Export enum dashboard

	Description of globals for ipacheckenumdb:
	------------------------------------------
	
	ipacheckenumdb creates enumerator dashboard with rates of interviews, duration, 
	don't know, refusal, missing, and other by enumerator, and variable statistics 
	by enumerator.

	en_period  			Interval for showing productivity (daily, weekly, monthly, auto)

*/
*------------------------------------------------------------------------------*

	gl en_period        	"auto"												
		
