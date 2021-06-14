#### Reversal Sensitivity Analysis

rm(list=ls())

library('dplyr')
library('ggplot2')

load('/cloud/project/dataframes/data_prep.rda')
load('/cloud/project/dataframes/longdat.cond.both.rda')

se <- function(x) sd(x, na.rm=TRUE)/sqrt(length(x)-sum(is.nan(x)))

# df <- filter(data_prep,Trial_idx %in% c(51:60,66:75,86:95,101:110,121:130))
df <- data_prep

# create index if first or second reversal
# df$reversal <- 'Last Reversal'
# df$reversal[df$Trial_idx>=50 & df$Trial_idx<=60] <- 'First Reversal'
# df$reversal[df$Trial_idx>=65 & df$Trial_idx<=75] <- 'Second Reversal'
# df$reversal[df$Trial_idx>=85 & df$Trial_idx<=95] <- 'Third Reversal'
# df$reversal[df$Trial_idx>=100 & df$Trial_idx<=110] <- 'Fourth Reversal'


df$reversal <- factor(df$reversal)
# index number of trials within reversal
df$revidx <- rep(c(-5:-1,1:5),times=10*28)

# create binary revstate variable
df$revstate <- rep(c(1,2),each=5,times=10*28)
df$revstate <- factor(df$revstate)

# aggregate
dfsens <- df %>% group_by(sub_id,revstate,Cond,reversal) %>% summarise(meandiff = mean(Correct,na.rm=TRUE))
dfsens <- df %>% group_by(Trial_idx,Cond) %>% summarise(meandiff = mean(Correct,na.rm=TRUE))
dfsens <- dfsens %>% arrange(desc(Cond))

dfsens$stresstrial <- condtrial(c(51:60,66:75,86:95,101:110,121:130))
ilter(data_prep,Trial_idx %in% c(51:60,66:75,86:95,101:110,121:130))

state_rev <- c(1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1, 1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2, 2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2,	2)

state_rev_2 <- replace(state_rev, state_rev==2, 0)

taskstruc <- plot(state_rev_2,type = "o", col = "black", xlab = "Trial", ylab = "Outcome probability", main = "Contingencies")
taskstruc

revsensplot <- ggplot(dfsens,aes(x = stresstrial,y = meandiff,color=Cond))+ 
  geom_point() + 
  geom_line() + 
  #geom_errorbar(aes(ymin=corr-SE, ymax=corr+SE),width=.2) + 
  labs(title = '',  x = "Trial relative to reversal", y = "Mean advantageous choices", color = "Condition") 

revsensplot

f2_results <- ggarrange(revsensplot, taskstruc,
                        labels = c("A", "B"),
                        ncol = 1, nrow = 2)
f2_results

ggsave(f2_results, filename = "f2_results.png","jpg", "/cloud/project/plots/meeting_plots")


# make wide along first/last variable in order to have 4 observations/subj
dfsenswide <- dfsens %>% dcast(sub_id + reversal + Cond ~ revstate)

dfsenswide$sensidx <- dfsenswide$'1' - dfsenswide$'2'


dfsenswideagg <- dfsenswide %>% group_by(Cond,reversal) %>% summarise(mean = mean(sensidx,na.rm=TRUE),SE=se(sensidx))

dfsenswidefirst <- dfsenswide %>% filter(reversal == "First Reversal")
dfsenswidesecond <- dfsenswide %>% filter(reversal == "Second Reversal")
dfsenswidethird <- dfsenswide %>% filter(reversal == "Third Reversal")
dfsenswidefourth <- dfsenswide %>% filter(reversal == "Fourth Reversal")
dfsenswidelast <- dfsenswide %>% filter(reversal == "Last Reversal")


# prepare data for merge with physio
dfsenswideboth <- merge.data.frame(dfsenswidefirst,dfsenswidesecond, by = c("Cond","sub_id"))
dfsenswideboth <- dfsenswideboth %>% rename(revidx_first="sensidx.x")
dfsenswideboth <- dfsenswideboth %>% rename(just_cond="Cond")

dfsenswideboth$sub_id <- str_remove(dfsenswideboth$sub_id, "[_]")
longdat.cond.both <- longdat.cond.both %>% rename(Cond = just_cond)


dfsenscort <- merge.data.frame(longdat.cond.both, dfsenswideboth, by = c("Cond","sub_id"))

# preparation for plot, calculate trialwise mean of correct choice across subject
dfagg <- df %>% group_by(Trial_idx,Cond,revidx,reversal) %>% summarise(corr=mean(Correct,na.rm=TRUE),SE=se(Correct)) 
# and plot (according to Fig 4, Cremer, 2021)

dfagg$Cond <- factor(dfagg$Cond, levels=rev(levels(dfagg$Cond)))

revsensplot <- ggplot(dfagg,aes(x = revidx,y = corr,color=Cond))+ 
                geom_point() + 
                geom_line() + 
                geom_errorbar(aes(ymin=corr-SE, ymax=corr+SE),width=.2) + 
                facet_wrap(.~reversal) +
  labs(title = '',  x = "Trial relative to reversal", y = "Mean advantageous choices", color = "Condition") 

revsensplot

ggsave(revsensplot, filename = "senscortplotall","jpg", "/cloud/project/plots/meeting_plots")


# scatter plot for sensitivity index (first or last) with cortisol AUC 

senscortplotfirst <- ggscatter(dfsenscort, x = "aucg", y = "revidx_first",
                              add = "reg.line", conf.int = TRUE, 
                              cor.coef = TRUE, cor.method = "pearson",
                              xlab = "AUCG", ylab = "Reversal Sensitivity Index (first)")
senscortplotfirst

senscortplotfirst <- ggscatter(dfsenscort, x = "aucg", y = "revidx_first",
                               add = "reg.line", conf.int = TRUE, 
                               cor.coef = TRUE, cor.method = "pearson",
                               xlab = "AUCG", ylab = "Reversal Sensitivity Index (first)")
senscortplotfirst


senscortplotlast <- ggscatter(dfsenscort, x = "aucg", y = "revidx_last",
                          add = "reg.line", conf.int = TRUE, 
                          cor.coef = TRUE, cor.method = "pearson",
                          xlab = "AUCG", ylab = "Reversal Sensitivity Index (last)")
senscortplotlast


# and bar plot 
revsensbar <- ggplot(dfsenswideagg,aes(x=Cond, y = mean, color = Cond)) + 
              geom_bar(stat='identity',alpha=0.2,width=0.4) + 
              geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE),width=.2) + 
              facet_wrap(.~reversal) + 
              xlab("Condition") + ylab("Reversal Sensitivity Index") +
              scale_color_manual(values = c("#00BFC4", "#F8766D"))
revsensbar

#ggsave(revsensbar, filename = "revsensbar",".jpg", "/cloud/project/plots/meeting_plots")


meandifffirst.ttest <- t.test(data=dfsenswidefirst, sensidx ~ Cond, paired = TRUE)
meandiffsecond.ttest <- t.test(data=dfsenswidesecond, sensidx ~ Cond, paired = TRUE)
meandiffthird.ttest <- t.test(data=dfsenswidethird, sensidx ~ Cond, paired = TRUE)
meandifffourth.ttest <- t.test(data=dfsenswidefourth, sensidx ~ Cond, paired = TRUE)
meandifflast.ttest <- t.test(data=dfsenswidelast, sensidx ~ Cond, paired = TRUE)

rm(dfsens)
rm(dfsenswide)
#rm(dfsenswideagg)
rm(dfsenswidefirst)
rm(dfsenswidelast)
