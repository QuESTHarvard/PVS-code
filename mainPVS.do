* People's Voice Survey main code file 
* Date of last update: April 2023
* Last updated by: N Kapoor, S Sabwa, M Yu

/* Purpose of code file: 
	
	This file sets all macros and runs all data cleaning files for the 
	People's Voice Survey. The files create a combined multi-country dataset for 
	analysis. 
	
	Countries included: Ethiopia, India, Kenya, South Africa, Colombia, Peru, 
	Uruguay, Italy, Mexico, United States, United Kingdom, Lao PDR, Rep. of Korea, 
	Argentina (Mendoza province)
	
*/

* Setting up files and macros
********************************************************************************

clear all
set more off

* Dropping any existing macros
macro drop _all

* Setting user globals 
global user "/Users/nek096"
*global user "/Users/catherine.arsenault"
*global user "/Users/tol145"
*global user "/Users/rodba"
*global user "/Users/shs8688"


* Setting file path globals
global data "$user/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"
*global data "$user/Dropbox/SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder (includes input and output folders for data checks)
global data_mc "$data/Multi-country"

* Path to data input/output folders 
global in_out "$data_mc/03 input output"

* Path to GitHub folder 
global github "$user/Documents/GitHub/PVS-code"


* Installing packages and commands
************************************************

* IPA's Stata Package for high-frequency checks
net install ipacheck, all replace from("https://raw.githubusercontent.com/PovertyAction/high-frequency-checks/master")
ipacheck update

ssc install elabel 
ssc install extremes

************************************************

* Clean each dataset separately 
run "$github/crPVS_cln_ET_IN_KE_ZA.do"
run "$github/crPVS_cln_CO_PE_UY.do"
run "$github/crPVS_cln_LA.do"
run "$github/crPVS_cln_IT_MX_US.do"
run "$github/crPVS_cln_KR.do"
run "$github/crPVS_cln_AR.do"
run "$github/crPVS_cln_BR.do"

* Append datasets 
run "$github/crPVS_append.do"

* Adding derived variables for analysis
run "$github/crPVS_der.do"


