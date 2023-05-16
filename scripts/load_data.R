#---- 0. Notes ----
# DO NOT RUN THIS CODE IF NOT NEEDED.
#
# This script is designed to extract data from the Maine EBD set.
# Allows me to keep better hygiene with my main script, dataproject.R.
#
#
# Rather than running time- and CPU-intensive AWK scripts every time
# We execute dataproject.R, this script can be run once and makes 
# The data appropriately available to dataproject.R.
#
#
# This script should only be run ONCE. It is CPU demanding (especially the
# first part of code part 3), so it purposefully saves objects as .RData
# and some as .txt files for later access. 
#
#
# Code written Spring 2023 by Sejal Prachand for Statistics Data Project.
#
#---- 1. Dependencies ----
#auk is a front-end for AWK specifically designed for use with eBird data.
library(auk)

#loading magrittr for the pipe command
library(magrittr)
#---- 2. All ME, BCCH, and EAPH ----
## Setup Ebird Path 
auk_set_ebd_path("./data", overwrite=TRUE)

## Load BCCH from all-Maine data-set
#output file name
bcch.output <- './data/BCCH_ebird.txt'

# Create filter object so Auk can do all this for me

#spits out BCCH data as a .txt file for later use
bcch.filter <- auk_ebd(file='./data/all_ME_ebird.txt', sep='\t') %>%
  auk_species('Black-Capped Chickadee') %>%
  auk_complete() %>%
  auk_filter(file=bcch.output, overwrite=TRUE)

#Load EAPH from all-Maine dataset
output.file <- './data/EAPH_ebird.txt'
eaph.filter <- auk_ebd(file='./data/all_ME_ebird.txt', sep='\t') %>%
  auk_species('Eastern Phoebe') %>%
  auk_complete() %>%
  auk_filter(file=output.file, overwrite=TRUE)
#spits out EAPH data as a .txt file for later use.

bcch <- read_ebd('./data/BCCH_ebird.txt', sep='\t')
eaph <- read_ebd('./data/EAPH_ebird.txt')

#me.rs <- read_ebd('./data/sample_ME_ebird.txt')
save(bcch, eaph, file='bcch_eaph.RData')
#save(me.rs, file='me_sample.RData')

me.rs.x <- read_ebd('./data/x_out_sample_ME_ebird.txt')
save(me.rs.x, file='./data/R_Data/me_sample.RData')

#---- 3. Presence-Absence Zero-Filling ----
## Filter SED to just Maine Data
years <- seq(2000, 2022, by=1)


auk_sampling('sampling_data.txt') %>%
  auk_complete() %>%
  auk_state('US-ME') %>%
  auk_year(years) %>%
  auk_filter(file='ME_SED.txt')

auk_ebd('FICR_ebird.txt', file_sampling='sampling_data.txt') %>%
  auk_complete() %>%
  auk_state('US-ME') %>%
  auk_year(years) %>%
  auk_species('Fish Crow')

#---- Fish Crow ----

auk_ebd('FICR_ebird.txt', file_sampling='sampling_data.txt') %>%
  auk_year(years) %>%
  auk_complete() %>%
  auk_state('US-ME') %>%
  auk_species('Fish Crow') %>%
  auk_filter(file='./data/filtered/FICR_filtered.txt', 
             file_sampling='./data/filtered/FICR_SED_filter.txt',
             overwrite=TRUE)

ficr.zf <- auk_zerofill('./data/filtered/FICR_filtered.txt', 
                        sampling_events='./data/filtered/FICR_SED_filter.txt',
                        collapse=TRUE)
# save(ficr.zf, file='./data/R_Data/ficr_zf.RData')
# load('./data/R_Data/ficr_zf.RData')
save(ficr.zf, file='./data/R_Data/ficr_zf_large.RData')
ficr.zf %>% dplyr::select(checklist_id, latitude, longitude,
                          observation_date, scientific_name, observation_count,
                          species_observed) %>% 
  save(file='./data/R_Data/ficr_zf.RData')

load('./data/R_Data/zf_large/ficr_zf_large.RData')
ficr.zf <- dplyr::select(.data=ficr.zf, checklist_id, latitude, longitude,
                         observation_date, scientific_name, observation_count,
                         species_observed)
save(ficr.zf, file='./data/R_Data/zf/ficr_zf.RData')

#---- Turkey Vulture ----
auk_ebd('TUVU_ebird.txt', file_sampling='sampling_data.txt') %>%
  auk_year(years) %>%
  auk_complete() %>%
  auk_state('US-ME') %>%
  auk_species('Turkey Vulture') %>%
  auk_filter(file='./data/filtered/TUVU_filtered.txt', 
             file_sampling='./data/filtered/TUVU_SED.txt', overwrite=TRUE)
tuvu.zf <- auk_zerofill('./data/filtered/TUVU_filtered.txt',
                        sampling_events='./data/filtered/TUVU_SED.txt',
                        collapse=TRUE)
#save(tuvu.zf, file='./data/R_Data/tuvu_zf.RData')

load('./data/R_Data/zf_large/tuvu_zf_large.RData')

save(tuvu.zf, file='./data/R_Data/tuvu_zf_large.RData')

tuvu.zf <- dplyr::select(tuvu.zf, checklist_id, latitude, longitude,
                          observation_date, scientific_name, observation_count,
                          species_observed)
save(tuvu.zf, file='./data/R_Data/zf/tuvu_zf.RData')


# ---- Black-Capped Chickadee ----
auk_ebd('BCCH_ebird.txt', file_sampling='sampling_data.txt') %>%
  auk_year(years) %>%
  auk_complete() %>%
  auk_state('US-ME') %>%
  auk_species('Black-Capped Chickadee') %>%
  auk_filter(file='./data/filtered/BCCH_filtered.txt', 
             file_sampling='./data/filtered/BCCH_SED_filter.txt',
             overwrite=TRUE)
bcch.zf <- auk_zerofill('./data/filtered/BCCH_filtered.txt',
                        sampling_events='./data/filtered/BCCH_SED_filter.txt',
                        collapse=TRUE)
bcch.zf %>% dplyr::select(checklist_id, latitude, longitude,
                          observation_date, scientific_name, observation_count,
                          species_observed) %>%
  save(file='./data/R_Data/bcch_zf.RData')
save(bcch.zf, file='./data/R_Data/bcch_zf_large.RData')

load('./data/R_Data/zf_large/bcch_zf_large.RData')

bcch.zf <- dplyr::select(.data=bcch.zf, checklist_id, latitude, longitude,
                               observation_date, scientific_name, observation_count,
                               species_observed)
save(bcch.zf, file='./data/R_Data/zf/bcch_zf.RData')


#---- Eastern Phoebe ----
auk_ebd('EAPH_ebird.txt', file_sampling='sampling_data.txt') %>%
  auk_year(years) %>%
  auk_complete() %>%
  auk_species('Eastern Phoebe') %>%
  auk_state('US-ME') %>%
  auk_filter(file='./data/filtered/EAPH_filtered.txt', 
             file_sampling='./data/filtered/EAPH_SED_filter.txt',
             overwrite=TRUE)
eaph.zf <- auk_zerofill('./data/filtered/EAPH_filtered.txt',
                        sampling_events='./data/filtered/EAPH_SED_filter.txt',
                        collapse=TRUE)
save(eaph.zf, file='./data/R_Data/eaph_zf_large.RData')
eaph.zf %>% dplyr::select(checklist_id, latitude, longitude,
                          observation_date, scientific_name, observation_count,
                          species_observed) %>% 
  save(file='./data/R_Data/eaph_zf.RData')

load('./data/R_Data/zf_large/eaph_zf_large.RData')
eaph.zf <- dplyr::select(.data=eaph.zf, checklist_id, latitude, longitude,
                         observation_date, scientific_name, observation_count,
                         species_observed)
save(eaph.zf, file='./data/R_Data/zf/eaph_zf.RData')