
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
summtab, catvars(usual_source no_unmet_need preventive anyvisit last_public discrim ///
		 usual_public_fac vgusual_quality ///
		 health_chronic ever_covid post_secondary high_income female urban) ///
		 contvars(age quality_score_last) by(country) mean meanrow catrow wts(weight) ///
		 replace excel excelname(Table_1)  
		 
********************************************************************************
* COUNTRY-SPECIFIC LOGISTIC REGRESSIONS
foreach x in Argentina Colombia Ethiopia  Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay Italy {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax usual_source no_unmet_need preventive ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	

	logistic fullvax quality_last last_public discrim ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A14) = etable
	
		logistic fullvax usual_public_fac vgusual_quality ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A27) = etable
}
	
import excel using "$user/$analysis/country-specific regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Colombia"
	gen model=2 in 12/22
	replace model=3 in 23/32
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Ethiopia Italy Kenya Korea LaoPDR Mexico Peru SouthAfrica USA Uruguay { 
	import excel using  "$user/$analysis/country-specific regressions.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 12/22
	replace model=3 in 23/32
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
}
	keep A B E F G country model
	encode country, gen(co)
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL) 
	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy"
	
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group
* FIGURE 2
	twoway (rspike UCL LCL co if A=="usual_source", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_source", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Has a usual source of care", size(medium))
	 
	graph export "$user/$analysis/usual_source.pdf", replace 

	twoway (rspike UCL LCL co if A=="no_unmet_need", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="no_unmet_need", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Had no unmet health care need in last year", size(medi))
	 
	graph export "$user/$analysis/unmet_need.pdf", replace 

	twoway (rspike UCL LCL co if A=="preventive", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="preventive", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Received at least 3 other preventive" "health care services in last year", size(medi))
	 
	graph export "$user/$analysis/preventive.pdf", replace 
* FIGURE 3
	twoway (rspike UCL LCL co if A=="quality_last", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="quality_last", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Quality score in last visit >=50%", size(medi))
	 
	graph export "$user/$analysis/quality_last.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="last_public", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="last_public", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Used public or government-owned facility", size(med))
	 
	graph export "$user/$analysis/last_public.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="discrim", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="discrim", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Experienced discrimination in the" "health system in the last year", size(med))
	 
	graph export "$user/$analysis/discrim.pdf", replace 
* FIGURE 4
	twoway (rspike UCL LCL co if A=="usual_publi~c", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_publi~c", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Usual facility is public or government-owned", size(med))
	 
	graph export "$user/$analysis/usual_public.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="vgusual_qua~y", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="vgusual_qua~y", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.5(0.5)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Rates usual facility quality" "as very good or excellent", size(medi))
	 
	graph export "$user/$analysis/quality_usual.pdf", replace 
*Supplemental table 3
	export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet1) firstrow(variable) replace 
	 
********************************************************************************	
* META ANALYSIS

	
	* Model 1
	metan lnB lnF lnG if A=="usual_source" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
		
	metan lnB lnF lnG if A=="no_unmet_need" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)

	metan lnB lnF lnG if A=="preventive" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="age2" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)

	metan lnB lnF lnG if A=="health_chronic" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="ever_covid" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="post_secondary" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="high_income" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="female" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="urban" & model==. , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	***********************
	* Model 2
	metan lnB lnF lnG if A=="last_public" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
		
	metan lnB lnF lnG if A=="quality_last" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)

	metan lnB lnF lnG if A=="discrim" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="age2" & model==2, by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)

	metan lnB lnF lnG if A=="health_chronic" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="ever_covid" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="post_secondary" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="high_income" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="female" & model==2 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="urban" & model==2, by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	***********************
	* Model 3
	metan lnB lnF lnG if A=="usual_publi~c" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
		
	metan lnB lnF lnG if A=="vgusual_qua~y" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="age2" & model==3, by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)

	metan lnB lnF lnG if A=="health_chro~c" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="ever_covid" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="post_second~y" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="high_income" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="female" & model==3 , by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	metan lnB lnF lnG if A=="urban" & model==3, by(inc_group) ///
	eform nograph  label(namevar=country) effect(aOR)
	
	

/********************************************************************************
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
