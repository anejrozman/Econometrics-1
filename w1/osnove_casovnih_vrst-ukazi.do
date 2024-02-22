* a) Pregled podatkov

describe
inspect spr
sum spr, detail
tabstat spr, stat(N mean sd median sum min max)
list

* b) Opredelitev casovne dimenzije in generiranje periodicnih komponent

tsset kvartal

sort spr
sort kvartal

order kvartal, last
order kvartal, first

gen t=_n

gen q=quarter(dofq(kvartal))
tabulate q, gen(d)

list kvartal spr q d1-d4
drop q

gen t2=t^2
gen t3=t^3
list

keep kvartal spr

* c) Generiranje neprave spremenljivke

sum spr, detail
return list

gen d=0
replace d=1 if spr>=0.8*r(p50) | spr<(2/3)*r(mean)

tab d
drop d

* d) Generiranje odlozenih in vodecih spremenljivk

sort kvartal

gen spr_lag1=l.spr
gen spr_lag4=l4.spr
gen spr_lead2=f2.spr
gen spr_diff1=d.spr
list

clear all
