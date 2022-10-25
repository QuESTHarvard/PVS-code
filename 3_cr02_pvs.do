* PVS Additional Cleaning
* September 2022
* N. Kapoor & R. B. Lobato

* u "$clean01survey", clear 
use "/Users/rodba/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/Internal HSPH/Data Quality/Data/clean01_all.dta"

****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Recode value labels *****************************
 * Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused), ///
	   pre(rec) label(yes_no)

recode Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37_B Q38 Q66 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know"), ///
	   pre(rec) label(yes_no_dk)

recode Q39 Q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
* All Excellent to Poor scales
**Ask about the don't knows and na when that's not on the raw data. Option above and below
*recode Q22 ///
*	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
*	   (5 = 0 Poor) (.a = .a NA) (.d = .d "Don't Know") (.r = .r Refused), /// 
*	   pre(rec) label(exc_poor)
**

recode Q9 Q10 Q22 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H Q48_I Q54 Q55 Q56 Q59 Q60 Q61///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)
	   
recode Q48_E ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)
	 
recode Q48_J ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)
	   
recode Q50_A Q50_B Q50_C Q50_D ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "I am unable to judge") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)

* All Very Confident to Not at all Confident scales 
**Same dk na question
*recode Q16 Q17 ///
*	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
*	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
*	   (.a = .a NA) (.d = .d "Don't Know") (.r = .r Refused), /// 
*	   pre(rec) label(vc_nc)
	   
recode Q16 Q17 Q51 Q52 Q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(vc_nc)
	   
*Miscellaneous questions with unique answer options

recode Q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode Q14_NEW ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused), ///
	pre(rec) label(covid_vacc)
	
recode Q15 /// 
	   (1 = 1 Yes, "I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_doses)
	   
recode Q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused), ///
	pre(rec) label(number_visits)
	
recode Q49 ///
	(1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") ///
	(7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
	(.r = .r Refused), ///
	pre(rec) label(prom_score)

* Note to Rodrigo: Double check the inclusion of "Don't know"	   
	   
* Other questions 
* COVID doses question 
* Ignore Q49 and Q49_new for now 


***************************** Renaming variables *****************************
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
drop Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37_B ///
	Q38 Q66 Q39 Q40 Q9 Q10 Q22 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H ///
	Q48_I Q54 Q55 Q56 Q59 Q60 Q61 Q48_E Q48_J Q50_A Q50_B Q50_C Q50_D Q16 ///
	Q17 Q51 Q52 Q53 Q3 Q14_NEW Q15 Q24 Q49
ren rec* *
  
ren Q14_NEW Q14
ren Q15_NEW Q15
ren Q19_4 Q19_other
ren Q21_9 Q21_other
ren Q28 Q28_A
ren Q28_NEW Q28_B
ren Q37_B Q37
ren Q42_10 Q42_other
ren Q43_4 Q43_other

*Ask Neena about Q7_other Q19_4, Q20_other,Q21_9, 43_4 (how do we want to name them). The options of "other" don't exixt as a separate variable in the original questionnaire.

***************************** Labeling variables ***************************** 
 
lab var Q6 "Q6. Do you have health insurance?"
**All questions

*Ro note: Ask what I need to do here*

* Note for NK: Will have to figure out what to do with Other, specify data 

/*
* Another option 
u "$clean01survey", clear 

* All Yes/No questions
recode Q6 Q11 Q12 (2 = 0) 

lab de yes_no 1 "Yes" 0 "No" .r "Refused" .d "Don't know", replace

lab val Q6 Q11 Q12 yes_no

lab var Q6 "Q6. Do you have health insurance?"
