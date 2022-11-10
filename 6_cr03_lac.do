* TEMP file to recode LAC data 
* November 2022
* N. Kapoor

use "$data_mc/00 interim data/LAC interim data 10252022.dta", clear

*------------------------------------------------------------------------------*

* Fix interview length variable and other time variables 
* Edit this section to include other date and time variables as needed 

* Formatting time 
format time_new Q46 Q47 %tcHH:MM:SS


* Converting interview length to minutes so it can be summarized

generate int_length = (hh(IntLength)*3600 + mm(IntLength)*60 + ss(IntLength)) / 60


* Converting Q46 and Q47 to minutes so it can be summarized
generate Q46_min = (hh(Q46)*3600 + mm(Q46)*60 + ss(Q46)) / 60

generate Q47_min = (hh(Q47)*3600 + mm(Q47)*60 + ss(Q47)) / 60


*------------------------------------------------------------------------------*

global all_ref 		"Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14_NEW Q15_NEW Q16 Q17 Q18 Q19_PE Q19_UY Q19_CO Q20 Q21 Q22 Q23 Q24 Q25_A Q25_B Q26 Q27 Q28 Q28_NEW Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q39 Q40 Q41 Q42 Q43_PE Q43_UY Q43_CO Q44 Q45 Q46 Q47 Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F Q48_G Q48_H Q48_I Q48_J Q49 Q50_A Q50_B Q50_C Q50_D Q51 Q52 Q53 Q54 Q55 Q56_UY Q56_PE Q57 Q58 Q59 Q60 Q61 Q62 Q63 Q66 Q67"

global all_dk 		"Q23 Q25_A Q25_B Q27 Q28 Q28_NEW Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q38 Q63 Q66 Q67"
	
* Recode Refused and Don't know

recode $all_dk ($dk_num = .d)
* NK Note: Check these numbrs and check don't know 

recode $all_ref ($ref_num = .r)
	
*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked due to skip patterns

*Q1/Q2 
recode Q2 (. = .a) if Q1 != .r
recode Q1 (. = .r) if Q2 != .a

* Q7 
recode Q7 (. = .a) if Q6 == 2 | Q6 == .r 

* Q13 
recode Q13 (. = .a) if Q12 == 2 | Q12 == .r | Q12 == .d 

* Q15
recode Q15_NEW (. = .a) if Q14_NEW == 3 | Q14_NEW == 4 | Q14_NEW == 5 | Q14_NEW == .r


*Q19-22
recode Q19_PE Q19_UY Q19_CO Q20 Q21 Q22 (. = .a) if Q18 == 2 | Q18 == .r 
recode Q20 (. = .a) if Q19_PE == 4 | Q19_U == 4 | Q19_CO  == 4
* ^ check if that is necessary

* NA's for Q23-27 
recode Q24 (. = .a) if Q23 != .d | Q23 != .r
recode Q25_A (. = .a) if Q23 != 1
recode Q25_B (. = .a) if Q23 == 0 | Q23 == 1 | Q24 == 1 | Q24 == .r 
recode Q26 (. = .a) if Q23 == 0 | Q23 == 1 | Q24 == 1 | Q24 == .r 
recode Q27 (. = .a) if Q26 != 2

* Q31 & Q32
recode Q31 (. = .a) if Q3 == 1 | Q1 < 50 | Q2 == 1 | Q2 == 2 | Q2 == 3 | Q2 == 4 | Q1 == .r | Q2 == .r 
recode Q32 (. = .a) if Q3 == 1 | Q1 == .r | Q2 == .r

* Q42
recode Q42 (. = .a) if Q41 == 2 | Q41 == .r


* Q43-49 NA's
recode Q43 Q44 Q45 Q46 Q46_min Q46_refused Q47 Q47_min Q47_refused Q48_A Q48_B Q48_C Q48_D Q48_E Q48_F /// 
	   Q48_G Q48_H Q48_I Q48_J Q49 (. = .a) if Q23 == 0 | Q24 == 1 | Q24 == .r
	   
recode Q44 (. = .a) if Q43 == 4 | Q43 == .r

*Q46/Q47 refused
recode Q46 Q46_min (. = .r) if Q46_refused == 1
recode Q47 Q47_min (. = .r) if Q47_refused == 1



*Q66/67
recode Q67 (. = .a) if Q66 == 2 | Q66 == .d | Q66 == .r 
recode Q66 Q67 (. = .a) if mode == 2


*------------------------------------------------------------------------------*

* Drop any unwanted/empty variables 

* drop 
* Make sure no under 18 - TODD is this okay to do? 
drop if Q2 == 1 | Q1 < 18

*------------------------------------------------------------------------------*
* In IPA code they also check that "key" variable has no missing values, generate a short key variable, drop data based on date/time
*------------------------------------------------------------------------------*

* Relabeling - some of these labels don't output well to excel (generally due to the appostrophes in the label)
* Add any other variables if needed

*Q2 

lab var Q2 "Q2. Respondents age group"

*lab var Q62 "Q62. Respondents mother tongue or native language" 

