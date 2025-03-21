/*
Input: "${datainput}/HH_INDI/indiv_level_v3.dta"
Output: "${datafinal}/hhindiv_data_v3.dta"
*/

**** CLEAN IND HH DATA TO GET INFORMATION ABOUT PARENTS 
use "${datainput}/HH_INDI/indiv_level_v3.dta", clear 

* Personas en el hogar por grupo de edad
label define age_group 0 "0-3" 4 "4-7" 8 "8-15" 16 "16-25" 26 "26-50" 51 "50+"
egen age_group=cut(p2), at(0 4 8 16 26 51 150)
label values age_group age_group
	tab age_group, gen(age_group)
	forvalues i=1/6 {
	bysort noformul hogarid hogarid_punto:	egen hhage_group`i'=total(age_group`i')
	local label=subinstr("`: var label age_group`i''","age_group==","",.)
	label var hhage_group`i' "hh members `label'"
	}
	rename (hhage_group1  hhage_group2  hhage_group3  hhage_group4  hhage_group5  hhage_group6) (hhage_group03  hhage_group47  hhage_group815  hhage_group1625  hhage_group2650  hhage_group50)
	




	
	

*  s1p17      Relacion con el jefe del hogar 
 tab s1p17
/*
p5              byte    %10.0g                Migrante permanente
p6              byte    %10.0g                Migrante temporal
s1p34 razon se fue 
*/

 tab s1p5 //  Estado Civil
 tab s1p7 // condicion de residencia 
 
 gen single=(s1p5==6)
 label var single "Single"
 
* PARA MENORES DE 15 AÑOS ¿Quién cuida a...la mayor parte del tiempo (cuándo no está en la escuela o preescolar)?
** Who takes care of ...?
tab s1p9a //   Quien cuida mayor parte del tiempo CP 
tab s1p9b  //   Quien es la persona>15 que cuida

preserve  // relacion con el jefe de la persona que mas cuida al niño
keep  noformul hogarid hogarid_punto cp s1p17 p2 male2010all
rename cp s1p9a 
rename s1p17 s1p9a_relacion
rename p2 s1p9a_edad
rename male2010all s1p9a_male
label var s1p9a_relacion "Quien cuida mayor parte del tiempo (relacion jefe)"
label var s1p9a_edad "Quien cuida mayor parte del tiempo (edad)"
label var s1p9a_male "Quien cuida mayor parte del tiempo (sex)"


tempfile caregiver
save `caregiver'
restore 

merge m:1 noformul hogarid hogarid_punto s1p9a using `caregiver'
drop if _m==2
drop _m 
order s1p9a_relacion s1p9a_edad s1p9a_male, a(s1p9a)




* INFORMACIÓN SOBRE EL PADRE y MADRE
********************************	
**# EDUCACION
********************************

des s1p25b*
/*
s1p18           byte    %16.0g     padres     Padre hogar-cp
s1p19           byte    %16.0g     analfab    Alfabetismo-Padre
s1p20a          byte    %10.0g                Ultimo grado estudio-Padre
s1p20b          byte    %13.0g     nivel_educ
                                              Nivel estudio aprobado-Padre
s1p21           byte    %16.0g     padres     Madre hogar-cp
s1p22           byte    %16.0g     analfab    Alfabetismo-Madre
s1p23a          byte    %10.0g                Ultimo grado estudio-Madre
s1p23b          byte    %13.0g     nivel_educ
                                              Nivel estudio aprobado-Madre
*/
 clonevar cp_padre=s1p18
 clonevar cp_madre=s1p21 
 
 
 
gen born_after_sept2006=(bdate2010all>`=td(01sept2006)' & bdate2010all!=.)
 
*** No. of kids
preserve 
gen mkids_born_after_sept2006=(bdate2010all>`=td(01sept2006)' & bdate2010all!=.) 
gen mkids_n=1 
collapse (sum) mkids_born_after_sept2006 mkids_n, by(noformul hogarid hogarid_punto cp_madre)
label var mkids_n "No. of kids (mother)"
label var mkids_born_after_sept2006 "No. of kids born after sept2006 (mother)"
rename cp_madre cp 

tempfile mom
save `mom'
restore 

merge 1:1 noformul hogarid hogarid_punto cp using `mom'
replace mkids_n =0 if _m==1
replace mkids_born_after_sept2006=0 if _m==1

 drop if _m==2
 drop _m 
 * Migracion - En casa?
/*
s1p28           byte    %10.0g     si_no      Actualmente esta en la casa
s1p29a          int     %10.0g                Hace cuanto se fue
s1p29b          byte    %10.0g     unidad_tiempo
                                              Unidad de tiempo: hace cuando se fue
s1p30           byte    %10.0g     si_no      Piensa regresar dentro de un mes
s1p31a          byte    %10.0g                Cuando regresara
s1p31b          byte    %10.0g     unidad_tiempo
                                              Unidad de tiempo: cuando regresara

*/



************* SECCIÓN 6A. ACTIVIDAD ECONÓMICA PARA LOS ÚLTIMOS 12 MESES: PERSONAS DE 6 AÑOS Y MÁS


* SECCIÓN 7. FECUNDIDAD Y SALUD DE LA MUJER PARA MUJERES DE 12 A 49 AÑOS

* How many of these mothers have kids?
* apart from Family Planning, questions about pregnancy are only to pregnant women and mothers with kids below 5.

local section7 s7p1a s7p1b s7p2 s7p3a s7p3b s7p4a s7p4b s7p5 s7p6 s7p7 s7p8 s7p9 s7p10 s7p11 s7p12 s7p13 s7p14 s7p15 s7p16a s7p16b s7p17a s7p17b s7p18a s7p18b s7p19 s7p20 s7p21 s7p22 s7p23 s7p24 s7p25 s7p26 s7p27 s7p28a s7p28b s7p29 s7p30 s7p31a s7p31b s7p32a s7p32b s7p33 s7p34 s7p35 s7p36

des `section7'

save "${datafinal}/hhindiv_data_v3.dta", replace 
use "${datafinal}/hhindiv_data_v3.dta", clear 

 


