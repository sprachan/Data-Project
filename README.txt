This project is designed to analyze Turkey Vulture and Fish Crow range, abundance, and timing shifts over the last 2 decades in Maine.

I used Black-Capped Chickadee (BCCH), Eastern Phoebe (EAPH), Turkey Vulture (TUVU), and Fish Crow (FICR) eBird data from 2000-2023 in all analysis. 

I downloaded eBird sampling event data, all Maine eBird data, Fish Crow in Maine data, and Turkey Vulture in Maine data in April 2023. Data is available for free by request from eBird.org. If running this analysis on different versions of data, it's important to make sure that you are using the same versions of all of these data

------------------- Dependencies ------------------------
(1) Code language
All analysis carried out in R using RStudio IDE. I use RStudio's Project functionality for portability.

(2) Packages
I load numerous packages in R and use functions from a few others. These should all be installed prior to running the script.

Loaded packages
	a. For graphing and graphics: ggplot2, viridis
	b. For data manipulation: dplyr, lubridate (dates specifically)
	c. For working with eBird data: auk
	d. For mapping: sf, rnaturalearth, rnaturalearthhires

Packages that I use functions from but do not load in full to avoid masking helpful functions
	a. For working with year-month objects: zoo
	b. For creating and working with raster objects: raster


------------------- Description of Scripts ---------------
** all ggsave() commands are commented out to speed up runtime. To save generated plots, uncomment these.**

(1) load_data.R
This script DOES NOT need to be run to reproduce my analysis. This script extracts the relevant data from massive eBird data sets and saves them as .txt files or .RData to save space. 

(2) dataproject.R
This script serves as a wrapper for all other scripts. This is the only script that needs to be run in order to reproduce the analysis.

(3) firsts.R
Finds and plots first sightings for each focal species as part of EDA.

(4) cpy.R
Calculates and plots checklists per year for each focal species as part of EDA.

(5) abundance.R
Calculates and plots abundance for each species ("CPUE") over time. Additionally produces a "zoomed" plot to easily identify seasonal patterns of presence/absence.

(6) mapping.R
Rasterizes presence/absence data and maps them. I generate several maps. First, I mapped abundance data from 2000-2010 for each species, then data from 2011-2021 for each species (saved in decade_maps). Then, I mapped abundance data from 2010-2015 and 2016-2021 for each species (saved in fiveyear_maps).

(7) functions.R
This file contains all user-defined functions I used in this analysis. These are:
	a. date_cols. Adds "Year", "Month", and "Day" columns to a data frame that has an Obs.Date (observation date) column and optionally makes those columns into factors; cpy_func, 
	b. cpy_func. Counts the number of checklists in a given year. 
	c. cutoff_rows. Removes rows whose year is strictly LESS than the cutoff value.
	d. month_cpue_list. Creates a Year_Mo column that has every year-month combination of the data frame input; creates a CPUE ("catch per unit effort") column calculated as the number of checklists a species was observed on in a given year-month combination divided by the number of checklists in the same year-month combination.
	e. to_spatial_years. Converts a dataframe with longitude and latitude to a simple features (sf) dataframe that spans the input years (given in character format).
	f. make_freq. Given a spatial feature input, generates a raster grid and calculates observation frequency in each grid cell.

(8) model_fitting.R
This file generates a LOESS model for each species using weekly abundance data. I use my own "home cooked" LOESS function as opposed to R's built in function for a bit more flexibility.

(9) model_checking.R
Calculate residuals from the LOESS model (side effect of having my own LOESS models instead of R's).

(10) plotting.R
All of the plotting that I did. 

----------------- Developer Information and Acknowledgements ---------
Code created by Sejal Prachand in Spring 2023 for Math 2606 Statistics Data Project at Bowdoin College.

Help and consultation from Prof. Jack O'Brien, math department.