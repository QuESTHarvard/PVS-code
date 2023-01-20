

clear all
set more off 

*------------------------------------------------------------------------------*

* Macros from main file

* Dropping existing macros
macro drop _all

* Setting user globals 
global user "/Users/nek096"
*global user "/Users/tol145"


* Setting file path globals
global data "$user/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder 
global data_mc "$data/Multi-country"

* Path to data check output folders (TBD)
global output "$data_mc/03 test output/Output"

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

* MEK's additional variables

*add new confidence variable conf_both if people can get care AND can afford it

gen conf_getafford =.
replace conf_getafford=1 if conf_sick==1 & conf_afford==1
replace conf_getafford=0 if conf_sick==0 | conf_afford==0
tab conf_getafford

*split education into below and above secondary
recode education 0/1=0 2/3=1, gen (edu_secon)

*split income into lowest v other
recode income 0=0 1/2=1, gen (nonpoor)

*age over 50
centile age,  centile(10(10)90)
**over 50 is 80th percentile
gen over50=.
replace over50=1 if age>50
replace over50=0 if age<50

*younger adults
gen under30=.
replace under30=1 if age<30
replace under30=0 if age>30

*gen wealthy
recode income 0/1=0 2=1, gen (wealthy)

*gen most_educ
recode education 0/2=0 3=1, gen (most_educ)

*gen total score for PHC services
gen phc_score=.
replace phc_score=phc_women+phc_child+phc_chronic+phc_mental

*gen diff between private and public
gen qual_diff=.
replace qual_diff=qual_private-qual_public

*gen getting better AND only small changes needed**did not use this in regs
gen bett_minor=.
replace bett_minor=1 if system_outlook_getbet==1 & system_reform_minor==1
replace bett_minor=0 if system_outlook_getbet==0 | system_reform_minor==0


*** continuous score for 4 public health services (total points out of 20)--strength of primary care system
egen phc_cont = rowtotal(phc_women phc_child phc_chronic phc_mental)
* note: treats refusal (missing) as 0, a lot of refusal for these vars
* other option: gen phc_cont = phc_women + phc_child + phc_chronic + phc_mental
*				this results in 19% missing 


* difference between rating of public v private health system (private - public number of steps)
gen qual_priv_publ_diff = qual_private - qual_public
* note: only 2% missing due to reufusal
* other option, if want to treat refusal as 0 
*    gen qual_public_neg = qual_public * -1
*    egen qual_priv_publ_diff = rowtotal(qual_public_neg qual_private)


gen mdp=.
replace mdp=1 if income==0 & (education==0 | education==1) & health_vge==0
replace mdp=0 if income>0 | education>1 | health_vge==1
*mdp is 1 for 11% of sample (1100 people)

*------------------------------------------------------------------------------*

* Save new dataset for paper 1 	   
	   
save "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

*------------------------------------------------------------------------------*

* Descriptive analysis 

u "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

* Survey set
svyset psu_id_for_svy_cmds , strata(mode) weight(weight)

* Recode country 
recode country (3 = 1 "Ethiopia") (5 = 2 "Kenya") (9 = 3 "South Africa") (7 = 4 "Peru") ///
				(2 = 5 "Colombia") (10 = 6 "Uruguay") (11 = 7 "Lao PDR"), gen(country2)

* Add weight for ZA so commands will run 
recode weight (. = 1) if country == 9

* Data for histograms  

summtab2 , by(country2) vars(usual_quality_vge phc_women_vge phc_child_vge phc_chronic_vge ///
		   phc_mental_vge qual_public_vge qual_private_vge covid_manage_vge) /// 
		   type(2 2 2 2 2 2 2 2)  wts(weight) /// 
		   catmisstype(none) catrow /// 
		   total replace excel /// 
		   excelname(p1_exhib) sheetname(Exhibit 1 data) directory("$output") /// 
		   title(Data for Paper 1, Exhibit 1) 

summtab2 , by(country2) vars(system_outlook_getbet system_reform_minor conf_getafford ) /// 
		   type(2 2 2)  wts(weight) /// 
		   catmisstype(none) catrow /// 
		   total replace excel /// 
		   excelname(p1_exhib) sheetname(Exhibit 2 data) directory("$output") /// 
		   title(Data for Paper 1, Exhibit 2) 		   
	   

*Excellent and very good responses for key variables by demographic stratifiers

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if usual_quality_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if phc_women_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if phc_child_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if phc_chronic_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if phc_mental_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if system_outlook_getbet==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if system_reform_minor==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if conf_getafford==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if qual_public_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if qual_private_vge==1, col
}

foreach x of varlist gender2 over50 edu_secon urban nonpoor health_chronic { 
svy: tab `x' country2 if covid_manage_vge==1, col
}

/*

*ALTERNATIVE*
ssc install tabout

foreach x of varlist usual_quality_vge phc_women_vge phc_child_vge phc_chronic_vge phc_mental_vge system_outlook_getbet system_reform_minor conf_getafford qual_public_vge qual_private_vge {
tabout gender2 over50 edu_secon urban nonpoor health_chronic c if `x'==1 using toddtest_append.csv, append c(col) f(1 1) svy stats(chi2) percent ///
style(tab)
}
		   
summtab2 , by(country) vars(gender urban education health age_cat discrim visits) /// 
		   type(2 2 2 2 2 2 1) wts(weight) wtfreq(ceiling) /// 
		   catmisstype(missnoperc) /// 
		   mean median range pmiss total replace excel /// 
		   excelname(sample_char_table) sheetname(Sample Characteristics Table) directory("$output") /// 
		   title(Sample Characteristics Table) 

	