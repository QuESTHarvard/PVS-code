* PVS Additional Cleaning for analyses 
* September 2022
* N. Kapoor & R. B. Lobato
* Note to Todd: Eventually this file might be combined with cr01  TL: LET'S PLEASE COMBINE

* u "$data_mc/00 interim data/pvs_et_ke_01.dta", clear 
u "$data/Kenya/00 interim data/pvs_ke_01.dta", clear 


****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Recode value labels *****************************
 * Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 /// 
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

recode Q9 Q10 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H Q48_I Q54 Q55 Q56 Q59 Q60 Q61 ///
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
	   
recode Q16 Q17 Q51 Q52 Q53 ///
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

* TODD Not sure why there is an error here? It works sometimes but not other times

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
drop Interviewer_Gender Q2 Q3 Q6 Q11 Q12 Q13 Q18 Q25_A Q26 Q29 Q41 Q30 Q31 Q32 Q33 Q34 Q35 Q36 ///
	Q38 Q66 Q39 Q40 Q9 Q10 Q22 Q48_A Q48_B Q48_C Q48_D Q48_F Q48_G Q48_H ///
	Q48_I Q54 Q55 Q56 Q59 Q60 Q61 Q48_E Q48_J Q50_A Q50_B Q50_C Q50_D Q16 ///
	Q17 Q51 Q52 Q53 Q3 Q14_NEW Q15 Q24 Q49 Q57

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
ren Q66 Q64
ren Q67 Q65

* Q37_B not currently in these data 

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
lab var Q11 "Q11. Do you have any longstanding illness or health problem?"
lab var Q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var Q13 "Q13. Was it confirmed by a test?"
lab var Q14 "Q14. How many doses of a COVID-19 vaccine have you received, or have you not"
lab var Q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
lab var Q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var Q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var Q18 "Q18. Is there one healthcare facility or provider's group you usually go to?"
lab var Q19 "Q19. Is this a public, private, or NGO/faith-based healthcare facility?"
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
lab var Q43 "Q43. Last healthcare visit in a public, private, or NGO/faith-based facility?"
lab var Q43_other "Other"
lab var Q44 "Q44. What type of healthcare facility is this?"
lab var Q44_other "Q44. Other"
lab var Q45 "Q45. What was the main reason you went?"
lab var Q45_other "Q45. Other"
lab var Q46_refused "Q46. Refused"
lab var Q46 "Q46. Approximately how long did you wait before seeing the provider?"
lab var Q47_refused "Q47. Refused"
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
lab var Q62_other "Q62. Other"
lab var Q63 "Q63. Total monthly household income"
lab var Q64 "Q64. Do you have another mobile phone number besides the one I am calling you on?"
lab var Q65 "Q65. How many other mobile phone numbers do you have?"


* Note for NK: Will have to figure out what to do with Other, specify data 

***************************** Save data *****************************

save "$data/Kenya/00 interim data/pvs_ke_02.dta", replace

***************************** Deriving variables *****************************

u "$data/Kenya/00 interim data/pvs_ke_02.dta", clear

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

* urban: type of region respondent lives in 
recode Q4 (6 7 = 1 "urban") (8 = 0 "rural") (.r = .r "Refused"), gen(urban)

* insur_type 
* NOTE - I'm just putting Other as refused for now 
recode Q7 (3 = 0 public) (4 5 6 = 1 private) /// 
		  (995 = .r "Refused") (.a = .a NA), gen(insur_type)

* education 
recode Q8 (7 = 0 "None") (8 = 1 "Primary") (9 10 = 2 "Secondary") /// 
	      (11 = 3 "Post-secondary"), gen(education)

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

* usual_type
recode Q20 (12 14 15 16 = 0 "Public primary") (13 = 1 "Public Secondary") ///
		   (17 18 20 = 2 "Private primary") (19 21 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused"), gen(usual_type)

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

			
* last_type 
recode Q44 (12 14 15 16 = 0 "Public primary") (13 = 1 "Public Secondary") ///
		   (17 18 20 = 2 "Private primary") (19 21 = 3 "Private secondary") ///
		   (.a = .a "NA") (.r = .r "Refused"), gen(last_type)

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

* income
recode Q63 (1 2 = 0 "Lowest income") (3 4 5 = 1 "Middle income") (6 7 = 2 "Highest income") ///
		   (.r = .r "Refused"), gen(income)


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

recode Q54 Q55 Q56 Q59 /// 
	   (0 1 = 0 "Fair/Poor") (2 = 1 "Good") ( 3 4 = 2 "Excellent/Very Good") /// 
	   (.r = .r "Refused") (.a = .a NA), pre(der) label(exc_poor_der3)

ren (derQ54 derQ55 derQ56 derQ59) (qual_public qual_private qual_ngo covid_manage)

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

order Q* /// 
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
vignette_good income, after(Interviewer_Gender)

***************************** Labeling variables ***************************** 
 
lab var age_calc "Exact respondent age or middle number of age range"
lab var age_cat "Categorical age"

**************************** Save data *****************************

save "$data/Kenya/00 interim data/pvs_ke_03.dta", replace

