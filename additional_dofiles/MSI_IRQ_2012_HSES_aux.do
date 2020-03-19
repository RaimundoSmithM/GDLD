/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Iraq special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/


	replace gtap_v10 = 36  if industry_orig>=160 & industry_orig<170 & gtap_v10==.
	replace gtap_v10 = 36  if industry_orig>2390 & industry_orig<2400 & gtap_v10==.
	replace gtap_v10 = 43  if industry_orig>3310 & industry_orig<3500 & gtap_v10==.
	replace gtap_v10 = 61  if industry_orig>8000 & industry_orig<8200 & gtap_v10==.
