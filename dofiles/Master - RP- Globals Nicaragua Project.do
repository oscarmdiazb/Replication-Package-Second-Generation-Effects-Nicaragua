* NICARAGUA PROJECT
* Description:  This dofile defines the globals defining the directories and 
* 				groups of variables used in the various dofiles. 

* ------------------------------------------------------- *
* SETTINGS				
* ------------------------------------------------------- *

set more 			off 
set graphics 		on 
set varabbrev 		on
version 			17          							    /* Use Stata 17 */ 
cap log close
cls

* ------------------------------------------------------- *
* PATH				
* ------------------------------------------------------- *

global mainfolder "C:\Users\cadia\Dropbox (Personal)\Nicaragua project\Replication package Second Generation Effects_March2025"

di "${mainfolder}"


**********************************************************************
********************** DATA ******************************************
**********************************************************************
* FOLDERS
	global data "${mainfolder}/data"
		global datainput "${data}/Input"
		global datafinal "${data}/Final"
		global datafromtania "${data}/Input"


* DATASETS

* Input folder 
* Files from Tania: 
global hh_data_v3 "${datainput}/HH_INDI/hh_level_v3.dta"
global hhindiv_data_v3 "${datainput}/HH_INDI/indiv_level_v3.dta"
global intergenparentsample "${datafromtania}/Data2010_IntergenParentSample.dta"

* Files from JV/KM:
global indiv_data_v2 "${datainput}/indi_2020_below7_v2.dta"
global  indiv_data_sa19 "${datainput}/a19a_c.dta"

* Output
*global indiv_antrho_data "$dataoutput/anthro_older_z", clear 
*global indiv_data_v2_anthro "$dataoutput/indi_2020_below7_f.dta",clear


**********************************************************************
********************** DOFILES ******************************************
**********************************************************************

**** DO FILES PATHS
global dofiles "${mainfolder}/Dofiles"
	global doclean "${dofiles}/clean"
	global doanalysis "${dofiles}/analysis" 
	
	
**********************************************************************
********************** OUTPUTS **********************************************************************

**** OUTPUT PATHS
global outputs "${mainfolder}/Outputs"
	global outgraphs "${outputs}/Graphs"
	global outtables "${outputs}/Tables"
	global outreports "${outputs}/Reports"
	global outlogs "${outputs}/Logs"


*** GRAPHS SETTINGS 
	graph set window fontface "Times New Roman"
	capture set scheme white_tableau , permanently
	
	
**********************************************************************
********************** INSTALL COMMANDS **********************************************************************	
	run  "${dofiles}/adofiles/program_main_regressions_paper.do"

******************************************************************
***LIST OF OUTCOMES***********************************************
******************************************************************

**** ANTRHOPOMETRICS  
global antrhopometrics haz waz bmiz whz ///
underweight stunting wasting overweight

**** COGNITIVE 
global tvip  a5score za5score
global memory a4score a4score_b7 a4score_b20 a6score 
global denver a7b_adv a7b_delay a7b_caution a7c_adv a7c_delay a7c_caution a7d_adv a7d_delay a7d_caution a7a_adv a7a_delay a7a_caution 

global denver_a 	a7a_delay	a7a_caution a7a_adv
global denver_b 	a7b_delay	a7b_caution a7b_adv
global denver_c 	a7c_delay	a7c_caution a7c_adv
global denver_d 	a7d_delay	a7d_caution a7d_adv


****Health 
global health health_sd control weighed timesweighed tarjeta updated_tarjeta vitaminA iron 
global health_ill diarrhea diarrhea_doctor other_illness illness other_illness12 illness_doctor illness12 deworming  sight disability // s4p29a s4p58a 

***** Vaccine
global vaccine bcg dtp3 opv3 rotavirus mmr sarampion dpt fvc2 bcg_ontime mmr_ontime bcg_catchup mmr_catchup catchup 
global tarjeta fvc2_tarjeta catchup_tarjeta bcg_tarjeta opv_dtp_tarjeta  rota_dpt_tarjeta  mmr_sarampion_tarjeta 

***** Pregnancy  
global pregnancy_siblings hhs7_ultimo_hijo hhs7_hermano_mayor 
global pregnancy_control hhs7_control hhs7_control_meses hhs7_control_n hhs7_control_sangre hhs7_control_orina hhs7_control_pecho hhs7_control_hierro hhs7_control_folico hhs7_control_quien_doctor hhs7_control_donde_salud 
global pregnancy_vaccine hhs7_vacuna_tetano hhs7_vacuna_tetano_dosis 
global pregnancy_expenses  hhs7_embarazo_pago hhs7_embarazo_pago_cuanto
global pregnancy_birth hhs7_parto_quien_doctor hhs7_parto_donde_hospital 
global pregnancy_postnatal hhs7_postnatal hhs7_postnatal_dias hhs7_postnatal_quien_doctor
 
*****Birth
global birth ageatbirth birthweight 
global birth2 first_child only_child a2p13 birthspacing total_siblings labor_compl premature exclusivebf bfeeding

*****Nutrition
global nutrition mdd mdd_alt ndd ndd_alt fcs 
global nutrition_foodgroup fc1 fc2 fc3 fc4 fc5 fc6 fc7 fc8 fc9 ofg1 ofg2 ofg3 ofg4 
global nutrition1 a3p1a a3p1b a3p1c a3p1d a3p1e 
global nutrition2 a3p2a a3p2b a3p2c a3p2d a3p2e a3p2f a3p2g a3p2h 
global nutrition3 a3p2i a3p2j a3p2k a3p2l a3p2m a3p2n a3p2o a3p2p a3p2q a3p2r

*****Parenting
global parenting_index misbehave_violence misbehave_nonviolence misbehave_violence_alt misbehave_nonviolence_alt discipline_sd
global parenting   mb_a17cp1a mb_a17cp1b mb_a17cp1c mb_a17cp1d mb_a17cp1e mb_a17cp1f mb_a17cp1g mb_a17cp1h mb_a17cp1i mb_a17cp1j mb_a17cp1k mb_a17cp1_n mb_a17cp1_o 

**** HOME
global home  a19score a19scorev2 home_sd home_s1 home_s2 home_s3 home_s4 home_s5 
global home_a s_a19ap1 s_a19ap2  s_a19ap3 s_a19ap4  s_a19ap5 s_a19ap6 
global home_b s_a19bp2 s_a19bp3 s_a19bp4 s_a19bp5  s_a19bp6 s_a19bp7 s_a19bp8 s_a19bp9 s_a19bp10 s_a19bp11 
global home_c s_a19cp1 s_a19cp2 s_a19cp3  s_a19cp4 s_a19cp5
global home_d s_a19dp1  s_a19dp2  s_a19dp3  s_a19dp4  s_a19dp5  s_a19dp6
*****STIMULATIONS
global stimulation  telling reading reading_days hours_reading painin preschool 



*** GENERAL - KID 
global general_kid age_months_hogar girl total_siblings originalhh municipio_treated 

*** GENERAL MOM 
*hogar
global general_mom p2_mom care_mom yearseducmom mothereduc relacion_madre_jefa relacion_madre_esposa relacion_madre_hija relacion_madre_nuera relacion_madre_nieta relacion_madre_inlaw  union_married single // married union divorced  widow found_mom s1p9a_mama
*indi
global general_mom2  resp_indi_mom resp_indi_gp 

*** GENERAL DAD 
*hogar
global general_dad a1p13 parents_age_gap fathernothome  fatherwrite fathereduc fatherhigheduc relacion_padre_jefe relacion_padre_esposo relacion_padre_hija relacion_padre_nuero  relacion_padre_inlaw hhind_p3_padre care_mom care_dad care_other mothernothome fathernothome a1p5_horas
*indi
global general_dad2 father_educ father_higheduc time_dad see_dad 

*****HOUSEHOLD COMPOSITION  
global hhcomposition hh_i09 hh_s2p1 hh_s2p2 hh_s2p2a hhage_group03  hhage_group47  hhage_group815  hhage_group1625  hhage_group2650  hhage_group50

*****HOUSEHOLD CONSUMPTION  
 *Consumption Index
 global consumption_index tb_lpcfood tb_exp_staplesshr tb_exp_animalprotshr tb_exp_fruitvegshr tb_exp_otherfoodshr
  
 *Extra consumption variables
 global consumption_comp tb_HHsize tb_total tb_ltotal tb_pctotal tb_pcfood tb_foodshr


**** MOTHER LABOR EDUCATION AND FERTILITY OUTCOMES 

*Fertility Family, plus workshop
global mother_fertility tb_z_fertilityF2 tb_s1_evermarried tb_a18b_anychild tb_age_firstsex15 tb_z_a18b_age_menarc tb_z_bmi_nopreg tb_a18b_wkshopRPS_preg tb_a18b_pap_know //z_fertilityM
 
 *Labor Market and Participation Family
 global mother_labor tb_z_family_migr tb_offfarm_all tb_migr_totwork tb_any_job tb_urban_job 
  
  *Earnings Family, rank
   global mother_income_rank tb_z_family_inc_offfarm_rank tb_income_rank tb_totinc_rank tb_maxincome_rank tb_maxsalary_rank
  
 *Earnings Family, 5% trim
 global mother_income_trim tb_z_family_inc_abs_o95 tb_tot2_income_pm_o95 tb_tot_inc_totwrk2_o95 tb_max_inc_pm_o95 tb_maxsalary_o95 
  
 *Socio-Emotional Family
 global mother_socioemotional tb_z_fam_noncog tb_z_pos_selfev tb_z_optimism tb_z_stress tb_z_neg_selfev
 
 *Schooling Family
 global mother_schooling tb_z_fam_edu tb_edu_2010_hh tb_edu_2010_hh_gd4f tb_enroll_2010 tb_literate_2010
 
 *Learning and Congition Indices
 global mother_learning tb_z_avgMathSpanish tb_z_avgSpanish tb_z_avgMath tb_z_raven tb_z_avgMixAchieve
  

 





*** ALL OUTCOMES
global outcomeslist antrhopometrics tvip memory denver_a denver_b denver_c denver_d ///
 health health_ill vaccine tarjeta pregnancy_control ///
 pregnancy_vaccine pregnancy_expenses pregnancy_birth pregnancy_postnatal birth birth2 ///
 nutrition nutrition_foodgroup nutrition1 nutrition2 nutrition3 ///
 parenting parenting_index home home_a home_b home_c home_d stimulation ///
 mother_fertility mother_labor mother_income_rank mother_income_trim mother_socioemotional  mother_schooling mother_learning ///
general_kid general_mom general_mom2 general_dad  general_dad2 hhcomposition /// 
consumption_index consumption_comp  

/*
global outcomeslist   hhcomposition /// 
consumption_index consumption_comp   //for when I wanna run only a subset of outcomes 
*/

******************************************************************
***LIST OF KEY VARS to CONTROL FOR ******************************
******************************************************************

global commonFE tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma

global clustervar tb_itt_comcens


*** Age polynomial
global agepol age age2 age3 age4 age5	

local age_months age_months_hogar age_months1 age_months2 age_months3 age_months4 age_months5 age_months6 age_months8 age_months9 age_months10 age_months11 age_months12 age_months13 age_months14 age_months15 age_months16 age_months7A age_months7B age_months7C age_months7D age_months17A age_months17B age_months17C age_months18A age_months18B age_months18C age_months18D age_months19A age_months19B age_months19C age_months19D a16age



foreach age of local age_months  { //create an age polynomial global for each age in months
	global agepol_`age' 
	forvalues n=1/5 { // add polynomial to the power
		global agepol_`age' ${agepol_`age'} `age'_`n'
	}
}

foreach age of local age_months  { //create an age polynomial global for each age in months
	global age6group_`age' i.`age'_6group //add dummies 6 months group
}

** assign to each group of outcomes the adecuate age polynomial 

// all the var groups for which outcome comes from HH survey and need to control for age_months_hogar 
local age_months_hogar_group health health_ill vaccine tarjeta birth birth2 pregnancy_control pregnancy_vaccine pregnancy_expenses pregnancy_birth pregnancy_postnatal general_kid general_mom general_dad hhcomposition consumption_index consumption_comp mother_fertility mother_labor mother_income_rank mother_income_trim mother_socioemotional  mother_schooling mother_learning tb_lpcfood health_av obs_env_pca_sd

foreach group of local age_months_hogar_group {
	global agepol_`group' ${agepol_age_months_hogar} 
	global age6group_`group' ${age6group_age_months_hogar}
}

// all the var groups for which ages of specific sections should be assigned
 
//Stimulation: from indi section 2
global agepol_stimulation ${agepol_age_months2} 
global age6group_stimulation ${age6group_age_months2} 

//Nutrition: comes from indi section 3
global agepol_nutrition ${agepol_age_months3} 
global agepol_nutrition_foodgroup ${agepol_age_months3} 
global agepol_nutrition1 ${agepol_age_months3} 
global agepol_nutrition2 ${agepol_age_months3} 
global agepol_nutrition3 ${agepol_age_months3} 

global age6group_nutrition ${age6group_age_months3} 
global age6group_nutrition_foodgroup ${age6group_age_months3} 
global age6group_nutrition1 ${age6group_age_months3} 
global age6group_nutrition2 ${age6group_age_months3} 
global age6group_nutrition3 ${age6group_age_months3} 

//Memory: from indi section 4 
global agepol_memory ${agepol_age_months4} 
global age6group_memory ${age6group_age_months4}

//TVIP: from indi section 5 
global agepol_tvip ${agepol_age_months5} 
global age6group_tvip ${age6group_age_months5}

//Denver: from indi section 7 
global agepol_denver_a ${agepol_age_months7A} 
global agepol_denver_b ${agepol_age_months7B} 
global agepol_denver_c ${agepol_age_months7C} 
global agepol_denver_d ${agepol_age_months7D} 

global age6group_denver_a ${age6group_age_months7A} 
global age6group_denver_b ${age6group_age_months7B} 
global age6group_denver_c ${age6group_age_months7C} 
global age6group_denver_d ${age6group_age_months7D} 


//Parenting: comes from indi section 17a
global agepol_parenting ${agepol_age_months17A} 
global agepol_parenting_index ${agepol_age_months17A} 

global age6group_parenting ${age6group_age_months17A} 
global age6group_parenting_index ${age6group_age_months17A}

//Home: comes from indi section 19
global agepol_home ${agepol_age_months19A} 
global agepol_home_a ${agepol_age_months19A} 
global agepol_home_b ${agepol_age_months19B} 
global agepol_home_c ${agepol_age_months19C} 
global agepol_home_d ${agepol_age_months19D} 

global age6group_home ${age6group_age_months19A} 
global age6group_home_a ${age6group_age_months19A} 
global age6group_home_b ${age6group_age_months19B} 
global age6group_home_c ${age6group_age_months19C} 
global age6group_home_d ${age6group_age_months19D} 


//Anthropometrics: from indi section 16 
global agepol_antrhopometrics ${agepol_a16age} 
global age6group_antrhopometrics ${age6group_a16age} 


//General 2: comes from indiv section 1 
global agepol_general_mom2 ${agepol_age_months1} 
global agepol_general_dad2 ${agepol_age_months1} 

global age6group_general_mom2 ${age6group_age_months1} 
global age6group_general_dad2 ${age6group_age_months1} 


* confirm it worked
foreach o of global outcomeslist {
	di "`o'"
	di "${agepol_`o'}"
	di "${age6group_`o'}"
}

*create a global per variable
foreach o of global outcomeslist {
foreach var of global `o' {
global `var'_a6g ${age6group_`o'}
	di "`o': `var' ${`var'_a6g}"
	assert "${`var'_a6g}"!=""
global `var'_apo ${agepol_`o'}
	di "`o': `var' ${`var'_apo}"
	assert "${`var'_apo}"!=""
	
		}
}

***** Notes below tables 
global note_main_controls "Controls include randomization strata, education level at cash transfer and a dummy if living in Madriz or Tuma. SE are cluster at the comarca level."



