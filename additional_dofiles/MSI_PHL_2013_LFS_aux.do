/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - Philippines special cases                   ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/	
	
	replace gtap_v10=4 if (industry_orig==117|industry_orig==118) & gtap_v10==.
	replace gtap_v10=15 if industry_orig>=324 & industry_orig<330 & gtap_v10==.
	replace gtap_v10=18 if industry_orig==722 & gtap_v10==.
	replace gtap_v10=8 if industry_orig>=150 & industry_orig<155 & gtap_v10==.
	replace gtap_v10=27 if industry_orig>=1419 & industry_orig<1440 & gtap_v10==.
	replace gtap_v10=30 if industry_orig>=1625 & industry_orig<=1628 & gtap_v10==.
	replace gtap_v10=40 if industry_orig>=2611 & industry_orig<=2620 & gtap_v10==.
	replace gtap_v10=52 if industry_orig==4932 & gtap_v10==.
	replace gtap_v10=61 if industry_orig>=8220 & industry_orig<8230 & gtap_v10==.
	replace gtap_v10=62 if industry_orig>=8530 & industry_orig<8550 & gtap_v10==.
	replace gtap_v10=63 if industry_orig>=8610 & industry_orig<8615 & gtap_v10==.
	replace gtap_v10=61 if industry_orig==9610 & gtap_v10==.
	replace gtap_v10=61 if industry_orig==9621 & gtap_v10==.
	replace gtap_v10=61 if industry_orig==9640 & gtap_v10==.
