#---- Calculate residuals for each year ----
bcch.res <- year_resids(bcch.m$df, bcch.mod)
eaph.res <- year_resids(eaph.m$df, eaph.mod)
ficr.res <- year_resids(ficr.m$df, ficr.mod)
tuvu.res <- year_resids(tuvu.m$df, tuvu.mod)

#for just a few years
ficr.res2 <- year_resids(ficr.m2$df, ficr.mod2)

#---- Calculate Differences from mean by Year ----
ficr.diffs <- mean_diffs(ficr.m$df, ficr.mean$Mean_CPUE)
tuvu.diffs <- mean_diffs(tuvu.m$df, tuvu.mean$Mean_CPUE)