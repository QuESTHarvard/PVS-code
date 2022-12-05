* PVS Descriptive Analysis 
* September 2022
* N. Kapoor 

clear all
set more off 

 * Import clean data with derived variables 

use "$data_mc/02 recoded data/pvs_ke_et_lac_02.dta", clear 


 *========================= Descriptive Analysis ============================* 


* Survey characteristics and Part 1: basic demographics - Q1-17

summtab2 , by(Country) vars(int_length mode Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 /// 
		   Q12 Q13 Q13B Q13E Q14 Q15 Q16 Q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics once they are accurate
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(Country) vars(Q18 Q19_KE_ET Q19_CO Q19_PE Q19_UY Q20 Q21 Q22 Q23 ///
		   Q24 Q25_A Q25_B Q26 Q27 Q28_B Q28_B /// 
		   Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42) /// 
		  type(2 2 2 2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(Country) vars(Q43_KE_ET Q43_CO Q43_PE Q43_UY Q44 Q45 Q46_min Q47_min ///
		  Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I /// 
		  Q48_J Q49) /// 
		  type(2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	  
		  
* Part 4: Health system confidence
summtab , by(Country) catvars(Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 /// 
		  Q56_KE_ET Q56_PE Q56_UY Q57 Q58 Q59 Q60 Q61 /// 
		  Q62 Q63) ///  
		  catmisstype(missnoperc) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(Country) vars(Q64 Q65) /// 
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
		   vignette_good income) ///
		   type(1 2 2 2 2 2 2 2 2 2 ///
				2 2 2 2 2	 ///			
				2 2 2 2 2 2 1 1 ///
				1 1 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 2 /// 
				2 2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2 2 2 2 2 ///  
				2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2) /// 
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

summtab2 , by(Country) vars(int_length mode Q1 Q2 Q3 Q3a Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 /// 
		   Q12 Q13 Q13B Q13E Q14 Q15 Q16 Q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics once they are accurate
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(Country) vars(Q18 Q19_KE_ET Q19_CO Q19_PE Q19_UY Q20 Q21 Q22 Q23 ///
		   Q24 Q25_A Q25_B Q26 Q27 Q28_B Q28_B /// 
		   Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42) /// 
		  type(2 2 2 2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(Country) vars(Q43_KE_ET Q43_CO Q43_PE Q43_UY Q44 Q45 Q46_min Q47_min ///
		  Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I /// 
		  Q48_J Q49) /// 
		  type(2 2 2 2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) wts(weight) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_3) directory("$output") ///
		  title(Care experience)
	  
		  
* Part 4: Health system confidence
summtab , by(Country) catvars(Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 /// 
		  Q56_KE_ET Q56_PE Q56_UY Q57 Q58 Q59 Q60 Q61 /// 
		  Q62 Q63) ///  
		  catmisstype(missnoperc) wts(weight) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(Country) vars(Q64 Q65) /// 
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
		   vignette_good income) ///
		   type(1 2 2 2 2 2 2 2 2 2 ///
				2 2 2 2 2	 ///			
				2 2 2 2 2 2 1 1 ///
				1 1 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 /// 
				2 2 2 2 2 2 2 ///
				2 2 2 2 2 2 ///
				2 2 2 2 2 2 ///  
				2 2 2 2 2 2 ///
				2 2 2 2 2 ///
				2 2) /// 
		  catmisstype(missnoperc) wts(weight) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results_wt) sheetname(derived variables) directory("$output") /// 
		  title(Derived Variables) 
