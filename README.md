# People's Voice Survey (PVS) Data Processing Code
Neena R Kapoor, Shalom Sabwa, Mia Yu

**This repository contains the .do files used to process and analyze data from the People's Voice Survey.** 

## About the survey: 
The People’s Voice Survey is a new instrument to integrate people’s voices into health system measurement, with a focus on population health needs and expectations as well as people’s perspectives on processes of care and confidence in the health system. It enables a rapid assessment of health system performance from the population perspective to inform health system planning.

## Countries: 
Currently, the PVS has been conducted in 14 countries: Argentina (Mendoza province), Colombia, Ethiopia,, Italy, India, Kenya, Lao People’s Democratic Republic, Mexico, Peru, South Africa, Republic of Korea, United States, Uruguay and United Kingdom. 

## Files in this repository: 
The "mainPVS.do" file sets globals and runs all .do files for data cleaning and preparation. Each country-specific creation file (crPVS_cln_AR.do, crPVS_cln_BR.do, etc.) cleans PVS country data in preparation for appending these datasets. The "crPVS_append.do" file appends all country-specific datasets into one mult-country dataset for analysis. The "crPVS_der.do" file creates derived varaibles for analysis. The "anPVS_mtbl.do" file creates weighted descriptive tables from these data. 
