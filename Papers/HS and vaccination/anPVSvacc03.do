* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023
* Confidence and vaccination models
********************************************************************************
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

u "$user/$analysis/pvs_vacc_analysis.dta", clear
set more off
********************************************************************************
* COUNTRY-SPECIFIC  REGRESSIONS - QUALITY AND MANAGEMENT OF NATIONAL HEALTH SYSTEM

foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/conf models.xlsx", sheet("`x'")  modify	
	logistic fullvax conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
	putexcel (A1) = etable	
	logistic fullvax vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
	putexcel (A15) = etable	
	logistic fullvax vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
	putexcel (A29) = etable	
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/conf models.xlsx", sheet("`x'")  modify		
	logistic fullvax conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
	putexcel (A1) = etable	
	logistic fullvax vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
	putexcel (A15) = etable	
	logistic fullvax vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
	putexcel (A29) = etable	
	}
* Import estimates
import excel using "$user/$analysis/conf models.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
foreach x in  Argentina Colombia India Korea  Uruguay Italy  Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/conf models.xlsx", sheet("`x'") firstrow clear
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
	replace A="health_chronic" if A=="health_chr~c"
	replace A="post_secondary" if A=="post_secon~y"
	replace A="vconf_opinion" if A=="vconf_opin~n"
	replace A="vgcovid_manage" if A=="vgcovid_ma~e"
	
* Income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia" | country=="India"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | ///
						     count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy" | count=="UK"
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group
	
*Supplemental table 
	export excel using "$user/$analysis/supp table conf.xlsx", sheet(Sheet1) firstrow(variable) replace 
		
********************************************************************************
* GRAPHS QUALITY OF NATIONAL HS
	twoway (rspike UCL LCL co if A=="conf_getafford" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
		   (scatter aOR co if A=="conf_getafford" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
		   (rspike UCL LCL co if A=="conf_getafford" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
		   (scatter aOR co if A=="conf_getafford" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
		   (rspike UCL LCL co if A=="conf_getafford" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
		   (scatter aOR co if A=="conf_getafford" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Somewhat or very confident to get" "and afford quality care if sick" , size(medi))
	 
	graph export "$user/$analysis/conf_getafford.pdf", replace 

	twoway (rspike UCL LCL co if A=="vconf_opinion" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
		   (scatter aOR co if A=="vconf_opinion" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
		   (rspike UCL LCL co if A=="vconf_opinion" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
		   (scatter aOR co if A=="vconf_opinion" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
		   (rspike UCL LCL co if A=="vconf_opinion" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
		   (scatter aOR co if A=="vconf_opinion" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Somewhat or very confident that government" "considers public opinion" , size(medi))
	 
	graph export "$user/$analysis/vconf_opinion.pdf", replace 

	twoway (rspike UCL LCL co if A=="vgcovid_manage" & co>=1 & co<=4, lwidth(medthick) lcolor(pink)) ///
		   (scatter aOR co if A=="vgcovid_manage" & co>=1 & co<=4, msize(medsmall) mcolor(pink))  ///
		   (rspike UCL LCL co if A=="vgcovid_manage" & co>=5 & co<=9, lwidth(medthick) lcolor(lime)) ///
		   (scatter aOR co if A=="vgcovid_manage" & co>=5 & co<=9, msize(medsmall) mcolor(lime))  ///
		   (rspike UCL LCL co if A=="vgcovid_manage" & co>=10 & co<=14, lwidth(medthick) lcolor(orange)) ///
		   (scatter aOR co if A=="vgcovid_manage" & co>=10 & co<=14, msize(medsmall) mcolor(orange)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ETH" 2"KEN" 3"IND" 4"LAO" 5"PER" 6"ZAF" 7"COL" 8"MEX" ///
				9"ARG" 10"URY" 11"ITA" 12"KOR" 13"GBR" 14"USA", labsize(vsmall)) xtitle("") ///
			ylabel(0.3(0.3)4.6, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Rates government's management of the COVID-19" ///
			"pandemic as very good or excellent" , size(medi))
	 
	graph export "$user/$analysis/vgcovid_manage.pdf", replace 
	
	* META ANALYSIS - by income groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("national system")  modify
	foreach v in conf_getafford vconf_opinion vgcovid_manage  {
	
		metan lnB lnF lnG if A=="`v'" , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	* META ANALYSIS - all countries
	local row = 1
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("national system_all")  modify
	foreach v in conf_getafford vconf_opinion vgcovid_manage  {
	
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR)			 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}

/********************************************************************************
*SENSITIVITY ANALYSIS at least 1 dose in low-supply countries
* SUPPLEMENTAL MATERIALS 

	u "$user/$analysis/pvs_vacc_analysis.dta", clear
	
	foreach x in   Ethiopia Kenya SouthAfrica  {

	putexcel set "$user/$analysis/sensitivity analysis one dose.xlsx", sheet("`x'")  modify
			
	logistic onedose usual_source  preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	

	logistic onedose usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
	
	import excel using "$user/$analysis/sensitivity analysis one dose.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	gen model=2 in 13/24
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Kenya SouthAfrica  { 
	import excel using  "$user/$analysis/sensitivity analysis one dose.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 13/24
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
	

	export excel using "$user/$analysis/supp table 4_one dose.xlsx", sheet(Sheet1) firstrow(variable) replace 

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
