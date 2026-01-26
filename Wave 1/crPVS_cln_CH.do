* People's Voice Survey data cleaning for Nepal
* Date of last update: November 4 ,2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Nepal. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** NEPAL ***********************

* Import data 
use "$data/Switzerland/01 raw data/PVS Switzerland data wave 1.dta", clear


gen wave = 1

* deleting variables that will not be in the harmonized dataset:
drop F131_5 // labeled 'age' with largely missing values and 'Y/N' responses
	drop F131_6 // similar issue with 'gender'


* confirm what these variables are:
drop RecordNo	
	
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 


rename caseid respondentid
rename age q1
rename gender q33 // SS: confirm with CH team
rename F185 q3a_ch 

*citizenship question, look at Germany data (q4):
	*Ask todd if the citizenship questions should be q4 instead of q3
	
* Does the respondent have swiss citizenship?
gen q4a_ch = .
replace q4a_ch = 1 if F010_1 == 169 | F010_2 == 169 | F010_3 == 169
replace q4a_ch = 0 if F010_1 != 169 & F010_2 != 169 & F010_3 != 169 // SS:check 
  
* Does respondent have single or multiple citizenship?
gen q3b = .

* Country of citizenship (string)

* Were you born in Switzerland?
gen q4c_ch = .







  
  