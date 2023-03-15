* People's Voice Survey data cleaning for Argentina
* Last updated: March 14 2023
* N. Kapoor, S. Sabwa

************************************* Argentina ************************************

* Import data 
use "/Users/shalomsabwa/Downloads/Re_ PVS Mendoza Links/PVS_Mendoza_Data_23.01.27.dta", clear

* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 

ren LanguageID Language
ren P46_Minutos int_length
ren pond weight
ren P1 q1
ren SampleFields_SampEDAD q2

*2 gender vars?
*ren P3_A q3
*ren SampleFields_SampSEXO

*Argentina specific: "Are you a man or woman?"
*ren P3_B

*2 "area" vars
*ren P4 q4
*ren SampleFields_SampZONAP3A


 



