cap program drop extra_variables_and_report
program define extra_variables_and_report
{
syntax, ccode(str) year(str) survey(str) tabdir(str) inddpr(str) occupdpr(str) ind_occup_ex(str) outdir(str)

********************************************************************************
* Additional Variables
********************************************************************************

// Generate Additional Variables

** Industry
if inlist(`ind_occup_ex',2,3){

*Get ISIC Codes
	preserve
	use "`tabdir'/isic_rev4", clear
	
*At 2, 3, and 4 Digits of Aggregation	
	if inlist(`inddpr',1,2,3,4){
		forv j = 1(1)`inddpr'{
			local f_1 = 1000
			local f_2 = 100
			local f_3 = 10
			local f_4 = 1
			cap gen isic_rev4_`j'dig = floor(isic_rev4_4dig/`f_`j'')
		}
		forv j = 1(1)4{
			if `j' > `inddpr' cap drop isic_rev4_`j'dig
		}
		bys isic_rev4_`inddpr'dig: keep if _n == 1
	}
	
*Section Level	
	if "`inddpr'" == "sec"{
		gen isic_rev4_1dig = floor(isic_rev4_4dig/1000)
		keep isic_rev4_1dig isic_rev4_secdig
		bys isic_rev4_secdig: keep if _n == 1
	}
	
/*At 1 Digit of Aggregation	
	if `inddpr' == 1{
		keep isic_rev4_1dig
		bys isic_rev4_1dig: keep if _n == 1
	}*/
	tempfile isictomerge
	save `isictomerge', replace
	restore

*Merge ISIC Codes	
	merge m:1 isic_rev4_`inddpr'dig using `isictomerge', keep(master matched) nogen
}

** Occupation
if inlist(`ind_occup_ex',1,3){

*Get ISCO Codes
	preserve
	use "`tabdir'/isco_08", clear
	
*At 2, 3, and 4 Digits of Aggregation	
	forv j = 1(1)`occupdpr'{
		local f_1 = 1000
		local f_2 = 100
		local f_3 = 10
		local f_4 = 1
		cap gen isco_08_`j'dig = floor(isco_08_4dig/`f_`j'')
	}
	forv j = 1(1)4{
		if `j' > `occupdpr' cap drop isco_08_`j'dig
	}
	bys isco_08_`occupdpr'dig: keep if _n == 1
	noi sum *
	tempfile iscotomerge
	save `iscotomerge', replace
	restore

*Merge ISCO Codes	
	merge m:1 isco_08_`occupdpr'dig using `iscotomerge', keep(master matched) nogen
}

********************************************************************************
* Matching Report Stage
********************************************************************************

// Initialize Report
	foreach var in full hasind hasisic hasgtap hasoccup hasisco{
		local `var'_N
	}

// Industry Report
if inlist(`ind_occup_ex',2,3){

*Tags
	gen full    = 1
	gen hasind = !mi(gdld_ind_orig)
	gen hasisic = !mi(isic_rev4_`inddpr'dig)
	gen hasgtap = !mi(gtap_v10)
	local full_name "Sample Size"
	local hasind_name "Has Industry Code"
	local hasisic_name "Has Matched ISIC Rev 4 Industry Code"
	local hasgtap_name "Has Matched GTAP Code"

*Primary Report: Sample Sizes
	foreach var in full hasind hasisic hasgtap{
		qui count if `var' == 1
		local `var'_N = `r(N)'
		di in red "## ``var'_name': ``var'_N' ##"
	}

*Secondary Repor: Matched Shares	
	local matched_share_1 = round(100*`hasisic_N' / `hasind_N')
	di in red "## Percentage of Non-Missing Industry Codes matched to ISIC Rev 4: `matched_share_1'% ##"
	local matched_share_2 = round(100*`hasgtap_N' / `hasind_N')
	di in red "## Percentage of Non-Missing Industry Codes matched to GTAP: `matched_share_2'% ##"	
	local matched_share_3 = round(100*`hasgtap_N' / `hasisic_N')
	di in red "## Percentage of matched ISIC Codes matched to GTAP: `matched_share_3'% ##"	
	
*RS: Add industry extensive margin report
	egen ind_orig_tag = tag(gdld_ind_orig)
	egen ind_matched_tag = tag(isic_rev4_`inddpr'dig)
	foreach var in ind_orig_tag ind_matched_tag{
		qui count if `var' == 1
		local `var'_N = `r(N)'
	}
	local matched_share_4 = round(100*`ind_matched_tag_N' / `ind_orig_tag_N')
	di in red "## Percentage of Unique Non-Missing Industry Codes matched to ISIC Rev 4: `matched_share_4'% ##"

*Clean Up	
	drop full hasind hasisic hasgtap ind_orig_tag ind_matched_tag
}

// Occupation Report
if inlist(`ind_occup_ex',1,3){
*Tags
	gen full    = 1
	gen hasoccup = !mi(gdld_occup_orig)
	gen hasisco = !mi(isco_08_`occupdpr'dig)
	local full_name "Sample Size"
	local hasoccup_name "Has Occupation Code"
	local hasisco_name "Matched ISCO Code"

*Primary Report: Sample Sizes
	foreach var in hasoccup hasisco{
		qui count if `var' == 1
		local `var'_N = `r(N)'
		di in red "## ``var'_name': ``var'_N' ##"
	}

*Secondary Repor: Matched Shares	
	local matched_share_5 = round(100*`hasisco_N' / `hasoccup_N')
	di in red "## Percentage of Non-Missing Occupation Codes matched to ISCO 08: `matched_share_5'% ##"
	
*RS: Add occupation extensive margin report	
	egen occup_orig_tag = tag(gdld_occup_orig)
	egen occup_matched_tag = tag(isco_08_`occupdpr'dig)
	foreach var in occup_orig_tag occup_matched_tag{
		qui count if `var' == 1
		local `var'_N = `r(N)'
	}
	local matched_share_6 = round(100*`occup_matched_tag_N' / `occup_orig_tag_N')
	di in red "## Percentage of Unique Non-Missing Occupation Codes matched to ISCO 08: `matched_share_6'% ##"
	
*Clean Up	
	drop full hasoccup hasisco occup_orig_tag occup_matched_tag
}

*Write Report
cap file close f
file open f using "`outdir'/report_`ccode'_`year'_`survey'.txt", write replace
file write f "country;survey;year;sample_size;hasindustry;Nuniqueindustry;hasisic;Nuniqueisic;hasgtap;hasoccup;Nuniqueoccup;hasisco;Nuniqueisco" _n
file write f "`ccode';`survey';`year';`full_N';`hasind_N';`ind_orig_tag_N';`hasisic_N';`ind_matched_tag_N';`hasgtap_N';`hasoccup_N';`occup_orig_tag_N';`hasisco_N';`occup_matched_tag_N'" _n
file close f

}
end

