/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - THA special cases                      ****


******************************************************************************************************/


	replace gtap_v10= 50 if gtap_v10==. & industry_orig > 4711 & industry_orig < 4800
	replace gtap_v10= 57 if gtap_v10==. & industry_orig==6419
	replace gtap_v10= 59 if gtap_v10==. & industry_orig==6810
	replace gtap_v10= 59 if gtap_v10==. & industry_orig==6820
	replace gtap_v10= 60 if gtap_v10==. & industry_orig==8121
	replace gtap_v10= 60 if gtap_v10==. & industry_orig==8129
	
	
	

