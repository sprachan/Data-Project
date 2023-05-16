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
#---- 4. Mapping 5-years ----
##Chickadee 
# ggplot()+geom_raster(data=bcch.fy1, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', name='BCCH\ Frequency \n 2010-2015')
# #ggsave('./plots/fiveyear_maps/BCCH_map_2010-2015.png')
# 
# ggplot()+geom_raster(data=bcch.fy2, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', limits=c(0, 1),
#                      name='BCCH\ Frequency \n 2016-2022')
# #ggsave('./plots/fiveyear_maps/BCCH_map_2016-2021.png')
# 
# ## Phoebe
# ggplot()+geom_raster(data=eaph.fy1, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2010-2015')
# #ggsave('./plots/fiveyear_maps/EAPH_map_2010-2015.png')
# 
# ggplot()+geom_raster(data=eaph.fy2, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2016-2021')
# #ggsave('./plots/fiveyear_maps/EAPH_map_2016-2021.png')
# 
# 
# ## Fish Crow
# ggplot()+geom_raster(data=ficr.fy1, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', limits=c(0, 0.05),
#                      name='FICR\ Frequency \n 2010-2015')
# #ggsave('./plots/fiveyear_maps/FICR_map_2010-2015.png')
# 
# ggplot()+geom_raster(data=ficr.fy2, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', limits=c(0, 0.05),
#                      name='FICR\ Frequency \n 2016-2021')
# #ggsave('./plots/fiveyear_maps/FICR_map_2016-2021.png')
# 
# 
# ## Turkey Vulture
# ggplot()+geom_raster(data=tuvu.fy1, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', name='TUVU\ Frequency \n 2010-2015')
# #ggsave('./plots/fiveyear_maps/TUVU_map_2010-2015.png')
# 
# ggplot()+geom_raster(data=tuvu.fy2, aes(x=x, y=y, fill=frequency))+
#   geom_sf(data=me, fill=NA, color='white', linewidth=1)+
#   theme_dark()+
#   scale_fill_viridis(na.value='transparent', limits=c(0, 1),
#                      name='TUVU\ Frequency \n 2016-2021')
# #ggsave('./plots/fiveyear_maps/TUVU_map_2016-2021.png')

