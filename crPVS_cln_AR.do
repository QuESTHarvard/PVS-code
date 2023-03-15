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

*2 vars for q5
*ren P5 q5
*ren SampleFieldls_SampPROVINCIA_DS q5

ren P8 q8
ren P9 q9
ren P10 q10
ren P11 q11
ren P12 q12
ren P13 q13
ren P13_E_10 q13e_other
ren P14 q14
ren P15 q15
ren P16 q16
ren P17 q17
ren P18 q18
ren P19 q19
ren P19_4 q19_other
ren P20 q20
ren P22 q22
ren P23 q23












 



