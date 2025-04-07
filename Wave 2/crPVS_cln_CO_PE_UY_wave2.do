* People's Voice Survey data cleaning for Colombia, Peru, Uruguay  
* Date of last update: April 2023
* Last updated by: N Kapoor, S Sabwa, M Yu

/*

This file cleans Ipsos data for Colombia, Uruguay, Peru. 

Cleaning includes:
	- Recoding implausible values 
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction 
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 

*/

*************************** Colombia, Peru, Uruguay ****************************

clear all

* Import raw data 

import spss using "$data/LAC wave2/01 raw data/PVS_LATAM_wave2_weighted.sav", case(lower)


*Label as wave 2 data:
gen wave = 2

*dropping interviewer vars:
drop respondent_serial_sourcefile intro intro_repregunta pa pa_repregunta red_quest control_calidad ///	
	 p1_codes p4_col_pesos p4_per_pesos p4_uru_pesos

	 
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 


rename pais country 

rename (p1 p2) (q1 q2)

rename p3_a q3_a // double check which q3 var is sex vs gender
rename p3 q3

gen q4 = p4_col
replace q4 = p4_per if country == 2
replace q4 = p4_uru if country == 3

              p5_col p5_per p5_uru p6_latam_col1 p6_latam_col2 p6_latam_col3 p6_latam_col4 p6_latam_col5 p6_latam_col6 p6_latam_col7 p6_latam_col8 p6_latam_col9 p6_latam_col_9 p6_latam_per1 p6_latam_per2 p6_latam_per3 p6_latam_per4 p6_latam_per5 p6_latam_per6 p6_latam_per_6 p6_latam_uru1 p6_latam_uru2 p6_latam_uru3 p6_latam_uru4 p6_latam_uru5 p6_latam_uru6 p6_latam_uru_6 p7_latam_col p7_latam_col_9 p7_latam_per p7_latam_per_6 p7_latam_uru p8_col p8_per p8_uru p9 p10 p11 p12a p12b p13 p13_a_col p13_a_col_4 p13_a_per p13_a_per_4 p13_a_uru_4 p13_a_uru p14_col p14_col_3 p14_per p14_per_5 p14_uru p14_uru_4 p15a_col p15a_col_3 p15a_col_4 p15a_per p15a_per_4 p15a_per_5 p15a_uru p15a_uru_3 p15a_uru_4 p15b_col p15b_col_3 p15b_col_4 p15b_per p15b_per_5 p15b_per_6 p15b_uru p15b_uru_3 p15b_uru_4 p15b_uru_5 p15c_col p15c_col_1 p15c_col_2 p15c_per p15c_per_4 p15c_per_5 p15c_uru p15c_uru_3 p15c_uru_4 p15c_uru_5 p15d_per p15d_per_3 p15d_per_4 p15d_uru p15d_uru_1 p15d_uru_2 p15e_per p15e_per_1 p15e_per_2 p16_col p16_col_10 p16_per p16_per_10 p16_uru p16_uru_10 p17 p18 p18_codes p19 p20 p21 p21_codes p22 p22_codes p23 p23_codes p24_col p24_col_4 p24_per p24_per_4 p24_uru p24_uru_4 p25 p26 p27a p27b p27c_col p27c_per p27c_uru p27d p27e p27f p27g p27h p28a p28b p29 p30_col p30_col_10 p30_per p30_per_10 p30_p0 p30_uru p30_uru_10 p31a p31b p31_c p32_col p32_col_3 p32_per p32_per_5 p32_uru p32_uru_4 p33a_col p33a_col_4 p33a_col_5 p33a_per p33a_per_4 p33a_per_5 p33a_uru p33a_uru_4 p33a_uru_5 p33b_col p33b_col_4 p33b_col_5 p33b_per p33b_per_5 p33b_per_6 p33b_uru p33b_uru_4 p33b_uru_5 p33c_col p33c_col_1 p33c_col_2 p33c_per p33c_per_4 p33c_per_5 p33c_uru p33c_uru_4 p33c_uru_5 p33d_per p33d_per_3 p33d_per_4 p33d_uru p33d_uru_1 p33d_uru_2 p33e_per p33e_per_1 p33e_per_2 p34_col p34_col_4 p34_per p34_per_4 p34_uru p34_uru_4 p35_col p35_per p35_uru p36_col p36_uru p36_per p37 p37_7 p38a p38b p38c p38d p38e p38f p38g p38h p38i p38j p38_k_col p38_k_per p38_k_uru p39 p40a_col p40a_per p40a_uru p40b_col p40b_per p40b_uru p40c_col p40c_per p40c_uru p40d_col p40d_per p40d_uru p41a p41b p41c p42_col p42_per p42_uru p43_col p43_per p43_uru p44_col p44_per p44_uru p45 p46 p47 p48 p49 p50_col p50_per p51_col p51_per p51_uru cell1 cell2 cell2_codes dia1 mes1 anio1 fecha1 tipo_base nombre_encuestador enc total wtvar hhini hhfin duracion p1n p18n p21n p22n p23n cell2n zona region_per pond_edad originalrespondentserial originalfile region_col region_uru minutos segundos duracion_humana peso p4_all p5_all respondio_p6col todas_na_p6col p6_col_all respondio_p6per todas_na_p6per p6_per_all respondio_p6uru todas_na_p6uru p6_uru_all p6_1 p7_all p7_total p8_all p13a_all p14_all p15_col p15_per p15_uru p15_all p16_all p19_all p24_all p27c_all p30_all p31c p32_all p33_col p33_per p33_uru p33_all p34_all p35_all p36_all p38k p40a p40b p40c p40d p42_all p43_all p44_all p50_all p51_all p2_2 p2_3 p4_col_2 p4_per_2 p4_uru_2 p4_2 p5_2 p7_total2 p8_2 p9_2 p10_2 _v1 _v2 p12_all p13_g p13_g2 p13_2 p15_2 p19_all2 p22_2 p23_2 p_user p_consult_all p27a_2 p27a_3 p27b_2 p27c_2 p27d_2 p27f_2 p27g_2 p27h_2 p27h_3 p31_2 p31_3 _v3 p33_2 p36_2 p37_2 p38a_2 p38b_2 p38c_2 p38d_2 p38e_2 p38f_2 p38g_2 p38h_2 p38i_2 p38j_2 p38k_2 p39_2 p41_2 p_expect p50_2 p50_3 p51_2 p2_pesos p4_col_pesos p4_per_pesos p4_uru_pesos p4_pesos p8_pesos categorias_pesos newpeso
