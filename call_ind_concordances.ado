cap program drop call_ind_concordances_online
program define call_ind_concordances
{
syntax, ind_occup_ex(str) outdir(str) [indclass(str) inddpr(str) occupclass(str) occupdpr(str) int(str)]

if inlist(`ind_occup_ex',2,3) == 1 & inlist(`int',0,1) {
	preserve

** ISIC Rev. 2-ISIC Rev. 4
	if `indclass'==1 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isic_rev2_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep isic_rev2_`inddpr'dig isic_rev4_`inddpr'dig
		ren isic_rev2_`inddpr'dig gdld_ind_orig									
	}
		
** ISIC Rev. 3-ISIC Rev. 4
	else if `indclass'==2 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isic_rev3_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep isic_rev3_`inddpr'dig isic_rev4_`inddpr'dig 
		ren isic_rev3_`inddpr'dig gdld_ind_orig									
	}
		
** ISIC Rev. 3.1-ISIC Rev. 4
	else if `indclass'==3 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isic_rev31_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep isic_rev31_`inddpr'dig isic_rev4_`inddpr'dig 
		ren isic_rev31_`inddpr'dig gdld_ind_orig									
	}

** ISIC Rev. 4
	else if `indclass'==4 {
		local f_1 = 1000
		local f_2 = 100
		local f_3 = 10
		local f_4 = 1
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isic_rev4.dta?raw=true", clear
		cap gen isic_rev4_`inddpr'dig = floor(isic_rev4_4dig/`f_`inddpr'')
		keep isic_rev4_`inddpr'dig
		ren isic_rev4_`inddpr'dig gdld_ind_orig									
		clonevar isic_rev4_`inddpr'dig=gdld_ind_orig
		bys isic_rev4_`inddpr'dig gdld_ind_orig: keep if _n == 1
	}

** NAICS 07-ISIC Rev. 4
	else if `indclass'==5 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/naics07_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep naics07_`inddpr'dig isic_rev4_`inddpr'dig 
		ren naics07_`inddpr'dig gdld_ind_orig									// CJ: UPDATED
	}	
	
** NAICS 12-ISIC Rev. 4
	else if `indclass'==6 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/naics12_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep naics12_`inddpr'dig isic_rev4_`inddpr'dig 
		ren naics12_`inddpr'dig gdld_ind_orig									// CJ: UPDATED
	}
	
**NACE 1-ISIC Rev. 4
	else if `indclass'==7 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/nace1_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep nace1_`inddpr'dig isic_rev4_`inddpr'dig 
		ren nace1_`inddpr'dig gdld_ind_orig									// CJ: UPDATED
	}	
	
**NACE 11-ISIC Rev. 4
	else if `indclass'==8 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/nace11_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep nace11_`inddpr'dig isic_rev4_`inddpr'dig 
		ren nace11_`inddpr'dig gdld_ind_orig									// CJ: UPDATED
	}	

**NACE 2-ISIC Rev. 4
	else if `indclass'==9 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/nace2_`inddpr'dig_to_isic_rev4_`inddpr'dig.dta?raw=true", clear
		keep nace2_`inddpr'dig isic_rev4_`inddpr'dig 
		ren nace2_`inddpr'dig gdld_ind_orig									// CJ: UPDATED
	}
	
// OUTPUT: DATA WITH LOCAL INDUSTRY VARIABLES AND ISIC REV. 4 CONCORDANCE
	save "`outdir'/isic4_concordance", replace
	restore
}
}
end
