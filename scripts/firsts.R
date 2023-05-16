# #Want to find when the first sighting of the year occurred in each year 
# #::: where there's data.

f.firsts <- group_by(f.mini.c, Year) %>% slice(1)
t.firsts <- group_by(t.mini.c, Year) %>% slice(1)
b.firsts <- group_by(b.mini.c, Year) %>% slice(1)
me.firsts <- group_by(me.mini.c, Year) %>% slice(1)
me.firsts$Species <- rep('Maine Random Sample', nrow(me.firsts))
e.firsts <- group_by(e.mini.c, Year) %>% slice(1)


combined.firsts <- rbind(f.firsts, t.firsts, b.firsts, e.firsts, me.firsts)


