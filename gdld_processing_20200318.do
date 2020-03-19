********************************************************************************
* GDLD Processing Revision
*******************************************************************************

// Setup

*Initialize
clear all
macro drop all 

********************************************************************************
* Set Globals
*******************************************************************************

// Local Paths

*Set Global Path
if "`c(username)'" == "raimu" global gdldpath "D:/Dropbox/Trabajos/World Bank/GDLD/"
if "`c(username)'" == "Cristian" global gdldpath "C:/Users/Cristian/Dropbox (Personal)/GDLD/"
if "`c(username)'" == "..." global gdldpath "..."

*Ado Files
adopath ++ "${gdldpath}Code/ado/"

*Processed Dataset
global outdir "${gdldpath}GDLD Processing/"

*Concordance Tables
global tabdir "${gdldpath}Concordance Tables/All Concordances/"

*Auxiliar Concordance Tables
global additionaltablespath "${gdldpath}Concordance Tables/All Concordances/additional_concordances/"

*I2D2 Surveys
global surveypath "${gdldpath}All in One/"

*Auxiliar Do Files
global auxfilespath "${gdldpath}Aux do files/"

*Metadata
global metadatapath "${gdldpath}Metadata/"

*Metadata Worksheet
global metadatafile "Metadata 15.03 with changes .xls"

*Assignement
global docdir "${gdldpath}Documents/"

*Log File
cap log close
log using "${outdir}gdld_processing_revision.txt", replace

********************************************************************************
* Setup
********************************************************************************

** Report
file open r using "${outdir}Output/revision_ccode_run_log.txt", write replace
file write r "ccode;result" _n

** Processing Program
cap program drop gdld_processing
program define gdld_processing
{
syntax, Ccode(str) Year(int) Survey(str) New(real) INT(real)
if $fullrun == 1 cap noi gdld_class, ccode(`ccode') year(`year') survey(`survey') new(`new') int(`int')
local result = _rc

file write r "`ccode';`result'" _n
cd "${outdir}"
}
end

** Output Directory
cd "${outdir}"

** Running Setup
global fullrun = 1
set trace off

********************************************************************************
* Sin Código Error
********************************************************************************

gdld_processing, ccode(AGO) year(2014) survey(CENSUS) new(0) int(0)
gdld_processing, ccode(AZE) year(2015) survey(AMSSW) new(0) int(0)
gdld_processing, ccode(BFA) year(2014) survey(EMC) new(0) int(0)
gdld_processing, ccode(BOL) year(2015) survey(EH) new(0) int(0)
gdld_processing, ccode(BRA) year(2015) survey(PNAD) new(0) int(2)
gdld_processing, ccode(BWA) year(2009) survey(BCWIS) new(0) int(0)
gdld_processing, ccode(CHL) year(2015) survey(CASEN) new(0) int(0)
gdld_processing, ccode(CHN) year(2013) survey(CGSS) new(0) int(3)
gdld_processing, ccode(COL) year(2017) survey(GEIH) new(0) int(2)
gdld_processing, ccode(DOM) year(2015) survey(ENFT) new(0) int(0)
gdld_processing, ccode(ECU) year(2015) survey(ENEMDU) new(0) int(0)
gdld_processing, ccode(EGY) year(2005) survey(ELMPS) new(0) int(0)
gdld_processing, ccode(GHA) year(2012) survey(GHA) new(0) int(0)
gdld_processing, ccode(GHA) year(2012) survey(LSS) new(0) int(0)
gdld_processing, ccode(GMB) year(2015) survey(IHS) new(0) int(0)
gdld_processing, ccode(GTM) year(2014) survey(ENCOVI) new(0) int(0)
gdld_processing, ccode(HND) year(2014) survey(EPHPM) new(0) int(0)
gdld_processing, ccode(HTI) year(2007) survey(EEEI) new(0) int(0)
gdld_processing, ccode(HUN) year(2008) survey(HBS) new(0) int(0)
gdld_processing, ccode(IDN) year(2009) survey(SAKERNAS) new(0) int(0)
gdld_processing, ccode(IRQ) year(2012) survey(HSES) new(0) int(0)
gdld_processing, ccode(JOR) year(2016) survey(LFS) new(0) int(0)
gdld_processing, ccode(KEN) year(2005) survey(IHBS) new(0) int(0)
gdld_processing, ccode(KHM) year(2012) survey(CLFCLS) new(0) int(0)
gdld_processing, ccode(KSV) year(2014) survey(LFS) new(0) int(0)
gdld_processing, ccode(LBR) year(2014) survey(HIES) new(0) int(0)
gdld_processing, ccode(MDA) year(2015) survey(LFS) new(0) int(0)
gdld_processing, ccode(MDV) year(2009) survey(HIES) new(0) int(0)
gdld_processing, ccode(MLI) year(2010) survey(EPAM) new(0) int(0)
gdld_processing, ccode(MMR) year(2005) survey(IHLCA) new(0) int(0)
gdld_processing, ccode(MNE) year(2011) survey(LFS) new(0) int(0)
gdld_processing, ccode(MNG) year(2014) survey(LFS) new(0) int(0)
gdld_processing, ccode(MUS) year(2012) survey(HBS) new(0) int(0)
gdld_processing, ccode(MWI) year(2013) survey(LFS) new(0) int(0)
gdld_processing, ccode(NER) year(2014) survey(ECVMA) new(0) int(0)
gdld_processing, ccode(NIC) year(2014) survey(EMNV) new(0) int(0)
gdld_processing, ccode(NPL) year(2010) survey(LSS) new(0) int(0)
gdld_processing, ccode(PER) year(2015) survey(ENAHO) new(0) int(0)
gdld_processing, ccode(PHL) year(2013) survey(LFS) new(0) int(0)
gdld_processing, ccode(POL) year(2011) survey(HBS) new(0) int(0)
gdld_processing, ccode(ROM) year(2013) survey(HBS) new(0) int(0)
gdld_processing, ccode(RUS) year(2016) survey(RMLS) new(0) int(2)
gdld_processing, ccode(SDN) year(2009) survey(NBHS) new(0) int(0)
gdld_processing, ccode(SLB) year(2005) survey(HIES) new(0) int(0)
gdld_processing, ccode(SLV) year(2014) survey(EHPM) new(0) int(0)
gdld_processing, ccode(SVN) year(2004) survey(HBS) new(0) int(0)
gdld_processing, ccode(SYC) year(2006) survey(HBS) new(0) int(0)
gdld_processing, ccode(THA) year(2011) survey(HSES) new(0) int(0)
gdld_processing, ccode(TJK) year(2013) survey(JMSC) new(0) int(0)
gdld_processing, ccode(TUN) year(2010) survey(HBS) new(0) int(0)
gdld_processing, ccode(TUR) year(2015) survey(HLFS) new(0) int(0)
gdld_processing, ccode(TZA) year(2011) survey(HBS) new(0) int(0)
gdld_processing, ccode(URY) year(2015) survey(ECH) new(0) int(0)
gdld_processing, ccode(VNM) year(2010) survey(LFS) new(0) int(0)
gdld_processing, ccode(AFG) year(2013) survey(ALCS) new(0) int(0) 
gdld_processing, ccode(BGD) year(2010) survey(HIES) new(0) int(0) 
gdld_processing, ccode(BLR) year(2016) survey(LFS) new(0) int(0) 
gdld_processing, ccode(CRI) year(2012) survey(ENAHO) new(0) int(0) 
gdld_processing, ccode(DJI) year(2015) survey(EDESIC) new(0) int(2) 
gdld_processing, ccode(LKA) year(2016) survey(HIES) new(0) int(0) 
gdld_processing, ccode(MAR) year(2009) survey(ENSLE) new(0) int(0) 
gdld_processing, ccode(MEX) year(2010) survey(ENIGH) new(0) int(0) 
gdld_processing, ccode(MOZ) year(2014) survey(IOF) new(0) int(0) 
gdld_processing, ccode(UGA) year(2016) survey(UNHS) new(0) int(0) 

********************************************************************************
* Codigo Error: 111
********************************************************************************

gdld_processing, ccode(BEN) year(2015) survey(EMICOV) new(0) int(0)
gdld_processing, ccode(BGR) year(2007) survey(MTHS) new(0) int(0)
gdld_processing, ccode(CAF) year(2008) survey(ECASEB) new(0) int(0)
gdld_processing, ccode(CIV) year(2015) survey(ENV) new(0) int(0)
gdld_processing, ccode(CMR) year(2014) survey(ECAM) new(0) int(0)
gdld_processing, ccode(COG) year(2011) survey(ECOM) new(0) int(0)
gdld_processing, ccode(CPV) year(2007) survey(QUIBB) new(0) int(0)
gdld_processing, ccode(DJI) year(2015) survey(EDESIC) new(0) int(0)
gdld_processing, ccode(ETH) year(2016) survey(UEUS) new(0) int(0)
gdld_processing, ccode(GNB) year(2010) survey(ILAP) new(0) int(0)
gdld_processing, ccode(GUY) year(1999) survey(SLC) new(0) int(0)
gdld_processing, ccode(KGZ) year(2011) survey(IHS) new(0) int(0)
gdld_processing, ccode(LAO) year(2007) survey(ECS) new(0) int(0)
gdld_processing, ccode(LBN) year(2011) survey(LFS) new(0) int(0)
gdld_processing, ccode(LSO) year(2010) survey(HBS) new(0) int(0)
gdld_processing, ccode(MDG) year(2012) survey(ENSOMD) new(0) int(0)
gdld_processing, ccode(MRT) year(2014) survey(EPCV) new(0) int(0)
gdld_processing, ccode(NAM) year(2015) survey(NHIES) new(0) int(0)
gdld_processing, ccode(PRI) year(2005) survey(CENSUS) new(0) int(0)
gdld_processing, ccode(PRY) year(2007) survey(EPH) new(0) int(0)
gdld_processing, ccode(RWA) year(2013) survey(EICV) new(0) int(0)
gdld_processing, ccode(SOM) year(2016) survey(HFS) new(0) int(0)
gdld_processing, ccode(SRB) year(2013) survey(HBS) new(0) int(0)
gdld_processing, ccode(STP) year(2010) survey(IOF) new(0) int(0)
gdld_processing, ccode(TGO) year(2015) survey(QUIBB) new(0) int(0)
gdld_processing, ccode(UKR) year(2013) survey(HLCS) new(0) int(0)
gdld_processing, ccode(UZB) year(2003) survey(HBS) new(0) int(0)
gdld_processing, ccode(VEN) year(2006) survey(EHM) new(0) int(0)
gdld_processing, ccode(mhl) year(1999) survey(census) new(0) int(0)

********************************************************************************
* Codigo Error: 198
********************************************************************************

gdld_processing, ccode(SSD) year(2009) survey(NBHS) new(0) int(0)

********************************************************************************
* Codigo Error: 601
********************************************************************************

gdld_processing, ccode(NGA) year(2010) survey(GHS (HARVEST)_2) new(0) int(0)

********************************************************************************
* Codigo Error: 909
********************************************************************************

gdld_processing, ccode(FJI) year(2008) survey(HIES) new(0) int(0)


** End Processing
cap log close
file close r
