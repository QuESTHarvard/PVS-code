* People's Voice Survey data cleaning for Malawi - Wave 1
* Date of last update: July 2025
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Malawi. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** MALAWI ***********************

* Import raw data 
use "$data/Malawi/01 raw/Malawi_PVS_data_2025-06-20.dta",clear

*Label as wave 2 data:
gen wave = 2
