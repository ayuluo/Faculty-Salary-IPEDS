*Downloading STATA dataset in .csv format and STATA program file in .do format from IPEDS website for year 1990, we get the STATA dataset in .dta format saved as "dct_sal90_a"

clear all
use "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1990\dct_sal90_a.dta" 
cd "C:\Users\Sivan Luo\Documents\STATA data\Urban Institute_Research Analyst Data Exercise\Data\1990"

*Drop non-essential variables

drop impa4-impa155
drop a1-a3
drop a6-a8
drop a11-a13
drop a16-a18
drop a21-a23
drop a26-a28
drop a31-a33
drop a36-a38
drop a41-a43
drop a46-a48
drop a51-a53
drop a56-a58
drop a61-a63
drop a66-a68
drop a71-a73
drop a76-a78
drop a81-a83
drop a86-a88
drop a91-a93
drop a96-a98
drop a101-a103
drop a106-a108
drop a111-a113
drop a116-a118
drop a121-a123
drop a126-a128
drop a131-a133
drop a136-a138
drop a141-a143
drop a146-a148
drop a151-a153

*Rename remaining variables by the group they belong to: 
*"numm" for number of staff for men; "numw" for number of staff for women
*"salm" for salary outlays for men; "salw" for salary outlays for women
*1 for professors on 9/10 month contract; 2 for associate professors on 9/10 month contract; 
*3 for assistant professors on 9/10 month contract; 4 for instructors on 9/10 month contract; 
*5 for lecturers on 9/10 month contract; 6 for no academic rank on 9/10 month contract; 
*7 for totals (men or women) on 9/10 month contract; 8 for totals (men and women all together) on 9/10 month contract;
*9 for professors on 11/12 month contract; 10 for associate professors on 11/12 month contract;
*11 for assistant professors on 11/12 month contract; 12 for instructors on 11/12 month contract;
*13 for lecturers on 11/12 month contract; 14 for no academic rank on 11/12 month contract; 
*15 for totals (men or women) on 11/12 month contract; 16 for totals (men and women all together) on 11/12 month contract;
*17 for totals (men and women) on less-than 9/10 month contract.

rename a4 numm1
rename a5 salm1
rename a9 numm2
rename a10 salm2
rename a14 numm3
rename a15 salm3
rename a19 numm4
rename a20 salm4
rename a24 numm5
rename a25 salm5
rename a29 numm6
rename a30 salm6
rename a34 numm7
rename a35 salm7

rename a39 numw1
rename a40 salw1
rename a44 numw2
rename a45 salw2
rename a49 numw3
rename a50 salw3
rename a54 numw4
rename a55 salw4
rename a59 numw5
rename a60 salw5
rename a64 numw6
rename a65 salw6
rename a69 numw7
rename a70 salw7

rename a74 num8
rename a75 sal8

rename a79 numm9
rename a80 salm9
rename a84 numm10
rename a85 salm10
rename a89 numm11
rename a90 salm11
rename a94 numm12
rename a95 salm12
rename a99 numm13
rename a100 salm13
rename a104 numm14
rename a105 salm14
rename a109 numm15
rename a110 salm15

rename a114 numw9
rename a115 salw9
rename a119 numw10
rename a120 salw10
rename a124 numw11
rename a125 salw11
rename a129 numw12
rename a130 salw12
rename a134 numw13
rename a135 salw13
rename a139 numw14
rename a140 salw14
rename a144 numw15
rename a145 salw15

rename a149 num16
rename a150 sal16

rename a154 num17
rename a155 sal17

*Reshape dataset from wide to long

reshape long num sal m w, i(unitid) j(arank) string

*Drop invalid data points

drop m w

*Generate variable "sex_num" for sex. sex_num = 1 for men; sex_num = 2 for women

gen sex_num = 1 if strpos(arank, "m")
replace sex_num = 2 if strpos(arank, "w")
label variable sex_num "Sex"

*Destring "arank" and add "arank_num" as the numeric variable for "arank". Generate "rank_num" as variable for academic rank. rank_num = 1 for professors; rank_num = 2 for associate professors; rank_num = 3 for assistant professors; rank_num = 4 for instructors; rank_num = 5 for lecturers; rank_num = 6 for no academic rank; rank_num = 7 for totals (men or women); rank_num = 8 for totals (men and women all together).

destring arank, gen(arank_num) i(m w)
gen rank_num = 1 if arank_num == 1 | arank_num == 9
replace rank_num = 2 if arank_num == 2 | arank_num == 10
replace rank_num = 3 if arank_num == 3 | arank_num == 11
replace rank_num = 4 if arank_num == 4 | arank_num == 12
replace rank_num = 5 if arank_num == 5 | arank_num == 13
replace rank_num = 6 if arank_num == 6 | arank_num == 14
replace rank_num = 7 if arank_num == 7 | arank_num == 15
replace rank_num = 8 if arank_num == 8 | arank_num == 16
label variable rank_num "Academic Rank"

*Generate "contract" as variable for contract length. contract = 1 for 9/10 month contract, contract = 2 for 11/12 month contract, contract = 3 for less-than 9/10 month contract. 

gen contract = 1 if arank_num <= 8
replace contract = 2 if arank_num > 8 & arank_num <= 16
replace contract = 3 if arank_num == 17
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

gen year = 1990
label variable year Year

*Save cleaned data as "1990_cleaned.dta"

save 1990_cleaned.dta
