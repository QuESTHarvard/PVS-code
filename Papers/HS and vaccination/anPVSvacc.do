global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

cd "$user/$analysis/"

net install collin

u "$user/$analysis/pvs_vacc_analysis.dta", clear
********************************************************************************
* FIGURE 1 COVID DOSES
ta nb_doses c  [aw=weight] , nofreq col
********************************************************************************
* TABLE 1	
summtab, catvars(usual_source  preventive unmet_need anyvisit ///
				 usual_public_fac vgusual_quality discrim  ///
				 health_chronic ever_covid post_secondary high_income female urban minority) ///
		         contvars(age ) by(country) mean meanrow catrow wts(weight) ///
		         replace excel excelname(Table_1)  				
********************************************************************************
* COUNTRY-SPECIFIC LOGISTIC REGRESSIONS
foreach x in   Ethiopia India Kenya LaoPDR Mexico Peru SouthAfrica USA  {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax usual_source  preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
				
	putexcel (A1) = etable	

	logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
foreach x in Argentina Colombia Korea  Uruguay Italy {

	putexcel set "$user/$analysis/country-specific regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority
				
	putexcel (A1) = etable	

	logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A15) = etable
	}
	
import excel using "$user/$analysis/country-specific regressions.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	gen model=2 in 13/24
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  India Kenya LaoPDR Mexico Peru SouthAfrica USA  { 
	import excel using  "$user/$analysis/country-specific regressions.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	gen model=2 in 13/24
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
foreach x in  Argentina Colombia Korea  Uruguay Italy   { 
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
	export excel using "$user/$analysis/supp table 3.xlsx", sheet(Sheet1) firstrow(variable) replace 
	
********************************************************************************
* GRAPHS
* FIGURE 2
	twoway (rspike UCL LCL co if A=="usual_source", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_source", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.20(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Has a usual source of care", size(medium))
	 
	graph export "$user/$analysis/usual_source.pdf", replace 
	
		twoway (rspike UCL LCL co if A=="preventive", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="preventive", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Received at least 3 other preventive" "health care services in last year", size(medi))
	 
	graph export "$user/$analysis/preventive.pdf", replace 

	twoway (rspike UCL LCL co if A=="unmet_need", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="unmet_need", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3.2, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Had unmet health care needs in last year", size(medi))
	 
	graph export "$user/$analysis/unmet_need.pdf", replace 

* FIGURE 3
	twoway (rspike UCL LCL co if A=="usual_public_fac", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="usual_public_fac", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Usual facility is public or government-owned", size(med))
	 
	graph export "$user/$analysis/usual_public.pdf", replace 

	twoway (rspike UCL LCL co if A=="vgusual_quality", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="vgusual_quality", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Rates quality of usual provider as" "very good or excellent" , size(medi))
	 
	graph export "$user/$analysis/vgusual_qual.pdf", replace 
	
	twoway (rspike UCL LCL co if A=="discrim", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="discrim", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
				   10"PER" 11"ZAF" 12"USA" 13"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Experienced discrimination in the" "health system in the last year", size(med))
	 
	graph export "$user/$analysis/discrim.pdf", replace 
	
	
********************************************************************************
* Check for collinearity
foreach x in  Ethiopia India Kenya LaoPDR Mexico Peru SouthAfrica USA  {			
				logistic fullvax usual_source  preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
				
				collin fullvax usual_source preventive unmet_need age2 ///
				health_chronic ever_covid post_seconda high_income female urban  if c=="`x'" & e(sample)==1

				logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)
				
				collin fullvax usual_public_fac vgusual_quality discrim ///
				health_chronic ever_covid post_seconda high_income female urban  if c=="`x'" & e(sample)==1
	}
foreach x in Argentina Colombia Korea  Uruguay Italy {		
				logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
				
				collin fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban if c=="`x'" & e(sample)==1

				logistic fullvax usual_public_fac vgusual_quality discrim  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
				collin fullvax usual_public_fac vgusual_quality discrim ///
				health_chronic ever_covid post_seconda high_income ///
				female urban  if c=="`x'" & e(sample)==1
	}
********************************************************************************	
* META ANALYSIS

	* Model 1 - by income groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model1")  modify
	foreach v in usual_source  preventive unmet_need age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==1 , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
	* Model 2 - by income groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model2")  modify
	foreach v in  usual_public_fac vgusual_quality discrim age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==2 , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}

	* Model 1 - by regional groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model1reg")  modify
	foreach v in usual_source preventive unmet_need age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==1 , by(reg_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
	* Model 2 - by regional groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimate metan.xlsx", sheet("Model2reg")  modify
	foreach v in  usual_public_fac vgusual_quality discrim age2 health_chronic ///
	             ever_covid post_secondary high_income female urban minority {
	
		metan lnB lnF lnG if A=="`v'" & model==2 , by(reg_group) ///
				eform nograph  label(namevar=country) effect(aOR)
				
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
********************************************************************************
*SENSITIVITY ANALYSIS at least 1 dose in low-supply countries

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
*CONFIDENCE

	u "$user/$analysis/pvs_vacc_analysis.dta", clear
	
foreach x in   Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA  {

	putexcel set "$user/$analysis/confidence regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax works ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	
	}

foreach x in Argentina Colombia Korea  Uruguay Italy {

	putexcel set "$user/$analysis/confidence regressions.xlsx", sheet("`x'")  modify
			
	logistic fullvax works ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)
				
	putexcel (A1) = etable	
	}
	
import excel using "$user/$analysis/confidence regressions.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Colombia Korea  Uruguay Italy  Kenya LaoPDR Mexico Peru SouthAfrica USA  { 
	import excel using  "$user/$analysis/confidence regressions.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}

	keep A B E F G country 
	encode country, gen(co)
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL) 
	
	twoway (rspike UCL LCL co if A=="workswell", lwidth(medthick) lcolor(navy)) ///
		   (scatter aOR co if A=="workswell", msize(medsmall) mcolor(ebblue*2)) , ///
			graphregion(color(white)) legend(off) ///
			xlabel(1"ARG" 2"COL" 3"ETH" 4"ITA" 5"KEN" 6"KOR" 7"LAO" 8"MEX" ///
				   9"PER" 10"ZAF" 11"USA" 12"URY", labsize(vsmall)) xtitle("") ///
			ylabel(0.2(0.2)3, labsize(vsmall) gstyle(minor)) ///
			yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
			title("Believes the health system works well" "and only minor changes are needed", size(med))
	 
	graph export "$user/$analysis/workswell.pdf", replace
	
	
/* Confirming weighted descriptive results in Ethiopia and Kenya
svyset psu_id_for_svy_cmd [pw=weight], strata(mode)
foreach v in usual_source unmet_need preventive anyvisit ///
				 usual_public_fac vgusual_quality discrim  ///
				 health_chronic ever_covid post_secondary high_income female urban minority {
svy: tab `v' if c=="Kenya"
				 }
svy: mean age if c=="Kenya"	
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
