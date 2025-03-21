/*
Input: "${datainput}/HH_INDI/hh_level_v3.dta"
Output: "${datafinal}/hh_data_v3.dta"
*/

**** CLEAN  HH DATA 
use "${datainput}/HH_INDI/hh_level_v3.dta", clear 
sum i09 // personas en el hogar 
label var s2p1 "Personas residentes" //           byte    %10.0g                Numero de personas residentes
label var s2p2 "Miembro migro" //  Titular o al menos un miembro migro
label var s2p2a  "Miembro migro fuera de la comunidad"    //      byte    %10.0g     si_no      Titular o al menos un miembro migro fuera de la comunidad
											
	recode s2p2 (2=0)
	recode s2p2a (2=0)
	replace s2p2a=0 if 	s2p2==0		
	
*SECCIÓN 14. OBSERVACIÓN DE AMBIENTE : REGISTRO POR OBSERVACIÓN	
save "${datafinal}/hh_data_v3.dta", replace 


