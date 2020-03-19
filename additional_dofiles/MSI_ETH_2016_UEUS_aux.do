/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - ETH special cases                      ****


******************************************************************************************************/


	replace gtap_v10= 6 if gtap_v10==. & industry_orig==129
	replace gtap_v10= 49 if gtap_v10==. & industry_orig==4390
	replace gtap_v10= 52 if gtap_v10==. & industry_orig==4922
	replace gtap_v10= 62 if gtap_v10==. & industry_orig==8411
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==9820
	
	


