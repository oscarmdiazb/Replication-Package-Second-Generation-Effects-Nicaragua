/*
Input: 
	"${datafromtania}/Data2010_IntergenParentSample.dta"
	"${datafinal}/hh_data_v3.dta"
	"${datafinal}/hhindiv_data_v3.dta"
	"${datafinal}/indi_2020_below7_indexes.dta"
Output: "${datafinal}/Data2010_IntergenParentSample.dta"
*/

use "${datafromtania}/Data2010_IntergenParentSample.dta", clear  

*This is the main sample to look at;
gen Intergen_samp9_12=(age_transfer>=9 & age_transfer<13 & (male2010all==1 | male2010all==0)  & realp==1  & treat~=.)

keep if Intergen_samp9_12==1
keep if male2010all==0
drop if treat==-1

gen early_treated=treat 
gen late_treated=early_treated
recode late_treated (1=0) (0=1)
label var early_treated "Early treated"
label var late_treated "Late treated"

label define early_treated 0 "LT" 1 "ET"
label values early_treated early_treated

label define late_treated 1 "LT" 0 "ET"
label values late_treated late_treated



//rename vars
foreach var of varlist _all {
		rename `var' tb_`var' //to know the source of the var (Tania B). 

}
foreach var of newlist noformul hogarid hogarid_punto cp  Intergen_samp9_12  treat late_treated early_treated {
rename tb_`var' `var'
}


**# Merge HH survey data 
preserve 
use  "${datafinal}/hh_data_v3.dta", clear 
tempfile hhdata
save `hhdata'
restore 
merge m:1 noformul hogarid hogarid_punto using `hhdata', keepusing(s7p37 s7p38 s7p39 s7p40 s7p41 s14p1 s14p2 s14p3 s14p4 s14p5 s14p6 s14p7 s14p8 s14p9 s14p10 s14p11 s14p12 )
drop if _m==2
drop _m

**# Merge hh individual survey data
preserve 
use "${datafinal}/hhindiv_data_v3.dta", clear 

tempfile hhindiv
save `hhindiv'
restore 
merge 1:1 noformul hogarid hogarid_punto cp using `hhindiv', keepusing(age single s7p1a s7p1b s7p2  s7p5 mkids_n mkids_born_after_sept2006)
drop if _m==2
drop _m

gen haskids_roster=(mkids_n>0 & mkids_n!=.)
label var haskids_roster "Tiene hijos (HH roster)"

gen haskids_after_sept2006=(mkids_born_after_sept2006>0 & mkids_born_after_sept2006!=.)
label var haskids_after_sept2006 "Tiene hijos después de Sept 2006 (HH roster)"


recode s7p1a (2=0) // ha tenido hijos nacidos vivos
replace s7p1a=0 if s7p1a==.
label var s7p1b "No. Hijos nacidos vivos"
	replace s7p1b=0 if s7p1a==0
label var s7p2 "Edad cuando tuvo primer hijo"

gen embarazada=0 if s7p5!=.
replace embarazada=1 if s7p5==1
label var embarazada "Embarazada"

gen kidunder5=0 if s7p5!=.
replace kidunder5=1 if s7p5==2 
label var kidunder5 "Tiene hijo menor a 5"

* Women in our sample?
**# Merge child instrument individual survey data
preserve 
use  "${datafinal}/indi_2020_below7_indexes.dta", clear 
 
duplicates drop noformul hogarid hogarid_punto cp_madre, force 
gen insample=1 
tempfile oursample
save `oursample'
restore 

gen cp_madre=cp 
merge 1:1 noformul hogarid hogarid_punto cp_madre using `oursample', keepusing(insample first_child)
drop if _m==2
replace insample=0 if _m==1
drop _m 
replace first_child=0 if first_child==.

label var insample "In sample" // 345  mothers make part of our 366 kids sample. 
label define insample  0 "Not in sample" 1 "In sample", replace 
label values insample insample

tab insample if haskids_after_sept2006==1
/*
    In sample |      Freq.     Percent        Cum.
--------------+-----------------------------------
Not in sample |          1        0.29        0.29
    In sample |        345       99.71      100.00
--------------+-----------------------------------
        Total |        346      100.00
*/

** 2 observations that says no kids but insample
replace  s7p1a=1 if insample==1



************Observations environment

*Please note, Z is done using insample=1 + late treatment 

sum s14p1 s14p2 s14p3 s14p4 s14p5 s14p6 s14p7 s14p8 s14p9 s14p10 s14p11 s14p12

local obs_rev s14p1 s14p2 s14p3 s14p4 s14p5 s14p11


 foreach x of local obs_rev {
gen s_`x'=.
replace s_`x'=0 if `x'==1
replace s_`x'=1 if `x'==2

}

local obs s14p6 s14p7 s14p8 s14p9 s14p10 s14p12

 foreach x of local obs {
gen s_`x'=.
replace s_`x'=0 if `x'==2
replace s_`x'=1 if `x'==1

}


tab s14p1 s_s14p1
tab s14p2 s_s14p2
tab s14p3 s_s14p3
tab s14p4 s_s14p4
tab s14p5 s_s14p5
tab s14p6 s_s14p6
tab s14p7 s_s14p7
tab s14p8 s_s14p8
tab s14p9 s_s14p9
tab s14p10 s_s14p10
tab s14p11 s_s14p11
tab s14p12 s_s14p12


label var s_s14p1 "NO excrements near house"
label var s_s14p2 "NO garbage near house"
label var s_s14p3 "NO stagnant water near house"
label var s_s14p4 "NO stables near house"
label var s_s14p5 "NO lack of ventilation"
label var s_s14p6 "backyard clean"
label var s_s14p7 "separated spaces house"
label var s_s14p8 "clean house"
label var s_s14p9 "kitchen spaces clean"
label var s_s14p10 "animals have no access"
label var s_s14p11 "NO served water"
label var s_s14p12 "dishes clean"

sum s_s14p*
foreach var of varlist s_s14p* {
	replace `var'=0 if `var'==.
}

gen obs_env= s_s14p1 + s_s14p2 + s_s14p3 + s_s14p4 + s_s14p8 + s_s14p9 + s_s14p10 + s_s14p11 + s_s14p12

label var obs_env "observations environment positive"


pca s_s14p1  s_s14p2  s_s14p3 s_s14p4  s_s14p8 s_s14p9  s_s14p10  s_s14p11  s_s14p12

predict obs_env_pca
label var obs_env_pca "observations environment positive (pca)"



local outcomes obs_env_pca s_s14p1  s_s14p2  s_s14p3 s_s14p4  s_s14p5  s_s14p6  s_s14p7  s_s14p8  s_s14p9  s_s14p10  s_s14p11  s_s14p12

 foreach x of local outcomes {
su `x' if early_treated==0 & insample==1
gen `x'_sd= (`x'- r(mean)) / r(sd) if `x'!=.

}


egen obs_env_av=rowmean(s_s14p1_sd s_s14p2_sd  s_s14p3_sd  s_s14p4_sd  s_s14p8_sd s_s14p9_sd  s_s14p10_sd  s_s14p11_sd  s_s14p12_sd) if (s_s14p1_sd!=. & s_s14p2_sd!=. & s_s14p3_sd!=. & s_s14p4_sd!=. & s_s14p8_sd!=. & s_s14p9_sd!=. & s_s14p10_sd!=. & s_s14p11_sd!=. & s_s14p12_sd!=.)

su obs_env_av if early_treated==0
gen obs_env_sd= (obs_env_av- r(mean)) / r(sd)

label var obs_env_sd "Observetions environment (sd)"


label var obs_env_pca_sd "Observations environment (Z)"

label var s_s14p1_sd "NO excrements near house (Z)"
label var s_s14p2_sd "NO garbage near house (Z)"
label var s_s14p3_sd "NO stagnant water near house (Z)"
label var s_s14p4_sd "NO stables near house (Z)"
label var s_s14p5_sd "NO lack of ventilation (Z)"
label var s_s14p6_sd "backyard clean (Z)"
label var s_s14p7_sd "separated spaces house (Z)"
label var s_s14p8_sd "clean house (Z)"
label var s_s14p9_sd "kitchen spaces clean (Z)"
label var s_s14p10_sd "animals have no access (Z)"
label var s_s14p11_sd "NO served water (Z)"
label var s_s14p12_sd "dishes clean (Z)"


save "${datafinal}/Data2010_IntergenParentSample.dta", replace 
use "${datafinal}/Data2010_IntergenParentSample.dta", clear 
