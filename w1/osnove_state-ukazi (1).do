* a) Pregled podatkov

describe
inspect y x1 x2 x3
sum y x1 x2 x3
sum y, detail

tabstat y x1 x2 x3, stat(N mean sd median sum min max)
tab y
tab y x3

list
list, N mean sum
list in 4/8
list x1 x2 if x2>=0

* b) Diagrami v Stati

twoway scatter y x2

twoway scatter y obs
twoway connected y obs
twoway line y obs

hist x2
hist x2, bin(5) normal

* c) Generiranje novih spremenljivk

gen yx2=100*y*x2
gen x2kv=x2^2
gen x2a=abs(x2)
gen lx2=log(x2)
gen ex2=exp(lx2)
list

replace lx2=0 if lx2==.
list lx2

egen x2s=std(x2) 
list

drop yx2 x2kv x2a lx2 ex2 x2s

* d) Priklic podatkov iz Statinega spomina

sum y
return list

regress y x2 x3
ereturn list

scalar r2=e(r2)
display r2

matrix varcov=e(V)
matrix list varcov

scalar varcov22=varcov[2,2]
display varcov22

* e) Kovariance in korelacija

correlate y x2 x3, covariance

correlate y x2 x3
pwcorr y x2 x3, sig

clear all
