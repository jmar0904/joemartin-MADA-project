#### Instructions
8 October 2021

In order to reproduce this project, begin by running the script "mada_project_part2.R", located in "~code/processing_code". The output from this script are four clean data sets which will be used for analysis. 

An exploratory analysis named "exploratory_analysis.R" is located in "~/code/analysis_code". This file produces several preliminary figures that explore the clean datasets.

Later analyses will be saved in the analysis_code folder and shared in the master project document. 

29 October 2021

"mada_project_part2.R" was updated to resolve issues with reproducibility. New coded added introduces new data scraped from Garmin Connect and joined to the main Garmin Connect export data. 

garminConnectScrape.R may not be reproducible for all users. It requires a Garmin Connect account and data. Instructions for starting a remote driver with Selenium are included. End of script contains some of the data cleaning done to the raw data.

Binary variables generated to describe distance of run (short,middle,long).