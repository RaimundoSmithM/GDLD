/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - Kosovo special cases                      ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

	replace gtap_v10 = 8 if gtap_v10==. & industry_orig==1
	replace gtap_v10 =15 if gtap_v10==. & industry_orig==5
	replace gtap_v10 =16 if gtap_v10==. & industry_orig==6
	replace gtap_v10 =18 if gtap_v10==. & industry_orig==7
	replace gtap_v10 =18 if gtap_v10==. & industry_orig==8
	replace gtap_v10 =18 if gtap_v10==. & industry_orig==9
	replace gtap_v10 =25 if gtap_v10==. & industry_orig==10
	replace gtap_v10 =26 if gtap_v10==. & industry_orig==11
	replace gtap_v10 =26 if gtap_v10==. & industry_orig==12
	replace gtap_v10 =27 if gtap_v10==. & industry_orig==13
	replace gtap_v10 =28 if gtap_v10==. & industry_orig==14
	replace gtap_v10 =30 if gtap_v10==. & industry_orig==16
	replace gtap_v10 =31 if gtap_v10==. & industry_orig==17
	replace gtap_v10 =33 if gtap_v10==. & industry_orig==20
	replace gtap_v10 =34 if gtap_v10==. & industry_orig==21
	replace gtap_v10 =36 if gtap_v10==. & industry_orig==23
	replace gtap_v10 =35 if gtap_v10==. & industry_orig==24
	replace gtap_v10 =37 if gtap_v10==. & industry_orig==25
	replace gtap_v10 =40 if gtap_v10==. & industry_orig==26
	replace gtap_v10 =40 if gtap_v10==. & industry_orig==27
	replace gtap_v10 =41 if gtap_v10==. & industry_orig==28
	replace gtap_v10 =39 if gtap_v10==. & industry_orig==29
	replace gtap_v10 =39 if gtap_v10==. & industry_orig==30
	replace gtap_v10 =42 if gtap_v10==. & industry_orig==32
	replace gtap_v10 =42 if gtap_v10==. & industry_orig==33
	replace gtap_v10 =43 if gtap_v10==. & industry_orig==36
	replace gtap_v10 =44 if gtap_v10==. & industry_orig==38
	replace gtap_v10 =51 if gtap_v10==. & industry_orig==59
	replace gtap_v10 =51 if gtap_v10==. & industry_orig==62
	replace gtap_v10 =55 if gtap_v10==. & industry_orig==80
	replace gtap_v10 =55 if gtap_v10==. & industry_orig==81
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==85
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==91
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==94
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==95
	replace gtap_v10 =56 if gtap_v10==. & industry_orig==96
	replace gtap_v10 =57 if gtap_v10==. & industry_orig==98
	replace gtap_v10 =55 if gtap_v10==. & industry_orig==99
