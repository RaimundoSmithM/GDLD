/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - HUN special cases                      ****


******************************************************************************************************/


	replace gtap_v10= 45 if gtap_v10==. & industry_orig==19
	replace gtap_v10= 34 if gtap_v10==. & industry_orig==21
	replace gtap_v10= 45 if gtap_v10==. & industry_orig==34
	replace gtap_v10= 43 if gtap_v10==. & industry_orig==36
	replace gtap_v10= 45 if gtap_v10==. & industry_orig==37
	replace gtap_v10= 52 if gtap_v10==. & industry_orig==60
	replace gtap_v10= 52 if gtap_v10==. & industry_orig==61
	replace gtap_v10= 57 if gtap_v10==. & industry_orig==67
	replace gtap_v10= 57 if gtap_v10==. & industry_orig==74	
	replace gtap_v10= 62 if gtap_v10==. & industry_orig==75
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==80
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==92		
	
** Not assigned:     40 - public utilities; 41 - public utilities ; 50 - commerce; 55 - commerce


