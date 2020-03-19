// Setup
 
clear all
if "`c(username)'" == "raimu" global gdldpath "D:/Dropbox/Trabajos/World Bank/GDLD/"

*Make Output Directory
global outdir "${gdldpath}GDLD Processing/Output/"
cap mkdir "${outdir}"

// Matching Rates

*Get Matching Reports
cd "${gdldpath}GDLD Processing/"
local reports: dir . files "report*.txt"
 
*Append Matching Reports
foreach r of local reports{
	preserve
	insheet using "`r'", delim(";") clear
	tempfile toappend
	save `toappend', replace
	restore
	append using `toappend'
}
compress

*Matching Shares
gen ind_matched_share = 100 * hasisic / hasindustry
gen occup_matched_share = 100 * hasisco / hasoccup

*Descriptive Statistics
sum *_matched_share

*Outliers
global lowtag = 50
gen low_ind_matched_share = ind_matched_share < $lowtag
gen low_occup_matched_share = occup_matched_share < $lowtag
list country if low_ind_matched_share
list country if low_occup_matched_share

*Big Countries
local blist USA CHN IND IDN ZAF BRA
foreach b of local blist{
	di "## Matching Status: `b' ##"
	sum *_matched_share if country == "`b'"
}


*Save Output
save "${outdir}Reports", replace	

// Comparison of Industrial Codes Assignation

set trace off
levelsof country, local(clist)
foreach c of local clist{

	*Get updated assignation
	cap{
		levelsof year if country == "`c'", local(y)
		levelsof survey if country == "`c'", local(s)

		cd "${gdldpath}GDLD Processing/"
		preserve

	*Get updated assignation
		local f: dir . files "update_MSI_`c'_`y'_*.dta"
		cap noi use `f', clear
		if _rc == 0{
			local tag 0
			
		*Tag maximum aggregation	
			foreach dig in 1 /*sec*/ 2 3 4{
				cap confirm variable isic_rev4_`dig'dig
				if _rc == 0 local tag `dig'
			}
			
		*If Tag goes through	
			if "`tag'" != "0"{
			
		*Get new assignation	
				gen n_new = 1
				collapse (sum) n_new, by(isic_rev4_`tag'dig)
				tempfile new
				save `new', replace
			
		*Get old assignation
				cd "${gdldpath}All in One/"
				local q: dir . files "MSI_`c'_`y'_*.dta"
				use `q', clear
				gen n_old = 1
				collapse (sum) n_old, by(isic_rev4_`tag'dig year ccode)

		*Merge both
				merge 1:1 isic_rev4_`tag'dig using `new', nogen
				gen dif = n_new - n_old
				save "${outdir}ind_comp_`c'", replace
				sum dif
				cap noi corr n_new n_old
			}
		}
	}
	restore
}	

// Import Log

insheet using "${outdir}ccode_run_log.txt", clear delim(";")
save "${outdir}ccode_run_log", replace
