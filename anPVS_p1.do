* PVS Analysis for Paper 1
* Last updated: February 2023
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

lab var usual_quality_e "E: Overall quality rating of usual source of care (Q22)"

recode usual_quality (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "I did not receive healthcare form this provider in the past 12 months"), /// 
	   gen(usual_quality_vge) label(exc_pr_hlthcare_2)

lab var usual_quality_vge "VGE: Overall quality rating of usual source of care (Q22)"

* last_qual	   
recode last_qual (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_e) label(exc_pr_1)

lab var last_qual_e "E: Last visit rating: overall quality (Q48A)"

	   
recode last_qual (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(last_qual_vge) label(exc_pr_2)

lab var last_qual_vge "VGE: Last visit rating: overall quality (Q48A)"
	   
* phc_women

recode phc_women (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_e) label(exc_pr_judge_1)
	   
lab var phc_women_e "E: Public primary care system rating for: pregnant women (Q50A)"
	   
	   
recode phc_women (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_women_vge) label(exc_pr_judge_2)

lab var phc_women_vge "VGE: Public primary care system rating for: pregnant women (Q50A)"   
	   
* phc_child 

recode phc_child (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_e) label(exc_pr_judge_1)
	   
lab var phc_child_e "E: Public primary care system rating for: children (Q50B)"

	   
recode phc_child (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_child_vge) label(exc_pr_judge_2)	   

lab var phc_child_vge "VGE: Public primary care system rating for: children (Q50B)"

	   
* phc_chronic

recode phc_chronic (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_e) label(exc_pr_judge_1)
	   
lab var phc_chronic_e "E: Public primary care system rating for: chronic conditions (Q50C)"
	   
recode phc_chronic (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_chronic_vge) label(exc_pr_judge_2)	   	   

lab var phc_chronic_vge "VGE: Public primary care system rating for: chronic conditions (Q50C)"
	   
* phc_mental

recode phc_mental (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_e) label(exc_pr_judge_1)
	   
lab var phc_mental_e "E: Public primary care system rating for: mental health (Q50D)"

recode phc_mental(0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA") (.d = .d "I am unable to judge") (.r = .r "Refused"), /// 
	   gen(phc_mental_vge) label(exc_pr_judge_2)	  

lab var phc_mental_vge "VGE: Public primary care system rating for: mental health (Q50D)"
	   
* qual_private  
recode qual_private (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_e) label(exc_pr_1)

lab var qual_private_e "E:  Overall quality rating of private healthcare system in country (Q55)"

recode qual_private (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_private_vge) label(exc_pr_2)

lab var qual_private_vge "VGE:  Overall quality rating of private healthcare system in country (Q55)"	   
	   
* qual_public
recode qual_public (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_e) label(exc_pr_1)
	   
lab var qual_public_e "E:  Overall quality rating of public healthcare system in country (Q54)"
	   
recode qual_public (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_public_vge) label(exc_pr_2)
	   
lab var qual_public_vge "VGE: Overall quality rating of gov or public healthcare system in country (Q54)"

* qual_ss_pe - just vge for now 
	   
recode qual_ss_pe (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_ss_pe_vge) label(exc_pr_2)

lab var qual_ss_pe_vge "VGE: PE only: Overall quality rating of social security system in country (Q56)"

* qual_mut_uy- just vge for now 
	   
recode qual_mut_uy (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(qual_mut_uy_vge) label(exc_pr_2)

lab var qual_mut_uy_vge "VGE: UY only: Overall quality rating of mutual healthcare system in country (Q56)"

* q56_mx_a - just vge for now 
	   
recode q56_mx_a (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(q56_mx_a_vge) label(exc_pr_2)

lab var q56_mx_a_vge "VGE: MX only: How would you rate the quality of services provided by IMSS? (Q56)"

* q56_mx_b - just vge for now 
	   
recode q56_mx_b (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(q56_mx_b_vge) label(exc_pr_2)

lab var q56_mx_b_vge "VGE:  MX only: How would you rate the quality of services...IMSS BIENESTAR? (Q56)"   
	   
* covid_manage
recode covid_manage (0 1 2 3 = 0 "Poor/Fair/Good/Very Good") (4 = 1 "Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_e) label(exc_pr_1)
	   
recode covid_manage (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(covid_manage_vge) label(exc_pr_2)

lab var covid_manage_vge "VGE: Rating of the government's management of the COVID-19 pandemic (Q59)"   
	   
* system outlook

recode system_outlook ///
	(0 1 = 0 "Staying the same/Getting worse") (2 = 1 "Getting better") ///
	(.r = .r "Refused") , gen(system_outlook_getbet) label(system_outlook2)

lab var system_outlook_getbet "Health system getting better (Q57)"	
	
* system reform

recode system_reform ///
	(1 2 = 0 "Major changes/Rebuilt") (3 = 1 "Minor changes") ///
	(.r = .r "Refused") , gen(system_reform_minor) label(system_reform2)

lab var system_reform_minor "System works well, only minor changes needed (Q58)"		
	
* gender
gen gender2 = gender
recode gender2 (2 = .)
lab var gender2 "Gender (binary)"
lab val gender2 gender

* health
recode health (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_vge) label(health2)

* health_mental
recode health_mental (0 1 2 = 0 "Poor/Fair/Good") (3 4 = 1 "Very good/Excellent") (.r = .r "Refused") /// 
	   (.a = .a "NA"), /// 
	   gen(health_mental_vge) label(health_mental2)


*add new confidence variable conf_both if people can get care AND can afford it

gen conf_getafford = .
replace conf_getafford=1 if conf_sick==1 & conf_afford==1
replace conf_getafford=0 if conf_sick==0 | conf_afford==0
replace conf_getafford=.r if conf_sick==.r & conf_afford==.r

* br conf_getafford conf_sick conf_afford if conf_getafford == .
* FLAG - currently people who say very confident and refused are missing 

* Create confidence can get and confidence can afford care with different split, 
* combining somewhat confident and very confident 

recode q51 (0 1 = 0) (2 3 = 1) (.r = .r), gen(conf_sick_sv)
recode q52 (0 1 = 0) (2 3 = 1) (.r = .r), gen(conf_afford_sv)

gen conf_getafford_sv = . 
replace conf_getafford_sv=1 if conf_afford_sv==1 & conf_sick_sv==1
replace conf_getafford_sv =0 if conf_afford_sv==0 | conf_sick_sv==0
replace conf_getafford_sv=.r if conf_sick_sv ==.r & conf_afford_sv ==.r
* NOTE: same issue as above 

*split education into below and above secondary
recode education (0/1=0 "None or primary") (2/3=1 "Secondary or post-secondary") , gen (edu_secon)
lab var edu_secon "Education: above or below secondary education "

*split income into lowest v other
recode income 0=0 1/2=1, gen (nonpoor)

*age over 50
centile age,  centile(10(10)90)
**over 50 is 80th percentile
gen over50=.
replace over50=1 if age>50 & age<.
replace over50=0 if age<50

*younger adults
gen under30=.
replace under30=1 if age<30 
replace under30=0 if age>=30 & age<.

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
				(2 = 5 "Colombia") (13 = 6 "Mexico") (10 = 7 "Uruguay") (11 = 8 "Lao PDR") ///
				(14 = 9 "Italy") (12 = 10 "United States"), gen(country2)

* Recode age
recode age (18/20 = 0 "<20") (20/29 = 1 "20-29") (30/39 = 2 "30-39") (40/49 = 3 "40-49") ///
		   (50/59 = 4 "50-59") (60/69 = 5 "60-69") (70/100 = 6 "> 70"), gen(age_cat2)


* Generate poor variable 
recode income 0=1 1/2=0, gen (poor)

*------------------------------------------------------------------------------*

* Save new dataset for paper 1 	   
	   
save "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

*------------------------------------------------------------------------------*

* Descriptive analysis 

u "$data_mc/02 recoded data/pvs_all_countries_p1.dta", replace

* Survey set
* svyset psu_id_for_svy_cmds, strata(mode) weight(weight)

* Survey set without weight
svyset psu_id_for_svy_cmds, strata(mode)


* Sample characteristics table - appendix table 5
summtab2 , by(country2) vars(gender2 age education urban income health_vge health_chronic ///
		   unmet_need usual_quality_vge last_qual_vge phc_women_vge phc_child_vge ///
		   phc_chronic_vge phc_mental_vge qual_public_vge qual_private_vge qual_ss_pe_vge ///
		   qual_mut_uy_vge q56_mx_a_vge q56_mx_b_vge conf_sick conf_afford conf_getafford ///
		   system_outlook_getbet system_reform_minor conf_opinion covid_manage_vge) /// 
		   type(2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		   wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		   median total replace word landscape /// 
		   wordname(sample_char_table) directory("$output/Paper 1") /// 
		   title(Sample Characteristics Table)

* Data for histograms - Exhibit 1 & 2

summtab2 , by(country2) vars(usual_quality_vge phc_women_vge phc_child_vge phc_chronic_vge ///
		   phc_mental_vge qual_public_vge qual_private_vge qual_ss_pe_vge qual_mut_uy_vge ///
		   q56_mx_a_vge q56_mx_b_vge) /// 
		   type(2 2 2 2 2 2 2 2 2 2 2)  wts(weight) /// 
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

* Data for forest plots - Exhibit 3  - only reporting B, D, E F now 

****Outcome 3A: quality of usual source of care 

foreach i in 1 2 3 4 6 5 7 8 9 10 {
	
	eststo: svy: logistic usual_quality_vge wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3A_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3A data") 

eststo clear

****Outcome 3B: overall public quality (logistic)***use this version

foreach i in 1 2 3 4 6 5 7 8 9 10 {
	
	eststo: svy: logistic qual_public_vge wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3B_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3B data")  

eststo clear


***Outcome 3C: 

foreach i in 1 2 3 4 6 5 7 8 9 10 {
	
	eststo: svy: logistic qual_private wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3C_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3C data")  

eststo clear

**Outcome 3D: confidence get and afford 


foreach i in 1 2 3 4 6 5 7 8 9 10  {
	
	eststo: svy: logistic conf_getafford wealthy most_educ urban under30  health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3D_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3D data")  

eststo clear

**Outcome 3E: system getting better

foreach i in 1 2 3 4 6 5 7 8 9 10  {
	
	eststo: svy: logistic system_outlook_getbet wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3E_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3E data")  

eststo clear

**Outcome 3F: minor changes needed

foreach i in 1 2 3 4 6 5 7 8 9 10  {
	
	eststo: svy: logistic system_reform_minor wealthy most_educ urban under30 health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3F_data.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3F data")  
	
eststo clear


*------------------------------------------------------------------------------*
* Exhibit 4 & 5

*** Confidence get and afford ***

eststo: svy: logistic conf_getafford poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**government listens to opinions (q53) is strongest predictor of confidence OR 9.6, covid managment OR 1.6 inconsistent up the likert

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot, ylabel(0(0.1)0.35, labsize(small)) xtitle("Quality of public system", size(small)) ///
			 ytitle("Pr(very confident)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("A. Health security: confidence can get and afford care", size(small)) 

graph export "$output/Paper 1/exhib5_1.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot, ylabel(0(0.1)0.35, labsize(small)) xtitle("Government considers public opinion", size(small)) ///
			 ytitle("Pr(very confident)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("B. Health security: confidence can get and afford care", size(small)) 
			 
graph export "$output/Paper 1/exhib5_2.pdf", replace

*** System outlook getting better ***

eststo: svy: logistic system_outlook_getbet poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public big determinant (excellent OR 5.6, then opinion 2.9 then covid managment 2.5

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		

marginsplot, ylabel(.2(0.1)0.6, labsize(small)) xtitle("Quality of public system", size(small)) ///
			 ytitle("Pr(getting better)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("C. Endorsement: health system getting better in past two years", size(small)) 

graph export "$output/Paper 1/exhib5_3.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	

marginsplot, ylabel(.2(0.1)0.6, labsize(small)) xtitle("Government considers public opinion", size(small)) ///
			 ytitle("Pr(getting better)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("D. Endorsement: health system getting better in past two years", size(small)) 

graph export "$output/Paper 1/exhib5_4.pdf", replace

*** System reform minor ***

eststo: svy: logistic system_reform_minor poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public important (excellent OR 4.1)

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot, ylabel(0.1(0.1)0.4, labsize(small)) xtitle("Quality of public system", size(small)) ///
			 ytitle("Pr(works well, only minor changes needed)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("E. Endorsement: health system works well, only minor changes needed", size(small)) 
graph export "$output/Paper 1/exhib5_5.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot, ylabel(0.1(0.1)0.4, labsize(small)) xtitle("Government considers public opinion", size(small)) ///
		     ytitle("Pr(works well, only minor changes needed)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			  title("F. Endorsement: health system works well, only minor changes needed", size(small))  
graph export "$output/Paper 1/exhib5_6.pdf", replace


esttab using "$output/Paper 1/exhibit_4.rtf", ///
	replace wide b(2) ci(2) compress nobaselevels eform ///
	rename(poor "Poor" under30 "Under 30 years" edu_secon "Secondary or higher education" ///
	urban "Urban" health_vge "Self-rated health (vge)" ///
	health_chronic "Chronic" gender2 "Gender" unmet_need "Unmet need for care" ///
	1.usual_quality "Usual source - Fair" 2.usual_quality "Usual source - Good" ///
	3.usual_quality "Usual source - Very good" 4.usual_quality "Usual source - Excellent" ///
	1.qual_public "Public system - Fair" 2.qual_public "Public system - Good" ///
	3.qual_public "Public system - Very good" 4.qual_public "Public system - Excellent" ///
	1.qual_private "Private system - Fair" 2.qual_private "Private system - Good" ///
	3.qual_private "Private system - Very good" 4.qual_private "Private system - Excellent" ///
	1.covid_manage "COVID management - Fair" 2.covid_manage "COVID management - Good" ///
	3.covid_manage "COVID management - Very good" 4.covid_manage "COVID management - Excellent" ///
	1.q53 "Gov opinion - Not too confident" 2.q53 "Gov opinion - Somewhat confident" ///
	3.q53 "Gov opinion - Very confident" 2.country2 "Kenya" ///
	3.country2 "South Africa" 4.country2 "Peru" 5.country2 "Colombia" ///
	6.country2 "Mexico" 7.country2 "Uruguay" 8.country2 "Lao PDR" 9.country2 "Italy" ///
	10.country2 "United States") mtitles("Confidence get and afford care" ///
	"System outlook getting better" "System works well, only minor changes needed") ///
	title("Exhibit 4 data")

eststo clear

********* Create new figures wit different split for confidence scales *********

* Exhibit 2

summtab2 , by(country2) vars(conf_sick_sv conf_afford_sv conf_getafford_sv) /// 
		   type(2 2 2)  wts(weight) /// 
		   catmisstype(none) catrow /// 
		   total replace excel /// 
		   excelname(p1_exhib1_2) sheetname(Exhibit 2 data v2) directory("$output/Paper 1") /// 
		   title(Data for Paper 1, Exhibit 2) 	

* Exhibit 3 		   
		   
**Outcome 3D: confidence get and afford 


foreach i in 1 2 3 4 6 5 7 8 9 10  {
	
	eststo: svy: logistic conf_getafford_sv wealthy most_educ urban under30  health_vge gender2 if country2 == `i' 
	
}

esttab using "$output/Paper 1/exhibit_3D_data v2.rtf", ///
	replace wide b(2) ci(2) nostar compress nobaselevels eform drop(health_vge _cons) ///
	rename(wealthy "High income" under30 "Under 30 years" most_educ "High education" ///
	urban "Urban" gender2 "Female") mtitles("Ethiopia" "Kenya" "South Africa" "Peru" "Colombia" ///
	"Mexico" "Uruguay" "Lao PDR" "Italy" "United States") ///
	title( "Exhibit 3D data v2")  

eststo clear


* Exhibit 4

*** Confidence get and afford ***

eststo: svy: logistic conf_getafford_sv poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**government listens to opinions (q53) is strongest predictor of confidence OR 9.6, covid managment OR 1.6 inconsistent up the likert

margins, at(qual_public=0 qual_public=1 qual_public=2 qual_public=3 qual_public=4) 		
marginsplot, ylabel(0.3(0.1)0.7, labsize(small)) xtitle("Quality of public system", size(small)) ///
			 ytitle("Pr(very or somewhat confident)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("A. Health security: confidence can get and afford care", size(small)) 

graph export "$output/Paper 1/exhib5_1 v2.pdf", replace

margins , at(q53=0 q53=1 q53=2 q53=3) 	
marginsplot, ylabel(0.3(0.1)0.7, labsize(small)) xtitle("Government considers public opinion", size(small)) ///
			 ytitle("Pr(very or somewhat confident)", size(small)) xlabel( , labsize(vsmall)) graphregion(color(white)) ///
			 title("B. Health security: confidence can get and afford care", size(small)) 
			 
graph export "$output/Paper 1/exhib5_2 v2.pdf", replace

*** System outlook getting better ***

eststo: svy: logistic system_outlook_getbet poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public big determinant (excellent OR 5.6, then opinion 2.9 then covid managment 2.5

*** System reform minor ***

eststo: svy: logistic system_reform_minor poor under30 edu_secon urban health_vge health_chronic gender2 unmet_need i.usual_quality i.qual_public i.qual_private i.covid_manage i.q53 i.country2
**qual_public important (excellent OR 4.1)

esttab using "$output/Paper 1/exhibit_4 v2.rtf", ///
	replace wide b(2) ci(2) compress nobaselevels eform ///
	rename(poor "Poor" under30 "Under 30 years" edu_secon "Secondary or higher education" ///
	urban "Urban" health_vge "Self-rated health (vge)" ///
	health_chronic "Chronic" gender2 "Gender" unmet_need "Unmet need for care" ///
	1.usual_quality "Usual source - Fair" 2.usual_quality "Usual source - Good" ///
	3.usual_quality "Usual source - Very good" 4.usual_quality "Usual source - Excellent" ///
	1.qual_public "Public system - Fair" 2.qual_public "Public system - Good" ///
	3.qual_public "Public system - Very good" 4.qual_public "Public system - Excellent" ///
	1.qual_private "Private system - Fair" 2.qual_private "Private system - Good" ///
	3.qual_private "Private system - Very good" 4.qual_private "Private system - Excellent" ///
	1.covid_manage "COVID management - Fair" 2.covid_manage "COVID management - Good" ///
	3.covid_manage "COVID management - Very good" 4.covid_manage "COVID management - Excellent" ///
	1.q53 "Gov opinion - Not too confident" 2.q53 "Gov opinion - Somewhat confident" ///
	3.q53 "Gov opinion - Very confident" 2.country2 "Kenya" ///
	3.country2 "South Africa" 4.country2 "Peru" 5.country2 "Colombia" ///
	6.country2 "Mexico" 7.country2 "Uruguay" 8.country2 "Lao PDR" 9.country2 "Italy" ///
	10.country2 "United States") mtitles("Confidence get and afford care" ///
	"System outlook getting better" "System works well, only minor changes needed") ///
	title("Exhibit 4 data")

eststo clear


* Sample characteristics table - appendix table 5

summtab2 , by(country2) vars(gender2 age education urban income health_vge health_chronic ///
		   unmet_need usual_quality_vge last_qual_vge phc_women_vge phc_child_vge ///
		   phc_chronic_vge phc_mental_vge qual_public_vge qual_private_vge qual_ss_pe_vge ///
		   qual_mut_uy_vge q56_mx_a_vge q56_mx_b_vge conf_sick_sv conf_afford_sv conf_getafford_sv ///
		   system_outlook_getbet system_reform_minor conf_opinion covid_manage_vge) /// 
		   type(2 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2) ///
		   wts(weight) wtfreq(ceiling) /// 
		   catmisstype(none) /// 
		   median total replace word landscape /// 
		   wordname(sample_char_table_v2) directory("$output/Paper 1") /// 
		   title(Sample Characteristics Table)
