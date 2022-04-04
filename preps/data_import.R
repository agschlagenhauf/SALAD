library(readxl)
library(lme4)
library(reshape2)
library(dplyr)
library(foreign)

################# ALL DATA FOR BEHAV/AGGREGATED/fMRI ANALYSES IMPORTED HERE ###########

# adapt path to data you want to import: operant_sample1 uses our extraction method, operant sample1_diff uses Zsuzsi's, operant_sample1_modeling includes modeling parameter
extrac_file <- "data_sum/operant_sample1.csv"
extrac_file_1 <- "data_sum/operant_sample1_modeling.csv"
extrac_file_2 <- "data_sum/operant_sample1_diffstay.csv"

param_file <- "data_sum/SALAD_bothCond_scaling_DU_tr_subj_loglik.csv"

spss_file <- "data_sum/SPSS/SALAD_Data.sav"

voi_file <- "fmri/fmri_VOIvals.csv"
ins_file <- "fmri/fmri_insvals.csv"

vstr_file <- "fmri/fmri_win_maineff.csv"


# import data, set missings (999) to NA and turn into tibble
dat_imported <- read_csv2(extrac_file_2,na = c("999", "NA"))
data_imported <- read.csv(extrac_file_1, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat <- as_tibble(dat_imported)
data <- as_tibble(data_imported)

dat_voi <- read.csv(voi_file,header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat.voi <- as_tibble(dat_voi)

dat_ins <- read.csv(ins_file,header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat.ins <- as_tibble(dat_ins)

dat_win <- read.csv(vstr_file,header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat.win <- as_tibble(dat_win)

# import only modeling params
data_params <-  read_csv(param_file,na = c("NA"))

# import large spss file for vas scale
dat.vas.raw <- read.spss(spss_file, use.value.label=TRUE, to.data.frame=TRUE)

dat.vas <- dat.vas.raw %>% select(VpNr,vas1_t1_ctrl,vas2_t1_ctrl,vas3_t1_ctrl, vas1_t2_ctrl,vas2_t2_ctrl,vas3_t2_ctrl,vas1_t3_ctrl,vas2_t3_ctrl,vas3_t3_ctrl, vas1_t4_ctrl,vas2_t4_ctrl,vas3_t4_ctrl, vas1_t5_ctrl,vas2_t5_ctrl,vas3_t5_ctrl, vas1_t6_ctrl,vas2_t6_ctrl,vas3_t6_ctrl, vas1_t1_str,vas2_t1_str,vas3_t1_str, vas1_t2_str,vas2_t2_str,vas3_t2_str,vas1_t3_str,vas2_t3_str,vas3_t3_str, vas1_t4_str,vas2_t4_str,vas3_t4_str, vas1_t5_str,vas2_t5_str,vas3_t5_str, vas1_t6_str,vas2_t6_str,vas3_t6_str)

# create datasets with only complete subjects or removed outliers (according to < 55% p_correct in all trials)
# dat_physio <- dat_physio %>% subset(dat_physio$operant_inclusion=="1")
# dat_complete <- na.omit(dat)
# 
dat.outlier.T1 <- dat %>% filter(p_correct_T1 < .55)
dat.outlier.T2 <- dat %>% filter(p_correct_T2 < .55)

dat.nooutlier <- dat %>% filter(p_correct_T1 > .55) %>% filter(p_correct_T2 > .55)

# save behavioral data and modeling parameters for later use
save(file='/cloud/project/dataframes/dat.rda',dat)
save(file='/cloud/project/dataframes/data.rda',data)
save(file='/cloud/project/dataframes/data_params.rda', data_params)
save(file='/cloud/project/dataframes/dat.nooutlier.rda',dat.nooutlier)
save(file='/cloud/project/dataframes/dat.vas.rda',dat.vas)
save(file='/cloud/project/dataframes/dat.voi.rda',dat.voi)
save(file='/cloud/project/dataframes/dat.ins.rda',dat.ins)
save(file='/cloud/project/dataframes/dat.win.rda',dat.win)


rm(dat_imported)
rm(data_imported)
rm(dat)
rm(data)
rm(data_params)
rm(dat.nooutlier)
rm(dat.vas)
rm(dat.vas.raw)
rm(dat_voi)
rm(dat.voi)