# prepare behavioral data (dat_all) for merge by reducing unnecessary columns
# CHANGE HERE to dat_all_reduced
dat_all_reduced = subset(dat_all, select =-c(p_RT_pre_CT,p_RT_rev_CT,p_RT_post_CT,p_correct_pre_CT,p_correct_rev_CT,p_correct_post_CT,p_stay_pre_CT,p_stay_rev_CT,p_stay_post_CT,p_sw_pre_CT,p_sw_rev_CT,p_sw_post_CT,p_w_st_pre_CT,p_w_st_rev_CT,p_w_st_post_CT,p_l_sw_pre_CT,p_l_sw_rev_CT,p_l_sw_post_CT, p_RT_pre_ST,p_RT_rev_ST,p_RT_post_ST,p_correct_pre_ST,p_correct_rev_ST,p_correct_post_ST,p_stay_pre_ST,p_stay_rev_ST,p_stay_post_ST,p_sw_pre_ST,p_sw_rev_ST,p_sw_post_ST,p_w_st_pre_ST,p_w_st_rev_ST,p_w_st_post_ST,p_l_sw_pre_ST,p_l_sw_rev_ST,p_l_sw_post_ST))

# merge cortisol data with dat by sub_id
names(data_wide)[names(data_wide) == "VpNr"] <- "sub_id"
names(data_physio_clean)[names(data_physio_clean) == "VpNr"] <- "sub_id"
data_wide$sub_id <- as.character(data_wide$sub_id)

#CHANGE HERE
dat_all_reduced$sub_id <- str_remove(dat_all_reduced$sub_id, "[_]")
data_all$sub_id <- str_remove(data_all$sub_id, "[_]")

# merge wide physio dataset with reduced behavioral performance data set and turn everything into numerics apart from the descriptive first six rows
dat_physio_behav <- merge(data_wide, data_all, by = "sub_id", all.y = TRUE)

#CHANGE HERE
#dat_physio_behav <- merge(data_wide, dat_all_reduced, by = "sub_id", all.y = TRUE)
dat_physio_behav[,6:65] <- sapply(dat_physio_behav[,6:65],as.numeric)

# convert to fully long by 
data_physio_long <- data_physio_clean %>% melt(data_physio_clean, id.vars=c("sub_id","condition","Gruppe","day_order"), measure.vars = c("t1_cort","t2_cort","t3_cort","t4_cort","t5_cort","t6_cort","t1_amyl","t2_amyl","t3_amyl","t4_amyl","t5_amyl","t6_amyl"), variable.name = "variable_name")
n<-length(unique(data_physio_clean$sub_id))
data_physio_long$time <-rep(c(1:6),each=2*n)
data_physio_long$marker <- rep(c("cort","amyl"),each=2*6*n)

# reduce combined dataset to most relevant parts
data_physio_behav_red =subset(dat_physio_behav, select =-c(Gruppe_control,Gruppe_stress,day_order_control,day_order_stress,excluded,t1_cort_control,t2_cort_control,t3_cort_control,t4_cort_control,t5_cort_control,t6_cort_control,t1_amyl_control,t2_amyl_control,t3_amyl_control,t4_amyl_control,t5_amyl_control,t6_amyl_control,t1_cort_stress,t2_cort_stress,t3_cort_stress,t4_cort_stress,t5_cort_stress,t6_cort_stress,t1_amyl_stress,t2_amyl_stress,t3_amyl_stress,t4_amyl_stress,t5_amyl_stress,t6_amyl_stress,p_correct_CT,p_stay_CT,p_switch_CT,p_win_stay_CT,p_win_switch_CT,p_lose_stay_CT,p_lose_switch_CT,mean_RT_ST,mean_RT_CT,p_correct_ST,p_stay_ST,p_switch_ST,p_win_stay_ST,p_win_switch_ST,p_lose_stay_ST,p_lose_switch_ST))

# prepare physio/behav dataset
data_physio_behav_red <- tibble::rowid_to_column(data_physio_behav_red, "sub_idx")

# the following has to be done to match subject ids to single data trialset (which ranges from 2-29, after 1A001 was dropped)
data_physio_behav_red <- data_physio_behav_red %>% mutate(sub_idx = data_physio_behav_red$sub_idx+1)


# convert to partially (along condition) long for area under the curve by
longdat.physbehav1 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs"),
                           # The source columns
                           measure.vars=c("aucg_control","aucg_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="aucg"
)

longdat.physbehav2 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs"),
                           # The source columns
                           measure.vars=c("z.peak_cort_control","z.peak_cort_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="zpeak"
)

longdat.physbehav3 <- melt(data_physio_behav_red,
                           # ID variables - all the variables to keep but not split apart on
                           id.vars=c("sub_idx","sub_id","order","age","weight","height","education","tmt_a","tmt_b","dsst","num_forward","num_backward","BIS_total","IQ_WST","school_yrs"),
                           # The source columns
                           measure.vars=c("z.peak_amyl_control","z.peak_amyl_stress"),
                           # Name of the destination column that will identify the original
                           # column that the measurement came from
                           variable.name="cond",
                           value.name="zpeak_amyl"
)

# prepare partially long format
longdat.physbehav1$cond <- factor(longdat.physbehav1$cond) 
longdat.physbehav2$cond <- factor(longdat.physbehav2$cond) 
longdat.physbehav3$cond <- factor(longdat.physbehav3$cond) 

#longdat.physbehav$cond <- factor(longdat.physbehav$cond, c('aucg_control', 'aucg_stress'), c(1,2))
# ACHTUNG plyr makes sourcing prep_agg crash
library(plyr)
longdat.physbehav1$Cond <- revalue(longdat.physbehav1$cond, c("aucg_control"="control", "aucg_stress"="stress"))
longdat.physbehav2$Cond <- revalue(longdat.physbehav2$cond, c("z.peak_cort_control"="control", "z.peak_cort_stress"="stress"))
longdat.physbehav3$Cond <- revalue(longdat.physbehav3$cond, c("z.peak_amyl_control"="control", "z.peak_amyl_stress"="stress"))

longdat.physbehav1$sub_idx <- factor(longdat.physbehav1$sub_idx)
longdat.physbehav2$sub_idx <- factor(longdat.physbehav2$sub_idx)
longdat.physbehav3$sub_idx <- factor(longdat.physbehav3$sub_idx)

# prepare single trial dataset
data_prep.HC <- data_prep %>% filter(Group == "HC")
data_prep.AD <- data_prep %>% filter(Group == "AUD")

## UNCOMMENT/COMMENT NEXT ROWS (depending on aucg or zpeak)
#data_new_HC <- data_prep.HC %>% right_join(longdat.physbehav1, by=c("sub_idx","Cond"))
#data_new_HC <- data_prep.HC %>% right_join(longdat.physbehav2, by=c("sub_idx","Cond"))
data_new_HC <- data_prep.HC %>% right_join(longdat.physbehav3, by=c("sub_idx","Cond"))

data_new_HC$Cond <- factor(data_new_HC$Cond)

######################## OR THE ABOVE FOR WHOLE DATASET (dat_complete)#####################
# lateron: add physio stuff for AD as well

dat <- tibble::rowid_to_column(dat, "sub_idx")
data_new <- merge(data_prep, dat)

