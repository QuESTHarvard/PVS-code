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

* Rename all variables, and some recoding if variable will be dropped 

ren q14_new q14
ren q15_new q15
ren q28 q28_a
ren q28_new q28_b
ren q28_a q28_c
ren q43 q43_et_in_ke_ro_za

recode q45 (1 = 1 "Care for an urgent or new health problem") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease") ///
		   (3 = 3 "Preventive care or a visit to check on your health") ///
		   (11 = 4 "Other,specify") ///
		   (996 = .r "Refused"), gen(recq45)

ren q46_a q46a

* Similar to greece, q46b data is confusing
ren q46_b q46b

ren q56 q56_et_gr_in_ke_ro_za
ren q66 q64
ren q67 q65
ren q68 q66

*formatting some vars:
format intlength %tcHH:MM:SS
gen int_length = (hh(intlength)*60 + mm(intlength) + ss(intlength)/60) 

*confirm the format for q46 and q47 (is it MM:SS or HH:MM) - and q46b is in  -1.19e+13?what does this mean?
format q46 %tcMM:SS
gen recq46 = (mm(q46)+ ss(q46)/60) 

format q47 %tcMM:SS
gen recq47 = (mm(q47)+ ss(q47)/60) 

gen reclanguage = 19000 + language 
lab def lang 19002 "RO: Romanian" 
lab values reclanguage lang

order q*, sequential
order respondent_id date int_length mode weight weight_educ //dropped country and lang

drop country
gen reccountry = 19
lab def country 19 "Romania"
lab values reccountry country 

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 
* replace the value to .r if the original one is "Refused"

gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 996
gen recq5 = reccountry*1000 + q5
replace recq5 = .r if q5 == 996
gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8 == 996
gen recq20 = reccountry*1000 + q20
replace recq20 = .r if q20 == 996
gen recq44 = reccountry*1000 + q44
replace recq44 = .r if q44 == 999
gen recq62 = reccountry*1000 + q62
replace recq62 = .r if q62== 996
gen recq63 = reccountry*1000 + q63
replace recq63 = .r if q63 == 996

local q4l labels8
local q5l labels9
local q8l labels12
local q20l labels13
local q44l labels23
local q62l labels53
local q63l labels54

foreach q in q4 q5 q8 q20 q44 q62 q63{
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

	forvalues i = 1/``q'n' {
		local recvalue`q' = 19000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 19000+`: word `i' of ``q'val'') ///
									    (`"RO: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

label define q4_label .a "NA" .r "Refused" , modify
label define q5_label .a "NA" .r "Refused" , modify
label define q8_label .a "NA" .r "Refused" , modify
label define q20_label .a "NA" .r "Refused" , modify
label define q44_label .a "NA" .r "Refused" , modify
label define q62_label .a "NA" .r "Refused" , modify
label define q63_label .a "NA" .r "Refused" , modify

* add label for "Refused"

*label define labels61 .r "Refused", add

*****************************

**** Combining/recoding some variables ****







*------------------------------------------------------------------------------*

* Recode refused and don't know values 
* In raw data, 995 = "don't know" 
recode q (995 = .d)

recode q23 q25_b  (997 = .d)

* Do i need this?
*recode q30 q32 q33 q35 q36 q37 q38 (3 = .d)

* In raw data, 996 = "refused" 	  
recode q4 q5 q6 q7 q8 q11 q12 q14 q15 q16 q17 q19 q20 q21 q22 q23 q24 q25_b q38 ///
	   q39 q44 q45 q46a q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j ///
	   q48_k q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56 q57 q58 q59 q60 ///
	   q61 q62 q63 q64 (996 = .r)


*------------------------------------------------------------------------------*

