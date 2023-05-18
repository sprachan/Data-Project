## Mapping abundance over time and space

#---- Setup for Mapping Decades ----
states <- ne_states(iso_a2 = c("US", "CA"), returnclass = "sf")
me <- filter(states, postal == "ME") %>% st_transform(crs=32619) %>%
  st_geometry()
#separate zero-fill spatial data into a 2000-2010 chunk and a 2011-2021 chunk

bcch.sp1 <- to_spatial_years(bcch.zf, 
                             year.start='2000-01-01', 
                             year.end='2010-12-31') %>%
  make_freq()

bcch.sp2 <- to_spatial_years(bcch.zf, 
                             year.start='2011-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

eaph.sp1 <-to_spatial_years(eaph.zf, 
                            year.start='2000-01-01', 
                            year.end='2010-12-31') %>%
  make_freq()
eaph.sp2 <- to_spatial_years(eaph.zf, 
                             year.start='2011-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

ficr.sp1 <-to_spatial_years(ficr.zf, 
                            year.start='2000-01-01', 
                            year.end='2010-12-31') %>%
  make_freq()
ficr.sp2 <- to_spatial_years(ficr.zf, 
                             year.start='2011-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

tuvu.sp1 <-to_spatial_years(tuvu.zf, 
                            year.start='2000-01-01', 
                            year.end='2010-12-31') %>%
  make_freq()
tuvu.sp2 <- to_spatial_years(tuvu.zf, 
                             year.start='2011-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()



#---- Mapping Setup: 5-year increments --------
bcch.fy1 <- to_spatial_years(bcch.zf, 
                             year.start='2010-01-01', 
                             year.end='2015-12-31') %>%
  make_freq()

bcch.fy2 <- to_spatial_years(bcch.zf, 
                             year.start='2016-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

eaph.fy1 <-to_spatial_years(eaph.zf, 
                            year.start='2010-01-01', 
                            year.end='2015-12-31') %>%
  make_freq()
eaph.fy2 <- to_spatial_years(eaph.zf, 
                             year.start='2016-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

ficr.fy1 <-to_spatial_years(ficr.zf, 
                            year.start='2010-01-01', 
                            year.end='2015-12-31') %>%
  make_freq()
ficr.fy2 <- to_spatial_years(ficr.zf, 
                             year.start='2016-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()

tuvu.fy1 <-to_spatial_years(tuvu.zf, 
                            year.start='2010-01-01', 
                            year.end='2015-12-31') %>%
  make_freq()
tuvu.fy2 <- to_spatial_years(tuvu.zf, 
                             year.start='2016-01-01', 
                             year.end='2021-12-31') %>%
  make_freq()


