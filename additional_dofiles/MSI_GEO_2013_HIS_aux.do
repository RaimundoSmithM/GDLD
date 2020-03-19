/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - Georgia special cases                   ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/
gen z = runiform() if industry_orig == 130
replace gtap_v10 = 8 if industry_orig == 130 & z > 0.5
replace gtap_v10 = 9 if industry_orig== 130 & z <= 0.5
drop z
