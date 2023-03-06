* People's Voice Survey+ vaccination
* Created Feb 23, 2023
* C.Arsenault

global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

cd "$user/$analysis"

u "$user/$data/pvs_all_countries.dta", clear

decode country, gen(c)
replace c = "LaoPDR" if country==11
replace c = "SouthAfrica" if country==9
replace c = "USA" if country==12

* Create covid vaccination variables
recode q14 (0/1=0) (2/4=1) if country==9 | country==3 | country==5, gen(fullvax1)
recode q14 (0/2=0) (3/4=1) if country ==2 | country==7 | country==10 | country==11 | ///
							  country ==12 | country ==13 | country ==14, gen(fullvax2)
egen fullvax = rowmax (fullvax1 fullvax2)						  
drop 	fullvax1  fullvax2


* Create binary vars
foreach v in health health_mental usual_quality last_qual {
	recode `v' (1/2=0) (3/4=1), gen(vg`v')
}
recode system_outlook (1=0) (2=1), gen(getting_better)
recode system_reform (1/2=0) (3=1), gen(minor_changes)

********************************************************************************
* Analysis						  
tab   country fullvax [aw=weight], row nofreq


foreach x in Peru Italy Uruguay Mexico LaoPDR USA Colombia Kenya SouthAfrica Ethiopia {
	
summtab if c=="`x'", catvars(gender urban education income insured vghealth ///
					health_chronic ever_covid usual_source usual_type_own  ///
					vgusual_quality vglast_qual blood_pressure mammogram cervical_cancer ///
					eyes_exam teeth_exam blood_sugar blood_chol mistake discrim ///
					unmet_need conf_sick conf_afford system_outlook system_reform covid_manage) ///
					contvars(age visits_total) pval mean meanrow catrow by(fullvax) wts(weight) ///
					replace excel excelname(table1)  sheetname("`x'") 
}

table country conf_sick [aw=weight], stat(mean fullvax)
table country conf_afford [aw=weight], stat(mean fullvax)
table country getting_better [aw=weight], stat(mean fullvax)
table country minor_changes [aw=weight], stat(mean fullvax)

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
		
		