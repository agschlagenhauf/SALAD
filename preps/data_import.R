################# ALL DATA FOR AGGREGATED + SINGLE TRIAL ANALYSES IMPORTED HERE ###########

# adapt path to data you want to import: operant_sample1 uses our extraction method, operant sample1_diff uses Zsuzsi's
extrac_file <- "data_sum/operant_sample1.csv"
extrac_file_1 <- "data_sum/operant_sample1_modeling.csv"
extrac_file_2 <- "data_sum/operant_sample1_diffstay.csv"

# adapt path to data you want to import, sing_trial_file_2 should be used because it includes C from Matlab
sing_trial_file <- "hierarchical/operant_sample1_singletrial.csv"
sing_trial_file_2 <- "hierarchical/operant_sample1_singtrial_wC.csv"
sing_trial_file_3 <- "hierarchical/operant_sample1_singtrial_wC_wo1A001.csv"
sing_trial_file_4 <- "hierarchical/operant_sample1_singtrial_wC_wo1A001_wRT.csv"

# import data, set missings (999) to NA and turn into tibble
dat_imported <- read_csv2(extrac_file_2,na = c("999", "NA"))
data_imported <- read.csv(extrac_file_1, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat <- as_tibble(dat_imported)
data <- as_tibble(data_imported)
rm(dat_imported)
rm(data_imported)

# import single trial dataset
data_strials <- read_csv(sing_trial_file_4,na = c("999", "NA"))

# create datasets with only complete subjects or removed outliers (according to < 55% p_correct in all trials or 1/3 phases)
#dat_physio <- dat_physio %>% subset(dat_physio$operant_inclusion=="1")
# dat_complete <- na.omit(dat)
# 
# dat.outlier.T1 <- dat %>% filter(p_correct_T1 < .55)
# dat.outlier.T2 <- dat %>% filter(p_correct_T2 < .55)

dat.nooutlier <- dat %>% filter(p_correct_T1 > .55) %>% filter(p_correct_T2 > .55)