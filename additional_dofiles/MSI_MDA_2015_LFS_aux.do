/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - Moldova special cases                      ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/


	replace gtap_v10 =26 if gtap_v10==. & industry_orig==12
	replace gtap_v10 =32 if gtap_v10==. & industry_orig==19
	replace gtap_v10 =34 if gtap_v10==. & industry_orig==21
	replace gtap_v10 =48 if gtap_v10==. & industry_orig==36
	replace gtap_v10 =48 if gtap_v10==. & industry_orig==37
	replace gtap_v10 =49 if gtap_v10==. & industry_orig==41
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==53
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==60
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==61
	replace gtap_v10 =60 if gtap_v10==. & industry_orig==69
	replace gtap_v10 =60 if gtap_v10==. & industry_orig==74
	replace gtap_v10 =60 if gtap_v10==. & industry_orig==75
	replace gtap_v10 =60 if gtap_v10==. & industry_orig==80
	replace gtap_v10 =64 if gtap_v10==. & industry_orig==87
	replace gtap_v10 =61 if gtap_v10==. & industry_orig==92
	replace gtap_v10 =61 if gtap_v10==. & industry_orig==97
	replace gtap_v10 =62 if gtap_v10==. & industry_orig==99

  


