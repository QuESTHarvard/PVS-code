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


