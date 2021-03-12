library(readxl)
library(lme4)
library(reshape2)
library(dplyr)

################# ALL DATA FOR BEHAVIORAL/AGGREGATED ANALYSES IMPORTED HERE ###########

# adapt path to data you want to import: operant_sample1 uses our extraction method, operant sample1_diff uses Zsuzsi's, operant_sample1_modeling includes modeling parameter
extrac_file <- "data_sum/operant_sample1.csv"
extrac_file_1 <- "data_sum/operant_sample1_modeling.csv"
extrac_file_2 <- "data_sum/operant_sample1_diffstay.csv"

param_file <- "data_sum/SALAD_bothCond_scaling_DU_tr.csv"

# import data, set missings (999) to NA and turn into tibble
dat_imported <- read_csv2(extrac_file_2,na = c("999", "NA"))
data_imported <- read.csv(extrac_file_1, header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE)
dat <- as_tibble(dat_imported)
data <- as_tibble(data_imported)

# import only modeling params
data_params <-  read_csv(param_file,na = c("NA"))

# create datasets with only complete subjects or removed outliers (according to < 55% p_correct in all trials)
# dat_physio <- dat_physio %>% subset(dat_physio$operant_inclusion=="1")
# dat_complete <- na.omit(dat)
# 
# dat.outlier.T1 <- dat %>% filter(p_correct_T1 < .55)
# dat.outlier.T2 <- dat %>% filter(p_correct_T2 < .55)

dat.nooutlier <- dat %>% filter(p_correct_T1 > .55) %>% filter(p_correct_T2 > .55)

# save behavioral data and modeling parameters for later use
save(file='/cloud/project/dataframes/dat.rda',dat)
save(file='/cloud/project/dataframes/data.rda',data)
save(file='/cloud/project/dataframes/data_params.rda', data_params)
save(file='/cloud/project/dataframes/dat.nooutlier.rda',dat.nooutlier)

rm(dat_imported)
rm(data_imported)
rm(dat)
rm(data)
rm(data_params)
rm(dat.nooutlier)