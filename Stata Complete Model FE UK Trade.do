clear					
set linesize 255	

* set global path if needed
* global path 

* Start log
log using "${path}/log/trade_log.log", replace 


*************************************************************
*						Open data set						*
*************************************************************


use "Data Final Pop.dta"

* Panel data - fixed effects model for Seminar paper "Empirical Trade: Is there a soft power premium on trade? Evidence from the UK"

**************** Data Cleaning and Preparation ****************
* Encode strings into int alternatives
encode Country, gen(country1)
encode Industry, gen(industry1)
* Country Industry ID
egen CoInID = group(Country Industry)
*encode Year, gen(year1)
* Destring several variables, replace them
destring Soft_Power30, replace
destring Soft_PowerUK, replace
destring Country, replace
destring Year, replace
* drop column names from excel file
drop A*
drop K L M N O P Q R S T U V W X Y Z
* install test for heteroscedasticity
*ssc install xttest
* add positive constant one to help with logarithm 
gen Export_UK_add = Export_UK + 1 
* turn other variables into logarithm
* no distance as it is time invariant
gen log_Export_UK = log(Export_UK_add)
gen log_SP30 = log(Soft_Power30)
gen log_SPUK = log(Soft_PowerUK)
gen log_GDP = log(GDPcapita)
gen log_POP = log(Population)
gen log_TO = log(Turnover)
gen log_EM = log(Employment)
gen SP_frac = (log_SP30/log_SPUK)
************************** Summary Statistics 
summarize log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM SP_frac
************************** Estimation ****************
**************************
* Pooled OLS with robust standard errors (allow for intra-group correlation between Country-Industry)
regress log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM, vce (cluster CoInID)
estimates store POLS

* Fixed Effects. ID = Country-Industry based ID, time = Year; time dummy (Woolridge 2010, p.301-302). VCE cluster: Allow for intra-group correlation between Country-Industry)

* No difference between xtset CoInID Year and xtset CoInID
xtset CoInID Year
* Entity FE
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM, fe
estimates store FE_Entity_No_VCE
* test for heteroscedasticity (Is present as p=0.00, HO: Homoscedasticity)
*ssc install xttest3
xttest3
estimates store het_error_test
* homoscedasticity rejected by Wald test (p of chi2 = 0.00)

* Same with SP_frac
* Entity FE
xtreg log_Export_UK SP_frac log_GDP log_POP log_TO log_EM, fe
estimates store FE_Entityfrac_No_VCE
xttest3
estimates store het_error_test

* VCE robust for SP and SP_frac
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM, fe vce(cluster CoInID)
estimates store FE_Entity
xtreg log_Export_UK SP_frac log_GDP log_POP log_TO log_EM, fe vce(cluster CoInID)
estimates store FE_Entityfrac

* Entity and Time FE 
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM i.Year, fe vce(cluster CoInID)
estimates store FE_Entity_Time

* Test whether Time FE are needed (p= 0.5592, Year is not significant -> Use Entity FE only)
testparm i.Year
estimates store Test_Time

* Entity and Time FE with SP frac
xtreg log_Export_UK SP_frac log_GDP log_POP log_TO log_EM i.Year, fe vce(cluster CoInID)
estimates store FE_Entity_Time_SPfrac

* Test whether Time FE are needed -> 
testparm i.Year
estimates store Test_Time_frac
* Effects stay similar; the SPUK effect is not significant after controlling for Years. All other stay significant and relatively close to Entity FE 

* Equivalent LSDV: Entity Fixed effect with interaction; industry-country dummies include
regress log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM i.CoInID, vce(cluster CoInID)
estimates store LSDV 

* run Random Effect (RE) for Hausmann test 
* no vce(cluster) for RE because hausman test cannot be used with it
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM, re 
estimates store RE_Entity_No_VCE
hausman FE_Entity_No_VCE RE_Entity_No_VCE
estimates store Hausman_test

xtreg log_Export_UK SP_frac log_GDP log_POP log_TO log_EM, fe
estimates store FE_Entity_No_VCE_frac
xtreg log_Export_UK SP_frac log_GDP log_POP log_TO log_EM, re 
estimates store RE_Entity_No_VCE_frac
hausman FE_Entity_No_VCE_frac RE_Entity_No_VCE_frac
estimates store Hausman_test_frac
* GET Ride of Industry variation
*get rid of industry variables, sum their UK exports based upon Country-Year 
collapse (sum) log_Export_UK log_TO log_EM, by(log_SP30 log_SPUK log_GDP log_POP Year country1)
* Entity FE (NO Industry) ID = Country
xtset country1
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM,fe vce(cluster country1)
est store FE_Entity_No_Industry
* Entity Time FE ; ID = Country
xtreg log_Export_UK log_SP30 log_SPUK log_GDP log_POP log_TO log_EM i.Year,fe vce(cluster country1)
testparm i.Year
estimates store Test_Time
* also cannot reject F test for effect of Year 
est store fixed_entitytime_noind
*Estab output of Coefficients From POLS, FE, FE frac (ID and ID+Time) and LSDV 
esttab POLS FE_Entity FE_Entityfrac FE_Entity_Time FE_Entity_Time_SPfrac, title(POLS, Fixed Effect and LSDV models) nonumbers mtitles("POLS" "FE (ID)" "FE Frac (ID)" "FE (ID+T)" "FE Frac (ID+T)") star(* 0.10 ** 0.05 *** 0.01)
*************************************************
*						End 					*
*************************************************
log close 






