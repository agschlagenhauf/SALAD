library(readxl)
library(lme4)
library(reshape2)
library(dplyr)
library(lubridate)
library(foreign)

################# ALL DATA FOR CORTISOL ANALYSES IMPORTED HERE ###########
################### NECESSARY TO RUN FOR SALAD_cortisol_modeling (Cortisol Analyses) ###################

cort_file <- "data_sum/SPSS/Longitudinal_cortisol_ALL_Okt2016.sav"
time_cort_file <- "data_sum/zeitablauf_selection.csv"

# import cortisol data 
cort_data <- read.spss(cort_file, use.value.label=TRUE, to.data.frame=TRUE)

# import individual time points of cortisol data, there are no NA (but how would one deal with those?)
data_time_cort <-  read_csv(time_cort_file)

# date_string = '11:30 AM'
# format = '%I:%M %p'
# my_date = datetime.strptime(date_string, format)
# my_date.strftime(format)
# 
# T1 <- strptime(data_time_cort$T1, format = "%H:%M:%S %p")
# format(T1, "%H:%M:%S")

# clean unnecessary columns from physio data
data_physio_clean = subset(cort_data, select = -c(sjn,VpNr_numeric,VpOrder,filter_.,operant_inclusion, operant_excl_reason,OPERA0,OPERA1,OPERA2,Comments,COMME0,COMME1,COMME2) )
#data_physio_clean <- na.omit(data_physio_clean)

#################### Calculate Cortisol Peaks and AUC Ground (aucg) = calculated according to Pruessner (2003) formula: 

# time intervals in our study design: t1-t2:28 min, t2-t3: 12 min, t3-t4: 5 min, t4-t5: 15 min, t5-t6: 15 min

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

# save files (data_physio_clean: both AD and HC in long format, data_physio_wide: both AD and HC in wide format)
save(file='/cloud/project/dataframes/data_physio_clean.rda',data_physio_clean)
save(file='/cloud/project/dataframes/data_physio_wide.rda',data_physio_wide)

rm(data_time_cort)
rm(data_physio_clean)
rm(data_physio_wide)
rm(melted)
rm(cort_data)
