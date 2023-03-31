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
replace c = "Argentina" if country==16

* COVID vaccination: 2+ or 3+ doses and continuous number of doses
recode q14 (0/1=0) (2/4=1) if c=="Ethiopia" | c=="Kenya" | c=="SouthAfrica", gen(fullvax2dose)
recode q14 (0/2=0) (3/4=1) if country ==2 | country==7 | country==10 | country==12 | ///
							  country ==13 | country ==14 | country ==15  | country ==16, gen(fullvax3dose)
							  
recode q14_la (0/2=0) (3/4=1) if country ==11, gen(fullvax3d_la)			
		  
egen fullvax = rowmax(fullvax2d fullvax3d* )	

rename q14 nb_doses

* Health system variables
gen qual_system= qual_public 
replace qual_system = qual_private if c=="USA" // quality of private sector in the USA
replace qual_system= q56a_mx if c=="Mexico" // quality of IMSS in Mexico
lab val qual_system exc_poor
				  			
foreach v in health_mental usual_quality last_qual  ///
			 last_skills last_supplies last_respect last_explain ///
			  last_visit_rate last_wait_rate {
	recode `v' (1/2=0) (3/4=1), gen(vg`v')
}

egen quality_score_last= rowmean(vglast_skills vglast_supplies vglast_respect vglast_explain vglast_skills vglast_visit_rate vglast_wait_rate)
recode quality_score_last (0/0.49=0) (0.5/1=1), gen(quality_last)

recode unmet_need (0=1) (1=0), gen(no_unmet_need)

egen preventive_score=rowtotal(blood_press blood_chol blood_sugar eyes teeth), m 
recode preventive_score (0/2=0) (3/5=1), gen(preventive) 

recode usual_quality (3/4=2) (0/2=1), gen(usual3cat)
replace usual3=0 if usual_source==0
lab def usual3 0"No usual source of care" 1"Poor-Good quality usual source" ///
			   2"VGood or excellent quality ussual source" 
lab val usual3 usual3

recode usual_type_own (0=1) (1/2=0), gen(usual_public_fac)
replace public_fac=1 if q20==12003 | q20==12004 // miscoded in the USA

recode usual_type_lvl (0=1) (1=0), gen(usual_primary_fac)

recode last_type_own (0=1) (1/2=0), gen(last_public)

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

recode minority (2=1) (3033/9995=.) // MINORITY ETHNIC GROUP CODING IS PENDING IN SOME COUNTRIES

lab var fullvax "Received 2+ or 3+ doses of a COVID vaccine"
lab var nb_doses "Number of COVID vacicne doses received"
lab var preventive "Received at leat 3 out of 5 preventive services"
lab var urban "Urban residence"
lab var vghealth_mental "Rates own mental health as very good or excellent"
lab var health_chronic "Has a longstanding illness or chronic health problem"
lab var ever_covid "Had COVID-19"
lab var no_unmet_need "Had no unmet need for health care in the past year"
lab var usual_source "Has a usual source of care"
lab var vgusual_qual "High quality usual source"
lab var vglast_qual "High quality last visit"
lab var quality_last "Quality score in last visit >50%"

save "$user/$analysis/pvs_vacc_analysis.dta", replace
