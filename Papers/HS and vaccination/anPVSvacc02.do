
* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023
* Health system competence and rating of own care models

********************************************************************************
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

u "$user/$analysis/pvs_vacc_analysis.dta", clear
set more off
********************************************************************************
* COUNTRY-SPECIFIC  REGRESSIONS - RATING OF OWN CARE AND SYSTEM COMPETENCE
foreach x in  Ethiopia  Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/country-specific regressions comp qual.xlsx", sheet("`x'")  modify	
	logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with minority			
	putexcel (A1) = etable	
	logistic fullvax vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)		
	putexcel (A15) = etable
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/country-specific regressions comp qual.xlsx", sheet("`x'")  modify
	logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without minority		
	putexcel (A1) = etable	
	logistic fullvax vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)		
	putexcel (A15) = etable
	}	
	* Import estimates
import excel using "$user/$analysis/country-specific regressions comp qual.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Colombia India Korea  Uruguay Italy Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/country-specific regressions comp qual.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
	keep A B E F G country 
	gen co = 1 if country=="Ethiopia"
	replace co =2  if country=="Kenya"
	replace co =3  if country=="India"
	replace co =4  if country=="LaoPDR"
	replace co =5  if country=="Peru"
	replace co =6  if country=="SouthAfrica"
	replace co =7  if country=="Colombia"
	replace co =8  if country=="Mexico"
	replace co =9  if country=="Argentina"
	replace co =10  if country=="Uruguay"
	replace co =11  if country=="Italy"
	replace co =12  if country=="Korea"
	replace co =13  if country=="UK"
	replace co =14  if country=="USA"
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL) 
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
	
*Supplemental table 3
	export excel using "$user/$analysis/supp table hs comp qual.xlsx", sheet(Sheet1) firstrow(variable) replace 
	
********************************************************************************
* GRAPHS SYSTEM COMPETENCE
	preserve 
	replace UCL=3.4 if UCL==4.543549 // Italy outlier UCL
		twoway (rspike UCL LCL co if A=="usual_source" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="usual_source" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
			   (rspike UCL LCL co if A=="usual_source" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="usual_source" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="usual_source" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="usual_source" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.20(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Has a usual source of care", size(medium))
		 
		graph export "$user/$analysis/usual_source.pdf", replace 
		
		twoway (rspike UCL LCL co if A=="preventive" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="preventive" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
			   (rspike UCL LCL co if A=="preventive" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="preventive" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="preventive" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="preventive" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.2(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Received at least 3 other preventive" "health care services in last year", size(medi))
		 
		graph export "$user/$analysis/preventive.pdf", replace 

		twoway (rspike UCL LCL co if A=="unmet_need" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="unmet_need"& co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
			   (rspike UCL LCL co if A=="unmet_need" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="unmet_need"& co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="unmet_need" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="unmet_need"& co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.2(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Had unmet health care needs in last year", size(medi))
		 
		graph export "$user/$analysis/unmet_need.pdf", replace 

	* GRAPHS QUALITY OF OWN CARE
		twoway (rspike UCL LCL co if A=="vgusual_quality"& co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="vgusual_quality" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
			   (rspike UCL LCL co if A=="vgusual_quality"& co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="vgusual_quality" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="vgusual_quality"& co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="vgusual_quality" & co>=10 & co<=14, msize(medsmall) mcolor(orange)),  ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.2(0.4)3.4, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Rates quality of usual provider as" "very good or excellent" , size(medi))
		 
		graph export "$user/$analysis/vgusual_qual.pdf", replace 
		
		twoway (rspike UCL LCL co if A=="discrim" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="discrim" & co>=1 & co<=4, msize(medsmall) mcolor(pink)) ///
			   (rspike UCL LCL co if A=="discrim" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="discrim" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="discrim" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="discrim" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.2(0.4)3.4, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Experienced discrimination in the" "health system in the last year", size(med))
		 
		graph export "$user/$analysis/discrim.pdf", replace 
		
		twoway (rspike UCL LCL co if A=="mistake" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
			   (scatter aOR co if A=="mistake" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
			   (rspike UCL LCL co if A=="mistake" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
			   (scatter aOR co if A=="mistake" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
			   (rspike UCL LCL co if A=="mistake" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
			   (scatter aOR co if A=="mistake" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
				ylabel(0.2(0.4)3.4, labsize(vsmall) gstyle(minor)) ///
				yline(1, lstyle(foreground) lpattern(dash) ) xsize(1) ysize(1) ///
				title("Believes medical mistake was made", size(med))
		 
		graph export "$user/$analysis/mistake.pdf", replace 
	restore 
	
	* META ANALYSIS - by income groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("hs_competence")  modify
	foreach v in usual_source  preventive unmet_need  {
	
		metan lnB lnF lnG if A=="`v'" , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("qualowncare")  modify
	foreach v in vgusual_quality discrim mistake  {
	
		metan lnB lnF lnG if A=="`v'" , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
* META ANALYSIS - all countries
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("hs_competence_all")  modify
	foreach v in usual_source preventive unmet_need  {
	
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("qualowncare_all")  modify
	foreach v in vgusual_quality discrim mistake  {
	
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
