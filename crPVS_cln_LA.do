* People's Voice Survey data cleaning for Laos
* Last updated: February 2023
* N. Kapoor, E. Clarke-Deelder & A. Aryal 

************************************* Laos ************************************

* Import data 
use "$data/Laos/02 recoded data/pvs_clean_weighted_la.dta", clear
* use "J:\HEHS\HE\QuEST Laos\Data\Lao PVS\Clean data\Harmonized version\pvs_clean_weighted_v2.dta"
* global output "J:\HEHS\HE\QuEST Laos\PVS analysis\Output"

* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 

* Study ID 10089 was incorrectly listed as complete
drop if study_id == 10089

ren study_id respondent_serial
* NOTE: will create unique study ID upon merge 

encode cal_int, gen(interviewerid)
ren lang language

ren bd1101A q1
ren bd1102A q2
ren bd1103 q3 
ren bd1104A q4 
ren bd1105 q5
lab val q5 province 
* NOTE: bd1105 is province, ignore bd1105A
ren bd1106 q6_la 
ren bd1108 q8
ren hs1209 q9
ren hs1210 q10
ren hs1211 q11
ren hs1212 q12
ren hs1213 q13 
ren hs1214 q14_la
ren hs1215b q15_la 
ren pa1316 q16 
ren pa1317 q17

ren usc2118 q18a_la
ren usc2119 q19_q20a_la
ren usc2119a q19_q20a_other_la 
ren usc2120a q18b_la
ren usc2120b q19_q20b_la
ren usc2120a1 q19_q20b_other_la 
ren usc2121 q21
ren usc2121_oth q21_other
ren usc2122 q22
ren up22231 q23
ren up2224 q24
ren up2225a q25_a
ren up2225b1 q25_b
ren up2226 q26
ren up22271 q27
ren up2228A q28_a
ren up22281 q28_b
ren up2229 q29
ren sc2330 q30
ren sc2331 q31
ren sc2332 q32
ren sc2333 q33
ren sc2334 q34
ren sc2335 q35
ren sc2336 q36
ren sc2338 q38
ren sc2339 q39
ren sc2340 q40
ren sc2441 q41
ren sc2442 q42
ren sc2442_1 q42_other 

ren ue2443 q43
ren ue2444 q44
ren OTH_factype3 q44_other 
ren ue2445 q45
ren ue24451 q45_other
ren ue24462 q46
ren ue24471 q47
ren ue2448 q48_a
ren ue2449 q48_b
ren ue2450 q48_c
ren ue2451 q48_d
ren ue2452 q48_e
ren ue2453 q48_f
ren ue2454 q48_g
ren ue2455 q48_h
ren ue2456 q48_i
ren ue2457 q48_j
ren ue3258 q49

ren hsa4159 q50_a
ren hsa4160 q50_b
ren hsa4161 q50_c
ren hsa4162 q50_d
ren ohsa4263 q51
ren ohsa4264 q52
ren ohsa4265 q53
ren ohsa4266 q54
ren ohsa4267 q55
ren ohsa4271 q59
ren ohsa4269 q57 
ren ohsa4270 q58

gen q60 = ohsa4372_f 
recode q60 (. = 1) if ohsa4372_m == 1
recode q60 (. = 2) if ohsa4372_m == 2
recode q60 (. = 3) if ohsa4372_m == 3
recode q60 (. = 4) if ohsa4372_m == 4
recode q60 (. = 5) if ohsa4372_m == 5
lab val q60 qlty_rate 

gen q61 = ohsa4373_f 
recode q61 (. = 1) if ohsa4373_m == 1
recode q61 (. = 2) if ohsa4373_m == 2
recode q61 (. = 3) if ohsa4373_m == 3
recode q61 (. = 4) if ohsa4373_m == 4
recode q61 (. = 5) if ohsa4373_m == 5
lab val q61 qlty_rate 
ren ig4474 q62
ren ig4474_oth q62_other
*ren bd1102b q62a_la
ren bd1102btext q62a_other_la
ren ig4475 q63
ren wgt weight_educ

* NOTE: Education, urban/rural, and native language were asked twice to measure 
*		if people were alert 
*		bd1104A is urban/rural, bd1108 is education, bd1102b is ethnicity


*------------------------------------------------------------------------------*

* Interview length

* Interview length is  difference between timestamp_start and timestamp_finalsec
* Outliers are because of call backs  

format timestamp_start %tcHH:MM:SS
format timestamp_finalsec %tcHH:MM:SS 
gen start_min = (hh(timestamp_start)*3600 + mm(timestamp_start)*60 + ss(timestamp_start)) / 3600
gen end_min = (hh(timestamp_finalsec)*3600 + mm(timestamp_finalsec)*60 + ss(timestamp_finalsec)) / 3600
gen int_length = (end_min - start_min)*60
replace int_length = . if int_length < 0 | int_length > 90

gen date = dofc(timestamp_start)
format date %tdD_M_CY

*------------------------------------------------------------------------------*

* Drop unused variables 

drop if consent == .

drop cal_int SubmissionDate today deviceid o_lang new_lang consent ///
hs1211a bd1105A hs1211b usc2120c1 usc2120d1 usc2120e1 up2223 /// 
up2225b up2227 up2228 sc2340A sc2340A_oth ue2443a1 ue2443a3 ue2443b1 ue24431 ////
ue2448b1 ue2448b10 ue2448b11 ue2448b12 ue2448b2 ue2448b3 ue2448b4 ue2448b5 ///
ue2448b6 ue2448b7 ue2448b8 ue2448b9 ue2448b99 ue2448b_oth ue3258b ue3258b1 /// 
ue3258b10 ue3258b11 ue3258b12 ue3258b2 ue3258b3 ue3258b4 ue3258b5 ue3258b6 /// 
ue3258b7 ue3258b8 ue3258b9 ue3258b99  ue3258b_oth hsa4159A ohsa4263b ohsa4263b1 ///
ohsa4263b10 ohsa4263b11 ohsa4263b12 ohsa4263b2 ohsa4263b3 ohsa4263b4 ohsa4263b5 ///
ohsa4263b6 ohsa4263b7 ohsa4263b8 ohsa4263b9 ohsa4263b99 ohsa4263b_oth ig4476 ///
ig4477 ig4478 ig4479 ig4480 ig4481 ig4481A ig4481B rand_name ohsa4372_m ///
ohsa4373_m ohsa4373_f ohsa4372_f ig4482 ig4483 outcome1 outcome2 instanceID ///
instanceName rand_22util KEY FormVersion duplicated_id duplicated_id_2 start ///
ue2446 ue2447 end timestamp_consent timestamp_consent timestamp_Sec21 /// 
timestamp_Sec22 timestamp_Sec2324 timestamp_Sec3132 timestamp_Sec41 ///
timestamp_Sec4142 timestamp_Sec4344 timestamp_finalsec time_beforestart ///
time_consent time_Part1 time_Sec21 time_Sec22 time_Sec2324 time_Sec3132 ///
time_Sec41 time_Sec42 time_Sec4344 time_finalsec time_submission time_total ///
time_withrespondent time_unexplained visitsyr placesyr telmedyr outreachyr ///
age_cat malefemale region urbanrural edu_cat urbanrural_ed urbanrural_age ///
timestamp_Part1 start_min end_min usc2120d timestamp_start

* NOTE: need to fix date variable in correct date/time format for merge

*------------------------------------------------------------------------------*

* Generate variables 

* Respondent ID
gen respondent_id = "LA" + string(respondent_serial)

gen country = 11 
gen mode = 1
gen q56 = .a

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (.r = 2.5) (.d = 2.5) if q24 == 1
recode q23_q24 (.r = 7) (.d = 7) if q24 == 2
recode q23_q24 (.r = 10) (.d = 10) if q24 == 3
recode q23_q24 (.d = .r) if q24 == .r 

*------------------------------------------------------------------------------*

* Country-specific values and value labels 

gen reclanguage = country*1000 +language
gen recq5 = country*1000 + q5  
gen recq4 = country*1000 + q4
gen interviewer_id = country*1000 + interviewerid
gen recq8 = country*1000 + q8
replace recq8 = .r if q8== .r
gen recq44 = country*1000 + q44
replace recq44 = country*1000 + 995 if q44== 4
replace recq44 = .r if q44== .r
gen recq62 = country*1000 +q62
replace recq62 = country*1000 + 995 if q62 == 4
replace recq62 = .r if q62== .r
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== .r
replace recq63 = .d if q63== .d

* Q6/Q7 - LA specific
recode q6_la (1 = 11001 "LA: Additional private insurance") (2 = 11002 "LA: Only public insurance") (99 = .r "Refused"), gen(q7) label(q7_label)
recode bd1102b (1 = 11001 "LA: Lao-Tai") (2 = 11002 "LA: Mon-Khmer") (3 = 11003 "LA: Hmong-Mien") (4 = 11004 "LA: Chinese-Tibetan") (5 = 11005 "LA: Other"), gen(q62a_la) label(ethnicity)

label define language 11001 "LA: Lao" 11002 "LA: Khmou" 11003 "LA: Hmong", add
lab val reclanguage language

local q4l place
local q5l province
local q8l educ
local q44l fac_type3
local q62l lang
local q63l income

foreach q in q4 q5 q8 q44 q62 q63{
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
		local recvalue`q' = 11000+`: word `i' of ``q'val''
		foreach lev in ``q'level' {
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 11000+`: word `i' of ``q'val'') ///
										(`"LA: `gr`i''"'), modify
			}
		}         
	}
	
	label val rec`q' `q'_label
}

label define q8_label .r "Refused", add
label define q44_label 11995 "LA: Other" .a "NA" .r "Refused", add
label define q62_label 11995 "LA: Other".r "Refused", add
label define q63_label .r "Refused", add
label define fac_owner .a "NA" .r "Refused", add 
label define fac_choose .a "NA" .r "Refused", add
label define fac_type1 .a "NA" .r "Refused", add
label define place_type .a "NA" .r "Refused", add
label define hsys_trend .r "Refused", add

*------------------------------------------------------------------------------*

* Refused values :recoded refusal and don't know values from raw data in different file 

*------------------------------------------------------------------------------*

* Check for other implausible values 

* Q1/Q2
list q1 q2 if q2 == 0 | q1 < 18

* Q25
* Note: q23/q24 was supposed to be inclusive of COVID, so these are errors.
list q23 q24 q23_q24 q25_b country if q25_b > q23_q24 & q25_b < . // *Note: 2 implausible errors identified
replace q25_b = . if q25_b > q23_q24 & q25_b < .

* Q26/Q27
list q23_q24 q27 country if q27 > q23_q24 & q27 < . // * One potentially implausible value, where number of facilities is higher than number of visits
recode q27 (9 = 8) if q23_q24 == 8 & q27 == 9

list q26 q27 country if q27 == 0 | q27 == 1
list q26 q27 country if q26 == 1 & q27 > 0 & q27 < .
* This is okay 

*Q39/Q40 
egen visits_total = rowtotal(q23_q24 q28_a q28_b)

list q23_q24 q39 q40 country if q39 == .a & visits_total > 0 & visits_total < . /// 
							  | q40 == .a & visits_total > 0 & visits_total < .
* Recoding Q39 and Q40 to refused if it is .a but they have visit values in past 12 months 
recode q39 q40 (.a = .r) if visits_total > 0 & visits_total < .
* 85 changes made to q39; 86 changes made to q40

* Recoding Q39 and Q40 to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
list q23_q24 q39 q40 country if q39 != .a & visits_total == 0 /// 
							  | q40 != .a & visits_total == 0
							  
recode q39 q40 (1 = .a) (2 = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* Note: 114 changes made to q39; 116 changes made to q40

drop visits_total

*****************************

* recode any answer to .a if they said they had 0 visits in the past 12 months in q23
* note: their answers will be kept if they refused both q23 and q24
recode q43 recq44 q45 q46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (nonmissing  = .a) if q23 == 0

/*
341 changes made to q43
491 changes made to recq44
488 changes made to q45
482 changes made to q46
572 changes made to q46_refused
478 changes made to q47
572 changes made to q47_refused
519 changes made to q48_a
517 changes made to q48_b
514 changes made to q48_c
517 changes made to q48_d
509 changes made to q48_e
518 changes made to q48_f
516 changes made to q48_g
518 changes made to q48_h
518 changes made to q48_i
515 changes made to q48_j
508 changes made to q49
*/
*****************************

*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked due to skip patterns

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . // *change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q13 
recode q13 (. = .a) if q12 == 2  | q12==.r

* q15_la
recode q15_la (. = .a) if q14_la != 1
* NOTE: ONLY ASKED TO PEOPLE WHO SAID 0 DOSES 

*q19-22
recode q19_q20a_la q18b_la (.=.r) if q18a_la == .r // refused to answer this sequence of questions
recode q19_q20a_la q18b_la q19_q20b_la q21 q22 (. = .a) if q18a_la == 2 // no usual source of care
recode q18b_la q19_q20b_la (. = .a) if inrange(q19_q20a_la,1,4) | q19_q20a_la == 6  // questions about a second usual source of care were only asked if the first usual source of care was a pharmacy, traditional healer, or other

recode q21 q22 q19_q20b_la (. = .a) if q18b_la == 2 // no usual source of care other than pharmacy or traditional healer 
recode q21 q22 q19_q20b_la (. = .a) if q18a_la==.r | q18b_la == .r // refused to answer about usual source of care, so not eligible for this sequence of questions 

* NOTE: People who answered pharmacy, traditional healer, or OTH to usc2119
*		were asked usc2120a. Those with empty usc2120a means that the person either
*		refused or did not answer the question.*/

* NA's for q24-27 
recode q24 (. = .a) if q23 != .d & q23 != .r & q23 != .
recode q25_a (. = .a) if q23 != 1 & q23 != .
* No 0 for q24  (option 1)
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == .r
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == .r
recode q27 (. = .a) if q26 == 1 | q26 == .r | q26 == .a 

* EC Note: We are missing 11 responses for q23, q24, q25_b, q26, q27, q28b, and q29 because people were randomized not to answer this section. (We meant to turn this off after the pilot, but made a mistake when we first started full data collection)

* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r // *Shalom-there is no "1" for q2 in this dataset.. it starts from 2 (18-29),should i update the inrange command or does this not matter?

recode q32 (. = .a) if q3 != 2 | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41==.r

* q43-49 na's
* Mia: there are 22 people who have . for both q23 and 24 but answered questions -Shalom only seeing 11 people, ask Mia to confirm if she also sees N=11 now
recode q43 recq44 q45 q46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == .r 

*Q46/q47
recode q46 (. = .r) if q46_refused==1 
recode q47 (. = .r) if q47_refused==1
recode q46_refused (. = 0) if q46 != .
recode q47_refused (. = 0) if q47 != .

*Q43/Q44
recode q43 (. = .a) if recq44 != 1

*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q6_la q11 q12 q13 q18a_la q18b_la q25_a q26 q29 q41 q46_refused q47_refused ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)

recode q30 q31 q32 q33 q34 q35 q36 q38 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.d = .d "Don't know") /// 
	   (.a = .a NA), ///
	   pre(rec) label(yes_no_dk)

* NOTE: No don't know 

recode q39 q40 /// 
	   (1 = 1 Yes) (2 = 0 No) ///
	   (.a = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r Refused), ///
	   pre(rec) label(yes_no_na)
	   
	   
* All Excellent to Poor scales

recode q9 q10 q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	   
recode q22  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) (5 = 0 Poor) /// 
	   (.a = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q48_e ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode q48_j ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q50_a q50_b q50_c q50_d ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (6 = .d "I am unable to judge") (.r = .r Refused) ///
	   (.a = .a NA), /// 
	   pre(rec) label(exc_poor_judge)

* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)
	   
* Miscellaneous questions with unique answer options

*recode interviewer_gender ///
*	(1 = 0 Male) (2 = 1 Female), ///
*	pre(rec) label(int_gender)

recode q2 (2 = 0 "18 to 29") (3 = 1 "30-39") (4 = 2 "40-49") (5 = 3 "50-59") ///
		  (6 = 4 "60-69") (7 = 5 "70-79") (8 = 6 "80+") (.r = .r "Refused") ///
		  (.a = .a "NA"), pre(rec) label(age_cat)

recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (3 = 2 "Another gender") (.r = .r Refused), ///
	pre(rec) label(gender)

* NOTE: This vaccine question is slightly different - looks like asked up to 5 and more, no data for beyond 4 doses as of 4/11

recode q14_la ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "4 doses") (6 = 5 "More than 4 doses") (7 = .r "Refused") (.r = .r "Refused"), ///
	pre(rec) label(covid_vacc_la)
	
* NOTE: This was potentially only asked to people with 0 doses - other countries asked for 0 or 1 

recode q15_la /// 
	   (1 = 1 "Yes") ///
	   (2 = 0 "No") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses_la)
	   
recode q24 ///
	(0 = 0 "0") (1 = 1 "1-4") (2 = 2 "5-9") (3 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)
	
recode q45 ///
	(1 = 1 "Care for an urgent or acute health problem (accident or injury, fever, diarrhea, or a new pain or symptom)" ) ///
	(2 = 2 "Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes; mental health conditions") ///
	(3 = 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)") ///
	(.a = .a "NA") (4 = 4 "Other, specify") (.r = .r "Refused"), ///
	pre(rec) label(main_reason)
	
recode q49 ///
	(0 = 0 "0") (1 = 1 "1") (2 = 2 "2") (3 = 3 "3") (4 = 4 "4") (5 = 5 "5") ///
	(6 = 6 "6") (7 = 7 "7") (8 = 8 "8") (9 = 9 "9") (10 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	
******** COUNTRY-SPECIFIC items for append ********
* NOTE: We have only received data from Ipsos so far, so the value labels are programmed to include all of countries being fielded by Ipsos 
* For Laos, for now, recoded the values to start after Ipsos countries and then re-label the values on append 

* Q21
recode q21 (10 = 9) (90 = .r) // *why are we recoding "other(10)" to "know someone at the facility?(9)" - should we do what we did for AR and add a LA-specific value ("LA:Know someone at the facility")? If not, we would need to do the same for AR and recode the AR specific value to "Other"
label define fac_choose 9 "Other", modify

*------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents
drop q2 q3 q4 q5 q6_la q8 q11 q12 q13 q18a_la q18b_la q25_a q26 q29 q41 q45 q30 q31 /// 
	 q32 q33 q34 q35 q36 q38 q39 q40 q44 q9 q10 q22 q48_a q48_b q48_c q48_d ///
	 q48_f q48_g q48_h q48_i q54 q55 q56 q59 q60 q61 q48_e q48_j q50_a q50_b ///
	 q50_c q50_d q16 q17 q51 q52 q53 q3 q14_la q15_la q24 q49 q57 language q62 q63 ///
	 interviewerid q46_refused q47_refused bd1102b

ren rec* *


* Label variables 

* lab var int_length "Interview length (in minutes)"
* lab var interviewer_gender "Interviewer gender"
lab var q1 "Q1. Respondent еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
lab var q4 "Q4. Type of area where respondent lives"
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6_la "Q6. LA only: Do you have private health insurance that you or your family...?"
lab var q7 "Q7. What type of health insurance do you have?"
* lab var q7_other "Q7_other. Other type of health insurance"
lab var q8 "Q8. Highest level of education completed by the respondent"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"
lab var q13 "Q13. Was it confirmed by a test?"
lab var q14_la "Q14. LA only: How many doses of COVID-19 vaccine have you received?" 
lab var q15_la "Q15. LA only: If a vaccine becomes available, do you plan to get vaccinated?" 
lab var q16 "Q16. How confident are you that you are responsible for managing your health?"
lab var q17 "Q17. Can tell a healthcare provider your concerns even when not asked?"
lab var q18a_la "Q18A. LA only: Is there one place you usually...? (incl pharm, traditional)"
lab var q19_q20a_la "Q19A. LA only: What type of place is this?"
lab var q19_q20a_other_la "Q19A. LA only: Other"
lab var q18b_la "Q18B. LA only: Is there one hospital, health center, or clinic you usually...?"
lab var q19_q20b_la "Q19B. LA only: What type of healthcare facility is this?"
lab var q19_q20b_other_la "Q19B. LA only: Other"
lab var q21 "Q21. Why did you choose this healthcare facility?"
lab var q21_other "Q21. Other"
lab var q22 "Q22. Overall respondent's rating of the quality received in this facility"
lab var q23 "Q23. How many healthcare visits in total have you made in the past 12 months?"
lab var q23_q24 "Q23/Q24. Total mumber of visits made in past 12 months (q23, q24 mid-point)"
lab var q24 "Q24. Total number of healthcare visits in the past 12 months (range)"
lab var q25_a "Q25_A. Was this visit for COVID-19?"
lab var q25_b "Q25_B. How many of these visits were for COVID-19? "
lab var q26 "Q26. Were all of the visits you made to the same healthcare facility?"
lab var q27 "Q27. How many different healthcare facilities did you go to?"
lab var q28_a "Q28_A. How many visits did you have with a healthcare provider at your home?"
lab var q28_b "Q28_B. How many virtual or telemedicine visits did you have?"
lab var q29 "Q29. Did you stay overnight at a healthcare facility as a patient?"
lab var q30 "Q30. Blood pressure tested in the past 12 months"
lab var q31 "Q31. Received a mammogram in the past 12 months"
lab var q32 "Q32. Received cervical cancer screening, like a pap test or visual inspection"
lab var q33 "Q33. Had your eyes or vision checked in the past 12 months"
lab var q34 "Q34. Had your teeth checked in the past 12 months"
lab var q35 "Q35. Had a blood sugar test in the past 12 months"
lab var q36 "Q36. Had a blood cholesterol test in the past 12 months"
lab var q38 "Q38. Received care for depression, anxiety, or another mental health condition"
lab var q39 "Q39. A medical mistake was made in your treatment or care in the past 12 months"
lab var q40 "Q40. You were treated unfairly or discriminated against in the past 12 months"
lab var q41 "Q41. Have you needed medical attention but you did not get it in past 12 months?"
lab var q42 "Q42. The last time this happened, what was the main reason?"
lab var q42_other "Q42. Other"
lab var q43 "Q43. Last healthcare visit in a public, private, or NGO/faith-based facility?"
*lab var q43_other "Q43. Other"
lab var q44 "Q44. What type of healthcare facility is this?"
lab var q44_other "Q44. Other"
lab var q45 "Q45. What was the main reason you went?"
lab var q45_other "Q45. Other"
lab var q46_refused "Q46. Refused"
lab var q46 "Q46. In minutes: Approximately how long did you wait before seeing the provider?"
lab var q47_refused "Q47. Refused"
lab var q47 "Q47. In minutes: Approximately how much time did the provider spend with you?"
lab var q48_a "Q48_A. How would you rate the overall quality of care you received?"
lab var q48_b "Q48_B. How would you rate the knowledge and skills of your provider?"
lab var q48_c "Q48_C. How would you rate the equipment and supplies that the provider had?"
lab var q48_d "Q48_D. How would you rate the level of respect your provider showed you?"
lab var q48_e "Q48_E. How would you rate your provider knowledge about your prior visits?"
lab var q48_f "Q48_F. How would you rate whether your provider explained things clearly?"
lab var q48_g "Q48_G. How would you rate whether you were involved in your care decisions?"
lab var q48_h "Q48_H. How would you rate the amount of time your provider spent with you?"
lab var q48_i "Q48_I. How would you rate the amount of time you waited before being seen?"
lab var q48_j "Q48_J. How would you rate the courtesy and helpfulness at the facility?"
lab var q49 "Q49. How likely would recommend this facility to a friend or family member?"
lab var q50_a "Q50_A. How would you rate the quality of care provided for care for pregnancy?"
lab var q50_b "Q50_B. How would you rate the quality of care provided for children?"
lab var q50_c "Q50_C. How would you rate the quality of care provided for chronic conditions?"
lab var q50_d "Q50_D. How would you rate the quality of care provided for the mental health?"
lab var q51 "Q51. How confident are you that you'd get good healthcare if you were very sick?"
lab var q52 "Q52. How confident are you that you'd be able to afford the care you requiered?"
lab var q53 "Q53. How confident are you that the government considers the public's opinion?"
lab var q54 "Q54. How would you rate the quality of public healthcare system in your country?"
lab var q55 "Q55. How would you rate the quality of private healthcare?"
lab var q56 "Q56. How would you rate the quality of the NGO or faith-based healthcare?"
lab var q57 "Q57. Is your country's health system is getting better, same or worse?"
lab var q58 "Q58. Which of these statements do you agree with the most?"
lab var q59 "Q59. How would you rate the government's management of the COVID-19 pandemic?"
lab var q60 "Q60. How would you rate the quality of care provided? (Vignette, option 1)"
lab var q61 "Q61. How would you rate the quality of care provided? (Vignette, option 2)"
lab var q62 "Q62. Respondent's mother tongue or native language"
lab var q62_other "Q62. Other"
lab var q62a_la "Q62a. LA ONLY: What is your ethnicity?"
lab var q62a_other_la "Q62a. LA only: Other"
lab var q63 "Q63. Total monthly household income"
*lab var q64 "Q64. Do you have another mobile phone number besides this one?"
*lab var q65 "Q65. How many other mobile phone numbers do you have?"

order respondent_serial respondent_id country language date int_length interviewer_id mode weight q1 q2 q3 q4 q5 q6_la q7 q8 q9 q10 q11 q12 q13 q14_la q15_la q16 q17 q18a_la q19_q20a_la q19_q20a_other q18b_la q19_q20b_la q19_q20b_other q21 q21_other q22 q23 q24 q23_q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q42_other q43 q44 q44_other q45 q45_other q46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56 q57 q58 q59 q60 q61 q62 q62_other q62a_la q62a_other_la q63 

save "$data_mc/02 recoded data/pvs_la.dta", replace
save "$data/Laos/02 recoded data/pvs_harmonized_la.dta", replace
*save "J:\HEHS\HE\QuEST Laos\Data\Lao PVS\Clean data\Harmonized version\pvs_laos_harmonized.dta", replace 


/*
*------------------------------------------------------------------------------*

* Missing data check 

* Below I summarize NA (.a), Don't know (.d), Refused (.r) and true Missing (.) 
* across the numeric variables(only questions) in the dataset by country

global all_dk 	"q23 q25_a q25_b q27 q28_a q28_b q30 q31 q32 q33 q34 q35 q36 q38 q50_a q50_b q50_c q50_d q63"
global all_num 	"q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18a_la q19_q20a_la q18b_la q19_q20b_la q21 q22 q23 q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q43 q44 q45 q46 q46_refused q47 q47_refused q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q57 q58 q59 q60 q61 q62 q63"
gl dq_output	"$output/dq_output_la.xlsx"
   
* Count number of NA, Don't know, and refused across the row 
ipaanycount $all_num, gen(na_count) numval(.a)
ipaanycount $all_dk, gen(dk_count) numval(.d)
ipaanycount $all_num, gen(rf_count) numval(.r)

* Count of total true missing 
egen all_missing_count = rowmiss($all_num)
gen missing_count = all_missing_count  - (na_count + dk_count + rf_count)


* Denominator for percent of NA and Refused 
egen nonmissing_count = rownonmiss($all_num)
gen total_miss = all_missing_count + nonmissing_count

* Denominator for percent of Don't know 
egen dk_nonmiss_count = rownonmiss($all_dk) 
egen dk_miss_count = rowmiss($all_dk) 
gen total_dk = dk_nonmiss_count + dk_miss_count 


preserve

collapse (sum) na_count dk_count rf_count missing_count total_miss total_dk, by(country)
gen na_perc = na_count/total_miss
gen dk_perc = dk_count/total_dk
gen rf_perc = rf_count/total_miss
gen miss_perc = missing_count/total_miss 
lab var na_perc "NA (%)" 
lab var dk_perc "Don't know (%)"
lab var rf_perc "Refused (%)"
lab var miss_perc "Missing (%)"
export exc country na_perc dk_perc rf_perc miss_perc using "$dq_output", sh(missing, replace) first(varl)

restore 

* EC note: reviewing which variables have unexplained missings:
foreach var in q1 q2 q3 q4 q5 q6 q7 q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18a_la q19_q20a_la q18b_la q19_q20b_la  q21 q22 q23 q24 q25_a q25_b q26 q27 q28_a q28_b q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 q42 q43 q44 q45 q46 q47 q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q49 q50_a q50_b q50_c q50_d q51 q52 q53 q54 q55 q56 q57 q58 q59 q60 q61 q62 q63 {
	egen `var'_missing =  total(`var'==.)
}

tab1 *_missing
drop *_missing

* EC note: the remaining unexplained missings almost all have to do with the randomization error (affecting 11 observations for q23, q24, q25_b, q26, q27, q28a, q28b, and q29). I'm not sure how to explain the unexplained missings for q7 and q16, but there are very few of them (between 1 and 3 per variable).

