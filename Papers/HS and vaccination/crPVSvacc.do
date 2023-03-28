* People's Voice Survey+ vaccination
* Created Feb 23, 2023
* C.Arsenault

global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country/02 recoded data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

u "$user/$data/pvs_all_countries.dta", clear

decode country, gen(c)
replace c = "LaoPDR" if country==11
replace c = "SouthAfrica" if country==9
replace c = "USA" if country==12
replace c = "Korea" if country==15

* Create covid vaccination variables
recode q14 (0/1=0) (2/4=1) if country==9 | country==3 | country==5, gen(fullvax2dose)
recode q14 (0/2=0) (3/4=1) if country ==2 | country==7 | country==10 | country==12 | ///
							  country ==13 | country ==14 | country ==15, gen(fullvax3dose)
recode q14_la (0/2=0) (3/4=1) if country ==11, gen(fullvax3d_la)					  
egen fullvax = rowmax (fullvax2d fullvax3d* )						  

* Other recoding
foreach v in health health_mental usual_quality last_qual covid_manage{
	recode `v' (1/2=0) (3/4=1), gen(vg`v')
}
recode age_cat (0/2=0) (3/6=1), gen(age2)
recode education (0/2=0) (3=1) , gen(educ2) 
egen preventive_score=rowtotal(blood_press blood_chol blood_sugar eyes teeth), m 
recode preventive_score (0/2=0) (3/5=1), gen(preventive) 
recode unmet_need (0=1) (1=0), gen(no_unmet_need)
recode system_outlook (1=0) (2=1), gen(getting_better)
recode system_reform (1/2=0) (3=1), gen(minor_changes)
recode visits_cat (1/2=1), gen(one_visit_or_more)
recode gender (2=1), gen(female)
recode income (0/1=0) (2=1), gen(high_income)

lab var age2 "Respondent aged 50+"
lab var educ2 "Post-secondary education"
lab var preventive "Received at leat 3 out of 5 preventive services"
lab var urban "Urban residence"
lab var vghealth "Rates own health as very good or excellent"
lab var health_chronic "Has a longstanding illness or chronic health problem"
lab var ever_covid "Had COVID-19"
lab var no_unmet_need "Had no unmet need for health care in the past year"
lab var conf_getafford "Confident would get and afford quality care"
lab var getting_better "Believes the health system is getting better in past 2 years"
lab var minor_changes "Believes the health system works well"

save "$user/$analysis/pvs_vacc_analysis.dta", clear
