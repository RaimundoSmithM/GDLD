cap program drop assign_gtap
program define assign_gtap
{
syntax, ccode(str) year(str) survey(str) outdir(str) tabdir(str) has_tradeweights(integer) inddpr(str) int(str)   //CJ: UPDATED

********************************************************************************
* Step 1: Assign ISIC Rev 4 Codes
********************************************************************************

// Setup Stage: Define ID's and Draw Uniform

*Set Seed
set seed 65587332 // 1.000 CLP Bill Code

*Draw a uniform at the person level
cap drop uniformdraw
gen uniformdraw = runiform()

*Set Unique ID
gen uniqueid = gdld_id										// CJ UPDATED
sort uniqueid, stable

*Get Rid of Decimals
cap replace gdld_ind_orig = floor(gdld_ind_orig)

// Merge Local Industry Concordance to ISIC Rev 4

*Call ISIC Rev 4 Codes
if `int'==0 |`int'==1 {
	joinby gdld_ind_orig using "`outdir'/isic4_concordance.dta", _merge(_industry_concordance) unmatched(both)        // CJ: UPDATED
}
else {
	joinby gdld_ind_orig using "`tabdir'/additional_concordances/`ccode'_`year'_`survey'_isic4_concordance.dta" , _merge(_industry_concordance) unmatched(both)        // CJ: UPDATED
	*joinby gdld_ind_orig using "C:\Users\Cristian\Dropbox (Personal)\GDLD\Concordance Tables\All Concordances\additional_concordances/`ccode'_`year'_`survey'_isic4_concordance.dta" , _merge(_industry_concordance) unmatched(both)
	
	}

// Merge Trade Weights to ISIC Rev 4

*Call Trade for ISIC Rev 4
if `has_tradeweights' == 1{

	joinby isic_rev4_`inddpr'dig using "`outdir'/tradeweights_isic_rev4_`inddpr'dig_`ccode'_`year'", _merge(_tradeweights_isic) unmatched(both)
	
*Select Matches
	egen match = max(_tradeweights_isic), by(uniqueid)
	keep if match == _tradeweights_isic
}

*Total Trade within Local Classification
egen tagtrade = tag(gdld_ind_orig isic_rev4_`inddpr'dig)								// CJ: UPDATED
if `has_tradeweights' == 1{	
	egen double tot_exports_prev = total(exports) if tagtrade == 1, by(gdld_ind_orig)   // CJ: UPDATED
	egen double tot_exports = max(tot_exports_prev), by(gdld_ind_orig)					 // CJ: UPDATED
	gen double tradeweight = exports / tot_exports
}
if `has_tradeweights' == 0  gen tradeweight = .
egen totsec = count(isic_rev4_`inddpr'dig), by(uniqueid)
replace tradeweight = 1 / totsec if tradeweight == .

// Assign ISIC Rev 4 Codes according to Trade Weights
	
*Loop over Original Industries and Assign ISIC Rev 4 Codes
ren isic_rev4_`inddpr'dig isic_rev4_`inddpr'dig_prev
gen isic_rev4_`inddpr'dig = .
qui levelsof gdld_ind_orig, local(oilist)											// CJ: UPDATED
foreach oi of local oilist{
	local step = 0	
	qui levelsof isic_rev4_`inddpr'dig_prev if gdld_ind_orig == `oi', local(ilist)  // CJ: UPDATED
	foreach i of local ilist{
		qui sum tradeweight if gdld_ind_orig == `oi' & isic_rev4_`inddpr'dig_prev == `i'   // CJ: UPDATED
		if `r(N)' > 0 qui replace isic_rev4_`inddpr'dig = `i' if inrange(uniformdraw,`step',`step' + `r(mean)') & gdld_ind_orig == `oi'      // CJ: UPDATED
		if `r(N)' > 0 local step = `step' + `r(mean)'
	}
}

// ISIC Rev 4 codes are assigned now

*Collapse to Person Level
sort uniformdraw
bys uniqueid: keep if _n == 1

*Drop Auxiliary Variables
local droplist uniformdraw _industry_concordance _tradeweights_isic exports match tagtrade tot_exports_prev tot_exports tradeweight totsec
foreach v of local droplist{
	cap drop `v'
}

********************************************************************************
* Step 2: Assign GTAP Codes
********************************************************************************

// Setup Stage: Draw a Uniform
	
*Draw a uniform at the person level
cap drop uniformdraw
gen uniformdraw = runiform()

// Merge GTAP Codes to ISIC Rev 4
		
*Call GTAP Codes
joinby isic_rev4_`inddpr'dig using "`tabdir'/isic_rev4_`inddpr'dig_gtap", _merge(_gtap) unmatched(both)

// Merge Trade Weights to GTAP Codes
	
*Call Trade for GTAP
if `has_tradeweights' == 1{
	joinby gtap_v10 using "`outdir'/tradeweights_gtap_`inddpr'dig_`ccode'_`year'", _merge(_tradeweights_gtap) unmatched(both)
// Select Matches
	egen match = max(_tradeweights_gtap), by(uniqueid)
	keep if match == _tradeweights_gtap
}

*Total Trade within Local Classification
egen tagtrade = tag(isic_rev4_`inddpr'dig gtap_v10)
if `has_tradeweights' == 1{	
	egen double tot_exports_prev = total(exports) if tagtrade == 1, by(isic_rev4_`inddpr'dig)
	egen double tot_exports = max(tot_exports_prev), by(isic_rev4_`inddpr'dig)
	gen double tradeweight = exports / tot_exports
}	
if `has_tradeweights' == 0  gen tradeweight = .
egen totsec = count(gtap_v10), by(uniqueid)
replace tradeweight = 1 / totsec if tradeweight == .

// Assign GTAP Codes according to Trade Weights
	
*Loop over Original Industries and GTAP V10
ren gtap_v10 gtap_v10_prev
gen gtap_v10 = .
qui levelsof isic_rev4_`inddpr'dig, local(ilist)
foreach i of local ilist{
	local step = 0	
	levelsof gtap_v10_prev if isic_rev4_`inddpr'dig == `i', local(glist)
	foreach g of local glist{
		qui sum tradeweight if gtap_v10_prev == `g' & isic_rev4_`inddpr'dig == `i'
		if `r(N)' > 0 qui replace gtap_v10 = `g' if inrange(uniformdraw,`step',`step' + `r(mean)') & isic_rev4_`inddpr'dig == `i'
		if `r(N)' > 0 local step = `step' + `r(mean)'
	}
}

// GTAP Codes are assigned now

*Collapse to Person Level
sort uniformdraw
bys uniqueid: keep if _n == 1
cap drop uniformdraw
cap drop uniqueid

*PENDING: a program wide clean up stage

}

end

