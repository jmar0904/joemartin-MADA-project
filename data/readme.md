## data folder

### Raw Data

#### Run Journals
These four files were imported from Google Sheets and saved as rds files. df2021.rds is updated at each project checkpoint to provide current data. 

#### Garmin Data

dailyRHR.csv is resting heartrate data from Garmin Connect 

garmin20211024.csv is the latest data export from the Garmin Connect activity logs. 

garminScrape1.csv and garminScrape1dates.csv are preliminary results from the Garmin Connect website scrape, which brougth in extra varaibles like anaerobic training effect and speed in miles per hour. They are not currently used in any scripts and were saved here as a back-up.

garminScrape1dates-final.csv and garminScrape-final.csv are the final raw results of the Garmin Connect website scrape. 

garmingScrapedf.csv is the result of the previous two files being joined and cleaned for better use. 

### Processed Data

garmin_data.rds now consists of data joined from the Garmin Connect export and Garmin Connect website scrape in the processing script (mada_project_part2.R). This data source will be the primary source for this project and perhaps the only source moving forward.

resting_heart_rate.rds consists of date and resting heart rate in beats per minute. Exported from Garmin Connect. 

run_data_complete.rds contains every date from Jan 1, 2013 through Dec 31, 2021 with NA values where there was no activity. run_data_clean.rds is the same data without the NA values.