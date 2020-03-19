cap program drop call_occup_concordances
program define call_occup_concordances
{
syntax, ind_occup_ex(str) outdir(str) [occupclass(str) occupdpr(str) int(str)]

if inlist(`ind_occup_ex',1,3) == 1 & inlist(`int',0,2) {
	preserve
**ISCO-88-ISCO-08 Concordance
	if `occupclass'==1 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isco_88_`occupdpr'dig_to_isco_08_`occupdpr'dig.dta?raw=true", clear
		keep isco_88_`occupdpr'dig isco_08_`occupdpr'dig
		rename (isco_88_`occupdpr'dig) (gdld_occup_orig)		
		label var gdld_occup_orig "Original Occupational Codes"
	}		

**ISCO-08 Codes // RS: ACTUALIZAR A TABLA ISCO 08 COMPLETA
	else if `occupclass'==2 {
		local f_1 = 1000
		local f_2 = 100
		local f_3 = 10
		local f_4 = 1
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/isco_08.dta?raw=true", clear
		cap gen isco_08_`occupdpr'dig = floor(isco_08_4dig/`f_`occupdpr'')
		keep  isco_08_`occupdpr'dig
		ren isco_08_`occupdpr'dig gdld_occup_orig									
		clonevar  isco_08_`occupdpr'dig=gdld_occup_orig	
		bys isco_08_`occupdpr'dig gdld_occup_orig: keep if _n == 1
	}

**SOC Codes
	else if `occupclass'==3 {
		use "https://github.com/RaimundoSmithM/GDLD/blob/master/soc_`occupdpr'dig_to_isco_08_`occupdpr'dig.dta?raw=true", clear
		keep soc_`occupdpr'dig isco_08_`occupdpr'dig
		rename (soc_`occupdpr'dig) (gdld_occup_orig)			
		label var gdld_occup_orig "Original Occupational Codes"
	}
	
// OUTPUT: DATA WITH LOCAL OCCUPATION VARIABLE AND ISCO-08 CONCORDANCE
	save "`outdir'/isco_08_concordance", replace
	restore
}
}
end
