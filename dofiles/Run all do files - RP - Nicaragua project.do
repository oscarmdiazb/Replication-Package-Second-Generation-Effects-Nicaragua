/*
******** ****************************************************
Dofile to reproduce all the  tables in 
Second Generation Effects of an Experimental Conditional
Cash Transfer Program on Early Childhood Human Capital in
Nicaragua
Tania Barham, Oscar Díaz, Karen Macours, John A. Maluccio, Julieta Vera Rueda
******** ****************************************************

*/ 

** Input data sets 
use "${datainput}/HH_INDI/hh_level_v3.dta", clear
* dropped ID vars  i10 encuest_cod super_cod comarca1 comun2 dirviv1 comarcaa comunidada gps* dirviva
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear
* dropped ID vars p1 s1p2b  s1p6 s1p15a s1p16 s1p15a s1p32 s1p33a  
use "${datainput}/indi_2020_below7_v2.dta", clear
* dropped ID vars i03a a_ge04 a_ge03 a_ge07 a_ge09 a_ge10 a_ge10a a_i01 a_i02 s1p15a s1p15a_cod s1p15b s1p15b_cod s1p15c s1p15c_cod s1p15d s1p15d_cod
use "${datainput}/a19a_c.dta", clear
use "${datainput}/anthro_older_z.dta", clear
use "${datainput}/baseline_balance_vars.dta", clear
use "${datafromtania}/Data2010_IntergenParentSample.dta", clear 
use "${datafromtania}/Data2010_IntergenParentSample_baselineupdate.dta", clear 


*** 1. ACTIVATE GLOBALS IN DO FILE "Master - RP- Globals Nicaragua Project"

**# 2. CLEAN AND CREATE FINAL DATA SETS
 ** CLEAN 	
do "${doclean}/1_clean_hh_data_v3.do"
	*Input: "${datainput}/HH_INDI/hh_level_v3.dta"
	*Output: "${datafinal}/hh_data_v3.dta"
do "${doclean}/2_clean_hhindiv_v3.do"
	/*
	Input: "${datainput}/HH_INDI/indiv_level_v3.dta"
	Output: "${datafinal}/hhindiv_data_v3.dta"
	*/
do "${doclean}/3_clean_section7_hhindiv_v3.do"
	/*
	Input: "${datainput}/HH_INDI/indiv_level_v3.dta"
	Output:  "${dataint}/section7_childlevel.dta"
	*/
do "${doclean}/4_clean_indi_2020_below7_v2.do"
/*
Input: 
		"${datainput}/indi_2020_below7_v2.dta"
		"${datainput}/a19a_c.dta"
		"${datainput}/HH_INDI/hh_level_v3.dta"
		"${datafromtania}/Data2010_IntergenParentSample.dta"
		
		"${datafinal}/hhindiv_data_v3.dta" 
		"${datafinal}/hh_data_v3.dta"
		"${datafinal}/section7_childlevel.dta"
		"${datainput}/baseline_balance_vars.dta"
		"${datafromtania}/Data2010_IntergenParentSample_baselineupdate.dta"
		
Output: "${datafinal}/indi_2020_below7_indexes.dta"
*/
do "${doclean}/5_clean_Data2010_IntergenParentSample.do"
/*
Input: 
	"${datafromtania}/Data2010_IntergenParentSample.dta"
	"${datafinal}/hh_data_v3.dta"
	"${datafinal}/hhindiv_data_v3.dta"
	"${datafinal}/indi_2020_below7_indexes.dta"
Output: "${datafinal}/Data2010_IntergenParentSample.dta"
*/


*******************************************************************************
**# 3. CREATE FINAL TABLES
do "${dofiles}/Tables - RP - Nicaragua project.do"
*******************************************************************************