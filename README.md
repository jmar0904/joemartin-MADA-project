## MADA Project

Last updated 12 December 2021

### Instructions

To fully reproduce this project, only the files in the code folder are needed. Run them in this order to test all code:

1) `code/processing_code/processing_code.R` - This is the data processing file. All necessary data files will load into here and produce the final, clean dataset. 

2) `code/analysis_code/exploratory_analysis.R` - This file produces many of the figures used in the final paper

3) `code/analysis_code/modeling_performance.Rmd` - This markdown file is where all of the modeling occurred. 

4) `products/Manuscript/predicting_run_performance_final.Rmd` - Knit this markdown to view the final paper.

All other files in this repository are supplementary. Some files, like the Garmin Connect scraping script in the supplementary folder are not fully reproducible, but provide instructions for anyone wanting to explore scraping with RSelenium.

### Part 1 - Background and dataset

Part 1 of my MADA project contains data files for 2020, 2021, and my daily resting heart rate. Previous versions included more data that went further back in time. After attempting my initial models, these were eliminated because they lacked the features I was interested in.

### Part 2 - Data Processing

Part 2 of my project contains four datasets which come from google sheets: 2020 - present, the raw data from my Garmin watch, downloaded from the Garmin Connect website, and a dataframe with my resting heart rate (also from Garmin Connect). Later in the project, I included data scraped from the Garmin Connect website which isn't available in the export file they provide.

This part focuses on cleaning my Google sheets and scraped data. For the purpose of the project and the safety of my files, I imported all Google sheets using the `googlesheets4` package, then saved them as .rds before cleaning. Throughout the course of this project, I periodically refreshed these files to have the most recent data available. The final refresh I did took place on 24 October 2021. 

The main takeaway from this part of my project is that I have several variables that seem have strong correlations. The most immediately useful correlations to me are in stride and average pace, as well as cadence and average pace. At this part of the project, I determined that Average Pace (recorded in seconds), will be the target variable in my models.

### Part 3 - Preliminary Data Analysis

The file `Modeling Running Performance.Rmd` contains preliminary modeling results from the available Garmin data. The most relevant results from this document were added to the `runDataProject_master.Rmd` file. 

The data analysis in Part 3 focuses primarily on identifying the most relevant variables to this study. The objective is to gain a better understanding of the full data set, while setting up for the next part of the project in which these models will be refined to predict performance events. 

### Part 4 - Statistical Modeling

Part 4 of this project primarily focuses on testing different statistical models on the Garmin data. In part 3, average pace and aerobic training effect. I landed on average pace as my final target variable, with the long-term idea of predicting a realistic pace based on training conditions. 

I tried many iterations of different models, including 2 general linear regressions, a few random forests, and a LASSO regression. 

### Part 5 - Clean-up

This part of my project focused on cleaning and organizing the whole repository, updating readme files with better instructions and information to reproduce this project, and as well as more updates and attempts at creating a more accurate model. Finally, I made significant updates to prepare a more complete final paper. 

### Part 6 - Final Updates

This part of my project focused on completing the project - tying up loose ends, revising sections based on peer feedback, and creating a better manuscript. 