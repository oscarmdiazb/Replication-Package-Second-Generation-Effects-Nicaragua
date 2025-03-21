**# Reg program main specification  


**# OUTREG 2
capture program drop outreg2_nica
program outreg2_nica
syntax [if] ,  outcomes(varlist) save(string) [tvar(varlist) agecontrols(string) weights(string) setfe(string) addcontrols(varlist) appendtable]
    preserve 
	if "`if'"!="" keep `if'
local tvar early_treated
label var early_treated "ITT"
local controllabel "Late Treated"
*if "`tvar'"!="" local controllabel "`: var label `tvar''(=0)"


local replace replace
if "`appendtable'"=="appendtable" local replace 
foreach var of varlist `outcomes' {
	qui sum `var' if   `tvar'==0
	local controlmean=round(`r(mean)',.001)
	if strlen("`controlmean'")>4 local controlmean=substr("`controlmean'",1,4)
	local controlsd `r(sd)'
	
	

local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma
local cluster tb_itt_comcens

if "`agecontrols'"==""  local controls 
if "`agecontrols'"=="agedummy"  local controls ${`var'_a6g} 
if "`agecontrols'"=="agepol"  local controls ${`var'_apo} 
if "`agecontrols'"!="" assert "`controls'"!="" 

if "`setfe'"!="" local fe `setfe'
	local controls `controls' `addcontrols'
	
	local l=strlen("`var'")
	if `l'>=27 display as error "var name too long, age control may not work"
	
	reg `var' `tvar' `controls' `fe' `weights', cluster(`cluster')
di "reg `var' `tvar' `controls' `fe' `weights', cluster(`cluster')"
	
	
	local regn=e(N)
		
		if "`keep'"=="" {
			local keep `tvar'
		}
	
	local obs=`e(N)'
	local addstat addstat(N, `obs', Mean Late Treatment, `controlmean')
	if abs(`controlmean')<0.001 {
	local addstat addstat(N, `obs')
	}
		
	outreg2 using "`save'", ///
	tex(frag) keep(`keep') `replace' nocons ///
	`addstat' label nonote noni nor2 dec(3) noobs
	local replace 
}
	
	end 

	
	
	
**#Standardize vars with respect to Late treatment	
	capture program drop z_lt
program define z_lt 
syntax varlist [if] , [tvar(varlist)]
if "`tvar'"=="" local tvar early_treated

foreach var of varlist `varlist' {
	sum `var' if `tvar'==0
	replace `var'=(`var'-`r(mean)')/`r(sd)'
}
end
 
**# Randomization inference 

capture program drop ri_nica
program ri_nica
syntax  ,  outcomes(varlist) save(string)

local tvar early_treated

local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma
local cluster tb_itt_comcens

local w= wordcount("`outcomes'")
matrix define ri=J(`w',3,.)
matrix colnames ri =  "Minimum P-value" "Maximum P-value" "Randomized P-value"
local i=1
local varlabels hola
local hola hola 

foreach var of varlist `outcomes' {
if "`agecontrols'"=="agedummy"  local controls ${`var'_a6g} 
if "`agecontrols'"!="" assert "`controls'"!="" 
	

di "randcmd ((early_treated) reg `var' `tvar' `controls' `fe' `weights', cluster(`cluster')), treatvars(`tvar') strata(tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7)"
 
randcmd ((`tvar' ) reg `var' `tvar' `controls' `fe' `weights', cluster(`cluster')), treatvars(`tvar') strata(tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7) 


local label=subinstr("`: var label `var''",","," ",.)
local varlabels `varlabels' "`label'"
matrix ri[`i',1]=round(e(RCoef)[1,4],0.001)
matrix ri[`i',2]=round(e(RCoef)[1,5],0.001)
matrix ri[`i',3]=round(e(RCoef)[1,6],0.001)
local i=`i'+1
}
local varlabels : list varlabels - hola
mat rownames ri = `varlabels'
mat list ri
esttab matrix(ri) using "`save'",  replace cells("Coef(fmt(3)) P-value(fmt(3))") 

mat drop ri 
	end 



	

**# RITEST 
capture program drop ritest_nica
program ritest_nica
syntax  ,  outcomes(varlist) save(string) reps(integer)

local tvar early_treated
local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma
local cluster tb_itt_comcens

local w= wordcount("`outcomes'")
matrix define rtist=J(`w',2,.)
matrix colnames rtist =  "Coef" "P-value"
local i=1
local varlabels hola
local hola hola 
foreach var of varlist `outcomes' {

 local controls ${`var'_a6g} 
ritest `tvar' _b[`tvar'], reps(`reps') cluster(`cluster') strata(`fe') seed(546): reg `var' `tvar' `controls' `fe' `weights', cluster(`cluster')

local label=subinstr("`: var label `var''",","," ",.)
local varlabels `varlabels' "`label'"
matrix rtist[`i',1]=round(r(b)[1,1],0.001)
matrix rtist[`i',2]=round(r(p)[1,1],0.001)
if r(p)[1,1]<0.001 matrix rtist[`i',2]=0.001
local i=`i'+1

}
local varlabels : list varlabels - hola
mat rownames rtist = `varlabels'
mat list rtist
esttab matrix(rtist) using "`save'",  replace cells("Coef(fmt(3)) P-value(fmt(3))") 

mat drop rtist

end


	


**# PDS LASSO NICA
capture program drop pdslasso_nica
program pdslasso_nica
syntax  ,  outcomes(varlist) save(string) [tvar(varlist) agecontrols(string) weights(string) partial(varlist) lassoselect(varlist) partial_age(string)]
if "`tvar'"=="" local tvar early_treated

local replace replace
foreach var of varlist `outcomes' {
	qui sum `var' if   `tvar'==0
	local controlmean=round(`r(mean)',.001)
	local controlsd `r(sd)'
	
	

local fe  tb_STRATA2  tb_STRATA3  tb_STRATA4  tb_STRATA5  tb_STRATA6 tb_STRATA7 tb_edu_lvl_c_0 tb_edu_lvl_c_1 tb_edu_lvl_c_2 tb_edu_lvl_c_3   tb_Dmadriz tb_Dtuma
local cluster tb_itt_comcens

  local age_controls 
  local lselect 
  local partialout
if "`agecontrols'"=="agedummy"  local age_controls ${`var'_a6g} 
if "`agecontrols'"=="agepol"  local age_controls ${`var'_apo} 
if "`agecontrols'"!="" assert "`age_controls'"!="" 

if "`lassoselect'"=="" local lselect cl_* `age_controls' `fe'
if  "`lassoselect'"!="" local lselect `lassoselect' `age_controls'


if "`partial'"=="" local partialout `age_controls' `fe'	
if "`partial'"!="" local partialout `partial'
if "`partial_age'"=="yes" local partialout `age_controls' `partialout'	

di "pdslasso `var' `tvar' (`lselect'), partial( `partialout' )  cl(`cluster')"

	pdslasso `var' `tvar' (`lselect'), partial( `partialout' )  cl(`cluster')

	local keep `tvar'
	local addstat addstat(DV mean (`: var label `tvar''), `controlmean')
	if abs(`controlmean')<0.001 {
	local addstat 
	}
		
	outreg2 using "`save'", ///
	tex(frag) keep(`keep') `replace' nocons ///
	`addstat' label nonote noni nor2 dec(3)
	local replace 
}
	
	end 







**# lassoClean.ado 

capture prog drop lassoClean
program lassoClean, rclass 

syntax varlist(numeric min=1) [if] [in] [, two_way to_indicator(varlist numeric min=1) to_fe(varlist numeric min=1) ]

*(0) Preliminaries	
qui: ssc install isvar
local varlist: list varlist - to_indicator 
local varlist: list varlist - to_fe
local _varlist " "
if wordcount("`two_way'")==1 {
	local max_char 11
}
else {
	local max_char 26
}
foreach var of varlist `varlist' {
	local newname = substr("`var'",1,`max_char')
	qui: gen _`newname'=`var'
	local _varlist "`_varlist' _`newname'"
}

*(1) Turn variables in `to_indicator' into indicators.  
if wordcount("`to_indicator'")!=0 {
local _i " "
foreach var of varlist `to_indicator' {
	qui: replace `var'=. if `var'>.
	local newname = substr("`var'",1,`max_char')
	qui: tabulate `var', missing generate(_`newname'i)
	unab add: _`newname'i*
	local _i "`_i' `add'"
}
}

*(2) Square variables with more than 2 values (any variable with 2 values is collinear with its square)
local _sq " "
foreach var of varlist `_varlist' {
	qui: levelsof `var'
	if wordcount("`r(levels)'")>2 {
		qui: gen `var'_sq= `var'^2
		local _sq "`_sq' `var'_sq"
	}
}

*(3) Missing dummies and missing values
local _mi " "
foreach var of varlist `_varlist' {
	qui: count if missing(`var')
	if `r(N)'>0 {
		qui: gen `var'_mi= (`var'>=.)
		local _mi "`_mi' `var'_mi"
		qui: replace `var'=0 if `var'>=.
	}
}
foreach var of varlist `_sq' {
	qui: replace `var'=0 if `var'>=.
}

*(4) Drop variables that have the same value for everything
local drop " " 
foreach var of varlist _* {
	qui: sum `var'
	if r(min)==r(max) {
		local drop "`drop' `var'" 
		qui: drop `var'
	}
}
local _varlist: list _varlist - drop
local _i: list _i - drop
local _mi: list _mi - drop
local _sq: list _sq - drop

*(5) Get rid of perfectly collinear variables
local drop " "
unab all: _*
local K: word count `all'
forv i=1(1)`=`K'-1' {
	forv j=`=`i'+1'(1)`K' {
		local y: word `i' of `all'
		local x: word `j' of `all'
		qui: isvar `y' `x'
		if wordcount("`r(varlist)'")==2 {
			qui: reg `y' `x'
			if e(r2)==1 {		
				local drop "`drop' `x'" 
				qui: drop `x' 
			}
        }
	}
}
local _varlist: list _varlist - drop
local _i: list _i - drop
local _mi: list _mi - drop
local _sq: list _sq - drop

*(6) Generate two-way interactions
if wordcount("`two_way'")==1 {
local _int " "
unab twoway: `_varlist' `_i' 
local K: word count `twoway'
forv i=1(1)`=`K'-1' {
	forv j=`=`i'+1'(1)`K' {
		local y: word `i' of `twoway'
		local x: word `j' of `twoway'
		local x = substr("`x'",2,.)	
		qui: gen `y'X`x'=`y'*_`x'
		local _int "`_int' `y'X`x'"
	}
}
foreach var of varlist `_int' {
	qui: sum `var'
	if r(min)==r(max) {
		qui: drop `var'
	}
}
}

*(7) Get rid of perfectly collinear variables including interactions
if wordcount("`two_way'")==1 {
unab all: _*
local K: word count `all'
unab non_int: `_varlist' `_i' `_mi' `_sq'
local K1: word count `non_int'
forv i=1(1)`=`K'-1' {
	forv j=`=`i'+1'(1)`K' {
		if `j'>`K1' {
			local y: word `i' of `all'
			local x: word `j' of `all'
			qui: isvar `y' `x'
			if wordcount("`r(varlist)'")==2 {
				qui: reg `y' `x'
				if e(r2)==1 {		
					drop `x' 
				}	
			}
		}
	}
}
}

*(8) Create fixed effects for specified variables 
if wordcount("`to_fe'")!=0 {
foreach var of varlist `to_fe' {
	qui: replace `var'=. if `var'>.
	tabulate `var', missing
	scalar m=length("`r(r)'")
	scalar max=28-m
	local newname = substr("`var'",1,max)
	qui: tabulate `var', missing generate(_`newname'i)
}
}

*(9) Standardize variables
foreach var of varlist _* {
	qui: sum `var'
	qui: replace `var'=(`var'-r(mean))/r(sd)
}

*(10) Output list of lasso-ready controls
unab var_p: _*	
return local var_prepped `var_p'
foreach var of varlist _* {
	rename `var' cl`var'
}
end


	
