*Downloading STATA dataset in .csv format and STATA program file in .do format from IPEDS website for year 1980, we get the STATA dataset in .dta format saved as "dct_sal1980_a.dta"

clear all
use "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980\dct_sal1980_a.dta"
cd "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980"

*Organize & inspect data

tabulate arank

*Drop non-essential variables
drop tenm
drop tenw
drop conm
drop conw

*Reshape dataset from long to wide to distribute arank (academic rank) to each variables

reshape wide numm salm numw salw, i(unitid) j(arank)

*Reshape dataset from wide to long to add arank as a variable for academic rank and w or m as variables for sex

reshape long num sal m w, i(unitid) j(arank) string

*Clean invalid data

drop w m

*Generate sex_num as variable for sex. sex_num = 1 for men, sex_num = 2 for women

gen sex_num = 1 if strpos(arank, "m")
replace sex_num = 2 if strpos(arank, "w")
label variable sex_num "Sex"

*Destring "arank" and add "arank_num" as the numeric variable for "arank". Generate "rank_num" as variable for academic rank. rank_num = 1 for professors; rank_num = 2 for associate professors; rank_num = 3 for assistant professors; rank_num = 4 for instructors; rank_num = 5 for lecturers; rank_num = 6 for no academic rank; rank_num = 7 for totals.

*Note: on the codebook for 1980, code value 14 in "arank" defines "12-month contracts: professors 12month contracts: associate professors" which seems to be typo. The destring process illustrated beblow is under the assumption that code value 14 in "arank" only defines "12-month contracts: professors".

gen arank_num = substr(arank, 2, .)
destring arank_num, replace
gen rank_num = 1 if arank_num == 1 | arank_num == 8
replace rank_num = 2 if arank_num == 2 | arank_num == 9
replace rank_num = 3 if arank_num == 3 | arank_num == 10
replace rank_num = 4 if arank_num == 4 | arank_num == 11
replace rank_num = 5 if arank_num == 5 | arank_num == 12
replace rank_num = 6 if arank_num == 6 | arank_num == 13
replace rank_num = 7 if arank_num == 7 | arank_num == 14
label variable rank_num "Academic Rank"

*Generate "contract" as variable for contract length. contract = 1 for 9/10 month contract, contract = 2 for 11/12 month contract.

gen contract = 1 if arank_num <= 7
replace contract = 2 if arank_num > 7
label variable contract "Contract Length"

*Generate "saverage" as variable for average salary; round average salary to the nearest 1.

gen saverage = sal/num
label variable saverage "Average Salary"
replace saverage = round(saverage, 1)

*Rename some variables for consistency among data files from different years; label new variables

rename num empcount
label variable empcount "Number of Stuff"
rename sal outlays
label variable outlays "Total Salary Outlays"

*Generate a new variable "year" to identify which dataset this is from when appending files from different years

gen year = 1980
label variable year Year

*Save cleaned data as "1980_cleaned.dta"

save 1980_cleaned






