* People's Voice Survey data cleaning for Argentina
* Last updated: March 14 2023
* N. Kapoor, S. Sabwa

************************************* Argentina ************************************

* Import data -confirm Path
use "/Users/shs8688/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Argentina (Mendoza)/01 raw data/PVS_Mendoza_Data_23.01.27.dta", clear

* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 

ren LanguageID Language
ren P46_Minutos int_length
ren pond weight
ren P1 q1
ren SampleFields_SampEDAD q2
ren P3_A q3
ren P4 q4
ren P5 q5
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
ren P21 q21
ren P21_10 q21_other
ren P22 q22
ren P23 q23
ren P24 q24
ren P25 q25_a
ren P25_B q25_b
ren P26 q26
ren P27 q27
ren P28 q28_a
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
ren P46 q46
ren P47 q47
ren P48_1_C q48_a
ren P48_2_C q48_b
ren P48_3_C q48_c
ren P48_4_C q48_d
ren P48_5_C q48_e
ren P48_6_C q48_f
ren P48_7_C q48_g
ren P48_8_C q48_h
ren P48_9_C q48_i
ren P48_10_C q48_j
ren P49 q49
ren P50_1_C q50_a
ren P50_2_C q50_b
ren P50_3_C q50_c
ren P50_4_C q50_d
ren P51 q51
ren P52 q52
ren P53 q53
ren P54 q54
ren P55 q55
ren P56 q56
ren P57 q57
ren P58 q58
ren P59 q59
ren P60 q60
ren P61 q61
ren P63 q63
ren P64 q64
ren P65 q65



*for Q20_B:
gen q44_other = q44_other_it + q44_other_mx + q44_other_us



* combine all q7
recode q46b_1 q46b_2 q46b_3 (. = 0) if q46b_1 < . | q46b_2 < . |q46b_3< .
gen q46b = (q46b_1/24) + q46b_2 + (q46b_3*7)






 



