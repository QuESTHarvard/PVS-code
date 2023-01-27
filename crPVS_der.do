* People's Voice Survey derived variable creation
* Date of last update: Jan 4, 2023
* Last updated by: T Lewis

/*

This file loads creates derived variables for analysis from the multi-country 
dataset created in the cr01_pvs_clin.do file. 

*/

***************************** Deriving variables *******************************

u "$data_mc/02 recoded data/pvs_appended.dta", clear

*------------------------------------------------------------------------------*

* age: exact respondent age or middle of age range 
gen age = q1 
recode age (.r = 23.5) if q2 == 0
recode age (.r = 34.5) if q2 == 1
recode age (.r = 44.5) if q2 == 2
recode age (.r = 54.5) if q2 == 3
recode age (.r = 64.5) if q2 == 4
recode age (.r = 74.5) if q2 == 5
recode age (.r = 80) if q2 == 6
lab def ref .r "Refused"
lab val age ref

* age_cat: categorical age 
gen age_cat = q2
recode age_cat (.a = 0) if q1 >= 18 & q1 <= 29
recode age_cat (.a = 1) if q1 >= 30 & q1 <= 39
recode age_cat (.a = 2) if q1 >= 40 & q1 <= 49
recode age_cat (.a = 3) if q1 >= 50 & q1 <= 59
recode age_cat (.a = 4) if q1 >= 60 & q1 <= 69
recode age_cat (.a = 5) if q1 >= 70 & q1 <= 79
recode age_cat (.a = 6) if q1 >= 80
lab val age_cat age_cat

* female: gender 	   
gen gender = q3
lab val gender gender

* covid_vax
recode q14 ///
	(0 = 0 "Unvaccinated (0 doses)") (1 = 1 "Partial vaccination (1 dose)") /// 
	(2 3 4 = 2 "Fully vaccinated (2+ doses)") (.r = .r Refused) (.a = .a NA), ///
	gen(covid_vax)
	
* covid_vax_intent 
gen covid_vax_intent = q15 
lab val covid_vax_intent yes_no_doses
* Note: In Laos, q15 was only asked to those who said 0 doses 

* region
gen region = q5
lab val region labels7

* patient_activiation
gen patient_activation = 1 if q16 == 3 & q17 == 3
recode patient_activation (. = 1) if q16 == 3 & q17 == .r | q16 == .r & q17 == 3 
recode patient_activation (. = 0) if q16 < 3 | q17 < 3 
recode patient_activation (. = .r) if q16 == .r & q17 == .r
lab def pa 0 "Not activated" ///
			1 "Activated (Very confident on Q16 and Q17)" ///
			.r "Refused", replace
lab val patient_activation pa

* usual_reason
recode q21 (2 = 1 "Convenience (short distance)") /// 
			(1 8 = 2 "Cost (low cost, covered by insurance)") ///
			(4 = 3 "Techincal quality (provider skills)") ///
			(3 5 = 4 "Interpersonal quality (short waiting time, respect)") ///
			(6 = 5 "Service readiness (medicines and equipment available)") ///
			(7 = 6 "Only facility available") ///
			(.r 9 = .r "Other or Refused") ///
			(.a = .a "NA") , gen(usual_reason)

* visits
gen visits = q23_q24

* visits_cat
gen visits_cat = 0 if q23 == 0 | q24 == 0
recode visits_cat (. = 1) if q23 >=1 & q23 <= 4 | q24 == 1
recode visits_cat (. = 2) if q23 > 4 & q23 < . | q24 == 2 | q24 == 3
recode visits_cat (. = .r) if q23 == .r | q24 == .r
lab def visits_cat 0 "Non-user (0 visits)" 1 "Occasional usuer (1-4 visits)" ///
			   2 "Frequent user (more than 4)" .r "Refused"
lab val visits_cat visits_cat

* visits_covid
gen visits_covid = q25_b
recode visits_covid (.a = 1) if q25_a == 1
recode visits_covid (.a = 0) if q25_a == 0

*fac_number
* Note: recoded 0's and 1's in q27 during cleaning 
gen fac_number = 1 if q26 == 1 
recode fac_number (. = 2) if q27 == 2 | q27 == 3
recode fac_number (. = 3) if q27 > 3 & q27 < . 
recode fac_number (. = .a) if q26 == .a & q27 == .a
recode fac_number (. = .d) if q27 == .d
recode fac_number (. = .r) if q26 == .r | q27 == .r
lab def fn 1 "1 facility (Q26 is yes)" 2 "2-3 facilities (Q27 is 2 or 3)" ///
		   3 "More than 3 facilities (Q27 is 4 or more)" .a "NA" .r "Refused" ///
		   .d "Don't know"
lab val fac_number fn 

* visits_total
egen visits_total = rowtotal(q23_q24 q28_a q28_b)

* value label for all numeric var
lab val visits visits_covid visits_total na_rf

* unmet_reason 
recode q42 (1 = 1 "Cost (High cost)") ///
			(2 = 2 "Convenience (Far distance)") ///
			(3 5 = 3 "Interpersonal quality (Long waiting time, Respect)") ///
			(4 = 4 "Technical quality (Poor provider skills)") ///
			(6 = 5 "Service readiness (Medicines and equipment not available)") ///
			(8 9 = 6 "COVID (COVID restritions or COVID fear)") ///
			(10 = 7 "Other") ///
			(.a 7 = .a "NA or Illness not serious") ///
			(.r = .r "Refused"), gen(unmet_reason)

* last_reason
gen last_reason = q45
lab def lr 1 "Urgent or new problem" 2 "Follow-up for chronic disease" ///
		   3 "Preventative or health check" 995 "Other" .a "NA" .r "Refused"
lab val last_reason lr

*last_wait_time
gen last_wait_time = 0 if q46_min <= 15
recode last_wait_time (. = 1) if q46_min >= 15 & q46_min < 60
recode last_wait_time (. = 2) if q46_min >= 60 & q46_min < .
recode last_wait_time (. = .a) if q46_min == .a
recode last_wait_time (. = .r) if q46_min == .r
lab def lwt 0 "Short (15 minutes)" 1 "Moderate (< 1 hour)" 2 "Long (> 1 hour)" ///
			.r "Refused" .a "NA"
lab val last_wait_time lwt

*last_visit_time
gen last_visit_time = 0 if q47_min <= 15
recode last_visit_time (. = 1) if q47_min > 15 & q47_min < .
recode last_visit_time (. = .a) if q47_min == .a
recode last_visit_time (. = .r) if q47_min == .r
lab def lvt 0 "<= 15 minutes" 1 "> 15 minutes " ///
			.r "Refused" .a "NA"
lab val last_visit_time lvt

* last_promote
gen last_promote = 0 if q49 < 8
recode last_promote (. = 1) if q49 == 8 | q49 == 9 | q49 == 10
recode last_promote (. = .a) if q49 == .a
recode last_promote (. = .r) if q49 == .r
lab def lp 0 "Detractor" 1 "Promoter" .r "Refused" .a "NA"
lab val last_promote lp

* system_outlook 
gen system_outlook = q57
lab val system_outlook system_outlook

* system_reform 
gen system_reform = q58
lab def sr 1 "Health system needs to be rebuilt" 2 "Health system needs major changes" /// 
		3 "Health system only needs minor chanes" .r "Refused", replace
lab val system_reform sr

**** Yes/No Questions ****

* insured, health_chronic, ever_covid, covid_confirmed, usual_source, inpatient
* unmet_need 
* Yes/No/Refused -Q6 Q11 Q12 Q13 Q18 Q29 Q41 

gen insured = q6 
recode insured (.a = 0) if q7 == 14
recode insured (.a = 1) if q7 == 10 | q7 == 11 | q7 == 12 | q7 == 13 | ///
						q7 == 15 | q7 == 16 | q7 == 17 | q7 == 18 | q7 == 19 | ///
						q7 == 20 | q7 == 21 | q7 == 22 | q7 == 28 | q7 == 29 | ///
						q7 == 30
recode insured (.a = .r) if q7 == .r | q7 == 995 | q7 == .

gen health_chronic = q11
gen ever_covid = q12
gen covid_confirmed = q13 
gen usual_source = q18
recode usual_source (.a = 1) if q18a_la == 1 & q19_q20a_la == 1 | q18a_la == 1 & q19_q20a_la == 2 | ///
							   q18a_la == 1 & q19_q20a_la == 3 | q18a_la == 1 & q19_q20a_la == 4 | ///
							   q18a_la == 1 & q19_q20a_la == 6 | q18b_la == 1
recode usual_source (.a = 0) if q18a_la == 0 | q18a_la == 1 & q18b_la == 0

* NOTE: check Laos addition 

gen inpatient = q29 
gen unmet_need = q41 
lab val insured health_chronic ever_covid covid_confirmed usual_source ///
		inpatient unmet_need yes_no	
* blood_pressure mammogram cervical_cancer eyes_exam teeth_exam blood_sugar  
* blood_chol care_mental 
* Yes/No/Don't Know/Refused - Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q30 Q40 Q66 
gen blood_pressure = q30 
gen mammogram = q31
gen cervical_cancer = q32
gen eyes_exam = q33
gen teeth_exam = q34
gen blood_sugar = q35 
gen blood_chol = q36
gen care_mental = q38 
gen mistake = q39
gen discrim = q40
lab val blood_pressure mammogram cervical_cancer eyes_exam teeth_exam /// 
	blood_sugar blood_chol care_mental mistake discrim yes_no_dk
	
**** Excellent to Poor scales *****	   

gen health = q9 
gen health_mental = q10 
gen last_qual = q48_a 
gen last_skills = q48_b 
gen last_supplies = q48_c 
gen last_respect = q48_d 
gen last_explain = q48_f 
gen last_decisions = q48_g
gen last_visit_rate = q48_h 
gen last_wait_rate = q48_i 
gen vignette_poor = q60
gen vignette_good = q61
lab val health health_mental last_qual last_skills last_supplies last_respect /// 
last_explain last_decisions last_visit_rate last_wait_rate vignette_poor /// 
vignette_good exc_poor
	   
gen usual_quality =q22
gen last_know = q48_e
gen last_courtesy = q48_j
lab val usual_quality exc_pr_hlthcare
lab val last_know exc_pr_visits
lab val last_courtesy exc_poor_staff

gen phc_women = q50_a
gen phc_child = q50_b
gen phc_chronic = q50_c
gen phc_mental = q50_d
lab val phc_women phc_child phc_chronic phc_mental exc_poor_judge
	
gen qual_public = q54
gen qual_private = q55 
gen qual_ngo_et_ke_za = q56_et_ke_za
gen qual_ss_pe = q56_pe
gen qual_mut_uy = q56_uy
gen covid_manage = q59
lab val qual_public qual_private qual_ngo_et_ke_za qual_ss_pe qual_mut_uy covid_manage exc_poor

**** All Very Confident to Not at all Confident scales ****

* conf_sick conf_afford conf_opinion

recode q51 q52 q53 ///
	   (3 = 1 "Very confident") ///
	   (0 1 2 = 0 "Somewhat confident/Not too confident/Not at all confident") /// 
	   (.r = .r refused) (.a = .a na), /// 
	   pre(der) label(vc_nc_der)

ren (derq51 derq52 derq53) (conf_sick conf_afford conf_opinion)

**** COUNTRY SPECIFIC ****
* NK NOTE: Only updated SA for urban, education, and wealth 

* urban: type of region respondent lives in 
recode q4 (1 2 3 6 7 9 10 12 13 18 20 = 1 "Urban") (4 8 11 14 19 = 0 "Rural") ///
		  (.r = .r "Refused"), gen(urban)

* insur_type 
* NOTE: check other, specify later

recode q7 (1 3 15 16 17 18 10 11 12 19 20 22 29 = 0 Public) (2 4 5 6 7 28 13 21 30 = 1 Private) /// 
		  (995 = 3 Other) ///
		  (.r = .r "Refused") (14 .a = .a NA), gen(insur_type)


* education 
recode q8 (1 2 7 12 13 25 26 18 19 32 33 45 = 0 "None") /// 
		  (3 8 14 15 27 20 34 46 = 1 "Primary") (4 9 16 28 21 35 47 48 = 2 "Secondary") /// 
	      (5 10 11 17 29 30 31 22 23 24 36 37 38 49 50 = 3 "Post-secondary") ///
		  (.r = .r "Refused"), gen(education)

* usual_type_own
		  
recode q19_et_ke_za (1 = 0 Public) (2 3 = 1 Private) (4 = 2 other) /// 
		(.a = .a NA) (.r = .r Refused), ///
		gen(usual_type_own)
recode usual_type_own (.a = 0) if q19_co == 1 | q19_pe == 1 | q19_uy == 1 | q19_uy == 5 | ///
								  q19_q20a_la == 1 | q19_q20a_la == 2 | q19_q20b_la == 1 | q19_q20b_la == 2
recode usual_type_own (.a = 1) if q19_co == 2 | q19_pe == 2 | q19_uy == 2 | q19_q20a_la == 1 | ///
								  q19_q20a_la == 3 | q19_q20a_la == 4 | q19_q20b_la == 3 | q19_q20b_la == 4 | ///
								  q19_q20a_la == 6 | q19_q20b_la == 6
recode usual_type_own (.a = 2) if q19_uy == 3 | q19_uy == 995 | q19_q20a_la == 9 | q19_q20b_la == 7
recode usual_type_own (.a = .r) if q19_co == .r | q19_pe == .r | q19_uy == .r 

* usual_type_lvl 

recode q20 (1 2 3 6 7 8 11 23 12 14 15 17 18 20 80 85 90 40 43 45 47 48 92 94 96 98 100 102 104 = 0 "Primary") /// 
		   (4 5 9 13 19 21 81 82 86 87 41 42 44 46 49 93 97 101 103 105 = 1 "Secondary (or higher)") ///
		   (.a = .a "NA") (995 .r = .r "Refused"), gen(usual_type_lvl)

recode usual_type_lvl (.a = 0) if q19_q20a_la == 2 | q19_q20a_la == 4 | q19_q20a_la == 6 | ///
								 q19_q20b_la == 2 | q19_q20b_la == 4 | q19_q20b_la == 6
recode usual_type_lvl (.a = 1) if q19_q20a_la == 1 | q19_q20a_la == 3 | q19_q20b_la == 1 | q19_q20b_la == 3


* NOTE: Maybe add an other for Laos? also for last visit level? But we will see with other, specify data

		   
* usual_type_own_lvl
gen usual_type_own_lvl = . 
recode usual_type_own_lvl (. = 0) if usual_type_own == 0 & usual_type_lvl == 0
recode usual_type_own_lvl (. = 1) if usual_type_own == 0 & usual_type_lvl == 1
recode usual_type_own_lvl (. = 2) if usual_type_own == 1 & usual_type_lvl == 0
recode usual_type_own_lvl (. = 3) if usual_type_own == 1 & usual_type_lvl == 1
recode usual_type_own_lvl (. = 4) if usual_type_own == 2 & usual_type_lvl == 0
recode usual_type_own_lvl (. = 5) if usual_type_own == 2 & usual_type_lvl == 1
recode usual_type_own_lvl (. = .a) if usual_type_own == .a | usual_type_lvl == .a
recode usual_type_own_lvl (. = .r) if usual_type_own == .r | usual_type_lvl == .r
lab def fac_own_lvl 0 "Public primary" 1 "Public secondary (or higher)" 2 "Private primary" /// 
					3 "Private secondary (or higher)" 4 "Other primary" 5 "Other secondary (or higher)" ///
					.a NA .r Refused, replace
lab val usual_type_own_lvl fac_own_lvl


* last_type_own
recode q43_et_ke_za (1 = 0 Public) (2 3 = 1 Private) (4 = 2 other) /// 
		(.a = .a NA) (.r = .r Refused), ///
		gen(last_type_own)
recode last_type_own (.a = 0) if q43_co == 1 | q43_pe == 1 | q43_uy == 1 | q43_uy == 5 | q43_la == 1
recode last_type_own (.a = 1) if q43_co == 2 | q43_pe == 2 | q43_uy == 2 | q43_la == 2 | q43_la == 3
recode last_type_own (.a = 2) if q43_uy == 3 | q43_uy == 995
recode last_type_own (.a = .r) if q43_co == .r | q43_pe == .r | q43_uy == .r 

* last_type_lvl 
recode q44 (1 2 6 7 11 23 12 14 15 17 18 20 80 85 90 40 43 45 47 48 92 94 96 98 100 102 104 = 0 "Primary") /// 
		   (3 4 5 8 9 13 19 21 81 82 86 87 41 42 44 46 49 93 97 101 103 105 = 1 "Secondary (or higher)") ///
		   (.a = .a "NA") (995 .r = .r "Refused"), gen(last_type_lvl)
recode last_type_lvl (.a = 0) if q44_la == 2 | q44_la == 3
recode last_type_lvl (.a = 1) if q44_la == 1 
recode last_type_lvl (. = .a) if q44_la == .a

* last_type_own_lvl
gen last_type_own_lvl = . 
recode last_type_own_lvl (. = 0) if last_type_own == 0 & last_type_lvl == 0
recode last_type_own_lvl (. = 1) if last_type_own == 0 & last_type_lvl == 1
recode last_type_own_lvl (. = 2) if last_type_own == 1 & last_type_lvl == 0
recode last_type_own_lvl (. = 3) if last_type_own == 1 & last_type_lvl == 1
recode last_type_own_lvl (. = 4) if last_type_own == 2 & last_type_lvl == 0
recode last_type_own_lvl (. = 5) if last_type_own == 2 & last_type_lvl == 1
recode last_type_own_lvl (. = .a) if last_type_own == .a | last_type_lvl == .a
recode last_type_own_lvl (. = .r) if last_type_own == .r | last_type_lvl == .r
lab def fac_own_lvl 0 "Public primary" 1 "Public secondary (or higher)" 2 "Private primary" /// 
					3 "Private secondary (or higher)" 4 "Other primary" 5 "Other secondary (or higher)" ///
					.a NA .r Refused, replace
lab val last_type_own_lvl fac_own_lvl

* native language
recode q62 (1 5 8 9 10 11 12 13 14 15 23 24 25 26 27 28 29 30 31 32 ///
			44 45 49 81 102 103 = 0 "Minority group languages") /// 
		   (2 3 4 6 7 21 22 53 87 101 = 1 "Majority group languages") /// 
		   (995 998 104 = 2 "Other") ///
		   (.r = .r "Refused") (.a = .a "NA"), gen(native_lang)

* income
recode q63 (1 2 9 10 15 16 17 23 39 40 48 31 32 38 49 50 61 101 102 = 0 "Lowest income") /// 
		   (3 4 5 11 12 18 19 20 41 42 43 33 34 35 51 52 53 103 104 105 = 1 "Middle income") /// 
		   (6 7 13 14 21 22 44 45 36 37 54 55 106 107 = 2 "Highest income") ///
		   (.r = .r "Refused") (.d = .d "Don't know"), gen(income)
		  


* NOTE: Ignored country-specific questions Q13B and Q13E

		   
**** Order Variables ****
		   
order respondent_serial respondent_id mode country language date time /// 
	  int_length weight age age_cat gender urban region ///
	  insured insur_type education health health_mental health_chronic ///
	  ever_covid covid_confirmed covid_vax covid_vax_intent patient_activation ///
	  usual_source usual_type_own usual_type_lvl usual_type_own_lvl ///
	  usual_reason usual_quality visits visits_cat visits_covid ///
	  fac_number visits_total inpatient blood_pressure mammogram ///
	  cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
	  mistake discrim unmet_need unmet_reason last_type_own last_type_lvl ///
	  last_type_own_lvl last_reason last_wait_time ///
	  last_visit_time last_qual last_skills last_supplies last_respect last_know ///
	  last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
	  last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
	  conf_afford conf_opinion qual_public qual_private qual_ngo_et_ke_za qual_ss_pe ///
	  qual_mut_uy system_outlook system_reform covid_manage vignette_poor /// 
	  vignette_good native_lang income q1 q2 q3 q3a q4 q5 q6 q7 ///
	  q7_other q8 q9 q10 q11 q12 q13 q13b_co_pe_uy q13e_co_pe_uy q13e_other q14 q15 q16 q17 q18 ///
	  q18a_la q18b_la ///
	  q19_et_ke_za q19_co q19_pe q19_uy q19_other q19_q20a_la q19_q20a_other q19_q20b_la ///
	  q19_q20b_other q20 q20_other q21 q21_other q22 ///
	  q23 q24 q23_q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 ///
	  q38 q39 q40 q41 q42 q42_other q43_et_ke_za q43_co q43_pe q43_uy q43_la q43_other /// 
	  q44 q44_la ///
	  q44_other q45 q45_other q46_min q46_refused q47_min q47_refused ///
	  q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a ///
	  q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_et_ke_za q56_pe q56_uy q57 q58 q59 ///
	  q60 q61 q62 q62_other q63 q64 q65 

***************************** Labeling variables ***************************** 
 
lab var age "Exact respondent age or midpoint of age range (Q1/Q2)"
lab var age_cat "Age (categorical) (Q1/Q2)"
lab var gender "Gender (Q3)" 
lab var urban "Respondent lives in urban vs rural area (Q4)"
lab var region "Region where respondent lives (County, state, province, etc.) (Q5)"
lab var insured "Insurance status (Q6)"
lab var insur_type "Type of insurance (for those who have insurance) (Q7)" 
lab var education "Highest level of education completed (Q8)"
lab var	health "Self-rated health (Q9)"
lab var	health_mental "Self-rated mental health (Q10)"
lab var	health_chronic "Longstanding illness or health problem (chronic illness) (Q11)"
lab var	ever_covid "Ever had COVID-19 or coronavirus (Q12)"
lab var	covid_confirmed	"COVID-19 or coronavirus confirmed by a test (Q13)"
lab var	covid_vax "COVID-19 vaccination status (Q14)"
lab var	covid_vax_intent "Intent to receive all recommended COVID vaccine doses if available (Q15)"
lab var	patient_activation "Patient activation: manage overall health and tell a provider concerns (Q16/Q17)"
lab var	usual_source "Whether respondent has a usual source of care (Q18)"
lab var	usual_type_own "Facility ownership for usual source of care (Q19)"
lab var	usual_type_lvl "Facility level for usual source of care (Q20)"
lab var	usual_type_own_lvl "Facility ownership and level for usual source of care (Q19/Q20)"
lab var	usual_reason "Main reason for choosing usual source of care facility (Q21)"
lab var	usual_quality "Overall quality rating of usual source of care (Q22)"
lab var	visits "Visits (continuous) made in-person to a facility in past 12 months (Q23/Q24)"
lab var	visits_cat "Visits (categorical) made in-person to a facility in past 12 months (Q23/Q24)"
lab var	visits_covid "Number of visits made for COVID in past 12 months (Q25A/Q25B)"
lab var	fac_number "Number of facilities visited during the past 12 months (Q26/Q27)"
lab var	visits_total "Total number of healthcare contacts: facility, home, and tele (Q23/Q28A/Q28B)"
lab var	inpatient "Stayed overnight at a facility in past 12 months (inpatient care) (Q29)"
lab var	blood_pressure "Blood pressure checked by healthcare provider in past 12 months (Q30)"
lab var	mammogram "Mammogram conducted by healthcare provider in past 12 months (Q31)"
lab var	cervical_cancer "Cervical cancer screening done by healthcare provider in past 12 months (Q32)"
lab var	eyes_exam "Eyes checked by healthcare provider in past 12 months (Q33)"
lab var	teeth_exam "Teeth checked by healthcare provider in past 12 months (Q34)"
lab var	blood_sugar "Blood sugar tested by healthcare provider in past 12 months (Q35)"
lab var	blood_chol "Blood cholesterol tested by healthcare provider in past 12 months (Q36)"		
*lab var	hiv_test "HIV test conducted by healthcare provider in past 12 months (Q37_A)"
lab var	care_mental	"Received care for depression, anxiety, or another mental health condition (Q38)"
lab var	mistake	"A medical mistake was made in treatment or care in the past 12 months (Q39)"	
lab var	discrim	"You were treated unfairly or discriminated against in the past 12 months (Q40)"	
lab var	unmet_need "Needed medical attention but did not get healthcare (Q41)"
lab var	unmet_reason "Reason for not getting healthcare when needed medical attention (Q42)"
lab var	last_type_own "Facility ownership for last visit to a healthcare provider (Q43)"
lab var	last_type_lvl "Facility level for last visit to a healthcare provider (Q44)"
lab var last_type_own_lvl "Facility ownership and level for last visit to a healthcare provider (Q43/Q44)"
lab var	last_reason	"Reason for last healthcare visit (Q45)" 
lab var	last_wait_time "Length of time waited for last visit to a healthcare provider (Q46)"
lab var	last_visit_time "Length of time spent with the provider during last healthcare visit (Q47)"
lab var	last_qual "Last visit rating: overall quality (Q48A)"
lab var	last_skills "Last visit rating: knowledge and skills of provider (Care competence) (Q48B)"
lab var	last_supplies "Last visit rating: equipment and supplies provider had available (Q48C)"
lab var	last_respect "Last visit rating: provider respect (Q48D)"
lab var	last_know "Last visit rating: knowledge of prior tests and visits (Q48E)"
lab var	last_explain "Last visit rating: explained things in an understandable way (Q48F)"
lab var	last_decisions "Last visit rating: involved you in decisions about your care (Q48G)"
lab var	last_visit_rate "Last visit rating: amount of time provider spent with you (Q48H)"
lab var	last_wait_rate "Last visit rating: amount of time you waited before being seen (Q48I)"
lab var	last_courtesy "Last visit rating: courtesy and helpfulness of the staff (Q48J)"
*lab var	last_comp_index "System competence composite index (average of X items)"
*lab var	last_user_index "User experience composite index (average of X items)"
lab var	last_promote "Net promoter score for facility visited for last visit (Q49)"
lab var	phc_women "Public primary care system rating for: pregnant women (Q50A)"
lab var	phc_child "Public primary care system rating for: children (Q50B)"
lab var	phc_chronic "Public primary care system rating for: chronic conditions (Q50C)"
lab var	phc_mental "Public primary care system rating for: mental health (Q50D)"
*lab var	phc_index "Public primary care system composite index"
lab var	conf_sick "Confidence in receiving good quality healthcare if became very sick (Q51)"
lab var	conf_afford	"Confidence in ability to afford care healthcare if became very sick (Q52)"
lab var	conf_opinion "Confidence that the gov considers public's opinion when making decisions (Q53)"
lab var	qual_public	"Overall quality rating of gov or public healthcare system in country (Q54)"
lab var	qual_private "Overall quality rating of private healthcare system in country (Q55)"
lab var qual_ss_pe "PE only: Overall quality rating of social security system in country (Q56)"
lab var qual_mut_uy "UY only: Overall quality rating of mutual healthcare system in country (Q56)"
lab var qual_ngo "KE/ET only: Overall quality rating of NGO healthcare system in country (Q56)"  
lab var	system_outlook "Health system opinion: getting better, staying the same, or getting worse (Q57)"
lab var	system_reform "Health system opinion: minor, major changes, or must be completely rebuilt (Q58)" 
lab var	covid_manage "Rating of the government's management of the COVID-19 pandemic (Q59)" 
lab var	vignette_poor "Rating of vignette in Q60 (poor care)"
lab var	vignette_good "Rating of vignette in Q61 (good care)"
lab var	native_lang "Native language (Q62)"
lab var	income "Income group (Q63)"


**************************** Save data *****************************

save "$data_mc/02 recoded data/pvs_all_countries.dta", replace


*rm "$data_mc/02 recoded data/pvs_appended.dta"
*rm "$data_mc/02 recoded data/pvs_ke.dta"
*rm "$data_mc/02 recoded data/pvs_et.dta"
*rm "$data_mc/02 recoded data/pvs_lac.dta"
*rm "$data_mc/02 recoded data/pvs_la.dta"




