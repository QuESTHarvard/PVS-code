
* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023
* Figure 1 and Table 1 and utilization model 

********************************************************************************
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

cd "$user/$analysis/"
u "$user/$analysis/pvs_vacc_analysis.dta", clear
*net install collin
clear all
set more off
********************************************************************************
* FIGURE 1 COVID DOSES
ta nb_doses c  [aw=weight] , nofreq col
********************************************************************************
* TABLE 1	
summtab, catvars(usual_source  preventive unmet_need  ///
				 usual_public_fac vgusual_quality discrim  ///
				 health_chronic ever_covid post_secondary high_income female urban minority) ///
		         contvars(age visits4) by(country) mean meanrow catrow wts(weight) ///
		         replace excel excelname(Table_1)  				
********************************************************************************
* COUNTRY-SPECIFIC REGRESSIONS - UTILIZATION
foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {

	putexcel set "$user/$analysis/utilization model.xlsx", sheet("`x'")  modify
			
	logistic fullvax i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
	putexcel (A1) = etable	
	}
foreach x in Argentina Colombia India Korea Uruguay Italy {

	putexcel set "$user/$analysis/utilization model.xlsx", sheet("`x'")  modify
			
	logistic fullvax i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
	putexcel (A1) = etable	
	}
* Import estimates
import excel using "$user/$analysis/utilization model.xlsx", sheet(Ethiopia) firstrow clear
	drop if B=="" | B=="Odds ratio"
	gen country="Ethiopia"
	save "$user/$analysis/graphs.dta", replace
	
foreach x in  Argentina Colombia India Korea  Uruguay Italy  Kenya LaoPDR Mexico Peru SouthAfrica USA UK { 
	import excel using  "$user/$analysis/utilization model.xlsx", sheet("`x'") firstrow clear
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
	
*Supplemental table 
	export excel using "$user/$analysis/supp table utilization.xlsx", sheet(Sheet1) firstrow(variable) replace 
* GRAPHS UTILIZATION MODELS
	preserve 
	replace UCL=6 if UCL==6.89416 // Uruguay outlier UCL
		twoway (rspike UCL LCL co if A=="1-2 visits", lwidth(medthick) lcolor(navy)) ///
			   (scatter aOR co if A=="1-2 visits", msize(medsmall) mcolor(ebblue*2)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
					   10"PER" 11"ZAF" 12"GBR" 13"USA" 14"URY", labsize(vsmall)) xtitle("") ///
				ylabel(0.40(0.4)6, labsize(tiny) gstyle(minor)) ///
				yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
				title("Had 1 or 2 visits in last year", size(medium))
		 
		graph export "$user/$analysis/1-2 visits.pdf", replace 

		* GRAPHS UTILIZATION MODELS
		twoway (rspike UCL LCL co if A=="3-4 visits", lwidth(medthick) lcolor(navy)) ///
			   (scatter aOR co if A=="3-4 visits", msize(medsmall) mcolor(ebblue*2)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
					   10"PER" 11"ZAF" 12"GBR" 13"USA" 14"URY", labsize(vsmall)) xtitle("") ///
				ylabel(0.40(0.4)6, labsize(tiny) gstyle(minor)) ///
				yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
				title("Had 3 or 4 visits in last year", size(medium))
		 
		graph export "$user/$analysis/3-4 visits.pdf", replace 

			* GRAPHS UTILIZATION MODELS
		twoway (rspike UCL LCL co if A=="5 or more visits", lwidth(medthick) lcolor(navy)) ///
			   (scatter aOR co if A=="5 or more visits", msize(medsmall) mcolor(ebblue*2)) , ///
				graphregion(color(white)) legend(off) ///
				xlabel(1"ARG" 2"COL" 3"ETH" 4"IND" 5"ITA" 6"KEN" 7"KOR" 8"LAO" 9"MEX" ///
					   10"PER" 11"ZAF" 12"GBR" 13"USA" 14"URY", labsize(vsmall)) xtitle("") ///
				ylabel(0.40(0.4)6, labsize(tiny) gstyle(minor)) ///
				yline(1, lstyle(foreground) lcolor(red)) xsize(1) ysize(1) ///
				title("Had 5 or more visits in last year", size(medium))
		 
		graph export "$user/$analysis/5+ visits.pdf", replace 	
	restore 
	
* META ANALYSIS- by income groups
	local row = 1
	
	putexcel set "$user/$analysis/pooled estimates.xlsx", sheet("utilization")  modify
	foreach v in 1-2visits  3-4visits 5ormorevisits {
	
		metan lnB lnF lnG if A=="`v'"  , by(inc_group) ///
				eform nograph  label(namevar=country) effect(aOR) 
	putexcel A`row'="`v'"
	matrix b= r(bystats)
	putexcel B`row'= matrix(b), rownames 
	local row = `row' + 9
	}

