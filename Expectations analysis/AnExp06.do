********************************************************************************
* 	Title: 				Population expectations for quality					
* 	Prepared by:		Todd Lewis										
* 	Date updated:		July 9, 2025							
********************************************************************************

********************************************************************************
* Settings and data input
********************************************************************************

clear all
set more off
set maxvar 32767
set seed 88888
graph set window fontface "Times New Roman"
set graphics on
set scheme lean2

global user "/Users/t.lewis/Library/CloudStorage/Box-Box"
global project "/QuEST Network/Core Research/People's Voice Survey/PVS External"
global data "/Data/Multi-country/02 recoded data"

cd "$user/$project/Analyses/Expectations paper/Output"

use "$user/$project/Analyses/Expectations paper/Data/Expdata.dta", clear

********************************************************************************
*Normalizing weights to analytic subset (only impacts table 1 frequencies)
********************************************************************************

scalar desired_total = 18312
summ weight
scalar current_total = r(sum)
gen norm_weight = weight * (18312 / r(sum))

********************************************************************************
*Table 1 (export to excel)
********************************************************************************

svyset psu_id_for_svy_cmds, weight(norm_weight) strata(strata_var)

dtable age i.gender i.education i.income2 i.rural i.activation ///
	i.health i.health_mental i.health_chronic ///
	i.insured i.usual2 i.visits_bin i.wait i.unmet_need ///
	i.discrim i.mistake i.covid_manage i.country_reg i.vp i.vg, ///
	svy nformat(%4.0f) export(table1.xlsx, replace)
	
********************************************************************************
*Figure: Bar charts/scatter plots of low and high expectations (made in excel)
********************************************************************************

svy: mean vp_high, over(country_reg)
svy: mean vp_high


svy: mean vg_low, over(country_reg)
svy: mean vg_low

********************************************************************************
*Table: Regression models - two models: 1) low exp 2) high exp
********************************************************************************

svyset psu_id_for_svy_cmds, strata(strata_var)

logistic vp_high age gender i.education i.income2 rural activation ///
	i.health i.health_mental health_chronic ///
	insured usual2 visits_bin wait unmet_need ///
	discrim mistake i.covid_manage i.country_reg
	
logistic vg_low age gender i.education i.income2 rural activation ///
	i.health i.health_mental health_chronic ///
	insured usual2 visits_bin wait unmet_need ///
	discrim mistake i.covid_manage i.country_reg
	

