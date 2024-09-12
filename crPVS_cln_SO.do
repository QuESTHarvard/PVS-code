* People's Voice Survey data cleaning for Somaliland
* Date of last update: September 11,2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Somaliland. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** SOMALILAND ***********************
