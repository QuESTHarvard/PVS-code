* People's Voice Survey+ vaccination
* Created Feb 23, 2023
* C.Arsenault

global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Multi-country (shared)"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Paper 7 vaccination/Results"

clear all
set more off

u "$user/$data/pvs_all_countries.dta", clear

decode country, gen(c)
replace c = "LaoPDR" if country==11
replace c = "SouthAfrica" if country==9
replace c = "USA" if country==12
replace c = "Korea" if country==15
replace c = "Argentina" if country==16
replace c ="UK" if country==17

* COVID vaccination: 2+ or 3+ doses and continuous number of doses
	recode q14 (0/1=0) (2/4=1) if c=="Ethiopia" | c=="Kenya" | c=="SouthAfrica", gen(fullvax2dose)
	recode q14 (0/2=0) (3/4=1) if country ==2 | country==4 | country==7 | country==10 | country==12 | ///
								  country ==13 | country ==14 | country ==15  | ///
								  country ==16 | country==17 , gen(fullvax3dose)
	recode q14_la (0/2=0) (3/4=1) if country ==11, gen(fullvax3d_la)					  
	egen fullvax = rowmax(fullvax2d fullvax3d* )	
	
	recode q14 (1/4=1), gen(onedose)
	replace onedose=. if country==2 | country==4 | country==7 | country>9 // only in SSA
	gen nb_doses=q14
	replace nb_doses = q14_la if nb_doses==.a
	
	recode q14 (0/1=0) (2/4=1) , gen(twodoses)
	recode q14_la (0/1=0) (2/4=1), gen(twodosesla)
	replace twodoses= twodosesla if twodoses==.a 
	drop twodosesla
	
* Health system variables
	recode visits_total (1/2=1) (2.5/4.5=2) (5/250=3), gen(visits4)
	lab def visits4 0"No visits" 1"1-2visits" 2"3-4visits" 3"5ormorevisits"
	lab val visits4 visits4
	
	gen qual_system= qual_public
	replace qual_system = qual_private if c=="USA" | c=="Korea"
	replace qual_system = q56a_mx if c=="Mexico"
	lab var qual_system "Quality of main health system"
	
	foreach v in usual_quality covid_manage qual_system {
		recode `v' (1/2=0) (3/4=1), gen(vg`v') 
		}
	recode conf_opinion (0/1=0) (2/3=1), gen(vconf_opinion)

	egen preventive_score=rowtotal(blood_press blood_chol blood_sugar eyes teeth), m 
	recode preventive_score (0/2=0) (3/5=1), gen(preventive) 
	
	recode system_reform (1/2=0) (3=1), gen(workswell)
	
	* Demographics
	recode age_cat (0/2=0) (3/6=1), gen(age2)
	lab def age2  1"18-49" 2"50+"
	lab val age2 age2

	recode education (0=1) , gen(educ3) 
	lab def educ3 1 "None or primary only" 2 "Secondary" 3"Post-secondary"
	lab val educ3 educ3

	recode education (0/2=0) (3=1) , gen(post_secondary) 
	recode income (0/1=0) (2=1), gen(high_income)
	recode gender (2=1), gen(female)

	recode minority (2=1) 
	replace minority = . if c=="Colombia" | c=="Korea" | c=="India"
	
	
	lab var fullvax "Received 2+ or 3+ doses of a COVID vaccine"
	lab var onedose "Received at least 1 dose of a COVID vaccine"
	lab var preventive "Received at leat 3 other preventive health services"
	lab var urban "Urban residence"
	lab var health_chronic "Has a longstanding illness or chronic health problem"
	lab var ever_covid "Had COVID-19"
	lab var vgusual_quality "Rates quality of usual facility as very good or excellent"
	lab var workswell "Believes health system works well and only minor changes needed"
	
save "$user/$analysis/pvs_vacc_analysis.dta", replace
