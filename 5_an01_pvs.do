* PVS Descriptive Analysis 
* September 2022
* N. Kapoor 

clear all
set more off 

 * Import clean data

use "$pvs01", clear 

* Q for Todd - I don't see how we can add N's for categorical variables within the summtab2 command?
* 				Are there any other issues with the megatable that MEK identified that we can fix here? 
*				I think most will have to be done by hand

 *========================= Descriptive Analysis ============================* 


* Survey characteristics and Part 1: basic demographics - Q1-17

summtab2 , by(Country) vars(int_length mode Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14_NEW Q15_NEW Q16 Q17) /// 
		   type(1 2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) /// 
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(demographics) directory("$output") /// 
		  title(Survey Characteristics & Basic Demographics) 

* Add back language or other interview characteristics once they are accurate(int_length)
		  
* Part 2: Utilization of care and system competence Q18-42
summtab2 , by(Country) vars(Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW /// 
			   Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42) /// 
		  type(2 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		  catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_2) directory("$output") /// 
		  title(Utilization of care and system competence) 		  
		  
		  
* Part 3: Care experience 
summtab2 , by(Country) vars(Q43 Q44 Q45 Q46_min Q47_min Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I /// 
		  Q48_J Q49_new) /// 
		  type(2 2 2 1 1 2 2 2 2 2 2 2 2 2 2 1) ///
		  catmisstype(missnoperc) total /// 
		  mean median range pmiss replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_3) directory("$output") ///
		  title(Care experience)
		  
* Part 4: Health system confidence
summtab , by(Country) catvars(Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56 Q57 Q58 Q59 Q60 Q61 /// 
		  Q62 Q63) ///  
		  catmisstype(missnoperc) total /// 
		  replace excel /// 
		  excelname(pvs_interim_results) sheetname(part_4) directory("$output") ///
		  title(Health system confidence)

* Other items
summtab2 , by(Country) vars(Q66 Q67) /// 
		  type(2 1) /// 
		   catmisstype(missnoperc) /// 
		  mean median range pmiss total replace excel /// 
		  excelname(pvs_interim_results) sheetname(other_items) directory("$output") ///
		  title(Other items)

* Note to Todd: Right now I'm saving this with the HFC output, but maybe this should eventually go somewhere else
