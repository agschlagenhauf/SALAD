#### Reversal Sensitivity Analysis

rm(list=ls())

library('dplyr')
library('ggplot2')

load('/cloud/project/dataframes/data_prep.rda')

df <- filter(data_prep,Trial_idx %in% c(50:60,120:130))