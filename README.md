## MADA Project

Last updated 26 November 2021
* Rmd file "runDataProject_part1" was renamed to "runDataProject_master". Future results and deliverables will be published in this document until the final version is complete.

### Instructions

To fully reproduce this project, just a few of the available files are needed. Run them in this order to test all code:

1) code/processing_code/mada_project_part2.R - This is the data processing file. All necessary data files will load into here and produce the final, clean dataset. 

2) code/analysis_code/exploratory_analysis.R

3) products/runDataProject_master.Rmd

All other files in this repository are supplementary. The file code/processing_code/garminConnectScrape.R is not fully reproducible, but included as a supplement to show how I scraped data from my Garmin account. The markdown file and associated pdf and html files named products/Modeling Running Performance.Rmd are fully reproducible, but were used to explore different models for this master file.

### Part 1 - Background and dataset

Part 1 of my MADA project contains data files for 2020, 2021, and my daily resting heart rate. Previous versions included more data that went further back in time. After attempting my initial models, these were eliminated becuase they lacked the features I was interested in.

R Markdown file answers questions outlined on MADA website: https://andreashandel.github.io/MADAcourse/Project_Rubric.html

### Part 2 - Data Processing

Part 2 of my project contains four datasets which come from google sheets - 2020 - present, the raw data from my Garmin watch, downloaded from the Garmin Connect website, and a dataframe with my resting heart rate (also from Garmin Connect). Later in the project, I included data scraped from the Garmin Connect website which isn't available in the export file they provide.

This part focuses on cleaning my Google sheets and scraped data. For the purpose of the project and the safety of my files, I imported all Google sheets using the googlesheets4 package, then saved them as .rds before cleaning. Throughout the course of this project, I will periodically refresh these files to have the most recent data available. The final refresh I did took place on 24 October 2021. 

The main takeaway from this part of my project is that I have several variables that seem have strong correlations. The most immediately useful correlations to me are in stride and average pace, as well as cadence and average pace. At this part of the project, I determined that Average Pace (recorded in seconds), will be the target variable in my models.


### Part 3 - Preliminary Data Analysis

Part 3 of this project focuses primarily on the data set exported and scraped from Garmin Connect. Part 2 of this project was updated to add new variables (speed in mph, anaerobic training effect, and associated binary variables) to aid in building linear regression and logistic regression models. 

The Rmd file "Modeling Running Performance" contains preliminary modeling results from the available Garmin data. The most relevant results from this document were added to the runDataProject_master.Rmd file. 

The data analysis in Part 3 focuses primarily on identifying the most relevant variables to this study. The objective is to gain a better understanding of the full data set, while setting up for the next part of the project in which these models will be refined to predict performance events. 

Structure Update:

products ->
runDataProject_master.Rmd
Modeling Running Performance.Rmd

### Part 4 - Statistical Modeling

Part 4 of this project primarily focuses on testing different statistical models on the Garmin data. In part 3, average pace and aerobic training effect. I landed on average pace as my final target variable, with the long-term idea of predicting a realistic pace based on training conditions. 

Setting up these models, the assumption was that a random forest would provide strong prediction power. After trying several models, I realized that my data set has many features (more than 20). I finally landed on using a LASSO regression to select relevant predictors for me, resulting in an improved RMSE. 

### Part 5 - Clean-up

This part of my project focused on cleaning and organizing the whole repository, updating readme files with better instructions and information to reproduce this project, and as well as more updates and attempts at creating a more accurate model. Finally, I made significant updates to prepare a more complete final paper. 