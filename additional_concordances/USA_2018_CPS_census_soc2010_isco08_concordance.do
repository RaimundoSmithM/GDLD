// CORRESPONDENCE BETWEEN US CENSUS OCCUP. CODE AND SOC
	import excel using "https://github.com/RaimundoSmithM/GDLD/blob/master/USA_2018_CPS_census_soc.xlsx?raw=true", firstrow sheet("2010 to 2018 Crosswalk ") clear
	keep SOCcode CensusCode
	ren (SOCcode CensusCode) (soc_code census_code)
	drop if mi(census_code)
	destring census_code, replace force
	qui ds, has(type string)
	foreach k in `r(varlist)' {
		replace `k'=strtrim(`k')
	}
	split soc_code, parse("-")
	destring soc_code2, gen(soc_4dig) force
	drop if mi(soc_4dig)
	drop soc_code*
	order census_code
	
	tempfile a1
	save `a1', replace

// MERGE SOC-ISCO 08 WITH LOCAL CLASSIFICATION
	use "https://github.com/RaimundoSmithM/GDLD/blob/master/soc_4dig_to_isco_08_4dig.dta?raw=true", clear
	joinby soc_4dig using `a1', unmatched(both)
	keep if _merge==3
	drop _merge soc_4dig
	ren (census_code) (gdld_occup_orig)
	sort gdld_occup_orig
	order gdld_occup_orig  isco_08_4dig
	
	save "C:/Users/Cristian/Dropbox (Personal)/GDLD/Concordance Tables/All Concordances/additional_concordances/USA_2018_CPS_isco08_concordance.dta", replace
