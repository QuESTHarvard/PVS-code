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

*what is the int_length var?
*ren P46_Minutos int_length

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
ren P24 q24
ren P25 q25_a
ren P25_B q25_b
ren P26 q26
ren P27 q27
ren P28_B q28_b
ren P29 q29
ren P30 q30
ren P31 q31
ren P32 q32
ren P33 q33
ren P34 q34
ren P35 q35
ren P36 q36
ren P38 q38
ren P39 q39
ren P40 q40
ren P41 q41
ren P42 q42
ren P42_11 q42_other
ren P43 q43
ren P43_4 q43_other
ren P44 q44
ren P45 q45
ren P45_4 q45_other

*P46_Minutos = int_length or q46
*ren P46_Minutos q46

ren P47 q47
ren P48_1_C q48_a
ren P48_2_C q48_b
ren P48_3_C q48_c
ren P48_4_C q48_d
ren P48_5_C q48_e
ren P48_6_C q48_f
ren 













 



