
use "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/pvs_all_countries_v2_9-17-24.dta", clear
* Note - dataset was saved to MH Analysis folder on 9/17 because countries and country order was changing 

* Country and region vars 

tab country_reg, gen(country_reg)
rename (country_reg1 country_reg2 country_reg3 country_reg4 country_reg5 ///
		country_reg6 country_reg7 country_reg8 country_reg9 country_reg10 ///
		country_reg11 country_reg12 country_reg13 country_reg14 ///
		country_reg15 country_reg16 country_reg17 country_reg18) ///
		(Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay ///
		 Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom ///
		 United_States)

global countries Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom United_States

recode country_reg (1 2 3 4 = 1 "Africa") (5 6 7 8 9 = 2 "Latin America") ///
				   (10 11 12 13 = 3 "Asia") (14 15 16 17 18 = 4 "Europe and US"), ///
				   gen(region2)

* Variable recoding

* Mental health

recode health_mental (0 1 = 0 "Poor/Fair") (2 3 4 = 1 "Good/Very good/Excellent") (.r = .r "Refused"), ///
	   gen(health_mental_gvge) label(health_mental_gvge)
	   
lab var health_mental_gvge "Self-rated mental health - GVGE"

recode health_mental (0 1 = 1 "Poor/Fair") (2 3 4 = 0 "Good/Very good/Excellent") (.r = .r "Refused"), ///
	   gen(health_mental_pf) label(health_mental_pf)
	   
lab var health_mental_pf "Self-rated mental health - PF"

* Public primary care for mental health 
	 
recode phc_mental (0 1 = 0 "Poor/Fair") (2 3 4 = 1 "Good/Very good/Excellent") ( .d .r = .r "Refused"), /// 
	   gen(phc_mental_gvge) 
	   
recode qual_public (0 1 = 0 "Poor/Fair") (2 3 4 = 1 "Good/Very good/Excellent") (.d .r = .r "Refused"), /// 
	   gen(qual_public_gvge) 
	   
recode qual_private (0 1 = 0 "Poor/Fair") (2 3 4 = 1 "Good/Very good/Excellent") (.d .r = .r "Refused"), /// 
	   gen(qual_private_gvge) 

* Confidence considers opinion 	   
recode conf_opinion (0 1 = 0 "Not at all / Not too confident") ///
	    (2 3 = 1 "Somewhat or very confident") (.d .r = .r "Refused"), /// 
	   gen(conf_opinion_sv) 

	   
* Health 

recode health (0 1 = 0 "Poor/Fair") (2 3 4 = 1 "Good/Very good/Excellent") (.r = .r "Refused"), /// 
	   gen(health_gvge) 
	   
recode health (0 1 = 1 "Poor/Fair") (2 3 4 = 0 "Good/Very good/Excellent") (.r = .r "Refused"), ///
	   gen(health_pf) label(health_pf)
	   
lab var health_pf "Self-rated health - GVGE / PF"

* Education 
	   
recode education (0 1 = 0 "None or Primary") (2 3 = 1 "Secondary/Post-secondary") ( .r = .r "Refused"), /// 
	   gen(educ) 
	   
recode education (0 1 2 = 0 "None, Primary or Secondary") (3 = 1 "Post-secondary or higher") ( .r = .r "Refused"), /// 
	   gen(educ2)
	   
lab var educ2 "Highest level of education completed"	   

* usual_qual

recode usual_quality (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   ( 5 .a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_vge) label(exc_pr_hlthcare_2)
	   
lab var usual_quality_vge "VGE: Overall quality rating of usual source of care (Q22)"

* last_qual	   
	   
recode last_qual (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_vge) label(exc_pr_2)

lab var last_qual_vge "VGE: Last visit rating: overall quality (Q48A)"

* last_skills 

recode last_skills (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_skills_vge) label(exc_pr_2)

lab var last_skills_vge "VGE: Last visit rating: knowledge and skills of provider"

* last_supplies 

recode last_supplies (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_supplies_vge) label(exc_pr_2)

lab var last_supplies_vge "VGE: Last visit rating: equipment and supplies provider had available"

* last_respect 


recode last_respect (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_respect_vge) label(exc_pr_2)

lab var last_respect_vge "VGE: Last visit rating: provider respect"

* last_know 

recode last_know (0 1 2 = 0 "Poor/Fair/Good") (3 4 5= 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_know_vge) label(exc_pr_2)

lab var last_know_vge "VGE: Last visit rating: knowledge of prior tests and visits"

* last_explain 

recode last_explain (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_explain_vge) label(exc_pr_2)

lab var last_explain_vge "VGE: Last visit rating: explained things in a way you could understand"

* last_decisions 

recode last_decisions (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_decisions_vge) label(exc_pr_2)

lab var last_decisions_vge "VGE: Last visit rating: involved you in decisions"

* last_visit_rate 

recode last_visit_rate (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_visit_rate_vge) label(exc_pr_2)

lab var last_visit_rate_vge "VGE: Last visit rating: amount of time provider spent with you"


* last_wait_rate 

recode last_wait_rate (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_wait_rate_vge) label(exc_pr_2)

lab var last_wait_rate_vge "VGE: Last visit rating: amount of time you waited before being seen"

* last_courtesy

recode last_courtesy (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (6 .r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_courtesy_vge) label(exc_pr_2)

lab var last_courtesy_vge "VGE: Last visit rating: courtesy and helpfulness of the staff"

* phc_mental

recode phc_mental(0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (5 .r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_vge) label(exc_pr_judge_2)	  

lab var phc_mental_vge "VGE: Public primary care system rating for: mental health (Q50D)"

* qual_private  
recode qual_private (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_vge) label(exc_pr_2)

lab var qual_private_vge "VGE:  Overall quality rating of private healthcare system in country (Q55)"

* qual_public
recode qual_public (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_vge) label(exc_pr_2)
	   
lab var qual_public_vge "VGE: Overall quality rating of gov or public healthcare system in country (Q54)"

   
* covid_manage
recode covid_manage (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_vge) label(exc_pr_2)

lab var covid_manage_vge "VGE: Rating of the government's management of the COVID-19 pandemic (Q59)"   
	   
* system outlook
recode system_outlook ///
	(1 2 = 0 "Staying the same/Getting worse") (3 = 1 "Getting better") ///
	(.r = .r "Refused") , gen(system_outlook_getbet) label(system_outlook2)

lab var system_outlook_getbet "Health system getting better (Q57)"	

* system reform
recode system_reform ///
	(1 2 = 0 "Major changes/Rebuilt") (3 = 1 "Minor changes") ///
	(.r = .r "Refused") , gen(system_reform_minor) label(system_reform2)

lab var system_reform_minor "System works well, only minor changes needed (Q58)"

*conf_opinion

recode conf_opinion ///
	   (3 2 = 1 "Somewhat confident/Very confident") ///
	   (0 1 = 0 "Not too confident/Not at all confident") /// 
	   (.r = .r Refused) (.a = .a na), /// 
	   gen(conf_opinion_scvc) label(vc_nc_der)		
	   
lab var conf_opinion_scvc "SCVC: Confidence that the gov considers public's opinion when making decisions (Q53)"

*q12_a
recode q12_a ///
	   (3 2 = 1 "Somewhat confident/Very confident") ///
	   (0 1 = 0 "Not too confident/Not at all confident") /// 
	   (.r = .r Refused) (.a = .a na), /// 
	   gen(pat_act_1) 
	
lab var pat_act_1 "Responsible for managing own health - patient activation"

*q12_b
recode q12_a ///
	   (3 2 = 1 "Somewhat confident/Very confident") ///
	   (0 1 = 0 "Not too confident/Not at all confident") /// 
	   (.r = .r Refused) (.a = .a na), /// 
	   gen(pat_act_2) 
	     
lab var pat_act_2 "Can tell a healthcare provider concerns - patient activation"

* Telehealth visits 

gen more_than_one_tele = 1 if visits_tele > 0 & visits_tele < .
recode more_than_one_tele (. = 0) if visits_tele == 0
lab def tele 0 "None" 1 "More than one visit"
lab val more_than_one_tele tele

lab var more_than_one_tele "More than one tele-health visit"

* Poor mental health - received care 

gen poormh_care = 1 if health_mental_pf == 1 & care_mental == 1
recode poormh_care (. = 0) if health_mental_pf == 1 & care_mental == 0

lab var poormh_care "Poor mental health and received care"
lab def poormh_care 0 "Poor mental health and did not receive care" 1 "Poor mental health and received care" ///
					2 "Good mental health and did not receive care" 3 "Good mental health and received care"
lab val poormh_care poormh_care

clonevar poormh_care_cat = poormh_care  
recode poormh_care_cat (. = 2) if health_mental_pf == 0 & care_mental == 0
recode poormh_care_cat (. = 3) if health_mental_pf == 0 & care_mental == 1

* Age categories

recode age_cat (1 = 1 "18-29") (2 3 = 2 "30-49") (4 5 6 7 = 3 "50+"), gen(age_cat2) 
lab var age_cat2 "Age"

* Gender
recode gender (0 = 0 "Male") (1 2 = 1 "Female or another gender"), gen(gender2)
lab var gender2 "Gender"

* Some checks

tab health_mental [aweight=weight]
tab care_mental [aweight=weight]
tab phc_mental [aweight=weight]

tab  gender health_mental_pf [aweight=weight] if country_reg == 1, col

tab  health_mental_pf [aweight=weight] if country_reg == 1
tab  health_mental_pf [aweight=weight] if country_reg == 2

tab  health_mental_pf country_reg [aweight=weight], col 


tab last_visit_rate health_mental_pf [aweight=weight] if country_reg == 1, col

tab poormh_care country_reg [aweight=weight], col

*import excel "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/GDP_Per_cap_PPP_WB_0428.xls", sheet("gdp") firstrow clear
* save "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/gdp_data.dta", replace

merge m:1 country_reg using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/gdp_data.dta"

* Country ordered by GDP 
* Recode the country variable based on GDP order
recode country (12 = 1 "US")  /// United States
              (17 = 2 "GB")  /// United Kingdom
              (14 = 3 "IT")  /// Italy
              (15 = 4 "KR")  /// Republic of Korea
              (19 = 5 "RO")  /// Romania
              (18 = 6 "GR")  /// Greece
              (10 = 7 "UY")  /// Uruguay
              (16 = 8 "AR")  /// Argentina
              (13 = 9 "MX")  /// Mexico
              (21 = 10 "CN") /// China
              (2 = 11 "CO")  /// Colombia
              (7 = 12 "PE")  /// Peru
              (9 = 13 "ZA")  /// South Africa
              (4 = 14 "IN")  /// India
              (11 = 15 "LA") /// Lao PDR
              (5 = 16 "KE")  /// Kenya
              (20 = 17 "NG") /// Nigeria
              (3 = 18 "ET")  /// Ethiopia
, generate(country_gdp)

* Calculate weighted counts for each category
bysort country: egen total_weight = total(weight)
bysort country: egen weighted_health_mental_pf = total(weight * health_mental_pf)

* Generate weighted percentage
gen percent_health_mental_pf = (weighted_health_mental_pf / total_weight) * 100

* Calculate total weighted counts for poormh_care
bysort country: egen weighted_poormh_care = total(weight * poormh_care)

* Generate weighted percentage for poormh_care
gen percent_poormh_care = (weighted_poormh_care / total_weight) * 100

********************************************************************************


* FIG 1A

summtab2 ,  by(country_gdp) vars(health_mental_pf) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_1A) sheetname(data) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 

* For FIG 1A CI's 
svyset psu_id_for_svy_cmds, weight(weight)		   
svy: tab country_gdp health_mental_pf, row ci

* FIG 1B 

summtab2 , by(country_reg) vars(health_mental_pf care_mental poormh_care poormh_care_cat) /// 
		   type(2 2 2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_1B_4B) sheetname(data) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis")

* FIG 2A

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(age_cat2) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_2A) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}


summtab2 , by(health_mental_pf) vars(age_cat2) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_2A) sheetname(Total) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis")
   		   
		   
* FIG 2B

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(gender2) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_2B) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}


summtab2 , by(health_mental_pf) vars(gender2) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_2B) sheetname(Total) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis")
		   


* FIG 3

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(health_gvge health_chronic activation) /// 
		   type(2 2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_3) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}

summtab2 , by(health_mental_pf) vars(health_gvge health_chronic activation) /// 
		   type(2 2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_3) sheetname(total) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 

* FIG 4 data

summtab2 , by(country_reg) vars(health_mental_pf care_mental poormh_care_cat) /// 
		   type(2 2 2) ///
		   wts(weight) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(fig_4) sheetname(data) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis")		   	   
		   

* FIG 5A, FIG 5B

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(usual_source unmet_need) /// 
		   type(2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_5A_5B) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}

* For significance


foreach i in Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom United_States {

svy: logistic usual_source health_mental_pf if `i' == 1 
svy: logistic unmet_need health_mental_pf if `i' == 1 

}


* FIG 6A

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(last_qual_vge) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_6A) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}

* For significance

foreach i in Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom United_States {

svy: logistic last_qual_vge health_mental_pf if `i' == 1 

}

* FIG 6B


foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(mistake discrim) /// 
		   type(2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_6B) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}


* For significance

foreach i in Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom United_States {

svy: logistic discrim health_mental_pf if `i' == 1 

}



* Figure 6C

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(phc_mental_vge) /// 
		   type(2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		   total replace excel landscape /// 
		   excelname(fig_6C) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}

* For significance

foreach i in Ethiopia Kenya Nigeria South_Africa Peru Colombia Mexico Uruguay Argentina Lao_PDR India China Korea Romania Greece Italy United_Kingdom United_States {

svy: logistic phc_mental_vge health_mental_pf if `i' == 1 

}


* Fig 7 - forest plots - code below and in R 

* Fig 8 compiled table 

foreach country in United_States India China Mexico Kenya United_Kingdom {
	
	summtab2 if `country' == 1,  by(health_mental_pf) vars(age_cat2 gender2 educ activation health_gvge ///
									health_chronic care_mental unmet_need usual_source ///
									last_qual_vge discrim phc_mental_vge conf_sick ///
									conf_afford conf_getafford system_reform_minor system_outlook_getbet) /// 
		   type(2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		   wts(weight) wtfreq(off) /// 
		   catmisstype(none) /// 
		    total replace excel /// 
		   excelname(fig_8_table) sheetname("`country'") directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 	
	
}


* Appendix Table 2

summtab2 , by(country_reg) vars(health_mental_pf care_mental poormh_care_cat) /// 
		   type(2 2 2) ///
		   wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(app_table2) sheetname(data) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis")
		   
		   

* Appendix Table 3

foreach c in $countries {	   
	
preserve


keep if `c'==1

summtab2 , by(health_mental_pf) vars(gender2 age_cat2 health_gvge ///
		   health_chronic activation usual_source unmet_need last_qual_vge ///
		   discrim phc_mental_vge) /// 
		   type(2 2 2 2 2 2 2 2 2 2) ///
		   wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(app_table3) sheetname(`c') directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 
		   
restore

}

summtab2 , by(health_mental_pf) vars(gender2 age_cat2 health_gvge ///
		   health_chronic activation usual_source unmet_need last_qual_vge ///
		   discrim phc_mental_vge) /// 
		   type(2 2 2 2 2 2 2 2 2 2) ///
		   wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		    total replace excel landscape /// 
		   excelname(app_table3) sheetname(total) directory("/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis") 

* Regressions

* Survey set without weight

* First regression

svyset psu_id_for_svy_cmds, strata(mode)

recode usual_quality_vge (.a .r = 2) if usual_source == 0

recode usual_quality_vge (0 = 1 "Usual source is poor/fair/good") (2 = 0 "No usual source") (1 = 2 "Usual source is very good/excellent"), gen(usual_qual_cat)

clonevar insur_type2 = insur_type
recode insur_type2 (2 3 = 0) 
recode insur_type2 (.a .d .r . = 4) if insured == 0

recode insur_type2 (4 = 0 "None") (0 = 1 "Public") (1 = 2 "Private"), gen(insured_type3)
* Check this split 

* Appendix table - receive care for poor mental health 

eststo: svy: logistic poormh_care gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat i.country_reg

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/app_reg2.rtf", ///
	replace wide b(2) ci(2) compress nobaselevels eform ///
	rename(gender2 "Gender" 2.age_cat2 "30-49" 3.age_cat2 "50+" ///
	educ2 "Post-secondary education" 1.income "Middle income" 2.income "High income" ///
	activation "Activated patient" urban "Urban" 1.insured_type3 "Public" ///
	2.insured_type3 "Private" health_chronic "Chronic illness" ///
	1.usual_qual_cat "Usual source is poor fair good" ///
	2.usual_qual_cat "Usual source is very good exc" ///
	2.country_reg "Kenya" 3.country_reg "Nigeria" ///
	4.country_reg "South Africa" 5.country_reg "Peru" 6.country_reg "Colombia" ///
	7.country_reg "Mexico" 8.country_reg "Uruguay" 9.country_reg "Argentina" 10.country_reg "Lao PDR" ///
	11.country_reg "India" 12.country_reg "China" 13.country_reg "Rep of Korea" /// 
	14.country_reg "Romania" 15.country_reg "Greece" ///
	16.country_reg "Italy" 17.country_reg "United Kingdom" ///
	18.country_reg "United States") ///
	mtitles("Received care for poor mental health") ///
	title("Table 1")
	
eststo clear 

* Confidence regressions 

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic conf_getafford health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_1.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Confidence in getting and affording good care") 
	
eststo clear 
	
	
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic system_outlook_getbet health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_2.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Health system getting better") 
	
eststo clear 	

	
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic system_reform_minor health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_3.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Health system reform minor") 
	
eststo clear 	
 	

* Regressions for text / appendix  

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic usual_source health_mental_pf if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/app_reg3_1.rtf", ///
	replace b(2) ci(2) compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Usual source") 
	
eststo clear 	

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic unmet_need health_mental_pf if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/app_reg3_2.rtf", ///
	replace b(2) ci(2) compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Unmet need") 
	
eststo clear 

* Confidence regressions 

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic conf_getafford health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_1_v2.rtf", ///
	replace  b(2) ci(2) compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Confidence in getting and affording good care") 
	
eststo clear 
	
	
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic system_outlook_getbet health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_2_v2.rtf", ///
	replace b(2) ci(2) compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Health system getting better") 
	
eststo clear 	

	
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		
eststo: svy: logistic system_reform_minor health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat covid_manage_vge if country_reg == `i' 

}

esttab using "/Users/neenakapoor/Dropbox (Harvard University)/MH Analysis/conf_reg_3_v2.rtf", ///
	replace b(2) ci(2) compress nobaselevels eform ///
	mtitles("Ethiopia" "Kenya" "Nigeria" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Argentina" "Lao PDR" "India" "China" "Rep of Korea" ///
	"Romania" "Greece" "Italy" "United Kingdom" "United States") ///
	title("Health system reform minor") 
	
eststo clear 	
 	

* Regressions for text / appendix 

eststo: svy: logistic health_pf health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.usual_qual_cat i.country_reg

eststo: svy: logistic health_pf health_mental_pf

eststo: svy: logistic health_chronic health_mental_pf

eststo: logistic usual_source health_mental_pf gender2 i.age_cat2 educ2 i.income activation urban i.insured_type3 health_chronic i.country_reg

