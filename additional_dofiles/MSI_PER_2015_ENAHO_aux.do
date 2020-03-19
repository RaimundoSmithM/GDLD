/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - Peru special cases                      ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

replace gtap_v10 = 49  if industry_orig ==40 & gtap_v10==.
replace gtap_v10 = 55  if industry_orig ==52 & gtap_v10==.
replace gtap_v10 = 56  if industry_orig ==60 & gtap_v10==.
replace gtap_v10 = 56  if industry_orig ==63 & gtap_v10==.
replace gtap_v10 = 57  if industry_orig ==64 & gtap_v10==.
replace gtap_v10 = 57  if industry_orig ==66 & gtap_v10==.
replace gtap_v10 = 60  if industry_orig ==71 & gtap_v10==.
replace gtap_v10 = 60  if industry_orig ==74 & gtap_v10==.
replace gtap_v10 = 60  if industry_orig ==80 & gtap_v10==.
replace gtap_v10 = 63  if industry_orig ==85 & gtap_v10==.
replace gtap_v10 = 61  if industry_orig ==91 & gtap_v10==.



  
