
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

cd "$user/$analysis/"
u "$user/$analysis/pvs_vacc_analysis.dta", clear

********************************************************************************
* FIGURE 1 COVID DOSES
ta nb_doses c  [aw=weight] , nofreq col
********************************************************************************
* TABLE 1	
summtab, catvars(usual_source no_unmet_need preventive vglast_qual discrim ///
		 health_chronic ever_covid educ3 income female urban) ///
		 contvars(age) by(country) mean meanrow catrow wts(weight) ///
		 replace excel excelname(Table_1)  

********************************************************************************
* COUNTRY-SPECIFIC LOGISTIC REGRESSIONS

foreach x in Argentina Colombia Ethiopia  Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay Italy {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'", replace)  modify
			
	logistic fullvax usual_source no_unmet_need preventive ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
	putexcel (A1) = etable	
	
	logistic fullvax quality_last last_public discrim ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
	putexcel (A14) = etable
}
	
import excel using "$user/$analysis/country-specific regressions.xlsx", sheet(Colombia) firstrow clear
	keep in 2/11
	gen country="Colombia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay { 
	import excel using  "$user/$analysis/country-specific regressions.xlsx", sheet("`x'") firstrow clear
	keep in 2/11
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
}
	keep A B E F G country
	encode country, gen(co)
	foreach v in E B F G  {
		destring `v', replace
	}
	rename (B E F G) (aOR p_value LCL UCL)
	
	twoway (rspike UCL LCL co if A=="usual_source", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="usual_source", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Has a usual source of care", size(small))
	 
	 twoway (rspike UCL LCL co if A=="public_fac", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="public_fac", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Usual source of care is a public or government-owned facility", size(small))
	 
	 twoway (rspike UCL LCL co if A=="no_unmet_need", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="no_unmet_need", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Had no unmet health care need in last year", size(small))
	 
	  twoway (rspike UCL LCL co if A=="preventive", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="preventive", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Received at least 3 other preventive services in last year", size(small))
	 
	  twoway (rspike UCL LCL co if A=="vgusual_quality", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="vgusual_quality", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Rates their usual provider as very good or excellent quality", size(small))

	  twoway (rspike UCL LCL co if A=="vglast_qual", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="vglast_qual", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Rates their last health care visit as very good or excellent quality", size(small))

	 twoway (rspike UCL LCL co if A=="discrim", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="discrim", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) 	xtitle("") ///
	 ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 title("Has experienced discrimination in health system in last year", size(small))
	 
	 export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet1) firstrow(variable) replace 
	 
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy"
	
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group
	
	 export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet2) firstrow(variable) replace 
********************************************************************************
* SUB-ANALYSIS: AMONG THOSE WITH >1 VISIT IN LAST YEAR
foreach x in Argentina Colombia Ethiopia  Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay Italy {
	putexcel set "$user/$analysis/at leat 1 visit.xlsx", sheet("`x'", replace)  modify
	
	logistic fullvax discrim  quality_score ///
			 age2 health_chronic ever_covid post_secondary ///
			 high_income female urban if c=="`x'", vce(robust)
		putexcel (A1) = etable	
}

import excel using "$user/$analysis/at leat 1 visit.xlsx", sheet(Colombia) firstrow clear
	drop if B==""
	gen country="Colombia"
	keep in 2/13
	save "$user/$analysis/graph1.dta", replace
	
foreach x in  Argentina Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay { 
	import excel using  "$user/$analysis/at leat 1 visit.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	gen country="`x'"
	keep in 2/13
	append using "$user/$analysis/graph1.dta"
	save "$user/$analysis/graph1.dta", replace
}

	keep A B F G country
	encode country, gen(co)
	foreach v in B F G  {
		destring `v', replace
	}
	rename (B F G) (aOR LCL UCL)
	
	twoway (rspike UCL LCL co if A=="vglast_qual", lwidt(medium) lcolor(navy)) ///
	(scatter aOR co if A=="vglast_qual", msize(small) mcolor(ebblue*2)) , ///
	 graphregion(color(white)) legend(off) ///
	 xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" 9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
	 ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
	 yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
	 ytitle("vg")
	
********************************************************************************
* POOLED MODEL
putexcel set "$user/$analysis/multi-country regressions.xlsx", sheet("all", replace) modify

regress nb_doses usual_source no_unmet_need preventive ///
			 age2 health_chronic ever_covid post_secondary ///
			high_income female urban i.country, vce(robust)
		
putexcel (A1) = etable	
		
putexcel set "$user/$analysis/multi-country regressions.xlsx", sheet("last_visit", replace) modify

regress nb_doses discrim quality_score ///
			 age2 health_chronic ever_covid post_secondary ///
			high_income female urban i.country, vce(robust)

			putexcel (A1) = etable	
			
			
			
			
			
			

* CORRELATIONS
foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
corr usual_source one_visit no_unmet_need preventive ///
	conf_getafford getting_better minor_changes ///
	health_chronic ever_covid age2 gender urban income if c=="`x'"
}
* REGRESSIONS
foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'", replace)  modify
	svyset psu_id_for_svy_cmds, strata(mode)
	svy: logistic fullvax usual_source one_visit no_unmet_need preventive ///
					conf_getafford getting_better minor_changes ///
					health_chronic ever_covid age2 female urban high_income ///
					educ2 if c=="`x'" 
	putexcel (A1) = etable	
}

* sub-analysis: look at people with a ususal source + with a last visit 
foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Quality usual regressions.xlsx", sheet("`x'", replace)  modify

	logistic fullvax  vgusual_quality ///
				  health_chronic ever_covid age2 i.gender i.urban high_income ///
				  educ2 if c=="`x'", vce(robust) 		 
	putexcel (A1) = etable	
}

foreach x in Colombia Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay {
	
	putexcel set "$user/$analysis/Quality last regressions.xlsx", sheet("`x'", replace)  modify

	logistic fullvax  vglast_qual  ///
				  health_chronic ever_covid age2 female i.urban high_income ///
				  educ2 if c=="`x'", vce(robust) 		 
	putexcel (A1) = etable	
}
********************************************************************************
* FOREST PLOTS - DEMOGRAPHICS AND HEALTH STATUS
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B==""
	gen country="Colombia"
	keep in 9/15
	save "$user/$analysis/foresplots.dta", replace

foreach x in  Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay { 
	import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'") firstrow clear
	drop if B==""
	gen country="`x'"
	keep in 9/15
	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}
	keep A B F G country
	foreach v in B F G {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	replace A= "Has a chronic illness" if A=="health_chr~c"
	replace A= "Had COVID" if A=="ever_covid"
	replace A= "Aged 50+" if A=="age2"
	replace A= "Female" if A=="female"
	replace A= "Lives in urban area" if A=="urban"
	replace A= "Highest income group" if A=="high_income"
	replace A= "Post-secondary education" if A=="educ2"
preserve
keep if A =="Highest income group" | A=="Post-secondary education" | A=="Aged 50+"  | A=="Lives in urban area"
	metan lnB lnF lnG , ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 
	graph export "$user/$analysis/FP demographics1.pdf", replace 
restore
keep if A== "Has a chronic illness" | A=="Had COVID" | A=="Female"
metan lnB lnF lnG , ///
		by(A) sortby(lnB) nosubgroup eform  nooverall nobox  label(namevar=country) effect(aOR)  ///
		xlabel(0.25, 0.5, 1, 2, 3, 4, 5) xtick (0.25, 0.5, 1, 2, 3, 4, 5) ///
		graphregion(color(white)) forestplot(spacing(1.1)  ciopts(lcolor(navy) lwidth(vthin)) ///
		pointopts (msize(tiny) mcolor(navy))) 
	graph export "$user/$analysis/FP demographics2.pdf", replace 
********************************************************************************
* FOREST PLOTS - UTILIZATION & CONFIDENCE
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet(Colombia) firstrow clear
	gen country="Colombia"
	keep in 2/8
	save "$user/$analysis/foresplots.dta", replace

foreach x in Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay { 
import excel using  "$user/$analysis/Utilization Confidence regressions.xlsx", sheet("`x'") firstrow clear
	gen country="`x'"
	keep in 2/8
	append using "$user/$analysis/foresplots.dta"
	save "$user/$analysis/foresplots.dta", replace
}
	keep A B F G country
	foreach v in B F G {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
replace A ="Has a usual source of care" if A=="usual_source"
replace A ="Had at least 1 visit in last year" if A=="one_visit_~e"
replace A ="Had no unmet need in last year" if A=="no_unmet_n~d"
replace A ="Received 3/5 preventive services in last year" if A=="preventive"
replace A ="Confident can get and afford quality care" if A=="conf_getaf~d"
replace A ="Believes system is getting better" if A=="getting_be~r"
replace A ="Believes the health system works well" if A=="minor_chan~s"

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
* BUBBLE PLOTS
putexcel set "$user/$analysis/bubbleplots.xlsx",  modify
		putexcel B2=("Vaccination")
		putexcel C2=("Vax_SE")
		putexcel D2=("Vax_LCI")
		putexcel E2=("Vax_UCI")
		
	local row = 3
	
	foreach i in Argentina Colombia Ethiopia  Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay Italy {

		set more off
	
		ci means fullvax  [aw=weight] if c=="`i'" 
		putexcel A`row'=("`i'") 
		putexcel B`row'=(r(mean))
		putexcel C`row'=(r(se))
		putexcel D`row'=(r(lb))
		putexcel E`row'=(r(ub))
		
		putexcel F2=("Usual_source")
		putexcel G2=("Usu_SE")
		putexcel H2=("Usu_LCI")
		putexcel I2=("Usu_UCI")
		
	ci means usual_source [aw=weight ] if c=="`i'" 
		putexcel F`row'=(r(mean))
		putexcel G`row'=(r(se))
		putexcel H`row'=(r(lb))
		putexcel I`row'=(r(ub))
		local row = `row'+1
}
import excel using "$user/$analysis/bubbleplots.xlsx", firstrow clear
	metareg Vaccination Usual_source, wsse(Vax_SE) graph
	
* BUBBLE PLOTS (scatter)
collapse (mean) fullvax quality_score   ///
		 (count) mode [aw=weight], by(c)
		 
scatter fullvax quality_score [w=mode], msymbol(circle_hollow)  ///
	|| lfit fullvax quality_score [w=mode] ///
	|| scatter fullvax quality_score, mcolor(white) mlabel(c) mlabcolor(navy) mlabsize(vsmall) mlabposition(12)  ///
	ytitle("Proportion vaccinated with 2+ or 3+ doses") ///
	xtitle("avg quality ") ///
	graphregion(color(white)) legend(off) 
	
	xlabel(0.6(0.1)1) 
	
scatter fullvax preventive [w=mode], msymbol(circle_hollow)  ///
	|| lfit fullvax preventive [w=mode] ///
	|| scatter fullvax preventive, mcolor(white) mlabel(c) mlabcolor(navy) mlabsize(vsmall) mlabposition(12)  ///
	ytitle("Proportion vaccinated with 2+ or 3+ doses") ///
	xtitle("Proportion who received at least 3 other preventive services") ///
	graphregion(color(white)) legend(off) 

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
		
		