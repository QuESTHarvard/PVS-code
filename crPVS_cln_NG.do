* People's Voice Survey data cleaning for Nigeria
* Date of last update: August 29 2023
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Nigeria. 

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
import spss using "$data/Nigeria/01 raw data/23-015344-01 PVS Nigeria_Weighted Data_V1_InternalUseOnly.sav", case(lower)

notes drop _all

* Note: .a means NA, .r means refused, .d is don't know, . is missing 
*------------------------------------------------------------------------------*

* Rename all variables, and some recoding if variable will be dropped 
