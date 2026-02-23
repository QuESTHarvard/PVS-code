* People's Voice Survey data cleaning for Colombia, Peru, Uruguay  
* Date of last update: April 2023
* Last updated by: S Sabwa

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


*------------------------------------------------------------------------------*

* Other specify recode 
* This command recodes all "other specify" variables as listed in /specifyrecode_inputs spreadsheet
* This command requires an input file that lists all the variables to be recoded and their new values
* The command in data quality checks below extracts other, specify values 

gen p13_a_col_4_original = p13_a_col_4
gen p14_col_3_original = p14_col_3	
gen p15a_col_3_original = p15a_col_3
gen p15b_col_3_original = p15b_col_3
gen p15c_col_1_original = p15c_col_1
gen p15c_col_2_original = p15c_col_2
gen p16_col_10_original = p16_col_10
gen p24_col_4_original = p24_col_4
gen p30_col_10_original = p30_col_10
gen p32_col_3_original = p32_col_3
gen p33a_col_4_original = p33a_col_4
gen p33a_col_5_original = p33a_col_5
gen p33b_col_4_original = p33b_col_4
gen p33b_col_5_original = p33b_col_5
gen p33c_col_1_original = p33c_col_1
gen p34_col_4_original = p34_col_4
gen p37_7_original = p37_7

gen p13_a_per_4_original = p13_a_per_4
gen p14_per_5_original = p14_per_5
gen p15a_per_4_original = p15a_per_4
gen p15b_per_5_original = p15b_per_5
gen p15b_per_6_original = p15b_per_6
gen p15c_per_4_original = p15c_per_4
gen p15c_per_5_original = p15c_per_5
gen p15d_per_4_original = p15d_per_4
gen p15e_per_1_original = p15e_per_1
gen p15e_per_2_original = p15e_per_2
gen p16_per_10_original = p16_per_10
gen p24_per_4_original = p24_per_4
gen p30_per_10_original = p30_per_10
gen p30_p0_original = p30_p0
gen p32_per_5_original = p32_per_5
gen p33a_per_4_original = p33a_per_4
gen p33b_per_5_original = p33b_per_5
gen p33c_per_4_original = p33c_per_4
gen p33d_per_3_original = p33d_per_3
gen p33d_per_4_original = p33d_per_4
gen p33e_per_1_original = p33e_per_1
gen p33e_per_2_original = p33e_per_2
gen p34_per_4_original = p34_per_4

gen p13_a_uru_4_original = p13_a_uru_4
gen p14_uru_4_original = p14_uru_4
gen p15a_uru_3_original = p15a_uru_3
gen p15b_uru_3_original = p15b_uru_3
gen p15b_uru_4_original = p15b_uru_4
gen p15c_uru_3_original = p15c_uru_3
gen p15c_uru_4_original = p15c_uru_4
gen p15d_uru_1_original = p15d_uru_1
gen p15d_uru_2_original = p15d_uru_2
gen p16_uru_10_original = p16_uru_10
gen p24_uru_4_original = p24_uru_4
gen p30_uru_10_original = p30_uru_10
gen p32_uru_4_original = p32_uru_4
gen p33a_uru_4_original = p33a_uru_4
gen p33b_uru_4_original = p33b_uru_4
gen p33c_uru_4_original = p33c_uru_4
gen p33d_uru_2_original = p33d_uru_2
gen p34_uru_4_original = p34_uru_4



foreach i in 2 7 10 {

ipacheckspecifyrecode using "$in_out/Input/specifyrecode_inputs/specifyrecode_inputs_`i'.xlsx",	///
	sheet(other_specify_recode)	 ///	
	id(respondent_id)	
 
}	


drop p13_a_col_4 p14_col_3 p15a_col_3 p15b_col_3 p15c_col_1 p15c_col_2 p16_col_10 ///
	 p24_col_4 p30_col_10 p32_col_3 p33a_col_4 p33a_col_5 p33b_col_4 p33b_col_5 ///
	 p33c_col_1 p34_col_4 p37_7 p33e_per_1 p34_per_4 p33e_per_2 p33d_per_4 p33d_per_3 ///
	 p33c_per_4 p33a_per_4 p33b_per_5 p32_per_5 p30_p0 p30_per_10 p24_per_4 p16_per_10 ///
	 p15e_per_2 p15e_per_1 p15d_per_4 p15c_per_5 p15c_per_4 p15b_per_6 p15b_per_5 p15a_per_4 ///
	 p14_per_5 p13_a_per_4 p13_a_uru_4 p14_uru_4 p15a_uru_3 p15b_uru_3 p15b_uru_4 p15c_uru_3 ///
	 p15c_uru_4 p15d_uru_1 p15d_uru_2 p16_uru_10 p24_uru_4 p30_uru_10 p32_uru_4 p33a_uru_4 ///
	 p33b_uru_4 p33c_uru_4 p33d_uru_2 p34_uru_4
	 
rename p13_a_col_4_original p13_a_col_4
rename p14_col_3_original p14_col_3	
rename p15a_col_3_original p15a_col_3
rename p15b_col_3_original p15b_col_3
rename p15c_col_1_original p15c_col_1
rename p15c_col_2_original p15c_col_2
rename p16_col_10_original p16_col_10
rename p24_col_4_original p24_col_4
rename p30_col_10_original p30_col_10
rename p32_col_3_original p32_col_3
rename p33a_col_4_original p33a_col_4
rename p33a_col_5_original p33a_col_5
rename p33b_col_4_original p33b_col_4
rename p33b_col_5_original p33b_col_5
rename p33c_col_1_original p33c_col_1
rename p34_col_4_original p34_col_4
rename p37_7_original p37_7

rename p13_a_per_4_original p13_a_per_4
rename p14_per_5_original p14_per_5
rename p15a_per_4_original p15a_per_4
rename p15b_per_5_original p15b_per_5
rename p15b_per_6_original p15b_per_6
rename p15c_per_4_original p15c_per_4
rename p15c_per_5_original p15c_per_5
rename p15d_per_4_original p15d_per_4
rename p15e_per_1_original p15e_per_1
rename p15e_per_2_original p15e_per_2
rename p16_per_10_original p16_per_10
rename p24_per_4_original p24_per_4
rename p30_per_10_original p30_per_10
rename p30_p0_original p30_p0
rename p32_per_5_original p32_per_5
rename p33a_per_4_original p33a_per_4
rename p33b_per_5_original p33b_per_5
rename p33c_per_4_original p33c_per_4
rename p33d_per_3_original p33d_per_3
rename p33d_per_4_original p33d_per_4
rename p33e_per_1_original p33e_per_1
rename p33e_per_2_original p33e_per_2
rename p34_per_4_original p34_per_4

rename p13_a_uru_4_original p13_a_uru_4
rename p14_uru_4_original p14_uru_4
rename p15a_uru_3_original p15a_uru_3
rename p15b_uru_3_original p15b_uru_3
rename p15b_uru_4_original p15b_uru_4
rename p15c_uru_3_original p15c_uru_3
rename p15c_uru_4_original p15c_uru_4
rename p15d_uru_1_original p15d_uru_1
rename p15d_uru_2_original p15d_uru_2
rename p16_uru_10_original p16_uru_10
rename p24_uru_4_original p24_uru_4
rename p30_uru_10_original p30_uru_10
rename p32_uru_4_original p32_uru_4
rename p33a_uru_4_original p33a_uru_4
rename p33b_uru_4_original p33b_uru_4
rename p33c_uru_4_original p33c_uru_4
rename p33d_uru_2_original p33d_uru_2
rename p34_uru_4_original p34_uru_4

*------------------------------------------------------------------------------*/

*dropping interviewer vars:
drop respondent_serial_sourcefile intro intro_repregunta pa pa_repregunta red_quest control_calidad ///	
	 p1_codes 

*dropping country specific vars:
drop p4_col p4_per p4_uru p5_col p5_per p5_uru p6_latam_col1 p6_latam_col2 p6_latam_col3 p6_latam_col4 p6_latam_col5 p6_latam_col6 p6_latam_col7 p6_latam_col8 p6_latam_col9 p6_latam_col_9 p6_latam_per1 p6_latam_per2 p6_latam_per3 p6_latam_per4 p6_latam_per5 p6_latam_per6 p6_latam_per_6 p6_latam_uru1 p6_latam_uru2 p6_latam_uru3 p6_latam_uru4 p6_latam_uru5 p6_latam_uru6 p6_latam_uru_6 p7_latam_col p7_latam_col_9 p7_latam_per p7_latam_per_6 respondio_p6col todas_na_p6col p6_col_all respondio_p6per todas_na_p6per p6_per_all respondio_p6uru todas_na_p6uru p6_uru_all p7_latam_uru p8_col p8_per p8_uru p13_a_col p13_a_col_4 p13_a_per p13_a_per_4 p13_a_uru_4 p13_a_uru p14_col_3 p14_per_5  p14_uru_4 p15a_col p15a_col_3 p15a_col_4 p15a_per p15a_per_4 p15a_per_5 p15a_uru p15a_uru_3 p15a_uru_4 p15b_col p15b_col_3 p15b_col_4 p15b_per p15b_per_5 p15b_per_6 p15b_uru p15b_uru_3 p15b_uru_4 p15b_uru_5 p15c_col p15c_col_1 p15c_col_2 p15c_per p15c_per_4 p15c_per_5 p15c_uru p15c_uru_3 p15c_uru_4 p15c_uru_5 p15d_per p15d_per_3 p15d_per_4 p15d_uru p15d_uru_1 p15d_uru_2 p15e_per p15e_per_1 p15e_per_2 p15_col p15_per p15_uru p16_col p16_col_10 p16_per p16_per_10 p16_uru p16_uru_10 p19 p24_col p24_col_4 p24_per p24_per_4 p24_uru p24_uru_4 p27c_col p27c_per p27c_uru p30_col p30_col_10 p30_per p30_per_10 p30_p0 p30_uru p30_uru_10 p31_c p32_col_3 p32_per_5 p32_uru_4 p33a_col p33a_col_4 p33a_col_5 p33a_per p33a_per_4 p33a_per_5 p33a_uru p33a_uru_4 p33a_uru_5 p33b_col p33b_col_4 p33b_col_5 p33b_per p33b_per_5 p33b_per_6 p33b_uru p33b_uru_4 p33b_uru_5 p33c_col p33c_col_1 p33c_col_2 p33c_per p33c_per_4 p33c_per_5 p33c_uru p33c_uru_4 p33c_uru_5 p33d_per p33d_per_3 p33d_per_4 p33d_uru p33d_uru_1 p33d_uru_2 p33e_per p33e_per_1 p33e_per_2 p34_col p34_col_4 p34_per p34_per_4 p34_uru p34_uru_4 p35_col p35_per p35_uru p36_col p36_uru p36_per p37_7 p38_k_col p38_k_per p38_k_uru p40a_col p40a_per p40a_uru p40b_col p40b_per p40b_uru p40c_col p40c_per p40c_uru p40d_col p40d_per p40d_uru p42_col p42_per p42_uru p43_col p43_per p43_uru p50_col p50_per p51_col p51_per p51_uru cell2_codes

drop p2_2 p2_3 p4_col_2 p4_per_2 p4_uru_2 p4_2 p5_2 p7_total p7_total2 p8_2 p9_2 p10_2 _v1 _v2 p13_g p13_g2 p13_2 p15_2 p22_2 p23_2 p27a_2 p27a_3 p27b_2 p27c_2 p27d_2 p27f_2 p27g_2 p27h_2 p27h_3 p31_2 p31_3 _v3 p33_2 p36_2 p37_2 p38a_2 p38b_2 p38c_2 p38d_2 p38e_2 p38f_2 p38g_2 p38h_2 p38i_2 p38j_2 p38k_2 p39_2 p41_2 p_user p_consult_all p_expect p51_2 p2_pesos p4_col_pesos p4_per_pesos p4_uru_pesos p4_pesos p8_pesos categorias_pesos newpeso

*confirm dropping these:
drop p12_all p19_all2 dia1 mes1 anio1 tipo_base nombre_encuestador enc total wtvar hhini hhfin p1n p18n p21n p22n p23n cell2n zona region_per pond_edad originalrespondentserial originalfile region_col region_uru minutos segundos duracion_humana p50_2 p50_3 
 
*------------------------------------------------------------------------------*
* Rename some variables, and some recoding if variable will be dropped 

recode pais (1 = 2 "Colombia") (2 = 7 "Peru") (3 = 10 "Uruguay"), gen(country) 
drop pais

rename fecha1 date
rename peso weight // confirm translation

rename (p1 p2) (q1 q2)

rename p3_a q3 // similar to how we coded q3 (sex) for wave 1 because of the cervical and mammogram derived vars
rename p3 q3a_co_pe_uy_ar // gender

rename p4_all q4

recode p5_all (1 = 1 "City") (2 = 2 "Town") (3 = 3 "Rural area") (4 = 4 "No response"),gen(q5)
drop p5_all 

recode p6_1 (1 = 1 "None") (2 = 2 "None")(3 = 3 "Subsidized")(4 = 4 "SIS (Integral Health System – Peru)") ///
            (5 = 5 "ASSE (State Health Services Administration – Uruguay)") (6 = 6 "Contributory") (7 = 7 "Contributory with complementary plan") ///
			(8 = 8 "EsSalud (Social Health Insurance – Peru)") (9 = 9 "Mutual Insurance Providers") (10 = 10  "Prepaid Medical Plan") (11 = 11 "More than one prepaid medical plan") ///
			(12 = 12 "Health Insurance Policy") (13 = 13 "More than one health insurance policy") (14 = 14 "Private") (15 = 15 "More than one private insurance") ///
			(16 = 16 "Private") (17 = 17 "More than one private insurance") (18 = 18 "Special Regimes") (19 = 19 "Armed Forces and Police Coverage") ///
			(20 = 20 "Other") (21 = 21 "Other") (22 = 22 "No response"),gen(q6_lac) // add to data dictionary
drop p6_1
			
* confirm translations
recode p7_all (1 = 1 "There isn't one that you use most frequently") (2 = 2 "There isn't one that you use most frequently") ///
			  (3 = 3 "Subsidized") (4 = 4 "SIS") (5 = 5 "ASSE") (6 = 6 "Contributory") (7 = 7 "Contributory with a complementary plan") ///
			  (8 = 8 "EsSalud") (9 = 9 "Mutualists") (10 = 10 "Prepaid medicine") (11 = 11 "More than one prepaid medicine") ///
			  (12 = 12 "Health insurance policy") (13 = 13 "More than one health insurance policy") (14 = 14 "Private") ///
			  (15 = 15 "More than one private insurance policy") (16 =16 "Private") (17 = 17 "More than one private coverage") ///
			  (18 = 18 "Special Regimes") (19 = 19 "Armed Forces and Police") (20 = 20 "Other") (21 = 21 "Other") (22 = .r "No response"),gen(q7)
drop p7_all

recode p8_all (1 = 1 "None") (2 = 2 "Preschool/Kindergarten") (3 = 3 "Elementary") (4 = 4 "Secondary") (5 = 5 "Non-university higher education") ///
			  (6 = 6 "University higher education") (7 = 7 "Postgraduate"),gen(q8)
drop p8_all


rename p9 q9
rename p10 q10
rename p11 q11
rename p12a q12_a
rename p12b q12_b
rename p13 q13

recode p13a_all (1 = 0 "No") (2 = 1 "Yes, pharmacy") (3 = 2 "Yes, healer/traditional medicine") ///
				(4 = 3 "Yes, alternative medicine") (5 = 4 "Yes, other") (6 = .r "No response"),gen(q13a_lac) label(q13a_lac_label) // add to data dictionary
drop p13a_all

recode p14_all (1 = 1 "Public") (2 = 2 "MINSA") (3 = 3 "EsSalud") (4 = 4 "Mutualist") (5 = 5 "Private") ///
			   (6 = 6 "Armed Forces or Police") (7 = 7 "Other") (8 = .r "No response"),gen(q14_lac) label(q14_lac_label)
drop p14_all

rename p14_col q14_co
rename p14_per q14_pe
rename p14_uru q14_uy
			   
* confirm translations			   
recode p15_all (1 = 101 "Health Center/Primary Care Center") (2 = 102 "Post/Health Center") (3 = 103 "Post/Health Center/UBAP") ///
			   (4 = 104 "Health Center") (5 = 105 "Private Practice") (6 = 106 "Polyclinic") (7 = 107 "Polyclinic") ///
			   (8 = 108 "Other Primary Care Facility") (9 = 109 "Hospital") (10 = 110 "Clinic") (11 = 111 "Clinic/Hospital") ///
			   (12 = 112 "Hospital/Sanitorium") (13 = 113 "Clinic/Sanitorium") (14 = 114 "National Institute") ///
			   (15 = 115 "Other Secondary Care Facility or more") (16 = .r "No response"),gen(q15)
drop p15_all
			   
rename p16_all q16
rename p17 q17

rename p18 q18
replace q18 = .d if p18_codes =="998. (NO LEER) No sabe"
replace q18 = .r if p18_codes == "999. (NO LEER)No responde"
drop p18_codes

recode p19_all (1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
		   (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"),gen(q19) label(q19_label)
drop p19_all
		   
rename p20 q20

rename p21 q21
replace q21 = .d if p21_codes == "998. (NO LEER) No sabe"
replace q21 = .r if p21_codes == "999. (NO LEER)No responde"
drop p21_codes

rename p22 q22
replace q22 = .d if p22_codes == "998. (NO LEER) No sabe"
replace q22 = .r if p22_codes == "999. (NO LEER)No responde"
drop p22_codes

rename p23 q23
replace q23 = .d if p23_codes == "998. (NO LEER) No sabe"
replace q23 = .r if p23_codes == "999. (NO LEER)No responde"
drop p23_codes

rename p24_all q24
rename p25 q25
rename p26 q26
rename p27a q27_a
rename p27b q27_b
rename p27c_all q27_c
rename p27d q27_d
rename p27e q27_e
rename p27f q27_f
rename p27g q27_g
rename p27h q27_h
rename p28a q28_a
rename p28b q28_b
rename p29 q29
rename p30_all q30
rename p31a q31a
rename p31b q31b
rename p31c q31_lac // new LAC var, add to data dictionary

recode p32_all (1 = 1 "Public") (2 = 2 "MINSA") (3 = 3 "EsSalud") (4 = 4 "Mutualist") (5 = 5 "Private") ///
			   (6 = 6 "Armed Forces or Police") (7 = 7 "Other") (8 = .r "No reponse"), gen(q32_co_pe_uy)
drop p32_all		   

* confirm translations
recode p33_all (1 = 101 "Health Center/Primary Care Center") (2 = 102 "Post/Health Center") (3 = 103 "Post/Health Center/UBAP") ///
			   (4 = 104 "Health Center") (5 = 105 "Private Practice") (6 = 106 "Polyclinic") (7 = 107 "Polyclinic") ///
			   (8 = 108 "Other Primary Care Facility") (9 = 109 "Hospital") (10 = 110 "Clinic") (11 = 111 "Clinic/Hospital") ///
			   (12 = 112 "Hospital/Sanitorium") (13 = 113 "Clinic/Sanitorium") (14 = 114 "National Institute") ///
			   (15 = 115 "Other Secondary Care Facility or More") (16 = .r "No response"), gen(q33) 
drop p33_all

rename p34_all q34
rename p35_all q35
rename p36_all q36
rename p37 q37
rename p38a q38_a
rename p38b q38_b
rename p38c q38_c
rename p38d q38_d
rename p38e q38_e
rename p38f q38_f
rename p38g q38_g
rename p38h q38_h
rename p38i q38_i
rename p38j q38_j
rename p38k q38_k
rename p39 q39
rename p40a q40_a
rename p40b q40_b
rename p40c q40_c
rename p40d q40_d
rename p41a q41_a
rename p41b q41_b
rename p41c q41_c
rename p42_all q42
rename p43_all q43
rename p44_all q44

rename p44_col q44_co
rename p44_per q44_pe
rename p44_uru q44_uy

rename p45 q45
rename p46 q46
rename p47 q47
rename p48 q48
rename p49 q49

*confirm translations
recode p50_all (1 = 1 "Spanish") (2 = 2 "Lenguas caribes") (3 = 3 "Lenguas chocó") (4 = 4 "Lenguas tucanas") ///
			   (5 = 5 "Quechua") (6 = 6 "Aimara") (7 = 7 "Awajún/Aguaruna") (8 = 8 "Shipibo/Konibo") ///
			   (9 = 9 "Shawi/Chayahuita") (10 = 10 "Other native language") (11 = 11 "Portuguese") ///
			   (12 = 12 "English") (13 = 13 "Another foreign language") (14 = 14 "Other") (15 = .r "No response") (. = .a "NA"), gen(q50)
drop p50_all			   

recode p51_all (1 = 1 "Less than 500,000 pesos") (2 = 2 "Between 500,000 and 1 million pesos") ///
			   (3 = 3 "Between 1 million and 3 million pesos") (4 = 4 "Between 3 million and 5 million pesos") ///
			   (5 = 5 "More than 5 million pesos") (6 = 6 "Less than 1,200 soles") (7 = 7 "Between 1,200 and 2,000 soles") ///
			   (8 = 8 "Between 2,000 and 3,000 soles") (9 = 9 "Between 3,000 and 5,000 soles") (10 = 10 "More than 5,000 soles") ///
			   (11 = 11 "Less than 18,000 pesos") (12 = 12 "Between 18,000 and 30,000 pesos") (13 = 13 "Between 30,000 and 40,000 pesos") ///
			   (14 = 14 "Between 40,000 and 70,000 pesos") (15 = 15 "More than 70,000 pesos") (16 = .r "No response"),gen(q51)
drop p51_all

rename duracion int_length
			  
* gen rec variable for variables that have overlap values to be country code * 1000 + variable 

*gen reclanguage = country*1000 + language  
*gen recinterviewer_id = country*1000 + interviewer_id *interviewer_id in a string fmt

gen language = country*1000 + q50 
recode language (. = .a)
label define Language ///
    2001 "CO: Spanish" ///
    2002 "CO: Lenguas caribes" ///
    2003 "CO: Lenguas chocó" ///
    2004 "CO: Lenguas tucanas" ///
    2011 "CO: Portuguese" ///
    2012 "CO: English" ///
    2014 "CO: Other" ///
    7001 "PE: Spanish" ///
    7005 "PE: Quechua" ///
    7006 "PE: Aimara" ///
    7007 "PE: Awajún/Aguaruna" ///
    7008 "PE: Shipibo/Konibo" ///
    7009 "PE: Shawi/Chayahuita" ///
    7010 "PE: Other native language" ///
	7013 "PE: Another foreign language" ///
    .r   "Refused" ///
	.a   "NA"

label values language Language


gen recq4 = country*1000 + q4
*replace recq4 = .r if q4 == 999

gen recq5 = country*1000 + q5  
replace recq5 = .r if q5 == 4

gen recq7 = country*1000 + q7
replace recq7 = .r if q7== 22

gen recq8 = country*1000 + q8
*replace recq8 = .r if q8== 999

gen recq15 = country*1000 + q15
replace recq15 = .r if q15== 16
*replace recq15 = .d if q15== 998

gen recq33 = country*1000 + q33
replace recq33 = .r if q33== 16 
*replace recq33 = .d if q33== 998

gen recq50 = country*1000 + q50 
replace recq50 = .r if q50== 15

gen recq51 = country*1000 + q51
replace recq51 = .r if q51== 16
*replace recq51 = .d if q51== 998

* Relabel some variables now so we can use the orignal label values
label define country_short 1 "EC" 2 "CO" 3 "ET" 4 "IN" 5 "KE" 7 "PE" 9 "ZA" 10 "UY" ///
						   11 "LA" 12 "US" 13 "MX" 14 "IT" 15 "KR" 16 "AR" ///
						   17 "GB" 18 "GT" 19 "RO" 20 "NG" 21 "CN" 22 "SO" ///
						   23 "NP"
qui elabel list country_short
local countryn = r(k)
local countryval = r(values)
local countrylab = r(labels)

local q4l labels142
local q5l q5
local q7l q7
local q8l q8
local q15l q15
local q33l q33
local q50l q50
local q51l q51


foreach q in q4 q5 q7 q8 q15 q33 q50 q51{
	qui elabel list ``q'l'
	local `q'n = r(k)
	local `q'val = r(values)
	local `q'lab = r(labels)
	local g 0
	foreach i in ``q'lab'{
		local ++g
		local gr`g' `i'
	}

	qui levelsof rec`q', local(`q'level)

	forvalues o = 1/`countryn' {
		forvalues i = 1/``q'n' {
			local recvalue`q' = `: word `o' of `countryval''*1000+`: word `i' of ``q'val''
			foreach lev in ``q'level'{
				if strmatch("`lev'", "`recvalue`q''") == 1{
					elabel define `q'_label (= `: word `o' of `countryval''*1000+`: word `i' of ``q'val'') ///
									        (`"`: word `o' of `countrylab'': `gr`i''"'), modify			
				}	
			}         
		}
	}
	
	label val rec`q' `q'_label
}

*****************************

drop q4 q5 q7 q8 q15 q33 q50 q51 
ren rec* *

*------------------------------------------------------------------------------*
* Fix interview length variable and other time variables 

*reformating date
g date2= date(substr(date, 1, 10), "DMY")
format date2 %td
drop date
rename date2 date

*------------------------------------------------------------------------------*
* Generate variables 

encode respondent_serial,gen(recrespondent_serial)
drop respondent_serial

gen mode = 1
lab def mode 1 "CATI",modify
lab val mode mode

replace q2 = 1 if q1 >=18 & q1<=39
replace q2 = 2 if q1 >=30 & q1<=39
replace q2 = 3 if q1 >=40 & q1<=49
replace q2 = 4 if q1 >=50 & q1<=59
replace q2 = 5 if q1 >=60 & q1<=69
replace q2 = 6 if q1 >=70 & q1<=79
replace q2 = 7 if q1 >=80 

gen q6 = .a

* q18/q19 mid-point var 
gen q18_q19 = q18 
recode q18_q19 (998 999 = 0) if q19 == 1
recode q18_q19 (998 999 = 2.5) if q19 == 2
recode q18_q19 (998 999 = 7) if q19 == 3
recode q18_q19 (998 999 = 10) if q19 == 4

*------------------------------------------------------------------------------*
* Recode all Refused and Don't know responses

* Don't know
recode q27_a q27_b q27_d q27_e q27_f q27_g q27_h q28_a q28_b q29 (4 = .d)

* Refused
recode q9 q10 q25 (6 = .r)
recode q11 q13 q20 q27_a q27_c q27_d q27_e q27_f q28_a q28_b q29 q35 (3 = .r)
recode q14_lac q32_co_pe_uy (8 = .r)
recode q16 q30 (11 = .r)	  
recode q17 (7 = .r)
recode q24 q34 (5 = .r)
recode q36 (9 = .r)

* "No reponse = Refused?" 
recode q3a_co_pe_uy_ar q45 q46 (4 = .r)
recode q12_a q12_b q42 q43 q44 q47 q48 q49 (6 = .r)
recode q26 q31a q31_lac (3 = .r)
recode q40_a q40_b q40_c q40_d (7 = .r)
recode q41_a q41_b  (5 = .r)
recode q6_lac (22 = .r)

*------------------------------------------------------------------------------*
* Check for implausible values

* Q17. Overall respondent's rating of the quality received in this facility
* Q18/Q19. Total number of visits made in past 12 months (q23, q24 mid-point)
* Q20. Were all of the visits you made to the same healthcare facility? 
* Q21. How many different healthcare facilities did you go to? 
* Q22. How many visits did you have with a healthcare provider at your home?
* Q23. How many virtual or telemedicine visits did you have?

* Q20, Q21
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
* None
*replace q21 = q18_q19 if q21 > q18_q19 & q21 < . 

list q20 q21 if q21 == 0 | q21 == 1
* None

* List if yes to q20: "all visits in the same facility" but q21: "how many different healthcare facilities did you go to" is more than 0
list q20 q21 if q20 ==1 & q21 > 0 & q21 < . 
* None

* Q28a, Q28b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q18_q19 q22 q23) 

list visits_total q17 if q17 == 6 & visits_total > 0 & visits_total < . | q17 == 6 & visits_total > 0 & visits_total < .

recode q17 (6 = .r) if visits_total > 0 & visits_total < . 
*N=15 with issues

drop visits_total

*------------------------------------------------------------------------------*
 * Recode missing values to NA for intentionally skipped questions

*q1/q2 - no missing data

*q14-17
recode q14_lac q15 q16 q17 (. = .a) if q13 !=1

* NA's for q19-21 
recode q19 (. = .a) if q18 != .d | q18 !=.r

recode q20 (. = .a) if q18 <1 | q18 == .d | q18 == .r | q19 != 2 | q19 != 3 | q19 != 4

recode q21 (. = .a) if q20 !=0 

*q24-q25 
recode q24 q25 (. = .a) if q23 == 0  | q23 == .d | q23 == .r

* q27_b q27_c
recode q27_b q27_c (. = .a) if q3 !=1


*q28
recode q28_a q28_b (. = .a) if q18 == 0 | q18 == .d | q18 == .r | q19 == 1 | q19 == .d | ///
							   q19 == .r | q22 == 0 | q22 == .d | q22 == .r | ///
							   q23 == 0 | q23 == .d | q23 == .r

* q30
recode q30 (. = .a) if q29 !=1

* q32-33
recode q32_co_pe_uy q33 q34 q35 q36 q37 q38_a q38_b q38_c q38_d q38_e q38_f /// 
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q18 == .d | q18 == .r | ///
													 q19 == 1 | q19 == .d | q19 == .r

recode q36 q38_k (. = .a) if q35 !=1		

recode q50 (. = .a) if country == 10

encode cell1, gen(reccell1)
drop cell1
recode reccell1 (1 = 0 "No") (2 = 1 "Yes") (3 = .d "Don't know") (4 = .r "Refused"), gen(cell1)
drop reccell1
recode cell1 (. = .a) if mode !=1

encode cell2, gen(reccell2)
drop cell2
ren reccell2 cell2
recode cell2 (. = .a) if cell1 !=1
									 
*------------------------------------------------------------------------------*
* Recode values and value labels so that their values and direction make sense:

* q2 - just fixing labels (not creating new var)
label define labels1 1 "18 to 29" 2	"30-39" 3 "40-49" 4	"50-59" 5 "60-69" ///
					 6 "70-79" 7 "80 or older" .a "NA" .r "Refused", modify 

recode q3a_co_pe_uy_ar ///
	(1 = 0 "Male") (2 = 1 "Female") (3 = 2 "Another gender") (.r = .r "Refused"), ///
	pre(rec) label(gender)
drop q3a_co_pe_uy_ar
	
recode q3 ///
	(1 = 0 "Man") (2 = 1 "Woman") (.r = .r "Refused") (.a = .a "NA"), ///
	pre(rec) label(gender2)
drop q3				 
				 
********* All Yes/No questions *********
recode q11 q13 q20 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a /// 
		q28_b q29 q31a q31b q31_lac  q35 ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (.a = .a "NA") ///
	   (.d = .d "Don't know"),  ///
	   pre(rec) label(yes_no)					 
drop q11 q13 q20 q26 q27_a q27_b q27_c q27_d q27_e q27_f q27_g q27_h q28_a /// 
		q28_b q29 q31a q31b q31_lac q35
	   
********* All Excellent to Poor scales *********
recode q9 q10 q25 q42 q43 q44 q47 q48 q49  ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") (.r = .r "Refused") (.a = .a "NA") (.d = .d "Don't know"), /// 
	   pre(rec) label(exc_poor)
drop q9 q10 q25 q42 q43 q44 q47 q48 q49 
	   
recode q17  ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") (5 = 0 "Poor") /// 
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r Refused), /// 
	   pre(rec) label(exc_pr_hlthcare)	   
drop q17	   
	   
recode q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") ///
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") ///
	   (7 = .a "NA or The clinic had no other staff") (8 = .r "Refused"), /// 
	   pre(rec) label(exc_poor_staff)	
drop q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j

recode q38_a  ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") ///
	   (6 = .a "NA or I did not receive healthcare form this provider in the past 12 months") ///
	   (7 = .r "Refused"), /// 
	   pre(rec) label(exc_poor_staff_2)	
drop q38_a 
	   
recode q38_k ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") (6 = .r "Refused") (.a = .a "NA"), pre(rec) label(exc_poor_staff_3)	
drop q38_k
	   
	   
recode q40_a q40_b q40_c q40_d q44_co q44_pe q44_uy  ///
	   (1 = 4 "Excellent") (2 = 3 "Very Good") (3 = 2 "Good") (4 = 1 "Fair") /// 
	   (5 = 0 "Poor") (6 = .r "Refused") ///
	   (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor_judge)	   
drop q40_a q40_b q40_c q40_d q44_co q44_pe q44_uy
	   
********* All Very Confident to Not at all Confident scales *********
recode q12_a q12_b q41_c  ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (5 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)		
drop q12_a q12_b q41_c
	   
recode q41_a q41_b ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)		   
drop q41_a q41_b
 		
********* Miscellaneous questions with unique answer options *********

recode q14_uy (1 = 1 "Public") (2 = 5 "Mutual") (3 = 2 "Private") (5 = 995 "Other"), pre(rec)
drop q14_uy

* SS: confirm translations	
recode q16 (1 = 1 "Low cost") (2 = 2 "Short distance") (3 = 3 "Short waiting time") ///
			(4 = 4 "Good healthcare provider skills") (5 = 5 "Staff shows respect") ///
			(6 = 6 "Medicines and equipment are available") (7 = 7 "Only facility available") ///
			(8 = 8 "Covered by insurance") (9 = 10 "Short waiting time to get appointments") ///
			(10 = 9 "Other, specify") (.a = .a "NA") (.d = .d "Don't know") (11 = .r "Refused"), ///
			pre(rec) label(q16_label)
drop q16
			
*translating q24
label define labels156 1 "Care for an urgent or acute health problem (accident or injury, fever, diarrhea, or a new pain or symptom)" 2	"Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes; mental health conditions" 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)" 4 "Other", modify 
			
* recode 9 and 10 for q30 -confirm translation

recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance)") ///
		   (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff don't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") ///
		   (8 = 19 "LAC: Problems with coverage") ///
		   (9 = 20 "LAC: Difficulty getting an appointment") (10 = 10 "Other") (.a = .a "NA") ///
		   (.d = .d "Don't know") (.r = .r "Refused") ,pre(rec) label(q30_label)
		
drop q30

*q34 - just fixing labels (not creating new var)
label define labels165 1 "Care for an urgent or new health problem (an accident or a new symptom like fever, pain, diarrhea, or depression)" 2	"Follow-up care for a longstanding illness or chronic disease (hypertension or diabetes, mental health conditions)" 3 "Preventive care or a visit to check on your health (for example, antenatal care, vaccination, or eye checks)" 4	"Other,specify" .a "NA" .d "Don't know" .r "Refused", modify 

* q36- just fixing labels (not creating new var)
label define labels167 1 "Same or next day" 2 "2 days to less than one week" 3 "1 week to less than 2 weeks" ///
					   4 "2 weeks to less than 1 month" 5 "1 month to less than 2 months" ///
					   6 "2 months to less than 3 months" 7 "3 months to less than 6 months" ///
					   8 "6 months or more" .a "NA" .d "Don't know" .r "Refused",modify

* q37- just fixing labels (not creating new var)				   
label define labels93 1 "Less than 15 minutes" 2 "15 minutes to less than 30 minutes" ///
					  3 "30 minutes to less than 1 hour" 4 "1 hour to less than 2 hours" ///
					  5 "2 hours to less than 3 hours" 6 "3 hours to less than 4 hours" ///
					  7 "More than 4 hours (specify)" .a "NA" .d "Don't know" .r "Refused", modify				   
recode q45 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") (.a = .a "NA") (.d = .d "Don't know") (.r = .r "Refused"), ///
	pre(rec) label(system_outlook)					  
drop q45

* q46- just fixing labels (not creating new var)
label define labels133 1 "Our healthcare system has so much wrong with it that we need to completely rebuild it." 2 "There are some good things in our healthcare system, but major changes are needed to make it work better." 3 "On the whole, the system works pretty well and only minor changes are necessary to make it work better." .r "Refused",modify	

recode q39 (1 = 0 "0") (2 = 1 "1") (3 = 2 "2") (4 = 3 "3") (5 = 4 "4") (6 = 5 "5") (7 = 6 "6") (8 = 7 "7") (9 = 8 "8") (10 = 9 "9") (11 = 10 "10") (12 = .r "Refused"), pre(rec)
drop q39
	
ren rec* *

*******************************************************************************
	
* all vars missing labels from values:
label define labels149 .a "NA" .d "Don't know" .r "Refused",add
label define q15_label .a "NA" .d "Don't know" .r "Refused",add
label define labels156 .a "NA" .d "Don't know" .r "Refused",add
label define labels160 .a "NA" .d "Don't know" .r "Refused",add
label define q33_label .a "NA" .d "Don't know" .r "Refused",add
label define q50_label .a "NA" .d "Don't know" .r "Refused",add
label define q51_label .a "NA" .d "Don't know" .r "Refused",add

* for appending process:
label copy q4_label q4_label2
label copy q5_label q5_label2
label copy q15_label q15_label2
label copy q33_label q33_label2
label copy q50_label q50_label2
label copy q51_label q51_label2

label val q4 q4_label2
label val q5 q5_label2
label val q15 q15_label2
label val q33 q33_label2
label val q50 q50_label2
label val q51 q51_label2

label drop q4_label q5_label q33_label q51_label

label copy labels25 q14_co
label copy labels26 q14_pe
label copy recq14_uy q14_uy

label val q14_co q14_co
label val q14_pe q14_pe
label val q14_uy q14_uy

label drop q14_co q14_pe q14_uy

label copy labels69 p32_col
label copy labels70 p32_per
label copy labels71 p32_uru

label val p32_col p32_col
label val p32_per p32_per
label val p32_uru p32_uru

label drop labels69 labels70 labels71

*------------------------------------------------------------------------------*

*Reorder variables
order q*, sequential
order respondent_serial respondent_id mode country wave language date int_length weight // language was not in dataset

*-------------------------------------------------------------------------------*

* Label variables - double check matches the instrument					
lab var country "Country"
lab var weight "Weight"
lab var respondent_serial "Respondent Serial #"
lab var int_length "Interview length (minutes)" 
lab var date "Date of the interview"
lab var respondent_id "Respondent ID"
lab var language "Language"

lab var mode "mode"
lab var q1 "Q1. Respondent's еxact age"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent's gender"
lab var q4 "Q4. What region do you live in?"
lab var q5 "Q5. Which of these options best describes the place where you live?"
lab var q6 "Q6. Do you have health insurance?"
lab var q7 "Q7. What type of health insurance do you have?"

lab var q8 "Q8. What is the highest level of education that you have completed?"
lab var q9 "Q9. In general, would you say your health is:"
lab var q10 "Q10. In general, would you say your mental health, including your mood and your ability to think clearly, is:"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
lab var q12_a "Q12a. How confident are you that you are responsible for managing your health?"
lab var q12_b "Q12b. Can tell a healthcare provider your concerns even when not asked?"
lab var q13 "Q13. Is there one healthcare facility or healthcare provider's group you usually go to for most of your healthcare?"
lab var q13a_lac "Q13a. LAC/EC only: Are there any other places, such as pharmacies, traditional healers, or alternative medicine, that you go to most frequently for care?" 
lab var q15 "Q15. What type of healthcare facility is this?"
label var q16 "Q16. Why did you choose this healthcare facility? Please tell us the main reason."
label var q17 "Q17. Overall, how would you rate the quality of healthcare you received in the past 12 months from this healthcare facility?"
label var q18 "Q18. How many healthcare visits in total have you made in the past 12 months?"
label var q19 "Q19. Total number of healthcare visits in the past 12 months choice(range)"
label var q18_q19 "Q18/Q19. Total mumber of visits made in past 12 months (q18, q19 mid-point)"
label var q20 "Q20. You said you made * visits. Were they all to the same facility?"
label var q21 "Q21. How many different healthcare facilities did you go to in total?"
label var q22 "Q22. How many visits did you have with a healthcare provider at your home?"
label var q23 "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
label var q24 "Q24. What was the main reason for the virtual or telemedicine visit?"
label var q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
label var q26 "Q26. Stayed overnight at a facility in past 12 months (inpatient care)"
label var q27_a "Q27a. Blood pressure tested in the past 12 months"
label var q27_b "Q27b. Breast examination"
label var q27_c "Q27c. Received cervical cancer screening, like a pap test or visual inspection"
label var q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
label var q27_e "Q27e. Had your teeth checked in the past 12 months"
label var q27_f "Q27f. Had a blood sugar test in the past 12 months"
label var q27_g "Q27g. Had a blood cholesterol test in the past 12 months"
label var q27_h "Q27h. Received care for depression, anxiety, or another mental health condition"
label var q28_a "Q28a. A medical mistake was made in your treatment or care in the past 12 months"
label var q28_b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
label var q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label var q30 "Q30. The last time this happened, what was the main reason you did not receive healthcare?"
label var q31a "Q31a. Have you ever needed to borrow money to pay for healthcare"
label var q31b "Q31b. Sell items to pay for healthcare"
label var q31_lac "Q31. LAC/EC only: In the last 12 months, have you stopped paying any utility bills (cable, electricity, water, etc.) to pay for healthcare?"
*label var q32_co_pe_uy "Q32. Was this a public, private, NGO or faith-based facility?" // change to LAC var
label var q33 "Q33. What type of healthcare facility was this?"
label var q34 "Q34. What was the main reason you went?"
label var q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt?"
label var q36 "Q36. How long did you wait in days, weeks, or months between making the appointment and seeing the health care provider?"
label var q37 "Q37. At this most recent visit, once you arrived at the facility, approximately how long did you wait before seeing the provider?"
label var q38_a "Q38a. How would you rate the overall quality of care you received?"
label var q38_b "Q38b. How would you rate the knowledge and skills of your provider?"
label var q38_c "Q38c. How would you rate the equipment and supplies that the provider had?"
label var q38_d "Q38d. How would you rate the level of respect your provider showed you?"
label var q38_e "Q38e. How would you rate your provider knowledge about your prior visits and test results?"
label var q38_f "Q38f. How would you rate whether your provider explained things clearly?"
label var q38_g "Q38g. How would you rate whether you were involved in your care decisions?"
label var q38_h "Q38h. How would you rate the amount of time your provider spent with you?"
label var q38_i "Q38i. How would you rate the amount of time you waited before being seen?"
label var q38_j "Q38j. How would you rate the courtesy and helpfulness at the facility?"
label var q38_k "Q38k. How would you rate how long it took for you to get this appointment?"
label var q39 "Q39. How likely would recommend this facility to a friend or family member?"
label var q40_a "Q40a. How would you rate the quality of care during pregnancy and childbirth like antenatal care, postnatal care"
label var q40_b "Q40b. How would you rate the quality of childcare such as care of healthy children and treatment of sick children"
label var q40_c "Q40c. How would you rate the quality of care provided for chronic conditions?"
label var q40_d "Q40d. How would you rate the quality of care provided for the mental health?"
label var q41_a "Q41a. How confident are you that you'd get good healthcare if you were very sick?"
label var q41_b "Q41b. How confident are you that you'd be able to afford the care you required?"
label var q41_c "Q41c. How confident are you that the government considers the public's opinion?"
label var q42 "Q42. How would you rate the quality of government or public healthcare system in your country?"
label var q43 "Q43. How would you rate the quality of the private for-profit healthcare system in your country?"
*label var q44_multi "Q44. How would you rate quality of NGO/faith-based healthcare system in your country?" // change to LAC var
label var q45 "Q45. Is your country's health system is getting better, staying the same or getting worse?"
label var q46 "Q46. Which of these statements do you agree with the most?"
label var q47 "Q47. How would you rate the government's management of the COVID-19 pandemic overall?"
label var q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label var q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label var q50 "Q50. What is your native language or mother tongue?"
label var q51 "Q51. Total monthly household income"
label var cell1 "Do you have another mobile phone number besides the one I am calling you on?"
label var cell2 "How many other mobile phone numbers do you have?"

*------------------------------------------------------------------------------*
* Save data

save "$data_mc/02 recoded data/input data files/pvs_co_pe_uy_wave2.dta", replace

*------------------------------------------------------------------------------*

	