********************************************************************************
* GDLD PROGRAM																   *
********************************************************************************

capture program drop gdld_class
program define gdld_class
{		
version 14.0	

syntax, Ccode(str) Year(int) Survey(str) New(real) INT(real) [ID_survey(varlist min=1) ind_occup_ex(real 3) INDName(varname numeric max=1) INDClass(int 4) INDPr(str) OCCUPName(varname numeric max=1) OCCUPClass(int 2) OCCUPDpr(int 1)] 

// 0. SETUP

**User written commands
cap noi ssc install filelist

**Current directory to save files
global outdir `c(pwd)'

// 1. SYNTAX ERRORS

**error: length of 'ccode' must be 3
if length("`ccode'")!=3 {
	di as error "Length of ccode() must be 3, 'ccode' is non-admisible"
	exit 198
} 

**error: 'ccode' restricted to alphabet
forval i=1/3 {
	if regexm(substr("`ccode'",`i',1),"[a-z]")!=1 & regexm(substr("`ccode'",`i',1),"[A-Z]")!=1  {
		di as error "ccode() specifies country codes, and is restricted restricted to the alphabet, 'ccode' is non-admisible"
		exit 198				
	}
}

**error: New or already processed survey
if `new'>1|`new'<0 {
	di as error "new() can only takes values 0 and 1, a value of 'new' is non-admisible"
	exit 198
} 

**error: Auxiliary correspondence table
if `int'>3|`int'<0 {
	di as error "int() can only takes values between 0 and 3, a value of 'int' is non-admisible"
	exit 198
} 
						
// 2. PROCESS SURVEYS

// 2.1 CHECK INPUTS WITH INFORMATION FROM WORKSHEET DATA 
	
**Old Surveys
if `new'==0 {

	**WARNING: Surveys from GDLD repository and the metadata are available only for WB users. 
	di in red "Warning: Surveys from GDLD repository and the metadata are available only for WB users"

	**Import metadata
	import excel "https://github.com/RaimundoSmithM/GDLD/blob/master/Metadata%2012.03.xls?raw=true", firstrow sheet("metadata") clear // Open worksheet
	
	**Transform ccode and survey to uppercase letters
	tempvar aux_ccode aux_survey
	gen `aux_ccode'="`ccode'"
	gen `aux_survey'="`survey'"
	qui replace `aux_ccode'=upper(`aux_ccode')		
	qui replace `aux_survey'=upper(`aux_survey')	
	
// ERRORS: INPUTS DO NOT MATCH WITH WORKSHEET INFORMATION
			
	**error: 'ccode' does not match with information from our data
	cap: assert wbccode!=`aux_ccode'
	if _rc!=9 {
		di as error "Country code `ccode' does not match with country codes from our data"
		exit 198			
	}
	else {
		**error: 'ccode' and 'year' do not match with information from our data				
		qui count if wbccode==`aux_ccode' & year==`year'
		if r(N)==0  {
			di as error "Year `year' does not match with country code `ccode' information from our data"
			exit 198			
		}
		else {
			**error: 'ccode', 'year' and 'survey' do not match with information from our data	
			qui count if wbccode==`aux_ccode' & year==`year' & upper(survey)==`aux_survey'			
			if r(N)==0 {				
				di as error "Survey `survey' does not match country code `ccode' and year `year' information from our data"
				exit 198					
			}
		}
	}
	**Keep obs. that do match with our data
	keep if wbccode==`aux_ccode' & year==`year' & survey==`aux_survey'

	**Warning: Digit of aggregation of industry and occupation similarity with ISIC and ISCO
	foreach k in ind_digit occup_digit {
		local ind_digit_name industrial
		local occup_digit_name occupation
		qui sum `k'_pr
		local `k'_pr=r(sum)
		qui sum `k'
		local `k'_orig=r(sum)
		if `k'!=`k'_pr {
			**Program's warning message about the digit of aggregation that will be used to process the surve
			di in red "Warning: ``k'_name' codes use ``k'_pr' digits of aggregation"
		}
	}
	
	**Consitency between original digit of aggregation and processing digit of aggregation of industry
	tempvar ind_exist occup_exist
	if `ind_digit_pr'==0 & `ind_digit_orig'!=0  {																											
		
		**Program's warning message about the digit of aggregation that will be used to process the survey
		di in red "ind_digit exists in original variable but the variable cannot be processed; check the metadata."			
		qui gen `ind_exist'=0
	}
	else if `ind_digit_pr'==0 & `ind_digit_orig'==0 {
		**Program's warning message about the digit of aggregation that will be used to process the survey
		di in red "ind_digit does not exist in original variable, the variable cannot be processed; check the metadata."									
		qui gen `ind_exist'=0		
	}
	else if `ind_digit_pr'!=0 & `ind_digit_orig'!=0  {																											
		qui gen `ind_exist'=1
	}
	
	**Consitency between original digit of aggregation and processing digit of aggregation of occupation
	if `occup_digit_pr'==0 & `occup_digit_orig'!=0  {																										
		**Program's warning message about the digit of aggregation that will be used to process the survey
		di in red "occup_digit exists in original variable but the variable cannot be processed; check the metadata."
		qui gen `occup_exist'=0
	}	
	else if `occup_digit_pr'==0 & `occup_digit_orig'==0{
		**Program's warning message about the digit of aggregation that will be used to process the survey
		di in red "occup_digit does not exist in original variable, the variable cannot be processed; check the metadata."									
		qui gen `occup_exist'=0		
	}
	else if `occup_digit_pr'!=0 & `occup_digit_orig'!=0  {																										
		qui gen `occup_exist'=1
	}

	qui sum `ind_exist'
	local ind_exist_l=r(mean)
	qui sum `occup_exist'
	local occup_exist_l=r(mean)
	
	**Local indpr and occupdpr
	local indpr=`ind_digit_pr'
	local occupdpr=`occup_digit_pr'

	**Local ind_class and occup_class
	qui sum ind_class_int
	local indclass=r(mean)
	if `ind_digit_pr'!=0 & mi(`indclass') & inlist(`int',0,1) {
		**Program's warning message about the digit of aggregation and industry class that will be used to process the survey
		di in red "industry classification not available, the variable cannot be processed; check the metadata."									/
	}
	
	qui sum occup_class_int
	local occupclass=r(mean)
	if `occup_digit_pr'!=0 & mi(`occupclass') & inlist(`int',0,2) {
		**Program's warning message about the digit of aggregation and industry class that will be used to process the survey
		di in red "occupation classification not available, the variable cannot be processed; check the metadata."									
	}
	
	**CCODE and SURVEY
	local a1="`ccode'"
	local ccode=upper(substr("`ccode'",1,3))
	
	local a2="`survey'"
	local survey=upper(substr("`survey'",1,.))

// 2.2 SURVEY DATA VARIABLES

*Get Survey File

tempfile surveydata
filelist , dir(${surveypath}) pattern(MSI_`ccode'_`year'_`survey'*.dta) save(`surveydata') replace
qui use `surveydata', clear	
local f = dirname + "/" + filename
use "`f'", clear

**Unique Ids
egen gdld_id=group(idh idp)
cap isid gdld_id
if _rc != 0{
	drop gdld_id
	qui gen gdld_id = _n // Create a correlative
}
drop if mi(gdld_id)
	
**Industry and occupation exists in the survey
if `ind_exist_l'==1 & `occup_exist_l'==1 {
	local ind_occup_ex=3
	global i2d2_vars gdld_id industry_orig occup_orig
	keep ${i2d2_vars} 	
	cap replace industry_orig = floor(industry_orig)
	cap replace occup_orig = floor(occup_orig)
					
	tempvar ind_orig_pr occup_orig_pr
	tostring industry_orig occup_orig, gen(`ind_orig_pr' `occup_orig_pr')
	replace `ind_orig_pr'=substr(`ind_orig_pr',1,`ind_digit_pr')
	destring `ind_orig_pr',gen(gdld_ind_orig)
	qui replace `occup_orig_pr'=substr(`occup_orig_pr',1,`occup_digit_pr')
	destring `occup_orig_pr',gen(gdld_occup_orig)
}

**Industry exists in the survey
else if `ind_exist_l'==1 & `occup_exist_l'!=1 {
	local ind_occup_ex=2
	global i2d2_vars gdld_id industry_orig   
	qui keep ${i2d2_vars} 	
	cap replace industry_orig = floor(industry_orig)
		
	tempvar ind_orig_pr 
	qui tostring industry_orig, gen(`ind_orig_pr')
	qui replace `ind_orig_pr'=substr(`ind_orig_pr',1,`ind_digit_pr')
	qui destring `ind_orig_pr',gen(gdld_ind_orig)
}
**Occupation exists in the survey
else if `ind_exist_l'!=1 & `occup_exist_l'==1 {
	local ind_occup_ex=1
	global i2d2_vars gdld_id occup_orig 
	qui keep ${i2d2_vars} 	
	cap replace occup_orig = floor(occup_orig)
		
	tempvar occup_orig_pr
	tostring occup_orig, gen(`occup_orig_pr')
	qui replace `occup_orig_pr'=substr(`occup_orig_pr',1,`occup_digit_pr')
	qui destring `occup_orig_pr',gen(gdld_occup_orig)
}
**Industry and occupation do not exists in the survey
else if `ind_exist_l'!=1 & `occup_exist_l'!=1 {
	di as error "industry_orig and occup_orig do not exist in the data; survey cannot be processed" 
	exit 111
}
} // End if new == 0

// NEW SURVEYS INPUTS
if `new'==1 {

	**New survey data must be open or the program will not run
	qui d
	if r(N)==0 & r(k)==0 {
		di as error "Data not found; survey data must be open before running the command"
		exit 111
	}

	**Program's warning about default arguments 
	di in red "Warning: You should modify optional arguments according to your preferences, or default values will be assigned to each one of them."

	// CHECK IF SURVEY ALREADY EXISTS
	
	preserve
	import excel "https://github.com/RaimundoSmithM/GDLD/blob/master/Metadata%2012.03.xls?raw=true", firstrow sheet("metadata") clear // Open worksheet

	**Transform ccode and survey to uppercase letters
	tempvar aux_ccode aux_survey
	qui gen `aux_ccode'="`ccode'"
	qui gen `aux_survey'="`survey'"
	qui replace `aux_ccode'=upper(`aux_ccode')		
	qui replace `aux_survey'=upper(`aux_survey')			

	count if ccode==`aux_ccode' & year==`year' & survey==`aux_survey'
	if r(N)>0 {
		di as error "`ccode'_`year'_i2d2_`survey'.dta is already processed"
		exit 198
	}
	restore

// ERRORS

	**error: optional arguments should be greater or equal to 0
	foreach k in `ind_occup_ex' `indclass' `occupclass' {
		if `k'<0 {
			di as error "Optional arguments must be greater than or equal to zero"
			exit 198	
		}
	}

	**error: Industry and occupation existence variables			
	if `ind_occup_ex'>3 {
		di as error "ind_occup_ex() can only take values between 0 and 3, 'ind_occup_ex()' is non-admisible"
		exit 198
	}
	**error: Industry classification system must be less than 7
	if `indclass'>6 {
		di as error "indclass() must be less than 7, 'indclass()' is non-admisible"
		exit 198
	}
	**error: Occupation classification system must be less than 4			
	if `occupclass'>3 {
		di as error "occupclass() must be less than 4, 'occupclass()' is non-admisible"
		exit 198
	}

// CREATE AND REPLACE VARIABLES WITH INPUT VALUES
	
	**ID's of the survey should be specified as inputs
	egen gdld_id=group(`id_survey')
	cap: assert gdld_id==1
	if _rc!=9 {
		drop gdld_id
		di as error "id_survey() should be specified as an input"
		exit 198
	}
	else {
		qui gen ccode="`ccode'" 						// WB country code
		qui gen year=`year'								// Year of the survey
		qui gen survey="`survey'" 						// Survey acronym
		qui gen gdld_ind_orig=""						// Industry variable 
		qui gen gdld_occup_orig=""						// Occupation variable
	}
	qui drop if mi(gdld_id)
	
	// INDUSTRY AND OCCUPATION VARIABLES EXISTENCE
		**Case 1: Both variables exists in the data
		if  `ind_occup_ex'==3  {

			**Existence `indname' and `occupname'
			tempvar indname_aux occupname_aux
			qui egen `indname_aux'=group(`indname')
			qui egen `occupname_aux'=group(`occupname')
			cap: assert `indname_aux'==1
			if _rc!=9 {
				drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "indname() should be specified as an input"
				exit 198
			}	
			cap: assert `occupname_aux'!=.
			if _rc!=9 {
				qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "occupname() should be specified as an input"
				exit 198
			}

			**Digits of aggregation of industry and occupation 						
			
				*Industry digit of aggregation
				if inlist("`indpr'","1","2","3","4","sec") !=1 {
					qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
					di as error "indpr()  must be 1, 2, 3, 4 or sec, 'indpr()' is non-admisible"
					exit 198
				}
				else if inlist("`indpr'","1","2","3","4") == 1 {					
					local indpr_aux=real("`indpr'")
				}
				else if inlist("`indpr'","sec") == 1 {								
					sort `indname'
					*encode `indname', replace 
					local indpr_aux=2
				}
				*Occupation digit of aggregation
				if inlist(`occupdpr',1,2,3,4) != 1 {
					qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
					di as error "occupdpr() must be between 1 and 4, 'occupdpr()' is non-admisible"
					exit 198
				}
			**Existence of industry and occupation variables
			foreach k in `indname' `occupname' {
			
			// MISSING VALUES
				qui count if `k'!=.
				if r(N)==0 {
					qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
					di as error "`k'() has no observations"
					exit 111
				}
				else tostring `k', replace
			}
			**Keep relevant aggregation digits to match international classifications
			qui replace gdld_ind_orig=substr(`indname', 1,`indpr_aux') 							
			qui replace gdld_occup_orig=substr(`occupname', 1,`occupdpr')
			qui destring gdld_ind_orig gdld_occup_orig, replace
			qui destring `indname' `occupname', replace
		}

		**Case 2: Industry variable exists but not occupation
		else if `ind_occup_ex'==2 {
			**Existence `indname' and `occupname'
			tempvar indname_aux 
			qui egen `indname_aux'=group(`indname')
			cap: assert `indname_aux'==1
			if _rc!=9 {
				qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "indname() should be specified as an input"
				exit 198
			}
			**Digits of aggregation of industry and occupation 							
			
				*Industry digit of aggregation
				if inlist("`indpr'","1","2","3","4","sec") !=1 {
					qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
					di as error "'indpr()'  must be 1, 2, 3, 4 or sec"
					exit 198
				}
				else if inlist("`indpr'","1","2","3","4") == 1 {						
					local indpr_aux=real("`indpr'")
				}
				else if inlist("`indpr'","sec") == 1 {								
					sort `indname'
					local indpr_aux=2
				}

		// MISSING VALUES
			qui count if `indname'!=.
			if r(N)==0 {
				drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "`indname'() has no observations"
				exit 111
			}
			else tostring `indname', replace
			if inlist(`indpr',1,2,3,4) == 1 replace gdld_ind_orig=substr(`indname', 1,`indpr_aux') 
			qui destring gdld_ind_orig, replace
			qui destring `indname' , replace
		}

		**Case 3: Occupation variable exists but not industry
		else if `ind_occup_ex'== 1 {
		
			**Existence `indname' and `occupname'
			tempvar occupname_aux
			qui egen `occupname_aux'=group(`occupname')
			cap: assert `occupname_aux'!=.
			if _rc!=9 {
				qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "occupname() should be specified as an input"
				exit 198
			}
	
		// MISSING VALUES
			qui count if `occupname'!=.
			if r(N)==0 {
				qui drop ccode year survey gdld_id gdld_ind_orig gdld_occup_orig
				di as error "`occup_name' has no observations"
				exit 111
			}
			else tostring `occupname', replace	
			qui replace gdld_occup_orig=substr(`occupname', 1,`occupdpr')
			qui destring gdld_occup_orig, replace
		}
		qui keep gdld_id ccode year survey gdld_ind_orig gdld_occup_orig // keep relevant variables for concordance computation
					
	**Replace variables with new survey values  
	qui replace ccode=upper("`ccode'")  					// Country code
	qui replace year=`year' 								// Year
	qui replace survey=upper("`survey'") 					// Survey	

} // End if new == 1

// 3. LOCAL INDUSTRY CLASSIFICATION - ISIC 

**Local concordance table with ISIC Rev.4

if `int'==0 {
	**Surveys available in GDLD repository
	if `new'==0 {
		**Confirm existence of local industry concordance table
		capture confirm file "${additionaltablespath}`ccode'_`year'_`survey'_isic4_concordance.dta"			
		if _rc==0 {
			di as error "Concordance table between local classification and ISIC Rev. 4 is available in GDLD repository; int(0) is not valid"
			exit 111
		}	
	}
} // End if int == 0

if `int'==2|`int'==3 {
	
	**Surveys available in GDLD repository
	if `new'==0 {
		**Confirm existence of local industry concordance table
		
		*capture confirm file "~/local_concordance/`ccode'_`year'_`survey'_isic4_concordance.dta"
		capture confirm file "${additionaltablespath}`ccode'_`year'_`survey'_isic4_concordance.dta"			
		if _rc!=0 {
			di as error "Concordance table between local classification and ISIC Rev. 4 is not available in GDLD repository"
			exit 111
		}	
	}
	**New surveys
	else {
		**Confirm existence of local industry concordance table	
		
		*capture confirm file "~/local_concordance/`ccode'_`year'_`survey'_isic4_concordance.dta"
		capture confirm file "`ccode'_`year'_`survey'_isic4_concordance.dta"			
		if _rc!=0 {
			di as error "Concordance table between local classification and ISIC Rev. 4 is not available in current directory"
			exit 111
		}
	}
	**Local to save local concordance table with ISIC Rev. 4
	local isic4_concordance: dir . files "`ccode'_`year'_`survey'_isic4_concordance.dta" 
}
**International concordance table with ISIC Rev.4
else {
	di in red "${outdir}"
	# d ;
	qui call_ind_concordances, 
		ind_occup_ex(`ind_occup_ex') 
		outdir(${outdir}) 	
		indclass(`indclass') 
		inddpr(`indpr')
		int(`int')						
	;
	# d cr
}

// 4. LOCAL OCCUPATION CLASSIFICATION - ISCO 

**Local concordance table with ISCO-08

if `int'==0 {
	**Surveys available in GDLD repository
	if `new'==0 {
		**Confirm existence of local occupation concordance table
		capture confirm file "${additionaltablespath}`ccode'_`year'_`survey'_isco08_concordance.dta"			
		if _rc==0 {
			di as error "Concordance table between local classification and ISCO-08 is available in GDLD repository; int(0) is not valid"
			exit 111
		}		
	}
}

if `int'==1|`int'==3 {
	if `new'==0 {
		
		**Confirm existence of local occupation concordance table
		capture confirm file "${additionaltablespath}`ccode'_`year'_`survey'_isco08_concordance.dta"			
		if _rc!=0 {
			di as error "Concordance table between local classification and ISCO-08 is not available in GDLD repository"
			exit 111
		}	
	}
	else {
		**Confirm existence of local occupation concordance table	
		
		*capture confirm file "~/local_concordance/`ccode'_`year'_`survey'_isico08_concordance.dta"
		capture confirm file "`ccode'_`year'_`survey'_isco08_concordance.dta"			
		if _rc!=0 {
			di as error "Concordance table between local classification and ISCO-08 is not available in current directory"
			exit 111
		}
	}
	**Local to save local concordance table with ISCO-08
	local local_isco08_concordance: dir . files "`ccode'_`year'_`survey'_isco_concordance.dta" 
}
**International concordance table with ISCO-08
else {
	# d ;
	qui call_occup_concordances, 
		ind_occup_ex(`ind_occup_ex') 
		outdir(${outdir}) 	
		occupclass(`occupclass') 
		occupdpr(`occupdpr') 
		int(`int')
	;
	# d cr
}


// 4. TRADEWEIGTHS
if inlist(`ind_occup_ex',2,3){
# d ;
qui tradeweights, 
ccode(`ccode') 
year(`year')
inddpr(`indpr') 
tabdir(${tabdir})
outdir(${outdir})
;
# d cr
local has_tradeweights = `r(has_tradeweights)'
}

// 6. INDUSTRY PROCESSING 

if inlist(`ind_occup_ex',2,3){
# d ;
qui assign_gtap, 
	ccode(`ccode') 
	year(`year')
	survey(`survey')
	outdir(${outdir}) 
	tabdir(${tabdir}) 
	has_tradeweights(`has_tradeweights') 
	inddpr(`indpr')
	int(`int')
;
# d cr
}

// 7. OCCUPATION PROCESSING

if inlist(`ind_occup_ex',1,3){
# d ;
qui assign_isco,
	outdir(${outdir}) 
	ccode(`ccode')
	year(`year')
	survey(`survey')
	int(`int')
;
# d cr
}


// 8. MATCHING REPORT 
# d ;
qui extra_variables_and_report,
	ccode(`ccode')
	year(`year')
	survey(`survey')
	inddpr(`indpr') 
	occupdpr(`occupdpr')
	tabdir(${tabdir})
	ind_occup_ex(`ind_occup_ex')
	outdir(${outdir})
;
# d cr

// 9. AUXILIARY CONCORDANCE CODES 
capture confirm file "${gdldpath}Aux do files/MSI_`ccode'_`year'_`survey'_aux.do"			
if _rc==0 {
	**Program's warning about default arguments 
	di in red "Warning: An additional code is available for file `ccode'_`year'_I2D2_`survey'.dta, this file computes the correspondence between local classifications and GTAP in cases where official correspondence do not have a good match (less than 90%)."
	do "${gdldpath}Aux do files/MSI_`ccode'_`year'_`survey'_aux.do"
}

// 10. LABELS

cd "${outdir}"

# d ;
qui labels,
ccode(`ccode')
year(`year')
survey(`survey')
outdir(${outdir})
;
# d cr


cd "${outdir}"

di in red "## END GDLD PROGRAM ; inddpr(`indpr') ; occupdpr(`occupdpr') ##"
}
end
