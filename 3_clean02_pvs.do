* PVS Additional Cleaning
* September 2022
* N. Kapoor & R. B. Lobato

u "$clean01survey", clear 

****** Renaming variables, recoding value labels, and labeling variables ******

***************************** Renaming variables *****************************  
ren Q28 Q28_A
ren Q28_NEW Q28_B

***************************** Recode value labels ***************************** 

* All Yes/No questions
recode Q6 Q11 Q12 (2 = 0) 

lab de yes_no 1 "Yes" 0 "No" .r "Refused" .d "Don't know", replace

lab val Q6 Q11 Q12 yes_no

* Another way to do this 
decode Q6

* All Excellent to Poor scales

recode Q9 (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0)

lab de exc_pr 4 "Excellent" 3 "Very Good" 2 "Good" 1 "Fair" 0 "Poor" /// 
				.a "NA" .d "Don't know" .r "Refused"
				
lab val Q9 exc_pr

* All Very Confident to Not at all Confident scales 


* Other questions 
* COVID doses question 

*Q49
decode Q49, gen(Q49_new)
destring Q49_new,replace
recode Q49_new (. = .a) if Q23 == 0 | Q24 == 1 | Q24 == .r 
recode Q49_new (. = .r) if Q49 == .r

***************************** Labeling variables ***************************** 
* Ask Todd about variable labels? 
lab var Q6 "Q6. Do you have health insurance?"


* NK Note: Will have to figure out what to do with Other, specify data 
