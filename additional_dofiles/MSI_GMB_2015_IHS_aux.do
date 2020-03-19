/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Gambia special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/	
	
	replace gtap_v10 = 9 if industry_orig>=140 & industry_orig<170 & gtap_v10==.
	replace gtap_v10 = 10 if industry_orig==170 & gtap_v10==.
	replace gtap_v10 = 15 if industry_orig>=500 & industry_orig<600 & gtap_v10==.
	replace gtap_v10 = 18 if industry_orig>=800 & industry_orig<900 & gtap_v10==.
	replace gtap_v10 = 17 if industry_orig==910 & gtap_v10==.
	replace gtap_v10 = 17 if industry_orig==1071 & gtap_v10==.
	replace gtap_v10 = 27 if industry_orig>=1300 & industry_orig<1400 & gtap_v10==.
	replace gtap_v10 = 28 if industry_orig>=1400 & industry_orig<1500 & gtap_v10==.
	replace gtap_v10 = 29 if industry_orig>=1500 & industry_orig<1600 & gtap_v10==.
	replace gtap_v10 = 30 if industry_orig>=1600 & industry_orig<1800 & gtap_v10==.
	replace gtap_v10 = 31 if industry_orig>=1800 & industry_orig<1900 & gtap_v10==.
	replace gtap_v10 = 33 if industry_orig>=2000 & industry_orig<2100 & gtap_v10==.
	replace gtap_v10 = 36 if industry_orig>=2300 & industry_orig<2400 & gtap_v10==.
	replace gtap_v10 = 37 if industry_orig>=2300 & industry_orig<2400 & gtap_v10==.
	replace gtap_v10 = 38 if industry_orig>=2400 & industry_orig<2500 & gtap_v10==.
 	replace gtap_v10 = 39 if industry_orig>=2500 & industry_orig<2600 & gtap_v10==.
 	replace gtap_v10 = 39 if industry_orig>=2800 & industry_orig<2900 & gtap_v10==.
	replace gtap_v10 = 45 if industry_orig>=3100 & industry_orig<3300 & gtap_v10==.
	replace gtap_v10 = 42 if industry_orig>=3300 & industry_orig<3600 & gtap_v10==.
	replace gtap_v10 = 48 if industry_orig>=3600 & industry_orig<3700 & gtap_v10==.
	replace gtap_v10 = 61 if industry_orig>=5800 & industry_orig<5900 & gtap_v10==.
	replace gtap_v10 = 61 if industry_orig>=8000 & industry_orig<9000 & gtap_v10==.
	replace gtap_v10 = 61 if industry_orig>=9500 & industry_orig<10000 & gtap_v10==.
