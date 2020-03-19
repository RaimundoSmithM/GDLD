/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Timor Leste special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

	replace gtap_v10 = 1 if ${industry_var} == 112 & gtap_v10==.  
	replace gtap_v10 = 6 if ${industry_var} == 113 & gtap_v10==. 
	replace gtap_v10 = 7 if ${industry_var} == 119|${industry_var} == 127 & gtap_v10==. 
	replace gtap_v10 = 27 if ${industry_var} == 1312 & gtap_v10==. 
	replace gtap_v10 = 50 if ${industry_var} == 4600|${industry_var} == 4710| ${industry_var} == 4780 & gtap_v10==. 
	
