* PVS Descriptive Analysis 
* Last updated: April 2023
* N. Kapoor 

clear all
set more off 

 * Import clean data with derived variables 

use "$data_mc/02 recoded data/pvs_all_countries.dta", replace

 *========================= Descriptive Analysis ============================* 

* Survey characteristics and Part 1: basic demographics - Q1-17

summtab2 , by(country) vars(int_length mode q1 q2 q3 q3a q4 q5 q6 q7 q8 q9 q10 q11 /// 
		   q12 q13 q13b q13e q14 q15 q16 q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics once they are accurate
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(country) vars(q18 q19_ke_et q19_co q19_pe q19_uy q18a_la q19_q20a_la ///
		   q18b_la q19_q20b_la /// 
		   q20 q21 q22 q23 ///
		   q24 q25_a q25_b q26 q27 q28_a q28_b /// 
		   q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42) /// 
		  type(2 2 2 2 2 2 2 2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(country) vars(q43_ke_et q43_la q43_co q43_pe q43_uy q44 q44_la ///
		  q45 q46_min q47_min ///
		  q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i /// 
		  q48_j q49) /// 
		  type(2 2 2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) wts(weight) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	  
		  
* Part 4: Health system confidence
summtab , by(country) catvars(q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
		  q56_ke_et q56_pe q56_uy q57 q58 q59 q60 q61 /// 
		  q62 q63) ///  
		  catmisstype(missnoperc) wts(weight) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(country) vars(q64 q65) /// 
		  type(2 1) /// 
		   catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(other_items) directory("$output") ///
		  title(Other items)

* Derived variables 
summtab2 , by(country) vars(age age_cat gender urban insured /// 5
		   insur_type education health health_mental health_chronic /// 5
		   ever_covid covid_confirmed covid_vax covid_vax_intent activation /// 5 
		   usual_source usual_type_own usual_type_lvl usual_type usual_reason /// 5
		   usual_quality visits visits_cat visits_covid /// 4
		   fac_number visits_total inpatient blood_pressure mammogram /// 5
		   cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
		   mistake discrim unmet_need unmet_reason last_type_own /// 5
		   last_type_lvl last_type last_reason last_wait_time /// 4
		   last_visit_time last_qual last_skills last_supplies last_respect last_know /// 6
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
		   conf_afford conf_getafford conf_opinion qual_public qual_private  ///
		    system_outlook system_reform covid_manage vignette_poor /// 
		   vignette_good minority income) ///
		   type(1 2 2 2 2 /// 5
				2 2 2 2 2 /// 5
				2 2 2 2 2	 /// 5			
				2 2 2 2 2 /// 5
				2 1 2 1 /// 4
				2 1 2 2 2 /// 5 
				2 2 2 2 2 2 /// 6
				2 2 2 2 2 /// 5
				2 2 2 2 /// 4
				2 2 2 2 2 2 /// 6
				2 2 2 2 2 /// 6 
				2 2 2 2 2 2 ///  
				2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(derived variables) directory("$output") /// 
		  title(Derived Variables) 


* Laos table 
summtab2 , by(q62a_la) vars(age age_cat gender urban insured /// 5
		   insur_type education health health_mental health_chronic /// 5
		   ever_covid covid_confirmed covid_vax covid_vax_intent activation /// 5 
		   usual_source usual_type_own usual_type_lvl usual_type usual_reason /// 5
		   usual_quality visits visits_cat visits_covid /// 4
		   fac_number visits_total inpatient blood_pressure mammogram /// 5
		   cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
		   mistake discrim unmet_need unmet_reason last_type_own /// 5
		   last_type_lvl last_type last_reason last_wait_time /// 4
		   last_visit_time last_qual last_skills last_supplies last_respect last_know /// 6
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
		   conf_afford conf_getafford conf_opinion qual_public qual_private  ///
		    system_outlook system_reform covid_manage vignette_poor /// 
		   vignette_good minority income) ///
		   type(1 2 2 2 2 /// 5
				2 2 2 2 2 /// 5
				2 2 2 2 2	 /// 5			
				2 2 2 2 2 /// 5
				2 1 2 1 /// 4
				2 1 2 2 2 /// 5 
				2 2 2 2 2 2 /// 6
				2 2 2 2 2 /// 5
				2 2 2 2 /// 4
				2 2 2 2 2 2 /// 6
				2 2 2 2 2 /// 6 
				2 2 2 2 2 2 ///  
				2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range total replace excel /// 
		  excelname(pvs_results_la) sheetname(derived variables) directory("$in_out") /// 
		  title(Derived Variables) 
		  
		  
		  
 *========================= Additional Tables ============================* 

 summtab2 , by(country) vars(gender urban education health age_cat discrim visits) /// 
		   type(2 2 2 2 2 2 1) wts(weight) wtfreq(ceiling) /// 
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(sample_char_table) sheetname(Sample Characteristics Table) directory("$output") /// 
		  title(Sample Characteristics Table) 
		  
*For South Africa team

* Survey characteristics and Part 1: basic demographics - Q1-17
preserve
keep if country==9

summtab2 , vars(int_length mode q1 q2 q3 q4 q5 q6_za q7 q8 q9 q10 q11 /// 
		   q12 q13 q14 q15 q16 q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 
	  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , vars(q18 q19_et_ke_za ///
		   q20 q21 q22 q23 ///
		   q24 q25_a q25_b q26 q27 q28_a q28_b /// 
		   q29 q30 q31 q32 q33 q34 q35 q36 q37_za q38 q39 q40 q41 q42) /// 
		  type(2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
* Part 3: Care experience 
summtab2 , vars(q43_et_ke_za_la q44 ///
		  q45 q46 q47 ///
		  q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i /// 
		  q48_j q49) /// 
		  type(2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) wts(weight) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	    
* Part 4: Health system confidence
summtab , catvars(q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
		  q56_et_ke_za q57 q58 q59 q60 q61 /// 
		  q62 q63) ///  
		  catmisstype(missnoperc) wts(weight) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , vars(q64 q65) /// 
		  type(2 1) /// 
		   catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(other_items) directory("$output") ///
		  title(Other items)
		  
* Country brief variables 

summtab2 , vars(health health_mental health_chronic /// health
		   activation q17 /// activation
		   usual_source usual_type_own usual_type_lvl usual_reason visits_total visits_home visits_covid fac_number unmet_need /// use 
		   blood_pressure mammogram cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// system competence
		   usual_quality mistake discrim last_wait_time ///
		   last_visit_time last_qual last_skills last_supplies last_respect last_know ///
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy last_promote /// quality
		   phc_women phc_child phc_chronic phc_mental /// conf in public phc
		   conf_sick conf_afford conf_opinion qual_public qual_private qual_ngo /// 
		   system_outlook system_reform covid_manage) /// trust in system
		   type(2 2 2 /// health 
				2 2 /// activation	
				2 2 2 2 1 1 1 1 2 /// use
				2 2 2 2 2 2 2 2 /// system competence
				2 2 2 1 ///
				1 2 2 2 2 2 /// 
				2 2 2 2 2 2 /// quality 
				2 2 2 2 /// conf in public phc 
				2 2 2 2 2 2 ///  
				2 2 2) /// trust in system
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(PVS in brief) directory("$output") /// 
		  title(Derived Variables)
restore

/*
* Derived variables 
preserve
keep if country==9

summtab2 , vars(age age_cat gender urban insured insur_type education health health_mental health_chronic ///
		   ever_covid covid_confirmed covid_vax covid_vax_intent activation /// 
		   usual_source usual_type_own usual_type_lvl usual_type_own usual_type_lvl usual_reason usual_quality visits visits_covid ///
		   fac_number visits_total inpatient blood_pressure mammogram ///
		   cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
		   unmet_need unmet_reason last_type_own last_type_lvl last_reason last_wait_time ///
		   last_visit_time last_qual last_skills last_supplies last_respect last_know ///
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
		   conf_afford conf_opinion qual_public qual_private qual_ngo ///
		   system_outlook system_reform covid_manage vignette_poor /// 
		   vignette_good language income) ///
		   type(1 2 2 2 2 2 2 2 2 2 ///
				2 2 2 2 2	 ///			
				2 2 2 2 2 2 2 2 1 ///
				2 1 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 /// 
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 ///  
				2 2 2 2 2 ///
				2 2 2 2 ///
				2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt_ZA) sheetname(derived variables) directory("$output") /// 
		  title(Derived Variables) 

restore
		  
		  