* TEMP file to recode LAC data 
* November 2022
* N. Kapoor

use "$data_mc/00 interim data/LAC interim data 10252022.dta", clear

*------------------------------------------------------------------------------*

* Fix interview length variable and other time variables 
* Edit this section to include other date and time variables as needed 

* Formatting time 
format time_new Q46 Q47 %tcHH:MM:SS


* Converting interview length to minutes so it can be summarized

generate int_length = (hh(IntLength)*3600 + mm(IntLength)*60 + ss(IntLength)) / 60


* Converting Q46 and Q47 to minutes so it can be summarized
generate Q46_min = (hh(Q46)*3600 + mm(Q46)*60 + ss(Q46)) / 60

generate Q47_min = (hh(Q47)*3600 + mm(Q47)*60 + ss(Q47)) / 60


*------------------------------------------------------------------------------*

global all_ref 	"Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q13B Q13E Q14_NEW Q15_NEW Q16 Q17 Q18 Q19_PE Q19_UY Q19_CO Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q43_PE Q43_UY Q43_CO Q44 Q45 Q46 Q47 Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56_UY Q56_PE Q57 Q58 Q59 Q60 Q61 Q62 Q63 Q66 Q67"

global all_dk  "Q13B Q13E Q23 Q25_A Q25_B Q27 Q28 Q28_NEW Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q63 Q66 Q67"

global all_num "Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q13B Q13E Q14_NEW Q15_NEW Q16 Q17 Q18 Q19_PE Q19_UY Q19_CO Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q43_PE Q43_UY Q43_CO Q44 Q45 Q46 Q47 Q46_min Q47_min Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56_UY Q56_PE Q57 Q58 Q59 Q60 Q61 Q62 Q63 Q66 Q67"
	
* Recode Refused and Don't know

recode $all_dk (997 = .d)

recode $all_ref (996 = .r)
	
*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked due to skip patterns

*Q1/Q2 
recode Q2 (. = .a) if Q1 != .r
recode Q1 (. = .r) if Q2 != .a

*Q6 why completely missing?

* Q7 
* recode Q7 (. = .a) if Q6 == 2 | Q6 == .r 

* Q13 
recode Q13 (. = .a) if Q12 == 2 | Q12 == .r | Q12 == .d 
recode Q13B (. = .a) if Q12 == 2 | Q12 == .r | Q12 == .d 
recode Q13E (. = .a) if Q13B == .a | Q13B == 1 | Q13B == .d | Q13B == .r

*TEMP
* drop Q13B Q13E Q13E_10

* Q15
recode Q15_NEW (. = .a) if Q14_NEW == 3 | Q14_NEW == 4 | Q14_NEW == 5 | Q14_NEW == .r


*Q19-22
recode Q19_PE Q19_UY Q19_CO Q20 Q21 Q22 (. = .a) if Q18 == 2 | Q18 == .r 
recode Q19_PE (. = .a) if Country != 7
recode Q19_UY (. = .a) if Country != 10
recode Q19_CO (. = .a) if Country != 2
* recode Q20 (. = .a) if Q19_PE == 4 | Q19_UY == 4 | Q19_CO  == 4
recode Q20 (. = .a) if Q19_PE == .r | Q19_UY == .r | Q19_CO  == .r

* NA's for Q23-27 
recode Q24 (. = .a) if Q23 != .d | Q23 != .r
recode Q25_A (. = .a) if Q23 != 1
recode Q25_B (. = .a) if Q23 == 0 | Q23 == 1 | Q24 == 1 | Q24 == .r 
recode Q26 (. = .a) if Q23 == 0 | Q23 == 1 | Q24 == 1 | Q24 == .r 
recode Q27 (. = .a) if Q26 != 2

* Q31 & Q32
recode Q31 (. = .a) if Q3 == 1 | Q1 < 50 | Q2 == 1 | Q2 == 2 | Q2 == 3 | Q2 == 4 | Q1 == .r | Q2 == .r 
recode Q32 (. = .a) if Q3 == 1 | Q1 == .r | Q2 == .r

* Q42
recode Q42 (. = .a) if Q41 == 2 | Q41 == .r


* Q43-49 NA's
recode Q43_CO Q43_PE Q43_UY Q44 Q45 Q46 Q46_min Q47 Q47_min Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F /// 
	   Q48_G Q48_H Q48_I Q48_J Q49 (. = .a) if Q23 == 0 | Q24 == 1 | Q24 == .r
	   
recode Q43_PE (. = .a) if Country != 7
recode Q43_UY (. = .a) if Country != 10
recode Q43_CO (. = .a) if Country != 2
recode Q44 (. = .a) if Q43_PE == .r | Q43_UY == .r | Q43_CO  == .r
* recode Q44 (. = .a) if Q43 == 4 


*Q46/Q47 refused
* recode Q46 Q46_min (. = .r) if Q46_refused == 1
* recode Q47 Q47_min (. = .r) if Q47_refused == 1

* Q56_PE, Q56_UY
recode Q56_PE (. = .a) if Country != 7
recode Q56_UY (. = .a) if Country != 10

*Q62
recode Q62 (. = .a) if Country == 10

*Q66/67
recode Q67 (. = .a) if Q66 == 2 | Q66 == .d | Q66 == .r 
* recode Q66 Q67 (. = .a) if mode == 2


*------------------------------------------------------------------------------*

* Drop any unwanted/empty variables 

* drop 
drop if Q2 == 1 | Q1 < 18

*------------------------------------------------------------------------------*
* In IPA code they also check that "key" variable has no missing values, generate a short key variable, drop data based on date/time
*------------------------------------------------------------------------------*

* Relabeling - some of these labels don't output well to excel (generally due to the appostrophes in the label)
* Add any other variables if needed

lab var Q2 "Q2. Respondents age group"
lab var Q13E "Q13E. Why didnt you receive health care for COVID-19?"
lab var Q48_F "Q48_F. How would you rate the staffs ability to explain things to you in a way"
lab var Q53 "Q53. How sure are you that peoples opinions are taken into account when making"

*lab var Q62 "Q62. Respondents mother tongue or native language" 

save "$data_mc/00 interim data/pvs_lac_01.dta", replace


****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Recode value labels *****************************
 * Recode values and value labels so that their values and direction make sense

u "$data_mc/00 interim data/pvs_lac_01.dta", clear

* All Yes/No questions

recode Q6 Q11 Q12 Q13 Q13B Q13E Q18 Q25_A Q26 Q29 Q41 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

recode Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q66 /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

* For future data, may need to add Q37_B 

recode Q39 Q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
* All Excellent to Poor scales

recode Q9 Q10 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H Q48_I Q54 Q55 Q56_PE Q56_UY Q59 Q60 Q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode Q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (6 = .a "I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode Q48_E ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode Q48_J ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode Q50_A Q50_B Q50_C Q50_D ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)

* All Very Confident to Not at all Confident scales 
	   
recode Q16 Q17 Q51 Q52 Q53  ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
*Miscellaneous questions with unique answer options

recode Interviewer_Gender ///
	(1 = 0 Male) (2 = 1 Female), ///
	pre(rec) label(int_gender)

recode Q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode Q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

recode Q14_NEW ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)
	
recode Q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode Q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)
	
recode Q49 ///
	(1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") ///
	(7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)

recode Q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)


***************************** Renaming variables *****************************
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
drop Interviewer_Gender Q2 Q3 Q6 Q11 Q12 Q13 Q13B Q13E Q18 Q25_A Q26 Q29 Q41 Q30 Q31 Q32 Q33 Q34 Q35 Q36 ///
	Q38 Q66 Q39 Q40 Q9 Q10 Q22 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H ///
	Q48_I Q54 Q55 Q56_PE Q56_UY Q59 Q60 Q61 Q48_E Q48_J Q50_A Q50_B Q50_C Q50_D Q16 ///
	Q17 Q51 Q52 Q53 Q3 Q14_NEW Q15 Q24 Q49 Q57

ren rec* *
 
ren Q7_995 Q7_other
ren Q14_NEW Q14
ren Q15_NEW Q15
ren Q19_4 Q19_other
ren Q20_Other Q20_other
ren Q21_9 Q21_other
ren Q28 Q28_A
ren Q28_NEW Q28_B
*ren Q37_B Q37
ren Q42_10 Q42_other
ren Q43_4 Q43_other
ren Q44_Other Q44_other
ren Q45_11 Q45_other
ren Q66 Q64
ren Q67 Q65

* Q37_B not currently in these data 

*Reorder variables

order Q*, sequential
order Q*, after(Interviewer_Gender)


***************************** Labeling variables ***************************** 
 
lab var int_length "Interview length (in minutes)"
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
lab var Q11 "Q11. Do you have any longstanding illness or health problem?"
lab var Q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var Q13 "Q13. Was it confirmed by a test?"
lab var Q13B "Q13B. Did you seek health care for COVID-19? (LAC Countries)"
lab var Q13E "Q13E. Why didnt you receive health care for COVID-19? (LAC Countries)"
lab var Q14 "Q14. How many doses of a COVID-19 vaccine have you received, or have you not"
lab var Q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var Q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var Q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var Q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var Q19_PE "Q19. Peru: Is this a public or private healthcare facility?"
lab var Q19_UY "Q19. Uruguay: Is this a public, private, or mutual healthcare facility?"
lab var Q19_CO "Q19. Colombia: Is this a public or private healthcare facility?"
lab var Q19_other "Q19. Other"
lab var Q20 "Q20. What type of healthcare facility is this?"
lab var Q20_other "Q20. Other"
lab var Q21 "Q21. Why did you choose this healthcare facility?"
lab var Q21_other "Q21. Other"
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
lab var Q42_other "Q42. Other"
lab var Q43_PE "Q43. Peru: Is this a public or private healthcare facility?"
lab var Q43_UY "Q43. Uruguay: Is this a public, private, or mutual healthcare facility?"
lab var Q43_CO "Q43. Colombia: Is this a public or private healthcare facility?"
lab var Q43_other "Other"
lab var Q44 "Q44. What type of healthcare facility is this?"
lab var Q44_other "Q44. Other"
lab var Q45 "Q45. What was the main reason you went?"
lab var Q45_other "Q45. Other"
lab var Q46_min "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var Q47_min "Q47. In minutes: Approximately how much time did the provider spend with you?"
*lab var Q46_refused "Q46. Refused"
lab var Q46 "Q46. Approximately how long did you wait before seeing the provider?"
*lab var Q47_refused "Q47. Refused"
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
lab var Q56_PE "Q56. Peru: How would you rate the quality of the social security system?"
lab var Q56_UY "Q56. Uruguay: How would you rate the quality of the mutual healthcare system?"
lab var Q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var Q58 "Q58. Which of these statements do you agree with the most?"
lab var Q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var Q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var Q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var Q62 "Q62. Respondent's mother tongue or native language"
*lab var Q62_other "Q62. Other"
lab var Q63 "Q63. Total monthly household income"
lab var Q64 "Q64. Do you have another mobile phone number besides the one I am calling you on?"
lab var Q65 "Q65. How many other mobile phone numbers do you have?"


ren date Date
* CATI Mode
gen mode = 1

order Respondent_Serial Respondent_ID InterviewerID_recoded Interviewer_Gender mode /// 
Country Date time_new IntLength int_length Q*

* Variables not in these data: ECS_ID PSU_ID Interviewer_Language Language
* (Added mode above)

save "$data_mc/00 interim data/pvs_lac_02.dta", replace

***************************** Append data *****************************

append using "$data/Kenya/00 interim data/pvs_ke_02.dta"

ren Q56 Q56_KE 
lab var Q56_KE "Q56. Kenya: How would you rate the quality of the NGO or faith-based healthcare?"
ren Q19 Q19_KE 
lab var Q19_KE "Q19. Kenya: Is this a public, private, or NGO/faith-based healthcare facility?"
ren Q43 Q43_KE 
lab var Q43_KE "Q43. Kenya: Is this a public, private, or NGO/faith-based healthcare facility?"

lab def m 1 "CATI" 2 "F2F"
lab val mode m
lab var mode "Mode of interview"

* TODD - may need to fix some other variables
* ordering below wasn't working well at first 

order Respondent_Serial Respondent_ID ECS_ID PSU_ID InterviewerID_recoded Interviewer_Language Interviewer_Gender mode Country Language Date time_new IntLength int_length Q1_codes Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q7_other Q8 Q9 Q10 Q11 Q12 Q13 Q13B Q13E Q13E_10 Q14 Q15 Q16 Q17 Q18 Q19_KE Q19_CO Q19_PE Q19_UY Q19_other Q20 Q20_other Q21 Q21_other Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28_A Q28_B Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q42_other Q43_KE Q43_CO Q43_PE Q43_UY Q43_other Q44 Q44_other Q45 Q45_other Q46 Q46_min Q46_refused Q47 Q47_min Q47_refused Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56_KE Q56_PE Q56_UY Q57 Q58 Q59 Q60 Q61 Q62 Q62_other Q63 Q64 Q65 QC_short _v1


save "$data_mc/00 interim data/pvs_ke_lac_01.dta", replace

***************************** Deriving variables *****************************

u "$data_mc/00 interim data/pvs_ke_lac_01.dta", clear

* age_calc: exact respondent age or middle of age range 
gen age_calc = Q1 
recode age_calc (.r = 23.5) if Q2 == 0
recode age_calc (.r = 34.5) if Q2 == 1
recode age_calc (.r = 44.5) if Q2 == 2
recode age_calc (.r = 54.5) if Q2 == 3
recode age_calc (.r = 64.5) if Q2 == 4
recode age_calc (.r = 74.5) if Q2 == 5
recode age_calc (.r = 80) if Q2 == 6
lab def ref .r "Refused"
lab val age_calc ref

* age_cat: categorical age 
gen age_cat = Q2
recode age_cat (.a = 0) if Q1 >= 18 & Q1 <= 29
recode age_cat (.a = 1) if Q1 >= 30 & Q1 <= 39
recode age_cat (.a = 2) if Q1 >= 40 & Q1 <= 49
recode age_cat (.a = 3) if Q1 >= 50 & Q1 <= 59
recode age_cat (.a = 4) if Q1 >= 60 & Q1 <= 69
recode age_cat (.a = 5) if Q1 >= 70 & Q1 <= 79
recode age_cat (.a = 6) if Q1 >= 80
lab val age_cat age_cat

* female: gender 	   
gen female = Q3
lab val female gender

* covid_vax
recode Q14 ///
	(0 = 0 "unvaccinated (0 doses)") (1 = 1 "partial vaccination (1 dose)") /// 
	(2 3 4 = 2 "fully vaccinated (2+ doses)") (.r = .r Refused) (.a = .a NA), ///
	gen(covid_vax)
	
* covid_vax_intent 
gen covid_vax_intent = Q15 
lab val covid_vax_intent yes_no_doses

* patient_activiation
* NOTE - Todd, see if this code makes sense 
gen patient_activation = 2 if Q16 == 3 & Q17 == 3	
recode patient_activation (. = 1) if Q16 == 3 & Q17 == 2 | Q16 == 2 & Q17 == 3 | /// 
						  Q16 == 2 & Q17 == 2	
recode patient_activation (. = .r) if Q16 == .r | Q17 == .r
recode patient_activation (. = 0) if Q16 == 0 | Q16 == 1 | Q17 == 0 | Q17 == 1
lab def pa 0 "Not activated (Not too confident and Not at all confident for either category)" ///
			1 "Somewhat activated (Very or somewhat confident on Q16 and Q17)" /// 
			2 "Activated (Very confident on Q16 and Q17)" .r "Refused", replace
lab val patient_activation pa

/* DELETE
* usual_type
recode Q20 (12 14 15 16 = 0 "Public primary") (13 = 1 "Public Secondary") ///
		   (17 18 20 = 2 "Private primary") (19 21 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused"), gen(usual_type)
*/

* usual_reason
recode Q21 (2 = 1 "Convenience (short distance)") /// 
			(1 8 = 2 "Cost (low cost, covered by insurance)") ///
			(4 = 3 "Techincal quality (provider skills)") ///
			(3 5 = 4 "Interpersonal quality (short waiting time, respect)") ///
			(6 = 5 "Service readiness (medicines and equipment available)") ///
			(7 = 6 "Only facility available") ///
			(.r 9 = .r "Other or Refused") ///
			(.a = .a "NA") , gen(usual_reason)

* visits
gen visits = 0 if Q23 == 0 | Q24 == 0
recode visits (. = 1) if Q23 >=1 & Q23 <= 4 | Q24 == 1
recode visits (. = 2) if Q23 > 4 & Q23 < . | Q24 == 2 | Q24 == 3
recode visits (. = .r) if Q23 == .r | Q24 == .r
lab def visits 0 "Non-user (0 visits)" 1 "Occasional usuer (1-4 visits)" ///
			   2 "Frequent user (more than 4)"
lab val visits visits	

* visits_covid
gen visits_covid = Q25_B
recode visits_covid (.a = 1) if Q25_A == 1

*fac_number
* NOTE - what to do with people who say 0 or 1 for Q27? It's 24 people - for now put them in 0 group
gen fac_number = 0 if Q26 == 1 | Q27 == 0 | Q27 == 1
recode fac_number (. = 1) if Q27 == 2 | Q27 == 3
recode fac_number (. = 2) if Q23 > 3
recode fac_number (. = .a) if Q26 == .a | Q27 == .a
recode fac_number (. = .r) if Q26 == .r | Q27 == .r
lab def fn 0 "1 facility (Q26 is yes)" 1 "2-3 facilities (Q27 is 2 or 3)" ///
		   2 "More than 3 facilities (Q27 is 4 or more)" .a "NA" .r "Refused"
lab val fac_number fn

* visits_total
gen visits_total = Q23 + Q28_A + Q28_B
* something strange may be happening with Q28_A refuse - just changing them all to refuse for now
recode visits_total (. = .r) if Q23 == .d | Q23 == .r | Q28_A == .d | Q28_A == .r ///
								| Q28_B == .d | Q28_B == .r 
			
* systems_fail 
* NOTE - Todd, see if systems_fail code makes sense
gen system_fail = 1 if Q39 == 1 | Q40 == 1	   
recode system_fail (. = 0) if Q39 == 0 & Q40 == 0	
recode system_fail (. = .r) if Q39 == .r | Q40 == .r	      
recode system_fail (. = .a) (0 = .a) (1 = .a) if Q39 == .a | Q40 == .a	   
lab val system_fail yes_no_na

* unmet_reason 
recode Q42 (1 = 1 "Cost (High cost)") ///
			(2 = 2 "Convenience (Far distance)") ///
			(3 5 = 3 "Interpersonal quality (Long waiting time, Respect)") ///
			(4 = 4 "Technical quality (Poor provider skills)") ///
			(6 = 5 "Service readiness (Medicines and equipment not available)") ///
			(8 9 = 6 "COVID (COVID restritions or COVID fear)") ///
			(10 = 7 "Other") ///
			(.a 7 = .a "NA or Illness not serious") ///
			(.r = .r "Refused"), gen(unmet_reason)

/* DELETE			
* last_type 
recode Q44 (12 14 15 16 = 0 "Public primary") (13 = 1 "Public Secondary") ///
		   (17 18 20 = 2 "Private primary") (19 21 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused"), gen(last_type)
*/

* last_reason
gen last_reason = Q45
lab def lr 1 "Urgent or new problem" 2 "Follow-up for chronic disease" ///
		   3 "Preventative or health check" .a "NA" .r "Refused"
lab val last_reason lr

*last_wait_time
gen last_wait_time = 0 if Q46_min <= 15
recode last_wait_time (. = 1) if Q46_min >= 15 & Q46_min < 60
recode last_wait_time (. = 2) if Q46_min >= 60 & Q46_min < .
recode last_wait_time (. = .a) if Q46_min == .a
recode last_wait_time (. = .r) if Q46_min == .r
lab def lwt 0 "Short (15 minutes)" 1 "Moderate (< 1 hour)" 2 "Long (> 1 hour)" ///
			.r "Refused" .a "NA"
lab val last_wait_time lwt

*last_visit_time
gen last_visit_time = 0 if Q47_min <= 15
recode last_visit_time (. = 1) if Q47_min > 15 & Q47_min < .
recode last_visit_time (. = .a) if Q47_min == .a
recode last_visit_time (. = .r) if Q47_min == .r
lab def lvt 0 "<= 15 minutes" 1 "> 15 minutes " ///
			.r "Refused" .a "NA"
lab val last_visit_time lvt

* last_promote
gen last_promote = 0 if Q49 < 8
recode last_promote (. = 1) if Q49 == 8 | Q49 == 9 | Q49 == 10
recode last_promote (. = .a) if Q49 == .a
recode last_promote (. = .r) if Q49 == .r
lab def lp 0 "Detractor" 1 "Promoter" .r "Refused" .a "NA"
lab val last_promote lp

* system_outlook 
gen system_outlook = Q57
lab val system_outlook system_outlook

* system_reform 
gen system_reform = Q58
lab def sr 1 "Health system needs to be rebuilt" 2 "Health system needs major changes" /// 
		3 "Health system only needs minor chanes" .r "Refused", replace
lab val system_reform sr

**** Yes/No Questions ****

* insured, health_chronic, ever_covid, covid_confirmed, usual_source inpatient
* unmet_need 
* Yes/No/Refused -Q6 Q11 Q12 Q13 Q18 Q29 Q41 
gen insured = Q6 
gen health_chronic = Q11
gen ever_covid = Q12
gen covid_confirmed = Q13 
recode covid_confirmed (.a = 0) if ever_covid == 0
gen usual_source = Q18
gen inpatient = Q29 
gen unmet_need = Q41 
lab val insured health_chronic ever_covid covid_confirmed usual_source ///
		inpatient unmet_need yes_no

* blood_pressure mammogram cervical_cancer eyes_exam teeth_exam blood_sugar  
* blood_chol care_mental 
* Yes/No/Don't Know/Refused - Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q66 
gen blood_pressure = Q30 
gen mammogram = Q31
gen cervical_cancer = Q32
gen eyes_exam = Q33
gen teeth_exam = Q34
gen blood_sugar = Q35 
gen blood_chol = Q36
gen care_mental = Q38 
lab val blood_pressure mammogram cervical_cancer eyes_exam teeth_exam /// 
	blood_sugar blood_chol care_mental yes_no_dk
	
**** Excellent to Poor scales *****	   

* health, health_mental, last_qual, last_skills, last_supplies, last_respect, 
* last_explain, last_decision, last_visit_rate, last_wait_rate, vignette_poor,
* vignette_good

recode Q9 Q10 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H Q48_I Q60 Q61 /// 
	   (0 1 = 0 "Fair/Poor") (2 3 4 = 1 "Excellent/Very Good/Good") /// 
	   (.r = .r "Refused") (.a = .a NA), pre(der)label(exc_poor_der2)
	   	   
ren (derQ9 derQ10 derQ48_A derQ48_B derQ48_C derQ48_D derQ48_F derQ48_G derQ48_H /// 
	 derQ48_I derQ60 derQ61) (health health_mental last_qual last_skills /// 
	 last_supplies last_respect last_explain last_decisions ///
	 last_visit_rate last_wait_rate vignette_poor vignette_good)

* usual_quality,last_know, last_courtesy 

recode Q22 (0 1 = 0 "Fair/Poor") (2 3 4 = 1 "Excellent/Very Good/Good") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   pre(der)label(exc_pr_hlthcare_der)

recode Q48_E (0 1 = 0 "Fair/Poor") (2 3 4 = 1 "Excellent/Very Good/Good") (.r = .r "Refused") /// 
	   (.a = .a "I have not had prior visits or tests"), /// 
	   pre(der)label(exc_pr_visits_der)

recode Q48_J (0 1 = 0 "Fair/Poor") (2 3 4 = 1 "Excellent/Very Good/Good") (.r = .r "Refused") /// 
	   (.a = .a "The clinic had no other staff"), /// 
	   pre(der)label(exc_pr_staff_der)
	   
ren (derQ22 derQ48_E derQ48_J) (usual_quality last_know last_courtesy)

* qual_public qual_private qual_ngo covid_manage

recode Q54 Q55 Q56_KE Q56_PE Q56_UY Q59 /// 
	   (0 1 = 0 "Fair/Poor") (2 = 1 "Good") ( 3 4 = 2 "Excellent/Very Good") /// 
	   (.r = .r "Refused") (.a = .a NA), pre(der) label(exc_poor_der3)

ren (derQ54 derQ55 derQ56_KE derQ56_PE derQ56_UY derQ59) /// 
	(qual_public qual_private qual_ngo_ke qual_PE qual_UY  covid_manage)
* TODD - maybe fix these var names for PE and UY? 

* phc_women phc_child phc_chronic phc_mental

recode Q50_A Q50_B Q50_C Q50_D ///
	   (0 1 = 0 "Fair/Poor") (2 3 4 = 1 "Excellent/Very Good/Good") (.r = .r "Refused") /// 
	   (.d = .d "The clinic had no other staff"), /// 
	   pre(der) label(exc_pr_judge_der)

ren (derQ50_A derQ50_B derQ50_C derQ50_D) ///
	(phc_women phc_child phc_chronic phc_mental)

**** All Very Confident to Not at all Confident scales ****

* conf_sick conf_afford conf_opinion

recode Q51 Q52 Q53 ///
	   (3 = 1 "Very confident") ///
	   (0 1 2 = 0 "Somewhat confident/Not too confident/Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(der) label(vc_nc_der)

ren (derQ51 derQ52 derQ53) (conf_sick conf_afford conf_opinion)

**** COUNTRY SPECIFIC **** NK STOPPED HERE 
* urban: type of region respondent lives in 
recode Q4 (9 10 = 1 "urban") (11 = 0 "rural") (.r = .r "Refused") if Country==2, gen(urbanCO) //Colombia
recode Q4 (6 7 = 1 "urban") (8 = 0 "rural") (.r = .r "Refused") if Country==7, gen(urbanPE) //Peru
recode Q4 (12 13 = 1 "urban") (14 = 0 "rural") (.r = .r "Refused") if Country==10, gen(urbanUY) //Uruguay
egen urban = rowtotal(urbanCO urbanPE urbanUY) 

* insur_type 
* NOTE - I'm just putting Other as refused for now 
recode Q7 (15 16 17 18 = 0 public) (28 = 1 private) /// CO
		  (995 = .r "Refused") (.a = .a NA) if Country==2, gen(insur_typeCO)

recode Q7 (10 11 12 = 0 public) (13 = 1 private) /// PE
		  (995 = .r "Refused") (14 .a = .a NA) if Country==7, gen(insur_typePE)

recode Q7 (19 20 22 = 0 public) (21 = 1 private) /// UY
		  (995 = .r "Refused") (.a = .a NA) if Country==10, gen(insur_typeUY)
		  
egen insur_type = rowtotal(insur_typeCO insur_typePE insur_typeUY) 


* education 
recode Q8 (25 26 = 0 "None") (27 = 1 "Primary") (28 = 2 "Secondary") /// 
	      (29 30 31 = 3 "Post-secondary") if Country==2, gen(educationCO)
		  
recode Q8 (18 19 = 0 "None") (20 = 1 "Primary") (21 = 2 "Secondary") /// 
	      (22 23 24 = 3 "Post-secondary") if Country==7, gen(educationPE)
		  
recode Q8 (32 33 = 0 "None") (34 = 1 "Primary") (35 = 2 "Secondary") /// 
	      (36 37 38 = 3 "Post-secondary") if Country==10, gen(educationUY)
		  
egen education = rowtotal(educationCO educationPE educationUY) 

		  
* usual_type
recode Q20 (80 82 83 = 0 "Public primary") (81 84 = 1 "Public Secondary") ///
		   (85 87 88 = 2 "Private primary") (86 89 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==2, gen(usual_typeCO)
		   
recode Q20 (40 43 = 0 "Public primary") (41 42 44 = 1 "Public Secondary") ///
		   (45 46 47 48 = 2 "Private primary") (49 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==7, gen(usual_typePE)
		   
recode Q20 (92 94 = 0 "Public primary") (93 = 1 "Public Secondary") ///
		   (96 97 98 100 101 102 = 2 "Private primary") (99 103 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==10, gen(usual_typeUY)
		   
egen usual_type = rowtotal(usual_typeCO usual_typePE usual_typeUY) 

		   
* last_type 
recode Q44 (80 82 83 = 0 "Public primary") (81 84 = 1 "Public Secondary") ///
		   (85 87 88 = 2 "Private primary") (86 89 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==2, gen(last_typeCO)
		   
recode Q44 (40 43 = 0 "Public primary") (41 42 44 = 1 "Public Secondary") ///
		   (45 46 47 48 = 2 "Private primary") (49 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==7, gen(last_typePE)
		   
recode Q44 (92 94 = 0 "Public primary") (93 = 1 "Public Secondary") ///
		   (96 97 98 100 101 102 = 2 "Private primary") (99 103 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused") if Country==10, gen(last_typeUY)
		   
egen last_type = rowtotal(last_typeCO last_typePE last_typeUY) 


* income
recode Q63 (39 40 48 = 0 "Lowest income") (41 42 43 = 1 "Middle income") (44 45 = 2 "Highest income") ///
		   (.r = .r "Refused") if Country==2, gen(incomeCO)
		   
recode Q63 (31 32 38 = 0 "Lowest income") (33 34 35 = 1 "Middle income") (36 37 = 2 "Highest income") ///
		   (.r = .r "Refused") if Country==7, gen(incomePE)
		   
recode Q63 (49 50 61 = 0 "Lowest income") (51 52 53 = 1 "Middle income") (54 55 = 2 "Highest income") ///
		   (.r = .r "Refused") if Country==10, gen(incomeUY)
		   
egen income = rowtotal(incomeCO incomePE incomeUY) 
		 

* NRK just edited, has not run this 
order Respondent_Serial Respondent_ID ECS_ID PSU_ID InterviewerID_recoded Interviewer_Language Interviewer_Gender mode Country Language Date time_new IntLength int_length Q1_codes Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q7_other Q8 Q9 Q10 Q11 Q12 Q13 Q13B Q13E Q13E_10 Q14 Q15 Q16 Q17 Q18 Q19_KE Q19_CO Q19_PE Q19_UY Q19_other Q20 Q20_other Q21 Q21_other Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28_A Q28_B Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q42_other Q43_KE Q43_CO Q43_PE Q43_UY Q43_other Q44 Q44_other Q45 Q45_other Q46 Q46_min Q46_refused Q47 Q47_min Q47_refused Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56_KE Q56_PE Q56_UY Q57 Q58 Q59 Q60 Q61 Q62 Q62_other Q63 Q64 Q65 QC_short _v1 ///
age_calc age_cat female urban insured insur_type education health health_mental /// 
health_chronic ever_covid covid_confirmed covid_vax covid_vax_intent /// 
patient_activation usual_source usual_type usual_reason usual_quality visits ///
visits_covid fac_number visits_total inpatient blood_pressure mammogram ///
cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental ///
system_fail unmet_need unmet_reason last_type last_reason last_wait_time ///
last_visit_time last_qual last_skills last_supplies last_respect last_know ///
last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
last_promote phc_women phc_child phc_chronic ///
phc_mental conf_sick conf_afford conf_opinion qual_public /// 
qual_private qual_ngo system_outlook system_reform covid_manage vignette_poor /// 
vignette_good income

***************************** Labeling variables ***************************** 
 
lab var age_calc "Exact respondent age or middle number of age range"
lab var age_cat "Categorical age"
lab var female "Gender" 
lab var urban "Type of region respondent lives in"
lab var insured "Insurance status "
lab var insur_type "Type of insurance (for those who have insurance)" 
lab var education "Highest level of education completed "
lab var	health "Self-rated health"
lab var	health_mental "Self-rated mental health"
lab var	health_chronic "Longstanding illness or health problem (chronic illness)"
lab var	ever_covid "Ever had COVID-19 or coronavirus"
lab var	covid_confirmed	"COVID-19 or coronavirus confirmed by a COVID-19 test"
lab var	covid_vax "COVID-19 vaccination status"
lab var	covid_vax_intent "Intent to receive all recommended COVID-19 vaccine doses if available (if received < 2 doses)"
lab var	patient_activation "Patient activation - can manage overall health and tell a provider concerns even when they do not ask"
lab var	usual_source "Usual source of care"
lab var	usual_type "Facility type for usual source of care"
lab var	usual_reason "Main reason for choosing usual source of care facility"
lab var	usual_quality "Overall quality rating of usual source of care"
lab var	visits "Visits made in-person to a facility in past 12 months"
lab var	visits_covid "Number of reported visits made for COVID in-person to a facility in past 12 months"
lab var	fac_number "Number of facilities visited if had more than one visit during the past 12 months"
lab var	visits_total "Total number of healthcare contacts, including those made to a facility, home visits and telemedicine visits"
lab var	inpatient "Stayed overnight as a facility in past 12 months (inpatient care)"
lab var	blood_pressure "Blood pressure checked by healthcare provider in past 12 months"
lab var	mammogram "Mammogram done by healtchare provider in past 12 months"
lab var	cervical_cancer "Cervical cancer screening done by healthcare provider in past 12 months"
lab var	eyes_exam "Eyes checked by healthcare provider in past 12 months"
lab var	teeth_exam "Teeth checked by healthcare provider in past 12 months"
lab var	blood_sugar "Blood sugar tested by healthcare provider in past 12 months"
lab var	blood_chol "Blood cholesterol tested by healthcare provider in past 12 months"		
*lab var	hiv_test "HIV test done by healthcare provider in past 12 months"
lab var	care_mental	"Received care for depression, anxiety or another mental health condition"
lab var	system_fail	"Failed by the health system- medical mistake made or discriminated against by provider"	
lab var	unmet_need "Needed medical attention but did not get healthcare"
lab var	unmet_reason "Reason for not getting healthcare when needed medical attention"
lab var	last_type "Facility type for last visit to a healthcare provider"
lab var	last_reason	"Reason for last healthcare visit" 
lab var	last_wait_time "Length of time waited for last visit to a healthcare provider"
lab var	last_visit_time "Length of time spent with the provider during last healthcare visit"
lab var	last_qual "Last visit rating: overall quality"
lab var	last_skills "Last visit rating: knowledge and skills of provider (Care competence)"
lab var	last_supplies "Last visit rating: equipment and supplies provider had available"
lab var	last_respect "Last visit rating: provider respect"
lab var	last_know "Last visit rating: knowledge of prior tests and visits"
lab var	last_explain "Last visit rating: explained things in an understrandable way"
lab var	last_decisions "Last visit rating: involved you in decisions about your care"
lab var	last_visit_rate "Last visit rating: amount of time provider spent with you"
lab var	last_wait_rate "Last visit rating: amount of time you waited before being seen"
lab var	last_courtesy "Last visit rating: courtesy and helpfulness of the staff"
*lab var	last_comp_index "System competence composite index (average of X items)"
*lab var	last_user_index "User experience composite index (average of X items)"
lab var	last_promote "Net promoter score for facility visited for last visit to a healthcare provider"
lab var	phc_women "Public primary care system rating for: pregnant women"
lab var	phc_child "Public primary care system rating for: children"
lab var	phc_chronic "Public primary care system rating for: chronic conditions"
lab var	phc_mental "Public primary care system rating for: mental health"
*lab var	phc_index "Public primary care system composite index"
lab var	conf_sick "Confidence in receiving good quality healthcare if became very sick"
lab var	conf_afford	"Confidence in ability to afford care healthcare if became very sick"
lab var	conf_opinion "Confidence that the government considers public's opinion when making decisions about the healthcare system"
lab var	qual_public	"Overall quality ratiing of government or public healthcare system in country"
lab var	qual_private "Overall quality rating of private healthcare system in country"
lab var	qual_ngo "Overall quality rating of NGO/faith-based healthcare system in country"	
lab var	system_outlook "Opinion on whether heatlh system is getting better, staying the same, or getting worse"
lab var	system_reform "Opinion on whether health system needs major changes, major changes, or must be completely rebuilt" 
lab var	covid_manage "Respondent's rating the government's management of the COVID-19 pandemic" 
lab var	vignette_poor "Rating of vignette in Q60 (poor care)"
lab var	vignette_good "Rating of vignette in Q61 (good care)"
*lab var	language "Native language"
lab var	income "Income group"

**************************** Save data *****************************


