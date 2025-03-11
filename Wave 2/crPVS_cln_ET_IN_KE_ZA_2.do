* People's Voice Survey data cleaning for Ethiopia, India, Kenya and South Africa - Wave 2
* Date of last update: March 2024
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for Ethiopia, India, Kenya and South Africa. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** ETHIOPIA, KENYA, SOUTH AFRICA, & INDIA ***********************

* Import raw data 
import spss "$data/ET IN KE ZA wave2/00 interim data/Weighted data and technical report/24-065373-01-02_Harvard_2024_Merged_weighted_SPSS.sav"
