*Using cleaned data file from 1980 as the base, append other cleaned data files from 1990 and 2001

clear all
use "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980 - 2001\1980_cleaned.dta"
append using "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980 - 2001\1990_cleaned.dta" "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980 - 2001\2001_cleaned.dta", keep(unitid empcount outlays sex_num rank_num contract saverage year)

*Drop non-essential variables which were used to organize/clean datasets from the base data file.

drop arank arank_num

*Reorder variables

order unitid rank_num contract sex_num outlays empcount saverage, first

*Drop non-essential data points

keep if unitid == 101161 | unitid == 101189 | unitid == 101240 | unitid == 101286 | unitid ==159373 | unitid == 159391 | unitid == 200226 | unitid == 201104 | unitid == 236656 | unitid ==239008

*Save appended file as "1990-2001_appended.dta"

save 1990-2001_appended

*Save appended file as "1990-2001_appended.csv"

export delimited using "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1980 - 2001\1980-2001_appended.csv", replace
