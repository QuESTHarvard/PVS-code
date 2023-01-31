* PVS Analysis for Paper 1
* Last updated: January 2023
* N. Kapoor 

clear all
set more off 

* Import clean data with derived variables 

u "$data_mc/02 recoded data/pvs_all_countries.dta", replace

*------------------------------------------------------------------------------*
* Derive additional variables for Paper 1 analysis 

* usual_quality last_qual phc_women phc_child phc_chronic phc_mental qual_private 
* qual_public system_outlook system_reform covid_manage gender health health_mental

* usual_qual
recode usual_quality (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_e) label(exc_pr_hlthcare_1)

recode usual_quality (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_vge) label(exc_pr_hlthcare_2)
lab var usual_quality_vge "VGE: Overall quality rating of usual source of care (Q22)"

* last_qual	   
recode last_qual (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_e) label(exc_pr_1)
	   
recode last_qual (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_vge) label(exc_pr_2)

* phc_women

recode phc_women (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_e) label(exc_pr_judge_1)
	   

recode phc_women (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_vge) label(exc_pr_judge_2)

* phc_child 

recode phc_child (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_e) label(exc_pr_judge_1)
	   

recode phc_child (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_vge) label(exc_pr_judge_2)	   

* phc_chronic

recode phc_chronic (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_e) label(exc_pr_judge_1)
	   

recode phc_chronic (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_vge) label(exc_pr_judge_2)	   	   
	   
* phc_mental

recode phc_mental (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_e) label(exc_pr_judge_1)
	   

recode phc_mental(0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_vge) label(exc_pr_judge_2)	  

* qual_private  
recode qual_private (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_e) label(exc_pr_1)
	   
recode qual_private (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_vge) label(exc_pr_2)

* qual_public
recode qual_public (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_e) label(exc_pr_1)
	   
recode qual_public (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_vge) label(exc_pr_2)
	   
lab var qual_public_vge "VGE: Overall quality rating of gov or public healthcare system in country (Q54)"

* covid_manage
recode covid_manage (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_e) label(exc_pr_1)
	   
recode covid_manage (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_vge) label(exc_pr_2)

* system outlook

recode system_outlook ///
	(0 1 = 0 "Staying the same/Getting worse") (2 = 1 "Getting better") ///
	(.r = .r "Refused") , gen(system_outlook_getbet) label(system_outlook2)

* system reform

recode system_reform ///
	(1 2 = 0 "Major changes/Rebuilt") (3 = 1 "Minor changes") ///
	(.r = .r "Refused") , gen(system_reform_minor) label(system_reform2)
	
* gender
gen gender2 = gender
recode gender2 (2 = .)
lab var gender2 "Gender (binary)"

* health
recode health (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_vge) label(health2)

* health_mental
recode health_mental (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_mental_vge) label(health_mental2)


*add new confidence variable conf_both if people can get care AND can afford it

gen conf_getafford =.
replace conf_getafford=1 if conf_sick==1 & conf_afford==1
replace conf_getafford=0 if conf_sick==0 | conf_afford==0
tab conf_getafford

*split education into below and above secondary
recode education (0/1=0 "None or primary") (2/3=1 "Secondary or post-secondary") , gen (edu_secon)
lab var edu_secon "Education: above or below secondary education "

*split income into lowest v other
recode income 0=0 1/2=1, gen (nonpoor)

*age over 50
centile age,  centile(10(10)90)
**over 50 is 80th percentile
gen over50=.
replace over50=1 if age>50
replace over50=0 if age<50

*younger adults
gen under30=.
replace under30=1 if age<30
replace under30=0 if age>30

*gen wealthy
recode income 0/1=0 2=1, gen (wealthy)

*gen most_educ
recode education 0/2=0 3=1, gen (most_educ)

*gen total score for PHC services
gen phc_score = phc_women+phc_child+phc_chronic+phc_mental

* gen phc_score_cat, score above 12 is 1
recode phc_score (0/11 = 0 "Good/Fair/Poor on all PHC services") (12/16 = 1 "Very good/Excellent on all PHC services"), gen(phc_score_cat)
lab var phc_score_cat "Public primary care score (cateogircal) (> 12)"

*gen diff between private and public
gen qual_diff=.
replace qual_diff=qual_public-qual_private

*gen getting better AND only small changes needed**did not use this in regs
gen bett_minor=.
replace bett_minor=1 if system_outlook_getbet==1 & system_reform_minor==1
replace bett_minor=0 if system_outlook_getbet==0 | system_reform_minor==0


gen mdp=.
replace mdp=1 if income==0 & (education==0 | education==1) & health_vge==0
replace mdp=0 if income>0 | education>1 | health_vge==1
*mdp is 1 for 11% of sample (1100 people)


* Recode country 
recode country (3 = 1 "Ethiopia") (5 = 2 "Kenya") (9 = 3 "South Africa") (7 = 4 "Peru") ///
				(2 = 5 "Colombia") (10 = 6 "Uruguay") (11 = 7 "Lao PDR"), gen(country2)

* Recode age
recode age (18/20 = 0 "<20") (20/29 = 1 "20-29") (30/39 = 2 "30-39") (40/49 = 3 "40-49") ///
		   (50/59 = 4 "50-59") (60/69 = 5 "60-69") (70/100 = 6 "> 70"), gen(age_cat2)


* Add weight for ZA so commands will run 
recode weight (. = 1) if country == 9

*------------------------------------------------------------------------------*

* Save new dataset for paper 1 	   
	   
save "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

*------------------------------------------------------------------------------*

* Descriptive analysis 

u "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

* Survey set
svyset psu_id_for_svy_cmds, strata(mode) weight(weight)


* Sample characteristics table
summtab2 , by(country) vars(gender2 urban education health_vge age_cat2 visits q28_b inpatient) /// 
		   type(2 2 2 2 2 1 1 2) wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		   median total replace word landscape /// 
		   wordname(sample_char_table) directory("$output/Paper 1") /// 
		   title(Sample Characteristics Table)

* Data for histograms - Exhibit 1 & 2

summtab2 , by(country2) vars(usual_quality_vge phc_women_vge phc_child_vge phc_chronic_vge ///
		   phc_mental_vge qual_public_vge qual_private_vge covid_manage_vge) /// 
		   type(2 2 2 2 2 2 2 2)  wts(weight) /// 
		   catmisstype(none) catrow /// 
		   total replace excel /// 
		   excelname(p1_exhib1_2) sheetname(Exhibit 1 data) directory("$output/Paper 1") /// 
		   title(Data for Paper 1, Exhibit 1) 

summtab2 , by(country2) vars(system_outlook_getbet system_reform_minor ///
							conf_sick conf_afford conf_getafford) /// 
		   type(2 2 2 2 2)  wts(weight) /// 
		   catmisstype(none) catrow /// 
		   total replace excel /// 
		   excelname(p1_exhib1_2) sheetname(Exhibit 2 data) directory("$output/Paper 1") /// 
		   title(Data for Paper 1, Exhibit 2) 		   
	   
/* Data for previous exhibit 3, table - no longer using 

* Key variables by demographic stratifiers


foreach i in 1 2 3 4 5 6 7 {
	
		rm "$output/Paper 1/exhib_3_ctry`i'.csv"

	foreach var of varlist conf_sick conf_afford phc_score_cat qual_public_vge usual_quality_vge { 
	
		tabout urban edu_secon health_chronic `var' if country2 == `i' ///
		using "$output/Paper 1/exhib_3_ctry`i'.csv", ///
		append c(row) f(3 3 3) svy stats(chi2) 
	
}

}

* Commands to check output 
* svy: tab conf_sick urban if country2 == 1, col
* svy: tab conf_sick urban if country2 == 7, col
*/

* Data for forest plots - Exhibit 3 

****Outcome 1: overall public quality (logistic)***use this version

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: logistic qual_public_vge wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3.1_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.1 data") 

eststo clear

***Outcome 2: diff between private and public

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: reg qual_diff wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3.2_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.2 data") 

eststo clear

***Outcome 3: total phc score (linear)

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: reg phc_score wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}


esttab using "$output/Paper 1/exhibit_3.3_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.3 data") 

eststo clear
	
**Outcome 4: try security in getting good care (not afford, since will use wealth as predictor)

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: logistic conf_sick wealthy most_educ urban under30  health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3.4_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.4 data") 

eststo clear

**Outcome 5: minor changes needed

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: logistic system_reform_minor wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3.5_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.5 data") 
	
eststo clear

**Outcome 6: system getting better

foreach i in 1 2 3 4 6 5 7 {
	
	eststo: logistic system_outlook_getbet wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3.6_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge gender2 _cons) ///
	rename(wealthy "Highest income" under30 "Under 30 years" most_educ "Highly educated" ///
	urban "Urban") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" "Uruguay" "Lao PDR") ///
	title( "Exhibit 3.6 data")

eststo clear

*------------------------------------------------------------------------------*
* Exhibit 4 & 5

* Generate poor variable 
recode income 0=1 1/2=0, gen (poor)

eststo: logistic conf_getafford poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.last_qual i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**government listens to opinions (q53) is strongest predictor of confidence OR 9.6, covid managment OR 1.6 inconsistent up the likert

margins country2, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot
graph export "$output/Paper 1/exhib_5_1.pdf", replace

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot
graph export "$output/Paper 1/exhib_5_1_v2.pdf", replace

margins country2, at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 
graph export "$output/Paper 1/exhib5_2.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 
graph export "$output/Paper 1/exhib5_2_v2.pdf", replace
	
margins country2, at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_3.pdf", replace

margins , at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_3_v2.pdf", replace

eststo: logistic system_outlook_getbet poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.last_qual i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public big determinant (excellent OR 5.6, then opinion 2.9 then covid managment 2.5

margins country2, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot 
graph export "$output/Paper 1/exhib5_4.pdf", replace

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot
graph export "$output/Paper 1/exhib5_4 v2.pdf", replace

margins country2, at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 
graph export "$output/Paper 1/exhib5_5.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 	
graph export "$output/Paper 1/exhib5_5_v2.pdf", replace

margins country2, at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_6.pdf", replace

margins , at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_6_v2.pdf", replace

eststo: logistic system_reform_minor poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.last_qual i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public important (excellent OR 4.1)
 
margins country2, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot 
graph export "$output/Paper 1/exhib5_7.pdf", replace


margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot
graph export "$output/Paper 1/exhib5_7 v2.pdf", replace


margins country2, at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 
graph export "$output/Paper 1/exhib5_8.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot 	
graph export "$output/Paper 1/exhib5_8 v2.pdf", replace

margins country2, at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_9.pdf", replace

margins , at(covid_manage=0 covid_manag=1 covid_manag=2 covid_manag=3 covid_manag=4) 			
marginsplot 
graph export "$output/Paper 1/exhib5_9 v2.pdf", replace


esttab using "$output/Paper 1/exhibit_4.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform ///
	rename(poor "Poor" under30 "Under 30 years" edu_secon "Secondary or higher education" ///
	urban "Urban" health_vge "Self-rated health (vge)" ///
	health_chronic "Chronic" gender2 "Gender" unmet_need "Unmet need for care" ///
	1.last_qual "Last visit - Fair" 2.last_qual "Last visit - Good" ///
	3.last_qual "Last visit - Very good" 4.last_qual "Last visit - Excellent" ///
	1.qual_public "Public system - Fair" 2.qual_public "Public system - Good" ///
	3.qual_public "Public system - Very good" 4.qual_public "Public system - Excellent" ///
	1.qual_private "Private system - Fair" 2.qual_private "Private system - Good" ///
	3.qual_private "Private system - Very good" 4.qual_private "Private system - Excellent" ///
	1.covid_manage "COVID management - Fair" 2.covid_manage "COVID management - Good" ///
	3.covid_manage "COVID management - Very good" 4.covid_manage "COVID management - Excellent" ///
	1.q53 "Gov opinion - Not too confident" 2.q53 "Gov opinion - Somewhat confident" ///
	3.q53 "Gov opinion - Very confident" 2.country2 "Kenya" ///
	3.country2 "South Africa" 4.country2 "Peru" 5.country2 "Colombia" ///
	6.country2 "Uruguay" 7.country2 "Lao PDR") mtitles("Confidence get and afford care" ///
	"System outlook getting better" "System works well, only minor changes needed") ///
	title("Exhibit data")

eststo clear
