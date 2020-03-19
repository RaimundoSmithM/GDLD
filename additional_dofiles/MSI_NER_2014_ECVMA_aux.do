/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Niger special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

	replace gtap_v10 = 18 if industry_orig ==7 & gtap_v10==.
	replace gtap_v10 = 18 if industry_orig ==8 & gtap_v10==.
	replace gtap_v10 =31 if industry_orig ==18 & gtap_v10==.
	replace gtap_v10 =48 if industry_orig ==39 & gtap_v10==.
	replace gtap_v10 =49 if (industry_orig ==40|industry_orig ==42) & gtap_v10==.
	
	

