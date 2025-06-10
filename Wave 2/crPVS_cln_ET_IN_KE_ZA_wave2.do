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
import spss using "$data/ET IN KE ZA wave2/01 raw data/24-065373-01-02_Harvard_2024_Merged_weighted_SPSS.sav", case(lower)

*Label as wave 2 data:
gen wave = 2

*Deleting unneccessary vars:
drop shell_chainid dw_overall_relative rim_age rim_sex rim_region rim_education qc_short

drop q1_q2

*dropping interviewer vars:
drop ecs_id start_time end_time interviewer_id interviewer_gender interviewer_language time_new

*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

rename q7_a q7_ke

rename (q12a q12b) (q12_a q12_b)

rename (q27a q27b q27c q27d q27e q27f q27g q27h) (q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h)

rename (q28a q28b) (q28_a q28_b)

rename (q38a q38b q38c q38d q38e q38f q38g q38h q38i q38j q38k) ///
	   (q38_a q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k)
	   
rename (q40a q40b q40c q40d q41a q41b q41c) (q40_a q40_b q40_c q40_d q41_a q41_b q41_c)

*Edit income var - continue from V1.0 values, add "V1.0" to labels
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
		   (999 = 999 "Refused") (998 = 998 "Don't know"), gen(recq51)
		   
	
* Value 11 was 21 in wave 1 data and value 10 was 11 in wave 1 data, recoding here	(what is 10 and 22?)
recode q15 (1 = 1 "Health Post") (2	= 2 "Health center") (2	= 2 "Health center") ///
		   (3 = 3 "Primary hospital") (4 = 4 "General hospital") (5 = 5 "Referral/specialized hospital") ///
		   (6 = 6 "Lower clinic") (7 = 7 "Medium clinic") (8 = 8 "Higher or specialty clinic") ///
		   (9 = 9 "Hospital / Speciality centre") (11 = 21 "NGO/Faith-based hospital") ///
		   (10 = 11 "NGO /Faith-based health center/clinic") (12 = 12 "Government dispensary") ///
		   (13 = 13 "Government/district/county hospital") (14 = 14 "Government health center or clinic") ///
		   (15 = 15	"Community health worker or outreach") (16 = 16 "Mobile clinic") ///
		   (17 = 17 "Private clinic or doctor's office") (18 = 18 "Private medical center") ///
		   (19 = 19 "Private hospital") (20	= 20 "NGO faith-based clinic") (21 = 21 "NGO/faith-based hospital") ///
		   (23 = 23 "Mobile clinic") (24 = 24 "Ward-based outreach care") (25 = 25 "Health posts") ///
		   (26 = 26 "Department of health clinic") (27 = 27 "Municipal clinic") ///
		   (28 = 28 "Department of health community health centre") (29	= 29 "District hospital") ///
		   (30 = 30	"Department of health hospital (Regional, Tertiary and Central hospitals)") ///
		   (31 = 31	"General practitioner practices") (32 = 32 "Private clinics") (33 = 33 "Private health centres")  ///
		   (34 = 34 "Specialist private practices") (35	= 35 "Private hospital") (36 = 36 "Faith-based or mission clinic") ///
		   (37 = 37 "Faith-based or mission hospital") (67 = 67 "Sub-centre/Health and Wellness Centre") ///
		   (68 = 68 "Primary Health Centre") (69 = 69 "Community Health Centre") (70 = 70 "District Hospital") ///
		   (71 = 71 "Medical College") (72 = 72 "Informal Providers (RMP)") (73	= 73 "Private clinic") ///
		   (74 = 74 "Private nursing home") (75 = 75 "Private hospital") ///
		   (76 = 76 "Faith-based or charitable hospital (religion or sect-based facility") ///
		   (997	= 997 "Other, specify") (998 = 998 "Don't know") (999 = 999 "Refused"), gen(recq15)	
		   
recode q33 (1 = 1 "Health Post") (2	= 2 "Health center") (3	= 3 "Primary hospital") (4 = 4 "General hospital") ///
		   (5 = 5 "Referral/specialized hospital") (6 = 6 "Lower clinic") (7 = 7 "Medium clinic") ///
		   (8 = 8 "Higher or specialty clinic") (9 = 9 "Hospital/Speciality centre") ///
		   (11 = 21 "NGO/Faith-based hospital") (10 = 11 "NGO/Faith-based health center/clinic")  ///
		   (12 = 12 "Government dispensary") (13 = 13 "Government/district/county hospital") ///
		   (14 = 14	"Government health center or clinic") (15 = 15 "Community health worker or outreach") ///
		   (16 = 16 "Mobile clinic") (17 = 17 "Private clinic or doctor's office") (18 = 18 "Private medical center") ///
		   (19 = 19 "Private hospital") (20	= 20 "NGO faith-based clinic") (21 = 21 "NGO/faith-based hospital") ///
		   (23 = 23 "Mobile clinic") (24 = 24 "Ward-based outreach care") (25 = 25 "Health posts") ///
		   (26 = 26 "Department of health clinic") (27 = 27 "Municipal clinic") ///
		   (28	= 28 "Department of health community health centre") (29 = 29 "District hospital") ///
		   (30 = 30 "Department of health hospital (Regional, Tertiary and Central hospitals)") ///
		   (31 = 31 "General practitioner practices") (32 = 32 "Private clinics") (33 = 33 "Private health centres") ///
		   (34 = 34 "Specialist private practices") (35	= 35 "Private hospital") (36 = 36 "Faith-based or mission clinic") ///
		   (37 = 37 "Faith-based or mission hospital") (67 = 67 "Sub-centre/Health and Wellness Centre") ///
		   (68 = 68 "Primary Health Centre") (69 = 69 "Community Health Centre") (70 = 70 "District Hospital") ///
		   (71 = 71 "Medical College") (72 = 72 "Informal Providers (RMP)") (73	= 73 "Private clinic") ///
		   (74 = 74 "Private nursing home") (75	= 75 "Private hospital") ///
		   (76 = 76 "Faith-based or charitable hospital (religion or sect based facility)") ///
		   (997	= 997 "Other, specify") (998 = 998 "Don't know") (999 = 999 "Refused"), gen(recq33)
		   
drop q51 q15 q33
ren rec* *

* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

gen reclanguage = country*1000 + language  

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
replace recq51 = .r if q51== 999
replace recq51 = .d if q51== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

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


lab def Language  9004  "ZA: isiXhosa" ///
              9005  "ZA: isiZulu" ///
              9006  "ZA: Sepedi" ///
              4008  "IN: Bangla" ///
              4009  "IN: Kannada" ///
              9010  "ZA: Sesotho" ///
              4011  "IN: Tamil" ///
              9013  "ZA: Afrikaans" ///
              4014  "IN: Hindi" ///
              5015  "KE: Swahili" ///
              4018  "IN: Telugu" ///
              5021  "KE: English" ///
              9022  "ZA: English" ///
              4027  "IN: English" ///
              3077  "ET: Amharic" ///
              3083  "ET: Tigrinya" ///
              3100  "ET: Oromo" ///
              3104  "ET: Somali" 

lab values reclanguage Language

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
recode q14 q18 q21 q22 q23 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h ///
	   q32 cell1 cell2 q18_q19 (998 = .d)
	   
*NOTE: currently in data q37_za "don't know" is category 3  

* In raw data, 996 = "refused" 
recode q1 q3 q6 q9 q10 q11 q12_a q12_b q13 q14 q16 q17 q18 q19 q20 q21 ///
	   q22 q23 q24 q25 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a ///
	   q28_b q29 q30 q31a q31b q32 q34 q35 q36 q37 q38_a q38_b q38_c ///
	   q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b q40_c ///
	   q40_d q41_a q41_b q41_c q42 q43 q44 q45 q46 q47 q48 q49 cell1 ///
	   cell2 q6_za q18_q19 (999 = .r)	
	   
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
*N=8 people, ask Todd to confirm how I cleaned this:
replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months - Note: q28_a and q28_b in this dataset does not have this option
egen visits_total = rowtotal(q18_q19 q22 q23) 
list visits_total q17 if q17 == 5 & visits_total > 0 & visits_total < . | q17 == 5 & visits_total > 0 & visits_total < .
*SS: N=4 with issues, this is how we've fixed it in the past
recode q17 (5 = .r) if visits_total > 0 & visits_total < . // N=99 changes

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions

*q1/q2 - no missing data

* q7 
recode q7 (. = .a) if q6 !=1
recode q7 (nonmissing = .a) if q6 == 0

recode q7_ke (. = .a) if country !=5 | q7 !=3 | q7 !=5

*q14-17
recode q14 q15 q16 q17 (. = .a) if q13 !=1

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

* q32-33
recode q32 q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r

recode q36 q38_k (. = .a) if q35 !=1		

recode cell1 (. = .a) if mode !=1

recode cell2 (. = .a) if cell1 !=1
									 
*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense:

recode q14 (1 = 1 "Public") (2 = 2 "Private") (4 = 3 "NGO/Faith-based") ///
		   (997 = 4 "Other, specify") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q14_label)  	   
		   		   
recode q19 (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q19_label)		   

recode q24 (1 = 1 "Care for an urgent or new health problem such as an accident or injury or a new symptom like fever, pain, diarrhea, or depression.") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease such as hypertension or diabetes. This may include mental health conditions.") ///
		   (3 = 3 "Preventive care or a visit to check on your health, such as an annual check-up, antenatal care, or vaccination.")  ///
		   (997 = 4 "Other (specify)") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q24_label)	
		   
recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") ///
		   (8 = 8 "COVID-19 restrictions (e.g., lockdowns, travel restrictions, curfews)") ///
		   (9 = 9 "COVID-19 fear") ///
		   (997 = 10 "Other") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q30_label)
		   
recode q32 (1 = 1 "Public") (2 = 2 "Private") ///
           (3 = 3 "NGO/Faith-based") ///
		   (997 = 4 "Other (specify)") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q32_label)

recode q34 (1 = 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)") ///
		   (3 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") /// 
		   (997 = 4 "Other (specify)") (.a = .a "NA") ///
		   (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q34_label)				   
recode q45 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)		
		    
recode q38_e (0 = 0 "Poor") ///
			 (1 = 1 "Fair") ///
			 (2 = 2 "Good") /// 
			 (3 = 3 "Very good") ///
			 (4 = 4 "Excellent") ///
			 (5 = ".a")	///
			 (.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q38e_label)

recode q38_j (0 = 0 "Poor") ///
			 (1 = 1 "Fair") ///
			 (2 = 2 "Good") /// 
			 (3 = 3 "Very good") ///
			 (4 = 4 "Excellent") ///
			 (6 = ".a")	(.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q38j_label)

recode q40_a q40_b q40_c q40_d (0 = 0 "Poor") ///
			 (1 = 1 "Fair") ///
			 (2 = 2 "Good") /// 
			 (3 = 3 "Very good") ///
			 (4 = 4 "Excellent") ///
			 (6 = ".d")(.d = .d "Don't Know") (.r = .r "Refused"), pre(rec) label(q40_label)
	
drop q19 q14 q24 q30 q32 q34 q45 q38_e q38_j q40_a q40_b q40_c q40_d

label define labels7  .a "NA" .d "Don't know" .r "Refused",add	
label define labels10 .a "NA" .d "Don't know" .r "Refused",add
label define labels12 .a "NA" .d "Don't know" .r "Refused",add	
label define labels14 .a "NA" .d "Don't know" .r "Refused",add	
label define labels15 .a "NA" .d "Don't know" .r "Refused",add
label define labels16 .a "NA" .d "Don't know" .r "Refused",add	
label define labels17 .a "NA" .d "Don't know" .r "Refused",add
label define labels18 .a "NA" .d "Don't know" .r "Refused",add
label define labels19 .a "NA" .d "Don't know" .r "Refused",add
label define labels20 .a "NA" .d "Don't know" .r "Refused",add
label define q15_label .a "NA" .d "Don't know" .r "Refused",add
label define labels22 .a "NA" .d "Don't know" .r "Refused",add
label define labels23 .a "NA" .d "Don't know" .r "Refused",add
label define labels24 .a "NA" .d "Don't know" .r "Refused",add
label define labels25 .a "NA" .d "Don't know" .r "Refused",add
label define labels26 .a "NA" .d "Don't know" .r "Refused",add
label define labels27 .a "NA" .d "Don't know" .r "Refused",add
label define labels28 .a "NA" .d "Don't know" .r "Refused",add
label define labels29 .a "NA" .d "Don't know" .r "Refused",add
label define labels31 .a "NA" .d "Don't know" .r "Refused",add
label define labels32 .a "NA" .d "Don't know" .r "Refused",add
label define labels33 .a "NA" .d "Don't know" .r "Refused",add
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
label define labels45 .a "NA" .d "Don't know" .r "Refused",add
label define labels46 .a "NA" .d "Don't know" .r "Refused",add
label define q33_label .a "NA" .d "Don't know" .r "Refused",add
label define labels50 .a "NA" .d "Don't know" .r "Refused",add
label define labels51 .a "NA" .d "Don't know" .r "Refused",add
label define labels52 .a "NA" .d "Don't know" .r "Refused",add
label define labels53 .a "NA" .d "Don't know" .r "Refused",add
label define labels54 .a "NA" .d "Don't know" .r "Refused",add
label define labels55 .a "NA" .d "Don't know" .r "Refused",add
label define labels56 .a "NA" .d "Don't know" .r "Refused",add
label define labels57 .a "NA" .d "Don't know" .r "Refused",add
label define labels58 .a "NA" .d "Don't know" .r "Refused",add
label define labels59 .a "NA" .d "Don't know" .r "Refused",add
label define labels60 .a "NA" .d "Don't know" .r "Refused",add
label define labels61 .a "NA" .d "Don't know" .r "Refused",add
label define labels62 .a "NA" .d "Don't know" .r "Refused",add
label define labels63 .a "NA" .d "Don't know" .r "Refused",add
label define labels64 .a "NA" .d "Don't know" .r "Refused",add
label define labels65 .a "NA" .d "Don't know" .r "Refused",add
label define labels66 .a "NA" .d "Don't know" .r "Refused",add
label define labels67 .a "NA" .d "Don't know" .r "Refused",add
label define labels68 .a "NA" .d "Don't know" .r "Refused",add
label define labels69 .a "NA" .d "Don't know" .r "Refused",add
label define labels70 .a "NA" .d "Don't know" .r "Refused",add
label define labels71 .a "NA" .d "Don't know" .r "Refused",add
label define labels72 .a "NA" .d "Don't know" .r "Refused",add
label define labels73 .a "NA" .d "Don't know" .r "Refused",add
label define labels74 .a "NA" .d "Don't know" .r "Refused",add
label define labels76 .a "NA" .d "Don't know" .r "Refused",add
label define labels77 .a "NA" .d "Don't know" .r "Refused",add
label define labels78 .a "NA" .d "Don't know" .r "Refused",add
label define labels79 .a "NA" .d "Don't know" .r "Refused",add
label define q50_label .a "NA" .d "Don't know" .r "Refused",add
label define q51_label .a "NA" .d "Don't know" .r "Refused",add


*for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q33_label q33_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
lab val q33 q33_label2
lab val q51 q51_label2

label drop q4_label q5_label q33_label q51_label

*------------------------------------------------------------------------------*
* Renaming variables 
* Rename variables to match question numbers in current survey

ren rec* *

*Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country wave language date int_length weight

*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen q7_other_original = q7_other
label var q7_other_original "Q7_other. Other"

gen q14_other_original = q14_other
label var q14_other_original "Q14_other. Other"
	
gen q15_other_original = q15_other
label var q15_other_original "Q15. Other"

gen q16_other_original = q16_other
label var q16_other_original "Q16. Other"

gen q24_other_original = q24_other
label var q24_other_original "Q24. Other"

gen q30_other_original = q30_other
label var q30_other_original "Q30. Other"

gen q32_other_original = q32_other
label var q32_other_original "Q32. Other"

gen q33_other_original = q33_other
label var q33_other_original "Q33. Other"
	
gen q34_other_original = q34_other
label var q34_other_original "Q34. Other"	

gen q50_other_original = q50_other
label var q50_other_original "Q50. Other"	


foreach i in 3 4 5 9 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)							///	
	id(respondent_id)	
 
}	

drop q7_other q14_other q15_other q16_other q24_other q30_other q32_other ///
	 q33_other q34_other q50_other
	 
ren q7_other_original q7_other
ren q14_other_original q14_other
ren q15_other_original q15_other
ren q16_other_original q16_other
ren q24_other_original q24_other
ren q30_other_original q30_other
ren q32_other_original q32_other
ren q33_other_original q33_other
ren q34_other_original q34_other
ren q50_other_original q50_other

order q*, sequential
order respondent_serial respondent_id mode country language date int_length weight

*------------------------------------------------------------------------------*/

* Country-specific vars for append -
rename q14 q14_multi
rename q32 q32_multi
rename q44 q44_multi

*------------------------------------------------------------------------------*
* Label variables - double check matches the instrument					
lab var country "Country"
lab var weight "Weight"
lab var respondent_serial "Respondent Serial #"
lab var int_length "Interview length (minutes)" 
lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"
lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab var q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"
lab var q7_ke "Q7. KE only: Were you previously enrolled with NHIF before SHIF began on October 1, 2024?"
lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?" 
lab var q14_multi "Q14. Is this a public, private, NGO or faith-based facility?"
lab var q15 "Q15. What type of healthcare facility is this?"
label variable q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
label variable q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label variable q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label variable q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
lab var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label variable q20 "Q20. You said you made * visits. Were they all to the same facility?"
label variable q21 "Q21. How many different healthcare facilities did you go to in total?"
label variable q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label variable q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label variable q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
label variable q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label variable q26 "Q26. Stayed overnight at a facility in past 12 months (inpatient care)"
label variable q27_a "Q27a. Blood pressure tested in the past 12 months"
label variable q27_b "Q27b. Breast examination"
label variable q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label variable q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label variable q27_e "Q27e. Had your teeth checked in the past 12 months"
label variable q27_f "Q27f. Had a blood sugar test in the past 12 months"
label variable q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label variable q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label variable q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label variable q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label variable q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label variable q30 "Q30. The last time this happened, what was the main reason you did not receive healthcare?"
label variable q31a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label variable q31b "Q31b. Sell items to pay for healthcare"
label variable q32_multi "Q32. Was this a public, private, NGO or faith-based facility?"
label variable q33 "Q33. What type of healthcare facility was this?"
label variable q34 "Q34. What was the main reason you went?"
label variable q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label variable q36 "Q36. How long did you wait in days, weeks, or months between making the appointment and seeing the health care provider?"
label variable q37 "Q37. At this most recent visit, once you arrived at the facility, approximately how long did you wait before seeing the provider?"
label variable q38_a "Q38a. How would you rate the overall quality of care you received?"
label variable q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
label variable q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
label variable q38_d "Q38d. How would you rate the level of respect your provider showed you?"
label variable q38_e "Q38e. How would you rate your provider knowledge about your prior visits and test results?"
label variable q38_f "Q38f. How would you rate whether your provider explained things clearly?"
label variable q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
label variable q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
label variable q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
label variable q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
label variable q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
label variable q39 "Q39. How likely would recommend this facility to a friend or family member?"
label variable q40_a "Q40a. How would you rate the quality of care during pregnancy and childbirth like antenatal care, postnatal care"
label variable q40_b "Q40b. How would you rate the quality of childcare such as care of healthy children and treatment of sick children"
label variable q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label variable q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label variable q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label variable q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label variable q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label variable q42 "Q42. How would you rate the quality of government or public healthcare system in your country?"
label variable q43 "Q43. How would you rate the quality of the private for-profit healthcare system in your country?"
label variable q44_multi "Q44. How would you rate quality of NGO/faith-based healthcare system in your country?"
label variable q45 "Q45. Is your country's health system is getting better, staying the same or getting worse?"
label variable q46 "Q46. Which of these statements do you agree with the most?"
label variable q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label variable q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label variable q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label variable q50 "Q50. What is your native language or mother tongue?"
label variable q51 "Q51. Total monthly household income"
label var cell1 "Do you have another mobile phone number besides the one I am calling you on?"
label var cell2 "CELL2. 	How many other mobile phone numbers do you have?"

*------------------------------------------------------------------------------*
* Save data

save "$data_mc/02 recoded data/input data files/pvs_et_in_ke_za_wave2.dta", replace

*------------------------------------------------------------------------------*

