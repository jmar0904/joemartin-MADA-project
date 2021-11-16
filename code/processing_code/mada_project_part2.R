#Load packages
pacman::p_load(pacman, tidyverse, googlesheets4, lubridate, here)

#Load training journals from 2019 - Present
#Each project checkpoint, I'll use googlesheets4 to refresh my data
#df2021 <- read_sheet()

#load data - last refreshed on 10/28/2021
df2021 <- read_rds(here::here("data","raw_data","df2021.rds"))
df2020 <- read_rds(here::here("data","raw_data","df2020.rds"))
df2019 <- read_rds(here::here("data","raw_data","df2019.rds"))
df1318 <- read_rds(here::here("data","raw_data","df1318.rds"))

#Load data from Garmin - includes run, cycle, swim, other
garmin <- read_csv(here::here ("data","raw_data", "garmin20211024.csv"))

#Load Resting heart rate data
rhr <- read_csv(here::here("data","raw_data","dailyRHR.csv"))

# Start binding and joining datasets. 
# My goal for putting these sheets together is to start from the earliest date (January 20,2013).
# All dates will be included, including dates I did not run. When all data is loaded, I will use iso_week() to add the week number to each year (Monday - Sunday). This will allow me to track run frequency as a variable.
# All variables will be included and there will be a lot of NAs from 2013 through 2019 as a result.

# Start by clearning Garmin data. This needs to be filtered so the only activity type is RUNNING and sorted to start from the earliest date and end on the present date. 
# I will retain the garmin dataframe for future use, in case I want to analyze my cycling and swimming data, as well

# Separate date variable into date and time
garmin <- separate(garmin, col = "Date", into = c("date","start_time"), sep = " " )
# Reformat the date so they R can read them as a date, not character
garmin$date <- ymd(garmin$date)
garmin$day_time <- lubridate::hms(garmin$start_time)

# Arrange date from earliest to latest
garmin <- garmin %>% 
             arrange(date)

# Begin renaming columns
## All of my columns have inconvenient names that contain spaces, or similar names
### To keep my dataframes clean, these are the titles I will use: 

garmin <- garmin %>% rename ("activity_type" = `Activity Type`,
                                   "favorite" = Favorite,
                                   "title" = Title,
                                   "distance" = Distance,
                                   "calories" = Calories, 
                                   "time" = Time,
                                   "avg_hr" = `Avg HR`,
                                   "max_hr" = `Max HR`, 
                                   "aerobic_TE" = `Aerobic TE`,
                                   "avg_run_cadence" = `Avg Run Cadence`,
                                   "max_run_cadence" = `Max Run Cadence`,
                                   "avg_pace" = `Avg Pace`,
                                   "best_pace" = `Best Pace`,
                                   "total_ascent" = `Total Ascent`,
                                   "total_decent" = `Total Descent`,
                                   "avg_stride" = `Avg Stride Length`,
                                   "avg_vert_ratio" = `Avg Vertical Ratio`,
                                   "avg_vert_oscillation" = `Avg Vertical Oscillation`,
                                   "total_strokes" = `Total Strokes`,
                                   "avg_swolf" = `Avg. Swolf`,
                                   "avg_stroke_rate" = `Avg Stroke Rate`,
                                   "total_reps" = `Total Reps`,
                                   "total_sets" = `Total Sets`,
                                   "dive_time" = `Dive Time`,
                                   "surface_interval" = `Surface Interval`,
                                   "decompression" = Decompression,
                                   "best_lap_time" = `Best Lap Time`,
                                   "number_of_laps" = `Number of Laps`,
                                   "avg_resp" = `Avg Resp`,
                                   "min_resp" = `Min Resp`,
                                   "max_resp" = `Max Resp`,
                                   "stress_change" = `Stress Change`,
                                   "stress_start" = `Stress Start`,
                                   "stress_end" = `Stress End`,
                                   "avg_stress" = `Avg Stress`,
                                   "moving_time" = `Moving Time`,
                                   "elapsed_time" = `Elapsed Time`,
                                   "min_elevation" = `Min Elevation`,
                                   "max_elevation" = `Max Elevation`
                                   )   
#  There are a lot of useless variables in my data. They're mostly related to the functions of my watch I used 
### once or twice. I'm going to remove any variables that don't have meaning or useful data. 

# This will be my dataframe for analyzing performance including activities other than running. 
garmin <- garmin %>% select(-favorite, -avg_vert_ratio, -avg_vert_oscillation, -`Training Stress Score®`,-Grit,-Flow,-dive_time,-`Min Temp`,-surface_interval,-decompression,-`Max Temp`,-min_resp,-max_resp,-stress_change,-stress_start,-stress_end,-avg_stress, -avg_resp, -total_sets, -moving_time,-elapsed_time)

# garminRun will be my dataframe for analyzing only run-specific data
garminRun <- garmin %>% 
  select(-total_strokes,-avg_swolf,-avg_stroke_rate,-total_reps) %>%
  filter(activity_type == "Running")

# Now that my garmin data is complete, I need to bind my previous data. 

# I'm going to begin by getting the right 

df2020 <- df2020[-c(1,2),]
df2021 <- df2021[-c(1,2,3),]

# My google sheets are my running journal. I keep the top few rows as a "scoreboard" with my monthly mileage, goals, and current PRs. 
# The two lines of code above remove most of this, but I need to update the variable names now. 

# Rename variables for df2021
df2021 <- df2021 %>% rename("weekday" = `Current Personal Records`,
                           "date" = `...2`,
                           "goal" = `Mile`,
                           "workout" = `5:12`,
                           "start_time" = `5k`,
                           "run_type"= `18:50`,
                           "distance_type"  = `10k`,
                           "weather"  = `00:38:39`,
                           "location"  = `Half Marathon`,
                           "shoes"  = `01:24:42`,
                           "distance"  = `Marathon`,
                           "total_time"  = `4:07:34`,
                           "avg_pace"  = `...13`,
                           "splits"  = `...14`,
                           "notes"  = `...15`
)

#drop empty variables
df2021 <- df2021 %>% select(-workout,-goal,-`...16`,-`...17`,-`...18`,-`...19`,-`...20`,-`0`,-`...22`,-`...23`,-`...24`,-`...25`,-`...26`)

# Drop unnecessary variables and rename

df2020 <- df2020 %>% select(`Current Personal Records`,`...2`, `5:26`,`5k`,`19:43`,`10k`,`00:43:09`, `Half Marathon`, `01:36:29`,`Marathon`, `4:07:34`,`...15`,`...18`)


df2020 <- df2020 %>% rename("weekday" = `Current Personal Records`,
                            "date" = `...2`,
                            "start_time" = `5:26`,
                            "run_type" = `5k`,
                            "distance_type"= `19:43`,
                            "weather"  = `10k`,
                            "location"  = `00:43:09`,
                            "shoes"  = `Half Marathon`,
                            "distance"  = `01:36:29`,
                            "total_time"  = `Marathon`,
                            "avg_pace"  = `4:07:34`,
                            "splits"  = `...15`,
                            "notes"  = `...18`
)

# Fix 2019 Dataset

df2019 <- df2019 %>% select(-`Weight (lbs)`,-`Track Workout (Comma Delimited)`,-`Food Notes`,-`...17`)

df2019 <- df2019 %>% rename("weekday" = Day,
                            "date" = Date,
                            "start_time" = `Start Time`,
                            "run_type" = `Run Type`,
                            "distance_type"= `Distance Type`,
                            "weather"  = Weather,
                            "location"  = Location,
                            "shoes"  = Shoes,
                            "distance"  = `Distance (miles)`,
                            "total_time"  = `Total Time`,
                            "avg_pace"  = `Avg. Pace`,
                            "splits"  = `Splits (Comma delimited)`,
                            "notes"  = Notes
                            )

# Coerce data from each table (2019 - 2021) so they can be bound together

# weekday
df2021$weekday <- as.character(df2021$weekday)

# date
df2019$date <- mdy(df2019$date)
df2020$date <- mdy(df2020$date)
df2021$date <- mdy(df2021$date)

# start_time
df2019$start_time <- as.character(df2019$start_time)
df2020$start_time <- as.character(df2020$start_time)
df2021$start_time <- as.character(df2021$start_time)

# run_type
df2020$run_type <- as.character(df2020$run_type)
df2021$run_type <- as.character(df2021$run_type)

# weather
df2020$weather <- as.character(df2020$weather)
df2021$weather <- as.character(df2021$weather)

#shoes
df2020$shoes <- as.character(df2020$shoes)
df2021$shoes <- as.character(df2021$shoes)

# distances have to be converted to character data before they can be coerced as.numeric. I'll go back to this after I bind rows.
df2019$distance <- as.character(df2019$distance)
df2020$distance <- as.character(df2020$distance)
df2021$distance <- as.character(df2021$distance)

# total_time
df2020$total_time <- as.character(df2020$total_time)
df2021$total_time <- as.character(df2021$total_time)

# avg_pace
df2020$avg_pace <- as.character(df2020$avg_pace)
df2021$avg_pace <- as.character(df2021$avg_pace)

# splits
df2019$splits <- as.character(df2019$splits)
df2020$splits <- as.character(df2020$splits)
df2021$splits <- as.character(df2021$splits)

# bind rows and create a dataset for 2019 - 2021. I'll call it df192021

df192021 <- bind_rows(df2019,df2020,df2021)



# Cleaning data from 2013 - 2018
## I put all of this data into a spreadsheet manually (the apps I used to record this data don't have good data policies)
## Theoretically, it should match up perfectly with 2019 - 2021
## After doing this, I'm going to do a full join on my garmin data, but retain df1321 to work with separately

df1318 <- df1318 %>% select(-weight)

df1318$date <- mdy(df1318$date)
df1318$start_time <- as.character(df1318$start_time)
df1318$run_type <- as.character(df1318$run_type)
df1318$distance_type <- as.character(df1318$distance_type)
df1318$distance <- as.character(df1318$distance)
df1318$average_pace <- as.character(df1318$average_pace)
df1318$splits <- as.character(df1318$splits)
df1318$notes <- as.character(df1318$notes)

df1318 <- df1318 %>% rename("weekday" = day,
                            "shoes" = run_shoes,
                            "avg_pace" = average_pace)

df1321 <- bind_rows(df1318,df192021)


#Now coerce data into proper types
# I'm going to create a datetime variable to have, as well
df1321$datetime <- paste(df1321$date,df1321$start_time, sep = ' ')

df1321$datetime <- as.POSIXct(df1321$datetime, format = "%Y-%m-%d %I:%M %p")

# run_type
df1321$run_type <- as.factor(df1321$run_type)
df1321$distance_type <- as.factor(df1321$distance_type)
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "Mid DIstance")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "7:21")
df1321$distance_type <- fct_recode(df1321$distance_type, "Long Distance" = "Disney Marathon")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "Mid-Distance")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "MId Distance")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "Mid Distnace")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "Race")
df1321$distance_type <- fct_recode(df1321$distance_type, "Mid Distance" = "Rest")

# weather
#separate into temperature and weather
df1321 <- separate(df1321, col = "weather", into = c("temperature","weather"), sep = ",")
df1321$weather <- trimws(df1321$weather)
df1321$weather <- as.factor(df1321$weather)
df1321$temperature <- as.numeric(df1321$temperature)

#shoes
df1321$shoes <- as.factor(df1321$shoes)

# distances have to be converted to character data before they can be coerced as.numeric. I'll go back to this after I bind rows.
df1321$distance <- as.numeric(df1321$distance)

# total_time
df1321$total_time <- lubridate::hms(df1321$total_time)

# avg_pace
# To examine average pace in my models, I will convert it from a MM:SS format to just seconds. For example, 8:02 will be 502
df1321 <- separate(df1321, col=avg_pace, into=c("min","sec"), sep = ":")

df1321$min <- as.numeric(df1321$min)
df1321$sec <- as.numeric(df1321$sec)

df1321$min <- df1321$min * 60

df1321$avg_pace_sec <- df1321$min + df1321$sec

# Deprecated. The Following code was used to convert average pace to HH:MM:SS format. Leaving it in case I need to use it again.
#df1321$min <- as.factor(df1321$min)

#df1321$min <- fct_recode(df1321$min, "05" = "5")
#df1321$min <- fct_recode(df1321$min, "06" = "6")
#df1321$min <- fct_recode(df1321$min, "07" = "7")
#df1321$min <- fct_recode(df1321$min, "08" = "8")
#df1321$min <- fct_recode(df1321$min, "09" = "9")

#df1321$avg_pace <- paste("00:",df1321$min,":",df1321$sec,sep = "")
#df1321 <- df1321 %>% select(-min,-sec)

#run_df$avg_pace <- hms::as_hms(run_df$avg_pace)

#df1321$avg_pace <- as.POSIXct(df1321$avg_pace, format = "%H:%M:%S")

#run_df$avg_pace <- lubridate::hms(run_df$avg_pace)

# all_data will be important to show run frequency by date. I'm also going to create a dataframe without NAs 

df1321$distance <- as.numeric(df1321$distance)

df1321$week <- isoweek(df1321$date)
# I think there are separate analyses I would want to do when combining Garmin data to my old dataset.
# I'll comment out this join until I need it or until I have more clarity about which specific variables I want to use in addition to the Garmin set.
#all_data <- left_join(df1321,garminRun, by = "date")

# New dataframe has no NAs###
run_df <- df1321 %>% drop_na(start_time)

#Don't forget resting heartrate! I'll coerce the data into the correct type and leave it alone until I need to join it
rhr$date <- mdy(rhr$date)

#Start running summary stats and basic plots to explore data and see if everything looks okay


summary(run_df) #Looking at my summary stats, I have at least one faulty entry for total time (showing I ran for 2 days!), and avg_pace is showing as character data

#Coerce my Garmin data to proper types

garminRun$calories <- as.numeric(garminRun$calories)
garminRun$time <- as.POSIXct(garminRun$time, format = "%H:%M:%S")
garminRun$avg_hr <- as.numeric(garminRun$avg_hr)
garminRun$max_hr <- as.numeric(garminRun$max_hr)
garminRun$aerobic_TE <- as.numeric(garminRun$aerobic_TE)
garminRun$avg_run_cadence <- as.numeric(garminRun$avg_run_cadence)
garminRun$max_run_cadence <- as.numeric(garminRun$max_run_cadence)

# fix average pace. Following the same format, this will be in seconds, only
garminRun <- separate(garminRun, col=avg_pace, into=c("avg_min","avg_sec"), sep = ":")

garminRun$avg_min <- as.numeric(garminRun$avg_min)
garminRun$avg_sec <- as.numeric(garminRun$avg_sec)

garminRun$avg_pace_sec <- ((garminRun$avg_min * 60) + garminRun$avg_sec)

# Deprecated. Use later if needed 
#garminRun$avg_min <- as.factor(garminRun$avg_min)

#garminRun$avg_min <- fct_recode(garminRun$avg_min, "05" = "5")
#garminRun$avg_min <- fct_recode(garminRun$avg_min, "06" = "6")
#garminRun$avg_min <- fct_recode(garminRun$avg_min, "07" = "7")
#garminRun$avg_min <- fct_recode(garminRun$avg_min, "08" = "8")
#garminRun$avg_min <- fct_recode(garminRun$avg_min, "09" = "9")

#garminRun$avg_pace <- paste("00:",garminRun$avg_min,":",garminRun$avg_sec,sep = "")


#garminRun$avg_pace <- as.POSIXct(garminRun$avg_pace, format = "%H:%M:%S")

#Best Pace
garminRun <- separate(garminRun, col=best_pace, into=c("best_min","best_sec"), sep = ":")
garminRun$best_min <- as.numeric(garminRun$best_min)
garminRun$best_sec <- as.numeric(garminRun$best_sec)

garminRun$best_pace_sec <- ((garminRun$best_min * 60) + garminRun$best_sec)

# Deprecated. Use later if needed.
#garminRun$best_min <- fct_recode(garminRun$best_min, "05" = "5")
#garminRun$best_min <- fct_recode(garminRun$best_min, "06" = "6")
#garminRun$best_min <- fct_recode(garminRun$best_min, "07" = "7")
#garminRun$best_min <- fct_recode(garminRun$best_min, "08" = "8")
#garminRun$best_min <- fct_recode(garminRun$best_min, "09" = "9")

#garminRun$best_pace <- paste("00:",garminRun$best_min,":",garminRun$best_sec,sep = "")

#garminRun$best_pace <- as.POSIXct(garminRun$best_pace, format = "%H:%M:%S")


garminRun$total_ascent <- as.numeric(garminRun$total_ascent)
garminRun$total_decent <- as.numeric(garminRun$total_decent)
garminRun$avg_stride <- as.numeric(garminRun$avg_stride)
garminRun$min_elevation <- as.numeric(garminRun$min_elevation)
garminRun$max_elevation <- as.numeric(garminRun$max_elevation)

garminRun$datetime <- paste(garminRun$date,garminRun$start_time, sep = " ")
garminRun$datetime <- ymd_hms(garminRun$datetime)

garminRun$week <- isoweek(garminRun$date)
### Save Data Files as RDS ###
# location to save file

save_data_location <- here::here("data","processed_data","run_data_clean.rds")
saveRDS(run_df, file = save_data_location) #clean data without NA dates

save_data_location <- here::here("data","processed_data","garmin_data.rds")
saveRDS(garminRun, file = save_data_location)#data from Garmin watch

save_data_location <- here::here("data","processed_data","run_data_complete.rds")
saveRDS(df1321, file = save_data_location) #clean data with NA dates. Keeping to preserve notes from days off

save_data_location <- here::here("data","processed_data","resting_heart_rate.rds")
saveRDS(rhr, file = save_data_location) 

### Added Data ###
# After scraping Garmin Connect, I was able to obtain data that is unavailable in my Garmin Connect exports. 
# I did minimal processing in that script (named garminConnectScrape.R) to add dates to the main data. 
# The code below processes the resulting csv files and adds them to garmin_data.rds

garmin_c_scrape <- read_csv(here::here("data","raw_data","garminScrapedf.csv"))


# Select only variables that are necessary to add

# There are a few more items I need to update in order to complete this new dataset
# remove units from values (calories burned, sweat loss, speed)
# split anaerobic and aerobic values into numeric value and factor value

# Remove labels
df_gs <- garmin_c_scrape %>% select(date,distance,calories_burned,`sweat_loss(ml)`,aerobic,anaerobic,avg_spd,avg_moving_spd,max_spd)
df_gs$distance <- as.numeric(gsub(" mi","",df_gs$distance))

df_gs$calories_burned <- str_remove(df_gs$calories_burned, " C")
df_gs$calories_burned <- as.numeric(str_remove(df_gs$calories_burned, ","))

df_gs$`sweat_loss(ml)` <- as.numeric(str_remove(df_gs$`sweat_loss(ml)`, " ml"))

df_gs$avg_spd <- as.numeric(str_remove(df_gs$avg_spd, " mph"))
df_gs$avg_moving_spd <- as.numeric(str_remove(df_gs$avg_moving_spd, " mph"))
df_gs$max_spd <- as.numeric(str_remove(df_gs$max_spd, " mph"))

# split numeric values from text values
df_gs <- separate(df_gs, col = "aerobic", into = c("aerobic_value", "aerobic_fct"), sep = " ", extra = "merge")
df_gs <- separate(df_gs, col = "anaerobic", into = c("anaerobic_value", "anaerobic_fct"), sep = " ", extra = "merge")
df_gs$aerobic_value <- as.numeric(df_gs$aerobic_value)
df_gs$anaerobic_value <- as.numeric(df_gs$anaerobic_value)

#create unique id variable to join scrape records with watch records. 
#Date and Distance should be sufficient

garminRun$id <- paste(garminRun$date,garminRun$distance,sep="-")
df_gs$id <- paste(df_gs$date,df_gs$distance,sep="-")

#Remove variables that will become duplicated
df_gs <- df_gs %>% select(-date,-distance)

garminRun1 <- left_join(garminRun,df_gs, by = "id")

#delete other useless variables
garminRun1 <- garminRun1 %>% select(-activity_type, -title)

pacman::p_load(fastDummies)

# Create variables with binary data. 0 is alway "absent" or "no", 1 is always "present" or "yes".
garminRun_bin <- garminRun1 %>% select(id, distance, calories,avg_hr,max_hr,avg_run_cadence,
                                       max_run_cadence,total_ascent,total_decent,avg_stride,min_elevation,
                                       max_elevation,avg_pace_sec,best_pace_sec,week,`sweat_loss(ml)`,
                                       aerobic_TE,aerobic_fct,anaerobic_value,anaerobic_fct,avg_spd,max_spd)

garminRun_bin$aerobic_fct <- as.factor(garminRun_bin$aerobic_fct)
garminRun_bin$anaerobic_fct <- as.factor(garminRun_bin$anaerobic_fct)

#create variable for run distance type. Below 6.22 miles is short distance, up to 12 is middle distance, above is long distance
#use a few extra decimals to account for extra .01 miles at the end of a run
#create these directly as binary variables
garminRun_bin$short_distance <- as.factor(ifelse(garminRun_bin$distance < 6.25, "Y","N"))
garminRun_bin$middle_distance <- as.factor(ifelse(garminRun_bin$distance > 6.25 & garminRun_bin$distance < 12.05, "Y","N"))
garminRun_bin$long_distance <- as.factor(ifelse(garminRun_bin$distance > 12.05, "Y","N"))



#save checkpoint
write_rds(garminRun_bin, here::here("data","processed_data","garmin_data.rds"))
