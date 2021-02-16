library(reshape2)
################# Transfer wide to long for p_correct #################

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


detach("package:ez", unload = TRUE)
detach("package:reshape2", unload = TRUE)
library(ez)
