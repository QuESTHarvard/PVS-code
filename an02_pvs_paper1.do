

clear all
set more off 

*------------------------------------------------------------------------------*

* Macros from main file

* Dropping existing macros
macro drop _all

* Setting user globals 
global user "/Users/nek096"

* Setting file path globals
global data "$user/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder 
global data_mc "$data/Multi-country"

*------------------------------------------------------------------------------*

* Import clean data with derived variables 

u "$data_mc/02 recoded data/pvs_all_countries.dta", replace

*------------------------------------------------------------------------------*
* Derive additional variables for Paper 1 analysis 

* usual_quality last_qual phc_women phc_child phc_chronic phc_mental qual_private 
* qual_public system_outlook system_reform covid_manage gender health health_mental

* usual_qual
recode usual_quality (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_e) label(exc_pr_hlthcare_1)

recode usual_quality (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_vge) label(exc_pr_hlthcare_2)

* last_qual	   
recode last_qual (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_e) label(exc_pr_1)
	   
recode last_qual (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_vge) label(exc_pr_2)

* phc_women

recode phc_women (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_e) label(exc_pr_judge_1)
	   

recode phc_women (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_vge) label(exc_pr_judge_2)

* phc_child 

recode phc_child (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_e) label(exc_pr_judge_1)
	   

recode phc_child (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_vge) label(exc_pr_judge_2)	   

* phc_chronic

recode phc_chronic (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_e) label(exc_pr_judge_1)
	   

recode phc_chronic (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_vge) label(exc_pr_judge_2)	   	   
	   
* phc_mental

recode phc_mental (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_e) label(exc_pr_judge_1)
	   

recode phc_mental(0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_vge) label(exc_pr_judge_2)	  

* qual_private  
recode qual_private (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_e) label(exc_pr_1)
	   
recode qual_private (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_vge) label(exc_pr_2)

* qual_public
recode qual_public (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_e) label(exc_pr_1)
	   
recode qual_public (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_vge) label(exc_pr_2)

* covid_manage
recode covid_manage (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_e) label(exc_pr_1)
	   
recode covid_manage (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_vge) label(exc_pr_2)

* system outlook

recode system_outlook ///
	(0 1 = 0 "Staying the same/Getting worse") (2 = 1 "Getting better") ///
	(.r = .r "Refused") , gen(system_outlook_getbet) label(system_outlook2)

* system reform

recode system_reform ///
	(1 2 = 0 "Major changes/Rebuilt") (3 = 1 "Minor changes") ///
	(.r = .r "Refused") , gen(system_reform_minor) label(system_reform2)
	
* gender
gen gender2 = gender
recode gender2 (2 = .)
lab var gender2 "Gender (binary)"

* health
recode health (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_vge) label(health2)

* health_mental
recode health_mental (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_mental_vge) label(health_mental2)


*------------------------------------------------------------------------------*

* Save new dataset for paper 1 	   
	   
save "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace



	