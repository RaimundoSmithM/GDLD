/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - VNM special cases                      ****


******************************************************************************************************/

	replace gtap_v10= 8 if gtap_v10==. & industry_orig==15
	replace gtap_v10= 8 if gtap_v10==. & industry_orig==16
	replace gtap_v10= 27 if gtap_v10==. & industry_orig==132
	replace gtap_v10= 48 if gtap_v10==. & industry_orig==381
	replace gtap_v10= 49 if gtap_v10==. & industry_orig==429
	replace gtap_v10= 49 if gtap_v10==. & industry_orig==431
	replace gtap_v10= 49 if gtap_v10==. & industry_orig==432
	replace gtap_v10= 49 if gtap_v10==. & industry_orig==433
	replace gtap_v10= 50 if gtap_v10==. & industry_orig==466
	replace gtap_v10= 50 if gtap_v10==. & industry_orig==477
	replace gtap_v10= 55 if gtap_v10==. & industry_orig==522
	replace gtap_v10= 56 if gtap_v10==. & industry_orig==602
	replace gtap_v10= 56 if gtap_v10==. & industry_orig==620
	replace gtap_v10= 57 if gtap_v10==. & industry_orig==641
	replace gtap_v10= 59 if gtap_v10==. & industry_orig==681
	replace gtap_v10= 60 if gtap_v10==. & industry_orig==731
	replace gtap_v10= 60 if gtap_v10==. & industry_orig==742
	replace gtap_v10= 60 if gtap_v10==. & industry_orig==821
	replace gtap_v10= 63 if gtap_v10==. & industry_orig==852
	replace gtap_v10= 63 if gtap_v10==. & industry_orig==855
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==900
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==910	
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==932
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==961
	replace gtap_v10= 61 if gtap_v10==. & industry_orig==963	




