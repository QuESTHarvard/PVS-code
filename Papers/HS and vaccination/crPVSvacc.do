* People's Voice Survey+ vaccination
* Created Feb 23, 2023
* C.Arsenault

global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

u "$user/$data/pvs_all_countries.dta", clear

decode country, gen(c)
replace c = "LaoPDR" if country==11
replace c = "SouthAfrica" if country==9
replace c = "USA" if country==12
replace c = "Korea" if country==15

* Create covid vaccination variables
recode q14 (0/1=0) (2/4=1) if country==9 | country==3 | country==5, gen(fullvax2dose)
recode q14 (0/2=0) (3/4=1) if country ==2 | country==7 | country==10 | country==12 | ///
							  country ==13 | country ==14 | country ==15, gen(fullvax3dose)
recode q14_la (0/2=0) (3/4=1) if country ==11, gen(fullvax3d_la)					  
egen fullvax = rowmax (fullvax2d fullvax3d* )						  

* Other recoding
foreach v in health health_mental usual_quality last_qual covid_manage{
	recode `v' (1/2=0) (3/4=1), gen(vg`v')
}
recode education (0=1), gen(educ3)
lab def educ3 1"None or primary" 2"Secondary" 3"Post secondary"
lab val educ3 educ3 
egen preventive_score=rowtotal(blood_press blood_chol blood_sugar eyes teeth), m 
recode preventive_score (0/2=0) (3/5=1), gen(preventive) 
recode unmet_need (0=1) (1=0), gen(no_unmet_need)
recode system_outlook (1=0) (2=1), gen(getting_better)
recode system_reform (1/2=0) (3=1), gen(minor_changes)
recode visits_cat (1/2=1), gen(one_visit_or_more)
recode gender (2=1)

lab var educ3 "Education level"
lab var preventive "Received at leat 3 out of 5 preventive services"
lab var urban "Urban residence"
lab var vghealth "Rates own health as very good or excellent"
lab var health_chronic "Has a longstanding illness or chronic health problem"
lab var ever_covid "Had COVID-19"
lab var no_unmet_need "Had no unmet need for health care in the past year"
lab var conf_getafford "Confident would get and afford quality care"
lab var getting_better "Believes the health system is getting better in past 2 years"
lab var minor_changes "Believes the health system works well"
********************************************************************************
* Table 1	
summtab, catvars( educ3 income gender urban vghealth health_chronic ever_covid ///
					usual_source no_unmet_need preventive ///
					conf_getafford getting_better minor_changes) ///
					contvars(age visits) by(country) mean meanrow catrow wts(weight) ///
					replace excel excelname(Table_1)  
					
* Regressions adjusted for Age, urban, male, above median income, higher education
* Health: SR health + chronic
* Health care use: has a usual source + visit frequency + preventive care BP, eyes, teeth, BS


foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'", replace)  modify

	logistic fullvax  usual_source one_visit no_unmet_need preventive ///
					conf_getafford getting_better minor_changes ///
					health_chronic ever_covid i.age_cat i.gender i.urban i.income ///
					i.educ if c=="`x'", vce(robust) 		 
	putexcel (A1) = etable	
}

* sub-analysis: look at people with a ususal source + with a last visit 
foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Quality usual regressions.xlsx", sheet("`x'", replace)  modify

	logistic fullvax  vgusual_quality ///
				  health_chronic ever_covid i.age_cat i.gender i.urban i.income ///
				  i.educ if c=="`x'", vce(robust) 		 
	putexcel (A1) = etable	
}

foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Quality last regressions.xlsx", sheet("`x'", replace)  modify

	logistic fullvax  vglast_qual  ///
				  health_chronic ever_covid i.age_cat i.gender i.urban i.income ///
				  i.educ if c=="`x'", vce(robust) 		 
	putexcel (A1) = etable	
}
********************************************************************************
* FOREST PLOTS - UTILIZATION & CONFIDENCE MODEL
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B==""
	drop in 1
	gen country="Colombia"
	drop in 8/24
	save "$user/$analysis/foresplots.dta", replace

foreach x in  LaoPDR Mexico SouthAfrica USA Uruguay { 
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	drop in 1
	gen country="`x'"
	drop in 8/24
	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}
foreach x in  Ethiopia Kenya Peru { 
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	drop in 1
	gen country="`x'"
	drop in 8/23
	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}	
	
foreach x in  Italy Korea { 
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	drop in 1
	gen country="`x'"
	drop in 8/22
	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}	
	keep A B F G country
	foreach v in B F G {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
replace A ="Has a usual source of care" if A=="usual_source"
replace A ="Had at least 1 visit in last year" if A=="one_visit_or_more"
replace A ="Did not seek care when needed" if A=="unmet_need"
replace A ="Received 3/5 preventive services in last year" if A=="preventive"

replace A ="Confident can get and afford quality care" if A=="conf_getafford"
replace A ="Believes system is getting better" if A=="getting_better"
replace A ="Believes the health system works well" if A=="minor_changes"

gen conf=1 if A =="Confident can get and afford quality care" | A =="Believes system is getting better" | A =="Believes the health system works well"
metan lnB lnF lnG if conf==., ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy)))  
graph export "$user/$analysis/FP Utilization.pdf", replace 

metan lnB lnF lnG if conf==1, ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy)))  
graph export "$user/$analysis/FP confidence.pdf", replace 

********************************************************************************
* FOREST PLOTS -QUALITY OF USUAL SOURCE
  import excel using  "$user/$analysis/Quality usual regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B==""
	keep in 2
	gen country="Colombia"
	save "$user/$analysis/foresplots.dta", replace
	
foreach x in  Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
  import excel using  "$user/$analysis/Quality usual regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	keep in 2
	gen country="`x'"
  	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}
keep A B F G country
	foreach v in B F G {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
replace A ="Rates quality of usual source as very good or excellent" 
metan lnB lnF lnG , ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy)))  
graph export "$user/$analysis/quality_usual.pdf", replace 

********************************************************************************
* FOREST PLOTS -QUALITY OF LAST VISIT
  import excel using  "$user/$analysis/Quality last regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B==""
	keep in 2
	gen country="Colombia"
	save "$user/$analysis/foresplots.dta", replace
	
foreach x in  Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
  import excel using  "$user/$analysis/Quality last regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	keep in 2
	gen country="`x'"
  	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}
keep A B F G country
	foreach v in B F G {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
replace A ="Rates quality of last visit as very good or excellent" 
metan lnB lnF lnG , ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy)))  
graph export "$user/$analysis/FP quality_last.pdf", replace 
/********************************************************************************

recode usual_type_own (0=2) (1/2=1), gen(usual_own)
lab def usual_own 1 "Public" 2 "Private or other"
lab val usual_own usual_own
recode gender (2=.)

recode educ (0=1), gen(educ3)
lab def educ3 1"None of primary only" 2 "Secondary only" 3 "Post secondary"
lab val educ3 educ3

lab var vghealth "Rates own health as very good or excellent"
lab var vgusual_quality "Rates usual source of care as very good or excellent"
lab var vglast_qual "Rates quality of last visit as very good or excellent"
lab var vgcovid_manage "Rayes government's management of the  pandemic as very good or excellent"

		 





keep fullvax Oddsratio LCL UCL 
foreach v in Oddsratio LCL UCL {
	gen ln`v'=ln(`v')
}



 
 xlabel(0.1, 0.4 , 0.7, 0.9, 1.1) xtick (0.1, 0.4 , 0.7, 0.9, 1.1)

* Africa 2 doses
metan lnB lnF lnG  if country=="Ethiopia" | country=="Kenya" | country=="SouthAfrica", ///
		by(country) nosubgroup eform  nooverall nobox  label(namevar=A) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 
graph export "$user/$analysis/FP AFR.pdf", replace

* LATAM 3 doses	
metan lnB lnF lnG  if country=="Colombia" | country=="Peru" | country=="Uruguay" | country=="Mexico", ///
		by(country) nosubgroup eform  nooverall nobox  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		label(namevar=A) effect(aOR)  graphregion(color(white))  ///
		forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 	
graph export "$user/$analysis/FP LATAM.pdf", replace

* Asia 3 doses
metan lnB lnF lnG  if country=="Korea" | country=="LaoPDR", ///
		by(country) nosubgroup eform  nooverall nobox ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		label(namevar=A) effect(aOR)  graphregion(color(white)) ///
		forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 
graph export "$user/$analysis/FP EA.pdf", replace 

* NA & EU 3 doses
metan lnB lnF lnG  if country=="USA" | country=="Italy", ///
		by(country) nosubgroup eform  nooverall nobox ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		label(namevar=A) effect(aOR)  graphregion(color(white)) ///
		forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 
graph export "$user/$analysis/FP NA EU.pdf", replace 
* Analysis						  
tab  country fullvax [aw=weight], row nofreq




table country conf_sick [aw=weight], stat(mean fullvax)
table country conf_afford [aw=weight], stat(mean fullvax)
table country getting_better [aw=weight], stat(mean fullvax)
table country minor_changes [aw=weight], stat(mean fullvax)


table country vgusual_quality [aw=weight], stat(mean fullvax)
table country vglast_qual [aw=weight], stat(mean fullvax)


xtlogit fullvax3d conf_sick i.age_cat i.gender i.urban i.income i.educ , re vce(robust)	

melogit fullvax3d conf_sick  i.age_cat i.gender i.urban i.income i.educ || country:, vce(robust) or

melogit fullvax2d conf_sick i.age_cat i.gender i.urban i.income i.educ || country:, vce(robust) or

/*keep if age_cat<4 // exclude 60+ 
tab country conf_sick [aw=weight], row nofreq
tab country conf_afford [aw=weight], row nofreq
tab country getting [aw=weight], row nofreq
tab country minor_changes [aw=weight], row nofreq
		 
		 	 
		 
* Scatter plots
preserve 
	keep if age_cat<4 // exclude 60+ 
	collapse (mean) conf_sick conf_afford getting_better minor_changes fullvax (count) nbconf_sick=conf_sick ///
					nbconf_afford=conf_afford nbgetting_better=getting_better ///
					nbminor_changes=minor_changes nbfullvax=fullvax [aw=weight], by(region)

	drop if nbfull<10
	foreach x in conf_sick conf_afford getting_better minor_changes fullvax {
		gen p`x'= `x'*100
	}


twoway (scatter pconf_sick  pfullvax, sort msize(small)) ///
		(lowess pconf_sick pfullvax), graphregion(color(white)) ///
		ylabel(0(10)100, labsize(vsmall)) xlabel(0(10)100, labsize(vsmall)) ///
		ytitle("% respondents confident to receive good quality healthcare", ///
		size(small)) xtitle("% respondents with 2+ or 3+ doses", size(small)) legend(off)

twoway (scatter pconf_afford  pfullvax, sort msize(small)) ///
		(lowess pconf_afford pfullvax), graphregion(color(white)) ///
		ylabel(0(10)100, labsize(vsmall)) xlabel(0(10)100, labsize(vsmall)) ///
		ytitle("% respondents confident to afford healthcare", ///
		size(small)) xtitle("% respondents with 2+ or 3+ doses", size(small)) legend(off)
		
twoway (scatter pgetting pfullvax, sort msize(small)) ///
		(lowess pgetting pfullvax), graphregion(color(white)) ///
		ylabel(0(10)100, labsize(vsmall)) xlabel(0(10)100, labsize(vsmall)) ///
		ytitle("% respondents believe health system is getting better", ///
		size(small)) xtitle("% respondents with 2+ or 3+ doses", size(small)) legend(off)
		
twoway (scatter pminor pfullvax, sort msize(small)) ///
		(lowess pminor pfullvax), graphregion(color(white)) ///
		ylabel(0(10)60, labsize(vsmall)) xlabel(0(10)100, labsize(vsmall)) ///
		ytitle("% respondents believe health system works well", ///
		size(small)) xtitle("% respondents with 2+ or 3+ doses", size(small)) legend(off)
		
		