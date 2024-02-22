# Nalaganje knjiznic in podatkov

library(data.table)
library(dint)
library(fastDummies)
library(Hmisc)
library(psych)

osnove_casovnih_vrst = readRDS("osnove_casovnih_vrst.rds")

# a) Pregled podatkov

sapply(osnove_casovnih_vrst,class)

psych::describe(osnove_casovnih_vrst$spr, type=1)
Hmisc::describe(osnove_casovnih_vrst$spr)

osnove_casovnih_vrst

# b) Opredelitev casovne dimenzije in generiranje periodicnih komponent

osnove_casovnih_vrst$kvartal = seq(as.Date("1950/1/1"), as.Date("2000/12/1"), by="quarter")
spr = ts(osnove_casovnih_vrst$spr, start = c(1950,1,1), frequency=4)

osnove_casovnih_vrst = osnove_casovnih_vrst[order(osnove_casovnih_vrst$kvartal),]

osnove_casovnih_vrst = osnove_casovnih_vrst[, c(2,1)]
colnames(osnove_casovnih_vrst)
osnove_casovnih_vrst = osnove_casovnih_vrst[, c(2,1)]
colnames(osnove_casovnih_vrst)

osnove_casovnih_vrst$t = seq_along(osnove_casovnih_vrst$spr)

osnove_casovnih_vrst$q = get_quarter(osnove_casovnih_vrst$kvartal)
osnove_casovnih_vrst$d = dummy_cols(osnove_casovnih_vrst$q)

osnove_casovnih_vrst[, c(1,2,4,5)]
osnove_casovnih_vrst$q = NULL

osnove_casovnih_vrst$t2 = osnove_casovnih_vrst$t^2
osnove_casovnih_vrst$t3 = osnove_casovnih_vrst$t^3

osnove_casovnih_vrst[1:12,]

osnove_casovnih_vrst = osnove_casovnih_vrst[, c(1,2)]
colnames(osnove_casovnih_vrst)

# c) Generiranje neprave spremenljivke

psych::describe(osnove_casovnih_vrst$spr, type=1)
mean_spr = psych::describe(osnove_casovnih_vrst$spr, type=1)$mean
median_spr = psych::describe(osnove_casovnih_vrst$spr, type=1)$median
mean_spr; median_spr

osnove_casovnih_vrst$d = 0
osnove_casovnih_vrst$d[which(osnove_casovnih_vrst$spr>=0.8*median_spr | osnove_casovnih_vrst$spr<(2/3)*mean_spr)] = 1

freq=table(osnove_casovnih_vrst$d, exclude=NULL)
percent=prop.table(freq)*100
cum=cumsum(percent)
cbind(freq,percent,cum)

osnove_casovnih_vrst$d = NULL

# d) Generiranje odlozenih in vodecih spremenljivk

osnove_casovnih_vrst$spr_lag1 = shift(osnove_casovnih_vrst$spr, n=1, type=c("lag"))
osnove_casovnih_vrst$spr_lag4 = shift(osnove_casovnih_vrst$spr, n=4, type=c("lag"))

osnove_casovnih_vrst$spr_lead2 = shift(osnove_casovnih_vrst$spr, n=2, type=c("lead"))

osnove_casovnih_vrst$spr_diff1 = osnove_casovnih_vrst$spr - osnove_casovnih_vrst$spr_lag1

osnove_casovnih_vrst[1:10,]
osnove_casovnih_vrst[195:204,]
