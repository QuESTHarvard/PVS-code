* People's Voice Survey data cleaning for The United States of America - Wave 2
* Date of last update: July 2025
* Last updated by: S Sabwa

/*

This file cleans Ipsos data for the United States of America. 

Cleaning includes:
	- Recoding outliers to missing 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

clear all
set more off 

*********************** UNITED STATES (WAVE 2) ***********************

* Import raw data 
import spss using "$data/United States wave 2/01 raw data/WashU PVS Final Dataset 07102025_FINAL WEIGHTS_confidential.sav", case(lower)

*Label as wave 2 data:
gen wave = 2

*Deleting unneccessary vars:
drop status hid_loi q5b_1 q5b_2 q5b_3 q5b_4 q5b_5 q5b_6 q5b_999 ///
	 hrandom_q16 hrandom_q27loop hrandom_q28loop hrandom_q30 ///
	 hrandom_q31loop hrandom_q38loop q39dk hrandom_q40loop ///
	 hrandom_q52 hrandom_q52a pregvote pincome pincome4way pownhome ///
	 pintfreq ptotper padults pparent pregion pdivision pstate pmetro pdma /// confirmed with Todd I can drop these for now
	 ownhome totper adults talkneigh volunteer regvote religion religion_997_other ///
	 intfreq page1 pagefinal pgender peduc peducation prace peth pemploy pmstatus3 ///
	 ppolparty ppollean ppolview m1count m1_2count m2count 

*confirm with Todd if we should keep these/what to do with these:
drop sampletype rural q53_1 q53_2 q53_3 q53_4 q53_5 q53_5_other q53_999 crisismessage

*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

gen reccountry = 12
lab def country 12 "United States"
lab values reccountry country

rename weight_total_sample_2 weight // confirm with Todd which weight var
rename respid respondent_serial
rename xchannel mode

rename q5a q50a_us
rename q5b_6_other q50a_us_other

rename q7_7_other q7_other
rename q15_7_other q15_other
rename q16_9_other q16_other
rename q24_4_other q24_other // check to see if this can be recoded back into the parent variable
rename q27_i q27i_us
rename q30_8_other q30_other
rename q33_7_other q33_other
rename q34_4_other q34_other
rename q37_7_other q37_other

rename q41a q41_us //confirm nomenclature with Todd

rename q50_3_other q50_other

rename q52 q52a_us
rename q52_4_other q52a_us_other // try to recode 
rename q52a q52b_us

gen recq4=.
replace recq4 = 1 if q4 == "AL"
replace recq4 = 2 if q4 == "AK"
replace recq4 = 3 if q4 == "AZ"
replace recq4 = 4 if q4 == "AR"
replace recq4 = 5 if q4 == "CA"
replace recq4 = 6 if q4 == "CO"
replace recq4 = 7 if q4 == "CT"
replace recq4 = 8 if q4 == "DE"
replace recq4 = 9 if q4 == "DC"
replace recq4 = 10 if q4 == "FL"
replace recq4 = 11 if q4 == "GA"
replace recq4 = 12 if q4 == "HI"
replace recq4 = 13 if q4 == "ID"
replace recq4 = 14 if q4 == "IL"
replace recq4 = 15 if q4 == "IN"
replace recq4 = 16 if q4 == "IA"
replace recq4 = 17 if q4 == "KS"
replace recq4 = 18 if q4 == "KY"
replace recq4 = 19 if q4 == "LA"
replace recq4 = 20 if q4 == "ME"

replace recq4 = 21 if q4 == "MD"
replace recq4 = 22 if q4 == "MA"
replace recq4 = 23 if q4 == "MI"
replace recq4 = 24 if q4 == "MN"
replace recq4 = 25 if q4 == "MS"
replace recq4 = 26 if q4 == "MO"
replace recq4 = 27 if q4 == "MT"
replace recq4 = 28 if q4 == "NE"
replace recq4 = 29 if q4 == "NV"
replace recq4 = 30 if q4 == "NH"

replace recq4 = 31 if q4 == "NJ"
replace recq4 = 32 if q4 == "NM"
replace recq4 = 33 if q4 == "NY"
replace recq4 = 34 if q4 == "NC"
replace recq4 = 35 if q4 == "ND"
replace recq4 = 36 if q4 == "OH"
replace recq4 = 37 if q4 == "OK"
replace recq4 = 38 if q4 == "OR"
replace recq4 = 39 if q4 == "PA"
replace recq4 = 40 if q4 == "RI"

replace recq4 = 41 if q4 == "SC"
replace recq4 = 42 if q4 == "SD"
replace recq4 = 43 if q4 == "TN"
replace recq4 = 44 if q4 == "TX"
replace recq4 = 45 if q4 == "UT"
replace recq4 = 46 if q4 == "VT"
replace recq4 = 47 if q4 == "VA"
replace recq4 = 48 if q4 == "WA"
replace recq4 = 49 if q4 == "WV"
replace recq4 = 50 if q4 == "WI"
replace recq4 = 51 if q4 == "WY"

lab def recq4 1 "Alabama" 2 "Alaska" 3 "Arizona" 4 "Arkansas" 5 "California" ///
			  6 "Colorado" 7 "Connecticut" 8 "Delaware" 9 "District of Columbia" ///
			  10 "Florida" 11 "Georgia" 12 "Hawaii" 13 "Idaho" 14 "Illinois" 15 "Indiana" ///
			  16 "Iowa" 17 "Kansas" 18 "Kentucky" 19 "Louisiana" 20 "Maine" ///
			  21 "Maryland" 22 "Massachusetts" 23 "Michigan" 24 "Minnesota" 25 "Mississippi" ///
			  26 "Missouri" 27 "Montana" 28 "Nebraska" 29 "Nevada" 30 "New Hampshire" ///
			  31 "New Jersey" 32 "New Mexico" 33 "New York" 34 "North Carolina" 35 "North Dakota" ///
			  36 "Ohio" 37 "Oklahoma" 38 "Oregon" 39 "Pennsylvania" 40 "Rhode Island" ///
			  41 "South Carolina" 42 "South Dakota" 43 "Tennessee" 44 "Texas" 45 "Utah" ///
			  46 "Vermont" 47 "Virginia" 48 "Washington" 49 "West Virginia" 50 "Wisconsin" 51 "Wyoming"
lab val recq4 recq4

drop q4
ren recq4 q4			  
			  

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = reccountry*1000 + language  

gen recq4 = reccountry*1000 + q4
*replace recq4 = .r if q4 == 999

gen recq5 = reccountry*1000 + q5  
*replace recq5 = .r if q5 == 999

gen recq7 = reccountry*1000 + q7
replace recq7 = .r if q7== 999

gen recq8 = reccountry*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = reccountry*1000 + q15
*replace recq15 = .r if q15== 999
*replace recq15 = .d if q15== 998

gen recq33 = reccountry*1000 + q33
replace recq33 = .r if q33== 999 
*replace recq33 = .d if q33== 998

gen recq50 = reccountry*1000 + q50 
*replace recq50 = .r if q50== 999

gen recq51 = reccountry*1000 + q51
replace recq51 = .r if q51== 999
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

local q4l recq4
local q5l labels8
local q7l labels12
local q8l labels13
local q15l labels18
local q33l labels33
local q50l labels64
local q51l labels65

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


lab def Language  12009  "US: English" 12010  "US: Spanish" 
lab values reclanguage Language

*****************************

drop q4 q5 q7 q8 q15 q33 q50 q51 language
ren rec* *

*------------------------------------------------------------------------------*
* Generate vairables
* Fix interview length variable and other time variables 

gen respondent_id = "US" + string(respondent_serial) 

*SS: Re-format date var? currently in %tcYY/NN/DD fmt 
*format date %tdD_M_CY

* gen q2 = . // already exists in the dataset
replace q2=0 if q1 <18
replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 
replace q2 = .a if q1 == .a | q1 == .d | q1 == .r

lab def q2_label 0 "under 18" 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" ///
				6 "70-79" 7 "80 +" .r "Refused" .a "NA" .d "Don't Know" .r "Refused"
lab val q2 q2_label

* q18/q19 mid-point var 
gen q18_q19 = q18 

recode q18_q19 (998 = 0) if q19 == 0
recode q18_q19 (998 = 1) if q19 == 1
recode q18_q19 (998 = 2.5) if q19 == 2
recode q18_q19 (998 = 7) if q19 == 3
recode q18_q19 (998 = 10) if q19 == 4

gen q14 = .a
gen q32 = .a

* visits_mental
egen visits_mental = rowtotal(m2_a m2_b m2_c m2_d m2_e m2_f m2_g m2_h m2_i) 
lab var visits_mental "PVS US only: Number of mental health providers people are seeing"

*Create a new variable for: How many people used anything (mental health module) to help?-add m6 vars
egen m6_total = rowtotal(m6_a m6_b m6_c m6_d m6_e m6_f m6_g m6_h m6_i m6_j) 
lab var m6_total "PVS US only: Number of resources or practices for problems people are using"

*renaming US based weights variables:
rename weight_main_2 usw_main2
rename weight_rural_2 usw_rural2
rename weight_under30_2 usw_under302
rename weight_mo_5 usw_mo5

lab var usw_main2 "PVS US only: Main weight for N=2500 sample"

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* In raw data, 998 = "don't know" 
recode q18 q19 q18_q19 q22 q23 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q27i_us (998 = .d) 

* In raw data, 999 = "refused" 
recode q9 q10 q11 q12_a q12_b q13 q16 q17 q18 q19 q18_q19 q22 q23 q24 q26 q28_a ///
	   q28_b q29 q34 q35 q36 q38_a q38_b q38_c q38_d q41_c q41_us q42 q43 q45 q38_e ///
	   q38_f q38_g q38_h q38_i q38_j q38_k q40_b q40_c q41_a q41_b q41_c q41_us q42 ///
	   q43 q45 q46 q47 q52a_us q52b_us m1_a m2_a m2_b m2_c m2_d m2_e m2_f m2_g m2_h m2_i ///
	   m3 m4 m5 m6_c m6_g m6_h (999 = .r)	
	   
*------------------------------------------------------------------------------*
* Check for implausible values 

* Q17. Overall respondent's rating of the quality received in this facility
* Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)
* Q20. Were all of the visits you made to the same healthcare facility? 
* Q21. How many different healthcare facilities did you go to? 
* Q22. How many visits did you have with a healthcare provider at your home?
* Q23. How many virtual or telemedicine visits did you have?

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 

replace q21 = q18_q19 if q21 > q18_q19 & q21 < . // N=64 changes, double check with Todd we want this to apply to people who said ".d"

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .

recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=34 changes

drop visits_total

*------------------------------------------------------------------------------*
* Recode missing values to NA for intentionally skipped questions (q14, q32 missing in this dataset)

*q1/q2 - no missing data

* q7 
recode q7 (. = .a) if q6 !=1
recode q7 (nonmissing = .a) if q6 == 0


*q14-17
recode q15 q16 q17 (. = .a) if q13 !=1

* NA's for q19-21 
recode q19 (. = .a) if q18 != .d | q18 !=.r

recode q20 (. = .a) if q18 <1 | q18 == .d | q18 == .r | q19 != 2 | q19 != 3 | q19 != 4

recode q21 (. = .a) if q20 !=0 

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0  | q23 == .d | q23 == .r

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=1 

*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 1 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (. = .a) if q29 !=1

* q33-38
recode q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r
													 
replace q38_e = .a if q38_e == 5  // I have not had prior visits or tests or The clinic had no other staff
replace q38_j = .a if q38_j == 5  // I have not had prior visits or tests or The clinic had no other staff													 

recode q36 q38_k (. = .a) if q35 !=1	

* mental health module:
recode m1_2_a m1_2_b m1_2_c m1_2_d m1_2_e m1_2_f m1_2_g  (. = .a) if (m1_a + m1_b) <=2
recode m1_2_a m1_2_b m1_2_c m1_2_d m1_2_e m1_2_f m1_2_g  (. = .a) if m1_a == .r | m1_b == .r

recode m3 (. = .a) if (m2_a + m2_b + m2_c + m2_d + m2_e + m2_f + m2_g + m2_h + m2_i) <=1

replace m3 = .a if (m2_a == .r | m2_a == 0) & (m2_b == .r | m2_b == 0) & ///
                (m2_c == .r | m2_c == 0) & (m2_d == .r | m2_d == 0) & ///
                (m2_e == .r | m2_e == 0) & (m2_f == .r | m2_f == 0) & ///
                (m2_g == .r | m2_g == 0) & (m2_h == .r | m2_h == 0) & ///
                (m2_i == .r | m2_i == 0)

recode m4 m5 (. = .a) if m3 !=. | m3 !=.a | m3 !=.d | m3 !=.r			

*create phq2 and phq9 score

egen phq2 = rowtotal(m1_a m1_b)

gen phq2_cat = .
replace phq2_cat = 0 if phq2 <3
replace phq2_cat = 1 if phq2 >=3

lab def phq2_cat_label 0 "Screen negative" 1 "Screen positive"
lab val phq2_cat phq2_cat_label

egen phq9 = rowtotal(m1_a m1_b m1_2_a m1_2_b m1_2_c m1_2_d m1_2_e m1_2_f m1_2_g)

replace phq9 = .a if phq2_cat ==0 

gen phq9_cat = .
replace phq9_cat = 1 if phq9 >0 & phq9<=4
replace phq9_cat = 2 if phq9 >=5 & phq9 <=9
replace phq9_cat = 3 if phq9 >=10 & phq9 <=14
replace phq9_cat = 4 if phq9 >=15 & phq9 <=19
replace phq9_cat = 5 if phq9 >=20 & phq9 <=27

lab def phq9_cat_label 1 "None-minimal"	2 "Mild" 3 "Moderate" 4 "Moderately Severe" 5 "Severe"
lab val phq9_cat phq9_cat_label

recode phq9_cat (. = .a) if phq2<3
				
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

recode q17 (5 = .a)

recode q19 (0 = 0) (1 = 1 "1-4") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more"), gen(recq19) // originally 1 was seperated out
drop q19

recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance)") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") (8 = 10 "Other"), gen(recq30)
drop q30

recode q33 (12001 = 12001 "US: Doctor's office, such as a private practice or group practice") /// confirm if you want this language or wave 1 language
		   (12002 = 12002 "US: Urgent care clinic") ///
		   (12003 = 12003 "US: Community health center or low-cost clinic, such as a public health clinic or Planned Parenthood") /// confirm language 
		   (12004 = 12008 "US: Veteran's Affairs, military, or Indian Health Service facility") /// it looks like they merged 4 and 5 from wave 1, confirm with Todd ///
		   (12005 = 12006 "US: Hospital emergency room") ///
		   (12006 = 12007 "US: Other hospital department(not the emergency room)") /// confirm language
		   (12007 = 12996 "US: Other"), gen(recq33)
drop q33

label def q33 12001 "US: Doctor's office, such as a private practice or group practice" ///
					12002 "US: Urgent care clinic" ///
					12003 "US: Community health center or low-cost clinic, such as a public health clinic or Planned Parenthood" ///
					12006 "US: Hospital emergency room" ///
					12007 "US: Other hospital department(not the emergency room)" ///
					12008 "US: Veteran's Affairs, military, or Indian Health Service facility" ///
					12996 "US: Other" 
label var recq33 q33 

recode q38_j (6 = .a)

recode q40_a q40_b q40_c q40_d  (5 = .d)

recode q45 (1 = 2 "Getting better") (2 = 1 "Staying the same") (3 = 0 "Getting worse"), gen(recq45)
drop q45

recode q51 (12001 = 12101 "US: Less than \$15,000") ///
		   (12002 = 12102 "US: \$15,000 to less than \$25,000") ///
		   (12003 = 12103 "US: \$25,000 to less than \$40,000") ///
		   (12004 = 12104 "US: \$40,000 to less than \$65,000") ///
		   (12005 = 12105 "US: \$65,000 to less than \$100,000") ///
		   (12006 = 12106 "US: \$100,000 to less than \$150,000") ///
		   (12007 = 12107 "US: More than \$150,000"), gen(recq51)
drop q51
rename recq51 q51
 
* Add value labels 
label define q7_label .a "NA" .d "Don't know" .r "Refused",add	
label define labels14 .a "NA" .d "Don't know" .r "Refused",add	
label define labels15 .a "NA" .d "Don't know" .r "Refused",add
label define labels16 .a "NA" .d "Don't know" .r "Refused",add
label define labels17 .a "NA" .d "Don't know" .r "Refused",add
label define q15_label .a "NA" .d "Don't know" .r "Refused",add
label define labels19 .a "NA" .d "Don't know" .r "Refused",add
label define labels20 .a "NA" .d "Don't know" .r "Refused",add
label define recq19 .a "NA" .d "Don't know" .r "Refused",add
label define labels23 .a "NA" .d "Don't know" .r "Refused",add
label define labels24 .a "NA" .d "Don't know" .r "Refused",add
label define labels21 .a "NA" .d "Don't know" .r "Refused",add
label define labels25 .a "NA" .d "Don't know" .r "Refused",add
label define labels26 .a "NA" .d "Don't know" .r "Refused",add
label define labels27 .a "NA" .d "Don't know" .r "Refused",add
label define labels28 .a "NA" .d "Don't know" .r "Refused",add
label define labels29 .a "NA" .d "Don't know" .r "Refused",add
label define labels30 .a "NA" .d "Don't know" .r "Refused",add
label define recq30 .a "NA" .d "Don't know" .r "Refused",add
label define recq33 .a "NA" .d "Don't know" .r "Refused",add
label define labels34 .a "NA" .d "Don't know" .r "Refused",add
label define labels35 .a "NA" .d "Don't know" .r "Refused",add
label define labels36 .a "NA" .d "Don't know" .r "Refused",add
label define labels37 .a "NA" .d "Don't know" .r "Refused",add
label define labels38 .a "NA" .d "Don't know" .r "Refused",add
label define labels39 .a "NA" .d "Don't know" .r "Refused",add
label define labels40 .a "NA" .d "Don't know" .r "Refused",add
label define labels41 .a "NA" .d "Don't know" .r "Refused",add
label define labels42 .a "NA" .d "Don't know" .r "Refused",add
label define labels43 .a "NA" .d "Don't know" .r "Refused",add
label define labels44 .a "NA" .d "Don't know" .r "Refused",add
label define labels45 .a "NA" .d "Don't know" .r "Refused",add
label define labels46 .a "NA" .d "Don't know" .r "Refused",add
label define labels47 .a "NA" .d "Don't know" .r "Refused",add
label define labels49 .a "NA" .d "Don't know" .r "Refused",add
label define labels50 .a "NA" .d "Don't know" .r "Refused",add
label define labels51 .a "NA" .d "Don't know" .r "Refused",add
label define labels52 .a "NA" .d "Don't know" .r "Refused",add
label define labels53 .a "NA" .d "Don't know" .r "Refused",add
label define labels55 .a "NA" .d "Don't know" .r "Refused",add
label define labels56 .a "NA" .d "Don't know" .r "Refused",add
label define labels57 .a "NA" .d "Don't know" .r "Refused",add
label define labels58 .a "NA" .d "Don't know" .r "Refused",add
label define recq45 .a "NA" .d "Don't know" .r "Refused",add
label define labels60 .a "NA" .d "Don't know" .r "Refused",add
label define labels61 .a "NA" .d "Don't know" .r "Refused",add
label define recq51 .a "NA" .d "Don't know" .r "Refused",add
label define labels66 .a "NA" .d "Don't know" .r "Refused",add
label define labels67 .a "NA" .d "Don't know" .r "Refused",add
label define labels76 .a "NA" .d "Don't know" .r "Refused",add
label define labels78 .a "NA" .d "Don't know" .r "Refused",add
label define labels79 .a "NA" .d "Don't know" .r "Refused",add
label define labels80 .a "NA" .d "Don't know" .r "Refused",add
label define labels81 .a "NA" .d "Don't know" .r "Refused",add
label define labels82 .a "NA" .d "Don't know" .r "Refused",add
label define labels83 .a "NA" .d "Don't know" .r "Refused",add
label define labels84 .a "NA" .d "Don't know" .r "Refused",add
label define labels86 .a "NA" .d "Don't know" .r "Refused",add
label define labels89 .a "NA" .d "Don't know" .r "Refused",add
label define labels90 .a "NA" .d "Don't know" .r "Refused",add
label define labels91 .a "NA" .d "Don't know" .r "Refused",add
label define labels92 .a "NA" .d "Don't know" .r "Refused",add


*recoding mental health:
recode m4 (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(m4_vge) label(m4_label_vge)

*------------------------------------------------------------------------------*
* Renaming variables 

drop m2_998 m2_999 m6_998 m6_999
ren rec* *

*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy recq33 q33_label2
label copy q50_label q50_label2
label copy recq51 q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q15_label recq33 q50_label q51_label

* fix labels for mental health module:
label copy labels76 m1_a_label
label copy labels77 m1_b_label
label copy labels78 m1_2_a_label
label copy labels79 m1_2_b_label
label copy labels80 m1_2_c_label
label copy labels81 m1_2_d_label
label copy labels82 m1_2_e_label
label copy labels83 m1_2_f_label
label copy labels84 m1_2_g_label
label copy labels86 m2_label
label copy labels89 m3_label
label copy labels90 m4_label
label copy labels91 m5_label
label copy labels92 m6_label
label copy labels95 m7_label
label copy labels96 m8_label
label copy labels97 m9_label
label copy labels98 m10_label
label copy labels99 m11_label
label copy labels100 m12_label

lab val m1_a m1_a_label
lab val m1_b m1_b_label
lab val m1_2_a m1_2_a_label
lab val m1_2_b m1_2_b_label
lab val m1_2_c m1_2_c_label
lab val m1_2_d m1_2_d_label
lab val m1_2_e m1_2_e_label
lab val m1_2_f m1_2_f_label
lab val m1_2_g m1_2_g_label

lab val m2_a m2_label 
lab val m2_b m2_label 
lab val m2_c m2_label 
lab val m2_d m2_label 
lab val m2_e m2_label 
lab val m2_f m2_label 
lab val m2_g m2_label
lab val m2_h m2_label 
lab val m2_i m2_label

lab val m3 m3_label
lab val m4 m4_label
lab val m5 m5_label
 
lab val m6_a m6_label
lab val m6_b m6_label
lab val m6_c m6_label
lab val m6_d m6_label
lab val m6_e m6_label
lab val m6_f m6_label
lab val m6_g m6_label
lab val m6_h m6_label
lab val m6_i m6_label
lab val m6_j m6_label

lab val m7 m7_label
lab val m8 m8_label
lab val m9 m9_label
lab val m10 m10_label
lab val m11 m11_label
lab val m12 m12_label

label drop labels76 labels77 labels78 labels79 labels80 labels81 labels82 labels83 labels84 labels86 labels89 labels90 labels91 labels92 labels95 labels96 labels97 labels98 labels99 labels100 

*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 


gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other"
	
gen q15_other_original = q15_other
label var q15_other_original "Q15. Other"

gen q16_other_original = q16_other
label var q16_other_original "Q16. Other"

gen q24_other_original = q24_other
label var q24_other_original "Q24. Other"

gen q30_other_original = q30_other
label var q30_other_original "Q30. Other"

gen q33_other_original = q33_other
label var q33_other_original "Q33. Other"
	
gen q34_other_original = q34_other
label var q34_other_original "Q34. Other"	

gen q50_other_original = q50_other 
label var q50_other_original "Q50. Other"	

gen q50a_us_other_original = q50a_us_other 
label var q50a_us_other_original "Q50a. Other"	

gen q52a_us_other_original = q52a_us_other 
label var q52a_us_other_original "Q52a. Other"	

gen m2_i_other_original = m2_i_other 
label var m2_i_other_original "M2_i. Other"	

gen m6_j_other_original = m6_j_other 
label var m6_j_other_original "M6_j. Other"	


foreach i in 12 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q15_other q16_other q24_other q30_other q33_other q34_other q37_other ///
	 q50_other q50a_us_other q52a_us_other m2_i_other m6_j_other
	 
ren q7_other_original q7_other
ren q15_other_original q15_other
ren q16_other_original q16_other
ren q24_other_original q24_other
ren q30_other_original q30_other
ren q33_other_original q33_other
ren q34_other_original q34_other
ren q50_other_original q50_other
ren q50a_us_other_original q50a_us_other
ren q52a_us_other_original q52a_us_other
ren m2_i_other_original m2_i_other
ren m6_j_other_original m6_j_other

*------------------------------------------------------------------------------*/

* Reorder variables
	order m1_a m1_b  m1_2_a m1_2_b m1_2_c m1_2_d m1_2_e m1_2_f m1_2_g m2_a m2_b m2_c m2_d ///
		  m2_e m2_f m2_g m2_h m2_i m2_i_other m3 m4 m5 m6_a m6_b m6_c m6_d m6_e m6_f m6_g m6_h ///
		  m6_i m6_j m6_j_other m7 m8 m9 m10 m11 m12 
	order q*, sequential
	order respondent_id respondent_serial wave country language date mode  // weight

*------------------------------------------------------------------------------*

* Save data
save "$data_mc/02 recoded data/input data files/pvs_us_wave2.dta", replace

*------------------------------------------------------------------------------*
