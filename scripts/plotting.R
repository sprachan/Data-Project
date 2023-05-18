theme_set(theme_bw())
##---- Checklists per Year -----
### no cutoff ----
cpy.plot <- ggplot()
cpy.plot+geom_point(data=me.cpy, aes(x=Year, y=log(Number.Lists), fill='ME'), shape=21, size=2)+
  geom_point(data=b.cpy, aes(x=Year, y=log(Number.Lists), fill='BCCH'), shape=21, size=2)+
  geom_point(data=f.cpy, aes(x=Year, y=log(Number.Lists), fill='FICR'), shape=21, size=2)+
  geom_point(data=t.cpy, aes(x=Year, y=log(Number.Lists), fill='TUVU'), shape=21, size=2)+
  geom_point(data=e.cpy, aes(x=Year, y=log(Number.Lists), fill='EAPH'), shape=21, size=2)+
  scale_fill_viridis_d(option='C', alpha=0.75)
ggsave('./plots/cpy.jpg')

### cutoff ----
cpy.cutoff.plot <- ggplot()+geom_point(data=me.cpy.c, aes(x=Year, y=log(Number.Lists), fill='ME'), shape=21, size=2)+
  geom_point(data=b.cpy.c, aes(x=Year, y=log(Number.Lists), fill='BCCH'), shape=21, size=2)+
  geom_point(data=f.cpy.c, aes(x=Year, y=log(Number.Lists), fill='FICR'), shape=21, size=2)+
  geom_point(data=t.cpy.c, aes(x=Year, y=log(Number.Lists), fill='TUVU'), shape=21, size=2)+
  geom_point(data=e.cpy.c, aes(x=Year, y=log(Number.Lists), fill='EAPH'), shape=21, size=2)+
  scale_fill_viridis_d(option='C', alpha=0.75)
cpy.cutoff.plot
ggsave('./plots/cpy_cutoff.jpg')



##---- First Sightings ----

### Individual ----
firsts.plot <- ggplot()

efp <- firsts.plot+geom_line(data=e.firsts, aes(x=Year, y=Month))

ffp <- firsts.plot+geom_line(data=f.firsts, aes(x=Year, y=Month))

tfp <- firsts.plot+geom_line(data=t.firsts, aes(x=Year, y=Month))

efp
ggsave('./plots/EAPH_firsts.png')
ffp
ggsave('./plots/FICR_firsts.png')
tfp
ggsave('./plots/TUVU_firsts.png')

### Together ----
firsts.plot+geom_line(data=combined.firsts, aes(x=Year, y=Month, color=Species))+
  scale_color_viridis_d(alpha=0.75)
ggsave('./plots/Combined_firsts.png')

firsts.plot+geom_line(data=combined.firsts, aes(x=Year, y=Month, color=Species))+
  facet_wrap(facets=vars(Species), nrow=5)+
  scale_color_viridis_d(option = 'H')
ggsave('./plots/combined_firsts2.png')

##---- Abundance ----
### All, zoomed out ----
ggplot(data=combined.ofpm, aes(x=Year_Mo, y=CPUE))+
  geom_point(aes(fill=Species),pch=21)+
  facet_wrap(facets=vars(Species), nrow=4, scales='free')+
  zoo::scale_x_yearmon(format='%m/%y')+
  scale_fill_viridis_d(alpha=0.75)
ggsave('./plots/CPUE_lists.png', dpi=500, width=12, height=6, units='in')


### Zoom ----
ggplot(data=subset(combined.ofpm, Year_Mo>=2022&Year_Mo<=2023),
       aes(x=zoo::as.Date(Year_Mo), y=CPUE))+
  geom_point(aes(fill=Species),pch=21)+
  facet_wrap(facets=vars(Species), nrow=4, scales='free_y')+
  scale_x_date(date_breaks='1 month', date_labels='%m')+
  xlab('Month of 2022')+ylab('Presence per unit effort')+
  scale_fill_viridis_d(alpha=0.75)
ggsave('./plots/CPUE_lists_zoom.png', dpi=500)

##---- Mapping ----
### 10 Years ----
#### Chickadee ----
ggplot()+geom_raster(data=bcch.sp1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='BCCH\ Frequency \n 2000-2010')
#ggsave('./plots/decade_maps/BCCH_map_2000-2010.png')

ggplot()+geom_raster(data=bcch.sp2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', limits=c(0, 1),
                     name='BCCH\ Frequency \n 2011-2021')
#ggsave('./plots/decade_maps/BCCH_map_2011-2021.png')

#### Phoebe ----
ggplot()+geom_raster(data=eaph.sp1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2000-2010')
#ggsave('./plots/decade_maps/EAPH_map_2000-2010.png')

ggplot()+geom_raster(data=eaph.sp2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2011-2021')
#ggsave('./plots/decade_maps/EAPH_map_2011-2021.png')


#### Fish Crow ----
ggplot()+geom_raster(data=ficr.sp1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='FICR\ Frequency \n 2000-2010')
#ggsave('./plots/decade_maps/FICR_map_2000-2010.png')

ggplot()+geom_raster(data=ficr.sp2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='FICR\ Frequency \n 2011-2021')
#ggsave('./plots/decade_maps/FICR_map_2011-2021.png')


#### Turkey Vulture ----
ggplot()+geom_raster(data=tuvu.sp1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='TUVU\ Frequency \n 2000-2010')
#ggsave('./plots/decade_maps/TUVU_map_2000-2010.png')

ggplot()+geom_raster(data=tuvu.sp2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='TUVU\ Frequency \n 2011-2021')
#ggsave('./plots/decade/maps/TUVU_map_2011-2021.png')

### 5 Years ----
#### Chickadee ----
ggplot()+geom_raster(data=bcch.fy1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='BCCH\ Frequency \n 2010-2015')
#ggsave('./plots/fiveyear_maps/BCCH_map_2010-2015.png')

ggplot()+geom_raster(data=bcch.fy2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', limits=c(0, 1),
                     name='BCCH\ Frequency \n 2016-2022')
#ggsave('./plots/fiveyear_maps/BCCH_map_2016-2021.png')

#### Phoebe ----
ggplot()+geom_raster(data=eaph.fy1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2010-2015')
#ggsave('./plots/fiveyear_maps/EAPH_map_2010-2015.png')

ggplot()+geom_raster(data=eaph.fy2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='EAPH\ Frequency \n 2016-2021')
#ggsave('./plots/fiveyear_maps/EAPH_map_2016-2021.png')


#### Fish Crow ----
ggplot()+geom_raster(data=ficr.fy1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', limits=c(0, 0.05),
                     name='FICR\ Frequency \n 2010-2015')
#ggsave('./plots/fiveyear_maps/FICR_map_2010-2015.png')

ggplot()+geom_raster(data=ficr.fy2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', limits=c(0, 0.05),
                     name='FICR\ Frequency \n 2016-2021')
#ggsave('./plots/fiveyear_maps/FICR_map_2016-2021.png')


#### Turkey Vulture ----
ggplot()+geom_raster(data=tuvu.fy1, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', name='TUVU\ Frequency \n 2010-2015')
#ggsave('./plots/fiveyear_maps/TUVU_map_2010-2015.png')

ggplot()+geom_raster(data=tuvu.fy2, aes(x=x, y=y, fill=frequency))+
  geom_sf(data=me, fill=NA, color='white', linewidth=1)+
  theme_dark()+
  scale_fill_viridis(na.value='transparent', limits=c(0, 1),
                     name='TUVU\ Frequency \n 2016-2021')
#ggsave('./plots/fiveyear_maps/TUVU_map_2016-2021.png')



##---- Modelling ----
### Yearly Curve Overlay ----
ggplot(data=combined.m, aes(x=Week, y=CPUE, color=Year))+
  geom_point()+
  facet_wrap(facets=vars(Species), nrow=4, scale='free_y')+
  #scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
scale_color_viridis(option='H')
ggsave('./plots/overlays/all.png', dpi=500, width=17, height=10, units='in')

ggplot(data=bcch.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_point()+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/overlays/bcch.png', dpi=500)

ggplot(data=eaph.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_point()+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/overlays/eaph.png', dpi=500)

ggplot(data=ficr.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_point()+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/overlays/ficr.png', dpi=500)

ggplot(data=tuvu.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_point()+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/overlays/tuvu.png', dpi=500)

###---- With Mean----
ggplot()+geom_point(data=ficr.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_line(data=ficr.mean, aes(x=Week, y=Mean_CPUE), color='black', linewidth=1)+
  scale_color_viridis(option='H')

ggplot()+geom_point(data=tuvu.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_line(data=tuvu.mean, aes(x=Week, y=Mean_CPUE), color='black', linewidth=1)+
  scale_color_viridis(option='H')


###--- Differences from Mean ----
ggplot(data=ficr.diffs, aes(x=Week, y=Difference, color=Year))+
  geom_point()+
  facet_wrap(facets=vars(Year))+
  scale_color_viridis(option='H')+
  ylab('Difference from Mean')

ggplot(data=tuvu.diffs, aes(x=Week, y=Difference, color=Year))+
  geom_point()+
  facet_wrap(facets=vars(Year))+
  scale_color_viridis(option='H')+
  ylab('Difference from Mean')

### LOESS ----
#plot BCCH
ggplot()+
  geom_point(data=bcch.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_ribbon(data=bcch.mod,
              aes(x=x, ymin = y - s, ymax = y+s), fill = "grey70", alpha=0.5) +
  geom_line(data=bcch.mod, aes(x=x, y = y), linewidth=1)+
  scale_color_viridis(option='H')
ggsave('./plots/models/bcch.png', dpi=500)

#plot EAPH
ggplot()+
  geom_point(data=eaph.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_ribbon(data=eaph.mod,
              aes(x=x, ymin = y - 2*s, ymax = y+2*s), fill = "grey70", alpha=0.5) +
  geom_line(data=eaph.mod, aes(x=x, y = y), linewidth=1)+
  scale_color_viridis(option='H')
ggsave('./plots/models/eaph.png', dpi=500)

#plot FICR
ggplot()+
  geom_point(data=ficr.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_ribbon(data=ficr.mod,
              aes(x=x, ymin = y - 2*s, ymax = y+2*s), fill = "grey70", alpha=0.5) +
  geom_line(data=ficr.mod, aes(x=x, y = y), linewidth=1)+
  scale_color_viridis(option='H')
ggsave('./plots/models/ficr.png', dpi=500)


ggplot()+
  geom_point(data=ficr.m2$df, aes(x=Week, y=CPUE, color=Year))+
  geom_ribbon(data=ficr.mod2, aes(x=x, ymin=y-2*s, ymax=y+2*s), fill='grey70', alpha=0.5)+
  geom_line(data=ficr.mod2, aes(x=x, y=y), linewidth=1)+
  scale_color_viridis(option='H')
ggsave('./plots/models/ficr2.png', dpi=500)
#plot TUVU
ggplot()+
  geom_point(data=tuvu.m$df, aes(x=Week, y=CPUE, color=Year))+
  geom_ribbon(data=tuvu.mod,
              aes(x=x, ymin = y - 2*s, ymax = y+2*s), fill = "grey70", alpha=0.5) +
  geom_line(data=tuvu.mod, aes(x=x, y = y), linewidth=1)+
  scale_color_viridis(option='H')
ggsave('./plots/models/tuvu.png', dpi=500)

##---- Residuals ----
ggplot(data=bcch.res, aes(x=Week, y=Res, color=Year))+
  geom_point(position='jitter')+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/residuals/bcch.png', dpi=500)

ggplot(data=eaph.res, aes(x=Week, y=Res, color=Year))+
  geom_point(position='jitter')+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H', alpha=0.75)
ggsave('./plots/residuals/eaph.png', dpi=500)

ggplot(data=ficr.res, aes(x=Week, y=Res, color=Year))+
  geom_point(position='jitter')+
  scale_x_continuous(breaks=seq(0, 54, by=2))+
  scale_color_viridis(option='H')
ggsave('./plots/residuals/ficr.png', dpi=500)

ggplot(data=ficr.res2, aes(x=Week, y=Res, color=Year))+
  geom_point(position='jitter')+
  scale_color_viridis(option='H')
ggsave('./plots/residuals/ficr2.png', dpi=500)

### With facets -----
ggplot(data=ficr.res, aes(x=Week, y=Res))+
  geom_point(position='jitter')+
  facet_wrap(facets=vars(Year))
