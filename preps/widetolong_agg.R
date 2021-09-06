library(reshape2)
library(strex)

################# NECESSARY TO RUN THIS FOR LATER RMANOVA ANALYSES ###########
################# ALL DATA FOR BEHAVIORAL/AGGREGATED ANALYSES PREPARED HERE ###########
################# Transfer wide to long for p_correct #################


## transfer from wide to long format p_correct, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.cond.correct <- melt(dat_all,
                        # ID variables - all the variables to keep but not split apart on
                        id.vars=c("sub_id", "group","order","age","school_yrs"),
                        # The source columns
                        measure.vars=c("p_correct_ST","p_correct_CT"),
                        # Name of the destination column that will identify the original
                        # column that the measurement came from
                        variable.name="cond",
                        value.name="p_correct"
)


longdat.cond.correct$p_correct <- as.numeric(longdat.cond.correct$p_correct)


longdat.cond.correct <- longdat.cond.correct %>% mutate(cond = grepl("*CT",longdat.cond.correct$cond)) 
longdat.cond.correct <- longdat.cond.correct %>% mutate(cond2 = (longdat.cond.correct$cond*-1)+1) %>% rename(cond = longdat.cond.correct$cond2)

longdat.cond.correct$group <- as.factor(longdat.cond.correct$group) 
levels(longdat.cond.correct$group) <- c('HC', 'AD')

longdat.cond.correct$cond <- as.factor(longdat.cond.correct$cond) 
levels(longdat.cond.correct$cond) <- c('Stress', 'Control')

longdat.cond.HC.correct <- longdat.cond.correct %>% filter(longdat.cond.correct$group == 'HC')


## transfer from wide to long format p_correct, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.correct <- melt(dat_all,
                        # ID variables - all the variables to keep but not split apart on
                        id.vars=c("sub_id", "group","order","age","school_yrs"),
                        # The source columns
                        measure.vars=c("p_correct_pre_ST","p_correct_rev_ST","p_correct_post_ST","p_correct_pre_CT","p_correct_rev_CT","p_correct_post_CT"),
                        # Name of the destination column that will identify the original
                        # column that the measurement came from
                        variable.name="phase",
                        value.name="p_correct"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.correct$id <- str_last_number(longdat.correct$sub_id)
longdat.correct$id <- as.factor(longdat.correct$id)
longdat.correct$p_correct <- as.numeric(longdat.correct$p_correct)


longdat.correct <- longdat.correct %>% arrange(id)

longdat.correct <- longdat.correct %>% arrange(phase)

longdat.correct$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.correct$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.correct$volat2 <- as.numeric(longdat.correct$volat1)

levels(longdat.correct$volat)[levels(longdat.correct$volat)=="pre_ST"] <- "pre"
levels(longdat.correct$volat)[levels(longdat.correct$volat)=="rev_ST"] <- "rev"
levels(longdat.correct$volat)[levels(longdat.correct$volat)=="post_ST"] <- "post"

levels(longdat.correct$volat)[levels(longdat.correct$volat)=="pre_CT"] <- "pre"
levels(longdat.correct$volat)[levels(longdat.correct$volat)=="rev_CT"] <- "rev"
levels(longdat.correct$volat)[levels(longdat.correct$volat)=="post_CT"] <- "post"

longdat.correct <- longdat.correct %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.correct <- longdat.correct %>% mutate(cond = grepl("*CT",longdat.correct$phase)) 
longdat.correct <- longdat.correct %>% mutate(cond2 = longdat.correct$cond*1) %>% rename(cond = longdat.correct$cond2)

longdat.correct$group <- as.factor(longdat.correct$group) 
levels(longdat.correct$group) <- c('HC', 'AD')

longdat.correct$cond <- as.factor(longdat.correct$cond) 
levels(longdat.correct$cond) <- c('Stress', 'Control')

longdat.HC.correct <- longdat.correct %>% filter(longdat.correct$group == 'HC')
longdat.AD.correct <- longdat.correct %>% filter(longdat.correct$group == 'AD')

################# Transfer wide to long for p_winstay #################

## transfer from wide to long format p_winstay, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.winstay <- melt(dat_all,
                        # ID variables - all the variables to keep but not split apart on
                        id.vars=c("sub_id", "group","order","age","IQ_WST","school_yrs"),
                        # The source columns
                        measure.vars=c("p_w_st_pre_ST","p_w_st_rev_ST","p_w_st_post_ST","p_w_st_pre_CT","p_w_st_rev_CT","p_w_st_post_CT"),
                        # Name of the destination column that will identify the original
                        # column that the measurement came from
                        variable.name="phase",
                        value.name="p_winstay"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.winstay$id <- str_last_number(longdat.winstay$sub_id)
longdat.winstay$id <- as.factor(longdat.winstay$id)
longdat.winstay$p_winstay <- as.numeric(longdat.winstay$p_winstay)

longdat.winstay$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.winstay$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.winstay$volat2 <- as.numeric(longdat.winstay$volat1)

levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="pre_ST"] <- "pre"
levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="rev_ST"] <- "rev"
levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="post_ST"] <- "post"

levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="pre_CT"] <- "pre"
levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="rev_CT"] <- "rev"
levels(longdat.winstay$volat)[levels(longdat.winstay$volat)=="post_CT"] <- "post"

longdat.winstay <- longdat.winstay %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.winstay <- longdat.winstay %>% mutate(cond = grepl("*CT",longdat.winstay$phase))
longdat.winstay <- longdat.winstay %>% mutate(cond2 = longdat.winstay$cond*1) %>% rename(cond = longdat.winstay$cond2)

longdat.winstay$group <- as.factor(longdat.winstay$group) 
levels(longdat.winstay$group) <- c('HC', 'AD')

longdat.winstay$cond <- as.factor(longdat.winstay$cond) 
levels(longdat.winstay$cond) <- c('Stress', 'Control')

longdat.HC.winstay <- longdat.winstay %>% filter(longdat.winstay$group == 'HC')
longdat.AD.winstay <- longdat.winstay %>% filter(longdat.winstay$group == 'AD')


################# Transfer wide to long for p_lswitch #################

## transfer from wide to long format p_loseswitch, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.lswitch <- melt(dat_all,
                        # ID variables - all the variables to keep but not split apart on
                        id.vars=c("sub_id", "group","order","age","IQ_WST","school_yrs"),
                        # The source columns
                        measure.vars=c("p_l_sw_pre_ST","p_l_sw_rev_ST","p_l_sw_post_ST","p_l_sw_pre_CT","p_l_sw_rev_CT","p_l_sw_post_CT"),
                        # Name of the destination column that will identify the original
                        # column that the measurement came from
                        variable.name="phase",
                        value.name="p_lswitch"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.lswitch$id <- str_last_number(longdat.lswitch$sub_id)
longdat.lswitch$id <- as.factor(longdat.lswitch$id)
longdat.lswitch$p_lswitch <- as.numeric(longdat.lswitch$p_lswitch)


longdat.lswitch$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.lswitch$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.lswitch$volat2 <- as.numeric(longdat.lswitch$volat1)

levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="pre_ST"] <- "pre"
levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="rev_ST"] <- "rev"
levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="post_ST"] <- "post"

levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="pre_CT"] <- "pre"
levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="rev_CT"] <- "rev"
levels(longdat.lswitch$volat)[levels(longdat.lswitch$volat)=="post_CT"] <- "post"

longdat.lswitch <- longdat.lswitch %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.lswitch <- longdat.lswitch %>% mutate(cond = grepl("*CT",longdat.lswitch$phase))
longdat.lswitch <- longdat.lswitch %>% mutate(cond2 = longdat.lswitch$cond*1) %>% rename(cond = longdat.lswitch$cond2)

longdat.lswitch$group <- as.factor(longdat.lswitch$group) 
levels(longdat.lswitch$group) <- c('HC', 'AD')

longdat.lswitch$cond <- as.factor(longdat.lswitch$cond) 
levels(longdat.lswitch$cond) <- c('Stress', 'Control')

longdat.HC.lswitch <- longdat.lswitch %>% filter(longdat.lswitch$group == 'HC')
longdat.AD.lswitch <- longdat.lswitch %>% filter(longdat.lswitch$group == 'AD')


longdat.RT <- melt(dat_all,
                   # ID variables - all the variables to keep but not split apart on
                   id.vars=c("sub_id", "group","order","age","school_yrs"),
                   # The source columns
                   measure.vars=c("p_RT_pre_ST","p_RT_rev_ST","p_RT_post_ST","p_RT_pre_CT","p_RT_rev_CT","p_RT_post_CT"),
                   # Name of the destination column that will identify the original
                   # column that the measurement came from
                   variable.name="phase",
                   value.name="p_RT"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.RT$id <- str_last_number(longdat.RT$sub_id)
longdat.RT$id <- as.factor(longdat.RT$id)
longdat.RT$p_RT <- as.numeric(longdat.RT$p_RT)

longdat.RT <- longdat.RT %>% arrange(id)

longdat.RT <- longdat.RT %>% arrange(phase)

longdat.RT$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.RT$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.RT$volat2 <- as.numeric(longdat.RT$volat1)


levels(longdat.RT$volat)[levels(longdat.RT$volat)=="pre_ST"] <- "pre"
levels(longdat.RT$volat)[levels(longdat.RT$volat)=="rev_ST"] <- "rev"
levels(longdat.RT$volat)[levels(longdat.RT$volat)=="post_ST"] <- "post"

levels(longdat.RT$volat)[levels(longdat.RT$volat)=="pre_CT"] <- "pre"
levels(longdat.RT$volat)[levels(longdat.RT$volat)=="rev_CT"] <- "rev"
levels(longdat.RT$volat)[levels(longdat.RT$volat)=="post_CT"] <- "post"

longdat.RT <- longdat.RT %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.RT <- longdat.RT %>% mutate(cond = grepl("*CT",longdat.RT$phase))
longdat.RT <- longdat.RT %>% mutate(cond2 = longdat.RT$cond*1) %>% rename(cond = longdat.RT$cond2)

longdat.RT$group <- as.factor(longdat.RT$group) 
levels(longdat.RT$group) <- c('HC', 'AD')

longdat.RT$cond <- as.factor(longdat.RT$cond) 
levels(longdat.RT$cond) <- c('Stress', 'Control')

longdat.HC.RT <- longdat.RT %>% filter(longdat.RT$group == 'HC')
longdat.AD.RT <- longdat.RT %>% filter(longdat.RT$group == 'AD')

## transfer from wide to long format p_stay, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.stay <- melt(dat_all,
                     # ID variables - all the variables to keep but not split apart on
                     id.vars=c("sub_id", "group","order","age","school_yrs"),
                     # The source columns
                     measure.vars=c("p_stay_pre_ST","p_stay_rev_ST","p_stay_post_ST","p_stay_pre_CT","p_stay_rev_CT","p_stay_post_CT"),
                     # Name of the destination column that will identify the original
                     # column that the measurement came from
                     variable.name="phase",
                     value.name="p_stay"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.stay$id <- str_last_number(longdat.stay$sub_id)
longdat.stay$id <- as.factor(longdat.stay$id)
longdat.stay$p_stay <- as.numeric(longdat.stay$p_stay)

longdat.stay$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.stay$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))

levels(longdat.stay$volat)[levels(longdat.stay$volat)=="pre_ST"] <- "pre"
levels(longdat.stay$volat)[levels(longdat.stay$volat)=="rev_ST"] <- "rev"
levels(longdat.stay$volat)[levels(longdat.stay$volat)=="post_ST"] <- "post"

levels(longdat.stay$volat)[levels(longdat.stay$volat)=="pre_CT"] <- "pre"
levels(longdat.stay$volat)[levels(longdat.stay$volat)=="rev_CT"] <- "rev"
levels(longdat.stay$volat)[levels(longdat.stay$volat)=="post_CT"] <- "post"

longdat.stay <- longdat.stay %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.stay <- longdat.stay %>% mutate(cond = grepl("*CT",longdat.stay$phase))
longdat.stay <- longdat.stay %>% mutate(cond2 = longdat.stay$cond*1) %>% rename(cond = longdat.stay$cond2)

longdat.stay$group <- as.factor(longdat.stay$group) 
levels(longdat.stay$group) <- c('HC', 'AD')

longdat.stay$cond <- as.factor(longdat.stay$cond) 
levels(longdat.stay$cond) <- c('Stress', 'Control')

## transfer from wide to long format p_sw, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.sw <- melt(dat_all,
                   # ID variables - all the variables to keep but not split apart on
                   id.vars=c("sub_id", "group","order","age","school_yrs"),
                   # The source columns
                   measure.vars=c("p_sw_pre_ST","p_sw_rev_ST","p_sw_post_ST","p_sw_pre_CT","p_sw_rev_CT","p_sw_post_CT"),
                   # Name of the destination column that will identify the original
                   # column that the measurement came from
                   variable.name="phase",
                   value.name="p_switch"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.sw$id <- str_last_number(longdat.sw$sub_id)
longdat.sw$id <- as.factor(longdat.sw$id)
longdat.sw$p_switch <- as.numeric(longdat.sw$p_switch)

longdat.sw$volat1 <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))
longdat.sw$volat <- gl(6,nrow(dat_all),labels=c("pre_ST","rev_ST","post_ST","pre_CT","rev_CT","post_CT"))

levels(longdat.sw$volat)[levels(longdat.sw$volat)=="pre_ST"] <- "pre"
levels(longdat.sw$volat)[levels(longdat.sw$volat)=="rev_ST"] <- "rev"
levels(longdat.sw$volat)[levels(longdat.sw$volat)=="post_ST"] <- "post"

levels(longdat.sw$volat)[levels(longdat.sw$volat)=="pre_CT"] <- "pre"
levels(longdat.sw$volat)[levels(longdat.sw$volat)=="rev_CT"] <- "rev"
levels(longdat.sw$volat)[levels(longdat.sw$volat)=="post_CT"] <- "post"

longdat.sw <- longdat.sw %>% arrange(id)

# extract string ST or CT from phase strings and turn it into logical, then numeric
longdat.sw <- longdat.sw %>% mutate(cond = grepl("*CT",longdat.sw$phase))
longdat.sw <- longdat.sw %>% mutate(cond2 = longdat.sw$cond*1) %>% rename(cond = longdat.sw$cond2)

longdat.sw$group <- as.factor(longdat.sw$group) 
levels(longdat.sw$group) <- c('HC', 'AD')

longdat.sw$cond <- as.factor(longdat.sw$cond) 
levels(longdat.sw$cond) <- c('Stress', 'Control')

longdat.HC.sw <- longdat.sw %>% filter(longdat.sw$group == 'HC')

################# Transfer wide to long along cond for p_winswitch #################

## transfer from wide to long format p_winswitch, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.winswitch <- melt(dat_all,
                        # ID variables - all the variables to keep but not split apart on
                        id.vars=c("sub_id", "group","order","age","IQ_WST","school_yrs"),
                        # The source columns
                        measure.vars=c("p_win_switch_ST","p_win_switch_CT"),
                        # Name of the destination column that will identify the original
                        # column that the measurement came from
                        variable.name="cond",
                        value.name="p_winswitch"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.winswitch$id <- str_last_number(longdat.winswitch$sub_id)
longdat.winswitch$id <- as.factor(longdat.winswitch$id)
longdat.winswitch$p_winswitch <- as.numeric(longdat.winswitch$p_winswitch)
longdat.winswitch$cond <- as.numeric(longdat.winswitch$cond)


longdat.winswitch <- longdat.winswitch %>% arrange(id)

longdat.winswitch <- longdat.winswitch %>% mutate(cond2 = longdat.winswitch$cond*1) %>% rename(cond = longdat.winswitch$cond2)

longdat.winswitch$group <- as.factor(longdat.winswitch$group)
levels(longdat.winswitch$group) <- c('HC', 'AD')

longdat.winswitch$cond <- as.factor(longdat.winswitch$cond)
levels(longdat.winswitch$cond) <- c('Stress', 'Control')

longdat.HC.winswitch <- longdat.winswitch %>% filter(longdat.winswitch$group == 'HC')
longdat.AD.winswitch <- longdat.winswitch %>% filter(longdat.winswitch$group == 'AD')

################# Transfer wide to long along cond for p_lswitch #################

## transfer from wide to long format p_lswitch, reclassify variables, prepare for stats
# transfer them to long format as preparation for rmANOVA

longdat.lswitch <- melt(dat_all,
                          # ID variables - all the variables to keep but not split apart on
                          id.vars=c("sub_id", "group","order","age","IQ_WST","school_yrs"),
                          # The source columns
                          measure.vars=c("p_lose_switch_ST","p_lose_switch_CT"),
                          # Name of the destination column that will identify the original
                          # column that the measurement came from
                          variable.name="cond",
                          value.name="p_lswitch"
)

# use package strex to extract last number from sub_id and turn it into factor
longdat.lswitch$id <- str_last_number(longdat.lswitch$sub_id)
longdat.lswitch$id <- as.factor(longdat.lswitch$id)
longdat.lswitch$p_lswitch <- as.numeric(longdat.lswitch$p_lswitch)
longdat.lswitch$cond <- as.numeric(longdat.lswitch$cond)


longdat.lswitch <- longdat.lswitch %>% arrange(id)

longdat.lswitch <- longdat.lswitch %>% mutate(cond2 = longdat.lswitch$cond*1) %>% rename(cond = longdat.lswitch$cond2)

longdat.lswitch$group <- as.factor(longdat.lswitch$group)
levels(longdat.lswitch$group) <- c('HC', 'AD')

longdat.lswitch$cond <- as.factor(longdat.lswitch$cond)
levels(longdat.lswitch$cond) <- c('Stress', 'Control')

longdat.HC.lswitch <- longdat.lswitch %>% filter(longdat.lswitch$group == 'HC')
longdat.AD.lswitch <- longdat.lswitch %>% filter(longdat.lswitch$group == 'AD')

