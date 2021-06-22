library(stringr)
library(reshape2)
################# NECESSARY TO RUN THIS FOR CORTISOL AND HIERARCHICAL ANALYSES ###########

load('/cloud/project/dataframes/dat_all.rda')
load('/cloud/project/dataframes/data_all.rda')
load('/cloud/project/dataframes/data_prep.rda')
load('/cloud/project/dataframes/data_prep_both.rda')
load('/cloud/project/dataframes/data_physio_wide.rda')
load('/cloud/project/dataframes/data_physio_clean.rda')
load('/cloud/project/dataframes/dat.vas.rda')

################# BASIC CLEAN-UP PHYSIO AND BEHAV DATASETS
# prepare behavioral data of full sample (dat_all) and only HC sample (data_all) for merge by reducing unnecessary columns
dat_all_reduced = subset(dat_all, select =-c(p_RT_pre_CT,p_RT_rev_CT,p_RT_post_CT,p_stay_pre_CT,p_stay_rev_CT,p_stay_post_CT,p_sw_pre_CT,p_sw_rev_CT,p_sw_post_CT,p_w_st_pre_CT,p_w_st_rev_CT,p_w_st_post_CT,p_l_sw_pre_CT,p_l_sw_rev_CT,p_l_sw_post_CT, p_RT_pre_ST,p_RT_rev_ST,p_RT_post_ST,p_stay_pre_ST,p_stay_rev_ST,p_stay_post_ST,p_sw_pre_ST,p_sw_rev_ST,p_sw_post_ST,p_w_st_pre_ST,p_w_st_rev_ST,p_w_st_post_ST,p_l_sw_pre_ST,p_l_sw_rev_ST,p_l_sw_post_ST))
data_all_reduced = subset(data_all, select =-c(p_RT_pre_CT,p_RT_rev_CT,p_RT_post_CT,p_stay_pre_CT,p_stay_rev_CT,p_stay_post_CT,p_sw_pre_CT,p_sw_rev_CT,p_sw_post_CT,p_w_st_pre_CT,p_w_st_rev_CT,p_w_st_post_CT,p_l_sw_pre_CT,p_l_sw_rev_CT,p_l_sw_post_CT, p_RT_pre_ST,p_RT_rev_ST,p_RT_post_ST,p_stay_pre_ST,p_stay_rev_ST,p_stay_post_ST,p_sw_pre_ST,p_sw_rev_ST,p_sw_post_ST,p_w_st_pre_ST,p_w_st_rev_ST,p_w_st_post_ST,p_l_sw_pre_ST,p_l_sw_rev_ST,p_l_sw_post_ST))

# prepare merge of cortisol and vas data with dat_all by sub_id
names(data_physio_wide)[names(data_physio_wide) == "VpNr"] <- "sub_id"
names(data_physio_clean)[names(data_physio_clean) == "VpNr"] <- "sub_id"
names(dat.vas)[names(dat.vas) == "VpNr"] <- "sub_id"
data_physio_wide$sub_id <- as.character(data_physio_wide$sub_id)

dat_all_reduced$sub_id <- str_remove(dat_all_reduced$sub_id, "[_]")
data_all_reduced$sub_id <- str_remove(data_all_reduced$sub_id, "[_]")

# merge wide physio dataset with reduced behavioral performance data set and turn everything into numerics apart from the descriptive first six rows
dat_physio_behav <- merge(data_physio_wide, dat_all_reduced, by = "sub_id", all.y = TRUE)
data_physio_behav <- merge(data_physio_wide, data_all_reduced, by = "sub_id", all.y = TRUE)
data_behav_vas <- merge(dat.vas, data_all_reduced, by = "sub_id", all.y = TRUE)

# time intervals in our study design: t2-t1:28 min, t3-t2: 12 min, t4-t3: 5 min, t5-t4: 15 min, t6-t5: 15 min
data_behav_vas$aucgvas1ct <- ((data_behav_vas$vas1_t2_ctrl+data_behav_vas$vas1_t1_ctrl)*28)/2 + ((data_behav_vas$vas1_t3_ctrl + data_behav_vas$vas1_t2_ctrl)*12)/2 + ((data_behav_vas$vas1_t4_ctrl + data_behav_vas$vas1_t3_ctrl)*5)/2 + ((data_behav_vas$vas1_t5_ctrl + data_behav_vas$vas1_t4_ctrl)*15)/2 + ((data_behav_vas$vas1_t6_ctrl + data_behav_vas$vas1_t5_ctrl)*15)/2
data_behav_vas$aucgvas2ct <- ((data_behav_vas$vas2_t2_ctrl+data_behav_vas$vas2_t1_ctrl)*28)/2 + ((data_behav_vas$vas2_t3_ctrl + data_behav_vas$vas2_t2_ctrl)*12)/2 + ((data_behav_vas$vas2_t4_ctrl + data_behav_vas$vas2_t3_ctrl)*5)/2 + ((data_behav_vas$vas2_t5_ctrl + data_behav_vas$vas2_t4_ctrl)*15)/2 + ((data_behav_vas$vas2_t6_ctrl + data_behav_vas$vas2_t5_ctrl)*15)/2
data_behav_vas$aucgvas3ct <- ((data_behav_vas$vas3_t2_ctrl+data_behav_vas$vas3_t1_ctrl)*28)/2 + ((data_behav_vas$vas3_t3_ctrl + data_behav_vas$vas3_t2_ctrl)*12)/2 + ((data_behav_vas$vas3_t4_ctrl + data_behav_vas$vas3_t3_ctrl)*5)/2 + ((data_behav_vas$vas3_t5_ctrl + data_behav_vas$vas3_t4_ctrl)*15)/2 + ((data_behav_vas$vas3_t6_ctrl + data_behav_vas$vas3_t5_ctrl)*15)/2

data_behav_vas$aucgvas1st <- ((data_behav_vas$vas1_t2_str+data_behav_vas$vas1_t1_str)*28)/2 + ((data_behav_vas$vas1_t3_str + data_behav_vas$vas1_t2_str)*12)/2 + ((data_behav_vas$vas1_t4_str + data_behav_vas$vas1_t3_str)*5)/2 + ((data_behav_vas$vas1_t5_str + data_behav_vas$vas1_t4_str)*15)/2 + ((data_behav_vas$vas1_t6_str + data_behav_vas$vas1_t5_str)*15)/2
data_behav_vas$aucgvas2st <- ((data_behav_vas$vas2_t2_str+data_behav_vas$vas2_t1_str)*28)/2 + ((data_behav_vas$vas2_t3_str + data_behav_vas$vas2_t2_str)*12)/2 + ((data_behav_vas$vas2_t4_str + data_behav_vas$vas2_t3_str)*5)/2 + ((data_behav_vas$vas2_t5_str + data_behav_vas$vas2_t4_str)*15)/2 + ((data_behav_vas$vas2_t6_str + data_behav_vas$vas2_t5_str)*15)/2
data_behav_vas$aucgvas3st <- ((data_behav_vas$vas3_t2_str+data_behav_vas$vas3_t1_str)*28)/2 + ((data_behav_vas$vas3_t3_str + data_behav_vas$vas3_t2_str)*12)/2 + ((data_behav_vas$vas3_t4_str + data_behav_vas$vas3_t3_str)*5)/2 + ((data_behav_vas$vas3_t5_str + data_behav_vas$vas3_t4_str)*15)/2 + ((data_behav_vas$vas3_t6_str + data_behav_vas$vas3_t5_str)*15)/2


# CHANGE HERE
# not ideal, needs to be adapted
#dat_physio_behav <- merge(data_physio_wide, dat_all_reduced, by = "sub_id", all.y = TRUE)
dat_physio_behav[,6:68] <- sapply(dat_physio_behav[,6:68],as.numeric)
data_physio_behav[,6:77] <- sapply(data_physio_behav[,6:77],as.numeric)

# convert to fully long and add marker for cortisol/amylase measurements
data_physio_long <- data_physio_clean %>% melt(data_physio_clean, id.vars=c("sub_id","condition","Gruppe","day_order"), measure.vars = c("t1_cort","t2_cort","t3_cort","t4_cort","t5_cort","t6_cort","t1_amyl","t2_amyl","t3_amyl","t4_amyl","t5_amyl","t6_amyl"), variable.name = "variable_name")
data_vas_long_unsorted <- data_behav_vas %>% melt(data_behav_vas, id.vars=c("sub_id"), measure.vars=c("vas1_t1_ctrl","vas2_t1_ctrl","vas3_t1_ctrl", "vas1_t2_ctrl","vas2_t2_ctrl","vas3_t2_ctrl","vas1_t3_ctrl","vas2_t3_ctrl","vas3_t3_ctrl", "vas1_t4_ctrl","vas2_t4_ctrl","vas3_t4_ctrl", "vas1_t5_ctrl","vas2_t5_ctrl","vas3_t5_ctrl", "vas1_t6_ctrl","vas2_t6_ctrl","vas3_t6_ctrl", "vas1_t1_str","vas2_t1_str","vas3_t1_str", "vas1_t2_str","vas2_t2_str","vas3_t2_str","vas1_t3_str","vas2_t3_str","vas3_t3_str","vas1_t4_str","vas2_t4_str","vas3_t4_str","vas1_t5_str","vas2_t5_str","vas3_t5_str","vas1_t6_str","vas2_t6_str","vas3_t6_str"), variable.name = "vas")
data_vas_long <- data_vas_long_unsorted %>% arrange(vas)

# find out how many subjects in wide dataset
n<-length(unique(data_physio_clean$sub_id))
data_physio_long$time <-rep(c(1:6),each=2*n)
data_physio_long$marker <- rep(c("cort","amyl"),each=2*6*n)

# find out how many subjects in wide dataset
num<-length(unique(data_behav_vas$sub_id))
data_vas_long$condition <-rep(c(1:2),each=18*num)
data_vas_long$time <-rep(c(1:6),each=num*3,times=2)
data_vas_long <- data_vas_long %>% arrange(sub_id)
data_vas_long$marker <- rep(c("arousal","valence","stress"),times=num*2)
data_vas_long$marker <- factor(data_vas_long$marker)


# reduce combined dataset to most relevant parts
dat_physio_behav_red =subset(dat_physio_behav, select =-c(Gruppe_control,Gruppe_stress,day_order_control,day_order_stress,excluded,t1_cort_control,t2_cort_control,t3_cort_control,t4_cort_control,t5_cort_control,t6_cort_control,t1_amyl_control,t2_amyl_control,t3_amyl_control,t4_amyl_control,t5_amyl_control,t6_amyl_control,t1_cort_stress,t2_cort_stress,t3_cort_stress,t4_cort_stress,t5_cort_stress,t6_cort_stress,t1_amyl_stress,t2_amyl_stress,t3_amyl_stress,t4_amyl_stress,t5_amyl_stress,t6_amyl_stress,p_stay_CT,p_switch_CT,p_win_stay_CT,p_win_switch_CT,p_lose_stay_CT,p_lose_switch_CT,p_stay_ST,p_switch_ST,p_win_stay_ST,p_win_switch_ST,p_lose_stay_ST,p_lose_switch_ST))
data_physio_behav_red =subset(data_physio_behav, select =-c(Gruppe_control,Gruppe_stress,day_order_control,day_order_stress,excluded,t1_cort_control,t2_cort_control,t3_cort_control,t4_cort_control,t5_cort_control,t6_cort_control,t1_amyl_control,t2_amyl_control,t3_amyl_control,t4_amyl_control,t5_amyl_control,t6_amyl_control,t1_cort_stress,t2_cort_stress,t3_cort_stress,t4_cort_stress,t5_cort_stress,t6_cort_stress,t1_amyl_stress,t2_amyl_stress,t3_amyl_stress,t4_amyl_stress,t5_amyl_stress,t6_amyl_stress,p_stay_CT,p_switch_CT,p_win_stay_CT,p_win_switch_CT,p_lose_stay_CT,p_lose_switch_CT,p_stay_ST,p_switch_ST,p_win_stay_ST,p_win_switch_ST,p_lose_stay_ST,p_lose_switch_ST))

# prepare physio/behav dataset
dat_physio_behav_red <- tibble::rowid_to_column(dat_physio_behav_red, "sub_idx")
data_physio_behav_red <- tibble::rowid_to_column(data_physio_behav_red, "sub_idx")

# UNCOMMENT THE FOLLOWING FOR NOT REMOVING 28-1B_057 (missing aucg_stress value), 17-1B015, 25-1B052, 28-1B056 (cortisol-nonresponder)
# data_physio_behav_red <- data_physio_behav_red[-c(17,25,27,28),]
# data_physio_behav_red <- data_physio_behav_red[-c(28),]

################# PREPARE BEHAV DATASETS AND MERGE WITH PHYSIO + SINGLETRIALS (both HC and AD)

#data_new_HC <- merge(data_new_HC, data_all, by = c("sub_id", "sub_idx"))

# here a final version of AUD sample is needed to decide based on sub_id which subjects should be part of single trial analyses
# dat_all <- tibble::rowid_to_column(dat_all, "sub_idx")
# data_new <- merge(data_prep_both, dat_all)

################# PREPARE PHYSIO DATASETS AND MERGE WITH SINGLE TRIALS (only HC)
# the following is not very elegant and could be done easier with one merge

## create 3 different long formats (depending on aucg_cort or zpeak_cort or zpeak_amyl)
# convert to partially (along condition) long for area under the curve by
longdat.physbehav1 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs","al_win","al_loss","bet_win","bet_loss","sc_bet_win","sc_bet_loss"),
                           # The source columns
                           measure.vars=c("aucg_control","aucg_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="aucg"
)

longdat.physbehav2 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs","al_win","al_loss","bet_win","bet_loss","sc_bet_win","sc_bet_loss"),
                           # The source columns
                           measure.vars=c("z.peak_cort_control","z.peak_cort_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="zpeak"
)

longdat.physbehav3 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs","al_win","al_loss","bet_win","bet_loss","sc_bet_win","sc_bet_loss"),
                           # The source columns
                           measure.vars=c("z.peak_amyl_control","z.peak_amyl_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="zpeak_amyl"
)

# prepare partially long format
# longdat.physbehav1$cond <- factor(longdat.physbehav1$cond) 
# longdat.physbehav2$cond <- factor(longdat.physbehav2$cond) 
# longdat.physbehav3$cond <- factor(longdat.physbehav3$cond) 

# careful here ggpubr can prevent the recoding to work!! detach before -> this needs a long-term solution
longdat.physbehav1 <- longdat.physbehav1 %>% mutate(cond=recode(cond, `aucg_control`="control", `aucg_stress`="stress"))
longdat.physbehav2 <- longdat.physbehav2 %>% mutate(cond=recode(cond, `z.peak_cort_control`="control", `z.peak_cort_stress`="stress"))
longdat.physbehav3 <- longdat.physbehav3 %>% mutate(cond=recode(cond, `z.peak_amyl_control`="control", `z.peak_amyl_stress`="stress"))

longdat.physbehav1 <- longdat.physbehav1 %>% rename(Cond = cond)
longdat.physbehav2 <- longdat.physbehav2 %>% rename(Cond = cond)
longdat.physbehav3 <- longdat.physbehav3 %>% rename(Cond = cond)

longdat.physbehav1$sub_idx <- factor(longdat.physbehav1$sub_idx)
longdat.physbehav2$sub_idx <- factor(longdat.physbehav2$sub_idx)
longdat.physbehav3$sub_idx <- factor(longdat.physbehav3$sub_idx)

data_prep$sub_id <- str_remove(data_prep$sub_id, "[_]")


## UNCOMMENT/COMMENT NEXT ROWS (depending on aucg_cort or zpeak_cort or zpeak_amyl)
data_new_HC <- data_prep %>% right_join(longdat.physbehav1, by=c("sub_id","sub_idx","Cond"))
#data_new_HC <- data_prep.HC %>% right_join(longdat.physbehav2, by=c("sub_id","sub_idx","Cond"))
#data_new_HC <- data_prep.HC %>% right_join(longdat.physbehav3, by=c("sub_id","sub_idx","Cond"))

data_new_HC$Cond <- factor(data_new_HC$Cond)

# now save necessary scripts for hierarchical analyses
# save(file='/cloud/project/dataframes/data_new.rda',data_new)
save(file='/cloud/project/dataframes/data_new_HC.rda',data_new_HC)
save(file='/cloud/project/dataframes/data_physio_long.rda',data_physio_long)

save(file='/cloud/project/dataframes/dat_physio_behav.rda',data_new_HC)
save(file='/cloud/project/dataframes/dat_physio_behav.rda',dat_physio_behav)
save(file='/cloud/project/dataframes/data_physio_behav.rda',data_physio_behav)
save(file='/cloud/project/dataframes/dat_physio_behav_red.rda',dat_physio_behav_red)
save(file='/cloud/project/dataframes/data_physio_behav_red.rda',data_physio_behav_red)
save(file='/cloud/project/dataframes/data_vas_long.rda',data_vas_long)
save(file='/cloud/project/dataframes/data_behav_vas.rda',data_behav_vas)


rm(dat.vas)
rm(data_behav_vas)
rm(dat_physio_behav)
rm(dat_all_reduced)
rm(data_all_reduced)
rm(longdat.physbehav1)
rm(longdat.physbehav2)
rm(longdat.physbehav3)
