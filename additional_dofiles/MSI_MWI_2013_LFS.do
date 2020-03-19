/*****************************************************************************************************
*****************************************************************************************************


****              Project:       GDLD Coding Template                                            ****

****              Created by:    Cristia at May 31, 2019                                         ****

****              Modified by:   Cristian at Mar 31, 2019                                        ****


Prev Prog: 		- None
	
Input Files: 	- gdld_class_program.do								: Program that checks local industry and occupation classification concordance with ISIC Rev. 4 and ISCO-08 
																	  respectively.
				- tradeweights.do									: 

			  	  
Output Files:  	- MSI_${ccode}_${year}_${survey}.dta				
				- MSI_${ccode}_${year}_${survey}_v6.dta


******************************************************************************************************/
*****************************************************************************************************

*  Before running this code, please complete the google sheet. 

/*****************************************************************************************************
*                                                                                                    *
*                                      1. INITIAL SETTINGS                                           *
*                                                                                                    *
*****************************************************************************************************/

macro drop _all
cap log close 
clear
set more off


foreach c in labmask {
	cap which `c'
	if _rc != 0 cap noi ssc install `c'                      						               //Check and Install Written Commands
}

/**************************			 1.1 Change Survey Information			 **************************************/


*Survey ID's
global ccode = "MWI"                                                                      // Country 3 Digit Name to replace "PAK", keep quotation marks.
global year = 2013                                                                       // 4 digit Year to replace "2014", keep keep quotation marks.
global survey = "LFS"        															// Survey Acro Name to replace "LFS", keep quotation marks.

global isic_dig = 2                                                            			// Industry digit of aggregation

*Base Year
global base_year = 2015                                                                   // For Wage Standardization 

/**************************			 1.1 Directory			 **************************************/

* Local User
if "`c(username)'" == "raimu"    	 global user = "RS"
if "`c(username)'" == "Cristian" 	 global user = "cj"
if "`c(username)'" == "Javiera"  	 global user = "jp"
if "`c(username)'" == "huanjunzhang" global user = "hj"
if "`c(username)'" == "israel"       global user = "io"  //Huanjun on Apr 16

* Main Directory: I2D2 Dropbox
if "${user}" == "jp"                 global maindir "/Users/Javiera/I2D2 Dropbox/"       //Mac User
if "${user}" == "RS"                 global maindir "D:/I2D2 Dropbox/"                   //PC  User
if "${user}" == "cj"                 global maindir "C:/Users/Cristian/I2D2 Dropbox/"
if "${user}" == "hj"                 global maindir "/Users/huanjunzhang/I2D2 Dropbox/"
if "${user}" == "io"                 global maindir " /Users/Israel/I2D2 Dropbox/" 

 
* Output Data Path	
global outpath "${maindir}Applications/Manufacturing skill intensity/I2D2 Surveys/${ccode}/${year}/Processed/"
     cap mkdir "${maindir}Applications/Manufacturing skill intensity/I2D2 Surveys/${ccode}/"
     cap mkdir "${maindir}Applications/Manufacturing skill intensity/I2D2 Surveys/${ccode}/${year}/"
     cap mkdir "${maindir}Applications/Manufacturing skill intensity/I2D2 Surveys/${ccode}/${year}/Processed/"
global rev "${maindir}Applications/GDLD/Workflow/GDLD_latest_0619v7/" 

*Box Path	
global boxpath "${maindir}Applications/Manufacturing skill intensity/Macro Aggregation/"

*Log File
log      using "${outpath}MSI_${ccode}_${year}_${survey}.txt", replace // Add survey's version if it necessary (e.g: survey_v02_M_v01_A) 

global tradepath "${maindir}Applications/Manufacturing skill intensity/Harmonizations/Tradeweights/"
global gtappath "${maindir}Applications/Manufacturing skill intensity/Harmonizations/GTAP/"
global gdldpath "${maindir}Applications/Manufacturing skill intensity/Harmonizations/GDLD/"
global indpath "${maindir}Applications/Manufacturing skill intensity/Harmonizations/Industry/"

** COUNTRY CODES - COUNTRY NAME CORRESPONDECE

preserve
use if ccode == "${ccode}" using "${maindir}Applications/Manufacturing skill intensity/Country Codes/Country Codes", clear
levelsof ccode, local(clist)
replace cname = proper(cname)
levelsof cname, local(n)
local ${ccode}_name `n'
restore


* Input Data Path (Check the current path of each database to be processed)
global  inpath "${maindir}Microdata/__I2D2/`${ccode}_name'/${year}/${survey}/Processed/"  


** HARDCODED INPUTS

** Start
di in red "### GTAP: `${ccode}_name' - ${year} - ${survey} ###"	
di in red "### Start: `c(current_time)' - `c(current_date)' ###"
	
/*****************************************************************************************************
*                                                                                                    *
							   * PREVIOUS PROGRAMS
*                                                                                                    *
*****************************************************************************************************/

	// 1. LOCAL INDUSTRY AND OCCUPATION CONCORDANCE	
		run "${maindir}Applications/GDLD/Workflow/GDLD_Code_Template/gdld_class_program.do" 
			
	// 2. TRADEWEIGHTS
		run "${maindir}Applications/Manufacturing Skill Intensity/Harmonizations/Tradeweights/Code/tradeweights.do"

	
	
/*****************************************************************************************************
*                                                                                                    *
							   * PREAMBLE
*                                                                                                    *
*****************************************************************************************************/

*ID's
global id_vars ccode year month idh idp wgt strata psu 	

*Demographic Variables
global demo_vars gender age

*Industry Variable
global industry_var industry_orig

*Occupation Variable
global occup_var occup_orig

*Wage Variables
global wage_vars wage unitwage whours

*Education Variables
global educ_vars educy edulevel1 edulevel2 edulevel3

*Demographic Variables
global demo_vars age gender urb

/*****************************************************************************************************
*                                                                                                    *
							   * LOCAL INDUSTRY AND OCCUPATION CONCORDANCE
*                                                                                                    *
*****************************************************************************************************/

/*
		  
	Input Files: 	- isic_corr(integer)	: Integer from 1 to 6 that corresponds to the concordance tables that must be used according to 
											  the local classification
									
										  1 --------------> Local classification with no concordance with ISIC
										  2 --------------> ISIC Rev. 2 - ISIC Rev. 4 concordance table
										  3 --------------> ISIC Rev. 3 - ISIC Rev. 4 concordance table
										  4 --------------> ISIC Rev. 31 - ISIC Rev. 4 concordance table
										  5 --------------> ISIC Rev. 4 codes
										  6 --------------> NAICS - ISIC Rev. 4 concordance table

					- isic_dig(integer)		: Integer from 1 to 6 that corresponds the level of aggregation of the local classification
				
										  1 - 4 --------------> Applies to all classifications
										  5 - 6 --------------> Applies only to  NAICS 
				
					- occup_corr(integer)	: Integer from 1 to 2 that corresponds to the concordance tables that must be used according to the 
											local classification
									
										  1 --------------> Local classification with no concordance with ISCO
										  2 --------------> ISCO-88 - ISCO-08 concordance table
										  3 --------------> ISCO-08 codes

										 			
					- occup_dig(integer)	: Integer from 1 to 4 that corresponds the level of aggregation of the local classification
				
										  1 - 4 --------------> Applies to all classifications		
										  
	Output Files:  	- isic4_concordance		: Tempfile with information on local industry variable and ISIC Rev. 4 concordance		
					- isco_08_concordance   : Tempfile with information on local occupation variable and ISCO-08 concordance
		  
*/	

gdld_classifications, isic_corr(5) isic_dig(${isic_dig}) occup_corr(2) occup_dig(2)
	

/*****************************************************************************************************
*                                                                                                    *
							   * SURVEY DATA
*                                                                                                    *
*****************************************************************************************************/

*Get Survey File
cd "${inpath}"
local surveydata: dir . files "${ccode}_${year}_I2D2_${survey}.dta" // Add survey's version if it necessary (e.g: survey_v02_M_v01_A)
di `surveydata'

	use `surveydata', clear	


	** Check if industry and occupation classification use more than 4 digits
	
		local j1 10 // 5-digit classification
		local j2 100 // 6-digit classification
		local j3 1000 // 7-digit classification
	
		foreach k in industry occup {
			tempvar `k'_orig_aux max_`k'_orig_aux 
			tostring `k'_orig, gen(``k'_orig_aux')
			egen `max_`k'_orig_aux'=max(length(``k'_orig_aux'))
			
		** Rename original industry/occupation variable and
			if `max_`k'_orig_aux' > 4 {
				ren `k'_orig  `k'_orig2
			
				forval i=1/3 {
					if `max_`k'_orig_aux'==`i'+4 {
						gen `k'_orig= floor(`k'_orig2/`j`i'')
					}
				}
			}
		}

** Monthly Wage (Inherited from Claudio Montenegro and David Newhouse)

*Test if Inputs are available
local test = 1
foreach var in wage unitwage{
	capture confirm numeric variable `var', exact
	if _rc != 0 local test = 0
}

if `test' == 1{
	
** Wage Per Month	
	gen wpm = .
	
*Daily
	replace wpm = wage * (5 * 4.345) if unitwage == 1 

*Weekly
	replace wpm = wage * (4.345) if unitwage==2

*Every two weeks
	replace wpm = wage * (4.345 / 2) if unitwage == 3

*Every two months
	replace wpm = wage / 2 if unitwage == 4

*Monthly
	replace wpm = wage if unitwage == 5

*Quarterly
	replace wpm = wage / 3 if unitwage == 6

*Every six months
	replace wpm = wage / 6 if unitwage == 7

*Annually
	replace wpm = wage / 12 if unitwage == 8

*Hourly
	cap confirm numeric variable whours, exact
	if _rc == 0 replace wpm = wage * (whours * 4.345) if unitwage == 9

** Wages in Constant US$ Dollars
	merge m:1 ccode year using "${maindir}Applications/Manufacturing skill intensity/Prices/Prices 1990 2017", gen(_prices)
	egen select = max(_prices), by(ccode)
	keep if select == 3
	drop select
	sum er if year == ${base_year}
	local er = `r(mean)'
	keep if _prices == 3
	foreach v in wage wpm{
		gen `v'_us = (`v' / (cpi / 100)) / `er'
	}
	label var wage_us "Last wages payment in constant US$ dollars"
	label var wpm  "Wage per month"
	label var wpm_us  "Wage per month in constant US$ dollars"	
	keep if inlist(_prices,1,3) 
	drop _prices er cpi
}

// 	MODIFY INDUSTRY_ORIG TO 2-DIGIT
	rename industry_orig industry_orig2
	clonevar industry_orig=industry_orig2
	replace industry_orig=floor(industry_orig * 10^-(2))

/*****************************************************************************************************
*                                                                                                    *
							   * GTAP CODES
*                                                                                                    *
*****************************************************************************************************/

if "${industry_var}" != ""{
	
// MERGE SURVEY DATA WITH ISIC REV. 4 CONCORDANCE TABLE 

// Run Tradeweights Program
	preserve
	tradeweights, ccode("${ccode}") year(${year}) isic_dig(${isic_dig}) tradepath("${tradepath}") gtappath("${gtappath}") gdldpath("${gdldpath}")
	if `r(has_tradeweights)' == 1 di in red "### Has Tradeweights ###"
	if `r(has_tradeweights)' == 0 di in red "### Missing Tradeweights ###"
	local has_tradeweights = `r(has_tradeweights)'
	restore
	
	*Draw a uniform at the person level
	set seed 489237
	gen z = runiform()

	// Call ISIC Rev 4 Codes	
	joinby ${industry_var} using "${outpath}isic4_concordance.dta", _merge(_industry_concordance) unmatched(both)

	// Call Trade for ISIC Rev 4
	if `has_tradeweights' == 1{

		joinby isic_rev4_${isic_dig}dig using "${gdldpath}tradeweights_isic_rev4_dig${isic_dig}_${ccode}_${year}", _merge(_tradeweights_isic) unmatched(both)
		
	// Select Matches
		egen match = max(_tradeweights_isic), by(idh idp)
		keep if match == _tradeweights_isic
	}

	// Total Trade within Local Classification
	egen tagtrade = tag(industry_orig isic_rev4_${isic_dig}dig)
	if `has_tradeweights' == 1{	
		egen double tot_exports_prev = total(exports) if tagtrade == 1, by(industry_orig)
		egen double tot_exports = max(tot_exports_prev), by(industry_orig)
		gen double tradeweight = exports / tot_exports
	}
	if `has_tradeweights' == 0  gen tradeweight = .
	egen totsec = count(isic_rev4_${isic_dig}dig), by(idh idp)
	replace tradeweight = 1 / totsec if tradeweight == .
		
	// Loop over Original Industries and Assign ISIC Rev 4 Codes
	ren isic_rev4_${isic_dig}dig isic_rev4_${isic_dig}dig_prev
	gen isic_rev4_${isic_dig}dig = .
	levelsof industry_orig, local(oilist)
	foreach oi of local oilist{
		local step = 0	
		levelsof isic_rev4_${isic_dig}dig_prev if industry_orig == `oi', local(ilist)
		foreach i of local ilist{
			qui sum tradeweight if industry_orig == `oi' & isic_rev4_${isic_dig}dig_prev == `i'
			if `r(N)' > 0 replace isic_rev4_${isic_dig}dig = `i' if inrange(z,`step',`step' + `r(mean)') & industry_orig == `oi'
			if `r(N)' > 0 local step = `step' + `r(mean)'
		}
	}

	// Collapse to Person Level
	sort z
	bys idh idp: keep if _n == 1
	
	*Drop Auxiliary Variables
	drop z _industry_concordance _tradeweights_isic exports match tagtrade tot_exports_prev tot_exports tradeweight totsec
		
	*Draw a uniform at the person level
	set seed 38958
	gen z = runiform()
			
	// Call GTAP Codes
	joinby isic_rev4_${isic_dig}dig using "${gtappath}isic_rev4_${isic_dig}dig_gtap", _merge(_gtap) unmatched(both)
			
	// Call Trade for GTAP
	if `has_tradeweights' == 1{
		joinby gtap_v10 using "${gdldpath}tradeweights_gtap_dig${isic_dig}_${ccode}_${year}", _merge(_tradeweights_gtap) unmatched(both)
	// Select Matches
		egen match = max(_tradeweights_gtap), by(idh idp)
		keep if match == _tradeweights_gtap
	}
		
	// Total Trade within Local Classification
	egen tagtrade = tag(isic_rev4_${isic_dig}dig gtap_v10)
	if `has_tradeweights' == 1{	
		egen double tot_exports_prev = total(exports) if tagtrade == 1, by(isic_rev4_${isic_dig}dig)
		egen double tot_exports = max(tot_exports_prev), by(isic_rev4_${isic_dig}dig)
		gen double tradeweight = exports / tot_exports
	}	
	if `has_tradeweights' == 0  gen tradeweight = .
	egen totsec = count(gtap_v10), by(idh idp)
	replace tradeweight = 1 / totsec if tradeweight == .
		
	// Loop over Original Industries and GTAP V10
	set trace off
	ren gtap_v10 gtap_v10_prev
	gen gtap_v10 = .
	levelsof isic_rev4_${isic_dig}dig, local(ilist)
	foreach i of local ilist{
		local step = 0	
		levelsof gtap_v10_prev if isic_rev4_${isic_dig}dig == `i', local(glist)
		foreach g of local glist{
			qui sum tradeweight if gtap_v10_prev == `g' & isic_rev4_${isic_dig}dig == `i'
			if `r(N)' > 0 replace gtap_v10 = `g' if inrange(z,`step',`step' + `r(mean)') & isic_rev4_${isic_dig}dig == `i'
			if `r(N)' > 0 local step = `step' + `r(mean)'
		}
	}
	
	// LABEL GTAP (65) INDUSTRY CLASSIFICATION
		label var gtap_v10 "GTAP(65) industry classification"	
		la de lblindustry_gtap 1 "Paddy rice" 2 "Wheat" 3 "Cereal grains, n.e.s." 	///
		4 "Vegetables, fruits, nuts" 5 "Oil seeds" 6 "Sugar cane and sugar beet" 		///
		7 "Plant-based fibers" 8 "Crops, n.e.s." 9 "Bovine cattle, sheep and goats, horses"  ///
		10 "Animal products n.e.s." 11 "Raw milk" 12 "Wool, silk-worm cocoons" 13 "Forestry" ///
		14 "Fishing" 15 "Coal" 16 "Oil" 17 "Gas" 18 "Minerals n.e.s."  ///
		19 "Bovine meat products" 20 "Meat products n.e.s." 21 "Vegetable oils and fats" ///
		22 "Dairy products" 23 "Processed rice" 24 "Sugar" 25 "Food products n.e.s." ///
		26 "Beverages and tobacco products" 27 "Textiles" 28 "Wearing apparel" ///
		29 "Leather products" 30 "Wood products" 31 "Paper products, publishing" ///
		32 "Petroleum, coal products" 33 "Chemicals and chemical roducts" 34 "Pharmaceutical and medical products" ///
		35 	"Rubber and plastic prodcuts" 36 "Mineral products n.e.s." 37 "Ferrous metals" 38 "Metals n.e.s." ///
		39 "Metal products"  40 "Electronic equipment" 41 "Electrical equipment" 42 "Machinery and equipment n.e.s." /// 
		43 "Machinery and equipment" 44 "Transport equipment n.e.s." 45 "Manufactures n.e.s." ///
		46 "Electricity" 47 "Gas manufacture, distribution" 48 "Water" 49 "Construction" /// 
		50 "Trade" 51 "Accomodation, food and beverage services" 52 "Transport n.e.s." 53 "Water transport" 54 "Air transport" ///
		55 "Warehousing" 56 "Communication" 57 "Financial services n.e.s." 58 "Insurance" 59 "Real State"  /// 
		60 "Business services n.e.s." 61 "Recreational and other services"  ///
		62 "Public administration and defence, compulsory social security" 63 "Education" 64 "Human health and social activies" ///
		65 "Dwellings"
		label values gtap_v10 lblindustry_gtap
		
** INDUSTRY_LINKAGE
	recode gtap_v10 (1 2 3 4 5 6 7 8 9 10 11 12 13 14  = 1) (15 16 17 18 32  = 2 ) (19 20 21 22 23 24 25 26  = 3) (27  = 4) (28 29  = 5) (33 34 35 36  = 6) (37 38 39  = 7) (44  = 8) (40 41  = 9) (43  = 10) (30 31 45  = 11) (46 47 48  = 12) (49  = 13) (47 48 49 50  = 14) (52 53 57 51  = 15) (60  = 16) (61 62 63 64  = 17), gen(industry_linkage)
	label var industry_linkage "LINKAGE(17) industry classification"
	la de lblindustry_linkage 1 "Other agriculture" 2 "Natural resources / mining" 3 "Food, beverages, tobacco" 4 "Textiles" 5 "Wearing apparel and leather" 6 "Chemical, rubber, plastic products" 7 "Metals" 8 "Transport equipment" 9 "Electronic equipment" 10 "Machinery and equipment nec" 11 "Other manufacturing" 12 "Utilities" 13 "Construction" 14 "Trade and transport" 15 "Finance and other business services" 16 "Communication and business services nec" 17 "Social services" 
	label values gtap_v10 lblindustry_gtap		
	label values industry_linkage lblindustry_linkage

	local isic_dig = $isic_dig
	drop isic_rev4_`isic_dig'dig_prev _gtap gtap_v10_prev _tradeweights_gtap exports match tagtrade tot_exports_prev tot_exports tradeweight totsec

	// Collapse to Person Level
	sort z
	bys idh idp: keep if _n == 1
	drop z

	// ISIC Rev. 4 variables

		if $isic_dig==1 {
			forval i=2/4 {
				gen isic_rev4_`i'dig=.
				label var isic_rev4_`i'dig "ISIC Rev. 4 Codes (`i' digits)"
			}
		}
		else if $isic_dig==2 {
			forval i=3/4 {
				gen isic_rev4_`i'dig=.
				label var isic_rev4_`i'dig "ISIC Rev. 4 Codes (`i' digits)"
			}
			local j=`isic_dig'-1
			gen isic_rev4_`j'dig = floor(isic_rev4_`isic_dig'dig * 10^-(`isic_dig'-`j'))
			label var isic_rev4_`j'dig "ISIC Rev. 4 Codes (`i' digits)"
		}
		else if $isic_dig==3 {
			gen isic_rev4_4dig=.
			label var isic_rev4_4dig "ISIC Rev. 4 Codes (4 digits)"
			forval i=1/2 {
				gen isic_rev4_`i'dig = floor(isic_rev4_`isic_dig'dig * 10^-(`isic_dig'-`i'))
				label var isic_rev4_`i'dig "ISIC Rev. 4 Codes (`i' digits)"
			}
		}
		else if $isic_dig==4 {
			forval i=1/3 {
				gen isic_rev4_`i'dig = floor(isic_rev4_`isic_dig'dig * 10^-(`isic_dig'-`i'))
				label var isic_rev4_`i'dig "ISIC Rev. 4 Codes (`i' digits)"
			}
		}
			label var isic_rev4_`isic_dig'dig "ISIC Rev. 4 Codes (`isic_dig' digits)"
			
// Add ISIC Rev. 3.1. at 2 Digits
	if ${isic_dig} > 1{
	
*Draw a uniform at the person level
		set seed 38958
		gen z = runiform()
		
*Merge Correspondence		
		local factor_3 10
		local factor_4 100
		joinby isic_rev4_${isic_dig}dig using "${indpath}isic_rev31_${isic_dig}dig_to_isic_rev4_${isic_dig}dig", _merge(_isic_31) unmatched(both)
		if ${isic_dig} > 2{
			gen isic_rev31_2dig = floor(isic_rev31_${isic_dig}dig / `factor_${isic_dig}')
			drop isic_rev31_${isic_dig}dig
		}	
		cap drop _isic_31 
		
*Label ISIC Rev 3.1.		
		label var isic_rev31_2dig "ISIC Rev. 3.1. Codes (2 digits)"
		
*Collapse to person level		
		bys z: keep if _n == 1
		drop z
	}			
	
	}
else {
	gen gtap_v10 = .
	label var gtap_v10 "GTAP(65) industry classification"	
	gen industry_linkage = .
	label var industry_linkage "LINKAGE(17) industry classification"
	gen isic_gtap_nomatch = 1
	label var isic_gtap_nomatch  "No concordance code available between ISIC and GTAP"
}


/*****************************************************************************************************
*                                                                                                    *
							   * ISCO CODES
*                                                                                                    *
*****************************************************************************************************/
/*
if "${occup_var}" != ""{
	
		*Merge ISCO-88 Classification	
		joinby occup_orig using "${outpath}isco_08_concordance.dta", _merge(isco_nomatch) unmatched(both) // add "occup_orig": by Cristian 0412
		label var isco_nomatch "Occupation variable missing"
	
		*We dont have a criteria for selecting one of the ISCO-08 codes for the many to many correspondences
		gen z = runiform()
		sort z, stable
		bys idh idp: keep if _n == 1 // Keep observations at random
		drop z 
	}
	*/

	gen occup_isco=.
	label var occup_isco "ISCO-08 Classification"
	gen isco_nomatch = 1
    label var isco_nomatch "Occupation variable missing"

	
/*****************************************************************************************************
*                                                                                                    *
							   * PROCESSED DATASET
*                                                                                                    *
*****************************************************************************************************/

compress
drop if mi(idp) | mi(idh)

** Drop auxiliary variables and rename original variables
	foreach k in industry occup {
		
	** Rename original industry/occupation variable and
		if `max_`k'_orig_aux' > 4 {
				drop `k'_orig
				ren `k'_orig2 `k'_orig
		}
	}

sort idh idp, stable
isid idh idp, sort
save "${outpath}MSI_${ccode}_${year}_${survey}", replace
save "${rev}MSI_${ccode}_${year}_${survey}_v7",replace

log close
