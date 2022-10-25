* PVS Main file 
* September 2022
* N. Kapoor 
* This file sets all macros and runs all .do files
* Note to Todd: Eventually, any absolutely necessary globals from the globals will be added here 
* This is based on the data and files being in the internal file, file paths will change 


************************************************
* Drop all macros
macro drop _all

*Project settings
*Individual users 
global user "/Users/nek096"

* Path to data folder 
global data "$user/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data"

* Path to multi-country data folder (includes input and output folders for HFCs)
global data_mc "$data/Multi-country"

* Path to HFC output folders
global output "$data_mc/03 hfc/Output"

* Path to GitHub folder 
global github "$user/Documents/GitHub/PVS-code"

************************************************
* Required packages 
* IPA's Stata Package for HFCs
net install ipacheck, all replace from("https://raw.githubusercontent.com/PovertyAction/high-frequency-checks/master")
ipacheck update

************************************************
* Run Globals 
run "$github/1_globals_pvs.do"

* Initial data cleaning (prepping for HFC)
run "$github/2_cr01_pvs.do"

run "$github/3_cr01_pvs.do"

* High frequency checks 
run "$github/4_hfc_pvs.do"

* Descriptive Analysis 
run "$github/5_an01_pvs.do"
