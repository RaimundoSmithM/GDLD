********************************************************************************
* Clean Up Stage
********************************************************************************
cap program drop labels
program define labels
{
syntax, ccode(str) year(str) survey(str) outdir(str)
// List of Variables
# d ;
global keeplist 
/*ccode 
year 
survey*/ 
gdld_id 
gdld_occup_orig 
gdld_ind_orig 
isco_08_1dig
isco_08_2dig
isco_08_3dig
isco_08_4dig
isic_rev4_secdig 
isic_rev4_1dig 
isic_rev4_2dig 
isic_rev4_3dig 
isic_rev4_4dig
gtap_v10
;
# d cr

// List of Labels
local ccode_l "Country Code"
local year_l "Year"
local survey_l "Survey"
local gdld_id_l "GDLD Person Level Id"
local gdld_occup_orig_l "Original Occupation Codes"
local gdld_ind_orig_l "Original Industry Codes"

local isco_08_1dig_l "ISCO 08 Codes (1 Digit)"
local isco_08_2dig_l "ISCO 08 Codes (2 Digit)"
local isco_08_3dig_l "ISCO 08 Codes (3 Digit)"
local isco_08_4dig_l "ISCO 08 Codes (4 Digit)" 

local isic_rev4_secdig_l "ISIC Rev 4 Codes (Section)"
local isic_rev4_1dig_l "ISIC Rev 4 Codes (1 Digit)"  
local isic_rev4_2dig_l "ISIC Rev 4 Codes (2 Digit)"
local isic_rev4_3dig_l "ISIC Rev 4 Codes (3 Digit)"
local isic_rev4_4dig_l "ISIC Rev 4 Codes (4 Digit)"

local gtap_v10_l "GTAP Version 10 Industry Codes"

// Label GTAP Codes
# d ;
lab def lblindustry_gtap 1 "Paddy rice" 2 "Wheat" 3 "Cereal grains, n.e.s."
4 "Vegetables, fruits, nuts" 5 "Oil seeds" 6 "Sugar cane and sugar beet" 
7 "Plant-based fibers" 8 "Crops, n.e.s." 9 "Bovine cattle, sheep and goats, horses"
10 "Animal products n.e.s." 11 "Raw milk" 12 "Wool, silk-worm cocoons" 13 "Forestry"
14 "Fishing" 15 "Coal" 16 "Oil" 17 "Gas" 18 "Minerals n.e.s."
19 "Bovine meat products" 20 "Meat products n.e.s." 21 "Vegetable oils and fats"
22 "Dairy products" 23 "Processed rice" 24 "Sugar" 25 "Food products n.e.s."
26 "Beverages and tobacco products" 27 "Textiles" 28 "Wearing apparel"
29 "Leather products" 30 "Wood products" 31 "Paper products, publishing"
32 "Petroleum, coal products" 33 "Chemicals and chemical roducts" 34 "Pharmaceutical and medical products"
35 	"Rubber and plastic prodcuts" 36 "Mineral products n.e.s." 37 "Ferrous metals" 38 "Metals n.e.s."
39 "Metal products"  40 "Electronic equipment" 41 "Electrical equipment" 42 "Machinery and equipment n.e.s."
43 "Machinery and equipment" 44 "Transport equipment n.e.s." 45 "Manufactures n.e.s."
46 "Electricity" 47 "Gas manufacture, distribution" 48 "Water" 49 "Construction" 
50 "Trade" 51 "Accomodation, food and beverage services" 52 "Transport n.e.s." 53 "Water transport" 54 "Air transport"
55 "Warehousing" 56 "Communication" 57 "Financial services n.e.s." 58 "Insurance" 59 "Real State"
60 "Business services n.e.s." 61 "Recreational and other services"
62 "Public administration and defence, compulsory social security" 63 "Education" 64 "Human health and social activies"
65 "Dwellings", replace
;
# d cr
cap confirm variable gtap_v10, exact
if _rc == 0 lab val gtap_v10 lblindustry_gtap

// Tag and Label Available Variables
local keeplist
foreach var in $keeplist{
	cap confirm variable `var', exact
	if _rc == 0{
		local keeplist `keeplist' `var'
		lab var `var' "``var'_l'"
	}
}

*Keep relevant set
keep `keeplist'
order `keeplist'
compress
drop if mi(gdld_id)
sort gdld_id, stable
isid gdld_id, sort
save "`outdir'/update_MSI_`ccode'_`year'_`survey'", replace
}
end
