* People's Voice Survey main code file 
* Date of last update: March 2025
* Last updated by: S Sabwa

/* Purpose of code file: 
	
	This file sets all macros and runs all data cleaning files for the 
	People's Voice Survey. The files create a combined multi-country dataset for 
	analysis. 
	
	Countries included: Ethiopia, Kenya, Nigeria, South Africa, Peru,
						Colombia, Mexico, Uruguay, Argentina, Lao PDR,
                        India, Rep. of Korea, Greece, Italy, United Kingdom
                        United States

	
*/

* Setting up files and macros
********************************************************************************

clear all
set more off

* Dropping any existing macros
macro drop _all

* Setting user globals 
*global user "/Users/nek096"
*global user "/Users/catherine.arsenault"
*global user "/Users/tol145"
global user "/Users/shs8688"


* Setting file path globals
global data "$user/Library/CloudStorage/Box-Box/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"
*global data "$user/Dropbox/SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder (includes input and output folders for data checks)
global data_mc "$data/Multi-country"

* Path to data input/output folders 
global in_out "$data_mc/03 input output"

* Path to GitHub folder 
global github "$user/Documents/GitHub/PVS-code"

/*
************************************************

* Clean each dataset separately 
run "$github/crPVS_cln_ET_IN_KE_ZA.do"
run "$github/crPVS_cln_CO_PE_UY.do"
run "$github/crPVS_cln_LA.do"
run "$github/crPVS_cln_IT_MX_US.do"
run "$github/crPVS_cln_KR.do"
run "$github/crPVS_cln_AR.do"
run "$github/crPVS_cln_GB.do"
run "$github/crPVS_cln_GR.do"
run "$github/crPVS_cln_RO.do"
run "$github/crPVS_cln_NG.do"
run "$github/crPVS_cln_ET_IN_KE_ZA_wave2.do"

* Append datasets 
run "$github/crPVS_append.do"

* Run Other specify 
*run "$github/crPVS_otherspecify"

* Adding derived variables for analysis
run "$github/crPVS_der.do"

* Installing packages and commands
************************************************
/*
* IPA's Stata Package for high-frequency checks
net install ipacheck, all replace from("https://raw.githubusercontent.com/PovertyAction/high-frequency-checks/master")
ipacheck update

ssc install elabel 
ssc install extremes
