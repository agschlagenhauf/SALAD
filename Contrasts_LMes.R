# Mixed effects models: specifying contrasts

# see Paper Schad et al. (2020): 
# Schad DJ, Vasishth S, Hohenstein S, Kliegl R. How to capitalize on a priori contrasts in linear (mixed) 
# models: A tutorial. J Mem Lang. 2020;110. 

# Example Factor "Cue" in Impact2 with 3 levels (CSpp CSm CSp)

# [1 ]treatment coding with CS- as baseline conditioning
# beta estimates represents difference CSpp - CSm or CSp - CSm
# intercept represents mean for CS-
# IMPORTANT: interpretation of other main effects: effect evaluated at zero for the other contrasts, as
# treatment contrast does not sum to zero!
# for other contrasts that sum to zero: main effect represents effect of factor over the mean of the other
# factor levels, as is the classical ANVOA interpretation; but this is only so if we include interactions

contrasts(cond$mrk) = contr.treatment(3, base = 2)


# [2] sum contrast
# estimates reflect deviation form grand mean; intercept represents grand mean, i.e. mean of all three conditions
contrasts(cond$mrk) <-cbind(c1=c(0.5, -0.5, 0), 
                            c2=c(0, -0.5, 0.5))

contrasts(cond$mrk) <-cbind(c1=c(1, -1, 0), 
                            c2=c(0, -1, 1))       
# interesting: this also changes the correlation between the predictors; now, no main effect of trial

# repeated contrasts
# code difference between level 2 and 1,  3 and 2, ...
# available in MASS package

contr.sdif(3)

# polynomial contrasts
# can test for linear or quadratic trend
# fist column test linear increase, the second a quadratic trend
contr.poly(3)


# Helmert contrast for conditioning: first: test difference between Factor 1 and 2, then test difference
# between mean of Factor 1+2 and Factor 3
# would make sense for conditioning in IMPACT2
contr.helmert(3)



# test of hypr Package from Schad et al. to do costumn contrasts

library(hypr)


# Example: create standard treatment contrast (3 levels: placebo condition, treatment 1, treatment 2) 

trtC <- hypr(baseline~0, trt1~baseline, trt2~baseline) 
trtC

# example 2: derive hypothesis matrix from a given contrast to check what this coding is really testing:
# ! if model includes intercept, the intercept has to be added!

treatC <- hypr()
cmat(treatC) <- cbind(int=1, contr.treatment(c("baseline","trt1","trt2")))
treatC

contr.hypothesis(trtC)

# test sum contrast with 3 factors

sumC<-hypr()
cmat(sumC)<-cbind(int=1, contr.sum(3))
sumC
# H1: grand mean=0
# H2: mu1 = grand mean
# H3: mu2=grand mean


trtC <- hypr(X1~1/3*X1 + 1/3*X2 + 1/3*X3, X1~X2, X1~X3) 

volatContrast <- hypr(X1~X2, X1~X3) 
volatContrast

