################### NECESSARY TO RUN FOR SALAD_cortisol ###################

cort_file <- "data_sum/SPSS/Longitudinal_cortisol_ALL_Okt2016.sav"

# import cortisol data need to set path first
cort_data <- read.spss(cort_file, use.value.label=TRUE, to.data.frame=TRUE)

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
data_wide <- dcast(melted,  VpNr ~ variable + condition)
