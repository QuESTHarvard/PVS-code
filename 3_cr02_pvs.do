* PVS Additional Cleaning
* September 2022
* N. Kapoor & R. B. Lobato

* u "$clean01survey", clear 
use "/Users/rodba/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/Internal HSPH/Data Quality/Data/clean01_all.dta"


****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Recode value labels *****************************
 * Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode Q6 Q11 Q12 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know"), ///
	   pre(rec) label(yes_no)

* All Excellent to Poor scales

recode Q9 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.a = .a NA) (.d = .d "Don't Know") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)

* All Very Confident to Not at all Confident scales 

recode Q16 Q17 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.a = .a NA) (.d = .d "Don't Know") (.r = .r Refused), /// 
	   pre(rec) label(vc_nc)

* Note to Rodrigo: Double check the inclusion of "Don't know"	   
	   
* Other questions 
* COVID doses question 
* Ignore Q49 and Q49_new for now 


***************************** Renaming variables *****************************
* Rename variables to match question numbers in current survey 
  
ren Q28 Q28_A
ren Q28_NEW Q28_B

drop Q6 Q11 Q12 Q9 Q16 Q17
ren rec* *

***************************** Labeling variables ***************************** 
 
lab var Q6 "Q6. Do you have health insurance?"

* Note for NK: Will have to figure out what to do with Other, specify data 

/*
* Another option 
u "$clean01survey", clear 

* All Yes/No questions
recode Q6 Q11 Q12 (2 = 0) 

lab de yes_no 1 "Yes" 0 "No" .r "Refused" .d "Don't know", replace

lab val Q6 Q11 Q12 yes_no

lab var Q6 "Q6. Do you have health insurance?"
