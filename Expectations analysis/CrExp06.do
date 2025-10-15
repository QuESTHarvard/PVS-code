********************************************************************************
* 	Title: 				Population expectations for quality					
* 	Prepared by:		Todd Lewis										
* 	Date updated:		June 18, 2025								
********************************************************************************

********************************************************************************
* Settings and data input
********************************************************************************
	
clear all
set more off
set maxvar 32767
set seed 88888

global user "/Users/t.lewis/Library/CloudStorage/Box-Box"
global project "/QuEST Network/Core Research/People's Voice Survey/PVS External"
global data "/Data/Multi-country/02 recoded data"

use "$user/$project/$data/pvs_all_countries_v2.dta", clear

cd "$user/$project/Analyses/Expectations paper/Output"

********************************************************************************
* Country and set-up variables
********************************************************************************

*Drop countries that used v2 with new vignettes
drop if country==22 //Somaliland
drop if country==23 //Nepal
drop if country==1 // Ecuador

drop if wave==2

* Colombia
gen CO = country == 2
label variable CO "Colombia"

* Ethiopia
gen ET = country == 3
label variable ET "Ethiopia"

* India
gen IN = country == 4
label variable IN "India"

* Kenya
gen KE = country == 5
label variable KE "Kenya"

* Peru
gen PE = country == 7
label variable PE "Peru"

* South Africa
gen ZA = country == 9
label variable ZA "South Africa"

* Uruguay
gen UY = country == 10
label variable UY "Uruguay"

* Lao PDR
gen LA = country == 11
label variable LA "Lao PDR"

* United States
gen US = country == 12
label variable US "United States"

* Mexico
gen MX = country == 13
label variable MX "Mexico"

* Italy
gen IT = country == 14
label variable IT "Italy"

* Republic of Korea
gen KR = country == 15
label variable KR "Republic of Korea"

* Argentina (Mendoza)
gen AR = country == 16
label variable AR "Argentina (Mendoza)"

* United Kingdom
gen GB = country == 17
label variable GB "United Kingdom"

* Greece
gen GR = country == 18
label variable GR "Greece"

* Romania
gen RO = country == 19
label variable RO "Romania"

* Nigeria
gen NG = country == 20
label variable NG "Nigeria"

* China
gen CN = country == 21
label variable CN "China"

* Create a copy of the existing country_reg
gen byte old_country_reg = country_reg

* Recode country_reg based on GDP per capita order
replace country_reg = 1  if old_country_reg == 2   // Ethiopia
replace country_reg = 2  if old_country_reg == 4   // Nigeria
replace country_reg = 3  if old_country_reg == 3   // Kenya
replace country_reg = 4  if old_country_reg == 5   // South Africa
replace country_reg = 5  if old_country_reg == 7   // Colombia
replace country_reg = 6  if old_country_reg == 6   // Peru
replace country_reg = 7  if old_country_reg == 8   // Mexico
replace country_reg = 8  if old_country_reg == 10  // Argentina
replace country_reg = 9  if old_country_reg == 9   // Uruguay
replace country_reg = 10 if old_country_reg == 12  // Lao PDR
replace country_reg = 11 if old_country_reg == 14  // India
replace country_reg = 12 if old_country_reg == 15  // China
replace country_reg = 13 if old_country_reg == 16  // South Korea
replace country_reg = 14 if old_country_reg == 17  // Romania
replace country_reg = 15 if old_country_reg == 18  // Greece
replace country_reg = 16 if old_country_reg == 19  // Italy
replace country_reg = 17 if old_country_reg == 20  // United Kingdom
replace country_reg = 18 if old_country_reg == 21  // United States

* Step 3: Re-apply value labels to match new codes
label define country_reg_lbl ///
    1 "Ethiopia" ///
    2 "Nigeria" ///
    3 "Kenya" ///
    4 "South Africa" ///
    5 "Colombia" ///
    6 "Peru" ///
    7 "Mexico" ///
    8 "Argentina" ///
    9 "Uruguay" ///
    10 "Laos" ///
    11 "India" ///
    12 "China" ///
    13 "South Korea" ///
    14 "Romania" ///
    15 "Greece" ///
    16 "Italy" ///
    17 "United Kingdom" ///
    18 "United States", replace

label values country_reg country_reg_lbl

decode country_reg, generate(strata_var)
replace strata_var = "Ethiopia_CATI" if country==3 & mode==1
replace strata_var = "Ethiopia_F2F" if country==3 & mode==2
replace strata_var = "Kenya_CATI" if country==5 & mode==1
replace strata_var = "Kenya_F2F" if country==5 & mode==2

********************************************************************************
*Outcomes
********************************************************************************

*Renaming vignette variables
rename vignette_poor vp
rename vignette_good vg

*High and low expectations

	*Rating poor vignette highly (exp too low)
	gen vp_high = .
		replace vp_high = 1 if vp>0 & vp<.
		replace vp_high = 0 if vp==0

	*Rating excellent care poorly (exp too high)
	gen vg_low = .
		replace vg_low = 1 if vg<3
		replace vg_low = 0 if vg==3 | vg==4
	
********************************************************************************
* Covariates
********************************************************************************

*Age: as derived

*Gender
recode gender (2 = 1)
lab var gender "female"

label define lab_gender 0 "Male" 1 "Female"
	label values gender lab_gender

*Education: as derived

*Rural (inverted)
recode urban 0=1 1=0, gen(rural)
lab var rural "Rural"
label define lab_rural 1 "Rural" 0 "Urban"
	label values rural lab_rural

*Income--adjusting to include Kenya (include table note)
gen income2=income
	replace income2=0 if q51==5001
	replace income2=1 if q51==5002
	replace income2=2 if q51>5002 & q51<5008
label define lab_income2 0 "Lowest income" 1 "Middle income" 2 "Highest income"
	label values income2 lab_income2

*Insured: as derived

*Activation: as derived

*Visits: visits_cat (binarized; otherwise omitted from models)
recode visits_cat 1=0 2=1, gen(visits_bin)
lab var visits_bin "Visits"
label define lab_visits 0 "4 or fewer" 1 "More than 4"
	label values visits_bin lab_visits

*Usual source: private vs public/other
	gen usual2=usual_type_own
		replace usual2=0 if usual_type_own==2
		
	lab var usual2 "Usual type: public/other vs private"

	label define lab_usual2 0 "Public/other" 1 "Private"
		label values usual2 lab_usual2

*Discrimination: as derived

*Mistake: as derived

*Unmet need: as derived

*Wait time:
gen wait=last_wait_time
	replace wait=0 if last_wait_time==0 | last_wait_time==1
	replace wait=1 if last_wait_time==2
	
	label define lab_wait 0 "Less than 1 hour" 1 "1 hour or more"
		label values wait lab_wait

*Self-rated health
rename q9 health

*Self-rated mental health
rename q10 health_mental

*Chronic illness: as derived

*Pandemic management
rename q47 covid_manage

***Dropping unsuable records***

*Dropping those who refused to answer vignettes (n=313)
drop if vg==.r | vp==.r

mdesc age gender education rural income2 insured activation visits_bin usual2 discrim mistake unmet_need wait health health_mental health_chronic covid_manage 

egen miss = rowmiss(age gender education rural income2 insured activation visits_bin usual2 discrim mistake unmet_need wait health health_mental health_chronic covid_manage)

drop if miss>0

********************************************************************************

save "$user/$project/Analyses/Expectations paper/Data/Expdata.dta", replace
