#### Reversal Sensitivity Analysis

rm(list=ls())

library('dplyr')
library('ggplot2')

load('/cloud/project/dataframes/data_prep.rda')

se <- function(x) sd(x, na.rm=TRUE)/sqrt(length(x)-sum(is.nan(x)))

df <- filter(data_prep,Trial_idx %in% c(51:60,121:130))

# create index if first or second reversal
df$reversal <- 'last'
df$reversal[df$Trial_idx>=50 & df$Trial_idx<=60] <- 'first'
df$reversal <- factor(df$reversal)
# index number of trials within reversal
df$revidx <- rep(c(-5:-1,1:5),times=4*28)

# create binary revstate variable
df$revstate <- rep(c(1,2),each=5,times=4*28)
df$revstate <- factor(df$revstate)

# aggregate
dfsens <- df %>% group_by(sub_id,revstate,Cond,reversal) %>% summarise(meandiff = mean(Correct,na.rm=TRUE))
dfsenswideagg <- dfsenswide %>% group_by(Cond,reversal) %>% summarise(mean = mean(sensidx,na.rm=TRUE),SE=se(sensidx))

# make wide along first/last variable in order to have 4 observations/subj
dfsenswide <- dfsens %>% dcast(sub_id + reversal + Cond ~ revstate)

dfsenswide$sensidx <- dfsenswide$'1' - dfsenswide$'2'

dfsenswidefirst <- dfsenswide %>% filter(reversal == "first")
dfsenswidelast <- dfsenswide %>% filter(reversal == "last")

# prepare data for merge with physio
dfsenswideboth <- merge.data.frame(dfsenswidefirst,dfsenswidelast, by = c("Cond","sub_id"))
dfsenswideboth <- dfsenswideboth %>% rename(revidx_first="sensidx.x")
dfsenswideboth <- dfsenswideboth %>% rename(revidx_last="sensidx.y")
dfsenswideboth <- dfsenswideboth %>% rename(just_cond="Cond")

dfsenswideboth$sub_id <- str_remove(dfsenswideboth$sub_id, "[_]")

dfsenscort <- merge.data.frame(longdat.cond.both,dfsenswideboth, by = c("just_cond","sub_id"))

# preparation for plot, calculate trialwise mean of correct choice across subject
dfagg <- df %>% group_by(Trial_idx,Cond,revidx,reversal) %>% summarise(corr=mean(Correct,na.rm=TRUE),SE=se(Correct)) 
# and plot (according to Fig 4, Cremer, 2021)
revsensplot <- ggplot(dfagg,aes(x = revidx,y = corr,color=Cond)) + geom_point() + geom_line() + geom_errorbar(aes(ymin=corr-SE, ymax=corr+SE),width=.2) + facet_wrap(.~reversal)
revsensplot

# scatter plot for sensitivity index (first or last) with cortisol AUC 

senscortplotfirst <- ggscatter(dfsenscort, x = "aucg", y = "revidx_first", color = "wm_cap",
                              add = "reg.line", conf.int = TRUE, 
                              cor.coef = TRUE, cor.method = "pearson",
                              xlab = "AUCG", ylab = "Reversal Sensitivity Index (first)")
senscortplotfirst

senscortplotlast <- ggscatter(dfsenscort, x = "aucg", y = "revidx_last", color = "wm_cap",
                          add = "reg.line", conf.int = TRUE, 
                          cor.coef = TRUE, cor.method = "pearson",
                          xlab = "AUCG", ylab = "Reversal Sensitivity Index (last)")
senscortplotlast

# and bar plot 
revsensbar <- ggplot(dfsenswideagg,aes(x=Cond, y = mean)) + geom_bar(stat='identity') + geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE),width=.2) + facet_wrap(.~reversal)
revsensbar

meandifffirst.ttest <- t.test(data=dfsenswidefirst, sensidx ~ Cond, paired = TRUE)
meandifflast.ttest <- t.test(data=dfsenswidelast, sensidx ~ Cond, paired = TRUE)

rm(dfsens)
rm(dfsensagg)
rm(dfsenswide)
rm(dfsenswideagg)
rm(dfsenswidefirst)
rm(dfsenswidelast)
