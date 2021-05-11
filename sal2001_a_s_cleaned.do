*Downloading STATA dataset in .csv format and STATA program file in .do format from IPEDS website for year 2001, we get the STATA dataset in .dta format saved as "dct_sal2001_a_s"

use "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\2001\dct_sal2001_a_s.dta" 
cd "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\2001"

*Drop non-essential variables/entries

drop xempcoun
drop xoutlays
drop xsaverag

*Generate "sex_num" as the new variable for sex. sex_num = 1 for male; sex_num = 2 for female.

gen sex_num = 1 if arank <= 7
replace sex_num = 2 if arank >= 8 & arank != 15
label variable sex_num "Sex"

*Generate "rank_num" as the new variable for academic rank. rank_num = 1 for 9/10 month professors and/or 11/12 month professor/associate professors; rank_num = 2 for associate professors; rank_num = 3 for assistant professors; rank_num = 4 for instructors; rank_num = 5 for lecturers; rank_num = 6 for no academic rank; rank_num = 7 for totals (men or women only); rank_num = 8 for totals (men and women all together).

gen rank_num = 1 if arank == 1 | arank == 8
replace rank_num = 2 if arank == 2 | arank == 9
replace rank_num = 3 if arank == 3 | arank == 10
replace rank_num = 4 if arank == 4 | arank == 11
replace rank_num = 5 if arank == 5 | arank == 12
replace rank_num = 6 if arank == 6 | arank == 13
replace rank_num = 7 if arank == 7 | arank == 14
replace rank_num = 8 if arank == 15
label variable rank_num "Academic Rank"

*Label all variables for consistency among files from other years

label variable contract "Contract Length"
label variable arank "Academic Rank"
label variable empcount "Number of Staff"
label variable outlays "Total Salary Outlays"
label variable saverage "Average Salary"

*Generate a new variable "year" to identify which dataset this is from when appending files from different years

gen year = 2001
label variable year Year

*Save cleaned data as "2001_cleaned.dta"

save 2001_cleaned



