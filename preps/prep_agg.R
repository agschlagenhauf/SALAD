library(dplyr)
################# NECESSARY TO RUN THIS FOR longtowide_agg.R AND LATER RMANOVA ANALYSES ###########

# get necessary datasets saved from data_import script
load('/cloud/project/dataframes/dat.rda')
load('/cloud/project/dataframes/data.rda')
load('/cloud/project/dataframes/dat.nooutlier.rda')

# prepare data first: p_correct_T1 needs to be turned into p_correct_CT and P_correct_T2 into P_Correct_S for order = 1(A)

# subset data for order (A=CT-ST,B=ST-CT)
dat.order.A <- subset(dat.nooutlier, order == "1")
dat.order.B <- subset(dat.nooutlier, order == "2")

dat.order.CTST <- dat.order.A %>% 
  
  rename(mean_RT_CT = mean_RT_T1) %>% 
  rename(p_correct_CT = p_correct_T1) %>% 
  rename(p_stay_CT = p_stay_T1) %>% 
  rename(p_switch_CT = p_switch_T1) %>%
  rename(p_win_stay_CT = p_win_stay_T1) %>% 
  rename(p_win_switch_CT = p_win_switch_T1) %>% 
  rename(p_lose_stay_CT = p_lose_stay_T1) %>% 
  rename(p_lose_switch_CT = p_lose_switch_T1) %>% 
  
  rename(mean_RT_ST = mean_RT_T2) %>% 
  rename(p_correct_ST = p_correct_T2) %>% 
  rename(p_stay_ST = p_stay_T2) %>% 
  rename(p_switch_ST = p_switch_T2) %>% 
  rename(p_win_stay_ST = p_win_stay_T2) %>% 
  rename(p_win_switch_ST = p_win_switch_T2) %>% 
  rename(p_lose_stay_ST = p_lose_stay_T2) %>% 
  rename(p_lose_switch_ST = p_lose_switch_T2) %>%
  
  rename(p_RT_pre_CT = p_RT_pre_T1) %>% 
  rename(p_RT_rev_CT = p_RT_rev_T1) %>% 
  rename(p_RT_post_CT = p_RT_post_T1) %>% 
  rename(p_correct_pre_CT = p_correct_pre_T1) %>% 
  rename(p_correct_rev_CT = p_correct_rev_T1) %>% 
  rename(p_correct_post_CT = p_correct_post_T1) %>% 
  rename(p_stay_pre_CT = p_stay_pre_T1) %>% 
  rename(p_stay_rev_CT = p_stay_rev_T1) %>% 
  rename(p_stay_post_CT = p_stay_post_T1) %>% 
  rename(p_sw_pre_CT = p_sw_pre_T1) %>% 
  rename(p_sw_rev_CT = p_sw_rev_T1) %>% 
  rename(p_sw_post_CT = p_sw_post_T1) %>% 
  rename(p_w_st_pre_CT = p_w_st_pre_T1) %>% 
  rename(p_w_st_rev_CT = p_w_st_rev_T1) %>% 
  rename(p_w_st_post_CT = p_w_st_post_T1) %>% 
  rename(p_l_sw_pre_CT = p_l_sw_pre_T1) %>% 
  rename(p_l_sw_rev_CT = p_l_sw_rev_T1) %>% 
  rename(p_l_sw_post_CT = p_l_sw_post_T1) %>% 
  
  rename(p_RT_pre_ST = p_RT_pre_T2) %>% 
  rename(p_RT_rev_ST = p_RT_rev_T2) %>% 
  rename(p_RT_post_ST = p_RT_post_T2) %>% 
  rename(p_correct_pre_ST = p_correct_pre_T2) %>% 
  rename(p_correct_rev_ST = p_correct_rev_T2) %>% 
  rename(p_correct_post_ST = p_correct_post_T2) %>%
  rename(p_stay_pre_ST = p_stay_pre_T2) %>% 
  rename(p_stay_rev_ST = p_stay_rev_T2) %>% 
  rename(p_stay_post_ST = p_stay_post_T2) %>% 
  rename(p_sw_pre_ST = p_sw_pre_T2) %>% 
  rename(p_sw_rev_ST = p_sw_rev_T2) %>% 
  rename(p_sw_post_ST = p_sw_post_T2) %>% 
  rename(p_w_st_pre_ST = p_w_st_pre_T2) %>% 
  rename(p_w_st_rev_ST = p_w_st_rev_T2) %>% 
  rename(p_w_st_post_ST = p_w_st_post_T2) %>% 
  rename(p_l_sw_pre_ST = p_l_sw_pre_T2) %>% 
  rename(p_l_sw_rev_ST = p_l_sw_rev_T2) %>% 
  rename(p_l_sw_post_ST = p_l_sw_post_T2)

# and the other way around for order = 2(B)

dat.order.STCT <- dat.order.B %>% 
  
  rename(mean_RT_CT = mean_RT_T2) %>% 
  rename(p_correct_CT = p_correct_T2) %>% 
  rename(p_stay_CT = p_stay_T2) %>% 
  rename(p_switch_CT = p_switch_T2) %>%
  rename(p_win_stay_CT = p_win_stay_T2) %>% 
  rename(p_win_switch_CT = p_win_switch_T2) %>% 
  rename(p_lose_stay_CT = p_lose_stay_T2) %>% 
  rename(p_lose_switch_CT = p_lose_switch_T2) %>% 
  
  rename(mean_RT_ST = mean_RT_T1) %>% 
  rename(p_correct_ST = p_correct_T1) %>% 
  rename(p_stay_ST = p_stay_T1) %>% 
  rename(p_switch_ST = p_switch_T1) %>% 
  rename(p_win_stay_ST = p_win_stay_T1) %>% 
  rename(p_win_switch_ST = p_win_switch_T1) %>% 
  rename(p_lose_stay_ST = p_lose_stay_T1) %>% 
  rename(p_lose_switch_ST = p_lose_switch_T1) %>%
  
  rename(p_RT_pre_CT = p_RT_pre_T2) %>% 
  rename(p_RT_rev_CT = p_RT_rev_T2) %>% 
  rename(p_RT_post_CT = p_RT_post_T2) %>% 
  rename(p_correct_pre_CT = p_correct_pre_T2) %>% 
  rename(p_correct_rev_CT = p_correct_rev_T2) %>% 
  rename(p_correct_post_CT = p_correct_post_T2) %>% 
  rename(p_stay_pre_CT = p_stay_pre_T2) %>% 
  rename(p_stay_rev_CT = p_stay_rev_T2) %>% 
  rename(p_stay_post_CT = p_stay_post_T2) %>% 
  rename(p_sw_pre_CT = p_sw_pre_T2) %>% 
  rename(p_sw_rev_CT = p_sw_rev_T2) %>% 
  rename(p_sw_post_CT = p_sw_post_T2) %>% 
  rename(p_w_st_pre_CT = p_w_st_pre_T2) %>% 
  rename(p_w_st_rev_CT = p_w_st_rev_T2) %>% 
  rename(p_w_st_post_CT = p_w_st_post_T2) %>% 
  rename(p_l_sw_pre_CT = p_l_sw_pre_T2) %>% 
  rename(p_l_sw_rev_CT = p_l_sw_rev_T2) %>% 
  rename(p_l_sw_post_CT = p_l_sw_post_T2) %>% 
  
  rename(p_RT_pre_ST = p_RT_pre_T1) %>% 
  rename(p_RT_rev_ST = p_RT_rev_T1) %>% 
  rename(p_RT_post_ST = p_RT_post_T1) %>% 
  rename(p_correct_pre_ST = p_correct_pre_T1) %>% 
  rename(p_correct_rev_ST = p_correct_rev_T1) %>% 
  rename(p_correct_post_ST = p_correct_post_T1) %>% 
  rename(p_stay_pre_ST = p_stay_pre_T1) %>% 
  rename(p_stay_rev_ST = p_stay_rev_T1) %>% 
  rename(p_stay_post_ST = p_stay_post_T1) %>% 
  rename(p_sw_pre_ST = p_sw_pre_T1) %>% 
  rename(p_sw_rev_ST = p_sw_rev_T1) %>% 
  rename(p_sw_post_ST = p_sw_post_T1) %>% 
  rename(p_w_st_pre_ST = p_w_st_pre_T1) %>% 
  rename(p_w_st_rev_ST = p_w_st_rev_T1) %>% 
  rename(p_w_st_post_ST = p_w_st_post_T1) %>% 
  rename(p_l_sw_pre_ST = p_l_sw_pre_T1) %>% 
  rename(p_l_sw_rev_ST = p_l_sw_rev_T1) %>% 
  rename(p_l_sw_post_ST = p_l_sw_post_T1)

# merge them back together and clean WS
dat_all <- bind_rows(dat.order.CTST,dat.order.STCT)

rm(dat.order.CTST)
rm(dat.order.STCT)
rm(dat.order.A)
rm(dat.order.B)

########################### NOW THE SAME FOR DATA #######################

## NECESSARY TO RUN THIS FOR LATER RMANOVA ANALYSES
# prepare data first: p_correct_T1 needs to be turned into p_correct_CT and P_correct_T2 into P_Correct_S for order = 1(A)

# subset data for order (A=CT-ST,B=ST-CT)
data.order.A <- subset(data, order == "1")
data.order.B <- subset(data, order == "2")

data.order.CTST <- data.order.A %>% 
  
  rename(mean_RT_CT = mean_RT_T1) %>% 
  rename(p_correct_CT = p_correct_T1) %>% 
  rename(p_stay_CT = p_stay_T1) %>% 
  rename(p_switch_CT = p_switch_T1) %>%
  rename(p_win_stay_CT = p_win_stay_T1) %>% 
  rename(p_win_switch_CT = p_win_switch_T1) %>% 
  rename(p_lose_stay_CT = p_lose_stay_T1) %>% 
  rename(p_lose_switch_CT = p_lose_switch_T1) %>% 
  
  rename(mean_RT_ST = mean_RT_T2) %>% 
  rename(p_correct_ST = p_correct_T2) %>% 
  rename(p_stay_ST = p_stay_T2) %>% 
  rename(p_switch_ST = p_switch_T2) %>% 
  rename(p_win_stay_ST = p_win_stay_T2) %>% 
  rename(p_win_switch_ST = p_win_switch_T2) %>% 
  rename(p_lose_stay_ST = p_lose_stay_T2) %>% 
  rename(p_lose_switch_ST = p_lose_switch_T2) %>%
  
  rename(p_RT_pre_CT = p_RT_pre_T1) %>% 
  rename(p_RT_rev_CT = p_RT_rev_T1) %>% 
  rename(p_RT_post_CT = p_RT_post_T1) %>% 
  rename(p_correct_pre_CT = p_correct_pre_T1) %>% 
  rename(p_correct_rev_CT = p_correct_rev_T1) %>% 
  rename(p_correct_post_CT = p_correct_post_T1) %>% 
  rename(p_stay_pre_CT = p_stay_pre_T1) %>% 
  rename(p_stay_rev_CT = p_stay_rev_T1) %>% 
  rename(p_stay_post_CT = p_stay_post_T1) %>% 
  rename(p_sw_pre_CT = p_sw_pre_T1) %>% 
  rename(p_sw_rev_CT = p_sw_rev_T1) %>% 
  rename(p_sw_post_CT = p_sw_post_T1) %>% 
  rename(p_w_st_pre_CT = p_w_st_pre_T1) %>% 
  rename(p_w_st_rev_CT = p_w_st_rev_T1) %>% 
  rename(p_w_st_post_CT = p_w_st_post_T1) %>% 
  rename(p_l_sw_pre_CT = p_l_sw_pre_T1) %>% 
  rename(p_l_sw_rev_CT = p_l_sw_rev_T1) %>% 
  rename(p_l_sw_post_CT = p_l_sw_post_T1) %>% 
  
  rename(p_RT_pre_ST = p_RT_pre_T2) %>% 
  rename(p_RT_rev_ST = p_RT_rev_T2) %>% 
  rename(p_RT_post_ST = p_RT_post_T2) %>% 
  rename(p_correct_pre_ST = p_correct_pre_T2) %>% 
  rename(p_correct_rev_ST = p_correct_rev_T2) %>% 
  rename(p_correct_post_ST = p_correct_post_T2) %>%
  rename(p_stay_pre_ST = p_stay_pre_T2) %>% 
  rename(p_stay_rev_ST = p_stay_rev_T2) %>% 
  rename(p_stay_post_ST = p_stay_post_T2) %>% 
  rename(p_sw_pre_ST = p_sw_pre_T2) %>% 
  rename(p_sw_rev_ST = p_sw_rev_T2) %>% 
  rename(p_sw_post_ST = p_sw_post_T2) %>% 
  rename(p_w_st_pre_ST = p_w_st_pre_T2) %>% 
  rename(p_w_st_rev_ST = p_w_st_rev_T2) %>% 
  rename(p_w_st_post_ST = p_w_st_post_T2) %>% 
  rename(p_l_sw_pre_ST = p_l_sw_pre_T2) %>% 
  rename(p_l_sw_rev_ST = p_l_sw_rev_T2) %>% 
  rename(p_l_sw_post_ST = p_l_sw_post_T2)

# and the other way around for order = 2(B)

data.order.STCT <- data.order.B %>% 
  
  rename(mean_RT_CT = mean_RT_T2) %>% 
  rename(p_correct_CT = p_correct_T2) %>% 
  rename(p_stay_CT = p_stay_T2) %>% 
  rename(p_switch_CT = p_switch_T2) %>%
  rename(p_win_stay_CT = p_win_stay_T2) %>% 
  rename(p_win_switch_CT = p_win_switch_T2) %>% 
  rename(p_lose_stay_CT = p_lose_stay_T2) %>% 
  rename(p_lose_switch_CT = p_lose_switch_T2) %>% 
  
  rename(mean_RT_ST = mean_RT_T1) %>% 
  rename(p_correct_ST = p_correct_T1) %>% 
  rename(p_stay_ST = p_stay_T1) %>% 
  rename(p_switch_ST = p_switch_T1) %>% 
  rename(p_win_stay_ST = p_win_stay_T1) %>% 
  rename(p_win_switch_ST = p_win_switch_T1) %>% 
  rename(p_lose_stay_ST = p_lose_stay_T1) %>% 
  rename(p_lose_switch_ST = p_lose_switch_T1) %>%
  
  rename(p_RT_pre_CT = p_RT_pre_T2) %>% 
  rename(p_RT_rev_CT = p_RT_rev_T2) %>% 
  rename(p_RT_post_CT = p_RT_post_T2) %>% 
  rename(p_correct_pre_CT = p_correct_pre_T2) %>% 
  rename(p_correct_rev_CT = p_correct_rev_T2) %>% 
  rename(p_correct_post_CT = p_correct_post_T2) %>% 
  rename(p_stay_pre_CT = p_stay_pre_T2) %>% 
  rename(p_stay_rev_CT = p_stay_rev_T2) %>% 
  rename(p_stay_post_CT = p_stay_post_T2) %>% 
  rename(p_sw_pre_CT = p_sw_pre_T2) %>% 
  rename(p_sw_rev_CT = p_sw_rev_T2) %>% 
  rename(p_sw_post_CT = p_sw_post_T2) %>% 
  rename(p_w_st_pre_CT = p_w_st_pre_T2) %>% 
  rename(p_w_st_rev_CT = p_w_st_rev_T2) %>% 
  rename(p_w_st_post_CT = p_w_st_post_T2) %>% 
  rename(p_l_sw_pre_CT = p_l_sw_pre_T2) %>% 
  rename(p_l_sw_rev_CT = p_l_sw_rev_T2) %>% 
  rename(p_l_sw_post_CT = p_l_sw_post_T2) %>% 
  
  rename(p_RT_pre_ST = p_RT_pre_T1) %>% 
  rename(p_RT_rev_ST = p_RT_rev_T1) %>% 
  rename(p_RT_post_ST = p_RT_post_T1) %>% 
  rename(p_correct_pre_ST = p_correct_pre_T1) %>% 
  rename(p_correct_rev_ST = p_correct_rev_T1) %>% 
  rename(p_correct_post_ST = p_correct_post_T1) %>% 
  rename(p_stay_pre_ST = p_stay_pre_T1) %>% 
  rename(p_stay_rev_ST = p_stay_rev_T1) %>% 
  rename(p_stay_post_ST = p_stay_post_T1) %>% 
  rename(p_sw_pre_ST = p_sw_pre_T1) %>% 
  rename(p_sw_rev_ST = p_sw_rev_T1) %>% 
  rename(p_sw_post_ST = p_sw_post_T1) %>% 
  rename(p_w_st_pre_ST = p_w_st_pre_T1) %>% 
  rename(p_w_st_rev_ST = p_w_st_rev_T1) %>% 
  rename(p_w_st_post_ST = p_w_st_post_T1) %>% 
  rename(p_l_sw_pre_ST = p_l_sw_pre_T1) %>% 
  rename(p_l_sw_rev_ST = p_l_sw_rev_T1) %>% 
  rename(p_l_sw_post_ST = p_l_sw_post_T1)

# merge them back together and clean WS
data_all <- bind_rows(data.order.CTST,data.order.STCT)

rm(data.order.CTST)
rm(data.order.STCT)
rm(data.order.A)
rm(data.order.B)

save(file='/cloud/project/dataframes/dat_all.rda', dat_all)
save(file='/cloud/project/dataframes/data_all.rda',data_all)

rm(dat)
rm(data)
rm(dat.nooutlier)