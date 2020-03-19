/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - BOL special cases                      ****


******************************************************************************************************/

replace gtap_v10 = 8  if industry_orig ==15 & gtap_v10==.
replace gtap_v10 = 49  if industry_orig ==432 & gtap_v10==.
replace gtap_v10 = 49  if industry_orig ==433 & gtap_v10==.
replace gtap_v10 = 52  if industry_orig ==492 & gtap_v10==.
replace gtap_v10 = 61  if industry_orig ==949 & gtap_v10==.

