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

*create date var

ren P46_Minutos int_length


