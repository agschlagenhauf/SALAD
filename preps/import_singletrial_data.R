library(readr)
library(dplyr)
library(lme4)

################# ALL DATA FOR SINGLE TRIAL ANALYSES IMPORTED AND PREPARED HERE ###########

# CHANGE HERE depending on analyses on HC sample 1 only (singtrial_file) or both groups
# adapt path to data you want to import, sing_trial_file_HC for HC only: including Cond (1 = CT, 2 = ST), Outcome (1=Reward, 0= No reward), Choice_t (which card was chosen), 
# Correct (1=card chosen which would be rewarded in this state), winstay, loseshift, RT and S (indicates same underlying task state: e.g. 1-55: 0,56-71: 1, 72-92: 0)
sing_trial_file_HC <- "hierarchical/operant_sample1_singtrial_wC_wo1A001_wRT_cond_wS.csv"
sing_trial_file_both <- "hierarchical/operant_sample1_singtrial_wC_both.csv"

data_strials <- read.csv(sing_trial_file_HC, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, )
data_strials_both <- read.csv(sing_trial_file_both, header = TRUE, sep = ";", quote = "\"", dec = ".", fill = TRUE)

# prepare both dataframes 
data_strials_both$Group <- factor(data_strials_both$Group, labels=c("HC", "AUD"))
data_strials_both$Cond <- factor(data_strials_both$Cond, labels=c("control", "stress"))
data_strials_both$sub_idx <- factor(data_strials_both$sub_idx)

data_strials$Cond <- factor(data_strials$Cond, labels=c("control", "stress"))
data_strials$sub_idx <- factor(data_strials$sub_idx)

# create volat to indicate which phase (1-3) and condtrial as new index for trials within each phase
n<-length(unique(data_strials$sub_idx))
phases<-c(rep(1,55), rep(2,70), rep(3,35))
condtrial <- c((1:55),(1:70),(1:35))

data_strials$condtrial <- rep(condtrial, times = n*2)
data_strials$volat<-rep(phases, times=n*2) 
data_strials$volat<-factor(data_strials$volat)

# same for data_strials_both: create volat to indicate which phase (1-3) and condtrial as new index for trials within each phase
n<-length(unique(data_strials_both$sub_idx))
phases<-c(rep(1,55), rep(2,70), rep(3,35))
condtrial <- c((1:55),(1:70),(1:35))

data_strials_both$condtrial <- rep(condtrial, times = n*2)
data_strials_both$volat<-rep(phases, times=n*2) 
data_strials_both$volat<-factor(data_strials_both$volat)       

save(file="hierarchical/operant_sample1_singtrial.RData", data_strials)

# change coding of Choice_t variable so it can be used to calculate w_stay and l_switch
data_strials$Choice_t[data_strials$Choice_t==0] <- -1

# create new w_stay and l_switch variables on a single-trial basis
data_prep <- data_strials %>% group_by(sub_idx,Cond) %>% 
  mutate(stay = c(Choice_t[1:length(Choice_t)-1]==Choice_t[2:length(Choice_t)],NaN),
         w_stay = stay*Outcome, 
         switch = c(Choice_t[1:length(Choice_t)-1]!=Choice_t[2:length(Choice_t)],NaN),
         l_switch = switch*(1-Outcome))

# change coding of Choice_t variable so it can be used to calculate w_stay and l_switch
data_strials$Choice_t[data_strials$Choice_t==0] <- -1

# create new w_stay and l_switch variables on a single-trial basis
data_prep_both <- data_strials_both %>% group_by(sub_idx,Cond) %>% 
  mutate(stay = c(Choice_t[1:length(Choice_t)-1]==Choice_t[2:length(Choice_t)],NaN),
         w_stay = stay*Outcome, 
         switch = c(Choice_t[1:length(Choice_t)-1]!=Choice_t[2:length(Choice_t)],NaN),
         l_switch = switch*(1-Outcome))

# save data_prep as a foundation for prep_cortbehav
save(file='/cloud/project/dataframes/data_prep.rda',data_prep)
save(file='/cloud/project/dataframes/data_prep_both.rda',data_prep_both)

rm(data_strials)
rm(data_strials_both)