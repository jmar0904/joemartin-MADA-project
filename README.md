## MADA Project

Last updated 8 October 2021
* Rmd file "runDataProject_part1" was renamed to "runDataProject_master". Future results and deliverables will be published in this document until the final version is complete.

### Part 1 - Background and dataset

Part 1 of my MADA project contains five data files - historical data from 2013-2018, individual .csv files for 2019, 2020, and 2021, and my daily resting heart rate. 

R Markdown file answers questions outlined on MADA website: https://andreashandel.github.io/MADAcourse/Project_Rubric.html

### Part 2 - Data Processing

Part 2 of my project contains four datasets which come from google sheets - historical data from 2013-2018, my running journal from 2019 - present, the raw data from my Garmin watch, downloaded from the Garmin Connect website, and a dataframe with my resting heart rate (also from Garmin Connect).

This part focuses on cleaning my Google sheets. For the purpose of the project and the safety of my files, I imported all Google sheets using the googlesheets4 package, then saved them as .rds before cleaning. Throughout the course of this project, I will periodically refresh these files to have the most recent data available. 

In Part 2, I primarily cleaned my data so I was able to coerce it into proper data types. With that said, there are still primarily two features I need to learn to clean more effectively. My average pace variables gave me problems every way I tried to coerce them. Lubridate and hms::as_hms both did not allow me to plot this variable on a continuous scale and made this data inaccessible. Therefore, I used as.POSIXct to use my average pace data immediately. I will need to learn more about time series analysis in order to use my split data more effectively. 

The main takeaway from this part of my project is that I have several variables that seem have strong correlations. The most immediately useful correlations to me are in stride and average pace, as well as cadence and average pace. 


### Part 3 - Preliminary Data Analysis

Part 3 of this project focuses primarily on the data set exported and scraped from Garmin Connect. Part 2 of this project was updated to add new variables (speed in mph, anaerobic training effect, and associate binary variables) to aid in building linear regression and logistic regression models. 

The Rmd file "Modeling Running Performance" contains preliminary modeling results from the available Garmin data. The most relevant results from this document were added to the runDataProject_master.Rmd file. 

The data analysis in Part 3 focuses primarily on identifying the most relevant variables to this study. The objective is to gain a better understanding of the full data set, while setting up for the next part of the project in which these models will be refined to predict performance events. 

Structure Update:

products ->
runDataProject_master.Rmd
Modeling Running Performance.Rmd

