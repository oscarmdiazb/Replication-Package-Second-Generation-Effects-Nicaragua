/*
******** ****************************************************
Dofile to reproduce all the  tables in 
Second Generation Effects of an Experimental Conditional
Cash Transfer Program on Early Childhood Human Capital in
Nicaragua
Tania Barham, Oscar Díaz, Karen Macours, John A. Maluccio, Julieta Vera Rueda
******** ****************************************************

*/


************************************************************ 
*************************************************************
**# Table 1: Experimental differences in female fertility in 2010
*************************************************************
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 
label var s7p1a "Ever had a, live birth,(=1)"
label var s7p1b "Number of,live births"
label var s7p2 "Mother's Age, at first birth,(years)"
replace s7p1a=1 if insample==1 

clonevar s7p2_insample=s7p2 if insample==1 

label var haskids_roster "Has,a child, (=1)"
label var mkids_n "Has,children,(N)"
label var haskids_after_sept2006 "Has a child,born after Sept. 1 2006,(=1)"
label var first_child "Child is,first born,(=1)"

local out s7p1a  haskids_roster  haskids_after_sept2006 s7p2_insample // s7p1b first_child
	outreg2_nica , outcomes(`out')  save("${outtables}/paper/appendix/prob_having_kids.tex")
tab early_treated if haskids_roster==0 & s7p1a==1

use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
clonevar first_child_unc=first_child
replace first_child_unc=0 if first_child_unc==.

global first_child_unc_a6g  ${age6group_age_months1} 
label var first_child_unc "Child is, first born, (=1)"
 	outreg2_nica , outcomes(first_child_unc)  save("${outtables}/paper/appendix/prob_having_kids.tex") appendtable
	
*************************************************************
**# Table 2: Baseline balance for sample mothers and their households in 2000
*************************************************************
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 
merge 1:1 noformul hogarid hogarid_punto cp using "${datainput}/baseline_balance_vars.dta"
drop if _merge==1 
drop _merge 

local allvarspaper2016  age_transfer noedu_c edu_c  work_lw_c mom_notpresent_c dad_notpresent_c son_hhh_c mom_noedu_2010com mom_edu_3pl_2010com  hh_female_c hh_ageyearscen_c hh_noedu_c   hh_work_lw_c   p_lpce fsize_c dem_T0008n_c dem_T0912n_c lnlandsize_c   workag_c pc1_b pc2_b pc3_b    scholdist_min_c   Dtuma Dmadriz  netsize_ind ownhousealt3 rooms_c blockwall_c zincroof_c  dirtfloor_c latrine_c light_electric_c cassette_c workanimal_c fumipump_c

merge 1:1 noformul hogarid hogarid_punto cp using "${datafromtania}/Data2010_IntergenParentSample_baselineupdate.dta", keepusing(`allvarspaper2016') //hh_edu3pl_c
drop if _merge==1 
drop _merge 

sum `allvarspaper2016'
des `allvarspaper2016'

keep if insample
local hspace 0.3cm

label var fincas "\hspace*{`hspace'} Number of parcels owned"
label var censt_fem_head "\hspace*{`hspace'} Female HH head"
label var censt_age_head "\hspace*{`hspace'} HH head age"
label var censt_no_educ_head "\hspace*{`hspace'} HH head no education(=1)"
label var censt_comp_4yrs_educ_head "\hspace*{`hspace'} HH head completed 4 years of education (=1)"

label var censt_agric_head "\hspace*{`hspace'} HH head/wife work in agriculture (=1)"
label var censt_supmet00_1000 "\hspace*{`hspace'} Land size (1000m2)"
label var censt_own_house "\hspace*{`hspace'} Own the house (=1)"
label var censt_house_service "\hspace*{`hspace'} House received in exchange for services (=1)"
label var censt_work_lw "\hspace*{`hspace'} Work last week (=1)"
label var censt_heirs_head_2000 "\hspace*{`hspace'} Children of hh head (N)"
label var censt_hh_nuclear "\hspace*{`hspace'} Nuclear household (=1)"
label var censt_hh_vertical "\hspace*{`hspace'} Intergenerational household (=1)"

label variable age_transfer "\hspace*{`hspace'} Age at start of transfers (years)"
label variable noedu_c "\hspace*{`hspace'} No grades attained (=1)"
label variable edu_c "\hspace*{`hspace'} Completed grades"
label variable work_lw_c "\hspace*{`hspace'} Worked last week (=1)"
label variable mom_notpresent_c "\hspace*{`hspace'} Mother not living in same household (=1)"
label variable dad_notpresent_c "\hspace*{`hspace'} Father not living in same household (=1)"
label variable son_hhh_c "\hspace*{`hspace'} Child of household head (=1)"
label variable mom_noedu_2010com "\hspace*{`hspace'} Mother has no grades attained (=1)"
label variable mom_edu_3pl_2010com "\hspace*{`hspace'} Mother has 3 plus grades attained (=1)"
label variable hh_female_c "\hspace*{`hspace'} Household head female (=1)"
label variable hh_ageyearscen_c "\hspace*{`hspace'} Household head age (years)"
label variable hh_noedu_c "\hspace*{`hspace'} Household head has no grades attained (=1)"
*label variable hh_edu3pl_c "\hspace*{`hspace'} Household head has 3 plus grades attained (=1)"
label variable hh_work_lw_c "\hspace*{`hspace'} Household head worked last week (=1)"
label variable p_lpce "\hspace*{`hspace'} Predicted log expenditures (per capita)"
label variable fsize_c "\hspace*{`hspace'} Number of household members"
label variable dem_T0008n_c "\hspace*{`hspace'} Number of children ages 0–8"
label variable dem_T0912n_c "\hspace*{`hspace'} Number of children ages 9–12"
label variable lnlandsize_c "\hspace*{`hspace'} Logarithm of size of landholdings"
*label variable ownhousealt3 "\hspace*{`hspace'} Own house (=1)"
label variable workag_c "\hspace*{`hspace'} Some in household work in agric (=1)"
label variable pc1_b "\hspace*{`hspace'} Wealth index - housing characteristics"
label variable pc2_b "\hspace*{`hspace'} Wealth index - productive assets"
label variable pc3_b "\hspace*{`hspace'} Wealth index - other assets"

local hspace 1cm

label variable rooms_c "\hspace*{`hspace'} Number of rooms in house"
label variable blockwall_c "\hspace*{`hspace'} Cement block walls (=1)"
label variable zincroof_c "\hspace*{`hspace'} Zinc roof (=1)"
label variable dirtfloor_c "\hspace*{`hspace'} Dirt floor (=1)"
label variable latrine_c "\hspace*{`hspace'} Latrine (=1)"
label variable light_electric_c "\hspace*{`hspace'} Electric light (=1)"
label variable cassette_c "\hspace*{`hspace'} Radio (=1)"
label variable workanimal_c "\hspace*{`hspace'} Work animals (=1)" 
label variable fumipump_c "\hspace*{`hspace'} Fumigation sprayer (=1)"

local hspace 0.3cm
label variable scholdist_min_c "\hspace*{`hspace'} Distance to nearest school (minutes)"
label variable Dtuma "\hspace*{`hspace'} Lives in Tuma region (=1)"
label variable Dmadriz "\hspace*{`hspace'} Lives in Madriz region (=1)"
*label variable netsize_ind "\hspace*{`hspace'} Family network size (individuals)"

local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma //tb_age_transfer

local cluster tb_itt_comcens

** store values 
local varlist  age_transfer noedu_c edu_c  work_lw_c mom_notpresent_c dad_notpresent_c son_hhh_c mom_noedu_2010com mom_edu_3pl_2010com  /// Individual
					hh_female_c hh_ageyearscen_c hh_noedu_c censt_comp_4yrs_educ_head hh_work_lw_c censt_agric_head  censt_heirs_head_2000    ///
				p_lpce censt_supmet00_1000 fincas censt_own_house censt_house_service   censt_hh_nuclear censt_hh_vertical   fsize_c dem_T0008n_c dem_T0912n_c lnlandsize_c   workag_c pc1_b pc2_b pc3_b    scholdist_min_c   Dtuma Dmadriz /// HH ownhousealt3 rooms_c blockwall_c zincroof_c  dirtfloor_c latrine_c light_electric_c cassette_c workanimal_c fumipump_c
					 /// HH head 
					   
** CREATE TABLE 
	tempfile		 newTextFile
	tempname 		 newHandle
	cap file close 	`newHandle'
	file open  		`newHandle' using "`newTextFile'", text write append
		*Set columns
	file write `newHandle' ///
							"c1" _tab "c2" _tab "c3" _tab "c4" _tab  "c5" ///
							_tab "c6" _tab "c7" _tab "c8" _tab "c9" ///
							_tab "c10" _tab "c11" _n
	*Write headers
	file write `newHandle' ///
							"label" _tab "Mean" _tab "SD" _tab  "" ///
							_tab "Mean" _tab "SD" _tab "" ///
							_tab "Diff." _tab "Diff./SD" _tab "P-value" _tab "Stars" _n
							
	foreach var of varlist `varlist' {
		** Get values 
		local label="`: var label `var''"
			sum `var' if early_treated==1
			scalar mean_et=`r(mean)'
			scalar sd_et=`r(sd)'
			scalar n_et=`r(N)'
			sum `var' if early_treated==0
			scalar mean_lt=`r(mean)'
			scalar sd_lt=`r(sd)'
			scalar n_lt=`r(N)'
			scalar diff=mean_et-mean_lt
			reg `var' early_treated `fe', cluster(`cluster')
			scalar pvalue = r(table)["pvalue", "early_treated"]
			local pvalue=pvalue
			scalar stars = cond(`pvalue' >= 0.10, 0, ///
										 cond(`pvalue' < 0.10 & `pvalue' >= 0.05, 1, ///
										 cond(`pvalue' < 0.05 & `pvalue' >= 0.01, 2, 3)))
							 
			scalar z_diff=diff/sd_et

	* Write data
		file write `newHandle'  /// 
							"`label'" _tab %9.2f (mean_et) _tab  %9.2f (sd_et) _tab  "" /// 
							_tab %9.2f (mean_lt) _tab  %9.2f (sd_lt) _tab   "" ///
							_tab %9.2f (diff) _tab %9.2f (z_diff) _tab  %9.3f (pvalue) _tab  %9.1f (stars) _n
							
	}
	 
	 	file close `newHandle'
	
		insheet using `newTextFile', clear

	*Read file with results 
	local var c11
		replace `var'="" if `var'=="0.0" 
		replace `var'="*" if `var'=="1.0" 
		replace `var'="**" if `var'=="2.0" 
		replace `var'="***" if `var'=="3.0" 
		replace `var'="" if `var'=="Stars"
	
	ereplace c10=concat(c10 c11)
	drop c11
	
	gen order=_n
	local nvars=_N
	local add=_N+3
	set obs `add'
	
	replace c1 = "\textit{\textbf{Individual Characteristics}}" if _n==`nvars'+1
	replace c1 = "\textit{\textbf{Household Head Characteristics}}" if _n==`nvars'+2
	replace c1 = "\textit{\textbf{Household Characteristics}}" if _n==`nvars'+3
	*replace c1 = "\textit{\textbf{Characteristics of Nearest School}}" if _n==`nvars'+4
	
	replace c1="" if c1=="label"
	
	replace order=1.5 if _n==`nvars'+1
	replace  order=10.5 if _n==`nvars'+2
	replace  order=17.5 if _n==`nvars'+3
	*replace  order=14.5 if _n==`nvars'+1 if _n==`nvars'+3
	sort order
	drop order 
	drop if _n==1

local save "${outtables}/paper/baseline_balancetable.tex"
texsave  _all using "`save'",  replace  varlabels dataonly nofix  // headerlines("& \multicolumn{2}{c}{\textbf{Early treatment}} & & \multicolumn{2}{c}{\textbf{Late treatment}}  & &  \multicolumn{3}{c}{\textbf{Diff. in Means}}" "\cmidrule{2-3} \cmidrule{5-6} \cmidrule{8-10}" "&Mean&SD&&Mean&SD&&Diff.&Diff. (Z)&P-value" ) frag
		
*************************************************************
**# Table 3: Experimental effects on early childhood anthropometrics and skills in 2010
*************************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
foreach x of newlist a b c d {
	foreach y of newlist adv delay {
sum a7`x'_`y' if early_treated==0
replace a7`x'_`y'=(a7`x'_`y'-`r(mean)')/`r(sd)' //standarize
	 if "`y'"=="delay" replace a7`x'_`y'=a7`x'_`y'*-1 //swap
	}
	egen denver_`x'_index=rowmean(a7`x'_adv a7`x'_delay)
	global denver_`x'_index_a6g ${a7`x'_adv_a6g} //add the age dummy control 
		global denver_`x'_index_apo ${a7`x'_adv_apo} //add the age dummy control 
}

pca s_a19dp1  s_a19dp2  s_a19dp3  s_a19dp4  s_a19dp5  s_a19dp6
predict home_d_index
global home_d_index_a6g ${s_a19dp1_a6g}
global home_d_index_apo ${s_a19dp1_apo}
label var haz "Height-for-age,z-score"
label var waz  "Weight-for-age,z-score"
label var whz  "Weight-for-height,z-score"
label var stunting  "Stunting,(=1)"
label var wasting  "Wasting,(=1)"
label var underweight  "Underweight,(=1)"
label var birthweight "Birth Weight,(kg)"
label var denver_a_index "Socio Emotional,(Z)"
label var denver_b_index "Language,(Z)"
label var denver_c_index "Fine Motor,(Z)"
label var denver_d_index "Gross Motor,(Z)"
label var home_d_index "Observed Behavior,(Z)"

local outcomes haz whz stunting wasting birthweight  a7a_delay a7a_adv  a7b_delay a7b_adv  a7c_delay a7c_adv  a7d_delay a7d_adv home_d_index
z_lt    denver_b_index denver_c_index denver_d_index home_d_index denver_a_index  //standarize outcomes based on LT except haz waz stunting wasting
local outcomes  haz whz stunting wasting birthweight  denver_b_index denver_c_index denver_d_index denver_a_index home_d_index 		
	outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) save("${outtables}/paper/table_final_outcomes_anthro_denver.tex") // Main table 
	
	*************************************************************
	**# Table B5: Experimental effects on early childhood anthropometrics and skills in 2010 with age polynomial controls
	*************************************************************
	outreg2_nica , outcomes(`outcomes') agecontrols(agepol) save("${outtables}/paper/appendix/table_final_outcomes_anthro_denver_agepol.tex") // with age polynomial controls 
	*************************************************************
	**#Table B6: Experimental effects on early childhood anthropometrics and skills in 2010 only with randomization strata controls
	*************************************************************
outreg2_nica , outcomes(`outcomes') setfe(tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7) save("${outtables}/paper/appendix/anthro_denver_onlystrata.tex")

	*************************************************************
	**# Table B7: Experimental effects on early childhood anthropometrics and skills in 2010 with baseline imbalanced controls
	*************************************************************
*Main results with usual controls + the variables that were off balance
local varsimbalance bl_censt_age_head bl_censt_no_educ_head // old version 
local varsimbalance bl_hh_ageyearscen_c bl_hh_noedu_c bl_dem_T0008n_c bl_lnlandsize_c bl_workag_c //bl_workanimal_c 
sum `varsimbalance'
outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) addcontrols(`varsimbalance') save("${outtables}/paper/appendix/anthro_denver_bl_imbalance_controls.tex")

	*************************************************************
	**# Table B8: Experimental effects on early childhood anthropometrics and skills in 2010 with randomization inference p-values
	*************************************************************
	local outcomes  haz whz stunting wasting birthweight  denver_b_index denver_c_index denver_d_index denver_a_index home_d_index 	
	if 1==0	ri_nica, outcomes(`outcomes') save("${outtables}/paper/appendix/table_final_outcomes_anthro_denver_randominference.tex") // randomize inference (this takes too long, that's why the condition)

	*************************************************************
	**# Table B9: Experimental effects on early childhood anthropometrics and skills in 2010 accounting for population weights
	*************************************************************
	outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_outcomes_anthro_denver_weights.tex") // table with weights

***********************************************************
**# Table 4: Differences in health- and nutrition-related mechanisms in 2010
***********************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
label var health_av "Child Health,Index,(Z)"
label var mdd_alt "Child Minimum,Dietary Diversity,(=1)"
label var ndd_alt "Child Number of,Food Groups,Consumed"
label var tb_lpcfood "Household,Food,Consumption"
label var fcs "Food,Consumption,Score"
global health_av_a6g  ${health_sd_a6g}
z_lt   health_av  //standarize based on LT  (already health_sd)

*Add environment observations
preserve 
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 
keep noformul hogarid hogarid_punto cp_madre obs_env_pca
tempfile data
save `data'
restore 
merge m:1 noformul hogarid hogarid_punto cp_madre using `data' // merge data from mothers
drop if _m==2 
drop _m 
clonevar obs_env_pca_sd=obs_env_pca
z_lt obs_env_pca_sd
label var obs_env_pca_sd "Household Observed,Sanitary Environment,(Z)"
global obs_env_pca_sd_a6g  ${agepol_age_months_hogar}

local outcomes health_av   mdd_alt ndd_alt tb_lpcfood obs_env_pca_sd  //fcs
	outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) save("${outtables}/paper/table_final_nutrition_consumption.tex")
	
	*************************************************************
	**# Table B10: Differences in health and nutrition-related mechanisms in 2010 accounting for population weights
	*************************************************************
		outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_nutrition_consumption_weights.tex")

**************************************************************************************************************************************************
**# Table 5: Differences in parental investment in children in 2010
**************************************************************************************************************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
 label var early_treated "Early treated"
 
label var fvc2 "Fully,Vaccinated,(=1)"
label var fvc2_tarjeta "Fully Vaccinated,Vacc-card, (=1)"
label var discipline "Overall,Discipline Index,(Z)" 
label var misbehave_violence "Violent, Discipline Index,(Z)" 
label var misbehave_nonviolence "Non-violent,Discipline Index,(Z)" 

label var hhs7_control "Attended Control,Pregnancy,(=1)"
label var hhs7_postnatal "Attended Control,Postnatal,(=1)"

z_lt telling reading   //reading_days hours_reading preschool painin
egen stimulation_index=rowmean(telling reading )
label var stimulation_index "Stimulation,Index,(Z)"
global stimulation_index_a6g ${reading_a6g}
*pre-postnatal investment index 
z_lt hhs7_control hhs7_postnatal  exclusivebf
egen prepostnatal_index=rowmean(hhs7_control hhs7_postnatal  exclusivebf)
label var prepostnatal_index "Pre \& Post-Natal,Investments,(Z)"
global prepostnatal_index_a6g ${hhs7_control_a6g}
global discipline_a6g  ${discipline_sd_a6g}
global misbehave_violence_sd_a6g  ${discipline_sd_a6g}
global misbehave_nonviolence_sd_a6g  ${discipline_sd_a6g}

drop discipline_sd  misbehave_nonviolence_sd
clonevar misbehave_violence_sd=misbehave_violence
clonevar misbehave_nonviolence_sd=misbehave_nonviolence
clonevar discipline_sd=discipline
z_lt   stimulation_index prepostnatal_index discipline_sd misbehave_violence_sd misbehave_nonviolence_sd //standarize based on LT  discipline_sd already standarized
local outcomes prepostnatal_index fvc2  fvc2_tarjeta stimulation_index discipline_sd misbehave_violence_sd misbehave_nonviolence_sd 
	outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) save("${outtables}/paper/table_final_health.tex")
	
	***********************************************************	
	**# Table B11: Differences in parental investment in children in 2010 accounting for population weights
	***********************************************************	
		outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_health_weights.tex")

***********************************************************	
**# Table 6: Differences in characteristics of the mother and father in 2010
***********************************************************
*local hhcomposition hh_i09 hh_s2p1 hh_s2p2 hh_s2p2a hhage_group03  hhage_group47  hhage_group815  hhage_group1625  hhage_group2650  hhage_group50
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 

label var p2_mom "Age,(years)"
label var mothereduc "Education,(years)" 
label var tb_migr_totwork "Migrated for Work,(=1)" 
label var a1p13 "Age,(years)"
label var father_educ  "Education,(years)"
label var fathernothome "Not Resident,(=1)"

local out p2_mom mothereduc tb_migr_totwork a1p13 father_educ fathernothome  
	outreg2_nica , outcomes(`out') agecontrols(agedummy) save("${outtables}/paper/table_final_parents.tex")
	
	***********************************************************	
	**# Table B12: Differences in characteristics of the mother and father in 2010 accounting for population weights
	***********************************************************	
	
		outreg2_nica , outcomes(`out') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_parents_weights.tex")
		
****************************************************	
**# Table 7: Differences in family living arrangements and household composition in 2010
****************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 

global hhage_group25plus_a6g ${hh_i09_a6g}	
global relacion_madre_jefa_esposa_a6g ${relacion_madre_jefa_a6g}
global relacion_madre_hija_nuera_a6g ${relacion_madre_hija_a6g}
 
 label var originalhh "Lives in Original,Beneficiary HH,(=1)"

	label var relacion_madre_jefa_esposa "Mother is HH Head or, HH Head spouse,(=1)"
	label var relacion_madre_hija "Mother is HH Head,Daughter,(=1)"
	label var relacion_madre_hija_nuera "Mother is HH Head,Daughter or Daughter-in-law,(=1)"
	label var relacion_padre_nuero "Father is HH Head,Son-in-law,(=1)"
	label var hh_i09 "Household,Size,"
	label var hh_s2p1 "Household,Size,"
	label var hhage_group25plus "Household,Members,25+"
	label var hhage_group2650 "Household,Members,26-50"
	label var hhage_group50 "Household,Members,50+"	
local hhcomposition originalhh relacion_madre_hija_nuera relacion_madre_jefa_esposa    hh_s2p1 hhage_group2650  hhage_group50 //relacion_padre_nuero
	outreg2_nica , outcomes(`hhcomposition') agecontrols(agedummy) save("${outtables}/paper/table_final_hhcomposition.tex")
	
	****************************************************
	**#Table B13: Differences in family living arrangements and household composition accounting for population weights
	****************************************************
		outreg2_nica , outcomes(`hhcomposition') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_hhcomposition_weights.tex")
		
****************************************************
**# Table 8: Differences in maternal mental health in 2010
****************************************************
local mother_socioemotional tb_z_fam_noncog tb_z_pos_selfev tb_z_optimism tb_z_stress tb_z_neg_selfev
foreach var of varlist `mother_socioemotional' {
	local label=subinstr("`: var label `var''"," z-score","(Z)",.)
	label var `var' "`label'"
	
}
des `mother_socioemotional'

z_lt tb_z_fam_noncog tb_z_pos_selfev tb_z_optimism tb_z_stress tb_z_neg_selfev
	outreg2_nica , outcomes(`mother_socioemotional') agecontrols(agedummy) save("${outtables}/paper/table_final_mental_health.tex")
	
	****************************************************
	**#Table B14: Differences in maternal mental health in 2010 accounting for population weights
	****************************************************
		outreg2_nica , outcomes(`mother_socioemotional') agecontrols(agedummy) weights([pw=tb_whh714_weight_hh]) save("${outtables}/paper/appendix/table_final_mental_health_weights.tex")
		
********************************************************************************************************
**# Additional tables in Appendix
********************************************************************************************************

	****************************************************
	**# Table B1: Women (9–12 at baseline) with children in the sample early vs late treatment at endline
	****************************************************
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 
keep if insample

local outcomes age /// 
		 tb_edu_2010_hh ///schooling
		 tb_enroll_2010 /// learning
		   tb_a18b_age_menarc tb_age_firstsex15   ///fertility
		 tb_z_bmi_nopreg ///
		  tb_offfarm_all tb_migr_totwork  tb_any_job tb_urban_job  ///labor
		 tb_tot2_income_pm_o95 ///Income 
		 

label variable age "Age,(years),"
label variable tb_edu_2010_hh "Grades,Completed,(years)"
label variable tb_enroll_2010 "Enrolled,(=1),"
label variable tb_a18b_age_menarc "Age,Menarche,(years)"
label variable tb_age_firstsex15 "Sex at 15,(=1),"
label variable tb_z_bmi_nopreg "Body Mass,Index,(Z)"
label variable tb_offfarm_all "Worked off, Family Farm,(=1)"
label variable tb_migr_totwork "Migrated, for Work,(=1)"
label variable tb_any_job "Had a Salaried,Non-Ag Job,(=1)"
label variable tb_urban_job "Worked,in Urban Area, (=1)"
label variable tb_tot2_income_pm_o95 "Earnings,per month,"

 		outreg2_nica, outcomes(`outcomes')	 save("${outtables}/paper/appendix/table_final_mothers_insample_new.tex")
		
		
	*************************************************************
	**# Table B2: Women (9–12 at baseline) with children in the sample versus without children
	*************************************************************
** ADD FIRST TABLE COMPARING THE FULL SET OF MOTHERS TO THE ONES THAT HAD KIDS IN SAMPLE. 
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 

z_lt tb_a18b_wkshopRPS_preg tb_a18b_pap_know
egen srh_index=rowmean(tb_a18b_wkshopRPS_preg tb_a18b_pap_know)
*egen learning_index=rowmean(tb_z_avgMathSpanish  tb_z_raven tb_z_avgMixAchieve)
gen learning_index=tb_z_avgMathSpanish

clonevar haskids=s7p1a // had ever had a kid
label define haskids 1 "Has children" 0 "No children"
label values haskids haskids 

replace haskids=1 if insample==1
gen kidsinsampl_outsample=(haskids & insample)
replace kidsinsampl_outsample=. if haskids==1 & insample==0
label define kidsinsampl_outsample 1 "Has children in sample" 0 "No children"
label values kidsinsampl_outsample kidsinsampl_outsample 

	*keep if haskids==1 
	*	outreg2_nica, outcomes(insample) weights([pw=tb_whh714_weight_hh])	 save("${outtables}/paper/appendix/table_final_attrition.tex")

label var age "Age" 
label var tb_edu_2010_hh "Grades completed (years)" 
label var  learning_index "Learning Index" 
label var 	 tb_s1_evermarried  "Ever married (=1)"
label var tb_a18b_age_menarc "Age at menarche" 
label var tb_age_firstsex15  "Had sex by age 15 (=1)" 
label var  tb_bmi_nopreg "Body Mass Index" 
label var 		  tb_offfarm_all "Worked off family farm"
label var tb_migr_totwork  "Migrated for work" 
label var tb_any_job "Ever had a salaried non-ag job" 
label var tb_urban_job  "Ever worked in urban area"
label var tb_tot2_income_pm_o95 "Earnings per month (last year)"
label var	 tb_z_optimism "Optimism (Z)"
label var tb_z_pos_selfev "Positive self-perception (Z)"  
label var tb_z_neg_selfev "Negative self-perception (Z)"
label var tb_z_stress  "Stress (Z)" //mental health

local outcomes age /// 
		 tb_edu_2010_hh ///schooling
		 learning_index /// learning
		 tb_s1_evermarried  tb_a18b_age_menarc tb_age_firstsex15   ///fertility
		 tb_bmi_nopreg ///
		  tb_offfarm_all tb_migr_totwork  tb_any_job tb_urban_job  ///labor
		 tb_tot2_income_pm_o95 //Income
		 * tb_z_optimism tb_z_pos_selfev   tb_z_neg_selfev tb_z_stress //mental health
des `outcomes'
** final tables version 1 
local commonoptions replace   nonote order(1 0)  stats(pair(p) desc(sd)) rowvarlabels

local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma
local cluster tb_itt_comcens
iebaltab `outcomes', groupvar(kidsinsampl_outsample)   vce(cluster `cluster') savexlsx("${outtables}/paper/table_final_mothers_haskids_colums1_3.xlsx") `commonoptions' savetex("${outtables}/paper/table_final_mothers_haskids_colums1_3.tex")   browse

drop v2 v4 v6 
local obs=_N+1
set obs `obs'
replace v1="N" if _n==`obs'
replace v3="345" if _n==`obs'
replace v5="458" if _n==`obs'

local save "${outtables}/paper/table_final_mothers_haskids_colums1_3.tex"
texsave  _all using "`save'",  replace  varlabels dataonly nofix hlines(3 -1 28 28)



	*************************************************************
	**#Table B3: Differences in maternal discipline when child misbehaves in 2010, by component	
	*************************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 

 label var early_treated "Early treated"
 
 label var mb_a17cp1a "misbehave: ignore"
label var mb_a17cp1b "misbehave: spank"
label var mb_a17cp1c "misbehave: threaten to, spank or punish"
label var mb_a17cp1d "misbehave: scold"
label var mb_a17cp1e "misbehave: ridicule"
label var mb_a17cp1f "misbehave: explain"
label var mb_a17cp1g "misbehave: offerreward"
label var mb_a17cp1h "misbehave: guide"
label var mb_a17cp1i "misbehave: allow"
label var mb_a17cp1j "misbehave: put to study"
label var mb_a17cp1k "misbehave: do not allow,"
label var mb_a17cp1_n "misbehave: punish"
label var mb_a17cp1_o "misbehave: distract or comfort"

* Creating locals for negative (violent) behaviors
local violence_vars mb_a17cp1b mb_a17cp1c mb_a17cp1d mb_a17cp1e mb_a17cp1_n

* Creating locals for non-violent behaviors
*local nonviolence_vars mb_a17cp1a mb_a17cp1f mb_a17cp1g mb_a17cp1h mb_a17cp1i  mb_a17cp1j mb_a17cp1k mb_a17cp1_o //
*without out to study
local nonviolence_vars mb_a17cp1a mb_a17cp1f mb_a17cp1g mb_a17cp1h mb_a17cp1i  mb_a17cp1k mb_a17cp1_o //

local discipline_vars `violence_vars' `nonviolence_vars'
sum `violence_vars' `nonviolence_vars'
des `violence_vars' `nonviolence_vars'
*VIOLENT: mb_a17cp1b "misbehave: spank", mb_a17cp1c "misbehave: threaten", mb_a17cp1d "misbehave: nag", mb_a17cp1e "misbehave: make fun", mb_a17cp1_n "misbehave: punish"
*NON-VIOLENT: mb_a17cp1a "misbehave: ignore", mb_a17cp1f "misbehave: explain", mb_a17cp1g "misbehave: offer a reward", mb_a17cp1h "misbehave: shepherd", mb_a17cp1i "misbehave: follow", mb_a17cp1j "misbehave: put to study", mb_a17cp1k "misbehave: not follow", mb_a17cp1_o "misbehave: distract/pamper"

label var misbehave_nonviolence "misbehave: non-violence"

* Loop through each variable and update the label
foreach var in `discipline_vars' {
    local newlabel=proper(subinstr("`: var label `var''","misbehave: ","",.))
    local newlabel=subinstr("`newlabel'"," ",",",.)
	local newlabel "`newlabel',(=1)"
    label var `var' "`newlabel'"
	
	global `var'_a6g  ${discipline_sd_a6g}

}

label var mb_a17cp1a "Ignore, (=1),"
label var mb_a17cp1b "Spank ,(=1),"
label var mb_a17cp1c "Threaten to, spank or punish, (=1)"
label var mb_a17cp1d "Scold,(=1),"
label var mb_a17cp1e "Ridicule, (=1),"
label var mb_a17cp1f "Explain, (=1),"
label var mb_a17cp1g "Offer, reward, (=1)"
label var mb_a17cp1h "Guide, (=1),"
label var mb_a17cp1i "Allow, (=1),"
label var mb_a17cp1j "Put to study, (=1),"
label var mb_a17cp1k "Do not, allow,(=1)"
label var mb_a17cp1_n "Punish, (=1),"
label var mb_a17cp1_o "Distract, or comfort, (=1)"

local outcomes `discipline_vars'
	outreg2_nica , outcomes(`outcomes') agecontrols(agedummy) save("${outtables}/paper/appendix/table_discipline_items.tex")

	*************************************************************
	**# Table B4: Differences in main caregiver and time spent with the father	
	*************************************************************
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 

 clonevar a1p5_horas_z=a1p5_horas
 z_lt a1p5_horas_z
local outcomes care_mom care_dad care_other  fathernothome a1p5_horas //a1p5_horas_z
*mothernothome all mothers at home 

label var care_mom "Main Caregiver:,Mother (=1)"
label var care_dad "Main Caregiver:,Father (=1)"

label var care_other "Main Caregiver:,Other (=1)"
label var mothernothome "Mother Lives,with Child (=1)"
label var a1p4_yes "Father Lives,with Child (=1)"
label var fathernothome "Father not Resident,(=1)"
label var a1p5_horas "Father Time, with Child (hours/week)"
label var a1p5_horas_z "Father Time with Child (hours/week), (Z)"

local outcomes `outcomes'
	outreg2_nica , outcomes(`outcomes')  agecontrols(agedummy) save("${outtables}/paper/appendix/main_caregiver_and_time_father.tex")

	****************************************************
	**# Table B15: Anthropometric and Health Investments in 2000 and 2010
	***************************************************
 use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
 label var early_treated "Early treated"
 gen all=1
 
 * Kids
 gen fvc_age0=fvc if  age_months_hogar<12 
 gen fvc_age1=fvc if  age_months_hogar>=12 &  age_months_hogar<24
 gen fvc_age2=fvc if  age_months_hogar>=24 &  age_months_hogar<36
 gen fvc_age3=fvc if  age_months_hogar>=36 &  age_months_hogar<48
 
 local sample all
 local out haz waz stunting wasting fvc_age0 fvc_age1 fvc_age2 fvc_age3 vitaminA  iron
 table () (result) if age_months_hogar<=48 & `sample'==1,  statistic(mean `out') stat(sd `out') stat(n `out') 
 * Mothers 
 egen tagmother=tag(noformul hogarid hogarid_punto cp_madre )
  local out hhs7_control hhs7_control_n hhs7_vacuna_tetano hhs7_control_meses hhs7_parto_donde_hospital
 table () (result) if age_months_hogar<=48 & tagmother==1 & `sample'==1,  statistic(mean `out') stat(sd `out') stat(n `out') append
collect export "${outtables}/paper/table2_2010.xlsx",replace 
