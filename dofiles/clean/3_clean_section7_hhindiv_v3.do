/*
Input: "${datainput}/HH_INDI/indiv_level_v3.dta"
Output:  "${dataint}/section7_childlevel.dta"
*/


* Using section 7 of the household individual data, I construct a data set at the kids level. 
*** CLEAN SECTION 7 OF THE HOUSEHOlD INDIVIDUAL DATA.
* FECUNDIDAD Y SALUD DE LA MUJER PARA MUJERES DE 12 a 49


* Understanding the data 
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear 

* apart from Family Planning, questions about pregnancy are only to pregnant women and mothers with kids below 5.
local identifiers noformul hogarid hogarid_punto cp hogarid_old cp_old hogreal p00 grupo_orig comcens c_strata grupocomp_orig_mom comcens_mom c_strata_mom itt itt_comcens carga_main carga_det panel  p2 p3 p4 p5

local section7 s7p1a s7p1b s7p2 s7p3a s7p3b s7p4a s7p4b s7p5 s7p6 s7p7 s7p8 s7p9 s7p10 s7p11 s7p12 s7p13 s7p14 s7p15 s7p16a s7p16b s7p17a s7p17b s7p18a s7p18b s7p19 s7p20 s7p21 s7p22 s7p23 s7p24 s7p25 s7p26 s7p27 s7p28a s7p28b s7p29 s7p30 s7p31a s7p31b s7p32a s7p32b s7p33 s7p34 s7p35 s7p36 


*****************************************************************"
*SECTION 7: FECUNDIDAD Y SALUD DE LA MUJER PARA MUJERES DE 12 a 49"
*****************************************************************"


* How many are pregnant and have another child?
tab s7p3a s7p5 , m 


**# Data set 1: kid p4, P5=2 not pregnant, outcomes p19-p28
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear 

keep if s7p5==2  //not pregnant, but kid under 5 
keep if s7p4a==1 | s7p4a==2 // has kidp4/hermano mayor under 5
* Embarazo anterior 
local kidp4  s7p4a s7p4b s7p19 s7p20 s7p21 s7p22 s7p23 s7p24 s7p25 s7p26 s7p27 s7p28a s7p28b 

keep  `identifiers' `kidp4'

foreach var of varlist `identifiers' { //these vars refer to the respondent: the mother
	rename `var' `var'_mama
	label var `var'_mama "`: var label `var'' (Mamá)"
}

* rename vars kid
rename s7p4a vive_hogar
rename s7p4b cp

rename s7p19 control_meses
rename s7p20 control_n
rename s7p21 control_sangre
rename s7p22 control_orina
rename s7p23 control_pecho
rename s7p24 control_hierro
rename s7p25 control_folico
rename s7p26 control_quien
rename s7p27 control_donde
rename s7p28a vacuna_tetano
rename s7p28b vacuna_tetano_dosis

gen hermano_mayor=1
gen ultimo_hijo=0

tempfile datakidp4 
save `datakidp4'

**# Data set 2: kid p3, P5=2 not pregnant, outcomes p7-p18, p29-p33
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear
keep if s7p5==2  //not pregnant, but kid under 5 
keep if s7p3a==1 | s7p3a==2 // has kidp3/last kid under 5
* Ultimo embarazo 
local kidp3 s7p3a s7p3b s7p7 s7p8 s7p9 s7p10 s7p11 s7p12 s7p13 s7p14 s7p15 s7p16a s7p16b s7p17a s7p17b s7p18a s7p18b s7p29 s7p30 s7p31a s7p31b s7p32a s7p32b s7p33


keep  `identifiers' `kidp3'

foreach var of varlist `identifiers' { //these vars refer to the respondent: the mother
	rename `var' `var'_mama
	label var `var'_mama "`: var label `var'' (Mamá)"
}

* rename vars kid
rename s7p3a vive_hogar
rename s7p3b cp

rename s7p7 control_meses
rename s7p8 control_n
rename s7p9 control_sangre
rename s7p10 control_orina
rename s7p11 control_pecho
rename s7p12 control_hierro
rename s7p13 control_folico
rename s7p14 control_quien
rename s7p15 control_donde
rename s7p16a vacuna_tetano
rename s7p16b vacuna_tetano_dosis
rename s7p17a control_pago
rename s7p17b control_pago_cuanto
rename s7p18a medicamentos_pago
rename s7p18b medicamentotos_pago_cuanto


rename s7p29 parto_quien
rename s7p30 parto_donde
rename s7p31a parto_pago
rename s7p31b parto_pago_cuanto
rename s7p32a postnatal
rename s7p32b postnatal_dias
rename s7p33 postnatal_quien

gen ultimo_hijo=1 
label var ultimo_hijo "Ultimo hijo (P3)"

gen hermano_mayor=0

tempfile datakidp3 
save `datakidp3'


**# Data set 3: kid p3, P5=1  pregnant, outcomes p19-p28, p29-p33
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear
keep if s7p5==1  // 
keep if s7p3a==1 | s7p3a==2 // has kidp3/last kid under 5
* Ultimo embarazo 
local kidp3_pregnant s7p3a s7p3b s7p19 s7p20 s7p21 s7p22 s7p23 s7p24 s7p25 s7p26 s7p27 s7p28a s7p28b  s7p29 s7p30 s7p31a s7p31b s7p32a s7p32b s7p33


keep  `identifiers' `kidp3_pregnant'

foreach var of varlist `identifiers' { //these vars refer to the respondent: the mother
	rename `var' `var'_mama
	label var `var'_mama "`: var label `var'' (Mamá)"
}

rename s7p3a vive_hogar
rename s7p3b cp

rename s7p19 control_meses
rename s7p20 control_n
rename s7p21 control_sangre
rename s7p22 control_orina
rename s7p23 control_pecho
rename s7p24 control_hierro
rename s7p25 control_folico
rename s7p26 control_quien
rename s7p27 control_donde
rename s7p28a vacuna_tetano
rename s7p28b vacuna_tetano_dosis

rename s7p29 parto_quien
rename s7p30 parto_donde
rename s7p31a parto_pago
rename s7p31b parto_pago_cuanto
rename s7p32a postnatal
rename s7p32b postnatal_dias
rename s7p33 postnatal_quien

gen ultimo_hijo=1 
label var ultimo_hijo  "Ultimo hijo (P3)"

gen hermano_mayor=0

tempfile datakidp3_pregnant
save `datakidp3_pregnant'


**# APPEND CHILD LEVEL

use `datakidp3', clear 

append using `datakidp3_pregnant' `datakidp4'

* Final cleaning 
 label var cp "CP del niño"
label var hermano_mayor "Hermano siguiente mayor a P3" 

 
 gen hascp=1 if cp!=.
 replace hascp=0 if cp==. 
 label var hascp "Has CP del niño"
 order hascp, a(cp) 
 
  * recode si no 
local recodesino control_sangre control_orina control_pecho control_hierro control_folico vacuna_tetano control_pago medicamentos_pago parto_pago postnatal
 
  foreach var of local recodesino {
  	recode `var' (2=0)
  }
 
 gen control_quien_doctor=0 if control_quien!=. 
 replace control_quien_doctor=1 if control_quien==1 
 label var control_quien_doctor "En control: con doctor" 
 order control_quien_doctor, a(control_quien)
 

  gen control_donde_salud=0 if control_donde!=.
 replace control_donde_salud=1 if control_donde==1 
 label var control_donde_salud "En control: cualquier centro de salud" 
  order control_donde_salud, a(control_donde)
  
   gen control=1  if control_meses!=.
  replace control=0 if control_meses==11 
  label var control "Hizo control"
 
  replace control_meses=. if control_meses==11 //no hizo control
  
    gen parto_quien_doctor=0 if parto_quien!=. 
	replace parto_quien_doctor=1 if parto_quien==1 
	label var parto_quien_doctor "En parto: con doctor" 
	order parto_quien_doctor, a(parto_quien)
	
	 gen parto_donde_hospital=0 if parto_donde!=.
	replace parto_donde_hospital=1 if parto_donde== 3 
	label var parto_donde_hospital "En parto: hospital" 
	order parto_donde_hospital, a(parto_donde)
	
	 gen postnatal_quien_doctor=0 if postnatal_quien!=. 
	replace postnatal_quien_doctor=1 if postnatal_quien==1 
	label var postnatal_quien_doctor "En postnatal: con doctor" 
	order postnatal_quien_doctor, a(postnatal_quien)
	

  * Uncondition vars 
  foreach var of varlist control_n control_sangre control_orina control_pecho control_hierro control_folico control_quien_doctor control_donde_salud   {
  	replace `var'=0 if control==0 | (control==1 & `var'==.)
	sum `var'
  }
  
	replace vacuna_tetano_dosis=0 if vacuna_tetano==0
	replace vacuna_tetano_dosis=1 if vacuna_tetano==1 & (vacuna_tetano_dosis==0 | vacuna_tetano_dosis==.)
	
	replace control_pago_cuanto=0 if control_pago==0
	
	replace medicamentotos_pago_cuanto=0 if medicamentos_pago==0

	replace parto_pago_cuanto=0 if parto_pago==0
	replace parto_quien_doctor=0 if parto_quien_doctor!=. & parto_quien!=1
	replace parto_donde_hospital=0 if  parto_donde_hospital!=. & parto_donde!=3
	replace postnatal_dias=0 if postnatal==0
	replace postnatal_quien_doctor=0 if postnatal==0
	
	label var control_pago "Pago control embarazo"
	label var control_pago_cuanto "Cuanto pago control embarazo"
	label var medicamentos_pago "Pago medicamentos embarazo"
	label var medicamentotos_pago_cuanto "Cuanto pago medicamento embarazo"
	label var parto_pago_cuanto "Cuanto pago atención parto"
	
	gen embarazo_pago =0 
	replace embarazo_pago=1 if control_pago==1 | medicamentos_pago==1 | parto_pago==1
	label var embarazo_pago "Pago control-medicamentos-parto"
	egen embarazo_pago_cuanto=rowtotal(control_pago_cuanto medicamentotos_pago_cuanto parto_pago_cuanto)
	label var embarazo_pago "Cuanto pago control-medicamentos-parto"
	
	
count  
// 2,914 observations

/* KEY VARS 
global pregnancy_siblings ultimo_hijo hermano_mayor 
global pregnancy_control control control_meses control_n control_sangre control_orina control_pecho control_hierro control_folico control_quien_doctor control_donde_salud 

global pregnancy_vaccine vacuna_tetano vacuna_tetano_dosis 

global pregnancy_expenses control_pago control_pago_cuanto medicamentos_pago medicamentotos_pago_cuanto 

global pregnancy_birth parto_quien_doctor parto_donde parto_pago parto_pago_cuanto 

global pregnancy_postnatal postnatal postnatal_dias postnatal_quien
*/

save "${datafinal}/section7_childlevel.dta", replace 


