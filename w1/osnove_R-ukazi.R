# Nalaganje knjiznic in podatkov

library(ggplot2)
library(Hmisc)
library(mosaic)
library(pastecs)
library(psych)

osnove_R = readRDS("osnove_R.rds")

# a) Pregled podatkov

sapply(osnove_R,class)

psych::describe(osnove_R[,-c(1)], type=1)
psych::describe(osnove_R$y, type=1)

Hmisc::describe(osnove_R$y)

quantile(osnove_R$y, c(.01, .05, .1, .25, .5, .75, .9, .95, .99))

desc=stat.desc(osnove_R[, -c(1)])
round(desc, 2)

freq=table(osnove_R$y, exclude=NULL)
percent=prop.table(freq)*100
cum=cumsum(percent)
cbind(freq,percent,cum)

osnove_R[,2:5]
osnove_R[4:8,2:5]
osnove_R[osnove_R$x2>=0,3:4]

# b) Diagrami v R

par(mar = c(4, 4, 1, 1))
plot(osnove_R$x2, osnove_R$y)
plot(osnove_R$x2, osnove_R$y, col="blue", xlab=label(osnove_R$x2), ylab=label(osnove_R$y), pch=16)

plot(osnove_R$obs, osnove_R$y, col="blue", xlab=label(osnove_R$obs), ylab=label(osnove_R$y), pch=16)

ts_plot = ggplot(osnove_R, aes(x = .data$obs, y = .data$y)) + geom_line() + labs(x=label(osnove_R$obs), y=label(osnove_R$y))
plot(ts_plot)

h = hist(osnove_R$x2, freq=FALSE)

x = osnove_R$x2
h = hist(x, breaks=4, col="light grey", xlab=label(osnove_R$x2), main="Histogram with Normal Curve", freq=FALSE) 
xfit = seq(min(x), max(x), length=length(x)) 
yfit = dnorm(xfit, mean=mean(x), sd=sd(x)) 
lines(xfit, yfit, col="red", lwd=2)

# c) Generiranje novih spremenljivk

osnove_R$yx2=100*osnove_R$y*osnove_R$x2
osnove_R$x2sq=osnove_R$x2^2
osnove_R$x2a=abs(osnove_R$x2)
osnove_R$lx2=log(osnove_R$x2)
osnove_R$ex2=exp(osnove_R$lx2)
osnove_R[, -c(1)]

osnove_R$lx2[is.na(osnove_R$lx2)] = 0
osnove_R$lx2[which(osnove_R$lx2==-Inf)] = 0

osnove_R$x2s=zscore(osnove_R$x2) 
osnove_R[, -c(1)]

osnove_R$yx2 = NULL
osnove_R$x2sq = NULL
osnove_R$x2a = NULL
osnove_R$lx2 = NULL
osnove_R$ex2 = NULL
osnove_R$x2s = NULL

# d) Priklic podatkov iz okolja R

psych::describe(osnove_R[,-c(1)], type=1)
tab_describe = psych::describe(osnove_R[,-c(1)], type=1)
str(tab_describe)

mean_y = tab_describe$mean[1]
median_x3 = tab_describe$median[4]
mean_y; median_x3

regression = lm(y ~ x2 + x3, data = osnove_R)
summary(regression)
summary_regression = summary(regression)
str(summary_regression)

regression_r2 = summary_regression$r.squared
regression_r2

regression_varcov = tril(vcov(regression))
regression_varcov

regression_varcov33 = regression_varcov[3,3]
regression_varcov33

# e) Kovariance in korelacija

df = data.frame(osnove_R)[, -c(1,3)]

cov(df)
cor(df)
rcorr(as.matrix(df))
