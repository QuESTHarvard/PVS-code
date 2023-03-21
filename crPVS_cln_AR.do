* People's Voice Survey data cleaning for Argentina
* Last updated: March 14 2023
* N. Kapoor, S. Sabwa

************************************* Argentina ************************************

* Import data -confirm Path
use "/Users/shs8688/Dropbox (Harvard University)/SPH-Kruk Team/QuEST Network/Core Research/People's Voice Survey/PVS External/Data/Argentina (Mendoza)/01 raw data/PVS_Mendoza_Data_23.01.27.dta", clear

* Note: .a means NA, .r means refused, .d is don't know, . is missing 

*------------------------------------------------------------------------------*
* Rename all variables, and some recoding if variable will be dropped 
*"Codes" vars need to be recoded as .r (refused) and .d (don't know) only for the participants with values in the "Code" var

ren LanguageID Language
ren P46_Minutos int_length
ren pond weight
ren P1 q1

*needs to be recoded from P1 - confirm categories:
gen q2= .
replace q2 = 0 if (q1 >= 18 & q1 <= 29)
replace q2 = 1 if (q1 >= 30 & q1 <= 39)
replace q2 = 2 if (q1 >= 40 & q1 <= 49)
replace q2 = 3 if (q1 >= 50 & q1 <= 59)
replace q2 = 4 if (q1 >= 60 & q1 <= 69)
replace q2 = 5 if (q1 >= 70 & q1 <= 79)
replace q2 = 6 if (q1 >= 80)
replace q2 = .a if (q1==.)

ren P3_A q3
ren P3_B q3a_co_pe_uy_ar
ren P4 q4
ren P5 q5

*q7 is in 6 different vars: P71, P72, P73, P74, P75, P76 - need to change yes/no, yes to name of variable - there are no "missing" in each variable
gen q7 = 1601 if P71 == 1 
replace q7 =1602 if P72 == 1
replace q7 = 1603 if P73 == 1
replace q7 = 1604 if P74 == 1
replace q7 = 1605 if P75 == 1
replace q7 = .a if P76 == 1
*1607 = "No insurance" - 0 people with no insurance - check no accross as well
replace q7 = 1607 if (P71==0 & P72==0 & P73==0 & P74==0 & P75==0 & P76==0)

*double check someone hasn't entered "Yes" to more than one option: 
*No one has >1
egen sum = rowtotal(P71 P72 P73 P74 P75)
tab sum

ren P8 q8
ren P9 q9
ren P10 q10
ren P11 q11
ren P12 q12
ren P13 q13
ren P13_B q13b_co_pe_uy_ar
ren P13_E q13e_co_pe_uy_ar
ren P13_E_10 q13e_other
ren P14 q14
ren P15 q15
ren P16 q16
ren P17 q17
ren P18 q18
ren P19 q19_ar
ren P19_4 q19_other
ren P20 q20
*q20_other 
gen q20_other = P20_3 + P20_4 + P20_8 + P20_9 + P20_13 + P20_14 + P20_16 + P20_17 + P20_21 + P20_22 + P20_25 + P20_26

*change q21for additional AR var:
gen q21 = .
replace q21 = 1 if P21 ==1
replace q21 = 2 if P21 ==2
replace q21 = 3 if P21 ==4
replace q21 = 4 if P21 ==5
replace q21 = 5 if P21 ==6
replace q21 = 6 if P21 ==7
replace q21 = 7 if P21 ==8
replace q21 = 8 if P21 ==9
replace q21 = 9 if P21 ==10
replace q21 = 10 if P21 ==3
replace q21 = .r if P21 ==11

	  
ren P21_10 q21_other
ren P22 q22

*adding .r/.d to q23 based on P23_Codes
replace P23 = .d if P23_Codes == 1
replace P23 = .r if P23_Codes == 2
ren P23 q23

ren P24 q24
ren P25 q25_a

*adding .r/.d to q23 based on P25_Codes - no data
replace P25_B = .d if P25_B_Codes == 1
replace P25_B = .r if P25_B_Codes == 2
ren P25_B q25_b

ren P26 q26

*adding .r/.d to q27 based on P27_Codes1 or P27_Codes2
replace P27 = .d if P27_Codes1 == 1
*P27_Codes2 only has "No" in the data right now 
replace P27 = .r if P27_Codes2 == 1 
ren P27 q27

*adding .r/.d to q28 based on P28_Codes1 or P28_Codes2
*Codes1 only has "No" in the data right now
replace P28 = .d if P28_Codes1 == 1
replace P28 = .r if P28_Codes2 == 1 
ren P28 q28_a

*adding .r/.d to q28_b based on P28_B_Codes1 or P28_B_Codes2
replace P28_B = .d if P28_B_Codes1 == 1
replace P28_B = .r if P28_B_Codes2 == 1 
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

*specific AR value added to q42:
gen q42 = .
replace q42 = 1 if P42 ==1
replace q42 = 2 if P42 ==2
replace q42 = 11 if P42 ==3
replace q42 = 3 if P42 ==4
replace q42 = 4 if P42 == 5
replace q42 = 5 if P42 ==6
replace q42 = 6 if P42 ==7
replace q42 = 7 if P42 ==8 
replace q42 = 8 if P42 ==9
replace q42 = 9 if P42 ==10
replace q42 = 10 if P42 ==11
replace q42 = .r if P42 ==12

ren P42_11 q42_other
ren P43 q43_ar
ren P43_4 q43_other
ren P44 q44
*q44_other:
gen q44_other = P44_3 + P44_4 + P44_8 + P44_9 + P44_13 + P44_14 + P44_16 + P44_17 + P44_21 + P44_22 + P44_25 + P44_26
ren P45 q45
ren P45_4 q45_other

ren P46 q46
replace q46 = .r if P46_Minutos_Codes == 96

*confirm- added .r to P46
*gen q46_refused = .
*replace q46_refused = .r if P46_Minutos_Codes == 96

ren P47 q47
replace q4 = .r if P47_Codes == 96

*confirm- added .r to P47
*gen q47_refused = . 
*replace q47_refused = .r if P47_Codes == 96

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
ren P56 q55

*q56_ar
ren P55 q56a_ar
ren P66 q56b_ar
ren P67 q56c_ar
ren P57 q57
ren P58 q58
ren P59 q59
ren P60 q60
ren P61 q61
ren P63 q63
ren P64 q64

*adding .r/.d to q65 based on P65_Codes1 or P65_Codes2
replace P65 = .d if P65_Codes1 == 1
replace P65 = .r if P65_Codes2 == 1 
ren P65 q65

*------------------------------------------------------------------------------*

* Date
generate date=mdy(CurrentMonth,CurrentDay,CurrentYear) 
format date %tdD_M_CY

*------------------------------------------------------------------------------*

* Drop unused or other variables - dropped P1_Codes because it has no data and no label as to which question it belongs to

drop Respondent_ID P2 DataCollection_Status1 introduccion confidencial Auto_grab P2 SampleFields_SampDEPARTAMENTO SampleFields_SampZONA SampleFields_SampZONAP3A SampleFields_SampTIPO SampleFields_SampSEXO SampleFields_SampPROVINCIA_DS SampleFields_SampEDAD cr1 cr2 cr3 cr4 cr5 P29_B P71 P72 P73 P74 P75 P76 P20_3 P20_4 P20_8 P20_9 P20_13 P20_14 P20_16 P20_17 P20_21 P20_22 P20_25 P20_26 P21 P42 P44_3 P44_4 P44_8 P44_9 P44_13 P44_14 P44_16 P44_17 P44_21 P44_22 P44_25 P44_26 CurrentMonth CurrentDay CurrentYear P1_Codes P23_Codes P25_B_Codes P27_Codes1 P27_Codes2 P28_Codes1 P28_Codes2 P28_B_Codes1 P28_B_Codes2 P65_Codes1 P65_Codes2 sum P46_Minutos_Codes P47_Codes
 

*------------------------------------------------------------------------------*

* Recode refused and don't know values 
* In raw data, coding "No response" as refused 	  
recode q3a_co_pe_uy_ar q4 q36 q39 q57 q58 q64 (4 = .r)	
recode q8 q63 (8 = .r)
recode q9 q10 q14 q54 q56a_ar q56b_ar q56c_ar q55 q59 q60 q61 (6 = .r)
recode q11 q12 q13 q13b_co_pe_uy_ar q15 q18 q26 q29 q41 (3 = .r)
recode q16 q17 q19_ar q24 q43_ar q45 q51 q52 q53 (5 = .r)
recode q22 q50_a q50_b q50_c q50_d (7 = .r)
recode q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j (96 = .r)
recode q21 (11 = .r)

*"Don't Know" vars
recode q30 q31 q32 q35 q36 q38 (3 = .d)

*"NA" vars - 6 is "No había hecho consultas o exámenes previos" = He had not made previous consultations or examinations and 7 is "El lugar no tenía otro personal" = the place had no other staff
*double check q48_c data, 6 should not be an option according to the instrument
recode q48_c q48_e (6 = .a)
recode q48_j (7 = .a)

*for these, recoding to NA as well but 6 is " No podría juzgar" = Couldn't judge
recode q50_a q50_b q50_c q50_d (6 = .a)

*q22 6 "No se atendió en ese lugar en los últimos 12 meses." = You have not been seen at that location in the last 12 months which is .a in main data dictionary
recode q22 (6 = .a)

*q39/q40 3 "No se atendió en los últimos 12 meses."
recode q39 q40 (3 = .a)

*------------------------------------------------------------------------------*

* Generate variables:

* Country-specific values and value labels 

* Generate variables
gen respondent_id = "AR" + string(Respondent_Serial)
gen country=16
lab def country 16 "Argentina" 
lab val country country
gen mode=1
lab def mode 3 "CATI"
lab val mode mode
gen language=1601
lab define lang 1601 "Spanish" 
lab val language lang

* Country-specific values 
gen recq4 = country*1000 + q4
gen recq5 = country*1000 + q5 
gen recq8 = country*1000 + q8 
gen recq20 = country*1000 + q20 
gen recq44 = country*1000 + q44 
gen recq63 = country*1000 + q63
replace recq63 = .r if q63== .r

* Q23/Q24 mid-point var 
gen q23_q24 = q23 
recode q23_q24 (.r = 2.5) (.d = 2.5) if q24 == 1
recode q23_q24 (.r = 7) (.d = 7) if q24 == 2
recode q23_q24 (.r = 10) (.d = 10) if q24 == 3
recode q23_q24 (.d = .r) if q24 == .r 

*------------------------------------------------------------------------------*

* Value labels  - every variable came with its own set of value labels?

label define q2_label 0 "18-29" 1 "30-39" 2 "40-49" 3 "50-59" 4 "60-69" 5 "70-79" 6 "80 or older"

label define labels8 3 "AR: Otro género", modify

label define q7 1601 "AR: Pública" 1602 "AR: OSEP" 1603 "AR: Otras obras sociales (Ejemplo: OSPE, OSDIPP)" 1604 "AR: PAMI" 1605 "AR: Prepaga o privada. (Ejemplo OSDE, GALENO, o similares)" 
			   			    					
label value q7 q7

*q21:
label define q21_label 1 "Bajo costo" 2 "Cercanía" 3 "Espera corta en lugar de atención (desde que llega hasta consulta)" 4 "Calidad de la atención" 5 "Respeto del personal" 6 "Disponibilidad de medicación y equipamiento" 7 "Único lugar disponible" 8 "Le corresponde por la cobertura" 9 "Otro <B>[NO LEER] </B>" 10 "AR: Tiempos de espera cortos  para obtener turnos"

label value q21 q21_label


*q42: - var names cut off
label define q42_label 1 "Alto costo (p.ej. elevado pago de bolsillo, atención no cubierta por seguro)" ///
2 "Lejanía (p.ej. establecimiento muy lejo"  ///
3 "Largos tiempos de espera en el establecimiento (p.ej. largas colas para acceder al establecimiento, larga espera para re" ///
4 "Mala calidad de atención (p.ej. la consulta fue muy rápida, no se hizo un examen clínico completo" ///
5 "Falta de respeto de parte del personal de salud (p.ej. el personal es vulgar, descortés, desdeñoso)" ///
6 "No había medicamentos o equipos médicos disponibles (p.ej. generalmente no hay medicación, o no hay equipos, como aparat" ///
7 "No estaba muy enfermo (incluye que usted no se consideraba muy enfermo para ir atenderse o que el personal de salud no l" ///
8 "Restricciones por COVID-19 (p.ej. cuarentenas, restricciones de viaje, toques de queda)" 9 "Miedo al COVID-19" ///
10 "Otro <B>[NO LEER] </B>" 11 "AR: Demora para conseguir un turno"

label value q42 q42_label

*------------------------------------------------------------------------------*

* Check for other implausible values 

*------------------------------------------------------------------------------*

* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*q6
gen q6 = .a

*q13b_co_pe_uy_ar  & q13e_co_pe_uy_ar
recode q13b_co_pe_uy_ar (. = .a) if q12 == 2 | q12 == .r 
recode q13e_co_pe_uy_ar (. = .a) if q12 == 2 | q12 == .r  | q13b_co_pe_uy_ar == 1

*q15
recode q15 (. = .a) if q14 == 3 | q14 == 4 | q14 == 5 | q14 == .r


*q19-22 
recode q19_ar q20 q21 q22 (. = .a) if q18 == 2 | q18 ==.r // no usual source of care


* NA's for q24-28 - redo for AR
recode q24 (. = .a) if q23 != .d | q23 != .r | q23 != . 
recode q25_a (. = .a) if q23 != 1
recode q25_b (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q26 (. = .a) if q23 == 0 | q23 == 1 | q24 == 1 | q24 == .r 
recode q27 (. = .a) if q26 == 1 | q26 == .a | q26 == .r 

* q31 & q32
recode q31 (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r
recode q32 (. = .a) if q3 != 2 | q1 == .r | q2 == .r 

* q42
recode q42 (. = .a) if q41 == 2 | q41 == .r

* q43-49 na's
recode q43_ar recq44 q45 q46 q46 q47 q48_a q48_b q48_c q48_d q48_e q48_f /// 
	   q48_g q48_h q48_i q48_j q49 (. = .a) if q23 == 0 | q24 == 1 | q24 == .r

recode recq44 (. = .a) if q43_ar == 4 | q43_ar == .r
 

*q65?
recode q65 (. = .a) if q64 == 2 | q64 == .r

 
*------------------------------------------------------------------------------*

* Recode value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions - should q15 be added? q64?
recode q11 q12 q13 q13b_co_pe_uy_ar q18 q25_a q26 q29 q30 q31 q32 q33 q34 q35 q36 q38 q39 q40 q41 ///
	   (1 = 1 Yes) (2 = 0 No) (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no)
	  
	   
* All Excellent to Poor scales

recode q9 q10 q22 q48_a q48_b q48_c q48_d q48_e q48_f q48_g q48_h q48_i q48_j q50_a q50_b q50_c q50_d q59 q60 q61 ///
	   (1 = 4 Excellent) (2 = 3 "Very Good") (3 = 2 Good) (4 = 1 Fair) /// 
	   (5 = 0 Poor) (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(exc_poor)
	 

* All Very Confident to Not at all Confident scales 
	   
recode q16 q17 q51 q52 q53 q54 q55 q56a_ar q56b_ar q56c_ar ///
	   (1 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (3 = 1 "Not too confident") (4 = 0 "Not at all confident") /// 
	   (.r = .r Refused) (.a = .a NA), /// 
	   pre(rec) label(vc_nc)


* Miscellaneous questions with unique answer options
recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
	   
	   
	   recode q3 ///
	(1 = 0 Male) (2 = 1 Female) (.r = .r Refused), ///
	pre(rec) label(gender)

recode q14 ///
	(1 = 0 "0- no doses received") (2 = 1 "1 dose") (3 = 2 "2 doses") ///
	(4 = 3 "3 doses") (5 = 4 "More than 3 doses") (.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(covid_vacc)

recode q15 /// 
	   (1 = 1 "Yes, I plan to receive all required doses") ///
	   (2 = 0 "No, don't plan to receive all required doses") ///
	   (.r = .r Refused) (.a = .a NA), ///
	   pre(rec) label(yes_no_doses)
	   
recode q24 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

recode q57 ///
	(3 = 0 "Getting worse") (2 = 1 "Staying the same") (1 = 2 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)

* Numeric questions needing NA and Refused value labels 
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b q46 q46b q47 na_rf

	   *------------------------------------------------------------------------------*

* Renaming variables 
* Rename variables to match question numbers in current survey 

***Drop all the ones that were recoded, then drop the recode, and rename then according to the documents

drop q4 q5 q8 q20 q44 q62 q63 q66 q11 q12 q18 q13 q25_a q26 q29 q41 q30 q31 ///
	 q32 q33 q34 q35 q36 q38 q39 q40 q46a q9 q10 q28_c q48_a q48_b q48_c q48_d ///
	 q48_f q48_g q48_h q48_i q48_k q54 q55 q59 q60 q61 q22 q48_e q48_j q50_a q50_b ///
	 q50_c q50_d q16 q17 q51 q52 q53 q2 q3 q14 q15 q24 q56 q57

ren rec* *
 
*Reorder variables
order q*, sequential
order q*, after(language) 

*------------------------------------------------------------------------------*
* Label variables  - pending if we have to retranslate/fix HTML
* do these need to be labeled: recq4 recq5 recq8 recq20 recq44 recq63 q23_q24 q6
*Why are "other" and "refused" commented out in KR?

lab var q2 "P2-Puede decirme si tiene entre…<BR/><B>ENCUESTADOR: LEER OPCIONES</B>"   
lab var q7 "P1-<B>ENCUESTADOR DEBE LEER:</B><BR/>Voy a comenzar a hacerle preguntas sobre us" 
lab var q13e_other "P13_E-¿Cuál fue la razón principal por la que no obtuvo atención para COVID-"
lab var q19_other "P19. Otro" 
lab var q21 "P21-¿Por qué eligió ese lugar?  (Díganos la razón principal). <BR/><B>ENCUE" 
lab var q21_other "P21. Otro" 
lab var q42 "P42-La última vez que sucedió, ¿cuál fue la razón principal por la que no o"    
lab var q42_other "P42. Otro""   
lab var q43_other "P43. Otro"  
lab var q44_other "P44. Otro"    
lab var q45_other "P45. Otro" 
lab var date "Date of the interview" 
lab var country "Country"  
lab var mode "Mode of interview (CATI or F2F)"  
lab var language "Language"   


