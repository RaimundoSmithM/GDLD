cap program drop tradeweights
program define tradeweights, rclass
{
syntax, ccode(str) year(integer) inddpr(str) outdir(str) tabdir(str) 

// Step 0: Define Outputs

preserve

*Outputs
local hasccode = 0
local hasyear = 0
local hasdata = 0

// Step 1: ISIC Rev 4 Trade Weights

*Load Raw Data
use ccode year isic_rev4_`inddpr'dig exports if ccode == "`ccode'" using "https://github.com/RaimundoSmithM/GDLD/blob/master/tradeweights_isic_rev4_`inddpr'dig.dta?raw=true", clear
count
if `r(N)' > 0 local hasccode = 1

*Check if Year is Available
if `hasccode' == 1{
	count if year == `year'
	if `r(N)' > 0 local hasyear = 1
	if `r(N)' == 0 local hasyear = 0

	if `hasyear' == 1{
		keep if year == `year'
		bys isic_rev4_`inddpr'dig: keep if _n == 1
	}
	if `hasyear' == 0{

*Tag Closest Years
		egen pre = max(year) if year < `year', by(ccode)
		egen post = min(year) if year > `year', by(ccode)
		keep if year == pre | year == post
		egen double aux_exports = total(exports), by(isic_rev4_`inddpr'dig)
		bys isic_rev4_`inddpr'dig: keep if _n == 1
		drop exports
		ren aux_exports exports
	}
	drop if isic_rev4_`inddpr'dig == .
	drop year ccode
	tempfile isic_rev4_trade
	save `isic_rev4_trade', replace
}	

// Step 2 : GTAP Trade Weights

*Load Raw Data
use ccode year gtap_v10 exports if ccode == "`ccode'" using "https://github.com/RaimundoSmithM/GDLD/blob/master/tradeweights_gtap_`inddpr'dig.dta?raw=true", clear
count
if `r(N)' > 0 local hasccode = 1

*Check if Year is Available
if `hasccode' == 1{
	count if year == `year'
	if `r(N)' > 0 local hasyear = 1
	if `r(N)' == 0 local hasyear = 0

	if `hasyear' == 1{
		keep if year == `year'
		bys gtap_v10: keep if _n == 1
	}
	if `hasyear' == 0{

*Tag Closest Years
		egen pre = max(year) if year < `year', by(ccode)
		egen post = min(year) if year > `year', by(ccode)
		keep if year == pre | year == post
		egen double aux_exports = mean(exports), by(gtap_v10)
		bys gtap_v10: keep if _n == 1
		drop exports
		ren aux_exports exports
	}
	drop if gtap_v10 == .
	drop year ccode
	tempfile gtap_trade
	save `gtap_trade', replace
}	

// Step 4: Export Datasets

*Chek Result
local hasdata = 1
foreach d in gtap isic_rev4{
	clear
	cap use ``d'_trade', clear
	count
	if `r(N)' == 0 local hasdata = 0
}

if `hasccode' == 1 & `hasdata' == 1{	
	foreach d in gtap isic_rev4{
		use ``d'_trade', clear
		compress
		tempfile tradeweights
		save "`outdir'/tradeweights_`d'_`inddpr'dig_`ccode'_`year'", replace
	}
}

restore

// Step 5: Return Results	
if `hasccode' == 1 & `hasdata' == 1 return local has_tradeweights 1
if `hasccode' == 0 | `hasdata' == 0 return local has_tradeweights 0
}

end
