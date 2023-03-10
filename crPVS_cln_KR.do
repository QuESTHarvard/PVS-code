* People's Voice Survey data cleaning for South Korea
* Last updated: March 2023
* Neena Kapoor, Hwa-Young Lee

************************************* South Korea ************************************

* Import data 
use "$data/South Korea/raw data/PVS_SK_raw.dta", clear


* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped*

* NOTE: q4 and q5 are switched
ren Q4 q5
ren Q5 q4
* NOTE: Q55 is all missing, I think it may be Q56 may be Q55

rename *, lower 
ren idx respondent_serial
ren time_diff time
* Note: need to fix this time var. Is it interview length? 
* Is there no date var? 

* Note: no interview_id because all online

* CAWI (web interface) is 3 in mode
ren q6 q6_kr 
ren q7 q7_kr
ren q19 q19_kr
* maybe combine with PE/CO? 
ren tq21_8 q21_other 
ren tq19_4 q19_other
ren q25a q25_a
ren q25b q25_b
ren q28a q28_a
ren q28b q28_b
ren q28c q28_c
ren tq42_10 q42_other
ren q43 q43_kr
ren tq43_4 q43_other
ren tq45_4 q45_other 
ren q46a q46a // check this - remove underscore or keep? 
* combine all q46b like in US/IT/MX, check this 
recode q46b_1 q46b_2 q46b_3 (. = 0) if q46b_1 < . | q46b_2 < . |q46b_3< .
gen q46b = (q46b_1/24) + q46b_2 + (q46b_3*7)								
recode q47_1 q47_2 (. = 0) if q47_1 < . | q47_2 < . 
gen q47 = q47_1*60 + q47_2
recode q46c_1 q46c_2 (. = 0) if q46c_1 < . | q46c_2 < . 
gen q46 = q46c_1*60 + q46c_2
* no q46/q47 refused 
ren q48_1 q48_a
ren q48_2 q48_b
ren q48_3 q48_c
ren q48_4 q48_d
ren q48_5 q48_e
ren q48_6 q48_f
ren q48_7 q48_g
ren q48_8 q48_h
ren q48_9 q48_i
ren q48_10 q48_j
ren q48_11 q48_k
ren q50_1 q50_a
ren q50_2 q50_b
ren q50_3 q50_c
ren q50_4 q50_d
* change q56 in other data 

*------------------------------------------------------------------------------*

* Drop unused or other variables 
drop agree q0 q6a qa qa_5 qb qc qd qe qf p0 q46b_1 q46b_2 q46b_3 q47_1 q47_2 ///
     q46c_1 q46c_2
	 
	 
*------------------------------------------------------------------------------*

* Recode refused and don't know values 
* In raw data, 995 = "don't know" 
recode q23 q25_a q25_b q27 q28_a q28_b q30 q31 q32 q33 q34 q35 q36 q38 q62 q63 ///
	   (995 = .d)

* In raw data, 996 = "refused" 	  
recode q1 q2 q3 q4 q5 q6_kr q7_kr q8 q9 q10 q11 q12 ///
	   q13 q14 q15 q16 q17 q18 q19_kr q20 q21 q22 ///
	   q23 q24 q25_a q25_b q26 q27 q28_a q28_b q28_c q29 q30 q31 q32 q33 ///
	   q34 q35 q36 q38 q39 q40 q41 q42 q43_kr q44 ///
	   q45 q48_a q48_b q48_c q48_d q48_e q48_f q48_g /// 
	   q48_h q48_i q48_j q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
	   q57 q58 q59 q60 q61 q62 q63 q66 (996 = .r)	
* add back q23_q24
* what about q46* q47* ?

*------------------------------------------------------------------------------*

* Generate variables
gen respondent_id = "KR" + string(respondent_serial)
gen country=15
lab def country 15 "Republic of Korea" 
lab val country country
gen mode=3
lab def mode 3 "CAWI"
lab val mode mode
gen language=1501
lab define lang 1501 "Korean" 
lab val language lang

* Country-specific values 
gen recq4 = country*1000 + q4
gen recq5 = country*1000 + q5 
gen recq8 = country*1000 + q8 
gen recq20 = country*1000 + q20 
gen recq44 = country*1000 + q44 
gen recq62 = country*1000 + q62 
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== .r
gen recq66 = country*1000 + q66
replace recq66 = .r if q66== .r

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (.r = 0) (.d = 0) if q24 == 1
recode q23_q24 (.r = 2.5) (.d = 2.5) if q24 == 2
recode q23_q24 (.r = 7) (.d = 7) if q24 == 3
recode q23_q24 (.r = 10) (.d = 10) if q24 == 4
recode q23_q24 (.d = .r) if q24 == .r 

*------------------------------------------------------------------------------*

* Value labels 

lab def q19_43 1 "KR: Public" 2 "KR: Private (for profit)" ///
			   3 "KR: Private (non-profit organization/religion related)" ///
			   4 "KR: Other" .a "NA" .r "Refused"
			   			   
lab	val q19_kr q43_kr q19_43

lab def q20_44 15001 "KR: Health center" 15002 "KR: Clinic" 15003 "KR: Hospital or secondary hospital" ///
			   15004 "KR: Tertiary general hospital" .a "NA" .r "Refused"
lab	val recq20 recq44 q20_44

lab def q62 15001 "KR: Korean"  15002 "KR: Other" .r "Refused"
lab val recq62 q62

lab def q63 15001 "KR: <50(10,000KW)" 15002 "KR:≥50 and <100(10,000KW)" ///
				 15003 "KR: ≥100 and <200(10,000KW)" 15004 "KR: ≥200 and <300(10,000KW)" ///
				 15005 "KR: ≥300 and <400(10,000KW)" 15006 "KR: ≥400 and <500(10,000KW)" ///
				 15007 "KR: ≥500 and <600(10,000KW)" 15008 "KR: ≥600(10,000KW)"  ///
				 .r"Refused"
lab val recq63 q63

* q4, q5, q6_kr, q7_kr, q8, 
*q21, q42, q45, q49, q58, q66 

*------------------------------------------------------------------------------*
* Check for other implausible values 


*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

* Recode missing values to NA for intentionally skipped questions

*q1/q2 - value for all q2 

*q6/q7 asked to all 

* q13 
recode q13 (. = .a) if q12 == 2 | q12 == .r 

* q15
recode q15 (. = .a) if inrange(q14,3,5) | q14 == .r 

*q19-22
recode q19_kr recq20 q21 q22 (. = .a) if q18 == 2 | q18 == .r 
recode recq20 (. = .a) if q19_kr == 4 | q19_kr == .r

* NA's for q24-28 
recode q24 (. = .a) if q23 != .d | q23 != .r | q23 != . 
recode q25_a (. = .a) if q23 != 1
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r 
recode q28_c (. = .a) if q28_b == 0 | q28_b == .d | q28_b == .r 


* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r
recode q32 (. = .a) if q3 != 2 | q1 == .r | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43_kr recq44 q45 q46 q46a q46b q47 q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q48_k q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r
recode q48_k (. = .a) if q46a == 2

recode recq44 (. = .a) if q43_kr == 4 | q43_kr == .r
recode q46b (. = .a) if q46a == 2 | q46a == .r 


*------------------------------------------------------------------------------*
* Recode value labels:
* Recode values and value labels so that their values and direction make sense


* All Yes/No questions

recode q11 q12 q13 q18 q25_a q26 q29 q41 q46a /// 
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)
	   
recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)

* All Excellent to Poor scales

recode q9 q10 q28_c q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k q54 q55 q56 q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)

* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)

* Miscellaneous questions with unique answer options

* Note: Without relabeling (removing the appostrophe) next command will not run 
recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)

* Numeric questions needing NA and Refused value labels 
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b q46 q46b q47 na_rf

*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents

drop q4 q5 q8 q20 q44 q62 q63 q66 q11 q12 q18 q13 q25_a q26 q29 q41 q30 q31 ///
	 q32 q33 q34 q35 q36 q38 q39 q40 q46a q9 q10 q28_c q48_a q48_b q48_c q48_d ///
	 q48_f q48_g q48_h q48_i q48_k q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a q50_b ///
	 q50_c q50_d q16 q17 q51 q52 q53 q2 q3 q14 q15 q24 q56 q57

ren rec* *
 
*Reorder variables
order q*, sequential
order q*, after(language) 

*------------------------------------------------------------------------------*
* Label variables 

lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6_kr "Q6. KR only: What is the type of your health coverage?"
lab var q7_kr "Q7. KR only: Do you have private health insurance in addition to national...?"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"
lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var q19_kr "Q19. KR only: Is this...public, private, or non-profit/religious medical...?"
lab var q19_other "Q19. Other"
lab var q20 "Q20. What type of healthcare facility is this?"
* lab var q20_other "Q20. Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19?"
lab var q28_c "Q28_C. How would you rate the overall quality of your last telemedicine visit?"
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43_kr "Q43. KR only: Is this...public, private, or non-profit/religious medical...?"
lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
*lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
*lab var q46_refused "Q46. Refused"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q46a "Q46A Was this a scheduled visit or did you go without an appt.?"
lab var q46b "Q46B In days: how long between scheduling and seeing provider?"
*lab var q47_refused "Q47. Refused"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q48_a "Q48_A. How would you rate the overall quality of care you received?"
lab var q48_b "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var q48_c "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var q48_d "Q48_D. How would you rate the level of respect your provider showed you?"
lab var q48_e "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var q48_f "Q48_F. How would you rate whether your provider explained things clearly?"
lab var q48_g "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var q48_h "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var q48_i "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var q48_j "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private for-profit healthcare?"
lab var q56 "Q56. How would you rate the quality of the NGO or faith-based healthcare?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62 "Q62. Respondent's mother tongue or native language"
*lab var q62_other "Q62. Other"
lab var q63 "Q63. Total monthly household income"
lab var q66 "Q66. Which political party did you vote for in the last election?"
