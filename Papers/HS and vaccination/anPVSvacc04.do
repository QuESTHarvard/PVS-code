* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023

* SENSITIVITY ANALYSIS: 2+ DOSES

********************************************************************************
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

u "$user/$analysis/pvs_vacc_analysis.dta", clear
set more off
********************************************************************************
* COUNTRY-SPECIFIC REGRESSIONS - UTILIZATION
foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/utilization model2d.xlsx", sheet("`x'")  modify
	logistic twodoses i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
	putexcel (A1) = etable	
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/utilization model2d.xlsx", sheet("`x'")  modify		
	logistic twodoses i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
	putexcel (A1) = etable	
	}
* Import estimates
import excel using "$user/$analysis/utilization model2d.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Colombia India Korea  Uruguay Italy  Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/utilization model2d.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
	keep A B E F G country 
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL)
	
* Create the income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia" | country=="India"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | ///
						     count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy" | count=="UK"
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group
	
*Meta analysis by income group 
local row = 1
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("utilization")  modify
	foreach v in 1-2visits  3-4visits 5ormorevisits {
		metan lnB lnF lnG if A=="`v'"  , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR) 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	
* Meta analysis accross all countries 
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("utilization_all")  modify
	foreach v in 1-2visits  3-4visits 5ormorevisits {
	
		metan lnB lnF lnG if A=="`v'"  ,  ///
				eform nograph  label(namevar=country) effect(aOR) 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
********************************************************************************
* COUNTRY-SPECIFIC  REGRESSIONS - HEALTH SYSTEM COMPETENCE, PERCEIVED QUALITY & USER EXPERIENCE
u "$user/$analysis/pvs_vacc_analysis.dta", clear
foreach x in  Ethiopia  Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/country-specific regressions comp qual2d.xlsx", sheet("`x'")  modify	
	logistic twodoses usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority			
	putexcel (A1) = etable	
	logistic twodoses vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)		
	putexcel (A15) = etable
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/country-specific regressions comp qual2d.xlsx", sheet("`x'")  modify
	logistic twodoses usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
	putexcel (A1) = etable	
	logistic twodoses vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)		
	putexcel (A15) = etable
	}	

* Import estimates
import excel using "$user/$analysis/country-specific regressions comp qual2d.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Colombia India Korea  Uruguay Italy Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/country-specific regressions comp qual2d.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
	keep A B E F G country 
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL) 
	replace A="vgusual_quality" if A=="vgusual_qu~y"
	replace A="health_chronic" if A=="health_chr~c"
	replace A="post_secondary" if A=="post_secon~y"
* Create income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia" | country=="India"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | ///
						     count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy" | count=="UK"
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group

* META ANALYSIS - by income groups
	local row = 1
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("hs_competence")  modify
	foreach v in usual_source  preventive unmet_need  {
		metan lnB lnF lnG if A=="`v'" , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR)		 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	local row = 1
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("qualowncare")  modify
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
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("hs_competence_all")  modify
	foreach v in usual_source preventive unmet_need  {
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR) 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
	local row = 1
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("qualowncare_all")  modify
	foreach v in vgusual_quality discrim mistake  {
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR)		 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
********************************************************************************
* COUNTRY-SPECIFIC  REGRESSIONS - CONFIDENCE IN HS AND GOVERNMENT
u "$user/$analysis/pvs_vacc_analysis.dta", clear
foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/conf models2d.xlsx", sheet("`x'")  modify	
	logistic twodoses conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
	putexcel (A1) = etable	
	logistic twodoses vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
	putexcel (A15) = etable	
	logistic twodoses vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
	putexcel (A29) = etable	
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/conf models2d.xlsx", sheet("`x'")  modify		
	logistic twodoses conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
	putexcel (A1) = etable	
	logistic twodoses vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
	putexcel (A15) = etable	
	logistic twodoses vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
	putexcel (A29) = etable	
	}
* Import estimates
import excel using "$user/$analysis/conf models2d.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
foreach x in  Argentina Colombia India Korea  Uruguay Italy  Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/conf models2d.xlsx", sheet("`x'") firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="`x'"
	append using "$user/$analysis/graphs.dta"
	save "$user/$analysis/graphs.dta", replace
	}
	keep A B E F G country 
	foreach v in E B F G  {
		destring `v', replace
		gen ln`v' = ln(`v')
	}
	rename (B E F G) (aOR p_value LCL UCL)
	
* Create income groups	
	gen inc_group = 1 if country=="LaoPDR" | countr=="Kenya" | count=="Ethiopia" | country=="India"
	replace inc_group = 2 if count=="SouthAfrica" | count=="Peru" | count=="Mexico" | ///
						     count=="Argentina" | count=="Colombia"
	replace inc_group = 3 if count=="Uruguay" | count=="USA" | count=="Korea" | count=="Italy" | count=="UK"
	lab def inc_group 1"LMI"  2"UMI" 3"HI"
	lab val inc_group inc_group

* META ANALYSIS - by income groups
	local row = 1
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("national system")  modify
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
	
	putexcel set "$user/$analysis/pooled estimates2d.xlsx", sheet("national system_all")  modify
	foreach v in conf_getafford vconf_opinion vgcovid_manage  {
		metan lnB lnF lnG if A=="`v'" ,  ///
				eform nograph  label(namevar=country) effect(aOR)			 
	putexcel A`row'="`v'"
	matrix b= r(ovstats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}
