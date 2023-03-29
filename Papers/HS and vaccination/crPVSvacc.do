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

* COVID vaccination: 2+ or 3+ doses and continuous number of doses
recode q14 (0/1=0) (2/4=1) if country==9 | country==3 | country==5, gen(fullvax2dose)
recode q14 (0/2=0) (3/4=1) if country ==2 | country==7 | country==10 | country==12 | ///
							  country ==13 | country ==14 | country ==15, gen(fullvax3dose)
recode q14_la (0/2=0) (3/4=1) if country ==11, gen(fullvax3d_la)			
		  
egen fullvax = rowmax (fullvax2d fullvax3d* )	

gen nb_doses=q14
					  			
* Other recoding
foreach v in health_mental usual_quality {
	recode `v' (1/2=0) (3/4=1), gen(vg`v')
}

gen qual_system= qual_public 
replace qual_system = qual_private if c=="USA" // quality of private sector in the USA
replace qual_system= q56a_mx if c=="Mexico" // quality of IMSS in Mexico
lab val qual_system exc_poor

recode unmet_need (0=1) (1=0), gen(no_unmet_need)

egen preventive_score=rowtotal(blood_press blood_chol blood_sugar eyes teeth), m 
recode preventive_score (0/2=0) (3/5=1), gen(preventive) 

recode age_cat (5/6=4), gen(age5)
lab def age5 0"18 to 29" 1"30-39" 2"40-49" 3"50-59" 4"60+"
lab val age5 age5  

recode education (0=1) , gen(educ3) 
lab def educ3 1 "None or primary only" 2 "Secondary" 3"Post-secondary"
lab val educ3 educ3

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


save "$user/$analysis/pvs_vacc_analysis.dta", replace
