* PVS Additional Cleaning for analyses 
* September 2022
* N. Kapoor & R. B. Lobato
* Note to Todd: Eventually this file might be combined with cr01  

* u "$pvs01", clear 
use "/Users/rodba/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/Internal HSPH/Data Quality/Data/clean01_all.dta"

****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Recode value labels *****************************
 * Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused), ///
	   pre(rec) label(yes_no)

recode Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q66 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know"), ///
	   pre(rec) label(yes_no_dk)

* Note to Rodrigo: Q37_B isn't in these data right now so I removed it (command won't run with it there)
* Feel free to delete this and above comment, and just leave below comment for our reference 
* For future data, may need to add Q37_B 

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

recode Q9 Q10 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H Q48_I Q54 Q55 Q56 Q59 Q60 Q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused), /// 
	   pre(rec) label(exc_poor)
	   
recode Q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "I did not receive healthcare form this provider in the past 12 months") (.r = .r Refused), /// 
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
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused), /// 
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

recode Interviewer_Gender ///
	(1 = 0 Male) (2 = 1 Female), ///
	pre(rec) label(int_gender)

recode Q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode Q14_NEW ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused), ///
	pre(rec) label(covid_vacc)
	
recode Q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
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
drop Interviewer_Gender Q3 Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 Q30 Q31 Q32 Q33 Q34 Q35 Q36 ///
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
*ren Q37_B Q37
ren Q42_10 Q42_other
ren Q43_4 Q43_other

**What happened to 64 and 65? It seems 66 and 67 should be 64 and 65. Renamed below.
ren Q66 Q64
ren Q67 Q65

* Question to Neena: Q37_B not in current data (country_specific ). Shall we shift 38 to become 37, etc.?

*Reorder variables

order Q*, sequential
order Q*, after(Interviewer_Gender)


***************************** Labeling variables ***************************** 
 
lab var Q1 "Q1. Respondent еxact age"
lab var Q2 "Q2. Respondent's age group"
lab var Q3 "Q3. Q3. Respondent gender (Female)"
lab var Q4 "Q4. Type of area where respondent lives"
lab var Q5 "Q5. County, state, region where respondent lives"
lab var Q6 "Q6. Do you have health insurance?"
lab var Q7 "Q7. What type of health insurance do you have?"
lab var Q7_other "Q7_other. Other type of health insurance"
lab var Q8 "Q8. Highest level of education completed by the respondent"
lab var Q9 "Q9. In general, would you say your health is:"
lab var Q10 "Q10. In general, would you say your mental health is?"
lab var Q11 "Q11. Q11. Do you have any longstanding illness or health problem?"
lab var Q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var Q13 "Q13. Was it confirmed by a test?"
lab var Q14 "Q14. How many doses of a COVID-19 vaccine have you received, or have you not"
lab var Q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var Q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var Q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var Q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var Q19 "Q19. Is this a public, private, or NGO/faith-based healthcare facility?"
lab var Q19_other "Other"
lab var Q20 "Q20. What type of healthcare facility is this?"
lab var Q20_other "Other"
lab var Q21 "Q21. Why did you choose this healthcare facility?"
lab var Q21_other "Other"
lab var Q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var Q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var Q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var Q25_A "Q25_A. Was this visit for COVID-19?"
lab var Q25_B "Q25_B. How many of these visits were for COVID-19? "
lab var Q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var Q27 "Q27. How many different healthcare facilities did you go to?"
lab var Q28_A "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var Q28_B "Q28_B. How many virtual or telemedicine visits did you have?"
lab var Q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var Q30 "Q30. Blood pressure tested in the past 12 months"
lab var Q31 "Q31. Received a mammogram in the past 12 months"
lab var Q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var Q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var Q34 "Q34. Had your teeth checked in the past 12 months"
lab var Q35 "Q35. Had a blood sugar test in the past 12 months"
lab var Q36 "Q36. Had a blood cholesterol test in the past 12 months"
*lab var Q37 "Q37_B. Had a test for HIV in the past 12 months"
lab var Q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var Q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var Q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var Q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var Q42 "Q42. The last time this happened, what was the main reason?"
lab var Q42_other "Other"
lab var Q43 "Q43. Last healthcare visit in a public, private, or NGO/faith-based facility?"
lab var Q43_other "Other"
lab var Q44 "Q44. What type of healthcare facility is this?"
lab var Q44_other "Other"
lab var Q45 "Q45. What was the main reason you went?"
lab var Q45_other "Other"
lab var Q46_refused "Q6. Do you have health insurance?"
lab var Q46 "Q6. Do you have health insurance?"
lab var Q47_refused "Refused"
lab var Q47 "Q47. Approximately how much time did the provider spend with you?"
lab var Q48_A "Q48_A. How would you rate the overall quality of care you received?"
lab var Q48_B "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var Q48_C "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var Q48_D "Q48_D. How would you rate the level of respect your provider showed you?"
lab var Q48_E "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var Q48_F "Q48_F. How would you rate whether your provider explained things clearly?"
lab var Q48_G "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var Q48_H "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var Q48_I "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var Q48_J "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var Q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var Q50_A "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var Q50_B "Q50_B. How would you rate the quality of care provided for children?"
lab var Q50_C "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var Q50_D "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var Q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var Q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var Q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var Q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var Q55 "Q55. How would you rate the quality of private for-profit healthcare?"
lab var Q56 "Q56. How would you rate the quality of the NGO or faith-based healthcare?"
lab var Q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var Q58 "Q58. Which of these statements do you agree with the most?"
lab var Q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var Q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var Q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var Q62 "Q62. Respondent's mother tongue or native language"
lab var Q62_other "Other"
lab var Q63 "Q63. Total monthly household income"
lab var Q64 "Q64. Do you have another mobile phone number besides the one I am calling you on?"
lab var Q65 "Q65. How many other mobile phone numbers do you have?"



**All questions

*Ro note: Ask what I need to do here*

* Note for NK: Will have to figure out what to do with Other, specify data 

***************************** Save data *****************************
* Note to Rodrigo: When finished, save data in the "Data/Multi-country/interim 00" folder 
* The data can be named pvs_ke_et_02
* I wrote a command below, I can show you how to use macros at some point 

* save "$data_mc/00 interim data/pvs_et_ke_02.dta", replace

