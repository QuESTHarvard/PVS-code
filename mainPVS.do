* People's Voice Survey main code file 
* Date of last update: February 2023
* Last updated by: N Kapoor

/* Purpose of code file: 
	This file sets all macros and runs all cleaning and analysis files for the 
	People's Voice Survey.
	
	Countries included: Colombia, Ethiopia, Kenya, Laos, Peru, South Africa, Uruguay
*/

* Setting up files and macros
********************************************************************************

clear all
set more off

* Dropping existing macros
macro drop _all

* Setting user globals 
global user "/Users/nek096"
*global user "/Users/catherine.arsenault"
*global user "/Users/tol145"
*global user "/Users/rodba"
global user "/Users/shalomsabwa"

* Setting file path globals
global data "$user/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"
*global data "$user/Dropbox/SPH Kruk QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder (includes input and output folders for data checks)
global data_mc "$data/Multi-country"

* Path to data check output folders (TBD)
global output "$data_mc/03 test output/Output"

* Path to GitHub folder 
global github "$user/Documents/GitHub/PVS-code"


* Installing packages and commands
************************************************

* IPA's Stata Package for high-frequency checks
net install ipacheck, all replace from("https://raw.githubusercontent.com/PovertyAction/high-frequency-checks/master")
ipacheck update

ssc install elabel // Mia: I used this pacakge to combine the value labels
* Running cleaning and analysis files
************************************************

* Initial data cleaning to create multi-country dataset 
run "$github/crPVS_cln_all.do"
run "$github/crPVS_cln_LA.do"
run "$github/crPVS_cln_IT_MX_US.do"

* Adding derived variables for analysis
run "$github/crPVS_der.do"

* Creating megatable 
* run "$github/anPVS_mtbl.do"

