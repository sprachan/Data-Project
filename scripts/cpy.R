#-----1. Make mini dataframes----

#Make smaller dataframes that just contain checklists over time and nothing else.
#::: If I screw anything up with these, it won't be catastrophic.
#::: Also, makes it much easier to deal with because there are a lot less variables
#::: on the go.
f.mini <- data.frame(Checklist=ficr$checklist_id, Obs.Date = ficr$observation_date,
                     Species = rep('Fish Crow', length(ficr$checklist_id)),
                     Count=ficr$observation_count)
t.mini <- data.frame(Checklist=tuvu$checklist_id, Obs.Date=tuvu$observation_date,
                     Species = rep('Turkey Vulture', length(tuvu$checklist_id)),
                     Count=tuvu$observation_count)
#Make smaller set of all BCCH data
b.mini <- data.frame(Checklist=bcch$checklist_id, Obs.Date=bcch$observation_date,
                     Species=rep('BC Chickadee', length(bcch$checklist_id)),
                     Count=bcch$observation_count)

#smaller df of random sample of ME data
me.mini <- data.frame(Checklist=me.rs.x$checklist_id, Obs.Date=me.rs.x$observation_date,
                      Species=me.rs.x$common_name, Count=me.rs.x$observation_count)

e.mini <- data.frame(Checklist=eaph$checklist_id, Obs.Date=eaph$observation_date,
                     Species=eaph$common_name, Count=eaph$observation_count)
#Add Year, Month, and Day columns using my function
f.mini <- date_cols(f.mini, as_f=FALSE)
t.mini <- date_cols(t.mini, as_f=FALSE)
b.mini <- date_cols(b.mini, as_f=FALSE)
me.mini <- date_cols(me.mini, as_f=FALSE)
e.mini <- date_cols(e.mini, as_f=FALSE)

# ---- 2. Checklists over Time ----
# #Use the cpy function to get checklists per year
f.cpy <- cpy_func(f.mini, f.cpy)
t.cpy <- cpy_func(t.mini, t.cpy)
b.cpy <- cpy_func(b.mini, b.cpy)
me.cpy <- cpy_func(me.mini, me.cpy)
e.cpy <- cpy_func(e.mini, e.cpy)


# ## Based on this graph, I'll set the cutoff at 2000 and only look at data
# #::: after that date (and before 2023, which has fewer checklists bc the
# #::: year isn't over yet)
f.mini.c <- cutoff_rows(f.mini, f.mini, 2000, 2022)
t.mini.c <- cutoff_rows(t.mini, t.mini, 2000, 2022)
b.mini.c <- cutoff_rows(b.mini, b.mini, 2000, 2022)
me.mini.c <- cutoff_rows(me.mini, me.mini, 2000, 2022)
e.mini.c <- cutoff_rows(e.mini, e.mini, 2000, 2022)

f.cpy.c <- cpy_func(f.mini.c, f.cpy.c)
t.cpy.c <- cpy_func(t.mini.c, t.cpy.c)
b.cpy.c <- cpy_func(b.mini.c, b.cpy.c)
me.cpy.c <- cpy_func(me.mini.c, me.cpy.c)
e.cpy.c <- cpy_func(e.mini.c, e.cpy.c)


