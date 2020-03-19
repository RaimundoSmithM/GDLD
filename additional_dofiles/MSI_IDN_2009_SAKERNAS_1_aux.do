/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Indonesia special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/	

	replace gtap_v10 = 8 if industry_orig ==130 & gtap_v10==.
	replace gtap_v10 = 13 if industry_orig >=200 & industry_orig<210 & gtap_v10==.
	replace gtap_v10 = 14 if industry_orig >=500 & industry_orig<510 & gtap_v10==.
	replace gtap_v10 = 28 if industry_orig ==1740 & gtap_v10==.
	replace gtap_v10 = 36 if industry_orig >=2600 & industry_orig<2660 &gtap_v10==.
	replace gtap_v10 = 28 if industry_orig ==2690 & gtap_v10==.
	replace gtap_v10 = 33 if industry_orig ==2512 & gtap_v10==.
	replace gtap_v10 = 50 if industry_orig >=5330 & industry_orig<=5390 & gtap_v10==.
	replace gtap_v10 = 50 if industry_orig >=5400 & industry_orig<=5500 & gtap_v10==.
	