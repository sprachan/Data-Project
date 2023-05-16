#---- 00. Notes and Descriptions: README ----
#Throughout this script, I use three colons (:::) to designate multiline comments.

# This script is designed to analyze Turkey Vulture (TUVU) and Fish Crow (FICR)
#::: range and timing shifts in Maine over time using eBird data. This is a wrapper
#::: for other scripts and sources the scripts in which data analysis takes place.

## Naming conventions: 
#Variables are named all lower-case with dots separating words
#Functions are named all lower-case with underscores separating words
#Data frames are named with an f for FICR or t for TUVU followed by a dot
#::: then the rest of the df name.
#Matrices are named ending with .mat

#Dependencies where I used the whole package are listed below, but I also
#::: use functions from "raster" and "zoo" packages; I did not load those packages
#::: in the preamble because they mask some base functions that I wanted to keep
#::: unambiguous.
#I used "raster" package functions to translate my data into a raster map.
#I used "zoo" package functions to make "yearmon" objects that have year and month
#::: without requiring a day as well. Makes plotting and manipulation of
#::: year-month level data (as opposed to year-month-day level data) easier.

## Code created Spring 2023 for Math 2606 Statistics Data Project by Sejal Prachand

#---- 0. Load Dependencies ----
#for graphs and graphics
library(ggplot2) 
library(viridis)

#for data manipulation
library(dplyr)
library(lubridate)

#for handling eBird data nicely.
library(auk)

#for mapping
library(sf)
library(rnaturalearth)
library(rnaturalearthhires)
#---- 1. Functions ---- 
## All the functions that will be used in all of the scripts.

source('./scripts/functions.R')

#---- 2. Load and Format Data ----
auk_set_ebd_path('./data', overwrite=TRUE)

## Load data from custom downloads (FICR and TUVU) and previous extraction
#::: (BCCH, EAPH)
ficr <- read_ebd('./data/FICR_ebird.txt', sep='\t')
tuvu <- read_ebd('./data/TUVU_ebird.txt', sep='\t')

#Load data that was stored as .Rdata for space

load('./data/R_Data/ebd_dfs/bcch_eaph.RData')
load('./data/R_Data/zf/bcch_zf.RData')
load('./data/R_Data/zf/eaph_zf.RData')
load('./data/R_Data/zf/ficr_zf.RData')
load('./data/R_Data/zf/tuvu_zf.RData')
load('./data/R_Data/ebd_dfs/me_sample.RData')

#---- 3. Checklists per Year ----
## Calculate number of checklists per year for each species
##::: and for random sample of all maine data

source('./scripts/cpy.R')

#---- 4. First Sightings ---- 
## First sightings for each year (at monthly level)
source('./scripts/firsts.R')



#---- 5. Abundance over Time ----
## Calculate abundance for each year at the monthly level

source('./scripts/abundance.R')


#---- 6. Mapping ----
## Map abundance in the state of Maine
source('./scripts/mapping.R')

#----7. Model Fitting ----
source('./scripts/model_fitting.R')

#----8. Model Checking ----
source('./scripts/model_checking.R')



