# LMEs

libs<-c("dplyr", "lme4")
sapply(libs, require, character.only=TRUE)

str(data_strials)

data_strials$Group<-factor(data_strials$Group, labels=c("HC", "AUD"))
data_strials$Cond<-factor(data_strials$Cond, labels=c("control", "stress"))
data_strials$sub_idx<-factor(data_strials$sub_idx)

n<-length(unique(data_strials$sub_idx))
phases<-c(rep(1,55), rep(2,70), rep(3,35))

data_strials$volat<-rep(phases, times=n*2) 
data_strials$volat<-factor(data_strials$volat)                

save(file="hierarchical/operant_sample1_singletrial.RData", data_strials)


