*Merge ISCO-08 Classification
cap program drop assign_isco
program define assign_isco
{
syntax, outdir(str) ccode(str) year(str) survey(str) int(str)     // CJ: UPDATED

// Setup Stage: Define ID's and Draw Uniform

*Set Seed
set seed 65587332 // 1.000 CLP Bill Code

*Draw a uniform at the person level
cap drop uniformdraw
gen uniformdraw = runiform()

*Set Unique ID
gen uniqueid = gdld_id
sort uniqueid, stable

// Merge Local Occupation Concordance to ISCO 08

if `int' == 0 |`int' == 2 {																				  // CJ: UPDATED
	joinby gdld_occup_orig using "`outdir'/isco_08_concordance.dta", _merge(isco_nomatch) unmatched(both) // CJ: UPDATED
}
else {
	joinby gdld_occup_orig using "${tabdir}additional_concordances/`ccode'_`year'_`survey'_isco08_concordance.dta" , _merge(isco_nomatch) unmatched(both)        // CJ: UPDATED
}
label var isco_nomatch "Occupation variable missing"

// ISCO Codes are assigned now

*Collapse to Person Level
sort uniformdraw
bys uniqueid: keep if _n == 1
cap drop uniformdraw
cap drop uniqueid
}
end
