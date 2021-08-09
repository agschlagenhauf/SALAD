library(readxl)
library(lme4)
library(reshape2)
library(dplyr)
library(lubridate)
library(foreign)

################# ALL DATA FOR CORTISOL ANALYSES IMPORTED HERE ###########
################### NECESSARY TO RUN FOR SALAD_cortisol_modeling (Cortisol Analyses) ###################

cort_file <- "data_sum/SPSS/Longitudinal_cortisol_ALL_Okt2016.sav"
time_file <- "data_sum/zeitablauf_selection_long.csv"

# import cortisol data 
cort_data <- read.spss(cort_file, use.value.label=TRUE, to.data.frame=TRUE)

# clean unnecessary columns from physio data
data_physio_clean = subset(cort_data, select = -c(sjn,VpNr_numeric,VpOrder,filter_.,operant_inclusion, operant_excl_reason,OPERA0,OPERA1,OPERA2,Comments,COMME0,COMME1,COMME2) )
#data_physio_clean <- na.omit(data_physio_clean)

# import individual time points of cortisol data, there are no NA (but how would one deal with those?)
data_time <-  read_csv(time_file)

# merge time selection dataset with cort dataset (both in long format)

data_cort_time <- merge.data.frame(data_time,data_physio_clean,by=c('VpNr','condition'),all=TRUE)

# time intervals in our study design: t2-t1:28 min, t3-t2: 12 min, t4-t3: 5 min, t5-t4: 15 min, t6-t5: 15 min
data_physio_clean$aucg <- ((data_physio_clean$t2_cort+data_physio_clean$t1_cort)*28)/2 + ((data_physio_clean$t3_cort + data_physio_clean$t2_cort)*12)/2 + ((data_physio_clean$t4_cort + data_physio_clean$t3_cort)*5)/2 + ((data_physio_clean$t5_cort + data_physio_clean$t4_cort)*15)/2 + ((data_physio_clean$t6_cort + data_physio_clean$t5_cort)*15)/2

data_physio_clean$indivaucg <- ((data_physio_clean$t2_cort+data_physio_clean$t1_cort)*difftime(data_cort_time$T2,data_cort_time$T1,units='mins'))/2 + ((data_physio_clean$t3_cort + data_physio_clean$t2_cort)*difftime(data_cort_time$T3,data_cort_time$T2,units='mins'))/2 + ((data_physio_clean$t4_cort + data_physio_clean$t3_cort)*difftime(data_cort_time$T4,data_cort_time$T3,units='mins'))/2 + ((data_physio_clean$t5_cort + data_physio_clean$t4_cort)*difftime(data_cort_time$T5,data_cort_time$T4,units='mins'))/2 + ((data_physio_clean$t6_cort + data_physio_clean$t5_cort)*difftime(data_cort_time$T6,data_cort_time$T5,units='mins'))/2

data_physio_clean$indivaucg <- as.numeric(data_physio_clean$indivaucg)

#replace missing indivaucg for 4 subjects with generic aucg
idx <- is.na(data_physio_clean$indivaucg)
data_physio_clean$aucg[idx==TRUE]
 
data_physio_clean$indivaucg[idx==TRUE] <- data_physio_clean$aucg[idx==TRUE]
#data_physio_clean$aucg[data_physio_clean$indivaucg==NA] 

#################### Calculate Cortisol Peaks and AUC Ground (aucg) = calculated according to Pruessner (2003) formula: 

# time intervals in our study design: t2-t1:28 min, t3-t2: 12 min, t4-t3: 5 min, t5-t4: 15 min, t6-t5: 15 min

data_physio_clean$aucg <- ((data_physio_clean$t2_cort+data_physio_clean$t1_cort)*28)/2 + ((data_physio_clean$t3_cort + data_physio_clean$t2_cort)*12)/2 + ((data_physio_clean$t4_cort + data_physio_clean$t3_cort)*5)/2 + ((data_physio_clean$t5_cort + data_physio_clean$t4_cort)*15)/2 + ((data_physio_clean$t6_cort + data_physio_clean$t5_cort)*15)/2
data_physio_clean$aucg_amyl <- ((data_physio_clean$t2_amyl+data_physio_clean$t1_amyl)*28)/2 + ((data_physio_clean$t3_amyl + data_physio_clean$t2_amyl)*12)/2 + ((data_physio_clean$t4_amyl + data_physio_clean$t3_amyl)*5)/2 + ((data_physio_clean$t5_amyl + data_physio_clean$t4_amyl)*15)/2 + ((data_physio_clean$t6_amyl + data_physio_clean$t5_amyl)*15)/2

################### Calculate and Standardized Cortisol by T4-T2 (z.peak_cort) for cortisol and T3-T2 (z.peak_amyl)

data_physio_clean <- mutate(data_physio_clean, peak_cort = t4_cort-t2_cort)
data_physio_clean <- mutate(data_physio_clean, peak_amyl = t3_cort-t2_cort)

z.peak_cort = (data_physio_clean$peak_cort-mean(data_physio_clean$peak_cort,na.rm=TRUE)/sd(data_physio_clean$peak_cort,na.rm=TRUE)) #ODER scale(peak_cort)
z.peak_amyl = (data_physio_clean$peak_amyl-mean(data_physio_clean$peak_amyl,na.rm=TRUE)/sd(data_physio_clean$peak_amyl,na.rm=TRUE)) #ODER scale(peak_cort)

data_physio_clean$z.peak_cort <- z.peak_cort
data_physio_clean$z.peak_amyl <- z.peak_amyl

# turn it into wide format, by condition
melted <- melt(data_physio_clean, id.vars= c("VpNr", "condition"))
data_physio_wide <- dcast(melted,  VpNr ~ variable + condition)
data_physio_wide[,6:43] <- sapply(data_physio_wide[,6:43],as.numeric)

data_physio_wide <- data_physio_wide %>% rename(sub_id = VpNr)

data_physio_wide.HC <- data_physio_wide %>% filter(Gruppe_control == "Control")

# save files (data_physio_clean: both AD and HC in long format, data_physio_wide: both AD and HC in wide format)
save(file='/cloud/project/dataframes/data_physio_clean.rda',data_physio_clean)
save(file='/cloud/project/dataframes/data_physio_wide.HC.rda',data_physio_wide.HC)

rm(data_physio_clean)
rm(data_cort_time)
rm(data_physio_wide)
rm(melted)
rm(cort_data)
