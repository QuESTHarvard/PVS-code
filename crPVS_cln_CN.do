* People's Voice Survey data cleaning for China
* Date of last update: 26 Jan 2024
* Last updated by: Xiaohui Wang

/*

This file cleans Ipsos data for China. 

Cleaning includes:
	- Recoding skip patterns, refused, and don't know 
	- Creating new variables (e.g., time variables), renaming variables, labeling variables 
	- Correcting any values and value labels and their direction
	- Comparison with PVS V1.0 and make the changes and variable codequestionnaire for future V2.0 users
	
Missingness codes: .a = NA (skipped), .r = refused, .d = don't know, . = true missing 
*/

clear all
set more off 

*********************** CHINA ***********************

* Import data 
import excel "C:\Users\think\OneDrive\3.Project\3.PVS\data\PVS_China_raw_12102023.xlsx", sheet("data") firstrow case(lower) clear

use "C:\Users\think\OneDrive\3.Project\3.PVS\data\data\PVS_China_raw_12102023.dta"

*note: This version is mainly focused on variable names and labels.

*change variable type to keep consistant with V1.0 varible types
destring q1code q1value q2 q3 q4region_province _1region_city _2region_couty _2region_couty_name _2other q5 q6 q7 q8 q9 q10 q11 q12_a q12_b q13 q14 q15 q16 q17 q18code q18value q19 q20 q21code q21value q22code q22value q23code q23value q24 q25 q26 q27a q27b q27bi q27bii q27c q27d q27e q27f q27g q27h q28a q28b q29 q30 q31a q31b q32 q33 q34 q35 q36 q37 q37other q38c q38a q38b q38d q38e q38f q38g q38h q38i q38k q38j q39code q39value q40a q40b q40c q40d q41a q41b q41c q42 q43 q45 q46 q47 q48 q49 q50 q51a q51b CELL1 CELL2 language, replace

* Renaming and labeling variables, and some recoding if variable will be dropped or change 
ren q12a q12_a
ren q12b q12_b

lab var country "Country"

rename Interviewtimeminutes int_length
lab var int_length "Interview length (in minutes)" 

rename Interviewdate date
lab var date "Date of interview"

lab var ID "Respondent ID"

replace q1value = 999 if q1value == .
ren q1value q1
drop q1code
lab var q1 "Q1. Respondent еxact age"
label variable q1 "Q1. value"
lab var q2 "Q2. Respondent's age group"
lab var q3 "Q3. Respondent gender"
rename q4region_province q4
lab variable q4 "Q4. Type of area where respondent lives-province"
lab variable _1region_city "q4_1.region_city"
rename _1region_city q4_1
lab variable _2region_couty "q4_2. region_couty"
rename _2region_couty q4_2
lab variable _2region_couty_name "q4_2_1.region_couty_name"
rename _2region_couty_name q4_2_1
lab variable _2other "q4_2_other, if region is not in the list"
rename _2other q4_2_other
drop  q4_2_other
lab var q5 "Q5. County, state, region where respondent lives"
lab var q6 "Q6. Do you have health insurance?"
replace q7 = .a if q7 == .  //Because Q6 skip (responded no insurance)

*Note: .a means NA, .r means refused, .d is don't know, . is missing 
lab var q7 "Q7. What type of health insurance do you have?"
rename q7other q7_other
lab var q7_other "Q7. Other type of health insurance" 
replace q7_other = "不知道" if q7_other == "不清楚" ///
                              | q7_other == "不知道." ///
							  | q7_other == "不知道。" ///
							  | q7_other == "不知道没注意，每次都是直接支付宝" ///
							  | q7_other== "不知道，不清楚" ///
							  | q7_other== "不知道，我忘了，说不清楚" ///
							  | q7_other == "不记得" ///
							  | q7_other == "家里给买的不太清楚" ///
							  | q7_other == "我不清楚，我爸帮我搞的。" ///
							  | q7_other == "我不知道这两个的区别，是公司买的" ///
							  | q7_other == "我也不知道，我没了解过这个方面" ///
							  | q7_other == "这个我不知道"
							  
replace q7_other = "社保" if q7_other == "个人买的社保" ///
                              | q7_other == "社会医保" ///
							  | q7_other == "社保。" ///
							  | q7_other == "社保，不知道是什么" 
replace q7_other = "城镇职工医疗保险和商业医疗保险" if q7_other == "城乡和商业都有，一样重要" ///
                              | q7_other == "城镇职工医疗保险和商业医疗保险都有在用，如果去私立医院就是商业医疗保险，去公立医院就是城镇职工医疗保险。" ///
							  | q7_other == "我有职工和商业险，我不知道哪个最主要" 
replace q7_other = "城乡居民医疗保险和商业医疗保险" if q7_other=="城镇职工医疗保险和商业医疗保险都有，都重要啊"  ///
							  | q7_other == "城乡居民医疗保险，和商业医疗"
replace q7=2 if q7_other == "每年120元"
replace q7_other = "4种保险" if q7_other == "什么都有，公费，个人都有，有四个，我不知道哪个最重要"
replace q7_other=".d" if q7_other == "不知道" ///


lab var q8 "Q8. Highest level of education completed by the respondent"
*lab var q8_other "Q8. Other" 
*not in V2.0

lab var q9 "Q9. In general, would you say your health is"
lab var q10 "Q10. In general, would you say your mental health is?"
lab var q11 "Q11. Do you have any longstanding illness or health problem?"
/*Q12-Q15 in V1.0 were deleted in V2.0
*lab var q12 "Q12. Have you ever had COVID-19 or coronavirus?"///deleted question
*lab var q13 "Q13. Was it confirmed by a test?"///deleted question
*lab var q14 "Q14. How many doses of a COVID-19 vaccine have you received?"///deleted question
*lab var q15 "Q15. Do you plan to receive all recommended doses if they are available to you?"
*/
lab var q12_a "Q12a. How confident are you that you are the person who is responsible for managing your overall health"  //V1.0 q16
lab var q12_b "Q12b. you can tell a healthcare provider concerns you have even when he or she does not ask" //V1.0 q17
lab var q13 "Q13. Is there one healthcare facility or provider's group you usually go to?" //V1.0 q18
lab var q14 "Q14. Is this a public, private, or NGO/faith-based healthcare facility?" //V1.0 q19
replace q14=.a if q14==.  //due to Q13 skip (responded no usual care facility) //V1.0 q19_multi 
*lab var q14_other "Q19. ET/IN/KE/RO/ZA only: Other"
rename q14other q14_other
label variable q14_other "Q14. if the respondent do not know public/private"
replace q14_other="不知道" if q14_other=="不清楚"
replace q14_other=".d" if q14_other=="不知道"

lab var q15 "Q15. What type of healthcare facility is this?" //aks if q13=1
replace q15=.a if q15==. //due to Q13 skip (responded have usual care facility)

rename q15other q15_other
label variable q15_other "Q15. Other, if the respondent do not know type of facility"
replace q15_other = "不知道" if q15_other == "不清楚" ///
                              | q15_other == "三甲医院" ///
                              | q15_other == "中西五医院" ///
							  | q15_other == "中西结合医院" ///
							  | q15_other == "保健院" ///
							  | q15_other == "天门市妇幼保健院" ///
							  | q15_other == "工人医院"
replace q15_other=".d" if q15_other == "不知道"

label variable q16 "Q16. Why did you choose this healthcare facility，Please tell us the main reason."
replace q16=.a if q16==.  
replace q16=.a if q13==0 //ASK IF Q13=1, Skip if q13=0 (responded have usual care facility) 
rename q16other q16_other
label variable q16_other "Q16. Other reasons"
replace q16=8 if q16_other == "单位附属医院" ///
               | q16_other == "员工" ///
			   | q16_other == "因为我在那里上班。" ///
			   | q16_other == "在医院工作"  ///
			   | q16_other == "就在本单位工作，所以选择这家医院"  ///
			   | q16_other == "我在那工作"  ///
			   | q16_other == "我是在这个医院读书"  ///
			   | q16_other == "自己的医院"  ///
			   | q16_other == "这家医院的职工"
list q16_other if q16_other == "单位附属医院" ///
               | q16_other == "员工" ///
			   | q16_other == "因为我在那里上班。" ///
			   | q16_other == "在医院工作"  ///
			   | q16_other == "就在本单位工作，所以选择这家医院"  ///
			   | q16_other == "我在那工作"  ///
			   | q16_other == "我是在这个医院读书"  ///
			   | q16_other == "自己的医院"  ///
			   | q16_other == "这家医院的职工"
replace q16=7 if q16_other == "没得选择"
list q16_other if q16_other == "没得选择"
replace q16=6 if q16_other == "设备好"
list q16_other if q16_other == "设备好"
replace q16=5 if q16_other == "医院服务好"
list q16_other if q16_other == "医院服务好"
replace q16=3 if q16_other == "人少"
list q16_other if q16_other == "人少"
replace q16=4 if q16_other == "三甲医院" ///
               | q16_other == "出名"  ///
	           | q16_other == "因为那家医院是当地最好的" ///
			   | q16_other == "大医院比较权威"  ///
			   | q16_other == "大医院，比较有公信力"  ///
			   | q16_other == "当地名气最大"  ///
			   | q16_other == "最好的医院"  ///	
			   | q16_other == "机构比较权威。" ///
			   | q16_other == "权威" ///
			   | q16_other == "权威机构"  ///
			   | q16_other == "比较权威"  ///
			   | q16_other == "比较权威靠谱"  ///
			   | q16_other == "这是三甲医院"  ///
			   | q16_other == "医院比较大，医院等级"  ///
			   | q16_other == "医院规模比较大"  ///
			   | q16_other == "医院较大，比较专业有安全感"  ///
			   | q16_other == "因为它是市级医院，比较大一些"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "大医院，比较放心"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "最大的，安全一些"  ///
			   | q16_other == "比较正规吧大医院"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "专科"  ///
			   | q16_other == "这里最大的医院"
list q16_other if q16_other == "三甲医院" ///
               | q16_other == "出名"  ///
	           | q16_other == "因为那家医院是当地最好的" ///
			   | q16_other == "大医院比较权威"  ///
			   | q16_other == "大医院，比较有公信力"  ///
			   | q16_other == "当地名气最大"  ///
			   | q16_other == "最好的医院"  ///	
			   | q16_other == "机构比较权威。" ///
			   | q16_other == "权威" ///
			   | q16_other == "权威机构"  ///
			   | q16_other == "比较权威"  ///
			   | q16_other == "比较权威靠谱"  ///
			   | q16_other == "这是三甲医院"  ///
			   | q16_other == "医院比较大，医院等级"  ///
			   | q16_other == "医院规模比较大"  ///
			   | q16_other == "医院较大，比较专业有安全感"  ///
			   | q16_other == "因为它是市级医院，比较大一些"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "大医院，比较放心"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "最大的，安全一些"  ///
			   | q16_other == "比较正规吧大医院"  ///
			   | q16_other == "大医院好一点"  ///
			   | q16_other == "专科" ///
			   | q16_other == "这里最大的医院"
replace q16=2 if q16_other == "乡镇医院方便" ///
               | q16_other == "综合因素，距离近公立方便多种原因"
list q16_other if q16_other == "乡镇医院方便" ///
               | q16_other == "综合因素，距离近公立方便多种原因"
replace q16_other = "相信中医" if q16_other == "中医比西医好一点" ///
               | q16_other == "中药对人体副作用伤害小" ///
			   | q16_other == "主要是想看中医" ///
			   | q16_other == "我支持中医" ///
			   | q16_other == "我相信中医这块。" ///
			   | q16_other == "更相信中医" ///
			   | q16_other == "要看中医"	   
replace q16_other = "专科" if q16_other == "专病专治" ///
               | q16_other == "这是专科医院" ///
			   | q16_other == "专业对口"
replace q16_other = "朋友推荐" if q16_other == "别人推荐的" ///
               | q16_other == "熟人介绍" 
replace q16_other = "环境好" if q16_other == "环境比较好" 
replace q16_other = "医疗条件好" if q16_other == "医疗条件有保障"
replace q16_other = "有熟人" if q16_other == "有熟人在，可以帮忙" ///
                                | q16_other == "有熟人，有认识的人" ///
								| q16_other == "有熟人。" ///
								| q16_other == "有家人在" ///
								| q16_other == "因为我老婆在那里上班。" ///
								| q16_other == "有熟人在，可以帮忙。" ///
								| q16_other == "我以前在这里工作"
								
replace q16_other = "信任医院" if q16_other == "具有安全感、靠谱" ///
								| q16_other == "口碑" ///
								| q16_other == "口碑好" ///
								| q16_other == "安心些" ///
								| q16_other == "存在时间长，从出生就在" ///
								| q16_other == "对医院的信任吧。" ///
								| q16_other == "放心" /// 
								| q16_other == "正规医疗机构比较放心" ///
								| q16_other == "正规医院" ///
								| q16_other == "比较规范" ///
								| q16_other == "镇医院有保障撒。" ///
								| q16_other == "放心一点不会乱收费"
replace q16_other = "公立医院" if q16_other == "公立医院有保障" ///
                                | q16_other == "公立医院，比较可靠" ///
								| q16_other == "国家医院，正规" ///
								| q16_other == "当地时间最早的公立医院" ///
								| q16_other == "是公立医院，上公立医院方便"
replace q16_other="习惯了" if q16_other == "习惯" ///
                            | q16_other == "习惯性。" ///
							| q16_other == "我去习惯了。" ///
							| q16_other == "已经习惯去这家医院" ///
							| q16_other == "长期调理" ///
							| q16_other == "全家人都在这家机构打疫苗" ///
							| q16_other == "长期看病的地方"
replace q16_other = "信任医院" if q16_other == "习惯了"
replace q16_other = "信任医院" if q16_other == "公立医院"
*听录音能否这样归类
replace q16_other="综合原因" if q16_other == "三甲医院.距离近可以报销等综合因素" ///
                            | q16_other == "就是综合方面比较好" ///
							| q16_other == "医疗资源好" ///
							| q16_other == "医疗有保障" ///
							| q16_other == "医疗条件好" ///
							| q16_other == "环境好" ///

label variable q17 "Q17.Overall respondent's rating of the quality received in this facility"
replace q17=.a if q13==0 //due to Q13 skip (responded have usual care facility)
rename q18code q18_code
label variable q18_code "q18. Healthcare visits in made in the past 12 months(1=yes;998-dont know)"

rename q18value q18_value
label variable q18_value "q18. How many healthcare visits in total have you made in the past 12 months? "
replace q18_value=998 if q18_code==998
drop q18_code
rename q18_value q18 //delete q18_code and rename q18_value, only keep variable q18

label variable q19 "Q19.Total number of healthcare visits in the past 12 months choice(range)"
replace q19 =.a if q18!=998 //ASK IF Q18=998

**# Bookmark #7 此处有问题，按照询问条件替换之后，q20就没有值了
label variable q20 "Q20. You said you made * visits. Were they all to the same facility?"
replace q20 =.a if  q20 == . //(ASK IF Q18>1 VISIT OR Q19=2,3,4; HAD AT LEAST TWO VISITS IN THE PAST 12 MONTHS)
replace q20 =.a if q19==2 | q19==3| q19==4

label variable q21code "q21. How many different healthcare facilities did you go to in total?"
rename q21code q21_code
label variable q21value "q21. number of different healthcare facilities went in total?"
rename q21value q21_value
replace q21_value = 998 if q21_code == 998
replace q21_value =. a if q21_value == . //ASK IF Q20 = 0
drop q21_code
ren q21_value q21

label variable q22code "Q22. How many visits did you have with a healthcare provider at your home?"
rename q22code q22_code
rename q22value q22_value
label variable q22_value "Q22. Times of home visits."
replace q22_value=998 if q22_code==998
ren q22_value q22
drop q22_code

label variable q23code "Q23. How many virtual or telemedicine visits did you have in the past 12 months?"
rename q23code q23_code
rename q23value q23_value
label variable q23_value "Q23. Times of virtual or telemedicine visits."
replace q23_value=998 if q23_code==998
ren q23_value q23
drop q23_code

label variable q24 "Q24.What was the main reason for the virtual or telemedicine visit?"
replace q24=.a if q24==.  // ASK IF Q23>0 VISITS & q23!=0
label variable q24other "q24.other reasons of virtual or telemedicine visit."
rename q24other q24_other
replace q24 = 1 if q24_other == "体检后，发现有问题去检查。"
list q24_other if q24_other == "体检后，发现有问题去检查。"
replace q24_other = "" in 526 //526 is the result of "list"
replace q24 = 1 if q24_other == "无明确病症，健康咨询"
list q24_other if q24_other == "无明确病症，健康咨询"
replace q24_other = "" in 947 //947 is the result of "list"
replace q24 = 1 if q24_other == "就是开药"
list q24_other if q24_other == "就是开药"
replace q24_other = "" in 2045 //2045 is the result of "list"
replace q24 = 1 if q24_other == "用药咨询"
list q24_other if q24_other == "用药咨询"
replace q24_other = "" in 1679 //1679 is the result of "list"

label variable q25 "Q25. How would you rate the overall quality of your last telemedicine visit?"
replace q25=.a if q23==0 | q23==998 //ask if q23>0 & q23!=998 (ASK IF Q23>0 VISITS)

label variable q26 "Q26.Stayed overnight at a facility in past 12 months (inpatient care)
label variable q27a "Q27.a Blood pressure tested in the past 12 months"
label variable q27b "Q27.b Breast examination"
label variable q27bi "Q27.b.i Breast colour ultrasound (B-ultrasound)"
label variable q27bii "Q27b ii. received a mammogram (a special X-ray of the breast)"
label variable q27c "Q27c. received cervical cancer screening, like a pap test or visual inspection"
rename q27a q27_a
rename q27b q27_b
rename q27bi q27_bi
rename q27bii q27_bii
rename q27c q27_c
rename q27d q27_d
label variable q27_d "Q27d. Had your eyes or vision checked in the past 12 months"
rename q27e q27_e
label variable q27_e "Q27e. Had your teeth checked in the past 12 months"
label variable q27f "q27.f Had a blood sugar test in the past 12 months"
rename q27f q27_f
label variable q27g "q27.g Had a blood cholesterol test in the past 12 months"
rename q27g q27_g
label variable q27h "Q27.h Received care for depression, anxiety, or another mental health condition"
rename q27h q27_h
label variable q28a "Q28.a A medical mistake was made in your treatment or care in the past 12 months"
rename q28a q28_a
replace q28_a=.a if q28_a!=0 & q28_a!=1 
//check the skip patterns///count if q18>0 & q18!=998 |q19==2|q19==3|q19==4
//ASK IF Q18>0 VISITS OR Q19=2,3,4; HAD AT LEAST ONE VISIT IN THE PAST 12 MONTHS
label variable q28b "Q28b. been treated unfairly or discriminated against by a doctor, nurse, or..."
rename q28b q28_b
replace q28_b =.a if q28_b!=0 & q28_b!=1 
//check the skip patterns///count if q18>0 &q18!=998 |q19==2|q19==3|q19==4
//ASK IF Q18>0 VISITS OR Q19=2,3,4; HAD AT LEAST ONE VISIT IN THE PAST 12 MONTHS

label variable q29 "Q29. Have you needed medical attention but you did not get it in past 12 months?"
label variable q30 "Q30. The last time this happened, what was the main reason?"
replace q30=.a if q29!=1 
//ask if Q29=1

label variable q30other "Q30. other"
rename q30other q30_other
replace q30 = 1 if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"
list q30_other if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"
replace q30_other = "" if q30_other == "医保不能报销"  ///
	| q30_other == "异地报销，不给报销"  ///
	| q30_other == "没法报销医保" ///
	| q30_other == "不报销"	
	
replace q30=3 if q30_other=="不好挂号"  ///
	 | q30_other == "人员满了，没排上号"  ///
	 | q30_other == "人太多，医生太少了"  ///
	 | q30_other == "医护人员不足"  ///
	 | q30_other == "医院人满为患，排不了队了" | ///
     | q30_other == "挂不上号" ///
	 | q30_other == "排不上号"  ///
	 | q30_other == "没挂上号。"  ///
	 | q30_other == "没有挂到号"  
replace q30_other = "" if q30_other == "不好挂号"  ///
	 | q30_other == "人员满了，没排上号"  ///
	 | q30_other == "人太多，医生太少了"  ///
	 | q30_other == "医护人员不足"  ///
	 | q30_other == "医院人满为患，排不了队了" | ///
     | q30_other == "挂不上号" ///
	 | q30_other == "排不上号"  ///
	 | q30_other == "没挂上号。"  ///
	 | q30_other == "没有挂到号"  
replace q30 = 7 if q30_other == "自己在家吃药"
replace q30_other = "" if q30_other == "自己在家吃药"
replace q30_other = "COVID (COVID restritions or COVID fear)" if q30_other == "因为新冠疫情，医院科室停诊" ///
      | q30_other == "因为新冠的时候出不去。" ///
	  | q30_other == "新冠期间" ///
	  | q30_other == "新冠期间，就诊比较困难。"  ///
	  | q30_other == "新冠肺炎" ///
	  | q30_other == "疫情期间医护人员不够" ///
      | q30_other == "疫情期间，医院不接诊，需要转移到别的医院" ///
      | q30_other == "隔离。" 
replace q30_other = "没有时间" if q30_other == "工作原因" ///
      | q30_other == "没时间" ///
	  | q30_other == "工作忙。" ///
	  | q30_other == "没有时间去" ///
	  | q30_other == "家里走不开。"
	  
rename q31a q31_a
label variable q31_a "Q31.a Have you ever needed to borrow money to pay for healthcare"
rename q31b q31_b
label variable q31_b "Q31.b Sell items to pay for healthcare"

label variable q32 "Q32. Last visit facility type public/private/social security/NGO/faith-based? "
replace q32=.a if q32==.
///ASK IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4
rename q32other q32_other
label variable q32_other "q32. other last visit facility type"
replace q32_other = "不知道" if q32_other == "不知道。" ///
	  | q32_other == "没记住。"  ///
	  | q32_other == "单位固定医疗机构体检"  ///
	  | q32_other == "农村的诊所，不知道是公立还是私立" 
replace q32 = 2 if q32_other == "国际"
replace q32_other = "" if q32_other == "国际"
replace q32_other = ".d" if q32_other == "不知道"

label variable q33 "Q33. What type of healthcare facility is this?(last visit)"
replace q33 = .a if q33 == .	//ASK IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4
rename q33other q33_other
label variable q33_other "Q33. other type of healthcare facility (last visit)"
replace q33_other = "不知道" if q33_other == "不清楚" ///
                | q33_other == "不清楚。" /// 
				| q33_other=="忘记了。" ///
				|q33_other=="私人医院不清楚" 
replace q33_other = "体检机构" if q33_other == "不知道名字，就是一个体检机构" ///
                | q33_other == "体检中心" /// 
				| q33_other=="体检医院" ///
				| q33_other=="公司的体检中心" /// 
				| q33_other=="和谐健康体检中心" ///
				| q33_other=="实名体检中心" ///
				| q33_other=="美兆体检中心" 
replace q33_other = "妇幼保健医院" if q33_other == "天门市妇幼保健院" ///
                | q33_other == "妇幼保健院" 
replace q33 = 1 if q33_other == "中西结合医院" | q33_other == "工人医院"
replace q33_other = "" if q33_other == "中西结合医院" | q33_other == "工人医院"

label variable q34 "Q34. What was the main reason you went?"
replace q34=.a if q34==.
///ASK IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4
rename q34other q34_other
label variable q34_other "Q34. other reasons"
replace q34 = 1 if q34_other == "内分泌不调" ///
	| q34_other == "去医院做手术"  ///
	| q34_other == "囊肿"  ///
	| q34_other == "拔牙"  ///
	| q34_other == "消化不良"  ///
	| q34_other == "看牙"  ///
	| q34_other == "箍牙"  ///
	| q34_other == "补牙"  ///
	| q34_other == "补牙齿"  ///
	| q34_other == "没事儿干，去医院溜达。我也不知道啥原因了，感觉有点疼，B超，ct,检查后，医生说没什么问题。"  ///
	| q34_other == "配假牙"
replace q34_other = ""  if q34_other == "内分泌不调" ///
	| q34_other == "去医院做手术"  ///
	| q34_other == "囊肿"  ///
	| q34_other == "拔牙"  ///
	| q34_other == "消化不良"  ///
	| q34_other == "看牙"  ///
	| q34_other == "箍牙"  ///
	| q34_other == "补牙"  ///
	| q34_other == "补牙齿" ///
	| q34_other == "没事儿干，去医院溜达。我也不知道啥原因了，感觉有点疼，B超，ct,检查后，医生说没什么问题。"  ///
	| q34_other == "配假牙"
replace q34 = 2 if q34_other == "调理身体"
replace q34_other = "" if q34_other == "调理身体"
replace q34_other = "生孩子"  if q34_other == "生产" | ///
	q34_other == "生孩子去的" | ///
	q34_other == "生小孩" 
replace q34_other=".d" if q34_other=="不清楚" ///
      | q34_other=="不知道" ///
	  | q34_other=="我也不知道，搞不懂"	
	
label variable q35 "Q35. Was this a scheduled visit or did you go to the facility without an appt."
replace q35=.a if q35==.
label variable q36 "Q36. How long did you wait between scheduling the appt. and seeing the provider?"
replace q36=.a if q35!=1 //ASK IF Q35=1
label variable q37 "Q37. Once you arrived at the facility, how long did you wait?"
replace q37=.a if q37==. //ASK IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4
label variable q37other "Q37. specify"
rename q37other q37_specify
replace q37=.r if q37_specify=="不清楚"
replace q37_specify = "" in 2259
replace q37_specify = "24" if q37_specify == "第二天"
replace q37_specify = "5" if q37_specify == "4-5小时内"
replace q37_specify = "48" if q37_specify == "48小时" |  q37_specify = "两天"
replace q37_specify = "9" if q37_specify == "9小时"
destring q37_specify, replace
label variable q37_specify "Q37. specify (hours)" //ASK Q38a_k IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4
label variable q38a "Q38a. the overall quality of care you received"
rename q38a q38_a
replace q38_a=.a if q38_a==.
label variable q38b "Q38b. the knowledge and skills of your provider"
rename q38b q38_b
replace q38_b=.a if q38_b==.
label variable q38c "Q38c. the equipment and supplies that the provider had available."
rename q38c q38_c
replace q38_c=.a if q38_c==.
label variable q38d "Q38d. the level of respect your provider showed you."
rename q38d q38_d
replace q38_d=.a if q38_d==.
label variable q38e "Q38e. whether your provider knew about your prior visits and test results."
rename q38e q38_e
replace q38_e=.a if q38_e==.
label variable q38f "Q38f. whether your provider explained things in a way you could understand"
rename q38f q38_f
replace q38_f=.a if q38_f==.
label variable q38g "Q38g. whether your provider involved you as much as you wanted to be in decision"
rename q38g q38_g
replace q38_g=.a if q38_g==.
label variable q38h "Q38h. the amount of time your provider spent with you"
rename q38h q38_h
replace q38_h=.a if q38_h==.
label variable q38i "Q38i. the amount of time you waited before being seen"
rename q38i q38_i
replace q38_i=.a if q38_i==.
label variable q38j "Q38j. the courtesy & helpfulness of the facility staff, other than provider "
rename q38j q38_j
replace q38_j=.a if q38_j==.
rename q38k q38_k
label variable q38k "Q38k. how long it took for you to get this appt."
drop q39code
ren q39value q39
label variable q39 "q39. likely to recommendation to  friends?"
replace q39=.a if q39==. //ASK IF Q18>0 VISITS OR Q19=2,3,4//count if q18>0 & q18!=998 | q19==2 | q19==3 |q19==4

rename q40a q40_a
label variable q40_a "Q40a. rate quality of care for pregnant women(antenatal/prental)"
rename q40b q40_b
label variable q40_b "Q40b. rate care for children, like well-child care and care for sick children"
rename q40c q40_c
label variable q40_c "Q40c. rate care for ongoing or chronic conditions, like hypertension or diabetes"
rename q40d q40_d
label variable q40_d "Q40d. rate care for mental health conditions, like depression or anxiety"

rename q41a q41_a
label variable q41_a "Q41a. How confident r u that y`d get good quality healthcare if u r very sick"
rename q41b q41_b
label variable q41_b "Q41.b How confident are you that you'd be able to afford the care you required?"
rename q41c q41_c
label variable q41_c "Q41.c How confident are you that the government considers the public's opinion?"

label variable q42 "Q42. How would you rate the quality of public healthcare system in your country?"
label variable q43 "Q43. How would you rate the quality of the private for-profit healthcare system "
note: q44 NA in China
gen q44=.
label variable q45 "Q45. Would you say your country's health sys is getting better/same/worse"
label variable q46 "Q46. Which of these statements do you agree with the most?"
label variable q47 "Q47. How would you rate the government's management of the COVID-19 pandemic?"
label variable q48 "Q48. How would you rate the quality of care provided? (Vignette, option 1)"
label variable q49 "Q49. How would you rate the quality of care provided? (Vignette, option 2)"
label variable q50 "Q50. What is your native language or mother tongue?"
label variable q50other "q50. other languages"
rename q50other q50_other
label variable q51a "Q51a.  (only China)What is the number of people in the household?"
replace q50_other = "蒙古族" if q50_other == "蒙族" | q50_other == "蒙古"
replace q50_other = "维吾尔族" if q50_other == "新疆维吾尔族"
replace q50 = 1 if q50_other == "闽南语"
replace q50_other = "" if q50_other == "闽南语"
rename q51a q51_a
label variable q51b "Q51b. Total monthly household income"
rename q51b q51_b
label variable CELL1 "CELL1. Do you have another mobile phone number besides the one I am calling. "
label variable CELL2 "CELL2. How many other mobile phone numbers do you have?"
rename huifang retest
label variable retest "retest after two weeks"
rename country Country
label variable int_length "Interview length"

*language data collection did in Chinese ony, which is the offical langue in China, people can communicate with Chiese"
gen language = .
replace language = 21001
lab def lang 21001 "CN: Chinese"
lab values language lang


order q*, sequential

*-----------------------------recode-----------------------------------*
rename Country country
gen reccountry = 21
lab def country 21 "CN"
lab values reccountry country 

recode q2 (0 = 0 "under 18") ///
          (1 = 1 "18-29") ///
		  (2 = 2 "30-39") ///
		  (3 = 3 "40-49") ///
		  (4 = 4 "50-59") ///
		  (5 = 5 "60-69") ///
		  (6 = 6 "70-79") ///
		  (7 = 7 ">80") ///
		  (999 = .r "refused"), gen(recq2)
recode q16 (1 = 1 "Low cost") ///
           (2 = 2 "Short distance") ///
		   (3 = 3 "Short waiting time") ///
		   (4 = 4 "Good healthcare provider skills") ///
		   (5 = 5 "Staff shows respect") ///
		   (6 = 6 "Medicines and equipment are available") ///
		   (7 = 7 "Only facility available") ///
		   (8 = 8 "Covered by insurance") ///
		   (9 = 9 "Other, specify"), gen(recq16)
recode q30 (1 = 1 "High cost (e.g., high out of pocket payment, not covered by insurance)") ///
           (2 = 2 "Far distance (e.g., too far to walk or drive, transport not readily available)") ///
		   (3 = 3 "Long waiting time (e.g., long line to access facility, long wait for the provider)") ///
		   (4 = 4 "Poor healthcare provider skills (e.g., spent too little time with patient, did not conduct a thorough exam)") ///
		   (5 = 5 "Staff didn't show respect (e.g., staff is rude, impolite, dismissive)") ///
		   (6 = 6 "Medicines and equipment are not available (e.g., medicines regularly out of stock, equipment like X-ray machines broken or unavailable)") ///
		   (7 = 7 "Illness not serious enough") ///
		   (8 = 8 "Other, specify") ///
		   (999 = .r "Refused"), gen(recq30)

recode q34 (1 = 1 "Care for an urgent or new health problem") ///
		   (2 = 2 "Follow-up care for a longstanding illness or chronic disease") ///
		   (3 = 3 "Preventive care or a visit to check on your health") ///
		   (4 = 4 "Other,specify") ///
		   (999 = .r "Refused"), gen(recq34)
		   
gen recq4 = reccountry*1000 + q4		  
label define recq4 21001 "CN:安徽省" 21002"CN:北京市" 21003"CN:福建省" 21004"CN:甘肃省" 21005"CN:广东省" 21006"CN:广西壮族自治区" ///
                     21007 "CN:贵州省" 21008"CN:海南省" 21009"CN:河北省" 21010"CN:河南省" 21011"CN:黑龙江省" 21012"CN:湖北省" ///
					21013 "CN:湖南省" 21014"CN:吉林省" 21015"CN:江苏省" 21016"CN:江西省" 21017"CN:辽宁省" 21018"CN:内蒙古自治区" ///
					21019 "CN:宁夏回族自治区" 21020"青海省" 21021"CN:山东省" 21022"CN:山西省" 21023"CN:陕西省" 21024"CN:上海市" ///
					21025 "CN:四川省" 21026"CN:天津市" 21027"CN:西藏自治区" 21028"CN:新疆维吾尔自治区" 21029"CN:云南省" ///
					21030 "CN:浙江省" 21031"CN:重庆市"
label values recq4 recq4	
//this approach is the same as for q2 & q16 and the following
//V1.0 q5 changed to q4 in V2.0
	   
recode q5 (1 = 21001 "CN:City") ///
          (2 = 21002 "CN:Suburb of city") ///
		  (3 = 21003 "CN:Small town") ///
		  (4 = 21004 "CN:Rural area") ///
		  (9 = 999 "Refused"), gen(recq5)
replace recq5 = .r if q5 == 999 
//V2.0 .r==999，V1.0 q4 changed to q5 in V2.0	  
		  
recode q8 (1 = 21001 "CN:No formal education (illiterate)") ///
          (2 = 21002 "CN:Did not finish primary school") ///
		  (3 = 21003 "CN:Elementary school") ///
		  (4 = 21004 "CN:Middle school") ///
		  (5 = 21005 "CN:High school") ///
		  (6 = 21006 "CN:Vocational school") ///
		  (7 = 21007 "CN:Two-/Three-Year College/Associate degree") ///
		  (8 = 21008 "CN:Four-Year College/Bachelor's degree") ///
		  (9 = 21009 "CN:Master's degree") ///
		  (10 = 21010	"CN:Doctoral degree/Ph.D.") ///
		  (999 = .r "Refused"), gen (recq8)
recode q15 (1 = 21001 "CN:General hospital (Not including traditional chinese medicine hospital)") ///
           (2 = 21002 "CN:Specialized hospital (Not including traditional chinese medicine hospital") ///
		   (3 = 21003 "CN:Chinese medicine hospital") ///  
		   (4 = 21004 "CN:Community healthcare center") ///  
		   (5 = 21005 "CN:Township hospital") ///  
		   (6 = 21006 "CN:Health care post") ///  
		   (7 = 21007 "CN:Village clinic/Private clinic") ///  
		   (8 = 21008 "CN:Other") ///
		   (999 = .r "Refused"), gen(recq15)
recode q33 (1 = 21001 "CN:General hospital (Not including traditional chinese medicine hospital)") ///
           (2 = 21002 "CN:Specialized hospital (Not including traditional chinese medicine hospital") ///
		   (3 = 21003 "CN:Chinese medicine hospital") ///  
		   (4 = 21004 "CN:Community healthcare center") ///  
		   (5 = 21005 "CN:Township hospital") ///  
		   (6 = 21006 "CN:Health care post") ///  
		   (7 = 21007 "CN:Village clinic/Private clinic") ///  
		   (8 = 21008 "CN:Other") ///
		   (999 = .r "Refused"), gen(recq33)
recode q50 (1 = 210001 "CN:Mandarin Chinese") ///
           (2 = 210002 "CN:other languages") ///
		   (999 = .r "Refused"), gen(recq50)
recode q51 (1 = 21001 "CN:<700") ///
           (2 = 21002 "CN:700-1499") ///
		   (3 = 21003 "CN:1500-2499") ///  
		   (4 = 21004 "CN:2500-3999") ///  
		   (5 = 21005 "CN:4000-6999") ///  
		   (6 = 21006 "CN:>=7000") /// 
           (999 = .r "Refused"), gen(recq51)
/* -------------gen rec variable for variables that have overlap values to be country code * 1000 + variable ---------------
-------------replace the value to .r if the original one is "Refused" or 996 in V1.0-------------------------------------
-----------this part is used in V1.0 to recode q5 q4 q8 q15 q33 q50 q51, equal to the foreach command used for V1.0
gen recq4 = reccountry*1000 + q4
replace recq4 = .r if q4 == 999
//V1.0 "Q5. County, state, region where respondent lives"，Shalom赋值,region中国用省份在省市编码中有各省编码替换q4成为CHN:Gansu？)

gen recq5 = reccountry*1000 + q5 
replace recq5 = .r if q5 == 999
// V1.0 Q4, V2.0 Q5

gen recq8 = reccountry*1000 + q8
replace recq8 = .r if q8 == 999
//q8 is the same in both V1.0 & V2.0
	
gen recq15 = reccountry*1000 + q15
replace recq15 = .r if q20 == 999
replace recq15 = .a if q15 == .a
//V1.0 Q20. What type of healthcare facility is this?" change to q15 in V2.0


gen recq33 = reccountry*1000 + q33
replace recq33 = .r if q33 == 999
replace recq33 = .a if q33 == .a
//V1.0 Q44. What type of healthcare facility is this?" changed to q33 in V2.0

									
gen recq50 = reccountry*1000 + q50
replace recq50 = .r if q50== 999
//V1.0 Q62. Respondent's mother tongue or native language, changed to q50 in V2.O
 
rename q51_b q51
gen recq51 = reccountry*1000 + q51
replace recq51 = .r if q51 == 999
//V1.0 Q63. Total monthly household income. V2.0 q51


label define labels9 1 "City" 2 "Suburb of city" 3 "Small town" 4 "Rural area" 999 "Refused" 
label define recq8  1 "No formal education (illiterate)" 2 "Did not finish primary school" 3 "Elementary school" 4 "Middle school" 5"High school" 6 "Vocational school" 7 "Two-/Three-Year College/Associate degree" 8 "Four-Year College/Bachelor's degree" 9 "Master's degree" 10 "Doctoral degree/Ph.D." 999 "refused"
label define labels23 1"General hospital (Not including TCM hospital" 2 "Specialized hospital (Not including TCM hospital)" 3"Chinese medicine hospital" 4"Community healthcare center" 5"Township hospital" 6 "Health care post" 7"Village clinic/Private clinic" 8 "Other" 999 "Refused"
label define labels53 1 "Mandarin" 2 "others" 999 "Refused"
label define labels54 1 "<700" 2 "700-1499" 3 "1500-2499" 4 "2500-3999" 4 "4000-6999" 5 ">=7000"

local q5l labels8
local q4l labels9
local q8l labels12
local q15l labels23
local q33l labels23
local q50l labels53
local q51l labels54

foreach q in q5 q4 q8 q15 q33 q50 q51{
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

	forvalues i = 1/``q'n' {
		local recvalue`q' = 21000+`: word `i' of ``q'val''
		foreach lev in ``q'level'{
			if strmatch("`lev'", "`recvalue`q''") == 1{
				elabel define `q'_label (= 21000+`: word `i' of ``q'val'') ///
									    (`"CN: `gr`i''"'), modify			
			}	
		}                 
	}

	
	label val rec`q' `q'_label
}

label define q4_label .a "NA" .r "Refused" , modify
label define q5_label .a "NA" .r "Refused" , modify
label define q8_label .a "NA" .r "Refused" , modify
label define q15_label .a "NA" .r "Refused" , modify
label define q33_label .a "NA" .r "Refused" , modify
label define q50_label .a "NA" .r "Refused" , modify
label define q51_label .a "NA" .r "Refused" , modify
*/

   		   
*----------------------------Fix time variables-----------------------------------------*
generate recdate = dofc(date)
format recdate %td

*----------------CN country = 21, country_reg = 12----------------*
*Note: .a means NA, .r means refused, .d is don't know, . is missing 

order q*, sequential
order respondent_id date int_length mode weight weight_educ //dropped country and lang

order q*, sequential
rename ID respondent_id
label variable respondent_id "Respondent ID (unique ID)"
gen mode = "CATI"
*gen weight=. (需要计算和赋值)
*gen weight_educ=.(需要计算和赋值)

order respondent_id date int_length mode weight weight_educ

* add label for "Refused"

label define labels52 .r "Refused", add

*****************************

**** Combining/recoding some variables ****

**recode q46_refused (. = 0) if q46 != .
** no q36_refused in CN data
recode q47_refused (. = 0) if q47 != .
** Q47: Dropped in V2.0 (time spent with provider).
* no q46b_refused in CN data (V1.0 Q46b changed to q36 in V2.0 )
recode q36 (999 = .r)
*recode q36_refused (. = 0) if q36b != .
* no q36_refused in CN data (V1.0 Q46b changed to q36 in V2.0 )
*------------------------------------------------------------------------------*

**# drop later on
* Drop unused variables 

drop respondent_id ecs_id time_new intlength q2 q4 q5 q8 q20 q21 q45 q42 q44 q46 q47 q62 q63 q66 rim_age rim_gender rim_region rim_eduction dw_overall interviewer_id interviewer_gender interviewer_language language // q46b

*------------------------------------------------------------------------------*

* Generate variables 
gen respondent_id_cn = "CN" + respondent_id
drop respondent_id
rename respondent_id_cn respondent_id
label variable respondent_id "respondent ID"


* Q18/Q19 mid-point var ////ask shalom 996换成999，997换成998，最后一个997换成997不符合逻辑？
gen q18_q19 = q18 
recode q18_q19 (999 = 0) (998 = 0) if q19 == 1
recode q18_q19 (999 = 2.5) (998 = 2.5) if q19 == 2
recode q18_q19 (999 = 7) (998 = 7) if q19 == 3
recode q18_q19 (999 = 10) (998 = 10) if q19 == 4
recode q18_q19 (998 = .r) if q19 == 999

*Q7 V1.0 Q7=V2.0 Q7-insurance
gen recq7 = reccountry*1000 + q7
replace recq7 = .a if q7 == .a
replace recq7 = .r if q7 == 999
label def q7_label 21001 "CN:Urban employee medical insurance" ///
                   21002 "CN:Urban and rural resident medical insurance (integrated urban resident medical insurance and new rural cooperative medical insurance)" ///
				   21003 "CN:Government medical insurance" ///
				   21004 "CN:Private medical insurance" ///
				   21005 "CN:Long-term care insurance" ///
				   21006 "CN:Other" .a "NA" .r "Refused"
label values recq7 q7_label
*drop q7 
///will drop all variables later on最后drop不用的变量

*------------------------------------------------------------------------------*

* Recode refused and don't know values 
recode q18 q21 q22 q23 (998 = .d)

recode q27_c q27_d q27_f q27_g q27_h (998 = .d)

* In raw data, 999 = "refused" -change from V1.0 996 to 999 in V2.0 & all questions have 999	  
recode q2 recq2 q3 q4 recq4 q5 recq5 q6 q7 recq7 q8 recq8 q9 q10 q11 q12_a q12_b ///
       q13 q14 q15 recq15 recq16 q17 q18 q19 q20 q21 q22 q23 q24 q25 q26 q27_a ///
	   q27_b q27_bi q27_bii q27_c q27_d q27_e q27_f q27_g q27_h q28_a q28_b q29 ///
	   q30 recq30 q31_a q31_b q32 q33 recq33 q34 recq34 q35 q36 recq34 q37 q38_a ///
	   q38_b q38_c q38_d q38_e q38_f q38_g q38_h q38_i q38_j q38_k q39 q40_a q40_b ///
	   q40_c q40_d q41_a q41_b q41_c q42 q43 q45 q46 q47 q48 q49 q50 recq50 q51 ///
	   recq51 CELL1 CELL2 (999 = .r)
*------------------------------------------------------------------------------*
* Recode missing values to NA for questions respondents would not have been asked 
* due to skip patterns

*------------------------------------------------------------------------------*
	 
* Check for implausible values - review

* Q26, Q27 
list q18_q19 q21 if q21 > q18_q19 & q21 < . 
* Note: This is fine because 10 is a mid-pint value

list q20 q21 if q21 == 0 | q21 == 1
*OK

* Q28_a, Q28_b 
* list if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
egen visits_total = rowtotal(q18_q19 q22 q23)

* Recoding Q28_a and Q28_b to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
*list visits_total q28_a q28_b if q28_a == 3 & visits_total > 0 & visits_total < . /// 
							  | q28_b == 3 & visits_total > 0 & visits_total < .
*China data is OK

* Recoding Q28_a and Q28_b to refused if they say "I did not get healthcare in past 12 months" but they have visit values in past 12 months 
recode q28_a q28_b (3 = .r) if visits_total > 0 & visits_total < .
*no changes make to both						  

*********************************check q2 & Q29 & 18 & 19 skip *************				 
* List if missing for q28_a/q28_b but does have a visit
list visits_total q28_a q28_b if q28_a == .a & visits_total > 0 & visits_total < . /// 
						       | q28_b == .a & visits_total > 0 & visits_total < .
*Ok in data？？？？？？？？？							 		  
list visits_total q28_a q28_b if q28_a != 3 & visits_total == 0 /// 
						   | q28_b != 3 & visits_total == 0							  
* Recoding q28_a and q28_b to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (1 = 3) (2 = 3) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 214 changes made to q39, 218 changes made to q40
							  
* Recoding q28_a and q28_b to "I did not get healthcare in past 12 months" if they choose no but they have no visit values in past 12 months 
recode q28_a q28_b (.r = .a) if visits_total == 0 //recode no/yes to no visit if they said they had 0 visit in past 12 months
* total of 1 change to q39 and 0 changes to q40

drop visits_total
****************************************************************************************************************************
*------------------------------------------------------------------------------*
 
* Recode missing values to NA for intentionally skipped questions

*q1/q2 
recode q2 (. = .a) if q1 > 0 & q1 < . //change q2 missing to .a if q1 has an actual value, keep q2 be . if q1 == .
recode q1 (. = .r) if inrange(q2,2,8) | q2 == .r 

* q7 
recode recq7 (. = .a) if q6 == 2 | q6 == .r 
recode recq7 (nonmissing = .a) if q6 == 2


*q19-22
recode q14 recq15 recq16 q17(. = .a) if q13 == 2 | q13 == .r 
recode recq15 (. = .a) if q14 == 4 | q14 == .r
*0 changes made

* NA's for q19-21 
recode q19 (. = .a) if q18 != .d & q18 != .r 
*0 changes made to q19

recode q20 (. = .a) if q18 == 0 | q18 == 1 | q19 == 1 | q19 == .r 
recode q21 (. = .a) if q20 == 1 | q20 == .a | q20 == .r
*0 changes made

*q25
recode q25 (. = .a) if q23 == 0 | q23 == .d | q23 == .r
*0 changes made

* q27_bii & q27_c
recode q27_bii (. = .a) if q3 != 2 | q1 < 50 | inrange(q2,1,4) | q2 == .r 
recode q27_c (. = .a) if q3 != 2 | q2 == .r 

* q30
recode recq30 (. = .a) if q29 == 2 | q29 == .r
*0 changes made

* q43-49 na's  43=32 44=33 45=34 46=35 47=drop 48_a=38_a ...k 49=39
* There is one case where both q23 and q24 are missing, but they answered q43-49
recode q32 recq33 recq34 q35 q38_a q38_b q38_c q38_d q38_e q38_f /// recq46b
	   q38_g q38_h q38_i q38_j q38_k q39 (. = .a) if q18 == 0 | q19 == 1 | q19 == .r
	   
recode q32 recq33 recq34 q35 q38_a q38_b q38_c q38_d q38_e q38_f /// recq46b
	   q38_g q38_h q38_i q38_j q38_k q39 (nonmissing = .a) if q18 == 0 | q19 == 1
	      
recode recq33 (. = .a) if q32 == 4 | q32 == .r

recode recq34 (995 = 4)

recode q38_k (. = .a) if q35 == 2 | q35 == .r

*CELL2
recode CELL2 (. = .a) if CELL1 != 1

*q66/67-------------NO 66&67 IN V2.0
*recode q66 (. = .a) if mode == 2

*------------------------------------------------------------------------------*
* Recode values and value labels:
* Recode values and value labels so that their values and direction make sense

* All Yes/No questions

recode q11 q13 q20 q26 q29 /// 
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (.a = .a "NA"), ///
	   pre(rec) label(yes_no)

recode q27_a q27_b q27_bi q27_bii q27_c q27_d q27_e q27_f q27_g q27_h ///
	   (1 = 1 "Yes") (2 = 0 "No") (.r = .r "Refused") (3 .d = .d "Don't know") /// 
	   (.a = .a "NA"), ///
	   pre(rec) label(yes_no_dk)

recode q6 q28_a q28_b /// 
	   (1 = 1 "Yes") (2 = 0 "No") ///
	   (3 = .a "I did not get healthcare in past 12 months") ///
	   (.r = .r "Refused"), ///
	   pre(rec) label(yes_no_na)
	   
recode q35 ///
		(1 = 1 "Yes, the visit was scheduled, and I had an appointment") ///
		(2 = 0 " No, I did not have an appointment") ///
		(.a = .a "NA") ///
		(.r = .r "Refused"), pre(rec) label(yes_no_appt)
		
******************01302024*start from here qnumber changed*************
*All Excellent to Poor scales
* Please note that in Greece: "Neither bad nor good" was recoded to "Fair"

recode q9 q10 q25 q38_a q38_b q38_c q38_d q38_f q38_g q38_h q38_i q38_k q42 q43 q47 q48 q49 ///
	   (4 = 4 "Excellent") (3 = 3 "Very Good") (2 = 2 "Good") (1 = 1 "Fair") /// 
	   (0 = 0 "Poor") (.r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor)
	   
recode q17 ///
	   (4 = 4 "Excellent") (3 = 3 "Very Good") (2 = 2 "Good") (1 = 1 "Fair") (0 = 0 "Poor") /// 
	   (5 = .a "NA or I did not receive healthcare form this provider in the past 12 months") /// 
	   (.r = .r "Refused"), /// 
	   pre(rec) label(exc_pr_hlthcare)
	   
recode q38_e ///
	   (4 = 4 "Excellent") (3 = 3 "Very Good") (2= 2 "Good") (1 = 1 "Fair") /// 
	   (0 = 0 Poor) (6 = .a "NA or I have not had prior visits or tests") (.r = .r "Refused"), /// 
	   pre(rec) label(exc_pr_visits)
	 
recode q38_j ///
	   (4 = 4 "Excellent") (3 = 3 "Very Good") (2 = 2 "Good") (1 = 1 "Fair") /// 
	   (0 = 0 Poor) (6 = .a "NA or The clinic had no other staff") (.r = .r Refused), /// 
	   pre(rec) label(exc_poor_staff)
	   
recode q40_a q40_b q40_c q40_d ///
	   (4 = 4 "Excellent") (3 = 3 "Very Good") (2 = 2 "Good") (1 = 1 "Fair") /// 
	   (0 = 0 "Poor") (5 = .d "I am unable to judge") (.r = .r "Refused") ///
	   (.a = .a "NA"), /// 
	   pre(rec) label(exc_poor_judge)
//used "5 I am unable to judge" in raw data.
	   
* All Very Confident to Not at all Confident scales 
	   
recode q12_a q12_b q41_a q41_b q41_c ///
	   (3 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (1 = 1 "Not too confident") (0 = 0 "Not at all confident") /// 
	   (.r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(vc_nc)
	   
	   
recode q41_b q41_c ///
	   (3 = 3 "Very confident") (2 = 2 "Somewhat confident") /// 
	   (1 = 1 "Not too confident") (0 = 0 "Not at all confident") /// 
	   (.r = .r "Refused") (.a = .a "NA"), /// 
	   pre(rec) label(vc_nc)
   
* Miscellaneous questions with unique answer options
	   
recode q3 (0 = 0 "Male") (1 = 1 "Female") (2 = 2 "Another gender") (.r = .r "Refused"), pre(rec) label(gender)
****************************************************************************************
recode q19 ///
	(1 = 0 "0") (2 = 1 "1-4") (3 = 2 "5-9") (4 = 3 "10 or more") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(number_visits)

recode q39 ///1-11 or 1-10？？？？？？？？
	(0 = 0 "0") (1 = 1 "1") (2 = 2 "2") (3 = 3 "3") (4 = 4 "4") (5 = 5 "5") ///
	(6 = 6 "6") (7 = 7 "7") (8 = 8 "8") (9 = 9 "9") (10 = 10 "10") ///
	(.r = .r Refused) (.a = .a NA), ///
	pre(rec) label(prom_score)
//use V2.0 code sequence (1-10), V1.0 coded as 1-11
recode q45 ///
	(3 = 3 "Getting worse") (2 = 2 "Staying the same") (1 = 1 "Getting better") ///
	(.r = .r "Refused") , pre(rec) label(system_outlook)
//use V2.0 code sequence
	
*CELL1
recode CELL1 (1 = 1 "Yes") (2 = 0 "No / No other numbers") (.r = .r "Refused"), pre(rec) label(CELL1)

*NA/Refused/DK
	
lab def na_rf .a "NA" .r "Refused" .d "Don't know"
lab val q1 q23 q23_q24 q25_b q27 q28_a q28_b recq46 recq47 q66 na_rf // recq46b


******* Country-specific *******

label define labels22 .a "NA" .r "Refused" .d "Don't know",modify//from RO. Did at first stage 
*q7
*q8
*q15
*q27_b(breast examination (only China))
*q27_bi(color ultrasound mammography (only China))

*------------------------------------------------------------------------------*
*----------------------need to comfirm and compare before drop-----------------*
*------------------------------------------------------------------------------*
* Renaming variables 
* Rename variables to match question numbers in current survey---N*******************????????????????????

*drop date q3 q6 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q22 q24 q25_a ///
	 q26 q28_c q29 q41 q30 q31 q32 q33 q34 q35 q36 q37_ro q38 q39 q40 q41 q46a ///
	  q48_a q48_b q48_c q48_d q48_f q48_g q48_h q48_i q48_k ///
	 q54 q55 q59 q60 q61 q22 q48_e q48_j q49 q50_a ///
	 q50_b q50_c q50_d q51 q52 q53 q54 q55 q56_ro q57 q59 q60 q61 q64 weight
	 
*ren rec* *

*Reorder variables
*order q*, sequential

*------------------------------------------------------------------------------*

* Save data - need to futher check the code and drop variables will not use 

*------------------------------------------------------------------------------*



