********************************************************************************
**********************NICARAGUA CCT: IMPACT ON NEXT GENERATION******************
********************************************************************************
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
********************************************************************************
*************DATASET************************************************************
*****************************************************************
/*
This data set includes children only (individual survey) PLUS information from section 1,2,4 and 5 from household survey.
This dataset also includes:

*comcens_mom: indicating the baseline comarca of the mother)

*grupocomp_orig_mom 
	–1 for the non-experimental comparison group
	0 for the experimental control group (I.e. Late treatment group) 
	1 for (early) treatment group
	
*c_strata_mom: stratification variable 
* comcens_mom: cluster variable - Numero de comarca censal
*/

use "${datainput}/indi_2020_below7_v2.dta" , clear 

**# MERGE Indiv instrument Section A19a_c
merge 1:1 noformul hogarid hogarid_punto cp acarga_main acarga acodcomu using "${datainput}/a19a_c.dta"
drop if _merge==2
drop _merge
/*
   Result                           # of obs.
    -----------------------------------------
    not matched                        11,834
        from master                        11  (_merge==1)
        from using                     11,823  (_merge==2)

    matched                             3,499  (_merge==3)
    -----------------------------------------

	*/

*IS-> Variable from individual survey
*HHS-> Variable from HH survey
count
*3510


merge n:1 noformul hogarid hogarid_punto using "${datainput}/HH_INDI/hh_level_v3.dta", keepusing(noformul hogarid hogarid_punto i01  i02 fentfirst)
/*    Result                      Number of obs
    -----------------------------------------
    Not matched                         2,749
        from master                         0  (_merge==1)
        from using                      2,749  (_merge==2)

    Matched                             3,510  (_merge==3)
    -----------------------------------------


	*/
drop if _merge==2
drop _m

******************************************************************
***IDENTIFIERS****************************************************
******************************************************************

clonevar cp_madre= s1p21
clonevar cp_padre= s1p18

******************************************************************
***Treatment variable*********************************************
******************************************************************
gen early_treated=grupocomp_orig_mom 
replace early_treated=. if early_treated==-1
gen late_treated=early_treated
recode late_treated (1=0) (0=1)
label var early_treated "Early treated 1; Late treated 0"
label var late_treated "Early treated 0; Late treated 1"
order early_treated late_treated, a(grupocomp_orig_mom) 


******************************************************************
**#Household location*********************************************
******************************************************************
** Lives in Original Household
	// not clean way: hh id ends in "01"
		gen originalhh=0
		replace originalhh=1 if hogarid_punto==1
		label var originalhh "Original,HH,(=1)"
** Lives in treated comarcas?
tab i01  
//Deptos Madriz & Matagalpa
gen departamento_madriz=0 
	replace departamento_madriz=1 if i01==20
	label var departamento_madriz "HH en Madriz departamento"
gen departamento_matagalpa=0 
	replace departamento_matagalpa=1 if i01==40
	label var departamento_matagalpa "HH in Matagalpa departamento"	

tab i02
// municipiocipalities Madriz
gen municipio_yalaguina=0 
	replace municipio_yalaguina=1 if i02==2030
	label var municipio_yalaguina "Vive en Yalaguina municipio"
gen municipio_totogalpa=0 
	replace municipio_totogalpa=1 if i02==2010
	label var municipio_totogalpa "Vive en Totogalpa municipio"

// municipiocipalities Matagalpa
gen municipio_tuma=0 
	replace municipio_tuma=1 if i02==4015
	label var municipio_tuma "Vive en Tuma municipio"	
	
gen municipio_cdario=0 
	replace municipio_cdario=1 if i02==4065
	label var municipio_cdario "Vive en Ciudad Dario municipio"	
	
gen municipio_terrabona=0 
	replace municipio_terrabona=1 if i02==4060
	label var municipio_terrabona "Vive en terrabona municipio"	
	
gen municipio_esquipulas=0 
	replace municipio_esquipulas=1 if i02==4050
	label var municipio_esquipulas "Vive en Esquipulas municipio"



gen municipio_treated=0 
replace municipio_treated=1 if municipio_yalaguina==1 | municipio_totogalpa==1 | municipio_tuma==1 | municipio_cdario==1 | municipio_terrabona==1 | municipio_esquipulas==1  
		label var municipio_treated "Lives in treated municipality"
******************************************************************
**#Child AGE******************************************************
******************************************************************	
gen girl=a_id04
recode girl (2=1) (1=0)
 	label var girl "Girl"
******************************************************************
**#Child AGE******************************************************
******************************************************************
* age when hogar questionnaire was done

gen age_months_hogar=datediff_frac(bdate, fentfirst, "month")
replace age_months_hogar=p2/12 if age_months_hogar<0
*age polynomial

gen age=p2
gen age2=p2*p2
gen age3=p2*p2*p2
gen age4=p2*p2*p2*p2
gen age5=p2*p2*p2*p2*p2

local age_months age_months1 age_months2 age_months3 age_months4 age_months5 age_months6 age_months8 age_months9 age_months10 age_months11 age_months12 age_months13 age_months14 age_months15 age_months16 age_months7A age_months7B age_months7C age_months7D age_months17A age_months17B age_months17C age_months18A age_months18B age_months18C age_months18D age_months19A age_months19B age_months19C age_months19D 
sum `age_months'

preserve
keep noformul hogarid hogarid_punto cp age_months1 age_months2 age_months3 age_months4 age_months5 age_months6 age_months8 age_months9 age_months10 age_months11 age_months12 age_months13 age_months14 age_months15 age_months16 age_months7A age_months7B age_months7C age_months7D age_months17A age_months17B age_months17C age_months18A age_months18B age_months18C age_months18D age_months19A age_months19B age_months19C age_months19D 

rename age_months7A age_months71
rename age_months7B age_months72
rename age_months7C age_months73
rename age_months7D age_months74
rename age_months17A age_months171
rename age_months17B age_months172
rename age_months17C age_months173
rename age_months18A age_months181
rename age_months18B age_months182
rename age_months18C age_months183
rename age_months18D age_months184
rename age_months19A age_months191
rename age_months19B age_months192
rename age_months19C age_months193
rename age_months19D age_months194

reshape long age_months, i(noformul hogarid hogarid_punto cp) j(age_month)

bysort noformul hogarid hogarid_punto cp: egen age_median=median(age_months) if age_months!=.

keep noformul hogarid hogarid_punto cp age_median 

collapse (max) age_median, by(noformul hogarid hogarid_punto cp)

tempfile age
save `age'

restore

merge 1:1 noformul hogarid hogarid_punto cp using `age'
drop _merge

/*
// make sure age vars have no missing. If missing input from other var. 
foreach var of local age_months {
		ereplace `var'=rowmean(`age_months')		
}
*/

egen age_mean=rowmean(age_months1 age_months2 age_months3 age_months4 age_months5 age_months6 age_months8 age_months9 age_months10 age_months11 age_months12 age_months13 age_months14 age_months15 age_months16 age_months7A age_months7B age_months7C age_months7D age_months17A age_months17B age_months17C age_months18A age_months18B age_months18C age_months18D age_months19A age_months19B age_months19C age_months19D)


// make sure age vars have no missing. If missing input from other var. 
foreach var of local age_months {
		replace `var'=age_median if 	`var'==. & age_median!=.
}	

sum `age_months'

foreach var of local age_months {
		replace `var'=a16age if 	`var'==. & a16age!=.
}

sum `age_months'
	
* create polynomial 
local age_months `age_months' age_months_hogar a16age //add age months hogar to local
foreach var of local age_months {
	gen `var'_1=`var'
	gen `var'_2=`var'*`var'
	gen `var'_3=`var'*`var'*`var'
	gen `var'_4=`var'*`var'*`var'*`var'
	gen `var'_5=`var'*`var'*`var'*`var'*`var'
	forvalues x=1/5 {
		label var `var'_`x' "`var' to the power of `x'"
	}
}

*Age groups 6 months - dummies
label define age_months_6group 0 "0-5" 6 "6-11" 12 "12-17"  18 "18-23" 24 "24-29" 30 "30-35" 36 "36-41" 42 "42-47" 48  "48+" , modify
foreach var of local age_months {
egen `var'_6group = cut(`var'), at(0(6)200)
	label values `var'_6group age_months_6group
	
	label var `var'_6group "`: var label `var'' - 6 months group"
}


* Age years
label var p2 "age child"

gen childgroup=.
replace childgroup=1 if p2<3
replace childgroup=2 if p2>=3&p2<5
replace childgroup=3 if p2>=5

tabulate childgroup, generate(childgroup)

label def childgroup 1 "below 3" 2 "3-4 yrs old" 3 "5-6 yrs old"
label values childgroup childgroup

label var childgroup1 "child below 3"
label var childgroup2 "child 3-4 yrs old"
label var childgroup3 "child 5-6 yrs old"


****HOME age groups

gen hchildgroup=.
replace hchildgroup=1 if p2<3
replace hchildgroup=2 if p2>=3&p2<=5
replace hchildgroup=3 if p2>5

tabulate hchildgroup, generate(hchildgroup)

label def hchildgroup 1 "below 3" 2 "3-5 yrs old" 3 "6 yrs old"
label values hchildgroup hchildgroup

label var hchildgroup1 "child below 3"
label var hchildgroup2 "child 3-5 yrs old"
label var hchildgroup3 "child 6 yrs old"


******************************************************************
**# Comarcas******************************************************
******************************************************************

tabulate grupocomp_orig_mom, generate(comarcas)

gen treated=0 if grupocomp_orig_mom==-1
replace treated=1 if grupocomp_orig_mom==0|grupocomp_orig_mom==1

gen com12=.
replace com12=0 if comarcas1==1
replace com12=1 if comarcas2==1

label var com12 "control vs. late treatment"

gen com13=.
replace com13=0 if comarcas1==1
replace com13=1 if comarcas3==1

label var com13 "late vs. early treatment"

gen com23=.
replace com23=0 if comarcas2==1
replace com23=1 if comarcas3==1

******************************************************************
**# Mother's fertility outcomes***********************************
******************************************************************
gen age_years_hogar=age_months_hogar/12

gen ageatbirth=p2_mom-age_years_hogar if p2_mom!=. & age_years_hogar!=.

lab var ageatbirth "age of mother at birth"

tab ageatbirth if p2_mom>=17&p2_mom<=23

*tab ageatbirth grupocomp_orig_mom

*¿ Cuántos niños nacidos vivos tenía la mamá antes del nacimiento de ...?

tab a2p13

label var a2p13 "children previously born"

*first child
gen first_child=0 if a2p13!=0 & a2p13!=.
replace first_child=1 if a2p13==0

label var first_child "first child"

*14. ¿ Cuántos años tenia … cuando su mamá tuvo su próximo hijo?
tab a2p14

*birth spacing
gen birthspacing=.
replace birthspacing=a2p14 if a2p14!=.
replace birthspacing=p2 if a2p14==.

label var birthspacing "birthspacing"

*total number of siblings

gen total_siblings=a2p13 if a2p14==.
replace total_siblings=a2p13+1 if a2p14!=.

label var total_siblings "total siblings"

*only child
gen only_child=0 if total_siblings!=0 & total_sibling!=.
replace only_child=1 if total_siblings==0
label var only_child "only child"


label var found_mom "found mom"

label var p2_mom "age mother"

********************************************
**# Birth- risk factors*********************
********************************************
gen labor_compl=.
replace labor_compl=0 if a2p10==2
replace labor_compl=1 if a2p10==1

label var labor_compl "labor complications"

gen premature=.
replace premature=0 if a2p11==1 | (a2p11==2 & a2p12==10)
replace premature=1 if (a2p11==2 & a2p12==7) | (a2p11==2 & a2p12==8)

label var premature "premature"

gen sight=.
replace sight=0 if a3p3==2
replace sight=1 if a3p3==1

label var sight "sight problems"


******************************************************************
**# Mother's Education*******************************************
******************************************************************
*** NIVEL DE ESTUDIO MADRE 
sum s1p23b /// Var from HHindiv hogar

gen mothereduc=0 if s1p23b==0 | s1p23b==1 /*ninguno o preescolar*/

replace mothereduc=s1p23b*s1p23a if s1p23b==2 // Edu adultos


replace mothereduc=s1p23a if s1p23b==3 /*primaria*/

replace mothereduc=6 + s1p23a if s1p23b==4 | s1p23b==5 /*secundaria o tecnica basico */

replace mothereduc=9 + s1p23a if s1p23b==6 /*tecnica medio*/

replace mothereduc=11 + s1p23a if s1p23b==7 | s1p23b==8 /*tecnica superior o universitario*/

label var mothereduc "Mother years education (hogar)"

count if mothereduc==. 
local m=`r(N)'
count if s1p23b==. | s1p23a==.
assert `m'==`r(N)'

******************************************************************
**# Mother's age groups*******************************************
******************************************************************

gen agegroup=.
replace agegroup=1 if p2_mom>=28 & p2_mom!=.
replace agegroup=2 if p2_mom>=24 & p2_mom<28
replace agegroup=3 if p2_mom>=17& p2_mom<=23

label def agegroup 1 "older than 28" 2 "24 to 27" 3 "17 to 23" 
label values agegroup agegroup

tabulate agegroup, generate(agegroup)

label var agegroup1 "older than 28"
label var agegroup2 "24 to 27"
label var agegroup3 "17 to 23"

tab agegroup grupocomp_orig_mom


****Titulares******************************
gen titular=.
replace titular=0 if s1p17!=3|agegroup!=1
replace titular=1 if s1p17==3&agegroup==1

label var titular "titular"


gen ag1ntt=.
replace ag1ntt=0 if agegroup==1&(titular==0)
replace ag1ntt=1 if agegroup==1&(titular==1)

gen ag1nt2=.
replace ag1nt2=0 if agegroup==1&(titular==0)
replace ag1nt2=1 if agegroup==2

gen ag1nt3=.
replace ag1nt3=0 if agegroup==1&(titular==0)
replace ag1nt3=1 if agegroup==3

gen ag1t2=.
replace ag1t2=0 if agegroup==1&(titular==1)
replace ag1t2=1 if agegroup==2

gen ag1t3=.
replace ag1t3=0 if agegroup==1&(titular==1)
replace ag1t3=1 if agegroup==3

gen ag23=.
replace ag23=0 if agegroup==2
replace ag23=1 if agegroup==3


******************************************************************
**# Mother's marital status***************************************
******************************************************************

gen union=.
replace union=0 if s1p5_mom!=1&s1p5_mom!=.
replace union=1 if s1p5_mom==1

label var union "Union"

gen married=.
replace married=0 if s1p5_mom!=2&s1p5_mom!=.
replace married=1 if s1p5_mom==2

label var married "Married"

gen union_married=married
	replace union_married=1 if union==1
	label var union_married "Married or Union"

gen divorced=.
replace divorced=0 if s1p5_mom!=3&s1p5_mom!=4&s1p5_mom!=.
replace divorced=1 if s1p5_mom==3|s1p5_mom==4

label var divorced "Divorced/separated"

gen single=.
replace single=0 if s1p5_mom!=6&s1p5_mom!=.
replace single=1 if s1p5_mom==6

label var single "Single"

gen widow=.
replace widow=0 if s1p5_mom!=5&s1p5_mom!=.
replace widow=1 if s1p5_mom==5

label var widow "Widow"

******************************************************************
**# Mother's Presence**************************************
******************************************************************
/*
a1p15           byte    %10.0g     si_no      La madre del ni�o es miembro de este hogar
a1p16           byte    %32.0g     no_hogar_notes
                                              Por qu� raz�n la madre del ni�o no vive en este hogar
a1p16o          str68   %68s                  Otro, cu�l
a1p17           int     %10.0g                En qu� a�o muri� la madre del ni�o
a1p18           int     %10.0g                En qu� a�o dej� de vivir la madre del ni�o en este hogar
a1p19           byte    %10.0g     si_no      La madre le ha enviado dinero al ni�o en los �ltimos 12 meses
a1p20           byte    %10.0g     si_no      La madre le ha enviado bienes, comida o regalos al ni�o en los �ltimos 12 meses
a1p21           byte    %10.0g     si_no      La madre ha visto o ha visitado al ni�o en los �ltimos 12 meses
a1p22           byte    %10.0g                Cada cu�nto habla la mam� con el ni�o
*/

gen a1p15_yes=(a1p15==1)
label var a1p15_yes "Mother lives with child (=1)"


******************************************************************
**# Father's characteristics**************************************
******************************************************************
/*
a1p4            byte    %10.0g     si_no      El padre de... es miembro de este hogar
a1p5            double  %10.0g                Cuantas horas por semana pasa con el papa
a1p6            byte    %32.0g     no_hogar_notes
                                              Por qu� raz�n el padre del ni�o no vive en este hogar
a1p6o           str88   %88s                  Otro, cu�l
a1p7            int     %10.0g                En qu� a�o muri� el padre del ni�o
a1p8            int     %10.0g                En qu� a�o dej� de vivir el padre del ni�o en el hogar
a1p9            byte    %10.0g     si_no      El padre le ha enviado dinero en los �ltimos 12 meses
a1p10           byte    %10.0g     si_no      El padre le ha enviado bienes, comida, regalos en los �ltimos 12 meses
a1p11           byte    %10.0g     si_no      El padre ha visto o ha visitado al ni�o en los �ltimos 12 meses
*/
gen a1p4_yes=(a1p4==1)
label var a1p4_yes "Father lives with child (=1)"

gen a1p5_horas=a1p5
replace a1p5_horas=0 if a1p4_yes==0
label var a1p5_horas "Father with child (hours/week)"






label var a1p13 "Age father"

gen fathernothome=.
replace fathernothome=0 if s1p18!=77&s1p18!=88
replace fathernothome=1 if s1p18==77|s1p18==88

label var fathernothome "father not home"


gen mothernothome=.
replace mothernothome=0 if s1p21!=77&s1p21!=88
replace mothernothome=1 if s1p21==77|s1p21==88
 label var mothernothome "mother not home"


gen fatherwrite=.
replace fatherwrite=0 if s1p19==2|s1p19==3
replace fatherwrite=1 if s1p19==1

label var fatherwrite "father reads/write"

/*Also to create the correct var for fathers education (you can use a14 indi for that, and alternatively section 1 hh survey and we can compare)

0 year if codigo de nivel is ninguno or preescolar

2 years of codigo de nivel = 2 (education de adultos) and grado = 1

4 years of codigo de nivel = 2 (education de adultos) and grado = 2

6 years of codigo de nivel = 2 (education de adultos) and grado = 3

# as indicated in Grado if nivel = 3 (primaria)

6+ # as indicated in Grado if nivel = 4 (primaria) or nivel = 5 (tecnica basico)
9 + # as indicated in Grado if nivel = 6 (tecnica medio)

11 + # as indicated in Grado if nivel = 7 (tecnica superior) or nivel = 9 (univ)*/


**Using a14 indi variables
*a1p14a grado o año aprobado
*a1p14b nivel

gen father_educ=0 if a1p14b==0 | a1p14b==1 /*ninguno o preescolar*/

replace father_educ=a1p14b*a1p14a if a1p14b==2 // Edu adultos


replace father_educ=a1p14a if a1p14b==3 /*primaria*/

replace father_educ=6 + a1p14a if a1p14b==4 | a1p14b==5 /*secundaria o tecnica basico */

replace father_educ=9 + a1p14a if a1p14b==6 /*tecnica medio*/

replace father_educ=11 + a1p14a if a1p14b==7 | a1p14b==8 /*tecnica superior o universitario*/

label var father_educ "father years education"

****Using s1p20b hogar variables
*a1p14a grado o año aprobado
*a1p14b nivel

gen fathereduc=0 if s1p20b==0 | s1p20b==1 /*ninguno o preescolar*/

replace father_educ=s1p20b*s1p20a if s1p20b==2 // Edu adultos

replace fathereduc=s1p20a if s1p20b==3 /*primaria*/

replace fathereduc=6 + s1p20a if s1p20b==4 | s1p20b==5 /*secundaria o tecnica basico */

replace fathereduc=9 + s1p20a if s1p20b==6 /*tecnica medio*/

replace fathereduc=11 + s1p20a if s1p20b==7 | s1p20b==8 /*tecnica superior o universitario*/

label var fathereduc "father years education (hogar)"

replace fathereduc=father_educ if fathereduc==. //183 real changes made 
replace father_educ=fathereduc if father_educ==. //110 real changes made 


gen father_higheduc=.
replace father_higheduc=0 if a1p14b<=3
replace father_higheduc=1 if a1p14b>3 & a1p14b!=.

label var father_higheduc "father higher educ"

*note: there are 5 obs with nivel 2 and grado 0, 4 and 6

gen fatherhigheduc=.
replace fatherhigheduc=0 if s1p20b<=3
replace fatherhigheduc=1 if s1p20b>=4&s1p20b<=8

label var fatherhigheduc "father higher educ (hogar)"

*note: there is one obs with nivel 2 and grado 6 

******************************************************************
**# Parental Investments******************************************
******************************************************************

***Birthweight (HHS)

*From lb to kg ---> 0.453592

*Peso al nacer (also check s4p27b which is the unit used- lb or kg)
tab s4p27a, miss
* 241  missing values

gen birthweight=.
replace birthweight=s4p27a if s4p27b==1
replace birthweight=s4p27a*0.453592 if s4p27b==2
lab var birthweight "birthweight all"

gen birthweight_tarjeta=.
replace birthweight_tarjeta=birthweight if s4p28==1
label var birthweight_tarjeta "birthweight (info tarjeta)"
**********************
**# Caregiving******
**********************
* s1p9a: Quien cuida mayor parte del tiempo
* s1p18: Padre hogar-cp
* s1p21: Madre hogar-cp

gen care_mom=.
replace care_mom=0 if s1p9a!=s1p21
replace care_mom=1 if s1p9a==s1p21

label var care_mom "Main caregiver: mother"

gen care_dad=.
replace care_dad=0 if s1p9a!=s1p18
replace care_dad=1 if s1p9a==s1p18

label var care_dad "Main caregiver: father"


* Main caregiver other 
gen care_other=0 if care_dad==1 | care_mom==1
replace care_other=1 if care_dad==0 & care_mom==0
label var care_other "Main caregiver: other"

sum care_mom care_dad care_other


gen time_dad=.
replace time_dad=a1p5 if a1p5!=.
replace time_dad=0 if a1p5==.&a1p4==2

label var time_dad "Hours spent with dad (0 if not in hh)"

gen see_dad=.
replace see_dad=0 if a1p11==2 | a1p6==1 | a1p6==9
replace see_dad=1 if a1p11==1| a1p4==1

label var see_dad "has contact with dad"

gen resp_indi_mom=0 if (a1p1a==1 & a1p1b==9 & care_mom==0)| (a1p1b==9 & care_mom==0) | (a1p1a==1 & a1p1b!=9) | (a1p1a==2 & a1p3a!=s1p21 & s1p21!=.) 
replace resp_indi_mom=1 if (a1p1a==1 & a1p1b==9 & care_mom==1)|(a1p1b==9 & care_mom==1) | (a1p1a==2 & a1p3a==s1p21 & s1p21!=.)
label var resp_indi_mom "respondent indi mom"

gen resp_indi_gp=0 if (a1p1a==1 & a1p1b!=15)| (a1p1a==2 &  a1p3b!=15) 
replace resp_indi_gp=1 if (a1p1a==1 & a1p1b==15)| (a1p1a==2 &  a1p3b==15) 
label var resp_indi_gp "respondent indi grandparent"

*********************************************
**# Nutrition: food of child food of hh******
*********************************************

**Exclusive Breastfeeding

***For all ages
gen bf_months=.
replace bf_months=0 if a2p15b==0
replace bf_months=0 if a2p15b==4 | a2p15b==5 /*nunca dió lactancia exclusiva (4) nunca dió pecho (5)*/
replace bf_months=a2p15a/30 if a2p15b==1
replace bf_months=a2p15a/4 if a2p15b==2
replace bf_months=a2p15a if a2p15b==3
replace bf_months=a2p15a if a2p15b==6
replace bf_months=age_months2 if a2p15b==6 & a2p15a==.

gen exclusivebf=.
replace exclusivebf=0     if (bf_months<6 & age_months2>=6)  | ((bf_months<age_months2) & age_months2<6) | (a2p15b==4) | (a2p15b==5)
replace exclusivebf=1     if (bf_months>=6 & bf_months!=. & age_months2>=6) | (a2p15b==6) | ((bf_months==age_months2) & age_months2<6)

label var exclusivebf "exclusive bfeeding all"


*** Predominant breastfeeding under 6 months

gen predominantbf=.

replace predominantbf=0 if  ((a2p16==0) | ///
							(a3p1d>0 | a3p1e>0 | a3p2a>0 | a3p2b>0 | a3p2c>0 | a3p2d>0 | a3p2e>0 | a3p2f>0 | a3p2g>0 | a3p2h>0 | a3p2i>0 | a3p2j>0 | a3p2k>0 | a3p2l>0 | a3p2m>0 | a3p2n>0 | a3p2o>0 | a3p2p>0 | a3p2q>0 | a3p2r>0)) ///
							& (age_months3<6)

replace predominantbf=1 if (a2p16>0 | (a2p16>0 & a3p1a>0) | (a2p16>0 & a3p1b>0) | (a2p16>0 & a3p1c>0)) & ///
					(a3p1d==0 & a3p1e==0 & a3p2a==0 & a3p2b==0 & a3p2c==0 & a3p2d==0 & a3p2e==0 & a3p2f==0 & a3p2g==0 & a3p2h==0 & a3p2i==0 & a3p2j==0 & a3p2k==0 & a3p2l==0 & a3p2m==0 & a3p2n==0 & a3p2o==0 & a3p2p==0 & a3p2q==0 & a3p2r==0) ///
					 &(age_months3<6) 

label var predominantbf "predominant bfeeding (<6m)"

*** Continued breastfeeding  6 to 23 months

gen bfeeding=.

replace bfeeding=0 if (a2p16==0) & (age_months3>=6 & age_months3<=23)

replace bfeeding=1 if (a2p16>0 & a2p16!=.) &  (age_months3>=6 & age_months3<=23)

label var bfeeding "breasfeeding (6-23m)"

gen bfeeding1yr=.

replace bfeeding1yr=0 if (a2p16==0) & (age_months3>=12 & age_months3<=15)

replace bfeeding1yr=1 if (a2p16>0 & a2p16!=.) &  (age_months3>=12 & age_months3<=15)

label var bfeeding1yr "bfeeding at 1 yr (12-15m)"

**************************************************
******Food consumption****************************
**************************************************

**********************************
**Dietary diversity***************
**********************************
/*
Group 1 — grains, roots and tubers /// Grains, potatoes, bread
Group 2 — legumes and nuts ///Beans
Group 3 — dairy products (milk, yogurt, cheese) ///Milk
Group 4— flesh foods (meat, fish, poultry and liver/organ meats) /// Meat
Group 5— eggs
Group 6— vitamin-A rich fruits and vegetables
Group 7— other fruits and vegetables

a3p1a leche de polvo/vaca 		3
a3p1b leche de soya 			2
a3p1c jugo o fresco 			6
a3p1d gaseosas 					sweets
a3p1e cafe 						other

a3p2a frutas 					6
a3p2b pan dulce o pan 			1
a3p2c tortillas 			    1
a3p2d arroz						1
a3p2e frijol 					2
a3p2f papas 					1
a3p2g tomate 					7
a3p2h cebolla 					7
a3p2i chayote/lechuga/etc 		6
a3p2j otros vegetales 			6
a3p2k galletas saladitas 		1	
a3p2l huevos 					5
a3p2m queso/cuajada 			3
a3p2n caramelos o helados 		sweets
a3p2o carne de res o pollo 		4
a3p2q meneitos, tortillas, etc  fat ?
a3p2p sopa rapida (maggi) 		other
a3p2r soya 						2

**Groups of food from Maluccio and Flores (2004)

/*
Grains, potatoes, bread  (group 1)
Beans (group 2)
Meat (group 4)
Milk (group 3)
Fats (fat)
Fruits and vegetables (group 6 and 7)
Alcohol and tobacco 
Sweets (sweets)
Other (other)

eggs? maybe with meat (proteins)
*/		

*/

************************
***Version I************
************************
*VERSION 1: Consumed at least one item at least once during 7 days

gen fg1=.

replace fg1=0 if a3p2b==0 & ///  /*pan dulce o pan 			1*/
				 a3p2c==0 & ///  /*tortillas 			    1*/
				 a3p2d==0 & ///  /*arroz					1*/
				 a3p2f==0 & ///  /*papas 					1*/
				 a3p2k==0   ///  /*galletas saladitas 		1*/	
				 
replace fg1=1 if (a3p2b>0 & a3p2b!=.) | ///   /*pan dulce o pan 			1*/
				 (a3p2c>0 & a3p2c!=.) | ///  /*tortillas 			    1*/
				 (a3p2d>0 & a3p2d!=.) | ///  /*arroz					    1*/
				 (a3p2f>0 & a3p2f!=.) | ///   /*papas 					1*/
				 (a3p2k>0 & a3p2k!=.)  ///  /*galletas saladitas 		1*/	
				 
label var fg1 "food group 1"

gen fg2=.

replace fg2=0 if a3p2e==0 & /// 	/* frijol 					2*/
				 a3p2r==0 & ///   	 /* soya 				    2*/
				 a3p1b==0 			/*leche de soya             2*/
				 

replace fg2=1 if (a3p2e>0 & a3p2e!=.) | ///  /* frijol 					2*/
				 (a3p2r>0 & a3p2r!=.) | ///  /* soya 					2*/
				 (a3p1b>0 & a3p1b!=.)        /*leche de soya			2*/
				 
label var fg2 "food group 2"

gen fg3=.

replace fg3=0 if a3p1a==0 & /// /*leche de polvo/vaca 		3*/
			     a3p2m==0   /// /* queso/cuajada 			3*/
				 
replace fg3=1 if (a3p1a>0 & a3p1a!=.) | /// /*leche de polvo/vaca 		3*/
			     (a3p2m>0 & a3p2m!=.)   /// /* queso/cuajada 			3*/
				 
label var fg3 "food group 3"	

gen fg4=.

replace fg4=0 if a3p2o==0      /* carne de res o pollo 		4*/

replace fg4=1 if (a3p2o>0 & a3p2o!=.)  /* carne de res o pollo 		4*/

label var fg4 "food group 4"

gen fg5=.

replace fg5=0 if a3p2l==0              /* huevos 					5*/

replace fg5=1 if (a3p2l>0 & a3p2l!=.)  /* huevos 					5*/

label var fg5 "food group 5"

gen fg6=.

replace fg6=0 if a3p1c==0 & /// /* jugo o fresco 			6*/
				 a3p2a==0 & /// /* frutas 					6*/
				 a3p2i==0 & /// /* chayote/lechuga/etc 		6*/
				 a3p2j==0   /// /* otros vegetales 			6*/

replace fg6=1 if (a3p1c>0 & a3p1c!=.)| /// /* jugo o fresco 			6*/
				 (a3p2a>0 & a3p2a!=.)| /// /* frutas 					6*/
				 (a3p2i>0 & a3p2i!=.)| /// /* chayote/lechuga/etc 		6*/
				 (a3p2j>0 & a3p2j!=.)    /* otros vegetales 			6*/
				 
label var fg6 "food group 6"
			
gen fg7=.

replace fg7=0 if a3p2g==0 & /// /* tomate 					7*/
                 a3p2h==0      /* cebolla 					7*/

replace fg7=1 if (a3p2g>0 & a3p2g!=.) | /// /* tomate 					7*/
                 (a3p2h>0 & a3p2h!=.)      /* cebolla 					7*/

label var fg7 "food group 7"



**Minimum dietary diversity (6 and above)

gen mdd=. 

replace mdd=0 if [(fg1 + fg2 + fg3 + fg4 + fg5 + fg6 + fg7)< 4 ] & (age_months3>=6&age_months3!=.)

replace mdd=1 if [((fg1 + fg2 + fg3 + fg4 + fg5 + fg6 +fg7)>= 4)&((fg1 + fg2 + fg3 + fg4 + fg5 + fg6 +fg7)!=.)] & (age_months3>=6&age_months3!=.)

label var mdd "minimum dietary diversity (>=6m)"

gen ndd=(fg1 + fg2 + fg3 + fg4 + fg5 + fg6 +fg7) if (age_months3>=6&age_months3!=.)

label var ndd "nb of food groups mdd (>=6m)"



/*Checks*/

local food a3p1a a3p1b a3p1c a3p1d a3p1e a3p2a a3p2b a3p2c a3p2d a3p2e a3p2f a3p2g a3p2h a3p2i a3p2j a3p2k a3p2l a3p2m a3p2n a3p2o a3p2p a3p2q a3p2r

foreach var of local food {
	
	gen  `var'_d=0 if  `var'==0
	replace  `var'_d=1 if  `var'>0 &  `var'!=.
	
}

*group 1
sum a3p2b_d  a3p2c_d a3p2d_d  a3p2f_d a3p2k_d fg1 if (age_months3>=6&age_months3!=.)
*group 2
sum a3p2e_d  a3p2r_d a3p1b_d fg2 if (age_months3>=6&age_months3!=.)
*group 3
sum  a3p1a_d a3p2m_d fg3  if (age_months3>=6&age_months3!=.)
*group 4
sum a3p2o_d fg4 if (age_months3>=6&age_months3!=.)
*group 5
sum a3p2l_d fg5 if (age_months3>=6&age_months3!=.)
*group 6
sum a3p1c_d a3p2a_d a3p2i_d a3p2j_d fg6 if (age_months3>=6&age_months3!=.)
*group 7 
sum a3p2g_d a3p2h_d fg7     if (age_months3>=6&age_months3!=.)


tab mdd if (age_months3>=6&age_months3!=.)

tab ndd if (age_months3>=6&age_months3!=.)


************************
***Version II***********
************************

*VERSION 2: Consumed at least one item  during 7 days

gen fg1_alt=.

replace fg1_alt=0 if a3p2b<7 & ///  /*pan dulce o pan 			1*/
				 a3p2c<7 & ///  /*tortillas 			    1*/
				 a3p2d<7 & ///  /*arroz					1*/
				 a3p2f<7 & ///  /*papas 					1*/
				 a3p2k<7   ///  /*galletas saladitas 		1*/	
				 
replace fg1_alt=1 if (a3p2b==7 & a3p2b!=.) | ///   /*pan dulce o pan 			1*/
				 (a3p2c==7 & a3p2c!=.) | ///  /*tortillas 			    1*/
				 (a3p2d==7 & a3p2d!=.) | ///  /*arroz					    1*/
				 (a3p2f==7 & a3p2f!=.) | ///   /*papas 					1*/
				 (a3p2k==7 & a3p2k!=.)  ///  /*galletas saladitas 		1*/	
				 
label var fg1_alt "food group 1- alternative"

gen fg2_alt=.

replace fg2_alt=0 if a3p2e<7 & /// 	/* frijol 					2*/
				 a3p2r<7 & ///   	 /* soya 				    2*/
				 a3p1b<7 			/*leche de soya             2*/
				 

replace fg2_alt=1 if (a3p2e==7 & a3p2e!=.) | ///  /* frijol 					2*/
				 (a3p2r==7 & a3p2r!=.) | ///  /* soya 					2*/
				 (a3p1b==7 & a3p1b!=.)        /*leche de soya			2*/
				 
label var fg2_alt "food group 2- alternative"

gen fg3_alt=.

replace fg3_alt=0 if a3p1a<7 & /// /*leche de polvo/vaca 		3*/
			     a3p2m<7   /// /* queso/cuajada 			3*/
				 
replace fg3_alt=1 if (a3p1a==7 & a3p1a!=.) | /// /*leche de polvo/vaca 		3*/
			     (a3p2m==7 & a3p2m!=.)   /// /* queso/cuajada 			3*/
				 
label var fg3_alt "food group 3- alternative"	

gen fg4_alt=.

replace fg4_alt=0 if a3p2o<7      /* carne de res o pollo 		4*/

replace fg4_alt=1 if (a3p2o==7 & a3p2o!=.)  /* carne de res o pollo 		4*/

label var fg4_alt "food group 4- alternative"

gen fg5_alt=.

replace fg5_alt=0 if a3p2l<7              /* huevos 					5*/

replace fg5_alt=1 if (a3p2l==7 & a3p2l!=.)  /* huevos 					5*/

label var fg5_alt "food group 5- alternative"

gen fg6_alt=.

replace fg6_alt=0 if a3p1c<7 & /// /* jugo o fresco 			6*/
				 a3p2a<7 & /// /* frutas 					6*/
				 a3p2i<7 & /// /* chayote/lechuga/etc 		6*/
				 a3p2j<7   /// /* otros vegetales 			6*/

replace fg6_alt=1 if (a3p1c==7 & a3p1c!=.)| /// /* jugo o fresco 			6*/
				 (a3p2a==7 & a3p2a!=.)| /// /* frutas 					6*/
				 (a3p2i==7 & a3p2i!=.)| /// /* chayote/lechuga/etc 		6*/
				 (a3p2j==7 & a3p2j!=.)    /* otros vegetales 			6*/
				 
label var fg6_alt "food group 6- alternative"
			
gen fg7_alt=.

replace fg7_alt=0 if a3p2g<7 & /// /* tomate 					7*/
                 a3p2h<7      /* cebolla 					7*/

replace fg7_alt=1 if (a3p2g==7 & a3p2g!=.) | /// /* tomate 					7*/
                 (a3p2h==7 & a3p2h!=.)      /* cebolla 					7*/

label var fg7_alt "food group 7- alternative"



**Minimum dietary diversity (6 and above)- Alternative measure

gen mdd_alt=. 

replace mdd_alt=0 if [(fg1_alt + fg2_alt + fg3_alt + fg4_alt + fg5_alt + fg6_alt + fg7_alt)< 4 ] & (age_months3>=6&age_months3!=.)

replace mdd_alt=1 if [((fg1_alt + fg2_alt + fg3_alt + fg4_alt + fg5_alt + fg6_alt +fg7_alt)>= 4)&((fg1_alt + fg2_alt + fg3_alt + fg4_alt + fg5_alt + fg6_alt +fg7_alt)!=.)] & (age_months3>=6&age_months3!=.)

label var mdd_alt "minimum dietary diversity (>=6m)- alternative"

gen ndd_alt=(fg1_alt + fg2_alt + fg3_alt + fg4_alt + fg5_alt + fg6_alt +fg7_alt) if (age_months3>=6&age_months3!=.)

label var ndd_alt "nb of food groups mdd (>=6m)- alternative"


/*
*Checks
*group 1
br a3p2b a3p2c a3p2d  a3p2f a3p2k fg1_alt if (age_months3>=6&age_months3!=.)
*group 2
br a3p2e  a3p2r a3p1b fg2_alt if (age_months3>=6&age_months3!=.)
*group 3
br  a3p1a a3p2m fg3_alt  if (age_months3>=6&age_months3!=.)
*group 4
br a3p2o fg4_alt if (age_months3>=6&age_months3!=.)
*group 5
br a3p2l fg5_alt if (age_months3>=6&age_months3!=.)
*group 6
br a3p1c a3p2a a3p2i a3p2j fg6_alt if (age_months3>=6&age_months3!=.)
*group 7 
br a3p2g a3p2h fg7_alt     if (age_months3>=6&age_months3!=.)
*/
**********************************
**Food consumption score**********
**********************************
/*
	a3p2b pan dulce o pan 		1
	a3p2c tortillas 		    1
	a3p2d arroz					1
	a3p2f papas 				1
	a3p2r soya 					1 Note: By definition, soybeans are not a pulse because their seed is not dry (it contains high amounts of oil).
	a3p1b leche de soya 		1
	a3p2k galletas saladitas 	1
	a3p2e frijol 				2
	a3p2i chayote/lechuga/etc 	3
	a3p2j otros vegetales 		3
	a3p2g tomate 				3
	a3p2h cebolla 				3
	a3p1c jugo o fresco 		4
	a3p2a frutas 				4
	a3p2o carne de res o pollo 	5
	a3p2l huevos 				5
	a3p1a leche de polvo/vaca 	6
	a3p2m queso/cuajada 		6
	a3p1d gaseosas 				7
	a3p2n caramelos o helados 	7
	a3p2q meneitos, tortillas, etc 	8
	a3p2p sopa rapida (maggi) 		8
	a3p1e cafe 						9


*/

*main staples (w=2)
*	a3p2b pan dulce o pan, a3p2c tortillas, a3p2d arroz, a3p2f papas, a3p2r soya, a3p2k galletas saladitas , a3p1b leche de soya 

gen fc1= a3p2b + a3p2c + a3p2d + a3p2f + a3p2r + a3p2k + a3p1b

label var fc1 "group: main staples"

*pulses (w=3)
* a3p2e frijol 
gen fc2= a3p2e

label var fc2 "group: pulses"

*vegetables (w=1)

* a3p2i chayote/lechuga/etc , a3p2j otros vegetales , a3p2g tomate, a3p2h cebolla 

gen fc3= a3p2i + a3p2j + a3p2g + a3p2h 

label var fc3 "group: vegetables"

*fruits (w=1)
*a3p1c jugo o fresco , a3p2a frutas 

gen fc4= a3p1c + a3p2a 

label var fc4 "group: fruits"

*Meat and fish (w=4)
*a3p2o carne de res o pollo, a3p2l huevos 

gen fc5= a3p2o + a3p2l 

label var fc5 "group: meat and fish"

*Milk (w=4)
*a3p1a leche de polvo/vaca, a3p2m queso/cuajada

gen fc6= a3p1a + a3p2m 

label var fc6 "group: milk"

*Sugar (w=0.5)
* a3p1d gaseosas, a3p2n caramelos o helados
	
gen fc7=a3p1d +	a3p2n 

label var fc7 "group: sugar"

*Oil (w=0.5)

*a3p2q meneitos, tortillas, etc, a3p2p sopa rapida (maggi)

gen fc8=a3p2q + a3p2p 
replace fc8=a3p2p if a3p2q==. /*only one missing for meneitos*/

label var fc8 "group: oil"

*Condiments (w=0)
*a3p1e cafe 
gen fc9= a3p1e 
replace fc9=0 if a3p1e==. & a3p1a!=.

label var fc9 "group: condiments"


gen fcs= (2* fc1) + (3* fc2) + (1* fc3) + (1* fc4) + (4* fc5) + (4* fc6) + (0.5* fc7) + (0.5* fc8) + (0* fc9) if (fc1!=.&fc2!=.&fc3!=.&fc4!=.&fc5!=.&fc6!=.&fc7!=.&fc8!=.&fc9!=.)  & (age_months3>=6&age_months3!=.)

label var fcs "Food consumption score (>=6m)"



****Other variables

*	a3p1a leche de polvo/vaca 
*	a3p2o carne de res o pollo 	

gen ofg1=.
replace ofg1=0 if (a3p1a==0 | a3p2o==0) & (age_months3>=6&age_months3!=.)
replace ofg1=1 if (a3p1a!=0 & a3p2o!=0 & a3p1a!=. & a3p2o!=.) & (age_months3>=6&age_months3!=.)

label var ofg1 "food: animal + milk"

*	a3p1b leche de soya 
*	a3p2r soya 					

gen ofg2=.
replace ofg2=0 if (ofg1==0 | a3p1b==0 | a3p2r==0) & (age_months3>=6&age_months3!=.)
replace ofg2=1 if (ofg1==1 & a3p1b!=0 & a3p2r!=0 & a3p1b!=. & a3p2r!=.) & (age_months3>=6&age_months3!=.)

label var ofg2 "food: animal protein + soya"

* a3p2i chayote/lechuga/etc
gen ofg3=.
replace ofg3=0 if (a3p2i==0) & (age_months3>=6&age_months3!=.)
replace ofg3=1 if (a3p2i!=0 & a3p2i!=.) & (age_months3>=6&age_months3!=.)

label var ofg3 "food: green veggies"


*   a3p1c jugo o fresco 
*   a3p2a frutas 
* 	a3p2f papas 				
*	a3p2i chayote/lechuga/etc	
*   a3p2j otros vegetales 	
*   a3p2g tomate 	
*   a3p2h cebolla

gen ofg4=.
replace ofg4=0 if (a3p1c==0 | a3p2a==0 | a3p2f==0 | a3p2i==0 | a3p2j==0 | a3p2g==0 | a3p2h==0) & (age_months3>=6&age_months3!=.)
replace ofg4=1 if (a3p1c!=0 & a3p2a!=0 & a3p2f!=0 & a3p2i!=0 & a3p2j!=0 & a3p2g!=0 & a3p2h!=0 & a3p1c!=. & a3p2a!=. & a3p2f!=. & a3p2i!=. & a3p2j!=. & a3p2g!=. &  a3p2h!=.) & (age_months3>=6&age_months3!=.)

label var ofg4 "food: fruit and veggies"

********************************************
**#Health***********************************
********************************************

****Control- revelant variable for 0-3 year old children

gen control=.
replace control=0 if s4p1a==2
replace control=1 if s4p1a==1

label var control "control"

gen weighed=.
replace weighed=0 if s4p3a==2 | s4p1a==2 | (s4p1a==1 & s4p3a==.)
replace weighed=1 if s4p3a==1

label var weighed "control + weighed"

gen timesweighed=.
replace timesweighed=0 if weighed==0 | (weighed==1 & s4p3b==.)
replace timesweighed=s4p3b if (weighed==1&s4p3b!=.)

label var timesweighed "times weighed"



****Tarjeta de control

gen tarjeta=.
replace tarjeta=0 if s4p4==2 | weighed==0
replace tarjeta=1 if s4p4==1

label var tarjeta "tarjeta control"

gen updated_tarjeta=.
replace updated_tarjeta=0 if tarjeta==0 | (s4p6==2) | (tarjeta==1 & s4p6==.)
replace updated_tarjeta=1 if s4p6==1

label var updated_tarjeta "updated tarjeta control"


*****Vitamins


gen vitaminA=.
replace vitaminA=0 if s4p9a==2
replace vitaminA=1 if s4p9a==1

label var vitaminA "vitamin A last 6m"

gen iron=.
replace iron=0 if s4p10a==2
replace iron=1 if s4p10a==1

label var iron "iron last 6m"

*****Diarrhea/other illnesses

gen diarrhea=.
replace diarrhea=0 if s4p29a==2
replace diarrhea=1 if s4p29a==1

label var diarrhea "diarrhea last month"

gen diarrhea_doctor=. 
replace diarrhea_doctor=0 if s4p30a==2
replace diarrhea_doctor=1 if s4p30a==1

label var diarrhea_doctor "consultation when had diarrhea"

gen other_illness=.
replace other_illness=0 if s4p36==2
replace other_illness=1 if s4p36==1

label var other_illness "other illness last month"

gen illness_doctor=.
replace illness_doctor=0 if s4p38a==2
replace illness_doctor=1 if s4p38a==1

label var illness_doctor "consultation for illness"

gen illness=.
replace illness=0 if diarrhea==0 & other_illness==0
replace illness=1 if diarrhea==1 | other_illness==1
label var illness "any illness last month"
 
gen other_illness12=.
replace other_illness12=0 if s4p52==6
replace other_illness12=1 if s4p52!=6&s4p52!=.

label var other_illness12 "other illness 12 months"

gen illness12=.
replace illness12=0 if illness==0 & other_illness12==0
replace illness12=1 if illness==1 | other_illness12==1
label var illness12 "any illness last 12 months"

gen deworming=.
replace deworming=0 if s4p57a==2
replace deworming=1 if s4p57a==1

label var deworming "deworming"


gen disability=.
replace disability=0 if s4p58a==2
replace disability=1 if s4p58a==1

label var disability "disability"


************************************************
*********Health indices*************************
************************************************
gen invillness12=illness12*(-1)

local health control vitaminA iron invillness12

 foreach x of local health {
su `x' if early_treated==0
gen `x'_sd= (`x'- r(mean)) / r(sd)

}
egen health_av=rowmean(control_sd vitaminA_sd iron_sd invillness12_sd)
su health_av if early_treated==0
gen health_sd= (health_av- r(mean)) / r(sd)
label var health_sd "health sd"

********************************************
**#Vaccination******************************
********************************************

***up-to-date vaccinations for children ages 12-23 months


/*

According to the Nicaraguan Ministry of Health guidelines, a child age 12-23 months should have (at
least) (1) one dose of BCG, (2) three doses of polio, (3) three doses of either Pentavalente or DPT, and (4)
one dose of MMR (or possibly just measles if vaccinated before MINSA changed to MMR in 1998). We
calculate whether they have completed the vaccine schedule to date, that is, given their current age in
months, calling this up-to-date vaccination. For children under 18 months, the DPT booster is not required
and is therefore not needed to be up-to-date; for those 18 months or older, it is.


From Barham and Maluccio (2008)

coverage for each vaccine: it takes the value one if a child received all of the recommended doses of that vaccine by the time of the
survey, and zero otherwise. A child is not considered to be vaccinated against DPT or polio unless they have received their third 
dose of the DPT vaccine (DPT3) or the oral polio vaccine (OPV3), respectively. 
A summary measure also was created to determine whether the child was fully vaccinated (FVC) with all four of the vaccines 
(i.e., was covered with BCG, OPV3, DPT3, and MCV).

The World Health Organization and other public health institutions typically use <12 month and 12–23 month age groups to 
evaluate up-to-date vaccination coverage for a child depending on the vaccine schedule.

-BCG vaccinations should be given at birth; therefore we use children <12 months of age as the population group for measuring 
on-time BCG vaccination rates. 
-For MCV, OPV, and DPT vaccination, the 12–23 month age group is used to assess on-time vaccination, because MCV vaccination 
is scheduled to be given at 12 months of age, and a large proportion of children under 12 months of age will not have received 
all three doses of OPV or DPT vaccines under the prescribed application schedule at 2, 4, and 6 months of age. 

"catch-up" for BCG, the catch-up group comprises children 12–23 months of age and for all the other vaccines, 24–35 months. 
*/

*****Coverage vaccines

* add any dpt, dpt1 
* also add on time vaccinations, we need to check if we have the date they received the vaccine. 
* one var, fully vaccinated.

*BCG, Poliomielitis oral, pentavalente DPT/HB+Hib 

*BCG- newborn
gen bcg=.
replace bcg=0 if s4p11==2
replace bcg=1 if s4p11==1
label var bcg "BCG vaccine"

gen bcg_tarjeta=0 if s4p13==2
replace bcg_tarjeta=1 if s4p13==1
label var bcg_tarjeta "bcg info from tarjeta"

*Polio (3 dosis before 6 months)
gen opv3=.
replace opv3=0 if (s4p16a==2) | (s4p16a==1 & s4p16b<3)
replace opv3=1 if (s4p16a==1 & s4p16b>=3)
label var opv3 "polio3 vaccine"

*DTP (3 dosis before 6 months)
gen dtp3=.
replace dtp3=0 if (s4p15a==2 & s4p14a==2) | ((s4p15a==1 & s4p15b<3) & (s4p14a==2)) | ((s4p15a==2) & (s4p14a==1 & s4p14b<3)) | ((s4p15a==1 & s4p15b<3) & (s4p14a==1 & s4p14b<3))
replace dtp3=1 if (s4p15a==1 & s4p15b>=3) | (s4p14a==1 & s4p14b>=3)
label var dtp3 "DPT3 vaccine"

gen opv_dtp_tarjeta=0 if s4p17==2
replace opv_dtp_tarjeta=1 if s4p17==1 | s4p17==3
label var opv_dtp_tarjeta "polio/dtp info from tarjeta"

*rotavirus (3 dosis before 6 months)
gen rotavirus=.
replace rotavirus=0 if (s4p24a==2) | (s4p24a==1 & s4p24b<3)
replace rotavirus=1 if (s4p24a==1 & s4p24b>=3)
label var rotavirus "rotavirus vaccine"

*neumococo - we don't ask


*DTP (18 months)
gen dpt=.
replace dpt=0 if s4p25a==2 & s4p15c==0 
replace dpt=1 if s4p25a==1 | s4p15c>0 
label var dpt "dpt booster"


gen rota_dpt_tarjeta=0 if s4p26==2
replace rota_dpt_tarjeta=1 if s4p26==1 | s4p26==3
label var rota_dpt_tarjeta "rotavirus/dpt info from tarjeta"

*MMR (1 dose)
gen mmr=.
replace mmr=0 if s4p18a==2 
replace mmr=1 if s4p18a==1 
label var mmr "MCV vaccine"


gen sarampion=.
replace sarampion=0 if s4p21a==2 
replace sarampion=1 if s4p21a==1 

label var sarampion "sarampion (at least 1)"

gen mmr_sarampion=0 if mmr==0 & sarampion==0
replace mmr_sarampion=1 if mmr==1 | sarampion==1
label var mmr_sarampion "MCV vaccine or sarampion"

gen mmr_sarampion_tarjeta=0 if s4p20==2 & s4p23==2
replace mmr_sarampion_tarjeta=1 if s4p20==1 | s4p23==1
label var mmr_sarampion_tarjeta "mmr/sarampion info from tarjeta"



*****Up-to-date vaccination rates

gen utdvaccination=.

replace utdvaccination=0 if bcg==0 & age_months_hogar<12
replace utdvaccination=1 if bcg==1 & age_months_hogar<12

replace utdvaccination=0 if (dtp3==0 | opv3==0 | mmr_sarampion==0) & (age_months_hogar>=12 & age_months_hogar<=23)
replace utdvaccination=1 if (dtp3==1 & opv3==1 & mmr_sarampion==1) & (age_months_hogar>=12 & age_months_hogar<=23)

label var utdvaccination "up-to-date vaccination (<=23m)"

/*The World Health Organization and other public health institutions typically use <12 month and 12–23 month age groups to 
evaluate up-to-date vaccination coverage for a child depending on the vaccine schedule.
*/

***Fully vaccinates (FVC)

** double check the age groups. 

*younger than 1
*-BCG vaccinations should be given at birth; therefore we use children <12 months of age as the population group for measuring  on-time BCG vaccination rates. 

***Fully vaccinates (FVC)

** double check the age groups. 

*younger than 1
*-BCG vaccinations should be given at birth; therefore we use children <12 months of age as the population group for measuring  on-time BCG vaccination rates. 

gen fvc=.
*replace fvc=0 if bcg==0 & age_months_hogar<12
replace fvc=0 if age_months_hogar<12 & bcg~=.
replace fvc=1 if bcg==1 & age_months_hogar<12 & bcg~=.

*age 12-23 months  
*bcg, polio, pentavalente, rotavirus* (in version 2)
*-For MCV, OPV, and DPT vaccination, the 12–23 month age group is used to assess on-time vaccination, because MCV vaccination  is scheduled to be given at 12 months of age, and a large proportion of children under 12 months of age will not have received  all three doses of OPV or DPT vaccines under the prescribed application schedule at 2, 4, and 6 months of age. 

*replace fvc=0 if (bcg==0 | dtp3==0 | opv3==0 | mmr_sarampion==0) & (age_months_hogar>=12 & age_months_hogar<=23
replace fvc=0 if  (age_months_hogar>=12 & age_months_hogar<=23) & bcg~=.
replace fvc=1 if (bcg==1 & dtp3==1 & opv3==1 & mmr_sarampion==1) & (age_months_hogar>=12 & age_months_hogar<=23) 

*older than 23 months  
*dtp* (in version 2) and mrr

*replace fvc=0 if (bcg==0 | dtp3==0 | opv3==0 | mmr_sarampion==0) & (age_months_hogar>23 & age_months_hogar!=.)
replace fvc=0 if  (age_months_hogar>23 & age_months_hogar!=.) & bcg~=.
replace fvc=1 if (bcg==1 & dtp3==1 & opv3==1 & mmr_sarampion==1) & (age_months_hogar>23 & age_months_hogar!=.)

label var fvc "fully vaccinated all"


*****Version 2 of fully vaccinated (including rotavirus and booster of DPT)

*younger than 1
*-BCG vaccinations should be given at birth; therefore we use children <12 months of age as the population group for measuring  on-time BCG vaccination rates. 

gen fvc2=.
*replace fvc2=0 if bcg==0 & age_months_hogar<12
replace fvc2=0 if age_months_hogar<12 &  bcg~=.
replace fvc2=1 if bcg==1 & age_months_hogar<12

*age 12-23 months  
*bcg, polio, pentavalente, rotavirus* (in version 2) mrr and DPT booster
 
*-For MCV, OPV, and DPT vaccination, the 12–23 month age group is used to assess on-time vaccination, because MCV vaccination  is scheduled to be given at 12 months of age, and a large proportion of children under 12 months of age will not have received  all three doses of OPV or DPT vaccines under the prescribed application schedule at 2, 4, and 6 months of age. 

*replace fvc2=0 if (bcg==0 | dtp3==0 | opv3==0| rotavirus==0  | mmr_sarampion==0 | dpt==0) & (age_months_hogar>=12 & age_months_hogar<=23)
replace fvc2=0 if (age_months_hogar>=12 & age_months_hogar<=23) & bcg~=.
replace fvc2=1 if (bcg==1 & dtp3==1 & opv3==1 & rotavirus==1 & mmr_sarampion==1) & (age_months_hogar>=12 & age_months_hogar<=23)

*older 23

*replace fvc2=0 if (bcg==0 | dtp3==0 | opv3==0| rotavirus==0  | mmr_sarampion==0 | dpt==0) & (age_months_hogar>23 & age_months_hogar!=.)
replace fvc2=0 if (age_months_hogar>23 & age_months_hogar!=.) & bcg~=.
replace fvc2=1 if (bcg==1 & dtp3==1 & opv3==1 & rotavirus==1 & mmr_sarampion==1  & dpt==1) & (age_months_hogar>23 & age_months_hogar!=.)

label var fvc2 "fully vaccinated v2 all"

****Conditional on having the info in the tarjeta

gen fvc2_tarjeta=.
*replace fvc2_tarjeta=0 if bcg==0 & age_months_hogar<12 & bcg_tarjeta==1
replace fvc2_tarjeta=0 if age_months_hogar<12 & bcg_tarjeta==1
replace fvc2_tarjeta=1 if bcg==1 & age_months_hogar<12 & bcg_tarjeta==1

*age 12-23 months  
*bcg, polio, pentavalente, rotavirus* (in version 2) mrr and DPT booster
 
*-For MCV, OPV, and DPT vaccination, the 12–23 month age group is used to assess on-time vaccination, because MCV vaccination  is scheduled to be given at 12 months of age, and a large proportion of children under 12 months of age will not have received  all three doses of OPV or DPT vaccines under the prescribed application schedule at 2, 4, and 6 months of age. 

*replace fvc2_tarjeta=0 if (bcg==0 | dtp3==0 | opv3==0| rotavirus==0  | mmr_sarampion==0 | dpt==0) & (age_months_hogar>=12 & age_months_hogar<=23) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

replace fvc2_tarjeta=0 if  (age_months_hogar>=12 & age_months_hogar<=23) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

replace fvc2_tarjeta=1 if (bcg==1 & dtp3==1 & opv3==1 & rotavirus==1 & mmr_sarampion==1) & (age_months_hogar>=12 & age_months_hogar<=23) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

*older 23

*replace fvc2_tarjeta=0 if (bcg==0 | dtp3==0 | opv3==0| rotavirus==0  | mmr_sarampion==0 | dpt==0) & (age_months_hogar>23) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

replace fvc2_tarjeta=0 if (age_months_hogar>23 & age_months_hogar!=.) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

replace fvc2_tarjeta=1 if (bcg==1 & dtp3==1 & opv3==1 & rotavirus==1 & mmr_sarampion==1  & dpt==1) & (age_months_hogar>23  & age_months_hogar!=.) & (bcg_tarjeta==1 & opv_dtp_tarjeta==1 & mmr_sarampion_tarjeta==1 & rota_dpt_tarjeta==1)

label var fvc2_tarjeta "fully vaccinated v2 all (tarjeta)"


*Age received vaccine

gen bcg_age=datediff_frac(bdate, s4p12_fecha, "month")
*Note: 5.3% have negative values

gen mmr_age=datediff_frac(bdate, s4p19_fecha, "month")
*Note: 1.25% have negative values

***On time
*gen bcg_ontime=0 if bcg==0 | (bcg_age>12 & bcg_age!=.) & age_months_hogar>=12
gen bcg_ontime=0 if age_months_hogar>=12 & bcg~=.
replace bcg_ontime=1 if bcg_age<=12 & age_months_hogar>=12

replace bcg_ontime=1 if age_months_hogar<12
label var bcg_ontime "bcg on time (12m or older)"

*gen mmr_ontime=0 if (mmr==0 & sarampion==0) | (mmr_age>23 & mmr_age!=.) & age_months_hogar>=23
gen mmr_ontime=0 if  age_months_hogar>23 & mmr~=.
replace mmr_ontime=1 if mmr_age<=23 & age_months_hogar>23
replace mmr_ontime=1 if age_months_hogar<=23

label var mmr_ontime "mcv on time (24m or older)"

***Catch-up
*"catch-up" for BCG, the catch-up group comprises children 12–23 months of age and for all the other vaccines, 24–35 months. 

*gen bcg_catchup=0 if bcg==0 | (bcg_age>23 & bcg_age!=.) & age_months_hogar>=23
gen 		bcg_catchup=0 if age_months_hogar>23 & bcg~=.
replace 	bcg_catchup=1 if bcg_age<=23 & age_months_hogar>23
replace 	bcg_catchup=1 if age_months_hogar<=23
label var 	bcg_catchup "bcg catchup"

*gen mmr_catchup=0 if mmr==0 | (mmr_age>35 & mmr_age!=.) & age_months_hogar>=35
gen 		mmr_catchup=0 if  age_months_hogar>35 & mmr~=.
replace 	mmr_catchup=1 if mmr_age<=35 & age_months_hogar>35  & age_months_hogar!=.
replace 	mmr_catchup=1 if age_months_hogar<=35
label var 	mmr_catchup "mmr catchup"

gen catchup=1 if age_months_hogar<12 &  bcg~=.

replace catchup=0 if bcg_catchup==0 & age_months_hogar>=12 & age_months_hogar<=35
replace catchup=1 if bcg_catchup==1 & age_months_hogar>=12 & age_months_hogar<=35

replace catchup=0 if bcg_catchup==0 | mmr_catchup==0 & age_months_hogar>35  & age_months_hogar!=.
replace catchup=1 if bcg_catchup==1 & mmr_catchup==1 & age_months_hogar>35  & age_months_hogar!=.

label var catchup "catchup"


***Conditional on having the info in the tarjeta

gen catchup_tarjeta=1 if age_months_hogar<12 & bcg_tarjeta==1 &  bcg~=.

replace catchup_tarjeta=0 if bcg_catchup==0 & age_months_hogar>=12 & age_months_hogar<=35  & tarjeta==1
replace catchup_tarjeta=1 if bcg_catchup==1 & age_months_hogar>=12 & age_months_hogar<=35  & tarjeta==1

replace catchup_tarjeta=0 if bcg_catchup==0 | mmr_catchup==0 & age_months_hogar>35 & age_months_hogar!=. & tarjeta==1
replace catchup_tarjeta=1 if bcg_catchup==1 & mmr_catchup==1 & age_months_hogar>35 & age_months_hogar!=. & tarjeta==1

label var catchup_tarjeta "catchup (tarjeta)"

********************************************
**#Stimulation******************************
********************************************

**Telling stories and Reading books
gen telling=.
replace telling=0 if a2p1==2
replace telling=1 if a2p1==1
label var telling "tell stories"
label def yesno 0 "no" 1 "yes"
label values telling yesno

gen reading=.
replace reading=0 if a2p2==2
replace reading=1 if a2p2==1

label var reading "read books"
label values reading yesno


gen reading_days=.
replace reading_days=0 if a2p2==2
replace reading_days=a2p3 if a2p3!=.

label var reading_days "days read books"


gen min_reading=a2p4a/60 if a2p4a!=.

gen hours_reading=.
replace hours_reading=0 if reading==0
replace hours_reading=a2p4 if a2p4!=.&a2p4a==.
replace hours_reading=a2p4+min_reading if a2p4!=.&min_reading!=.

label var hours_reading "hours read books"


*Stories
gen stories=0 if (reading==0 & telling==0)
replace stories=1 if (reading==1 | telling==1) 

lab var stories "Child is told or read stories"


*** Stimulation programs

gen painin=.
replace painin=0 if (a2p5==1&a2p6==1)
replace painin=1 if (a2p5!=1&a2p5!=.) | (a2p5==1&a2p6!=1&a2p6!=.)

label var painin "painin"

gen preschool=.
replace preschool=0 if a2p8==1
replace preschool=1 if a2p8==2 | a2p8==3 | a2p8==4

label var preschool "preschool"




********************************************
**#Parenting********************************
********************************************
local misbehave a17cp1a a17cp1b a17cp1c a17cp1d a17cp1e a17cp1f a17cp1g a17cp1h a17cp1i a17cp1j a17cp1k a17cp1l

/*
Ignorarlo
Pegarle 
Amenaza con pegarle
Regañarlo 
Burlarse de él
Conversar para explicarle que no está bien lo que hace
Ofrecerle un premio si se porta bien
Pastorearlo 
Hago lo que el niño dice para que no llore.
Lo pone a estudiar
No dan o permiten lo que quiere
Otro. ¿Cuál?
*/


/*OTHERS
New options: 
-castigar (punish)
-distract/pamper

*/

foreach x of local misbehave {

gen mb_`x'=.
replace mb_`x'=0 if `x'==.
replace mb_`x'=1 if `x'==1
}

gen mb_a17cp1m=.
replace mb_a17cp1m=0 if a17cp1m==""
replace mb_a17cp1m=1 if a17cp1m!=""


local misbehave2 mb_a17cp1a mb_a17cp1b mb_a17cp1c mb_a17cp1d mb_a17cp1e mb_a17cp1f mb_a17cp1g mb_a17cp1h mb_a17cp1i mb_a17cp1j mb_a17cp1k  mb_a17cp1l mb_a17cp1m 

foreach v of local misbehave2 {
replace `v'=. if (a17cp1a==. & a17cp1b==. & a17cp1c==. & a17cp1d==. & a17cp1e==. & a17cp1f==. & a17cp1g==. & a17cp1h==. & a17cp1i==. & a17cp1j==. & a17cp1k==. & a17cp1l==. & a17cp1m=="")
}

label var mb_a17cp1a "misbehave: ignore"
label var mb_a17cp1b "misbehave: spank"
label var mb_a17cp1c "misbehave: threaten"
label var mb_a17cp1d "misbehave: nag"
label var mb_a17cp1e "misbehave: make fun"
label var mb_a17cp1f "misbehave: explain"
label var mb_a17cp1g "misbehave: offer a reward"
label var mb_a17cp1h "misbehave: shepherd"
label var mb_a17cp1i "misbehave: follow"
label var mb_a17cp1j "misbehave: put to study"
label var mb_a17cp1k "misbehave: not follow"
*label var mb_a17cp1l "Misbehave: other"

tostring a17cp1m_1, replace

egen a17cp1m_clean= sieve(a17cp1m), keep(a n)

*OTHERS
*ignore
replace mb_a17cp1a=1 if a17cp1m=="DEJARLO LLORAR"| a17cp1m=="LO DEJO LLORAR"| a17cp1m=="SE PREOCUPA"

*spank
replace mb_a17cp1b=1 if a17cp1m=="LO CASTIGO PEGANDOLE"| a17cp1m=="ICARLO" | a17cp1m=="CASTIGARLA LE DOY CON UNATAJA"| a17cp1m=="CASTIGARLO CON UNA FAJA"



*threaten 

replace mb_a17cp1c=1 if a17cp1m=="A VECES LO METE EN MIEDO"|	a17cp1m=="AMENAZA CON CASTIGARLA"|	a17cp1m=="AMENAZA CON CASTIGARLA OINYECTARLA"|	a17cp1m=="AMENAZARLA CON DECIRLE ALPAPA"|	a17cp1m=="AMENAZAS CON CONTARLE A LA MAMA"|	a17cp1m=="JUGAR CON ELLA / AMENAZARLA CON DECIRLE A LA MAMA PARA QUE LE PEGUEN"|	a17cp1m=="LA ASUSTA DICIENDO QUE SE"|	a17cp1m=="LA METE EN MIEDO LE DICEQUE EL MONO SE LA COME"|	a17cp1m=="LA METEN EN MIEDO"|	a17cp1m=="LE DICE QUE LA VAN A VACUNAR"|	a17cp1m=="LE DICE QUE LE VA A DAR PAU PAU"|	a17cp1m=="LE DICE QUE SE LO VAN A LLEVAR"|	a17cp1m=="LE DICE QUE SE VA A MORIRY QUE SE VA A QUEDAR SOLA"|	a17cp1m=="LE DICE QUE SE VA Y LO DEJA SOLO"|	a17cp1m=="LE DICE QUE SI SIGUE DE MALCRIADO SE VUELVE VIEJITO"|	a17cp1m=="LE DICE QUE SI SIGUE DE MALCRIADO SE VA A PONER FEA SI QUIERE VERSE BONITA TIENE QUE HACER CASO"|	a17cp1m=="LE DICE QUE YA NO LA QUIERE"|	a17cp1m=="LE DICE QUE YA SE VA QUEVA A DEJAR SOLO Y SE ESCONDE"|	a17cp1m=="LE DICEN QUE EL GATO SE LO LLEVA SI SIGUE LLORANDO"|	a17cp1m=="LE HACE MIEDO QUE ALGUIENSE LO VA A LLEVAR"|	a17cp1m=="LE HACE MIEDO(QUE SE LA VA A LLEVAR EL LOCO)"|	a17cp1m=="LO ASUSTA CON QUE SE LO VA A LLEVAR UN ANIMAL"|	a17cp1m=="LO METE EN MIEDO"|	a17cp1m=="LO METE EN MIEDO DICIENDOLE QUE LE ECHARA AL GATO"|	a17cp1m=="METERLA EN MIEDO"|	a17cp1m=="METERLA EN MIEDO (HAY VIENEN LOS ANIMALES)"|	a17cp1m=="METERLA EN MIEDO (TE LLEVA EL MONO)"|	a17cp1m=="METERLA EN MIEDO QUE LE SALE UN ANIMAL Y SE LA LLEVA"|	a17cp1m=="METERLO EN MIEDO"|	a17cp1m=="METERLO EN MIEDO DICIENDOLE QUE SE LO VA A LLEVAR EL CONGO"|	a17cp1m=="QUE SE LO VA A MANDAR DONDE LA MAMA"

replace mb_a17cp1c=1 if a17cp1m_clean=="AMENAZASDEQUEELTIOLEREGAARA"

		*Meterle miedo Amenazar con castigo Amenazar con decirle a papa/mama que se Amenazar con abandonarle o morirse Otras amenazas Decirle que ya no le quiere, ponerse a
replace mb_a17cp1c=1 if a17cp1m_1==3
replace mb_a17cp1c=1 if a17cp1m_1==6
replace mb_a17cp1c=1 if a17cp1m_1==7
replace mb_a17cp1c=1 if a17cp1m_1==8
replace mb_a17cp1c=1 if a17cp1m_1==10
replace mb_a17cp1c=1 if a17cp1m_1==24

		*Meterle miedo Amenazar con decirle a papa/mama que se
replace mb_a17cp1c=1 if a17cp1m_2==3
replace mb_a17cp1c=1 if a17cp1m_2==7


*nag
replace mb_a17cp1d=1 if a17cp1m=="LE HABLA FUERTE VOZ ALTA"| a17cp1m=="PONERLA A HACER TAREAS"

*explain 

replace mb_a17cp1f=1 if a17cp1m=="ACONSEJA"|	a17cp1m=="ACONSEJA P Q DEJE DE ESTAR DE MALCREADO"|	a17cp1m=="ACONSEJA PARA Q DE ESTARDE MALCREADO"|	a17cp1m=="ACONSEJA PARA QUE NO ANDEDE MALCREADO Y LE DA DINERO" |	a17cp1m=="ACONSEJA Q NO ANDE DE MALCREADO Q ES MALO"|	a17cp1m=="ACONSEJARLA"|	a17cp1m=="ACONSEJARLA PARA Q NO ESTEDENECIA"|	a17cp1m=="ACONSEJARLA Q NO HAGA COSAS MALAS"|	a17cp1m=="ACONSEJARLO"|	a17cp1m=="ACONSEJARLO PARA Q NO ESTE DE MALCREADO"|	a17cp1m=="ACONSEJARLO PARA Q NO SEAMALCRIADO"|	a17cp1m=="LE DICE QUE TIENE SER EDUCADO PORQUE ESTA EN PREESCOLAR"|	a17cp1m=="LEERLE LA BIBLIA TEXTOS DONDE HABLA DE LOS DESOBEDIENTES\n"|	a17cp1m=="LO CORRIGE CONVERSANDO QUE HAGA CASO Q NO SEA NECIO"

replace mb_a17cp1f=1 if a17cp1m_clean=="ACONSEJALEDICEQSEAOBEDIENTECONSUPAP" | a17cp1m_clean=="ACONSEJARLOQNOANDEDEDEMALCREADOYENGAARLOCONALGOPARAQNOANDEDENECIO" 

		*Aconsejarle que no se porta mal Hablar de la biblia
replace mb_a17cp1f=1 if a17cp1m_1==2
replace mb_a17cp1f=1 if a17cp1m_1==34

* put to study
replace mb_a17cp1j=1 if a17cp1m=="PONERLA A HACER TAREAS"

*shepherd

replace mb_a17cp1h=1 if a17cp1m=="ACOSTARLA"|	a17cp1m=="ACOSTARLE EN EL RING"|	a17cp1m=="ACOSTARLO Y DORMIRLO"|	a17cp1m=="CHINEARLO Y DORMIRLO"|	a17cp1m=="DARLE REMEDIO PORQUE ESTAENFERMO"|	a17cp1m=="DOMIRLO"|	a17cp1m=="DORMIRLA"|	a17cp1m=="LA CHINEA LA DUERME"|	a17cp1m=="LA DUERME"|	a17cp1m=="LA DUERMO"|	a17cp1m=="LA PONE A DORMIR"|		a17cp1m=="LO DUERME"|	a17cp1m=="LO DUERMO"|	a17cp1m=="LO PONE A DORMIR"|	a17cp1m=="PASEARLA DORMIRLA"|	a17cp1m=="SE ACUESTA A DORMIR"|	a17cp1m=="TRATA DE DORMIRLA"

replace mb_a17cp1h=1 if a17cp1m_clean=="LOSBAAYLOSMANDAADORMIR" |	a17cp1m_clean=="LABAAYLAPONEADORMIR" | a17cp1m_clean=="LOBAOYLODUERMO"

		*Darle remedio medico, Acostarle 
replace mb_a17cp1h=1 if a17cp1m_1==35
replace mb_a17cp1h=1 if a17cp1m_1==5

*punish 
gen mb_a17cp1_n=0 if mb_a17cp1l!=.
replace mb_a17cp1_n=1 if a17cp1m=="ARRODILLARLO EN EL SOL"|	a17cp1m=="CASTIGA"|	a17cp1m=="CASTIGARLA"|	a17cp1m=="CASTIGARLA CON SENTARLA YNO DEJARLA JUGAR"|	a17cp1m=="CASTIGARLA LA MANDA ACOSTARSE"|	a17cp1m=="CASTIGARLO"|	a17cp1m=="CASTIGARLO CON NO DEJARLOVER TV"|	a17cp1m=="CASTIGARLO INCADO"|	a17cp1m=="CASTIGARLO NO DEJANDOLO VER TV"|	a17cp1m=="CASTIGARLO NO LO DEJA VERTV"|	a17cp1m=="CASTIGARLOS"|	a17cp1m=="ENCERRARLO EN EL CUARTO"|	a17cp1m=="ENCERRARLO EN LA CASA SOLO"|	a17cp1m=="ENERRARLO EN EL CUARTO"|	a17cp1m=="LA ARRODILLA"|	a17cp1m=="LA CASTIGA LA SIENTA EN UNA SILLA Y LE DICE Q NO SE MUEVA"|	a17cp1m=="LA MANDA A DORMIR"|	a17cp1m=="LA PONE A HACER TAREAS DOMESTICAS"|	a17cp1m=="LA PONE ARRODILLADA"|	a17cp1m=="LA PONE HACER OFICIOS"|	a17cp1m=="LO HINCA"|	a17cp1m=="LO MANDA A ACOSTARSE"|	a17cp1m=="LO MANDA A DORMIR"|	a17cp1m=="LO MANDA A HACER MANDADOS"|	a17cp1m=="LO MANDA A RODILLARSE"|	a17cp1m=="LO MANDA A TRAER AGUA"|	a17cp1m=="LO MANDA HACER OFICIO"|	a17cp1m=="LO PONE A BARRER EL PATIO"|	a17cp1m=="LO PONE A REZAR"|	a17cp1m=="LO PONE INCADO 10 MINUTOS"|	a17cp1m=="LO PONE SENTADO Y LO DEJOPOR 15 MINUTOS"|	a17cp1m=="LO SIENTA POR 30 MINUTOS"|	a17cp1m=="LO SIENTO (SENTARSE)"|	a17cp1m=="LOS PONE DE RODILLAS"|	a17cp1m=="MANDA ACOSTARCE"|	a17cp1m=="MANDAR A HACER COMPRAS"|	a17cp1m=="MANDARLA A JALAR AGUA"|	a17cp1m=="MANDARLA A JALAR AGUA Y ACHINEAR AL HERMANO MENOR"|	a17cp1m=="MANDARLA A SENTARSE"|	a17cp1m=="MANDARLA A UN RINCON DE LA CASA"|	a17cp1m=="MANDARLO A ACOSTAR"|	a17cp1m=="MANDARLO A DORMIR"|	a17cp1m=="MANDARLO A SENTARSE"|	a17cp1m=="METERLO AL RING"|	a17cp1m=="NO LA DEJA VER TELEVISION"|	a17cp1m=="NO LA DEJA VER TV E IR AJUGAR"|	a17cp1m=="NO LE DA EL PECHO"|	a17cp1m=="NO LE DA PERMISO DE IR AJUGAR A OTRA CASA"|	a17cp1m=="NO LO DEJA IR A JUGAR"|	a17cp1m=="NO LO DEJA SALIR A JUGAR"|	a17cp1m=="NO LO DEJO IR A VER TELEVISION"|	a17cp1m=="NOLE DAN LO QUE QUIERE COMIDA"|	a17cp1m=="PONE A SACAR AGUA"|	a17cp1m=="PONERLA HACER MANDADOS"|	a17cp1m=="PONERLA HACER OFICIO"|	a17cp1m=="QUITARLE LA TELEVISION"

*check
replace mb_a17cp1_n=1 if 	a17cp1m=="AMARRE DE LA SILLA PARA QUE SE CALME DE AGNA DE ESTA DE NECIA"


		*No dejarle ir a jugar Dejarlo sentado, amarrado a una silla Ponerle de rodilas Castigarle Ponerle a trabajar No dejarle ver TV Encerrarle 
replace mb_a17cp1_n=1 if a17cp1m_1==4
replace mb_a17cp1_n=1 if a17cp1m_1==11 /*check*/
replace mb_a17cp1_n=1 if a17cp1m_1==13
replace mb_a17cp1_n=1 if a17cp1m_1==16
replace mb_a17cp1_n=1 if a17cp1m_1==17
replace mb_a17cp1_n=1 if a17cp1m_1==18
replace mb_a17cp1_n=1 if a17cp1m_1==20

		*No dejarle ir a jugar
replace mb_a17cp1_n=1 if a17cp1m_2==4

label var mb_a17cp1_n "misbehave: punish"


*distract/pamper

gen mb_a17cp1_o=0 if mb_a17cp1l!=.
replace mb_a17cp1_o=1 if a17cp1m=="ABRAZARLA"|	a17cp1m=="ABRAZARLO"|	a17cp1m=="ABRAZARLO Y BESARLO/PASERARLO"|	a17cp1m=="ABRAZARLO Y DECIRLE TE QUIERO"|	a17cp1m=="ACARICIANDOLA Y DECIRLE PALABRAS BONITAS"|	a17cp1m=="ACARICIAR"|	a17cp1m=="ACARICIARLA"|	a17cp1m=="ACARICIARLA / PASEARLA"|	a17cp1m=="ACARICIARLA BESARLA"|	a17cp1m=="ACARICIARLO"|	a17cp1m=="ACARICIARLO PARA Q SE CALME"|	a17cp1m=="AGARRARLO DARLE ALGO LO CARGO Y LO CHINCHINEO"|	a17cp1m=="AGARRARLO PARA PASEARLO"|	a17cp1m=="BUSCARLE JUGUETE Y ACARICIARLO PARA Q NO ESTE DE MALCREADO O LE DAN UN BOMBON\n"|	a17cp1m=="BUSCARLE JUGUETES"|	a17cp1m=="CANTAN JUNTOS"|	a17cp1m=="CANTARLE"|	a17cp1m=="CARGARLO Y PASEARLO"|	a17cp1m=="CARICIAS"|	a17cp1m=="CHINEA"|	a17cp1m=="CHINEA PARA QUE NO LLORE"|	a17cp1m=="CHINEA Y PASEA"|	a17cp1m=="CHINEADA"|	a17cp1m=="CHINEANDOLA CANTARLE PASEARLA"|	a17cp1m=="CHINEARLA"|	a17cp1m=="CHINEARLA ACARICIARLA"|	a17cp1m=="CHINEARLA CANTARLE ACARICIARLE"|	a17cp1m=="CHINEARLA Y BESARLA"|	a17cp1m=="CHINEARLA Y PASEARLA"|	a17cp1m=="CHINEARLO"|	a17cp1m=="CHINEARLO / PONERLE SUS JUGUETES"|	a17cp1m=="CHINEARLO DARLE JUGUETES"|	a17cp1m=="CHINEARLO O PASEARLO"|	a17cp1m=="CHINEARLO PASEARLO CANTAR"|	a17cp1m=="CHINEARLO PONERLE JUGUETES PARA QUE JUEGUE"|	a17cp1m=="CHINEARLO Y ACARICIARLO"|	a17cp1m=="CHINEARLO Y DARLE JUGUETE"|	a17cp1m=="CHINEARLO Y DARLE JUGUETES"|	a17cp1m=="CHINEARLO Y DORMIRLO"|	a17cp1m=="CHINEARLO Y PASEARLO"|	a17cp1m=="CHINEARLO Y PASEARLO LE DA JUGUETES"|	a17cp1m=="CHINEARLO Y PASEARLO PARAQ SE CALME"|	a17cp1m=="CHINEARLO,ACARICIARLA"|	a17cp1m=="CHINERALO"|	a17cp1m=="CONTARLE CUENTOS"|	a17cp1m=="CONTENTARLA PASEANDOLA PARA Q NO LLORE"|	a17cp1m=="CONTENTARLA Y ABRAZARLA"|	a17cp1m=="CONTENTARLO CHINEANDOLO"|	a17cp1m=="CONTROLANDO PASEANDOLO"|	a17cp1m=="CONTUMEREA BUSCA Q DARLEPARA Q DEJE DE ESTAR DE MALCRIADO UN BOMBON GOLOSINA"|	a17cp1m=="CONTUMEREARLA ABRAZALA PARA QUEU DEJE DE LLORAR Y SE CALME"|	a17cp1m=="CONTUMEREO PASEANDOLO"|	a17cp1m=="CONTUMERIANDOLA CHINEANDOLA"|	a17cp1m=="CONTUMERIARLA"|	a17cp1m=="CONTUMERIARLA (PASEARLA)DARLE ALGO P/Q SE CALME"|	a17cp1m=="CONTUMERIARLA CHINEARLA"|	a17cp1m=="CONTUMERIARLA DANDOLE ALGP AGARRARLA"

replace mb_a17cp1_o=1 if a17cp1m_clean=="BAARLO" | a17cp1m_clean=="CHINEARLAYBAARLA"| a17cp1m_clean=="DARLECARIO" | a17cp1m_clean=="DARLECARIOPASEARLA"| 	a17cp1m_clean=="HABLARLECONCARIOACARICIARLA"|	a17cp1m_clean=="HACERLECARIOJUEGOCONELLA"| a17cp1m_clean=="CONTUMERIARLOPASEANDOLOOSIESPORCALORLOBAA" | a17cp1m_clean=="CONTUMEREARLOSACARLAAPASEARYLAGARGAPARAQUESECALMECOMOESLAPEQUEAHAYQUEMIMARLA"


replace mb_a17cp1_o=1 if a17cp1m=="CONTUMERIARLA LE DICE Q SI ANDA DE MALCREADA NO LA VA A QUERER"|	a17cp1m=="CONTUMERIARLA PARA Q NO ESTE DE MALCRIADA DARLE COSAS Q QUIERA"|	a17cp1m=="CONTUMERIARLA SACARLA A PASEAR"|	a17cp1m=="CONTUMERIARLO CARGANDO YLO ABRAZO"| a17cp1m=="CONTUMERIARLO PASEARLO"|	a17cp1m=="DAR JUGUETE PARA QUE SE CONTETE Y PASEARLA"|	a17cp1m=="DAR JUGUETES"|	a17cp1m=="DAR JUGUETES, PASEO"|	a17cp1m=="DARLE ALGUN JUGUETE"|	a17cp1m=="DARLE CARICIAS"|	a17cp1m=="DARLE DINERO"|	a17cp1m=="DARLE DULCE O BONBONES, CAJETAS"|	a17cp1m=="DARLE JUGUETE"|	a17cp1m=="DARLE JUGUETE PONERME A JUGAR CON ELLA"|	a17cp1m=="DARLE JUGUETES"|	a17cp1m=="DARLE JUGUETES CHINEARLA"|	a17cp1m=="DARLE JUGUETES PASEARLA"|	a17cp1m=="DARLE JUGUETES Y PONERLAA JUGAR"|	a17cp1m=="DARLE JUGUTE PARA QUE SEENTRETENGA"|	a17cp1m=="DARLE UN JUGUETE"|	a17cp1m=="DARLE UN JUGUETE PARA CONTROLARLO"|	a17cp1m=="DARLE UN PASEO"|	a17cp1m=="DARLES JUGUETES"|	a17cp1m=="JUEGA"

replace mb_a17cp1_o=1 if a17cp1m=="JUEGA CON EL"|	a17cp1m=="JUEGA CON ELLA"|	a17cp1m=="JUEGA CON ELLA LA CHINEA"|a17cp1m=="JUEGO CON ELLA"|	a17cp1m=="JUGAR CON EL"|	a17cp1m=="JUGAR CON EL ACARICIARLO"|	a17cp1m=="JUGAR CON EL Y PASEARLO DONDE EL VECINO"|	a17cp1m=="JUGAR CON ELLA"|	a17cp1m=="JUGAR CON ELLA / AMENAZARLA CON DECIRLE A LA MAMA PARA QUE LE PEGUEN"|	a17cp1m=="JUGAR CON ELLA CANTARLE"|	a17cp1m=="JUGAR CON ELLA CONTARLE OLA PONE EN EL SUELO PARA QUE GATEA"|	a17cp1m=="JUGUETE"|	a17cp1m=="LA ACARICIABA"|	a17cp1m=="LA AGARRO Y LA CARGO LA CONTUMEREO"|	a17cp1m=="LA CARGA Y LA SACA A PASEAR"|	a17cp1m=="LA CHINCHINEA LO SACO LAA FUERA A PASEAR PARA QUE SE COLME Y NO SIGA LLORANDO"|	a17cp1m=="LA CHINEA"|	a17cp1m=="LA CHINEA LA DUERME"|	a17cp1m=="LA CHINEA LA PASEA"|	a17cp1m=="LA CHINEA PARA PASEARLA OJUGAR CON ELLA"|	a17cp1m=="LA CHINEA SE PONE A JUGARCON EL"|	a17cp1m=="LA CHINEA Y ACARICIA"|	a17cp1m=="LA CHINEA Y PASEA"|	a17cp1m=="LA CHINEO O LA SACO A PASEARLA DONDE EL VECINO"|	a17cp1m=="LA CONTENTA CON JUGUETES"|	a17cp1m=="LA CONTROLA DISTRAYENDOLACON ALGO"|	a17cp1m=="LA CONTUMEREA SACANDOLA AFUERA DE LA CASA A PASEARLA"|	a17cp1m=="LA LLEVA A PASEAR"|	a17cp1m=="LA LLEVA A PASEAR AL VECINO"|	a17cp1m=="LA MANDA A JUGAR"|	a17cp1m=="LA PASEA"|	a17cp1m=="LA PASEA CHINEADA"|	a17cp1m=="LA PASEA POR EL PATIO"|	a17cp1m=="LA PASEAN"|	a17cp1m=="LA PASEO"|	a17cp1m=="LA PELEO"|	a17cp1m=="LA PONE A JUGAR"|	a17cp1m=="LA PONE A VER TELEVISION"|	a17cp1m=="LA SACA A PASEAR"|	a17cp1m=="LA SACA A PASEAR O LE DAJUGUETES"|	a17cp1m=="LA SACA A PASEAR PARA Q DEJE DE LLORAR"

replace mb_a17cp1_o=1 if a17cp1m_clean=="JUEGACONLANIAPARAQUESECONTENTE"

replace mb_a17cp1_o=1 if a17cp1m_clean=="JUEGACONELNIO" | a17cp1m_clean=="JUEGACONLANIA" | a17cp1m_clean=="LAABRAZALEDACARIO" | a17cp1m_clean=="LABAA"|	a17cp1m_clean=="LABAAYLAPONEADORMIR" |	a17cp1m_clean=="LAMANDABAAR"

replace mb_a17cp1_o=1 if a17cp1m=="LA SACA A PASEARLA"|	a17cp1m=="LA SACA PASEAR"|	a17cp1m=="LE CANTA"|	a17cp1m=="LE CUENTA CUENTOS"|	a17cp1m=="LE DA CARICIAS PARA QUE NO LLORE"| a17cp1m=="LE DA JUEGUETE"|	a17cp1m=="LE DA JUGUETE"|	a17cp1m=="LE DA JUGUETE LO CHINEA"|	a17cp1m=="LE DA JUGUETE PARA QUE JUEGUE"|	a17cp1m=="LE DA JUGUETE PARA QUE SECALME"|	a17cp1m=="LE DA JUGUETES"|	a17cp1m=="LE DA MIMOS"|	a17cp1m=="LE DA UN JUGUETE"|	a17cp1m=="LE DA UN JUGUETE Y LO SACA A PASEAR PARA QUE SE CALME"|	a17cp1m=="LE DAN UN JUGUETE Q LE GUSTE PARA Q SE CALME"|	a17cp1m=="LE DOY JUGUETES"|	a17cp1m=="LE DOY UN JUGUETE ASI LACONSUELO PARA Q NO LLORE"|	a17cp1m=="LE HABLA PARA QUE SE CONTENTE"|	a17cp1m=="LE HECHA AGUA"|	a17cp1m=="LE PONE LOS JUGUETES"|	a17cp1m=="LEDA JUGUETE"|	a17cp1m=="LLEVA A PASEAR"|	a17cp1m=="LLEVARLO A JUGAR"|	a17cp1m=="LO ACUESTA EN LA HAMACA LO PASEA"|	a17cp1m=="LO AGARRA Y LO SACA A PASEAR PARA Q SE CALME"| a17cp1m=="LO CARGO Y LE DIGO COSASDULCES P Q SE CONTROLE"|	a17cp1m=="LO CHINEA"|	a17cp1m=="LO CHINEA LO PASEA"|	a17cp1m=="LO CHINEA LO PATEA"|	a17cp1m=="LO CHINEA Y JUEGA CON EL"|	a17cp1m=="LO CHINEA Y LO ACUESTA ALA HAMACA"|	a17cp1m=="LO CHINEA Y LO SACA A PASEAR"|	a17cp1m=="LO CONSUELO PASEANDOLO"|	a17cp1m=="LO CONTENTA JUGANDO CON EL LO PASEA O LE DA UN JUGUETE"|	a17cp1m=="LO LLEVA A PASEAR"|	a17cp1m=="LO MANDA A JUGAR"|	a17cp1m=="LO MANDA JUGAR"|	a17cp1m=="LO MIMA"|	a17cp1m=="LO PASEA"|	a17cp1m=="LO PASEA CHINIADA"|	a17cp1m=="LO PASEA LE DA JUGUETES"|	a17cp1m=="LO PASEA LO CHINEA"|	a17cp1m=="LO PASEA O DA JUGUETES"|	a17cp1m=="LO PASEA,LE CANTA"|	a17cp1m=="LO PASEA,LO PONE A JUGAR"|	a17cp1m=="LO PASEO SACO DE LA CASA"|	a17cp1m=="LO PONE A JUGAR"|	a17cp1m=="LO PONE A JUGAR CON LA HERMANA"|	a17cp1m=="LO PONE EN EL SUELO PARAQUE JUEGUE"|	a17cp1m=="LO PONGO EN LA SILLA Y DOY UN JUGUETE PARA QUE SE CALME"|	a17cp1m=="LO SACA A CAMINAR"|	a17cp1m=="LO SACA A FUERA AL PATIOPARA Q DEJE DE LLORAR"|	a17cp1m=="LO SACA A LA CALLE A VER"|	a17cp1m=="LO SACA A PASEAR CONTUMERIARLO"|	a17cp1m=="LO SACA A PASEAR LE DA JUGUETES"

replace mb_a17cp1_o=1 if a17cp1m_clean=="LEDACARIO"|  a17cp1m_clean=="LOBAAPARAQUESELEQUITELAARRECHURA" | a17cp1m_clean=="LOBAOYLODUERMO" |  a17cp1m_clean=="LOMANDAAJUGARALVECINOOLOBAAYLOMANDAADORMIR" | a17cp1m_clean=="LOLLEVAAJUGARYLEENSEAALASPARAQSECALME\n" | a17cp1m_clean=="LOBAAPARAQSELEBAJELACOLERA"| a17cp1m_clean=="LECANTALOSPOLLITOSYJUEGACONELNIO"

replace mb_a17cp1_o=1 if a17cp1m=="LO SACA A PASEAR LO PONEA JUGAR"|	a17cp1m=="MANDAR A PASEAR DONDE LAABUELA"|	a17cp1m=="MANDARLA A JUGAR"|	a17cp1m=="MANDARLA A JUGAR AL PATIO"|	a17cp1m=="MANDARLA A JUGAR DENTRO DE LA CASA"|	a17cp1m=="MANDARLA A PASEAR PARA QSE CALME"|	a17cp1m=="MANDARLE JUGUETE"|	a17cp1m=="MANDARLO A JUGAR FUERA DELA CASA"|	a17cp1m=="MECERLO"|	a17cp1m=="MECERLO OB 12 DICE QUE ME"|	a17cp1m=="MESA AMACA"|	a17cp1m=="MIMARLA CON JUGUETES O CHINEARLA"| a17cp1m=="PARA BAJARLE EL CORAJE LEHECHO AGUA Y LE PEGO ESO SA MUCHO RESULTADO PEGARLE"|	a17cp1m=="PASEA"|	a17cp1m=="PASEA LE DA JUGUETES"|	a17cp1m=="PASEANDOLO"|	a17cp1m=="PASEAR"|	a17cp1m=="PASEARL DARLE JUGUETE"|	a17cp1m=="PASEARLA"|	a17cp1m=="PASEARLA CHINEARLA"|	a17cp1m=="PASEARLA DARLE JUGUETE"|	a17cp1m=="PASEARLA DARLE JUGUETES"|	a17cp1m=="PASEARLA DARLE UN JUGUETE"|	a17cp1m=="PASEARLA DORMIRLA"|	a17cp1m=="PASEARLA PARA Q SE CALME"| a17cp1m=="PASEARLA Y CONTARLE"|	a17cp1m=="PASEARLA Y DARLE JUGUETE"|	a17cp1m=="PASEARLA Y DARLE UN JUGUETE"|	a17cp1m=="PASEARLA Y JUGAR"|	a17cp1m=="PASEARLA, LE CANTA"|	a17cp1m=="PASEARLO"|	a17cp1m=="PASEARLO ACARICIARLO"|	a17cp1m=="PASEARLO BESARLO CHINEARLO"|	a17cp1m=="PASEARLO CARGARLO CHINEARLO"|	a17cp1m=="PASEARLO DARLE JUGUETE"|	a17cp1m=="PASEARLO DARLE JUGUETES"|	a17cp1m=="PASEARLO JUGAR CON EL"|	a17cp1m=="PASEARLO Y DARLE JUGUETE"|	a17cp1m=="PASEO/DARLES BESOS Y ABRAZOS"|	a17cp1m=="PONE A SUS OTROS HIJOS QUE LA PASEEN O CHINEARLO\n"|	a17cp1m=="PONERSE A JUGAR CON EL"|	a17cp1m=="QUE LAS HERMANS LO PASEENLO METE EN MIEDFO HAY VIEN EL CHANCHO"|	a17cp1m=="SACA A PASEAR"|	a17cp1m=="SACA A PASEAR O JUGAR"|	a17cp1m=="SACA A PASEARLA O DARLE JUGUETES"|	a17cp1m=="SACAR A PASEAR"|	a17cp1m=="SACARLA A PASEAR"|	a17cp1m=="SACARLA A PASEAR PARA Q SE CALME"|	a17cp1m=="SACARLA A PASEARLA PARA QDEJE DE LLORAR Y SE CALME"|	a17cp1m=="SACARLO A PASEAR"|	a17cp1m=="SACARLO A PASEAR A LA VENTA LE DAN ALGO PARA Q DEJE LLORAR Y SE CALME"|	a17cp1m=="SACARLO AL PATIO A JUGAR"|	a17cp1m=="SE LA LLEVA A PASEAR"|	a17cp1m=="SE PONE A JUGAR CON EL"|	a17cp1m=="SE PONE A JUGAR CON ELLA"|	a17cp1m=="SENTARLA" |a17cp1m=="ACONSEJA PARA QUE NO ANDEDE MALCREADO Y LE DA DINERO"


replace mb_a17cp1_o=1 if a17cp1m_clean=="TRATARLOCONCARIO(HABLARLESUAVE)" | a17cp1m_clean=="OUNREGAO)" | a17cp1m_clean=="PASEARLAYBAARLOS" | a17cp1m_clean=="PASEARLOENSEARLELASGALLINASDARLEJUGUETES"

		*Darle cari�o (abrazar, acariciar, canta Ba�arle Darle juguetes, golosina, dinero etc Pasearle Jugar con el La manda a jugar o fuera de la casa Echarle agua
replace mb_a17cp1_o=1 if a17cp1m_1==1
replace mb_a17cp1_o=1 if a17cp1m_1==14
replace mb_a17cp1_o=1 if a17cp1m_1==15
replace mb_a17cp1_o=1 if a17cp1m_1==19
replace mb_a17cp1_o=1 if a17cp1m_1==21
replace mb_a17cp1_o=1 if a17cp1m_1==23
replace mb_a17cp1_o=1 if a17cp1m_1==25

		*Darle cari�o (abrazar, acariciar, canta Acostarle Ba�arle Darle juguetes, golosina, dinero etc Pasearle Jugar con el Echarle agua
replace mb_a17cp1_o=1 if a17cp1m_2==1
replace mb_a17cp1_o=1 if a17cp1m_2==5
replace mb_a17cp1_o=1 if a17cp1m_2==14
replace mb_a17cp1_o=1 if a17cp1m_2==15
replace mb_a17cp1_o=1 if a17cp1m_2==19
replace mb_a17cp1_o=1 if a17cp1m_2==21
replace mb_a17cp1_o=1 if a17cp1m_2==25

		*Ba�arle Darle juguetes, golosina, dinero etc Jugar con el
replace mb_a17cp1_o=1 if a17cp1m_3==14
replace mb_a17cp1_o=1 if a17cp1m_3==15
replace mb_a17cp1_o=1 if a17cp1m_3==21

label var mb_a17cp1_o "misbehave: distract/pamper"


*NEGATIVE: mb_a17cp1b "misbehave: spank", mb_a17cp1c "misbehave: threaten", mb_a17cp1d "misbehave: nag", mb_a17cp1e "misbehave: make fun", mb_a17cp1_n "misbehave: punish"

gen misbehave_violence= mb_a17cp1b + mb_a17cp1c + mb_a17cp1d + mb_a17cp1e + mb_a17cp1_n

label var misbehave_violence "misbehave: violence"

*NON-VIOLENT: mb_a17cp1a "misbehave: ignore", mb_a17cp1f "misbehave: explain", mb_a17cp1g "misbehave: offer a reward", mb_a17cp1h "misbehave: shepherd", mb_a17cp1i "misbehave: follow", mb_a17cp1j "misbehave: put to study", mb_a17cp1k "misbehave: not follow", mb_a17cp1_o "misbehave: distract/pamper"

gen misbehave_nonviolence= mb_a17cp1a + mb_a17cp1f + mb_a17cp1g + mb_a17cp1h + mb_a17cp1i +  mb_a17cp1j + mb_a17cp1k + mb_a17cp1_o 

label var misbehave_nonviolence "misbehave: non-violence"


*****Additional discipline

/*
Ignorarlo          1 		positive
Pegarle	2			 		negative
Amenazar con pegarle	3 	negative
Rega�arlo	4				negative
Explicarle que no esta bien lo que hace	6	positive
Ofrecerle un premio si se porta bien	7	positive
Pastorearlo	8								positive
Hago lo que el ni�o dice para que no ll	9	positive
Lo pone a estudiar	10						positive
No le dan o permiten lo que quiere	11		positive
Otro	12
*/


egen a17cp2a_clean=sieve(a17cp2a), keep(a n)


*distract
gen violence_alt_other1=0 if a17cp2!=.
replace violence_alt_other1=1 if a17cp2a=="ABRAZARLO Y ACARICIARLO"|	a17cp2a=="ACARICIANDOLA Y DECIRLE PALABRAS BONITAS"|	a17cp2a=="ACARICIARLA"|	a17cp2a=="ACARICIARLA Y MIMARLA"|	a17cp2a=="ACARICIARLO"|	a17cp2a=="ACARICIARLO PARA Q SE CALME"|	a17cp2a=="CANTARLE"|	a17cp2a=="CARGARLO Y PASEARLO"|	a17cp2a=="CARICIAS"|	a17cp2a=="CHINEA"|	a17cp2a=="CHINEADA"|	a17cp2a=="CHINEANDOLA CANTARLE PASEARLA"|	a17cp2a=="CHINEARLA"|	a17cp2a=="CHINEARLA PARA PASEARLA"|	a17cp2a=="CHINEARLA Y BESARLA"|	a17cp2a=="CHINEARLO"|	a17cp2a=="CHINEARLO PASEARLO CANTAR"|	a17cp2a=="CHINEARLO Y BESARLO"|	a17cp2a=="CHINEARLO Y DARLE JUGUETE"|	a17cp2a=="CHINEARLO Y PASEARLO"|	a17cp2a=="CHINEARLO,ACARICIARLA"|	a17cp2a=="CHINERALA"|	a17cp2a=="CONTENTARLA PASEANDOLA PARA Q NO LLORE"|	a17cp2a=="CONTUMEREA BUSCA Q DARLEPARA Q DEJE DE ESTAR DE MALCRIADO UN BOMBON GOLOSINA"|	a17cp2a=="CONTUMEREARLA ABRAZALA PARA QUEU DEJE DE LLORAR Y SE CALME"|	a17cp2a=="CONTUMERIARLA SACARLA A PASEAR"|	a17cp2a=="CONTUMERIARLO CARGANDO YLO ABRAZO"|	a17cp2a=="CUANDO JUEGA CON EL"|	a17cp2a=="CUANDO LO MANDA A JUGAR"|	a17cp2a=="CUANDO LO PASEA"|	a17cp2a=="DANDOLE UN JUGUETE"|	a17cp2a=="DAR JUGUETE PARA QUE SE CONTETE Y PASEARLA"|	a17cp2a=="DARLE ALGO QUE QUIERE JUGUETE"|	a17cp2a=="DARLE ALGUN JUGUETE"|	a17cp2a=="DARLE CARICIAS"|	a17cp2a=="DARLE DINERO"|	a17cp2a=="DARLE DULCE O BONBONES, CAJETAS"|	a17cp2a=="DARLE JUGUETE"|	a17cp2a=="DARLE JUGUETES"|	a17cp2a=="DARLE JUGUETES CHINEARLA"|	a17cp2a=="DARLE JUGUETES PARA QUE JEUGUE SOLO"|	a17cp2a=="DARLE SUS JUGUETES PARA QUE SE ENTRETENGA"|	a17cp2a=="DARLE UN JUGUETE"|	a17cp2a=="DARLE UN JUGUETE (DE LOSQUE TIENE EN CASA, USO)"|	a17cp2a=="DARLE UN PASEO"|	a17cp2a=="DARLES JUGUETES"|	a17cp2a=="JUGAR CON EL"|	a17cp2a=="JUGAR CON EL (CON MAMA)"|	a17cp2a=="JUGAR CON EL Y CHINEARLO"|	a17cp2a=="JUGAR CON ELLA"|	a17cp2a=="JUGAR CON ELLA (MOSTRARLESONAJEROS"|	a17cp2a=="LA ACARICIA"|	a17cp2a=="LA ARRODILLA"| a17cp2a=="LA CARGA Y LA SACA A PASEAR"|	a17cp2a=="LA CHINCHINEA LO SACO LAA FUERA A PASEAR PARA QUE SE COLME Y NO SIGA LLORANDO"|	a17cp2a=="LA CHINEA"|	a17cp2a=="LA CHINEO O LA SACO A PASEARLA DONDE EL VECINO"|	a17cp2a=="LA CONTUMEREA SACANDOLA AFUERA DE LA CASA A PASEARLA"|	a17cp2a=="LA MECE EN LA HAMACA"|	a17cp2a=="LA PASEA"|	a17cp2a=="LA PASEA CHINEADA"|	a17cp2a=="LA PASEAN"|	a17cp2a=="LA PASEO"|	a17cp2a=="LA PONE A JUGAR"|	a17cp2a=="LA PONE A JUGAR CON SU HERMANO"|	a17cp2a=="LA PONE A JUGAR SOLA CONSUS JUGUTES"|	a17cp2a=="LA PONE A VER TELEVISION"|	a17cp2a=="LA SACA A PASEAR"|	a17cp2a=="LA SACA A PASEARLA"|	a17cp2a=="LA SACA PASEAR"|	a17cp2a=="LE DA DINERO PARA QUE COPMPRE EN LA VENTA"|	a17cp2a=="LE DA I PESO PARA QUE COMPRE EN LA VENTA"|	a17cp2a=="LE DA JUGUETE"|	a17cp2a=="LE DA JUGUETE PARA QUE SECALME"|	a17cp2a=="LE DA UN JUGUETE"|	a17cp2a=="LE DA UN JUGUETE Y LA PONE A JUGAR"|	a17cp2a=="LE DA UN JUGUETE Y LO SACA A PASEAR PARA QUE SE CALME"|	a17cp2a=="LE DAN JUGUETES PARA ENTRENERLO"|	a17cp2a=="LE DAN UN JUGUETE Q LE GUSTE PARA Q SE CALME"|	a17cp2a=="LE DOY JUGUETES"|	a17cp2a=="LE PONE A JUGAR"|	a17cp2a=="LE PONE LOS JUGUETES"|	a17cp2a=="LLEVA A PASEAR"|	a17cp2a=="LLEVARLO A JUGAR"|	a17cp2a=="LO CHINEA"|	a17cp2a=="LO CHINEA Y JUEGA CON EL"|	a17cp2a=="LO LLEVA A COMPRAR CARAMELO"|	a17cp2a=="LO LLEVAN A PASEAR"|	a17cp2a=="LO MANDA A JUGAR"| a17cp2a=="LO MANDA JUGAR"|	a17cp2a=="LO PASEA"|	a17cp2a=="LO PASEA LE DA JUGUETES"|	a17cp2a=="LO PASEA O DA JUGUETES"|	a17cp2a=="LO PASEO SACO DE LA CASA"|	a17cp2a=="LO PONE A JUGAR"|	a17cp2a=="LO SACA A CAMINAR"|	a17cp2a=="LO SACA A LA CALLE A VER"| a17cp2a=="LOS PONE DE RODILLAS"|	a17cp2a=="MANDAR A JUGAR"|	a17cp2a=="MANDAR A PASEARLO DONDE LA ABUELA"|	a17cp2a=="MANDARLA A JUGAR"|	a17cp2a=="MANDARLA A JUGAR FUERA DELA CASA"|	a17cp2a=="MANDARLE JUGUETE"|	a17cp2a=="MANDARLO A JUGAR"|	a17cp2a=="MANDARLO A JUGAR A LAS CASAS VECINAS"|	a17cp2a=="MANDARLO A JUGAR FUERA DELA CASA"|	a17cp2a=="MECERLO"|	a17cp2a=="MECERLO OB 12 DICE QUE ME"|	a17cp2a=="MESA AMACA"|	a17cp2a=="MIMARLA"|	a17cp2a=="MIMARLA CON JUGUETES O CHINEARLA"|	a17cp2a=="PASEAR"|	a17cp2a=="PASEAR CON EL"|	a17cp2a=="PASEARL DARLE JUGUETE"|	a17cp2a=="PASEARLA"|	a17cp2a=="PASEARLA DARLE UN JUGUETE"|	a17cp2a=="PASEARLA DORMIRLA"| a17cp2a=="PASEARLA Y CONTARLE"|	a17cp2a=="PASEARLA Y DARLE UN JUGUETE"|	a17cp2a=="PASEARLO"|	a17cp2a=="PASEARLO DARLE JUGUETES"|	a17cp2a=="PASEARLO Y DARLE JUGUETE"|	a17cp2a=="PASTOREAR"|	a17cp2a=="PONE A SUS OTROS HIJOS QUE LA PASEEN O CHINEARLO\n"|	a17cp2a=="PONERLE LA TV DIBUJOS ANIMADO"|	a17cp2a=="PONERSE A JUGAR CON EL"|	a17cp2a=="SACA A PASEAR"|	a17cp2a=="SACA A PASEAR O JUGAR"|	a17cp2a=="SACA A PASEARLA O DARLE JUGUETES"|	a17cp2a=="SACARLA A PASEAR PARA Q SE CALME"|	a17cp2a=="SACARLA A PASEARLA PARA QDEJE DE LLORAR Y SE CALME"|	a17cp2a=="SACARLO A PASEAR"|	a17cp2a=="SACARLO A PASEAR A LA VENTA LE DAN ALGO PARA Q DEJE LLORAR Y SE CALME"|	a17cp2a=="SE LA LLEVA A PASEAR"|	a17cp2a=="SE PONE A JUGAR CON ELLA" |	a17cp2a=="ACONSEJA PARA QUE NO ANDEDE MALCREADO Y LE DA DINERO"


replace violence_alt_other1=1 if a17cp2a_clean=="CHINEARLAYBAARLA" | a17cp2a_clean=="DARLECARIOPASEARLA" | a17cp2a_clean=="JUEGACONLANIA" | a17cp2a_clean=="LAABRAZALEDACARIO" | a17cp2a_clean=="LEDACARIO"| a17cp2a_clean=="LABAA" | a17cp2a_clean=="LOCHINEAODALOSJUGUETESDELNIO" | a17cp2a_clean=="LOLLEVAAJUGARYLEENSEAALASPARAQSECALME\n"| a17cp2a_clean=="LOSBAAYLOSMANDAADORMIR"| a17cp2a_clean=="LOMANDAAJUGARALVECINOOLOBAAYLOMANDAADORMIR"| a17cp2a_clean=="PASEARLAYBAARLOS"|	a17cp2a_clean=="MANDARLOAJUGARALPATIOCONLOSOTROSNIOS" | a17cp2a_clean=="CONTUMEREARLOSACARLAAPASEARYLAGARGAPARAQUESECALMECOMOESLAPEQUEAHAYQUEMIMARLA"

replace violence_alt_other1=1 if a17cp2a_1==1 | a17cp2a_1==15 | a17cp2a_1==19 | a17cp2a_1==21 | a17cp2a_1==23

replace violence_alt_other1=1 if a17cp2a_2==1 | a17cp2a_2==15 | a17cp2a_2==15

label var violence_alt_other1 "misbehave works: distract"

*explain
gen violence_alt_other2=0 if a17cp2!=.
replace violence_alt_other2=1 if a17cp2a=="ACONSEJA P Q DEJE DE ESTAR DE MALCREADO"|	a17cp2a=="ACONSEJA PARA Q DE ESTARDE MALCREADO"|	a17cp2a=="ACONSEJA PARA QUE NO ANDEDE MALCREADO Y LE DA DINERO"|	a17cp2a=="ACONSEJARLA"|	a17cp2a=="ACONSEJARLA PARA Q NO ESTEDENECIA"|	a17cp2a=="ACONSEJARLA Q NO HAGA COSAS MALAS"|	a17cp2a=="ACONSEJARLO PARA Q NO ESTE DE MALCREADO"|	a17cp2a=="LO CORRIGE CONVERSANDO QUE HAGA CASO Q NO SEA NECIO"

replace violence_alt_other2=1 if a17cp2a_clean=="ACONSEJARLOQNOANDEDEDEMALCREADOYENGAARLOCONALGOPARAQNOANDEDENECIO" |a17cp2a_clean=="ACONSEJALEDICEQSEAOBEDIENTECONSUPAP"

replace violence_alt_other2=1 if a17cp2a_1==2

label var violence_alt_other2 "misbehave works: explain"

* follow 
gen violence_alt_other3=0 if a17cp2!=.
replace violence_alt_other3=1 if a17cp2a=="DARLE LO QUE ELLA QUIERECOSAS"

label var violence_alt_other3 "misbehave works: follow"

*ignore

gen violence_alt_other4=0 if a17cp2!=.
replace violence_alt_other4=1 if a17cp2a=="IGNORARLO NO LE HAGO CASO"| a17cp2a=="NO HACERLE CASO Y ESPEROQUE SE LE PASE LA MALACRIANZA"

label var violence_alt_other4 "misbehave works: ignore"

*nag
gen violence_alt_other5=0 if a17cp2!=.
replace violence_alt_other5=1 if a17cp2a_clean=="DECIRLEQUESECALLE(COMOUNREGAO)"

label var violence_alt_other5 "misbehave works: nag"

*punish
gen violence_alt_other6=0 if a17cp2!=.
replace violence_alt_other6=1 if a17cp2a=="DECIRLE QUE NO IRA A PASEAR CON LA MAMA\n"|	a17cp2a=="ENCERRARLO EN EL CUARTO"|	a17cp2a=="LA PONE ARRODILLADA"|	a17cp2a=="LA PONE DE RODILLA A ORARPOR 4 MINUTOS"|	a17cp2a=="LA PONE HACER OFICIO"|	a17cp2a=="AMARRE DE LA SILLA PARA QUE SE CALME DE AGNA DE ESTA DE NECIA"|	a17cp2a=="AMENAZA CON NO COMPRARLEALGO"|	a17cp2a=="APAGARLE LA TELEVISION"|	a17cp2a=="ARRODILLARLO EN EL SOL"|	a17cp2a=="CASTIGA"|	a17cp2a=="CASTIGARLA"|	a17cp2a=="CASTIGARLA CON SENTARLA YNO DEJARLA JUGAR"|	a17cp2a=="CASTIGARLA LA MANDA ACOSTARSE"|	a17cp2a=="CASTIGARLA LE DOY CON UNATAJA"|	a17cp2a=="CASTIGARLO"|	a17cp2a=="CASTIGARLO NO DEJANDOLO VER TV"|	a17cp2a=="LA PONE A BARRER, HACER OFICIO"|	a17cp2a=="LO MANDA A DORMIR"|	a17cp2a=="LO MANDA A TRAER AGUA"|	a17cp2a=="LO PONE INCADO 10 MINUTOS"|	a17cp2a=="LO PONE SENTADO Y LO DEJOPOR 15 MINUTOS"|	a17cp2a=="MANDA ACOSTARCE"|	a17cp2a=="MANDAR A QUE HAGA OFICIOS"|	a17cp2a=="MANDARLO A ACOSTAR"|	a17cp2a=="MANDARLO A DORMIR"|	a17cp2a=="MANDARLO A HACER MANDADOS\n"|	a17cp2a=="NO DEJARLO SALIR Y PONERLO A ESTUDIAR"|	a17cp2a=="NO LO DEJA SALIR A JUGAR"|	a17cp2a=="NO LO DEJA SALIR AL PATIOA JUGAR"|	a17cp2a=="PONE A SACAR AGUA"|	a17cp2a=="PONERLA HACER OFICIO"

replace violence_alt_other6=1 if a17cp2a_1==4 | a17cp2a_1==11 | a17cp2a_1==13 | a17cp2a_1==16 | a17cp2a_1==17 | a17cp2a_1==18 | a17cp2a_1==20

label var violence_alt_other6 "misbehave works: punish"

*put to study
gen violence_alt_other7=0 if a17cp2!=.
replace violence_alt_other7=1 if a17cp2a=="NO DEJARLO SALIR Y PONERLO A ESTUDIAR"

label var violence_alt_other7 "misbehave works: put to study"

*shepherd
gen violence_alt_other8=0 if a17cp2!=.
replace violence_alt_other8=1 if a17cp2a=="DARLE REMEDIO PORQUE ESTAENFERMO"| a17cp2a=="LA DUERME"| a17cp2a=="LA DUERME MECIENDOLA EN UNA AMACA"| a17cp2a=="LA DUERMO"| a17cp2a=="LO DUERME"| a17cp2a=="LO DUERME EN UNA HAMACA"| a17cp2a=="MESERLO PARA QUE SE DUERMA"|  a17cp2a=="SE ACUESTA A DORMIR"

replace violence_alt_other8=1 if a17cp2a_clean=="PASEARLAYBAARLOS"

replace violence_alt_other8=1 if a17cp2a_1==5| a17cp2a_1==14 | a17cp2a_1==35

replace violence_alt_other8=1 if a17cp2a_2==5

label var violence_alt_other8 "misbehave works: shepherd"

*spank
gen violence_alt_other9=0  if a17cp2!=.
replace violence_alt_other9=1 if a17cp2a=="LO HINCA"

label var violence_alt_other9 "misbehave works: spank"

*threaten
gen violence_alt_other10=0 if a17cp2!=.
replace violence_alt_other10=1 if 	a17cp2a=="AMENAZA CON CASTIGARLA OINYECTARLA"|	a17cp2a=="AMENAZA CON DECIRLE AL PAPA PARA QUE LE PEGUE"|	a17cp2a=="AMENAZA CON QUE SE LA VANA LLEVAR"|	a17cp2a=="AMENAZO CON IRSE"|	a17cp2a=="ASUSTARLA CON QUE LE VA ASALIR UN ANIMAL"|	a17cp2a=="LA ASUSTA DICIENDO QUE SELA LLEVA EL MONO"|	a17cp2a=="LA METE EN MIEDO LE DICEQUE EL MONO NO SE LA VA A COMER"|	a17cp2a=="LE DICE QUE LA VAN A VACUNAR"|	a17cp2a=="LE DICE QUE SE LO VAN A LLEVAR"|	a17cp2a=="LE DICE QUE SE VA A MORIRY QUE SE VA A QUEDAR SOLA"|	a17cp2a=="LE DICE QUE SE VA Y LO DEJA SOLO"|	a17cp2a=="LE DICE QUE SI SIGUE DE MALCRIADO SE VA A PONER FEA SI QUIERE VERSE BONITA TIENE QUE HACER CASO"|	a17cp2a=="LE DICEN QUE EL GATO SE LO LLEVA SI SIGUE LLORANDO"|	a17cp2a=="LE HACE MIEDO (HAY VIENEEL MONO"|	a17cp2a=="LE HACE MIEDO COMO DICIENDOLE VIENE EL GATO ETC"|	a17cp2a=="LE HACE MIEDO TE VA A COMER EL GATO"|	a17cp2a=="LO AMENAZA CON DECIRLE QUE NO VA A SALIR"|	a17cp2a=="LO ASUSTA"|	a17cp2a=="LO METE EN MIEDO"|	a17cp2a=="METERLA EN MIEDO"|	a17cp2a=="METERLA EN MIEDO (HAY VIENEN LOS ANIMALES)"|	a17cp2a=="METERLA EN MIEDO QUE LE SALE UN ANIMAL Y SE LA LLEVA"|	a17cp2a=="METERLO EN MIEDO"|	a17cp2a=="METERLO EN MIEDO DICIENDOLE QUE SE LO VA A LLEVAR EL CONGO"|	a17cp2a=="METERLO EN MIEDO HAY VIENE EL CHANCHO"

replace violence_alt_other10=1 if a17cp2a_clean=="AMENAZAALNIOQUESELOVAALLEVARLAPOLICIA" | a17cp2a_clean=="AMENAZALACONDECIRLEALAMAMPARAQUELEPEGUE" | a17cp2a_clean=="LOAMENAZACONQUESELOVAUNSEOR"

replace violence_alt_other10=1 if a17cp2a_1==3 |  a17cp2a_1==6 |  a17cp2a_1==7 |  a17cp2a_1==8 | a17cp2a_1==10

label var violence_alt_other10 "misbehave works: threaten"

gen misbehave_violence_alt=.
replace misbehave_violence_alt=0 if a17cp2!=2 & a17cp2!=3 & a17cp2!=4 & violence_alt_other5==0 & violence_alt_other6==0 & violence_alt_other9==0 & violence_alt_other10==0 & a17cp2!=.
replace misbehave_violence_alt=1 if a17cp2==2 | a17cp2==3 | a17cp2==4 | violence_alt_other5==1| violence_alt_other6==1 |  violence_alt_other9==1 | violence_alt_other10==1
label var misbehave_violence_alt "misbehave: violence (works)"

gen misbehave_nonviolence_alt=.
replace misbehave_nonviolence_alt=0 if a17cp2!=1 &  a17cp2!=6 & a17cp2!=7 & a17cp2!=8 & a17cp2!=9 & a17cp2!=10 & a17cp2!=11 & violence_alt_other1==0 & violence_alt_other2==0 & violence_alt_other3==0 & violence_alt_other4==0 & violence_alt_other7==0 & violence_alt_other8==0 & a17cp2!=.

replace misbehave_nonviolence_alt=1 if a17cp2==1  | a17cp2==6 | a17cp2==7 | a17cp2==8 | a17cp2==9 | a17cp2==10 | a17cp2==11 | violence_alt_other1==1 | violence_alt_other2==1 | violence_alt_other3==1 | violence_alt_other4==1 |violence_alt_other7==1 | violence_alt_other8==1
label var misbehave_nonviolence_alt "misbehave: non-violence (works)"

 
************************************************
*********Discipline indices*********************
************************************************

gen invmisbehave_violence=misbehave_violence*(-1)
gen invmisbehave_violence_alt=misbehave_violence_alt*(-1)

local discipline invmisbehave_violence misbehave_nonviolence invmisbehave_violence_alt misbehave_nonviolence_alt

 foreach x of local discipline {
su `x' if early_treated==0
gen `x'_sd= (`x'- r(mean)) / r(sd)

}


egen discipline=rowmean(invmisbehave_violence_sd misbehave_nonviolence_sd ) //invmisbehave_violence_alt_sd misbehave_nonviolence_alt_sd


su discipline if early_treated==0
gen discipline_sd= (discipline- r(mean)) / r(sd)

label var discipline_sd "Discipline Index (Z)"

********************************************
**#HOME*************************************
********************************************
local positive a19ap1 a19ap2 a19ap3 a19ap5 a19ap6 a19bp2  a19bp3 a19bp9  a19bp10  a19bp11  a19cp5     

local negative a19ap4  a19bp4  a19bp5 a19bp6  a19bp7 a19bp8 a19cp1 a19cp2 a19cp3  a19cp4 

foreach x of local positive {

gen s_`x'=.
replace s_`x'=0 if `x'==2
replace s_`x'=1 if `x'==1
}

foreach x of local negative {

gen s_`x'=.
replace s_`x'=0 if `x'==1
replace s_`x'=1 if `x'==2
}


label var s_a19ap1 "positive responde"
label var s_a19ap2 "correct grammatical structure"
label var s_a19ap3 "verbal affection"
label var s_a19ap4 "not refer in derogatory manner"
label var s_a19ap5 "praise of child"
label var s_a19ap6 "positive feelings"

label var s_a19bp2 "vocalize to/conversed with child"
label var s_a19bp3 "responded verbally to child"
label var s_a19bp4 "not shout child"
label var s_a19bp5 "not express annoyance toward child"
label var s_a19bp6 "not spank child"
label var s_a19bp7 "not scold child"
label var s_a19bp8 "not restrict child"
label var s_a19bp9 "teach child"
label var s_a19bp10 "kiss child"
label var s_a19bp11 "speak clearly"

label var s_a19cp1 "clean face"
label var s_a19cp2 "clean hair"
label var s_a19cp3 "clean hands"
label var s_a19cp4 "clean clothes"
label var s_a19cp5 "wears shoes"


**** Family relationships
/*
*a19ap1 a19ap2 a19ap3 a19ap4 a19ap5 a19ap6

variable name   type    format     label      variable label
------------------------------------------------------------------------------------
a19ap1          byte    %10.0g     si_no      Guardian muestra respuestas emocionales positivas
a19ap2          byte    %10.0g     si_no      Guardian utiliza una estructura  gramatical adecuada
a19ap3          byte    %10.0g     si_no      Guardian utiliza algun termino de cari�o
a19ap4          byte    %10.0g     si_no      Guardian se refier al ni�o de manera derrogativa
a19ap5          byte    %10.0g     si_no      Guardian espontaneamente alaba al ni�o  (al menos 2 veces)
a19ap6          byte    %10.0g     si_no      Guardian al hablar transmite sentimientos positivos
	
	variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------------------------------------
a19bp1          byte    %10.0g     si_no      Estuvo despierto y se observo interaccion con guardian
a19bp2          byte    %10.0g     si_no      Espontaneamente el guardian dirigio palabras o sonidos de afecto
a19bp3          byte    %10.0g     si_no      El guardian respondio verbalmente ante sonidos y palabras de afecto
a19bp4          byte    %10.0g     si_no      El guardian grito al ni�o
a19bp5          byte    %10.0g     si_no      El guardian expreso fastidio/hostilidad hacia el ni�o
a19bp6          byte    %10.0g     si_no      El guardian le pego durante la entrevista
a19bp7          byte    %10.0g     si_no      El guardian le rega�o o critico durante la entrevista
a19bp8          byte    %10.0g     si_no      El guardian le prohibio hacer algo en 3 ocasiones
a19bp9          byte    %10.0g     si_no      El guardian le ense�o algo al menos en una ocasion
a19bp10         byte    %10.0g     si_no      El guardian le acaricio o beso por lo menos una vez
a19bp11         byte    %10.0g     si_no      La forma de hablar del guardi�n es clara, audible y bien articulada


	variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------------------------------------
a19cp1          byte    %10.0g     si_no      Tiene la cara sucia
a19cp2          byte    %10.0g     si_no      Tiene el pelo sucio
a19cp3          byte    %10.0g     si_no      Tiene las manos sucias
a19cp4          byte    %10.0g     si_no      Tiene la ropa sucia
a19cp5          byte    %10.0g     si_no      Tiene puesto calzado
*/


gen home_s1=.

replace home_s1=s_a19ap1 + s_a19ap2 + s_a19ap3 + s_a19ap4 + s_a19ap5 + s_a19ap6

label var home_s1 "family relationships"

****Interactions (conditional on a19bp1==Yes)
*a19bp1 a19bp2 a19bp3 a19bp4 a19bp5 a19bp6 a19bp7 a19bp8 a19bp9 a19bp10 a19bp11
*note: 
gen home_s2=.

replace home_s2= s_a19bp2 + s_a19bp3 + s_a19bp4 + s_a19bp5 + s_a19bp6 + s_a19bp7 + s_a19bp8 + s_a19bp9 + s_a19bp10 + s_a19bp11

label var home_s2 "interactions"

****Hygiene 
*a19cp1 a19cp2 a19cp3 a19cp4 a19cp5

gen home_s3=.
replace home_s3= s_a19cp1 + s_a19cp2 + s_a19cp3 + s_a19cp4 + s_a19cp5

label var home_s3 "hygiene"

****Avoidance of restriction and punishment

gen home_s4= s_a19bp4 + s_a19bp5  + s_a19bp6 + s_a19bp7  + s_a19bp8 

label var home_s4 "avoidance punishment"

*home a + b
tab a19score
label var a19score "family relationship + interactions"

*conditional on having answers on interaction
gen a19scorev2=home_s1 + home_s2
label var a19scorev2 "family relationship + interactions (v2)"

*section d: behaviour of childgroup

*not shy
gen s_a19dp1=0 if a19dp1==1
replace s_a19dp1=1 if a19dp1==2
label var s_a19dp1 "test:not shy"

*normal behavior
gen s_a19dp2=0 if a19dp2==2
replace s_a19dp2=1 if a19dp2==1
label var s_a19dp2 "test:normal behavior"

*cooperate

gen s_a19dp3=0 if  a19dp3==2 |  a19dp3==3
replace s_a19dp3=1 if  a19dp3==1
label var s_a19dp3 "test:cooperate (always)"

*interested


gen s_a19dp4=0 if a19dp4==2 | a19dp4==3
replace s_a19dp4=1 if a19dp4==1
label var s_a19dp4 "test:interested"

*bold

gen s_a19dp5=0 if a19dp5==1
replace s_a19dp5=1 if a19dp5==2 | a19dp5==3
label var s_a19dp5 "test:bold"


*not distracted

gen s_a19dp6=0 if a19dp6==1
replace s_a19dp6=1 if a19dp6==2
label var s_a19dp6 "test:not distracted"

gen home_s5=s_a19dp1 + s_a19dp2 + s_a19dp3 + s_a19dp4 + s_a19dp5 + s_a19dp6
label var home_s5 "test"

 

************************************************
*********HOME index*****************************
************************************************


local home  home_s1 home_s2 home_s3 home_s5

 foreach x of local home {
su `x' if early_treated==0
gen `x'_sd= (`x'- r(mean)) / r(sd)

}

egen home_av=rowmean(home_s1_sd home_s2_sd home_s3_sd home_s5_sd) if (home_s1!=. & home_s2!=. & home_s3!=. & home_s5!=.)


su home_av if early_treated==0
gen home_sd= (home_av- r(mean)) / r(sd)

label var home_sd "home sd"


**************************
**#Anthropometrics**********
**************************
****Merging and creating anthropometric measures****
merge 1:1 noformul hogarid hogarid_punto cp a_id04 a16age a16p4 a16p6 using "${datainput}/anthro_older_z"
assert _merge==3
drop _merge 
*****younger than 5 years old
*I use command zscore06

sum a16age a16p4 a16p6 a_id04

zscore06 , a(a16age) s(a_id04) h(a16p6) w(a16p4) female(2) male(1)


* Length/height-for-age z-score (zlen) zlen < -6 or zlen > 6
replace haz06 =. if haz06 < -6 | haz06 > 6
* Weight-for-age z-score (zwei) zwei < -6 or zwei > 5
replace waz06=. if waz06 < -6 | waz06 > 5
* BMI-for-age z-score (zbmi) zbmi < -5 or zbmi > 5 
replace bmiz06=. if bmiz06 < -5 | bmiz06 > 5
*Weight-for-height
replace whz06=. if whz06<-5 | whz06>5


gen haz=.
replace haz=haz06 if a16age<=60
replace haz=_zhfa if a16age>60

label var haz "height for age"

gen waz=.
replace waz=waz06 if a16age<=60
replace waz=_zwfa if a16age>60


label var waz "weight for age"

gen bmiz=.
replace bmiz=bmiz06 if a16age<=60
replace bmiz=_zbfa if a16age>60

label var bmiz "bmi for age"

gen whz=.
replace whz=whz06 if a16age<=60

label var whz "weight for height"


***weight 
tab a16p3,miss
*58 missing values


***height
tab a16p6,miss
*55 missing values


*age
tab a16age,miss
*54 missing values

*Height-for-age
tab haz, miss

*Weight-for-age
tab waz, miss

*BMI-for-age
tab bmiz, miss

*Weight-for-height
tab whz, miss

*Underweight ( Underweight: weight for age < –2 SD)

gen underweight=.
replace underweight=0 if waz>=-2 & waz!=.
replace underweight=1 if waz<-2 & waz!=.

label var underweight "underweight"

*Stunting (height for age < –2 SD )

gen stunting=.
replace stunting=0 if haz>=-2 & haz!=.
replace stunting=1 if haz<-2 & haz!=.

label var stunting "stunting"

*Wasting (Wasting: weight for height < –2 SD)

gen wasting=.
replace wasting=0 if whz>=-2 & whz!=.
replace wasting=1 if whz<-2 & whz!=.

label var wasting "wasting"

*Overweight (Overweight: weight for height > +2 SD)
gen overweight=.
replace overweight=0 if whz<=2 & whz!=.
replace overweight=1 if whz>2 & whz!=.

label var overweight "overweight"




******************************************************************
***Children's outcomes********************************************
******************************************************************

*Any illness (HHS)
tab s4p29a,miss

***Disability 

*Tiene discapacidad permanente 
tab s4p58a,miss
*7 missing values
*only 1.2% are disabled




**************************
*Cognitive Skills*********
**************************

*****************
***TVIP (3-6)
*****************

tab a5score 
tab a5score if p2>=3, miss
* 88 missing values

*Standardized measured

gen za5score=.

sum a5score 
gen a5score_mean=r(mean)
gen a5score_sd=r(sd)
replace za5score=(a5score-a5score_mean)/a5score_sd
label var za5score "Standardized score TVIP"

**************************
***Short term memory (3-6)
**************************
tab a4score

gen a4score_b7=.
replace a4score_b7=0 if a4score>7&a4score!=.
replace a4score_b7=1 if a4score<=7
label var a4score_b7 "Score on short-term memory - 7 or less correct"

gen a4score_b20=.
replace a4score_b20=0 if a4score>20&a4score!=.
replace a4score_b20=1 if a4score<=20
label var a4score_b20 "Score on short-term memory - 20 or less correct"

************************
***Digit spam test (3-6)
************************

***Total score
tab a6score 
*digit span forward
tab a6score_p1 
*digit span backwards
tab a6score_p2


gen a6score_b3=.
replace a6score_b3=0 if a6score>=3&a6score!=.
replace a6score_b3=1 if a6score<3
lab var a6score_b3 "Digit span- below 3"

****Standardized measured

gen za6score=.

sum a6score 
gen a6score_mean=r(mean)
gen a6score_sd=r(sd)
replace za6score=(a6score-a6score_mean)/a6score_sd
label var za6score "Standardized score on digit span test"






*****************************************************************************
*** DENVER *****************************************************************
****************************************************************************
*************************
***Socio-emotional skills
*************************

*Personal-social tasks (Denver)
des a7a*
tab a7a_nrresp 
tab a7a_nradv 
tab a7a_nrnormal 
tab a7a_nrcaution 
tab a7a_complete 
tab a7a_adv 
tab a7a_delay 
tab a7a_caution

**************************
***Language tasks (Denver)
**************************

tab a7b_nrresp 
tab a7b_nradv 
tab a7b_nrnormal 
tab a7b_nrcaution 
tab a7b_complete 
tab a7b_adv 
tab a7b_delay 
tab a7b_caution

*****************
***Motor Skills
*****************

*Fine motor skills (Denver)

tab a7c_nrresp 
tab a7c_nradv 
tab a7c_nrnormal 
tab a7c_nrcaution 
tab a7c_complete 
tab a7c_adv 
tab a7c_delay 
tab a7c_caution


*Gross motor skills (Denver)

tab a7d_nrresp 
tab a7d_nradv 
tab a7d_nrnormal 
tab a7d_nrcaution 
tab a7d_complete 
tab a7d_adv 
tab a7d_delay 
tab a7d_caution


*** label denver with short labels for regression tables 

foreach d of newlist a7a a7b a7c a7d {
label var  `d'_nrresp "Tasks scored"
label var  `d'_nradv "Tasks ahead of age"
label var  `d'_nrnormal  "Tasks in age range"
label var  `d'_nrcaution  "Tasks in lowest age quartile"
label var  `d'_nrdelay "Tasks delayed for age"
label var  `d'_complete  "At least 3 passes"
label var  `d'_adv  "Sills ahead of age"
label var  `d'_delay  "Skills delayed for age"
label var  `d'_caution "One skill in lowest age quartile"
}


*****************
***Behaviour
*****************

***Total difficulties score/scale

tab a17bscore 

tab a17btotdiff_scale

***Emotional symptoms raw score/scale

tab a17bemotional_score 

tab a17bemotional_scale


***Conduct problems raw score/scale

tab a17bconduct_score 

tab a17bconduct_scale


***Hyperactivity problem raw score/scale

tab a17bhyperact_score 

tab a17bhyperact_scale


**Peer problems raw score/scale

tab a17bpeer_score 

tab a17bpeer_scale

*Prosocial behaviour raw score/scale

tab a17bprosocial_score 

tab a17bprosocial_scale


****** QUESTIONS FOR MEMBERS UP TO 21 COVER MOTHERS 






******************** MERGING NEW DATA SETS *************************************
**# MERGE VARS TO DEFINE SAMPLE 
preserve 
use "${datafromtania}/Data2010_IntergenParentSample.dta", clear 
gen cp_madre=cp 
drop cp 
gen Intergen_samp7_12=(age_transfer>=7 & age_transfer<13 & (male2010all==1 | male2010all==0)  & realp==1  & treat~=.)

*This is the main sample to look at;
gen Intergen_samp9_12=(age_transfer>=9 & age_transfer<13 & (male2010all==1 | male2010all==0)  & realp==1  & treat~=.)

//rename vars
foreach var of varlist _all {
		rename `var' tb_`var' //to know the source of the var (Tania B). 

}
foreach var of newlist noformul hogarid hogarid_punto cp_madre Intergen_samp9_12 Intergen_samp7_12 {
rename tb_`var' `var'
}
tempfile intergenparentsample
save `intergenparentsample'
restore 


merge m:1 noformul hogarid hogarid_punto cp_madre using `intergenparentsample' // merge data from mothers shared by Tania
drop if _m==2
drop _m
** DEFINE SAMPLE 
keep if grupocomp_orig_mom==1 | grupocomp_orig_mom==0 
keep if Intergen_samp9_12==1
gen bdate_after_sept2006=(bdate>`=td(01sept2006)')
bysort noformul hogarid hogarid_punto cp_madre (bdate_after_sept2006): gen haskid_after_sept2006= bdate_after_sept2006[_N]
preserve //check how many mothers have kids before sept2006
keep noformul hogarid hogarid_punto cp_madre bdate_after_sept2006
collapse (sum) bdate_after_sept2006, by(noformul hogarid hogarid_punto cp_madre )
count if bdate_after_sept2006==0
restore 
keep if bdate>`=td(01sept2006)'
count
assert `r(N)'==366




**# Confirm Unique observations noformul hogarid hogarid_punto cp
unique noformul hogarid hogarid_punto cp
assert `r(N)'==`r(unique)'

**# MERGE HH to KIDS INSTRUMENT 
preserve
use "${datafinal}/hh_data_v3.dta", clear 
keep noformul hogarid hogarid_punto i09 s2p1 s2p2 s2p2a
rename (i09 s2p1 s2p2 s2p2a) (hh_i09 hh_s2p1 hh_s2p2 hh_s2p2a)

tempfile hhdata
save `hhdata'
restore 

merge m:1 noformul hogarid hogarid_punto  using `hhdata' 
drop if _m==2
drop _m 

**# MERGE HH INDV to KIDS INSTRUMENT 
 
// add relacion mama con el jefe de la persona que mas cuida al niño y age group
preserve 
use "${datafinal}/hhindiv_data_v3.dta", clear 
unique  noformul hogarid hogarid_punto cp

local keepvarsindiv s1p9a s1p9a_relacion s1p9a_edad s1p9a_male s1p20a s1p20b s1p23a s1p23b s1p25b_mother s1p25b_father
keep noformul hogarid hogarid_punto cp `keepvarsindiv' ///
				hhage_group03  hhage_group47  hhage_group815  hhage_group1625  hhage_group2650  hhage_group50 
				
foreach var of local keepvarsindiv {
	rename `var' hhind_`var' //to know the source of the var 
}

gen source_hhind="Household individual survey"
order source_hhind, first 
tempfile hhindiv
save `hhindiv'
restore 
*Merge main caregiver 
merge 1:1 noformul hogarid hogarid_punto cp using `hhindiv'  //merging the child to itself
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                           862
        from master                       162  (_merge==1)
        from using                        700  (_merge==2)

    Matched                             3,348  (_merge==3)
    -----------------------------------------


*/
drop if _m==2
drop _m 











// add relacion de la mama a jefe del hogar
preserve 
use "${datafinal}/hhindiv_data_v3.dta", clear 
keep noformul hogarid hogarid_punto cp s1p17 p3
rename cp cp_madre 
rename s1p17 hhind_s1p17_madre
label var hhind_s1p17_madre "Relacion madre a jefe del hogar"
rename p3 hhind_p3_madre
label var hhind_p3_madre "Mother is titular"
tempfile relacionmadre
save `relacionmadre'
restore 

*Merge relacion madre a jefe del hogar 
merge m:1 noformul hogarid hogarid_punto cp_madre using `relacionmadre'  //merging the child to its mother
	gen madreenroster=0 
	replace madreenroster=1 if _m==3
	label var madreenroster "Mother in HH Roster"
drop if _m==2
drop _m 
replace hhind_p3_madre=0 if hhind_p3_madre==.

gen relacion_madre_jefa=0
replace relacion_madre_jefa=1 if hhind_s1p17_madre==1
label var relacion_madre_jefa "Relation to hh head: hh head"

gen relacion_madre_esposa=0 
replace relacion_madre_esposa=1 if hhind_s1p17_madre==2
label var relacion_madre_esposa "Relation to hh head: partner"

gen relacion_madre_hija=0
replace relacion_madre_hija=1 if hhind_s1p17_madre==3
label var relacion_madre_hija "Relation to hh head: daughter"

gen relacion_madre_nuera=0
replace relacion_madre_nuera=1 if hhind_s1p17_madre==6
label var relacion_madre_nuera "Relation to hh head: daughter-in-law"

gen relacion_madre_nieta=0
replace relacion_madre_nieta=1 if hhind_s1p17_madre==7
label var relacion_madre_nieta "Relation to hh head: granddaughter"

gen relacion_madre_inlaw=0
replace relacion_madre_inlaw=1 if inlist(hhind_s1p17_madre, 5, 6, 10,11,14,22) 
label var relacion_madre_inlaw "Relation to hh head: in-law"

gen relacion_madre_otra=0
replace relacion_madre_otra=1 if inlist(0, relacion_madre_jefa, relacion_madre_esposa, relacion_madre_hija, relacion_madre_nuera, relacion_madre_nieta)

label var relacion_madre_otra "Relation to hh head: other"

local relacion_madre relacion_madre_jefa relacion_madre_esposa relacion_madre_hija relacion_madre_nuera relacion_madre_nieta relacion_madre_otra

gen hhage_group25plus=hhage_group2650+hhage_group50
gen relacion_madre_jefa_esposa=0
replace relacion_madre_jefa_esposa=1 if relacion_madre_jefa==1 | relacion_madre_esposa==1
gen relacion_madre_hija_nuera=0
replace relacion_madre_hija_nuera=1 if relacion_madre_hija==1 | relacion_madre_nuera==1

// add relacion del papa a jefe del hogar, si es beneficiario y otras caracteristicas del papa
preserve 
use "${datafinal}/hhindiv_data_v3.dta", clear 
keep noformul hogarid hogarid_punto cp s1p17 p3

rename cp cp_padre 
rename s1p17 hhind_s1p17_padre
label var hhind_s1p17_padre "Relacion padre a jefe del hogar"
rename p3 hhind_p3_padre
label var hhind_p3_padre "Father is titular"
tempfile relacionpadre
save `relacionpadre'
restore 

*Merge relacion padre a jefe del hogar 
merge m:1 noformul hogarid hogarid_punto cp_padre using `relacionpadre'  //merging the child to its father
	gen padreenroster=0 
	replace padreenroster=1 if _m==3
	label var padreenroster "Father in HH roster"
drop if _m==2
drop _m 
replace hhind_p3_padre=0 if hhind_p3_padre==.

gen relacion_padre_jefe=0
replace relacion_padre_jefe=1 if hhind_s1p17_padre==1
label var relacion_padre_jefe "Relation to hh head: hh head"

gen relacion_padre_esposo=0 
replace relacion_padre_esposo=1 if hhind_s1p17_padre==2
label var relacion_padre_esposo "Relation to hh head: partner"

gen relacion_padre_hija=0
replace relacion_padre_hija=1 if hhind_s1p17_padre==3
label var relacion_padre_hija "Relation to hh head: son"

gen relacion_padre_nuero=0
replace relacion_padre_nuero=1 if hhind_s1p17_padre==6
label var relacion_padre_nuero "Relation to hh head: son-in-law"

gen relacion_padre_inlaw=0
replace relacion_padre_inlaw=1 if inlist(hhind_s1p17_padre, 5, 6, 10,11,14,22) 
label var relacion_padre_inlaw "Relation to hh head: in-law"

gen relacion_padre_otra=0
replace relacion_padre_otra=1 if relacion_padre_jefe==0 & relacion_padre_esposo==0 & relacion_padre_hija==0 & relacion_padre_nuero==0 
label var relacion_padre_otra "Relation to hh head: other"

local relacion_padre relacion_padre_jefe relacion_padre_esposo relacion_padre_hija relacion_padre_nuero  relacion_padre_otra

gen parents_age_gap=a1p13-p2_mom
label var parents_age_gap "Father years older than mother"

**# MERGE HH SURVEY SECTION 7 to KIDS INSTRUMENT
* Key outcomes from this section: ** PREGNANCY 
preserve
use "${datafinal}/section7_childlevel.dta", clear 
drop if cp==. 
foreach var of varlist _all {
	rename `var' hhs7_`var' //to get source 
}
rename hhs7_noformul_mama noformul
rename hhs7_hogarid_mama hogarid
rename hhs7_hogarid_punto_mama hogarid_punto
rename hhs7_cp cp 
unique noformul hogarid hogarid_punto cp


gen source_hhsection7="Section 7"


// 3 cases/6 kids where mothers are different but kid has the same hogarid hogarid_punto cp. It seems as if there were multiple mothers in the same household. 
drop if hogarid==101 & hogarid_punto==1 & cp==6 
drop if hogarid==716301 & hogarid_punto==1 & cp==11 
drop if hogarid==17008901 & hogarid_punto==1 & cp==12 

tempfile s7 
save `s7'
restore

merge 1:1 noformul hogarid hogarid_punto cp using `s7'
drop if _m==2
drop _m
/*
   Result                      Number of obs
    -----------------------------------------
    Not matched                         1,416
        from master                     1,042  (_merge==1)
        from using                        374  (_merge==2)

    Matched                             2,466  (_merge==3)
	
*** 	
*/

**# BASELINE DATA 

preserve 
use "${datainput}/baseline_balance_vars.dta", clear 
local allvarspaper2016  age_transfer noedu_c edu_c  work_lw_c mom_notpresent_c dad_notpresent_c son_hhh_c mom_noedu_2010com mom_edu_3pl_2010com  hh_female_c hh_ageyearscen_c hh_noedu_c   hh_work_lw_c   p_lpce fsize_c dem_T0008n_c dem_T0912n_c lnlandsize_c ownhousealt3  workag_c pc1_b pc2_b pc3_b  rooms_c blockwall_c zincroof_c  dirtfloor_c latrine_c light_electric_c cassette_c workanimal_c fumipump_c  scholdist_min_c   Dtuma Dmadriz  //netsize_ind
merge 1:1 noformul hogarid hogarid_punto cp using "${datafromtania}/Data2010_IntergenParentSample_baselineupdate.dta", keepusing(`allvarspaper2016') //hh_edu3pl_c
keep if _merge==3
drop _merge 


rename censt_comp_4yrs_educ_head censt_4yrs_educ_head
foreach var of varlist _all {
	if 0==inlist("`var'", "noformul", "hogarid", "hogarid_punto", "cp") {
	label var `var' "`: var label `var'' BL"
	rename `var' bl_`var'
		local l=strlen("`var'")
	if `l'>=24 display as error "`var' name too long, age control may not work"
	}
}
rename cp cp_madre 
lassoClean bl_*

tempfile bl
save `bl'
restore 

merge m:1 noformul hogarid hogarid_punto cp_madre using `bl'
drop if _m==2
drop _m 
 

foreach outcomegroup of global outcomeslist {
	di "`outcomegroup'"
	sum $`outcomegroup'
}

count 
assert `r(N)'==366
save "${datafinal}/indi_2020_below7_indexes.dta", replace 	


use "${datafinal}/indi_2020_below7_indexes.dta", clear 





	
	
	
