#---- date_cols ----
# Given data with date format YYYY-MM-DD, add
#::: year, month, and date in their own columns.
#::: modifies existing df, does not create a new one.
#::: requires that the date column is Obs.Date, which works for this data
#::: but needs modification for other sources.
#::: I will also sort the input df by year, then month, then day.

date_cols <- function(data.in, as_f){
  if(as_f==FALSE){
    data.in$Year <- format(data.in$Obs.Date, '%Y') %>% as.numeric()
    data.in$Month <- format(data.in$Obs.Date, '%m') %>% as.numeric()
    data.in$Day <- format(data.in$Obs.Date, '%d') %>% as.numeric()
    data.in <- arrange(data.in, Year, Month, Day)
  }else{
    data.in$Year <- format(data.in$Obs.Date, '%Y') %>% as.factor()
    data.in$Month <- format(data.in$Obs.Date, '%m') %>% as.factor()
    data.in$Day <- format(data.in$Obs.Date, '%d') %>% as.factor()
    data.in <- arrange(data.in, Year, Month, Day)
  }
 
  return(data.in)
}


#---- cpy_func ----
#Count the number of checklists in a given year.
#::: Requires that years in df are in a column called "Years"
cpy_func <- function(data.in, name.out){
  years <- unique(data.in$Year)
  vec <- rep(0, length(years))
  #prepare matrix that has years in the first column and filled in with 0's
  #::: in the second column (for storage)
  cpy.mat <- matrix(c(years, vec), nrow=length(years), ncol=2)
  
  #loop through all the years, get the rows that have those years,
  #and count how many rows we've extracted. 
  #store that row count in the storage matrix
  for(i in 1:length(years)){
    rows <- which(data.in$Year==years[i], arr.ind=TRUE)
    cpy.mat[i, 2] <- length(data.in[rows,][,1])
  }
  name.out <- data.frame(Year = cpy.mat[,1], Number.Lists=as.numeric(cpy.mat[,2]))
  return(name.out)
}


#---- cpmy_func ----
#get checklists per month per year
cpmy_func <- function(data.in){
  x <- data.in
  x$Year = year(data.in$observation_date)
  x$Month = month(data.in$observation_date)
  x <- group_by(x, Year, Month) %>%
    summarize(Checklists=n()) %>%
    ungroup()
  return(x)
}

#---- cutoff_rows ----
#Removes rows whose year is strictly LESS than the cutoff value.
cutoff_rows <- function(data.in, name.out, lb, ub){
  name.out <- data.in[which(data.in$Year > lb & data.in$Year < ub), ]
  return(name.out)
}


#---- month_cpue_list ----
#Requires Year, Month as factors
#Make grouped_df by year
#On each group (each year), for each month,
#count the number of "TRUE"s in the species_observed column
  ## ie., how many checklists the species appeared on
#Divide this by number of lists in that month and year
#

month_cpue_list <- function(data.in, data.out, species){
  # want to (1) make a yearmo column for easy plotting; (2) for each year-mo
  #combination, calculate CPUE; and (3) return this new df as data.out
  data.out <- data.in
  data.out$Year_Mo = zoo::as.yearmon(data.in$observation_date)
  data.out <- group_by(data.out, Year_Mo) %>%
    summarize(CPUE=sum(species_observed)/n()) %>%
    ungroup()
  data.out$Species <- as.factor(rep(species, nrow(data.out)))
  return(data.out)
}


#---- to_spatial_years ----
#need year.start and year.end as characters 'yyyy-mm-dd'
to_spatial_years <- function(data.in, year.start, year.end){
  #make an interval
  int <- interval(ymd(year.start), ymd(year.end))
  
  #subset years we want
  year.data <- subset(data.in, observation_date %within% int)
  
  #transform that data to a sf format
  spatial <- year.data %>% st_as_sf(coords=c('longitude', 'latitude'), crs=4326) %>%
    #convert to UTM zone 19
    st_transform(crs=32619)
  
  return(spatial)
}

#----make_freq ----
#calculates CPUE for each raster square
make_freq <- function(data.in){
  #make a raster template from input data (has to be previously converted to sf)
  raster.template <- raster::raster(as(data.in, 'Spatial'), res=10000)
  
  #generate frequencies for each raster square
  r.freq <- raster::rasterize(data.in, 
                              raster.template, 
                              field='species_observed', fun=mean) 
  freq.df <- raster::as.data.frame(r.freq, xy=TRUE)
  names(freq.df)[3] <- 'frequency'
  return(freq.df)
}

#---- make_xy ----
#Given a weeks x years matrix, generate an x vector and a y vector
#::: for easy use in the loess_reg function.
make_xy <- function(data.in)
{
  num.weeks <- dim(data.in)[1] #number of weeks is the number of rows
  num.years <- dim(data.in)[2] #number of years is the number of columns
  
  x.vec <- c()
  #create an empty x storage vector
  y.vec <- c()
  #create an empty y storage vector
  
  for(i in 1:num.weeks)
  {
    #go through all the weeks; for each week replicate, add
    #:: an appropriate x and y
    x.vec <- c(x.vec,rep(i,num.years)) 
    y.vec <- c(y.vec,data.in[i,])
  }
  
  # generate a matrix that has x vector in column 1 and y vector in column 2
  return(cbind(x.vec,y.vec))
}

#---- make_week ----
## Generate a dataframe and a matrix. Dataframe for ease of plotting;
#::: has week, year, CPUE, and species as columns.
#::: Matrix for LOESS regression: 2 column matrix where x values 
#::: (week; eg., 1,1,1,1,...,2,2,...) are in the first column
#::: and corresponding y-values are in the second column.
#use lubridate's week function to get the week of the observation date
#same with year

make_week <- function(data.in, species){
  #make a data frame that's better for plotting...
  x <- mutate(data.in, Week = week(observation_date),
                     Year = year(observation_date))
  x <- group_by(x, Week, Year) %>%
    summarize(CPUE=sum(species_observed)/n())
  x$Species <- rep(species, nrow(x))
  #and a matrix that's better for model fitting.
  #::: weeks will be the rows, years will be the columns
  y <- unique(x$Year)
  w <- seq(1, 53, by=1)
  week.dimnames <- list(paste0('week', w), y)
  week.mat <- matrix(data=x$CPUE, nrow=length(w), ncol=length(y),
                     byrow=TRUE, dimnames=week.dimnames) %>%
    make_xy()
  l <- list(x, week.mat)
  names(l) <- c('df', 'mat')
  return(l)
}

#---- weighted_mean ----
#Calculate the weighted mean given a vector of values and a vector of weights
weighted_mean <- function(x,w)
{
  #get any values that are not NA and are not negative infinity
  #::: for my purposes, this should be all of them
  vals <- which(!is.na(x)&(x>-Inf))
  
  #calculate weighted mean by multiplying 
  #:::appropriate value by appropriate weight, dividing by the
  #::: sum of the weights
  w.m <- sum(w[vals]*x[vals], na.rm=TRUE)/sum(w[vals], na.rm=TRUE)
  return(w.m)
}
#---- weighted_cov ----
#Calculate the weighted covariance given a vector of x-values, 
#::: a vector of associated y-values,
#::: and a vector of weights.
weighted_cov <- function(x,y,w)
{
  #get the rows for which both x and y are defined
   vals <- which(!is.na(x)&!is.na(y)&(y>-Inf))
   #if there are rows for which they're both defined,calculate the covariance.
   #::: if not, throw an NA.
  if (length(vals)>1)
  {
    #get weighted mean in x and weighted mean in y
    x.w <- weighted.mean(x[vals],w[vals])
    y.w <- weighted.mean(y[vals],w[vals])
    
    #calculate weighted covariance
    w.cov <- sum(
      (x[vals]-x.w)*(y[vals]-y.w),
      na.rm=TRUE)
    return(w.cov)
    
  }else 
  {
    return(NA)
  }
  
}

#---- local_reg ----
# Given an x vector, a y vector, a center value, and an epsilon (sd of normal),
#::: execute a local regression.
local_reg <- function(x,y,center,epsilon)
{
  #generate weights using dnorm. Generate weights for all the x positions
  w <- dnorm(x, mean=center, sd=epsilon)
  
  #calculate the slope by dividing weighted covariance of x and y
  #::: by weighted covariance of x and x
  a <- weighted_cov(x,y,w)/weighted_cov(x,x,w)
  
  #calculate the intercept
  b <- weighted_mean(y,w) - a*weighted_mean(x,w)
  
  #calculate the error term
  error.term <- y - (a*x+b)

  #make sure you are only working with values that give an error term
  #::: that makes sense
  these <- which(error.term > -Inf)

  #sqrt(sum(weights*error^2)/sum(weights))
  s <- sqrt(sum(w[these]*error.term[these]^2,na.rm=TRUE)/sum(w[these],na.rm=TRUE))
  return(c(a,b,s))
}
#




#---- loess_reg ----
#execute a loess regression
loess_reg <- function(x,y,epsilon,mesh)
{
  
  ## find/create mesh
  min.x <- min(x,na.rm=TRUE)
  max.x <- max(x,na.rm=TRUE)
  
  x.seq <- seq(min.x,max.x,length.out=mesh)
  
  ## create out matrix
  out <- matrix(0,nrow=mesh,ncol=4)
  
  colnames(out) <- c("x","a","b","s")
  for(j in 1:mesh)
  {
    ## col 1 = x value in this iteration
    ## col 2 = slope
    ## col 3 = intercept
    ## col 4 = "s"
    
    out[j,] <- c(x.seq[j], local_reg(x,y, x.seq[j],epsilon))
  }
 out.df <- as.data.frame(out) %>% mutate(y=a*x+b)
 return(out.df)
}

#---- year_resids ----
#need data.in to have a Week column
#and loess.in to have columns x, y, etc.
year_resids <- function(data.in, loess.in){
  w <- unique(data.in$Week)
  years <- unique(data.in$Year)
  n <- length(years)
  #get the rows that have whole number weeks to get appropriate predictions
  pred.y <- filter(loess.in, x==round(x))$y
  res <- 0
  y <- 0
  for(i in years[1]:years[n]){
    obs.y <- filter(data.in, Year==i)$CPUE
    res <- c(res, obs.y-pred.y)
    y <- c(y, rep(i, length(obs.y)))
  }
  y <- y[-1]
  res <- res[-1]
  res.df <- data.frame(Year=y, Week=rep(w, n), Res = res)
}

#---- mean_diffs ----
mean_diffs <- function(data.in, means.in){
  years <- unique(data.in$Year)
  diffs <- 0
  y <- 0
  w <- unique(data.in$Week)
  for(i in years){
    obs.CPUE <- filter(data.in, Year==i)$CPUE
    diffs <- c(diffs, obs.CPUE-means.in)
    y <- c(y, rep(i, length(obs.CPUE)))
  }
  diffs <- diffs[-1]
  y <- y[-1]
  diff.df <- data.frame(Year=y, Week=rep(w, length(years)), Difference = diffs)
}
