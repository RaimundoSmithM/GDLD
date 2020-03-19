/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template  - * Kenya special cases                 ****

****              Created by:    Cristia at May 29, 2019                                         ****

****              Modified by:   Cristian at Mar 29, 2019                                        ****

******************************************************************************************************/

		replace isco_08_3dig=634 if occup_orig==631 & isco_08_3dig==.
		replace isco_08_3dig=731 if occup_orig==773 & isco_08_3dig==.
		replace isco_08_3dig=751 if occup_orig==751 & isco_08_3dig==.
		replace isco_08_3dig=512 if occup_orig==532 & isco_08_3dig==.
