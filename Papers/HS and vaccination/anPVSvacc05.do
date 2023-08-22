* Analysis: Health system quality and COVID vaccination in 14 countries
* Created by C.Arsenault, April 2023

* CHECKING FOR MULTICOLLINEARITY 

global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

u "$user/$analysis/pvs_vacc_analysis.dta", clear
cd "$user/$analysis/"

set more off

*------------------------------------------------------------------------------*
* UTILIZATION MODEL
foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {

	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify
	putexcel (A1) ="Utilization model"		
	logistic fullvax i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
				vif, uncentered
				putexcel (A2) =rscalars
	}
	
foreach x in Argentina Colombia India Korea Uruguay Italy {

	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify
	putexcel (A1) ="Utilization model"	
	logistic fullvax i.visits4 ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority		
				vif, uncentered
				putexcel (A2) =rscalars
	}
	
*------------------------------------------------------------------------------*
* HEALTH SYSTEM COMPETENCE, QUALITY & UX MODELS

foreach x in  Ethiopia  Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify	
	putexcel (B1) ="Health system competence model"	
	logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with minority		
				vif, uncentered
	putexcel (B2) = rscalars
	
	putexcel (C1) ="Quality & UX model"	
	logistic fullvax vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  minority if c=="`x'", vce(robust)	
				vif, uncentered
	putexcel (C2)= rscalars
	}
	
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify
	putexcel (B1) ="Health system competence model"	
	logistic fullvax usual_source preventive unmet_need ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without minority
				vif, uncentered
	putexcel (B2) = rscalars
	
	putexcel (C1) ="Quality & UX model"	
	logistic fullvax vgusual_quality discrim mistake  ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust)	
				vif, uncentered
	putexcel (C2) = rscalars
	}	
	
*------------------------------------------------------------------------------*
* CONFIDENCE MODELS
foreach x in  Ethiopia Kenya LaoPDR Mexico Peru SouthAfrica USA UK {
	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify	
	putexcel (D1) ="Conf get afford"
	logistic fullvax conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) // countries with the variable minority
				vif, uncentered
	putexcel (D2) = rscalars
	
	putexcel (E1) ="Conf opinion"
	logistic fullvax vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
				vif, uncentered
	putexcel (E2) = rscalars
	
	putexcel (F1) ="Covid manage"
	logistic fullvax vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban minority if c=="`x'", vce(robust) 
				vif, uncentered
	putexcel (F2) = rscalars	
	}
	
foreach x in Argentina Colombia India Korea Uruguay Italy {
	putexcel set "$user/$analysis/vif.xlsx", sheet("`x'")  modify	
		putexcel (D1) ="Conf get afford"
	logistic fullvax conf_getafford ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) // countries without the variable minority	
				vif, uncentered
	putexcel (D2) = rscalars	
	
	putexcel (E1) ="Conf opinion"
	logistic fullvax vconf_opinion ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
				vif, uncentered
	putexcel (E2) = rscalars	
	
	putexcel (F1) ="Covid manage"
	logistic fullvax vgcovid_manage ///
				age2 health_chronic ever_covid post_secondary ///
				high_income female urban  if c=="`x'", vce(robust) 
				vif, uncentered
	putexcel (F2) = rscalars	
	}
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	