## Add column for observation date in Year-month format for easy plotting.
#Pass the new data frame to month_cpue_list function to add a 
#count (of lists) per unit effort -- that is, how many checklists the species was
#observed over the number of lists overall

#---- Calculate CPUE ----
bcch.ofpm <- month_cpue_list(bcch.zf, bcch.ofpm, 'Black-Capped Chickadee')
eaph.ofpm <- month_cpue_list(eaph.zf, eaph.ofpm, 'Eastern Phoebe')
ficr.ofpm <- month_cpue_list(ficr.zf, ficr.ofpm, 'Fish Crow')
tuvu.ofpm <- month_cpue_list(tuvu.zf, tuvu.ofpm, 'Turkey Vulture')

combined.ofpm <- rbind(bcch.ofpm, eaph.ofpm, ficr.ofpm, tuvu.ofpm)
combined.ofpm$Species <- as.factor(combined.ofpm$Species)

