#### Reversal Sensitivity Analysis

rm(list=ls())

library('dplyr')
library('ggplot2')

load('/cloud/project/dataframes/data_prep.rda')
load('/cloud/project/dataframes/longdat.cond.both.rda')

se <- function(x) sd(x, na.rm=TRUE)/sqrt(length(x)-sum(is.nan(x)))

df <- filter(data_prep,Trial_idx %in% c(51:60,66:75,86:95,101:110,121:130))
df <- data_prep

# create index if first or second reversal
df$reversal <- 'Last Reversal'
df$reversal[df$Trial_idx>=50 & df$Trial_idx<=60] <- 'First Reversal'
df$reversal[df$Trial_idx>=65 & df$Trial_idx<=75] <- 'Second Reversal'
df$reversal[df$Trial_idx>=85 & df$Trial_idx<=95] <- 'Third Reversal'
df$reversal[df$Trial_idx>=100 & df$Trial_idx<=110] <- 'Fourth Reversal'


df$reversal[df$Trial_idx>=1 & df$Trial_idx<=55] <- 'state_1'
df$reversal[df$Trial_idx>=71 & df$Trial_idx<=90] <- 'state_1'
df$reversal[df$Trial_idx>=106 & df$Trial_idx<=125] <- 'state_1'

df$reversal[df$Trial_idx>=56 & df$Trial_idx<=70] <- 'state_2'
df$reversal[df$Trial_idx>=91 & df$Trial_idx<=105] <- 'state_2'
df$reversal[df$Trial_idx>=126 & df$Trial_idx<=160] <- 'state_2'

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


revsensplot <- ggplot(dfsens,aes(x = Trial_idx,y = meandiff,color=Cond))+
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=corr-SE, ymax=corr+SE),width=.2) +
  labs(title = '',  x = "Trial Index", y = "Mean advantageous choices", color = "Condition")

revsensplot

f2_results <- ggarrange(revsensplot, taskstruc,
                        labels = c("A", "B"),
                        ncol = 1, nrow = 2)
f2_results

ggsave(f2_results, filename = "f2_results.png","jpg", "/cloud/project/plots/meeting_plots")


# make wide along first/last variable in order to have 4 observations/subj
dfsenswide <- dfsens %>% spread(sub_id + reversal + Cond ~ revstate)

dfsenswide$sensidx <- dfsenswide$'1' - dfsenswide$'2'

dfsenswideagg <- dfsenswide %>% group_by(Cond,reversal) %>% summarise(mean = mean(sensidx,na.rm=TRUE),SE=se(sensidx))

# dfsenswidefirst <- dfsenswide %>% filter(reversal == "First Reversal")
# dfsenswidesecond <- dfsenswide %>% filter(reversal == "Second Reversal")
# dfsenswidethird <- dfsenswide %>% filter(reversal == "Third Reversal")
# dfsenswidefourth <- dfsenswide %>% filter(reversal == "Fourth Reversal")
# dfsenswidelast <- dfsenswide %>% filter(reversal == "Last Reversal")

# prepare data for merge with physio
dfsenswideboth <- merge.data.frame(dfsenswidefirst,dfsenswidesecond, by = c("Cond","sub_id"))
dfsenswideboth <- dfsenswideboth %>% rename(revidx_first="sensidx.x")
dfsenswideboth <- dfsenswideboth %>% rename(just_cond="Cond")

dfsenswideboth$sub_id <- str_remove(dfsenswideboth$sub_id, "[_]")
longdat.cond.both <- longdat.cond.both %>% rename(Cond = just_cond)


dfsenscort <- merge.data.frame(longdat.cond.both, dfsenswideboth, by = c("Cond","sub_id"))

df <- df %>% mutate(Choice_t = dplyr::recode(state, `-1` = 0))


df$df_chos1 <- NA
df$df_chos1<-ifelse(df$Choice_t==1,"Card A","Card B")
df$df_chos1 <- factor(df$df_chos1)

# preparation for plot, calculate trialwise mean of correct choice across subject 
dfagg_state1 <- df %>% group_by(Trial_idx,Cond)  %>% filter(reversal=="state_1")  %>%  summarise(corr=mean(Correct,na.rm=TRUE),SE=se(Correct)) 
dfagg_state2 <- df %>% group_by(Trial_idx,Cond)  %>% filter(reversal=="state_2")  %>%  summarise(corr=1-mean(Correct,na.rm=TRUE),SE=se(Correct)) 

dfagg <- dfagg_state1 %>% bind_rows(dfagg_state2)

dfaggstruc <- merge(dfagg,task_struc, by = "Trial_idx")

# and plot (according to Fig 4, Cremer, 2021)

dfaggstruc$Cond <- factor(dfaggstruc$Cond, levels=rev(levels(dfaggstruc$Cond)))

dfaggstruc <- dfaggstruc %>% mutate(Cond=recode(Cond, `control`="Control", `stress`="Stress"))

theme_set(theme_minimal())

figchosplot <- ggplot(dfaggstruc,aes(x = Trial_idx,y = corr,color = Cond)) +
                geom_line() +
                geom_line(aes(x=Trial_idx,y=state_rev_2), color = "darkgrey") +
                geom_ribbon(aes(ymin=corr-SE, ymax=corr+SE,fill = Cond),width=.2, alpha = 0.2, linetype = 0) + 
                labs(x = "Trial index", y = "Proportion of chosen card", color = "Condition") +
                scale_y_continuous(breaks = c(0,1), label = c("Card A", "Card B"),size = limits=c(0,1.01)) +
                scale_x_continuous(limits=c(1,160)) +
                annotate("rect", xmin=1, xmax=56, ymin=0, ymax=1, fill="darkgrey", alpha = 0.2) +
                annotate("rect", xmin=56, xmax=126, ymin=0, ymax=1, fill="lightgreen", alpha = 0.2) +
                annotate("rect", xmin=126, xmax=160, ymin=0, ymax=1, fill="darkgrey", alpha = 0.2) +
                theme(plot.title = element_text(face = "italic",size=12),axis.text=element_text(size=16), axis.title=element_text(size=18)) 

fig2chosplot <- figchosplot + guides(
    fill = guide_legend(
      title = "Condition",
      override.aes = aes(label = "Condition")))
    

ggsave(fig2chosplot, filename = "fig2chosplot_updated","jpg", "/cloud/project/plots/manuscript_plots")

fig2corrplot <- ggplot(dfaggstruc,aes(x = Trial_idx,y = corr,color = Cond)) +
  geom_line() +
  geom_line(aes(x=Trial_idx,y=state_rev_2), color = "darkgrey") +
  geom_ribbon(aes(ymin=corr-SE, ymax=corr+SE,fill = Cond),width=.2, alpha = 0.2, linetype = 0) + 
  labs(title = '',  x = "Trial index", y = "Chosen card", color = "Condition") +
  scale_y_continuous(breaks = c(0,1), label = c("Card A", "Card B"),limits=c(0,1.01)) +
  scale_x_continuous(limits=c(1,160)) 
fig2corrplot

ggsave(fig2chosplot, filename = "fig2chosplot.png","jpg", "/cloud/project/plots/manuscript_plots")


df$State <- as.numeric(df$State)
df$Trial_idx <- as.numeric(df$Trial_idx)


df %>% filter(sub_idx==1) %>% ggplot() + geom_line(aes(x=Trial_idx,y=State))


ggsave(revsensplot, filename = "empirical_revs.png","jpg", "/cloud/project/plots/manuscript_plots")

dfagg_choice <- df %>% group_by(Trial_idx,Cond) %>% filter(Order==1)  %>% summarise(Choice=mean(Choice_t,na.rm=TRUE),SE=se(Choice_t)) 

revsensplot <- ggplot(dfagg_choice,aes(x = Trial_idx,y = Choice,color=Cond))+ 
  geom_line() + 
  geom_ribbon(aes(ymin=Choice-SE, ymax=Choice+SE),width=.2, alpha = 0.2) + 
  labs(title = '',  x = "Trial index", y = "Mean choice of each card", color = "Condition") 
revsensplot

ggsave(revsensplot, filename = "senscortplotall_choice.png","jpg", "/cloud/project/plots/manuscript_plots")

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
