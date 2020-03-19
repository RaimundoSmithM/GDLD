/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Slovenia special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/
	
	replace gtap_v10 = 15 if gtap_v10==. & industry_orig==10
	replace gtap_v10 =18 if gtap_v10==. & industry_orig==11
	replace gtap_v10 =27 if gtap_v10==. & industry_orig==16
	replace gtap_v10 =29 if gtap_v10==. & industry_orig==19
	replace gtap_v10 =40 if gtap_v10==. & industry_orig==32
	replace gtap_v10 =55 if gtap_v10==. & industry_orig==73
	replace gtap_v10 =55 if gtap_v10==. & industry_orig==91	
     