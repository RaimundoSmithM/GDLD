/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - South Africa special cases                      ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

replace gtap_v10 = 62  if industry_orig ==914 & gtap_v10==.
replace gtap_v10 = 62  if industry_orig ==915 & gtap_v10==.
replace gtap_v10 = 62  if industry_orig ==916 & gtap_v10==.
replace gtap_v10 = 62  if industry_orig ==917 & gtap_v10==.
replace gtap_v10 = 63  if industry_orig ==920 & gtap_v10==.
replace gtap_v10 = 62  if industry_orig ==999 & gtap_v10==.



