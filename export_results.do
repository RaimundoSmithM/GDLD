// Report

use "D:\Dropbox\Trabajos\World Bank\GDLD\GDLD Processing\Output\Reports.dta", clear

// Labels
keep country survey year sample_size hasindustry nuniqueindustry hasisic nuniqueisic hasgtap hasoccup nuniqueoccup hasisco nuniqueisco ind_matched_share occup_matched_share
lab var country "Country"
lab var survey "Survey"
lab var year "Year"
lab var sample_size "Survey Sample Size"
lab var hasindustry "Non-Missing Industry Codes"
lab var nuniqueindustry "Unique Non-Missing Industry Codes"
lab var hasisic "Non-Missing ISIC Rev 4 Codes"
lab var nuniqueisic "Unique Non-Missing ISIC Rev 4 Codes"
lab var hasgtap "Non-Missing GTAP"
lab var hasoccup "Non-Missing Occupation Codes"
lab var nuniqueoccup "Unique Non-Missing Occupation Codes"
lab var hasisco "Non-Missing ISCO 08 Codes"
lab var nuniqueisco "Unique Non-Missing ISCO 08 Codes"
lab var ind_matched_share "% of Matched Industry Codes"
lab var occup_matched_share "% of Matched Occupation Codes"

compress
sort country
save "D:\Dropbox\Trabajos\World Bank\GDLD\GDLD Processing\Output\Matching_Report.dta", replace
export excel using "D:\Dropbox\Trabajos\World Bank\GDLD\GDLD Processing\Output\Matching_Report.xlsx", replace firstrow(varlabels)
