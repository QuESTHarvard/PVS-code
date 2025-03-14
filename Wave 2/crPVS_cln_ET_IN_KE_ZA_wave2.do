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
import spss "$data/ET IN KE ZA wave2/00 interim data/Weighted data and technical report/24-065373-01-02_Harvard_2024_Merged_weighted_SPSS.sav", case(lower)


*Label as wave 2 data:

gen wave = 2

*Deleting unneccessary vars:
drop shell_chainid dw_overall_relative rim_age rim_sex rim_region rim_education qc_short


*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

*Edit income var - ask Todd how he would like this to be coded, recode all data? If not, add (wave 1) to original income vars?
recode q51 (101 = 101  "< Ksh 1,000") ///
		   (102 = 102 "Ksh 1,001 – 3,000") ///
		   (103 = 103 "Ksh 3,001 - 5,000") ///
		   (104 = 104 "Ksh 5,001 – 7,000") ///
		   (105 = 105 "Ksh 7,001 - 10,000") ///
		   (106 = 106 "Ksh 10,001 – 12,000") ///
		   (107 = 107 "Ksh 12,001 - 15,000") ///
		   (4 = 108 "Ksh 15,001 - 20,000") /// 
           (5 = 109 "Ksh 20,001 - 40,000") /// 
		   (108 = 110 "> Ksh 40,000") ///
		   (9 = 111 "< 1001 Eth.Birr") /// NOTE: this was <1000 Birr in wave 1
		   (10 = 112 "1001 - 2000  Eth.Birr") /// NOTE: this was 1000-3000 Birr
		   (11 = 113 "2001 – 3000 Eth.Birr") /// NOTE: this was 3001-5000 Birr
		   (12 = 114 "3001 – 5000 Eth.Birr") /// NOTE: this was 5001–10000 Birr
		   (13 = 115 "5001 - 10000 Eth.Birr") /// NOTE: this was 10001-20000 Birr
		   (14 = 116 "10,001 - 20,000 Eth.Birr") /// NOTE: this was Greater than 20000 Birr
		   (99 = 117 "> 20,000 Eth.Birr") ///
		   (23 = 118 "No income") /// same
		   (15 = 119 "<R751") /// NOTE: this was <R750 in wave 1
		   (16 = 120 "R751 - R1500") /// same as wave 1
		   (17 = 121 "R1501 - R3000") /// same as wave 1
		   (18 = 122 "R3001 - R6000") /// same as wave 1
		   (19 = 123 "R6001 - R11000") /// same as wave 1
		   (20 = 124 "R11001 - R27000") /// same as wave 1
		   (21 = 125 "R27001 - R45000") /// same as wave 1
		   (22 = 126 "R>45000") /// same as wave 1
		   (24 = 127 "<3001 INR") /// NOTE: this was less than <3000 INR in wave 1
		   (25 = 128 "3,001 - 5,000 INR") /// NOTE: this was 3000 - 10000 INR in wave 1
		   (26 = 129 "5,001 - 10,000 INR") /// NOTE: this was 10,001-20,000 INR in wave 1
		   (27 = 130 "10,001 - 15,000 INR") /// NOTE: this was 20,001-30,000 INR in wave 1
		   (28 = 131 "15,001 - 20,000 INR") /// NOTE: this was 30,001-40,000 INR in wave 1
		   (29 = 132 "20,001 - 30,000 INR INR") /// NOTE: this was 40,001-50,000 INR in wave 1
		   (30 = 133 "30,001 - 40,000 INR") /// NOTE: this was >50,000 INR in wave 1
		   (109 = 134 "40,001 - 50,000 INR") ///
		   (110 = 135 "> 50,000 INR") ///
		   (999 = .r "Refused") (998 = .d "Don't know"), gen(recq51)
		   
drop q51
ren rec* *

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = country*1000 + language  
*gen recinterviewer_id = country*1000 + interviewer_id *interviewer_id in a string fmt

gen recq4 = country*1000 + q4
replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 999

gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 999

gen recq8 = country*1000 + q8
replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
replace recq15 = .r if q15== 999
replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
replace recq33 = .r if q33== 999 
replace recq33 = .d if q33== 998

gen recq50 = country*1000 + q50 
replace recq50 = .r if q50== 999

gen recq51 = country*1000 + q51
*replace recq51 = .r if q51== 999
*replace recq51 = .d if q51== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

** SS: eventually change wave 1/v1.0 labels to new v2.0 ordering/add labels to data dictionary?
local q4l labels9
local q5l labels8
local q7l labels11
local q8l labels13
local q15l labels21
local q33l labels48
local q50l labels80
local q51l recq51

foreach q in q4 q5 q7 q8 q15 q33 q50 q51 {
	qui elabel list ``q'l'
	local `q'n = r(k)
	local `q'val = r(values)
	local `q'lab = r(labels)
	local g 0
	foreach i in ``q'lab'{
		local ++g
		local gr`g' `i'
	}

	qui levelsof rec`q', local(`q'level)

	forvalues o = 1/`countryn' {
		forvalues i = 1/``q'n' {
			local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of ``q'val''
			foreach lev in ``q'level'{
				if strmatch("`lev'", "`recvalue`q''") == 1{
					elabel define `q'_label (= `: word `o' of `countryval''*1000+`: word `i' of ``q'val'') ///
									        (`"`: word `o' of `countrylab'': `gr`i''"'), modify			
				}	
			}                 
		}
	}
	
	label val rec`q' `q'_label
}


*****************************

drop q4 q5 q7 q8 q15 q33 q50 q51 language
ren rec* *

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

* Converting interview length to minutes so it can be summarized
gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60)
drop intlength

*SS: Re-format date var? currently in %tcDD-Mon-CCYY fmt 
*format date %tdD_M_CY

* Generate new var for insurance in ZA since question asked differently - confirm with Todd
gen q6_za = q6 if country == 9
replace q6 = .a if country == 9
recode q6_za (. = .a) if country != 9

*------------------------------------------------------------------------------*
* Generate variables 

replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 

* q18/q19 mid-point var 
*SS: note, it looks like q19 is on a scale of 1-4 instead of 0-3 like the data dictionary
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* In raw data, 997 = "don't know" 
recode q14 q18 q21 q22 q23 q27a q27b q27c q27d q27e q27f q27g q27h (998 = .d)
	   
*NOTE: currently in data q37_za "don't know" is category 3  

* In raw data, 996 = "refused" 
recode q1 q3 q6 q9 q10 q11 q12a q12b q13 q14 q16 q17 q18 q19 q20 q21 q22 q23 q24 q25 q26 q27a q27b q27d q27e q27f q27g q27h q28a q28b q29 q30 (999 = .r)	
	   
*------------------------------------------------------------------------------*

* Check for implausible values 


