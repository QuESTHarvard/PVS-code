* People's Voice Survey data cleaning for Greece
* Date of last update: July 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Greece and Romania. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** GREECE ***********************

* Import data 
import spss using "$data/Greece/01 raw data/PVS_Greece_weighted_180723.sav", case(lower)

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

* Rename all variables, and some recoding if variable will be dropped 

ren intlength int_length
ren q14_new q14
ren q15_new q15
ren q28 q28_a
ren q28_new q28_b
ren q28_gr q28_c // need to flip order of values
ren q37_gr q37_in_gr
ren q46_gr2 q46a
ren q46_gr q46b // double check units of raw data
ren q46_gr_refused  q46b_refused
ren q56 q56_et_gr_in_ke_za
ren q67 q65




*------------------------------------------------------------------------------*

* Drop unused variables 

drop ecs_id time_new q2 q19 q20_b q20_b_other q20_c q20_c_other q20_d q20_d_other q43_gr q44_b q44_b_other q44_c q44_c_other q66_a q66_b q69 q69_codes rim_age rim_gender q4_weight rim_region q8_weight rim_education dw_overall
 