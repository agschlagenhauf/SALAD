## ----setup, include = FALSE, echo=FALSE----------------------------------
library(MASS)
library(knitr)
library(xtable)
library(papaja)
#library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)
#library(sjPlot)
library(png)

theme_set(theme_apa())

# load mixedDesign function for simulating data
source("functions/mixedDesign.v0.6.3.R")

# set global chunk options, put figures into folder
options(warn=-1, replace.assign=TRUE)
opts_chunk$set(fig.path='figures/figure-', fig.align='center', fig.show='hold')
options(replace.assign=TRUE,width=75)
opts_chunk$set(dev='postscript')


## ----Flow, fig.height=3, fig.width=3, fig.cap="Conceptual and didactic flow. The left panel, conceptual flow, shows how to use the hypothesis matrix and the generalized inverse to construct custom contrast matrices for a given set of hypotheses. The right panel, didactic flow, shows an overview of the sections of this paper. The first grey box indicates the sections that introduce a set of default contrasts (treatment, sum, repeated, polynomial, and custom contrasts); the second grey box indicates sections that introduce contrasts for designs with two factors.", fig.align="center"----
#library(png)
knitr::include_graphics("figures/Figure1_Flow.png", dpi = 20)


## ---- echo=TRUE----------------------------------------------------------
library(dplyr)
M <- matrix(c(0.8, 0.4), nrow=2, ncol=1, byrow=FALSE)
set.seed(1) # set seed of random number generator for replicability
simdat <- mixedDesign(B=2, W=NULL, n=5, M=M,  SD=.20, long = TRUE) 
names(simdat)[1] <- "F"  # Rename B_A to F(actor)
levels(simdat$F) <- c("F1", "F2")
simdat
str(simdat)
table1 <- simdat %>% group_by(F) %>% # Table for main effect F
   summarize(N=n(), M=mean(DV), SD=sd(DV), SE=SD/sqrt(N) )
(GM <-  mean(table1$M)) # Grand Mean


## ----Fig1Means, fig=TRUE, include=TRUE, echo=FALSE, cache=FALSE, fig.width=4, fig.height=3.6, fig.cap = "Means and standard errors of the simulated dependent variable (e.g., response times in seconds) in two conditions F1 and F2."----
(plot1 <- qplot(x=F, y=M, group=1, data=table1, geom=c("point", "line")) + 
	 geom_errorbar(aes(max=M+SE, min=M-SE), width=0) + 
   #scale_y_continuous(breaks=c(250,275,300)) + 
   scale_y_continuous(breaks=seq(0,1,.2)) + coord_cartesian(ylim=c(0,1)) + 
   labs(y="Mean Response Time [sec]", x="Factor F") +
   theme_apa())


## ----table1a, include=TRUE, echo=FALSE-----------------------------------
table1a <- table1
names(table1a) <- c("Factor F","N data points","Estimated means","Standard deviations","Standard errors")


## ----table1, results = "asis"--------------------------------------------
apa_table(table1a, placement="b", digits=1, 
    caption="Summary statistics per condition for the simulated data.")


## ----fitmodel, echo=TRUE-------------------------------------------------
m_F <- lm(DV ~ F, simdat)
round(summary(m_F)$coef,3)


## ----table2, results = "asis"--------------------------------------------
apa_table(apa_print(m_F, digits=1, est_name="Estimate")$table, placement="h",
    caption="Estimated regression model. Confidence intervals are obtained in R, e.g., using the function confint().")


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat$F)


## ---- echo=TRUE----------------------------------------------------------
simdat$Fb <- factor(simdat$F,  levels = c("F2","F1"))
contrasts(simdat$Fb)


## ---- echo=TRUE----------------------------------------------------------
m1_mr <- lm(DV ~ Fb, simdat)


## ----table4, results = "asis"--------------------------------------------
apa_table(apa_print(m1_mr, digits=1, est_name="Estimate")$table, caption="Reordering factor levels", placement="h")


## ---- echo=TRUE----------------------------------------------------------
(contrasts(simdat$F) <- c(-0.5,+0.5))
m1_mr <- lm(DV ~ F, simdat)


## ----table5, results = "asis"--------------------------------------------
apa_table(apa_print(m1_mr, digits=1, est_name="Estimate")$table, caption="Estimated regression model", placement="h")


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat$F)


## ---- echo=TRUE----------------------------------------------------------
m2_mr <- lm(DV ~ -1 + F, simdat)


## ----table2a, results = "asis"-------------------------------------------
apa_table(apa_print(m2_mr, digits=1, est_name="Estimate")$table, caption="Estimated regression model", placement="h")


## ---- echo=TRUE----------------------------------------------------------
contr.treatment(3)


## ---- echo=TRUE----------------------------------------------------------
contr.sum(3)


## ---- echo=TRUE----------------------------------------------------------
library(MASS)
contr.sdif(3)


## ---- echo=TRUE----------------------------------------------------------
contr.poly(3)


## ---- echo=TRUE----------------------------------------------------------
contr.helmert(3)


## ---- eval=FALSE, echo=TRUE----------------------------------------------
## contrasts(dat$WordFrequency) <- contr.sdif(3)


## ---- eval=FALSE, echo=TRUE----------------------------------------------
## lm(DV ~ WordFrequency, data=dat)


## ---- echo=TRUE----------------------------------------------------------
M <- matrix(c(500, 450, 400), nrow=3, ncol=1, byrow=FALSE)
set.seed(1)
simdat2 <- mixedDesign(B=3, W=NULL, n=4, M=M,  SD=20, long = TRUE) 
names(simdat2)[1] <- "F"  # Rename B_A to F(actor)/F(requency)
levels(simdat2$F) <- c("low", "medium", "high")
simdat2$DV<-round(simdat2$DV)
head(simdat2)
table.word <- simdat2 %>% group_by(F) %>% 
  summarise(N = length(DV), M = mean(DV), SD = sd(DV), SE = sd(DV)/sqrt(N))


## ----table6a, include=TRUE, echo=FALSE-----------------------------------
table.word1 <- table.word
names(table.word1) <- c("Factor F","N data points","Estimated means","Standard deviations","Standard errors")


## ----table6, results = "asis"--------------------------------------------
apa_table(table.word1, placement="h", format.args=list(digits=0),
    caption="Summary statistics of the simulated lexical decision data per frequency level.")


## ---- echo=TRUE----------------------------------------------------------
aovF <- aov(DV ~ F + Error(id), data=simdat2)


## ----table7, results = "asis"--------------------------------------------
apa_table(apa_print(aovF)$table, placement="h", 
    caption="ANOVA results. The effect F stands for the word frequency factor.")


## ---- echo=TRUE----------------------------------------------------------
HcSum <- rbind(cH00=c(low= 1/3, med= 1/3, hi= 1/3), 
               cH01=c(low=+2/3, med=-1/3, hi=-1/3), 
               cH02=c(low=-1/3, med=+2/3, hi=-1/3))
fractions(t(HcSum))


## ---- echo=TRUE----------------------------------------------------------
ginv2 <- function(x) # define a function to make the output nicer
  fractions(provideDimnames(ginv(x),base=dimnames(x)[2:1]))


## ---- echo=TRUE----------------------------------------------------------
(XcSum <- ginv2(HcSum))


## ---- echo=TRUE----------------------------------------------------------
fractions(cbind(1,contr.sum(3)))


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat2$F) <- XcSum[,2:3]
m1_mr <- lm(DV ~ F, data=simdat2)


## ----table8, results="asis"----------------------------------------------
apa_table(apa_print(m1_mr, digits=0, est_name="Estimate")$table, 
    placement="h",
    caption="Regression model using the sum contrast.")


## ---- echo=TRUE----------------------------------------------------------
# Data, means, and figure
M <- matrix(c(10, 20, 10, 40), nrow=4, ncol=1, byrow=FALSE)
set.seed(1)
simdat3 <- mixedDesign(B=4, W=NULL, n=5, M=M,  SD=10, long = TRUE) 
names(simdat3)[1] <- "F"  # Rename B_A to F(actor)
levels(simdat3$F) <- c("F1", "F2", "F3", "F4")
table3 <- simdat3 %>% group_by(F) %>% 
   summarize(N=length(DV), M=mean(DV), SD=sd(DV), SE=SD/sqrt(N) )
(GM <-  mean(table3$M)) # Grand Mean


## ----helmertsimdatTab1, include=TRUE, echo=FALSE-------------------------
table3a <- table3
names(table3a) <- c("Factor F","N data points","Estimated means","Standard deviations","Standard errors")


## ----helmertsimdatTab, results="asis"------------------------------------
apa_table(table3a, placement="h", digits=1,
  caption="Summary statistics for simulated data with one between-subjects factor with four levels.")


## ----helmertsimdatFig, fig=TRUE, include=TRUE, echo=FALSE, cache=FALSE, fig.width=4.7, fig.height=3.4, fig.cap = "Means and error bars (showing standard errors) for a simulated data-set with one between-subjects factor with four levels."----
(plot2 <- qplot(x=F, y=M, group=1, data=table3, geom=c("point", "line")) + 
	 geom_errorbar(aes(max=M+SE, min=M-SE), width=0) + 
   #scale_y_continuous(breaks=c(250,275,300)) + 
   labs(y="Mean DV", x="Factor F") +
   theme_apa())


## ---- echo=TRUE----------------------------------------------------------
t(HcSD <- rbind(c2vs1=c(F1=-1,F2=+1,F3= 0,F4= 0),
                c3vs2=c(F1= 0,F2=-1,F3=+1,F4= 0),
                c4vs3=c(F1= 0,F2= 0,F3=-1,F4=+1)))


## ---- echo=TRUE----------------------------------------------------------
(XcSD <- ginv2(HcSD))


## ---- echo=TRUE----------------------------------------------------------
fractions(contr.sdif(4))


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat3$F) <- XcSD
m2_mr <- lm(DV ~ F, data=simdat3)


## ----table0, results="asis"----------------------------------------------
apa_table(apa_print(m2_mr, digits=0, est_name="Estimate")$table, placement="h",caption="Repeated contrasts. \\label{tab:table0}")


## ---- echo=TRUE----------------------------------------------------------
simdat3$F <- factor(simdat3$F, levels=c("F1","F2","F3","F4"))
(contrasts(simdat3$F) <- XcSD) # contrast matrix
(covars <- as.data.frame(model.matrix(~F, simdat3))) # design matrix


## ---- echo=TRUE----------------------------------------------------------
simdat3[,c("Fc2vs1","Fc3vs2","Fc4vs3")] <- covars[,2:4]


## ---- echo=TRUE----------------------------------------------------------
m3_mr <- lm(DV ~ Fc2vs1 + Fc3vs2 + Fc4vs3, data=simdat3)


## ----table0.3, results="asis"--------------------------------------------
apa_table(apa_print(m3_mr, digits=0, est_name="Estimate")$table, placement="h", 
    caption="Repeated contrasts as linear regression.")


## ---- echo=TRUE----------------------------------------------------------
Xpol <- contr.poly(4)
(contrasts(simdat3$F) <- Xpol)
m1_mr.Xpol <- lm(DV ~ F, data=simdat3)


## ----table14polA, results="asis"-----------------------------------------
apa_table(apa_print(m1_mr.Xpol, digits=0, est_name="Estimate")$table, placement="h",
    caption="Polynomial contrasts.")


## ---- echo=TRUE----------------------------------------------------------
(contrasts(simdat3$F) <- cbind(c(-3, -3, 1, 5)))
C <-  model.matrix(~ F, data=simdat3)
simdat3$Fcust <- C[,"F1"]
m1_mr.Xcust <- lm(DV ~ Fcust, data=simdat3)


## ----table14cust, results="asis"-----------------------------------------
apa_table(apa_print(m1_mr.Xcust, digits=0, est_name="Estimate")$table, placement="h",
    caption="Custom contrasts.")


## ---- echo=TRUE----------------------------------------------------------
colSums(contr.treatment(4))


## ---- echo=TRUE----------------------------------------------------------
colSums(contr.sdif(4))


## ---- echo=TRUE----------------------------------------------------------
(Xsum <- cbind(F1=c(1,1,-1,-1), F2=c(1,-1,1,-1), F1xF2=c(1,-1,-1,1)))
cor(Xsum)


## ---- echo=TRUE----------------------------------------------------------
cor(contr.sum(4))


## ---- echo=TRUE----------------------------------------------------------
cor(contr.sdif(4))
cor(contr.treatment(4))


## ---- echo=TRUE----------------------------------------------------------
t(HcSD <- rbind(c2vs1=c(F1=-1,F2= 1,F3= 0), 
                c3vs1=c(    0,   -1,    1)))
t(ginv2(ginv2(HcSD)))


## ---- echo=TRUE----------------------------------------------------------
(XcTr <- cbind(int=1,contr.treatment(3)))


## ---- echo=TRUE----------------------------------------------------------
t(ginv2(XcTr))


## ---- echo=TRUE----------------------------------------------------------
(XcTr <- contr.treatment(3))
t(Hc <- ginv2(XcTr))


## ----Overview, fig.height=6, fig.width=6, fig.cap="Overview of contrasts including treatment, sum, and repeated contrasts. From top to bottom panels, we illustrate the computation of regression coefficients, show the contrast design and hypothesis matrices, formulas for computing regression coefficients, the null hypotheses tested by each coefficient, and formulas for estimated data.", fig.align="center"----
#library(png)
knitr::include_graphics("figures/Figure_Contrasts3.png", dpi = 60)


## ---- echo=TRUE----------------------------------------------------------
(XcTr <- cbind(int=c(F1=1,F2=1), c2vs1=c(0,1)))


## ---- echo=TRUE----------------------------------------------------------
(beta <- c(0.8,-0.4))
## convert to a 2x1 matrix:
beta<-matrix(beta,ncol = 1)


## ---- echo=TRUE----------------------------------------------------------
XcTr %*% beta #The symbol %*% indicates matrix multiplication


## ---- echo=TRUE----------------------------------------------------------
XcTr
ginv2(XcTr)
fractions( ginv2(XcTr) %*% XcTr )


## ----fitmodel1, echo=TRUE------------------------------------------------
XcTr


## ----fitmodel1b, echo=TRUE-----------------------------------------------
(HcTr <- ginv2(XcTr))


## ---- echo=TRUE----------------------------------------------------------
mu <- table1$M
HcTr %*% mu # %*% indicates matrix multiplication.


## ---- echo=TRUE----------------------------------------------------------
HcTr


## ----fitmodel2, cache=FALSE, echo=TRUE-----------------------------------
contrasts(simdat$F) <- c(0,1)
data.frame(X <- model.matrix( ~ 1 + F,simdat)) # obtain design matrix X
(Xinv <- ginv2(X)) # take generalized inverse of X
(y <- simdat$DV) # raw data
Xinv %*% y # matrix multiplication


## ---- echo=TRUE----------------------------------------------------------
(contrasts(simdat3$F) <- contr.poly(4))
simdat3X <- model.matrix(~ F, data=simdat3)
simdat3[,c("cLinear","cQuadratic","cCubic")] <- simdat3X[,2:4]
m1_mr.Xpol2 <- lm(DV ~ cLinear + cQuadratic + cCubic, data=simdat3)


## ---- echo=TRUE----------------------------------------------------------
(aovModel <- anova(m1_mr.Xpol2))
# SumSq contrast
SumSq <- aovModel[1:3,"Sum Sq"]
names(SumSq) <- c("cLinear","cQuadratic","cCubic")
SumSq


## ---- echo=TRUE----------------------------------------------------------
# SumSq effect
sum(SumSq)
# r2 alerting
round(SumSq / sum(SumSq), 2)


## ---- echo=FALSE---------------------------------------------------------
set.seed(1)
simdat4 <- mixedDesign(B=c(2,2), W=NULL, n=5, M=M,  SD=10, long = TRUE) 
names(simdat4)[1:2] <- c("A","B")

# Check that we are analyzing the same measurements as before
#identical(simdat3$DV, simdat4$DV)

table4 <- simdat4 %>% group_by(A, B) %>% # plot interaction
    summarize(N=length(DV), M=mean(DV), SD=sd(DV), SE=SD/sqrt(N))
GM <-  mean(table4$M) # Grand Mean

table4a <- table4
names(table4a) <- c("Factor A","Factor B","N data","Means","Std. dev.","Std. errors")


## ----twobytwosimdatTab, results="asis"-----------------------------------
apa_table(table4a, digits=1, placement="h",
    caption="Summary statistics for a two-by-two between-subjects factorial design.")


## ----twobytwosimdatFig, fig=TRUE, include=TRUE, echo=FALSE, cache=FALSE, fig.width=5, fig.height=3, fig.cap = "Means and error bars (showing standard errors) for a simulated data-set with a two-by-two  between-subjects factorial design."----
(plot2 <- qplot(x=A, y=M, group=B, linetype=B, shape=B, data=table4, geom=c("point", "line")) + 
   labs(y="Dependent variable", x="Factor A", colour="Factor B", linetype="Factor B", shape="Factor B")+
	 geom_errorbar(aes(max=M+SE, min=M-SE), width=0) ) 


## ---- echo=TRUE----------------------------------------------------------
# generate 2 times 2 between subjects data:
simdat4 <- mixedDesign(B=c(2,2), W=NULL, n=5, M=M,  SD=10, long = TRUE) 
names(simdat4)[1:2] <- c("A","B")
head(simdat4)

table4 <- simdat4 %>% group_by(A, B) %>% # plot interaction
    summarize(N=length(DV), M=mean(DV), SD=sd(DV), SE=SD/sqrt(N))
GM <-  mean(table4$M) # Grand Mean


## ----twobytwosimdatTab1, include=TRUE, echo=FALSE------------------------
table4a <- table4
names(table4a) <- c("Factor A","Factor B","N data","Means","Std. dev.","Std. errors")


## ---- echo=TRUE----------------------------------------------------------
# ANOVA: B_A(2) times B_B(2)
m2_aov <- aov(DV ~ A*B + Error(id), data=simdat4)

# MR: B_A(2) times B_B(2)
m2_mr <- lm(DV ~ A*B, data=simdat4)


## ----table16, results="asis"---------------------------------------------
apa_table(apa_print(m2_aov)$table, placement="!htbp",
    caption="Estimated ANOVA model.")


## ----table17, results="asis"---------------------------------------------
apa_table(apa_print(m2_mr, digits=0, est_name="Estimate")$table, placement="!htbp", 
    caption="Estimated regression model.")


## ---- echo=TRUE----------------------------------------------------------
# define sum contrasts:
contrasts(simdat4$A) <- contr.sum(2)
contrasts(simdat4$B) <- contr.sum(2)
m2_mr.sum <- lm(DV ~ A*B, data=simdat4)

# Alternative using covariates
mat_myC <- model.matrix(~ A*B, simdat4)
simdat4[, c("GM", "FA", "FB", "FAxB")] <- mat_myC
m2_mr.v2 <- lm(DV ~  FA + FB + FAxB, data=simdat4)


## ----table18, results="asis"---------------------------------------------
apa_table(apa_print(m2_mr.sum, digits=0, est_name="Estimate")$table, placement="h",
    caption="Regression analysis with sum contrasts.")


## ----table19, results="asis"---------------------------------------------
apa_table(apa_print(m2_mr.v2, digits=0, est_name="Estimate")$table, placement="h",
    caption="Defining sum contrasts using the model.matrix() function.")


## ---- echo=TRUE----------------------------------------------------------
t(fractions(HcInt <- rbind(A  =c(F1=1/4,F2= 1/4,F3=-1/4,F4=-1/4),
                           B  =c(F1=1/4,F2=-1/4,F3= 1/4,F4=-1/4),
                           AxB=c(F1=1/4,F2=-1/4,F3=-1/4,F4= 1/4))))
(XcInt <- ginv2(HcInt))
contrasts(simdat3$F) <- XcInt
m3_mr <- lm(DV ~ F, data=simdat3)


## ----table20, results="asis"---------------------------------------------
apa_table(apa_print(m3_mr, digits=0, est_name="Estimate")$table, placement="h",
    caption="Main effects and interaction: Custom-defined sum contrasts (scaled).")


## ---- echo=TRUE----------------------------------------------------------
t(fractions(HcNes <- rbind(B   =c(F1= 1/2,F2=-1/2,F3= 1/2,F4=-1/2),
                           B1xA=c(F1=-1  ,F2= 0  ,F3= 1  ,F4= 0  ),
                           B2xA=c(F1= 0  ,F2=-1  ,F3= 0  ,F4= 1 ))))
(XcNes <- ginv2(HcNes))
contrasts(simdat3$F) <- XcNes
m4_mr <- lm(DV ~ F, data=simdat3)


## ----table21, results="asis"---------------------------------------------
apa_table(apa_print(m4_mr, digits=0, est_name="Estimate")$table, placement="h",
    caption="Regression model for nested effects.")


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat4$A) <- c(-0.5,+0.5)
contrasts(simdat4$B) <- c(+0.5,-0.5)
m4_mr.x <- lm(DV ~ B / A, data=simdat4)


## ----table22, results="asis"---------------------------------------------
apa_table(apa_print(m4_mr.x, digits=0, est_name="Estimate")$table, placement="h",
    caption="Nested effects: R-formula.")


## ---- echo=TRUE----------------------------------------------------------
# Extract contrasts as covariates from model matrix
mat_myC <- model.matrix(~ F, simdat3)
fractions(as.matrix(data.frame(mat_myC)))
  
# Repeat the multiple regression with covariates 
simdat3[, c("GM", "C1", "C2", "C3")] <- mat_myC
m2_mr.myC1 <- lm(DV ~ C1 + C2 + C3, data=simdat3)
summary(m2_mr.myC1)$sigma # standard deviation of residual
# Run the multiple regression by leaving out C1
m2_mr.myC2 <- lm(DV ~ C2 + C3, data=simdat3)
summary(m2_mr.myC2)$sigma # residual standard error


## ----table22a, results="asis"--------------------------------------------
apa_table(apa_print(m2_mr.myC1, digits=0, est_name="Estimate")$table, placement="h",
    caption="Nested effects: Full model.")


## ----table-myC2, results="asis"------------------------------------------
apa_table(apa_print(m2_mr.myC2, digits=0, est_name="Estimate")$table, placement="h",
    caption="Nested effects: Without main effect of B B.")


## ---- echo=TRUE----------------------------------------------------------
t(fractions(HcNes2 <- rbind(A   =c(F1=1/2,F2= 1/2,F3=-1/2,F4=-1/2),
                            A1_B=c(F1=1  ,F2=-1  ,F3= 0  ,F4= 0  ),
                            A2_B=c(F1=0  ,F2= 0  ,F3= 1  ,F4=-1 ))))
(XcNes2 <- ginv2(HcNes2))
contrasts(simdat3$F) <- XcNes2
m4_mr <- lm(DV ~ F, data=simdat3)


## ----table-m4mr, results="asis"------------------------------------------
apa_table(apa_print(m4_mr, digits=0, est_name="Estimate")$table, placement="h",
    caption="Factor B nested within Factor A.") # Question: How to include underscore ("_") to the caption?


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat4$A) <- contr.treatment(2)
contrasts(simdat4$B) <- contr.treatment(2)
XcTr <- unique(model.matrix(~A*B, simdat4))
rownames(XcTr) <- c("A1_B1","A1_B2","A2_B1","A2_B2")
XcTr


## ---- echo=TRUE----------------------------------------------------------
t(ginv2(XcTr))


## ---- echo=TRUE----------------------------------------------------------
contrasts(simdat4$A) <- contr.sum(2)
contrasts(simdat4$B) <- contr.sum(2)
XcSum <- unique(model.matrix(~A*B, simdat4))
rownames(XcSum) <- c("A1_B1","A1_B2","A2_B1","A2_B2")
XcSum
t(ginv2(XcSum))


## ---- echo=TRUE----------------------------------------------------------
M9 <- matrix(c(150,175,200, 175,150,175, 200,175,150),ncol=1)
matrix(M9,nrow=3,dimnames=list(paste0("Prime",1:3),paste0("Target",1:3)))
set.seed(1)
simdat5 <- mixedDesign(B=c(3,3), W=NULL, n=5, M=M9, SD=50, long = TRUE) 
names(simdat5)[1:2] <- c("Prime","Target")
levels(simdat5$Prime) <- paste0("Prime",1:3)
levels(simdat5$Target) <- paste0("Target",1:3)
table5 <- simdat5 %>% group_by(Prime, Target) %>% # plot interaction
    summarize(N=length(DV), M=mean(DV), SD=sd(DV), SE=SD/sqrt(N))
table5 %>% select(Prime,Target,M) %>% spread(key=Target, value=M) %>% 
  data.frame()


## ----3by3simdatTab1, include=TRUE, echo=FALSE----------------------------
table5a <- table5
names(table5a) <- c("Factor Prime","Factor Target","N data","Means","Stand. dev.","Stand. errors")


## ----3by3simdatFig, fig=TRUE, include=TRUE, echo=FALSE, cache=FALSE, fig.width=5.5, fig.height=3.7, fig.cap = "Means and error bars (showing standard errors) for a simulated data-set with a 3 x 3 between-subjects factorial design."----
(plot3 <- ggplot(aes(x=Prime, y=M, group=Target, fill=Target), data=table5)+
   geom_bar(stat="identity", position="dodge") + labs(y="Dependent variable", x="Factor Prime", colour="Factor Target", linetype="Factor Target", shape="Factor Target")+
   scale_fill_grey()+
	 geom_errorbar(aes(max=M+SE, min=M-SE), width=0, position=position_dodge(0.9)) )


## ---- echo=TRUE----------------------------------------------------------
meansExp <- rbind(Prime1=c(Target1=150,Target2=200,Target3=200), 
                  Prime2=c(        200,        150,        200), 
                  Prime3=c(        200,        200,        150))


## ---- echo=TRUE----------------------------------------------------------
(XcS <- (meansExp-mean(meansExp))*3/50)


## ---- echo=TRUE----------------------------------------------------------
simdat5$cMatch <- ifelse(
    as.numeric(simdat5$Prime)==as.numeric(simdat5$Target),-2,1)
mOmn <- summary(aov(DV~Prime*Target       +Error(id), data=simdat5))
mCon <- summary(aov(DV~Prime*Target+cMatch+Error(id), data=simdat5))


## ---- echo=FALSE---------------------------------------------------------
rownames(mCon[[1]][[1]])[3:4] <- c("Matching contrast","Contrast residual")
mod <- rbind(mOmn[[1]][[1]][1:3,], 
             mCon[[1]][[1]][3:4,], 
             Error=mOmn[[1]][[1]][4,])
mFull <- mOmn
mFull[[1]][[1]] <- mod
tabTmp <- apa_print(mFull)$table[c(1,2,5,3,4),]
tabTmp[,5] <- round(mFull[[1]][[1]][1:5,"Sum Sq"])
class(tabTmp[,5]) <- c("papaja_labelled","character")
attr(tabTmp[,5],"label") <- "$\\mathit{Sum}$ $\\mathit{Sq}$"


## ----tableIntCon, results="asis"-----------------------------------------
apa_table(tabTmp, placement="h", midrules=c(3), stub_indents=list(c(4,5)), 
    digits=0, align=c("l","l","l","l","r","l","l"),
    caption="Interaction contrast.")


## ----render_appendix, include=FALSE--------------------------------------
render_appendix("appendixshort.Rmd")


## ----create_r-references-------------------------------------------------
r_refs(file = "r-references.bib")

