#---- Format Data ----
#For each species, generate a dataframe (for plotting)
#::: and matrix (for model-fitting) that has CPUE by week.
#make_week function returns a list of 2; the first element ($df)
#::: is a data frame and the second element ($mat) is a matrix

#Based on EDA, I am only including years after 2008.

bcch.m <- filter(bcch.zf, year(observation_date)>=2008) %>% make_week('BCCH')


eaph.m <- filter(eaph.zf, year(observation_date)>=2008) %>% make_week('EAPH')


ficr.m <- filter(ficr.zf, year(observation_date)>=2008) %>% make_week('FICR')
ficr.m2 <- filter(ficr.zf, year(observation_date)>=2016) %>% make_week('FICR')


tuvu.m <- filter(tuvu.zf, year(observation_date)>=2008) %>% make_week('TUVU')


combined.m <- rbind(bcch.m$df, eaph.m$df, ficr.m$df, ficr.m$df, tuvu.m$df)



#---- Fit LOESS model ----
bcch.mod <- loess_reg(x=bcch.m$mat[,1], y=bcch.m$mat[,2], epsilon=1, mesh=1041)

eaph.mod <- loess_reg(x=eaph.m$mat[,1], y=eaph.m$mat[,2], epsilon=0.5, mesh=1041)

ficr.mod <- loess_reg(x=ficr.m$mat[,1], y=ficr.m$mat[,2], epsilon=1, mesh=1041)

tuvu.mod <- loess_reg(x=tuvu.m$mat[,1], y=tuvu.m$mat[,2], epsilon=1, mesh=1041)


#fish crows have weird data so take a more recent subset to see how that changes model
ficr.mod2 <- loess_reg(x=ficr.m2$mat[,1], y=ficr.m2$mat[,2], epsilon=1, mesh=1041)


#---- Calculate Weekly Mean CPUEs ----
ficr.mean <- group_by(ficr.m$df, Week) %>% summarize(Mean_CPUE=mean(CPUE))
tuvu.mean <- group_by(tuvu.m$df, Week) %>% summarize(Mean_CPUE=mean(CPUE))
