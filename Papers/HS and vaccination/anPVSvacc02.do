
* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023
* SENSITIVITY ANALYSIS (2+ DOSES)
********************************************************************************
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

cd "$user/$analysis/"

u "$user/$analysis/pvs_vacc_analysis.dta", clear

********************************************************************************
* COUNTRY-SPECIFIC LOGISTIC REGRESSIONS
foreach x in   Ethiopia India Kenya LaoPDR Mexico Peru SouthAfrica USA  {

	putexcel set "$user/$analysis/country-specific regressions_2doses.xlsx", sheet("`x'")  modify
			
	logistic twodoses usual_source  preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
				
	putexcel (A1) = etable	

	logistic twodoses usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
foreach x in Argentina Colombia Korea  Uruguay Italy {

	putexcel set "$user/$analysis/country-specific regressions_2doses.xlsx", sheet("`x'")  modify
			
	logistic twodoses usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority
				
	putexcel (A1) = etable	

	logistic twodoses usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
	
import excel using "$user/$analysis/country-specific regressions_2doses.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	gen model=2 in 13/24
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  India Kenya LaoPDR Mexico Peru SouthAfrica USA  { 
	import excel using  "$user/$analysis/country-specific regressions_2doses.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 13/24
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
foreach x in  Argentina Colombia Korea  Uruguay Italy   { 
	import excel using  "$user/$analysis/country-specific regressions_2doses.xlsx", sheet("`x'") firstrow clear
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
	replace model=1 if model==.
	replace A="usual_public_fac" if A=="usual_publ~c"
	replace A="vgusual_quality" if A=="vgusual_qu~y"
	replace A="health_chronic" if A=="health_chr~c"
	replace A="post_secondary" if A=="post_secon~y"
	
* Income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia" | country=="India"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | ///
						     count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy" | count=="UK"
	
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group

* Region groups
	gen reg_group = 1 if country=="SouthAfrica" | country=="Ethiopia" | country=="Kenya"
	replace reg_group = 2 if country=="Korea" |  country=="LaoPDR" | country=="India"
	replace reg_group= 3 if country=="Peru" | country=="Mexico" | country=="Argentina" ///
							| country=="Colombia" |  country=="Uruguay" 
	replace reg_group=4 if country=="USA" | country=="Italy" | country=="UK"
	
	lab def reg_group 1 "SSA" 2"Asia" 3"LATAM" 4"NAWE"
	lab val reg_group reg_group
	
*Supplemental table 3
	*export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet1) firstrow(variable) replace 
	
********************************************************************************
* GRAPHS
* FIGURE 2
	twoway (rspike UCL LCL co if A=="usual_source", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_source", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.20(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Has a usual source of care", size(medium))
	 
	graph export "$user/$analysis/usual_source2.pdf", replace 
	
		twoway (rspike UCL LCL co if A=="preventive", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="preventive", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Received at least 3 other preventive" "health care services in last year", size(medi))
	 
	graph export "$user/$analysis/preventive2.pdf", replace 

	twoway (rspike UCL LCL co if A=="unmet_need", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="unmet_need", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Had unmet health care needs in last year", size(medi))
	 
	graph export "$user/$analysis/unmet_need2.pdf", replace 

* FIGURE 3
	twoway (rspike UCL LCL co if A=="usual_public_fac", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_public_fac", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Usual facility is public or government-owned", size(med))
	 
	graph export "$user/$analysis/usual_public2.pdf", replace 

	twoway (rspike UCL LCL co if A=="vgusual_quality", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="vgusual_quality", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Rates quality of usual provider as" "very good or excellent" , size(medi))
	 
	graph export "$user/$analysis/vgusual_qual2.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="discrim", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="discrim", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)5, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Experienced discrimination in the" "health system in the last year", size(med))
	 
	graph export "$user/$analysis/discrim2.pdf", replace 
