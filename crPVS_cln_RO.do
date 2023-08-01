* People's Voice Survey data cleaning for Romania
* Date of last update: August 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Romania. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ROMANIA ***********************

* Import data 
import spss using "$data/Romania/01 raw data/PVS_Romania_Final weighted.sav", case(lower)

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*
