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
summtab, catvars(usual_source no_unmet_need preventive anyvisit ///
				 usual_public_fac vgusual_quality discrim  ///
				 health_chronic ever_covid post_secondary high_income female urban minority) ///
		         contvars(age ) by(country) mean meanrow catrow wts(weight) ///
		         replace excel excelname(Table_1)  
		 
********************************************************************************
* COUNTRY-SPECIFIC LOGISTIC REGRESSIONS
foreach x in  Colombia Ethiopia Kenya Korea LaoPDR Mexico Peru USA  {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax usual_source no_unmet_need preventive ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	

	logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
foreach x in Argentina  SouthAfrica Uruguay Italy {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax usual_source no_unmet_need preventive ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	

	logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
	
import excel using "$user/$analysis/country-specific regressions.xlsx", sheet(Colombia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Colombia"
	gen model=2 in 13/24
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Ethiopia Kenya Korea LaoPDR Mexico Peru USA  { 
	import excel using  "$user/$analysis/country-specific regressions.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 13/24
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
foreach x in  Argentina  SouthAfrica Uruguay Italy  { 
	import excel using  "$user/$analysis/country-specific regressions.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 12/22
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
	
* Income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy"
	
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group
	replace model=1 if model==.

*Supplemental table 3
	export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet1) firstrow(variable) replace 
	
********************************************************************************
* GRAPHS
* FIGURE 2
	twoway (rspike UCL LCL co if A=="usual_source", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_source", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.20(0.2)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Has a usual source of care", size(medium))
	 
	graph export "$user/$analysis/usual_source.pdf", replace 

	twoway (rspike UCL LCL co if A=="no_unmet_need", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="no_unmet_need", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Had no unmet health care need in last year", size(medi))
	 
	graph export "$user/$analysis/unmet_need.pdf", replace 

	twoway (rspike UCL LCL co if A=="preventive", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="preventive", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)4, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Received at least 3 other preventive" "health care services in last year", size(medi))
	 
	graph export "$user/$analysis/preventive.pdf", replace 
	
* FIGURE 3
	twoway (rspike UCL LCL co if A=="usual_public~c", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_public~c", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Usual facility is public or government-owned", size(med))
	 
	graph export "$user/$analysis/usual_public.pdf", replace 

	twoway (rspike UCL LCL co if A=="vgusual_qual~y", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="vgusual_qual~y", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Rates quality of usual provider as" "very good or excellent" , size(medi))
	 
	graph export "$user/$analysis/vgusual_qual.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="discrim", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="discrim", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Experienced discrimination in the" "health system in the last year", size(med))
	 
	graph export "$user/$analysis/discrim.pdf", replace 
********************************************************************************	
* META ANALYSIS

	* Model 1
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model1")  modify
	foreach v in usual_source no_unmet_need preventive age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==1 , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
	* Model 2
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model2")  modify
	foreach v in  usual_public~c vgusual_qual~y discrim age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==2 , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}

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
