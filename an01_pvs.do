* PVS Descriptive Analysis 
* September 2022
* N. Kapoor 

clear all
set more off 

 * Import clean data with derived variables 

use "$data_mc/02 recoded data/pvs_ke_et_lac_02.dta", clear 

* NOTE: Some of these take a while to run. Is there a faster way to do this? 


 *========================= Descriptive Analysis ============================* 


* Survey characteristics and Part 1: basic demographics - Q1-17

summtab2 , by(country) vars(int_length mode q1 q2 q3 q3a q4 q5 q6 q7 q8 q9 q10 q11 /// 
		   q12 q13 q13b q13e q14 q15 q16 q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics if interested
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(country) vars(q18 q19_ke_et q19_co q19_pe q19_uy q20 q21 q22 q23 ///
		   q24 q25_a q25_b q26 q27 q28_a q28_b /// 
		   q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42) /// 
		  type(2 2 2 2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(country) vars(q43_ke_et q43_co q43_pe q43_uy q44 q45 q46_min q47_min ///
		  q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i /// 
		  q48_j q49) /// 
		  type(2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	  
		  
* Part 4: Health system confidence
summtab , by(country) catvars(q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
		  q56_ke_et q56_pe q56_uy q57 q58 q59 q60 q61 /// 
		  q62 q63) ///  
		  catmisstype(missnoperc) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(country) vars(q64 q65) /// 
		  type(2 1) /// 
		   catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(other_items) directory("$output") ///
		  title(Other items)

* Derived variables 
summtab2 , by(Country) vars(age_calc age_cat gender urban insured insur_type education health health_mental health_chronic ///
		   ever_covid covid_confirmed covid_vax covid_vax_intent patient_activation /// 
		   usual_source usual_type_own usual_type_lvl usual_type_own_lvl usual_reason usual_quality visits visits_covid ///
		   fac_number visits_total inpatient blood_pressure mammogram ///
		   cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
		   system_fail unmet_need unmet_reason last_type_own last_type_lvl last_type_own_lvl last_reason last_wait_time ///
		   last_visit_time last_qual last_skills last_supplies last_respect last_know ///
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
		   conf_afford conf_opinion qual_public qual_private qual_ngo_ke qual_ss_pe ///
		   qual_mut_uy system_outlook system_reform covid_manage vignette_poor /// 
		   vignette_good native_lang income) ///
		   type(1 2 2 2 2 2 2 2 2 2 ///
				2 2 2 2 2	 ///			
				2 2 2 2 2 2 2 1 ///
				2 1 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 2 /// 
				2 2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2 2 2 2 ///  
				2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2) /// 
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(derived variables) directory("$output") /// 
		  title(Derived Variables) 



* WEIGHTED DATA 
clear all
set more off 

 * Import clean data with derived variables 

use "$data_mc/02 recoded data/pvs_ke_et_lac_02.dta", clear 
drop if Country == 3

 *========================= Descriptive Analysis ============================* 



* Survey characteristics and Part 1: basic demographics - Q1-17

summtab2 , by(Country) vars(int_length mode q1 q2 q3 q3a q4 q5 q6 q7 q8 q9 q10 q11 /// 
		   q12 q13 q13b q13e q14 q15 q16 q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics once they are accurate
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(Country) vars(q18 q19_ke_et q19_co q19_pe q19_uy q20 q21 q22 q23 ///
		   q24 q25_a q25_b q26 q27 q28_a q28_b /// 
		   q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42) /// 
		  type(2 2 2 2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(Country) vars(q43_ke_et q43_co q43_pe q43_uy q44 q45 q46_min q47_min ///
		  q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i /// 
		  q48_j q49) /// 
		  type(2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) wts(weight) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	  
		  
* Part 4: Health system confidence
summtab , by(Country) catvars(q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 /// 
		  q56_ke_et q56_pe q56_uy q57 q58 q59 q60 q61 /// 
		  q62 q63) ///  
		  catmisstype(missnoperc) wts(weight) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(Country) vars(q64 q65) /// 
		  type(2 1) /// 
		   catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(other_items) directory("$output") ///
		  title(Other items)

* Derived variables 
summtab2 , by(Country) vars(age_calc age_cat gender urban insured insur_type education health health_mental health_chronic ///
		   ever_covid covid_confirmed covid_vax covid_vax_intent patient_activation /// 
		   usual_source usual_type_own usual_type_lvl usual_type_own_lvl usual_reason usual_quality visits visits_covid ///
		   fac_number visits_total inpatient blood_pressure mammogram ///
		   cervical_cancer eyes_exam teeth_exam blood_sugar blood_chol care_mental /// 
		   system_fail unmet_need unmet_reason last_type_own last_type_lvl last_type_own_lvl last_reason last_wait_time ///
		   last_visit_time last_qual last_skills last_supplies last_respect last_know ///
		   last_explain last_decisions last_visit_rate last_wait_rate last_courtesy ///
		   last_promote phc_women phc_child phc_chronic phc_mental conf_sick ///
		   conf_afford conf_opinion qual_public qual_private qual_ngo_ke qual_ss_pe ///
		   qual_mut_uy system_outlook system_reform covid_manage vignette_poor /// 
		   vignette_good native_lang income) ///
		   type(1 2 2 2 2 2 2 2 2 2 ///
				2 2 2 2 2	 ///			
				2 2 2 2 2 2 2 1 ///
				2 1 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 /// 
				2 2 2 2 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 ///  
				2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(derived variables) directory("$output") /// 
		  title(Derived Variables) 
