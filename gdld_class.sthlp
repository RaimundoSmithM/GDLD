{smcl}
{* *! version 1.0 17mar2020 }{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "gdld_class##syntax"}{...}
{viewerjumpto "Description" "gdld_class##description"}{...}
{viewerjumpto "Tradeweights" "gdld_class##tradeweights"}{...}
{viewerjumpto "Options" "gdld_class##options"}{...}
{viewerjumpto "Inputs and auxiliary files" "gdld_class##tables"}{...}
{viewerjumpto "Examples" "gdld_class##examples"}{...}
{title:Title}

{phang}
{bf:gdld_class} {hline 2} Concordance between industry/occupation and international classifications (ISIC/GTAP/ISCO)


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:gdld_class}, {it:ccode(str) year(int) survey(string) new(real) int(real) [id_survey(varlist) ind_occup_ex(real) indname(varname) indclass(int) indpr(str) occupname(varname) occupclass(int) occupdpr(str)]}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main arguments}
{synopt:{opt c:code(string)}}World Bank's Country Code {p_end}
{synopt:{opt y:ear(#)}}Year of the survey{p_end}
{synopt:{opt s:urvey(string)}}Survey acronym{p_end}
{synopt:{opt n:ew(#)}}Identifies new surveys in the GDLD system{p_end}
{synopt:{opt i:nt(#)}}Identifies surveys with local industry/occupation classifications different from international standard classifications{p_end}

{syntab:Optional arguments}
{synopt:{opt id:survey(varlist)}}Unique identifiers used in the (new)survey to be proccesed{p_end}
{synopt:{opt ind_occup_ex(#)}}Identifies the existence of industry and occupation variables in the survey.{p_end}
{synopt:{opt indn:name(varname)}}Identifies industry variable in the new survey to be processed{p_end}
{synopt:{opt indc:lass(#)}}Identifies the international classification followed by the industry variable in the survey{p_end}
{synopt:{opt indp:r(string)}}Digit of aggregation used to processed industry variable in the survey{p_end}
{synopt:{opt occupn:ame(#)}}Identifies occupation variable in the new survey to be processed{p_end}
{synopt:{opt occupc:lass(#)}}Identifies the international classification followed by the occupation variable in the survey{p_end}
{synopt:{opt occupd:pr(#)}}Digit of aggregation used to processed occupation variable in the survey{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gdld_class} Computes the correspondence between local industry/occupation classifications and international classifications (ISIC/GTAP/ISCO). In the case of industry, it 
				 matches local codes with ISIC Rev. 4, and then matches those codes with GTAP codes. While in the case of occupation, it matches local codes with 
				 ISCO-08 codes. It also reports the level (%) of precision of the match performed by the program and, in the case of industry, it generates variables with the match using 
				 a lower digit of aggregation that the one of the original variable. The command is flexible enough to compute the correspondence of surveys that are not in the GDLD repository. 
				 However, if additional correspondece tables are needed to match codes, they must be used (or uploaded to the repository) before runnning the program.

{marker tradeweights}{...}
{title:Tradeweights}

{pstd}				 
	In most cases, the correspondence between local industry codes and ISIC Rev. 4 is a many to many concordance table. 
	This implies that a local industry code can be assigned to several ISIC Rev. 4 codes and viceversa.
	We use country level yearly data for each ISIC Rev. 4 industry on export flows to improve the quality of our assignation procedure. 
	This data comes from the {browse "https://wits.worldbank.org/":Wits datasets}.
	The algorithm increases the likelihood of assigning locally relevant ISIC Rev. 4 industries to local industries when 
	there are more than one ISIC Rev. 4 code per local industry code. Local codes that have no correspondence with {browse "https://wits.worldbank.org/":Wits datasets}
	will not be assigned to a GTAP code. 
	
{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt ccode(string)} Identifies the country of the survey that is going to be used

{phang}
{opt year(#)} Identifies the year of the survey.

{phang}
{opt survey(string)} Identifies the acronym of the survey.

{phang}
{opt new(#)} Identifies if the survey that is being used to computes the correspondence is already in the GDLD repository or not.
			 The option can take two values: 0 if the survey is in the GDLD repository; or 1 if it is a "new" survey. Surveys in the GDLD
			 repository (0) comes from the I2D2 project and can only be used by World Bank's users. 
			 
{phang}
{opt int(#)} Identifies surveys with local industry/occupation classifications different from international standard classifications. Particularly, 
			 each value of the option identifies if the survey uses an 'additional' correspondence table between the local classification and ISIC Rev. 4
			 in the case of industry, and between local classification and ISCO-08 in the case of occupation. The option can take 4 values:
			 0 if the survey do not use 'special' correspondence tables; 1 if the survey use and additional table for occupation; 2 if the survey
			 uses an additional table in the case of industry; and 3 if the survey uses additional tables for industry and occupation. 

{dlgtab:Option arguments (Required for new surveys)}

{phang}
{opt idsurvey(varlist)} Unique identifiers used in the (new)survey to be proccesed. Surveys from the GDLD repository do not required this option because I2D2 uses the same identifiers in all
						of their surveys. If the user do not specify this option when trying to run the command to process a new survey, the program will display an error message.

{phang}
{opt ind_occup_ex(#)} User must specify if industry and occupation variables exist in the survey that wants to be process. The option can take three values: 1 if only occupation exists in the 
					  survey; 2 if only industry exist in the survey; and 3 if both variables exists in the survey (default).

{phang}
{opt indname(varname)} Name of industry variable in the survey that is going to be processed. User can only specify one variable and it must be numeric. In other case, it will
					   display an error message. 

{phang}
{opt indclass(#)} Identifies the international classification followed by the industry variable in the survey. The option can take 7 different values depending on the international
				  classification that matches with local industry classification: 1 corresponds to ISIC Rev. 2; 2 to ISIC Rev. 3; ISIC Rev. 3.1; 4 to ISIC Rev. 4 (default); 5  to NAICS;
				  6 to NACE 1.1; and 7 to NACE 2. 
						 
{phang}
{opt indpr(string)} Identifies the digit of aggregation that was used to processed the industry variable in the survey. This input is necesary for processing new surveys, as sometimes
				 local classifications correspondence with international classifications are only valid for some digits (e.g industry variable in HND_2014_EPHPM is disaggregated at 7
				 digits, but only the first 4 are necesary for the correspondence with ISIC Rev. 4.) The input can take 5 values depending on the level of aggregation of the original
				 variable: 4 if the first four digits are valid for the correspondence with ISIC Rev. 4; 3 if the first three digits are valid; 2 if the first two digits are valid; 1 
				 if the original variable is disaggregated at 1-digit using a classification from 1 to 10; and "sec" which corresponds to a 1-digit disaggregation that matches
				 with the 22 sections of ISIC Rev. 4. 
				 
{phang}
{opt occupname(varname)} Name of occupation variable in the survey that is going to be processed. User can only specify one variable and it must be numeric. In other case, it will
					     display an error message. 

{phang}
{opt occupclass(#)} Identifies the international classification followed by the occupation variable in the survey. The option can take 3 values depending on the international
					classification that matches with local occupation classification: 1 corresponds to ISCO-88; 2 corresponds to ISCO-08 (default) and 3 to SOC.
			 
{phang}
{opt occupdpr(string)} Identifies the digit of aggregation that was used to processed the occupation variable in the survey. This input is necesary for processing new surveys, as sometimes
				 local classifications correspondence with international classifications are only valid for some digits (e.g occupation variable in HND_2014_EPHPM is disaggregated at 6
				 digits, but only the first 4 are necesary for the correspondence with ISCO-08.) The input can take 4 values depending on the level of aggregation of the original
				 variable: 4 if the first four digits are valid for the correspondence with ISCO-08; 3 if the first three digits are valid; 2 if the first two digits are valid; 1 
				 if the original variable is disaggregated at 1-digit using a classification from 1 to 10. 

{marker tables}{...}
{title:Inputs and auxiliary files}

{phang}
Correspondence tables, the metadata and auxiliary files used as inputs by the command
can be found on this {browse "https://github.com/RaimundoSmithM/GDLD":link}
				 

{marker examples}{...}
{title:Examples}

{phang}{cmd:. gdld_class, cccode(CHL) year(2015) survey(CASEN) new(0) int(0)}{p_end}

{phang}{cmd:. gdld_class, cccode(CHN) year(2013) survey(CGSS) new(0) int(3)}{p_end}

{phang}{cmd:. gdld_class, cccode(COL) year(2017) survey(GEIH) new(0) int(2)}{p_end}

{phang}{cmd:. gdld_class, cccode(CHL) year(2017) survey(CASEN) new(1) int(0) id_survey(folio o) ind_occup_ex(3) indname(industry) indclass(4) indpr(4) occupname(occup) occupclass(2) occupdpr(4) }{p_end}

