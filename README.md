# Trade_Seminar_SoftPower
This is my work done for my seminar paper "Is there a soft power premium on trade? Evidence from the UK".

For the seminar "Advanced International Trade: Empirical Applications" I investigated the effect of soft power between the UK and Germany, Russia, the USA, China, and France, respectively.
The exports of the UK into the five countries were studied for the years 2015-2019. Feel free to reach out to me for the seminar paper if you are interested. 

## Data
The Soft Power 30 index is sourced from yearly reports spanning 2015-2019 (McClory 2019).

The country and industry-based data consists of the GDP per capita and population for the former and the UK exports and their respective number of employees and turnover for the industries. The 2015-2019 data from the UK exports is based on the country-by-commodity data (current prices- non-season- ally adjusted) from the Office for National Statistics (ONS). Before the transformation of export data, a 1 was added to the exports to allow for application of the logarithm on zeros. The changes in output are minuscule.
The turnover and employment per industry is based on the Business population estimate (BPE) for the respective years. 
As the export data is based on the Standard International Trade Classification (SITC) and the latter on the Standard Industrial Classification (SIC) for the UK, 
they were harmonized by hand. This was necessary because it was not feasible to translate either the SITC into the SIC divisions or vice versa without 
severe overlaps of several categories. The new industries were established to encompass the similar categories of the SIC and SITC under one umbrella term.

The main data is in the "Data Final Pop.dta" file. 
"SoftPower Data Graph.xlsx" was used to provide a box plot/line plot with seaborn using the added Python file.



## Methodology
The data was analysed using a Fixed-Effects model within the established framework of the Gravity equation in international trade. 
I used STATA for the data cleaning, exploration and the econometrics. 
<img src="https://github.com/favicon.ico" width="48">

### Models used:
<img src="FE Model 1 Trade.png" width="750" height="250">
<img src="FE Model 2 Trade.png" width="750" height="250">
