pacman::p_load(pacman, tidyverse, here)

### Load Data ###
run_df <- read_rds(here::here("data","processed_data","run_data_clean.rds"))
garminRun <- read_rds(here::here("data","processed_data","garmin_data.rds"))
rhr <- read_rds(here::here("data","processed_data","resting_heart_rate.rds"))

### Tables ###

#### TEST PLOTS ####

###Resting Heart Rate 
#I've yet to find a good solution for plotting average pace, which will be important to me. I'll need to work on this.

#Despite some outliers (which occur when I don't wear my watch all day and night), my resting heart rate seems to stay consistently around 47 BPM
rhr_plot <- rhr %>% ggplot(aes(x=date, y=`rhr(bpm)`))+
  geom_line()+
  geom_smooth(method = "lm")

rhr_plot
ggsave(here::here("figures","rhr_plot.png"), device = "png", scale = 1.5)

### Average Pace ###
avg_pace_ols <- lm(avg_pace_sec ~ ., garminRun)
summary(avg_pace_ols)

# Average Pace and Average Speed
avg_pace_avg_spd <- garminRun %>%
  ggplot(aes(x = avg_spd, y = avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color= "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Speed (in miles per hour)", y = "Average Pace (in seconds)")
avg_pace_avg_spd
ggsave(here::here("figures","avg_pace_avg_spd.png"), device = "png", scale = 1.5)

# 2013-2021 data
average_pace_1321 <- run_df %>% ggplot(aes(x=date, y= avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm")
average_pace_1321
ggsave(here::here("figures","avg_pace_1321.png"), device = "png", scale = 1.5)

# Average pace and temperature
# temperature does not seem to affect pace as much as I thought it would
avg_pace_temp <- run_df %>% filter(avg_pace_sec < 750) %>%
  ggplot(aes(x=temperature, y = avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
avg_pace_temp
ggsave(here::here("figures","avg_pace_temp.png"), device = "png", scale = 1.5)

# Long Disance Runs
ld <- run_df %>%
  filter(distance >= 12) %>%
  filter(date >= "2018-01-01") %>%
  ggplot(aes(x=date,y=avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm")
ld
ggsave(here::here("figures","avg_p_ld.png"), device = "png", scale = 1.5)

#### Investigate cadence and avg_pace ####

# Effect of Cadence on Average Pace
# Potentially strong relationship
cad_ap <-garminRun %>% ggplot(aes(x=avg_run_cadence, y=avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Run Cadence (Steps per minute)", y = "Average Pace (in seconds/mile)")
cad_ap
ggsave(here::here("figures","avg_pace_cadence.png"), device = "png", scale = 1.5)

#### 

#### Investigate aerobicTE and avg_pace ####
# Effect of Harder Aerobic Effort on Average Pace
ae_ap<- garminRun %>% ggplot(aes(x=aerobic_TE, y=avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Aerobic Training Effect", y = "Average Pace (in seconds/mile)")
ae_ap
ggsave(here::here("figures","ae_ap.png"), device = "png", scale = 1.5)
####

#### Investigate avg_hr and avg_pace ####
# Average Pace and Average Heart Rate
hr_ap <- garminRun %>% ggplot(aes(x=avg_hr, y = avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Heart Rate (beats per minute)", y = "Average Pace (in seconds/mile)")
hr_ap
ggsave(here::here("figures","hr_ap.png"), device = "png", scale = 1.5)
####

#### Investigate avg_pace and avg_stride ####
# Stride and Average Pace - seems to have a very strong relationship
st_ap <- garminRun %>% ggplot(aes(x=avg_stride, y = avg_pace_sec))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Stride Length(in meters)", y = "Average Pace (in seconds/mile)")
st_ap
ggsave(here::here("figures","st_ap.png"), device = "png", scale = 1.5)

####

# Temperature
# I'm less likely to run far when it gets hot out. 
fit1 <- lm(distance ~ temperature, run_df)
summary(fit1)

temp_dist <- run_df %>% ggplot(aes(x=temperature, y = distance))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
temp_dist
ggsave(here::here("figures","temp_dist.png"), device = "png", scale = 1.5)

# Ascent
#avg_hr, total_ascent
hr_ascent <- lm(avg_hr~total_ascent,garminRun)
summary(hr_ascent)

#### Investigate avg_hr and ascent ####
hr_ascent_plot <-garminRun %>% ggplot(aes(x=avg_hr, y = total_ascent))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Heart Rate (in beats per minute)", y = "Total Ascent (in feet)")
hr_ascent_plot
ggsave(here::here("figures","hr_ascent.png"), device = "png", scale = 1.5)
####

#### Investigate aerobicTE and ascent ####
ae_ta <- garminRun %>% ggplot(aes(x=aerobic_TE, y=total_ascent))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
ae_ta
ggsave(here::here("figures","ae_ta.png"), device = "png", scale = 1.5)
####

cadence_aerobicTE <- lm(avg_run_cadence~aerobic_TE, garminRun)
summary(cadence_aerobicTE)

#### Investigate aerobic TE and cadence ####
ca_at <- garminRun %>% ggplot(aes(x=avg_run_cadence, y=aerobic_TE))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
ca_at
ggsave(here::here("figures","ca_at.png"), device = "png", scale = 1.5)
####

#### Investigate cadence and stride ####
stride <- garminRun %>% ggplot(aes(x=avg_run_cadence, y=avg_stride))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Run Cadence (steps per minute)", y = "Average Stride Length (in meters)")
stride
ggsave(here::here("figures","stride.png"), device = "png", scale = 1.5)
####

#### Resting Heart Rate ####
# RHR and Average Pace
rhr_ap <- garminRun %>% ggplot(aes(x=avg_pace_sec, y=rhr))+
  geom_point()+
  geom_smooth(method = "lm", color = "red", se = FALSE)+
  theme_minimal()+
  labs(x = "Average Pace (in seconds per mile)", y = "Resting Heart Rate (in beats per minute)")
rhr_ap
ggsave(here::here("figures","rhr_ap.png"), device = "png", scale = 1.5)

#RHR and cadence
rhr_cad <- garminRun %>% ggplot(aes(x=avg_run_cadence, y=rhr))+
  geom_point()+
  geom_smooth(method="lm")
rhr_cad
ggsave(here::here("figures","rhr_cad.png"), device = "png", scale = 1.5)

#RHR and Stride
rhr_stride <- garminRun %>% ggplot(aes(x=avg_stride, y=rhr))+
  geom_point()+
  geom_smooth(method = "lm")
rhr_stride
ggsave(here::here("figures","rhr_stride.png"), device = "png", scale = 1.5)

rhr_distance <- garminRun %>% ggplot(aes(x=distance, y=rhr))+
  geom_point()+
  geom_smooth(method = "lm")+
  geom_smooth(color="red")
rhr_distance
ggsave(here::here("figures","rhr_dist.png"), device = "png", scale = 1.5)

rhr_avg_hr <- garminRun %>% ggplot(aes(x=avg_hr, y=rhr))+
  geom_point()+
  geom_smooth(method = "lm")+
  geom_smooth(color="red")
rhr_avg_hr
ggsave(here::here("figures","rhr_avghr.png"), device = "png", scale = 1.5)

rhr_max_hr <- garminRun %>% ggplot(aes(x=max_hr, y=rhr))+
  geom_point()+
  geom_smooth(method = "lm")+
  geom_smooth(color="red")
rhr_max_hr
ggsave(here::here("figures","rhr_maxhr"), device = "png", scale = 1.5)

### More Garmin Data ###
# 10/25/2021 - I've scraped more data from my Garmin dashboard that, for some reason is unavailable in my exports
# Inspiration for this was the Human Running Performance paper from Nature, which uses anaerobic value in their model
# This also gave me access to speed variable (in mph) which I thought would be interesting to look at

garminRun %>% ggplot(aes(x=avg_pace_sec, y=anaerobic_value))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")

garminRun %>% ggplot(aes(x=avg_pace_sec, y=aerobic_TE))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")

#### Investigate avg_speed and anaerobic TE ####
garminRun %>% ggplot(aes(x=avg_spd, y=anaerobic_value))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
####

#### Investigate avg_spd and aerobic TE ####
garminRun %>% ggplot(aes(x=avg_spd, y=aerobic_TE))+
  geom_point()+
  geom_smooth(method = "lm", color = "red")+
  geom_smooth(color = "blue")
####


# Through this initial analysis, the most significant variables I've found so far are:
# avg_pace
# avg_spd (average speed in mph)
# avg_cadence (cadence in steps per minute)
# avg_stride (average stride length in meters)
# aerobic_TE (aerobic training effect, same as aerobic_value)
# anaerobic_value (same as anaerobic training effect)
# avg_ascent (average elevation gain)
# avg_hr (average heart rate in beats per minute)

# first, I want to do a linear regression with a target variable of speed in avg miles per hour. 

speed1 <- lm(avg_spd ~ avg_pace_sec + avg_run_cadence + avg_stride + aerobic_TE + anaerobic_value + total_ascent + avg_hr, garminRun)
summary(speed1)

speed2 <- lm(avg_spd ~ avg_run_cadence + avg_stride + aerobic_TE + anaerobic_value, garminRun)
summary(speed2)

# I still have a lot of variables to test. The variables listed above will initially get most of my focus. 
save_data_location <- here::here("data","processed_data","run_data_clean.rds")
saveRDS(run_df, file = save_data_location) #clean data without NA dates

# Next Steps: Continue exploratory analysis with other variables
# go into processing script - find other errors that prevented it from running for Dr. Handel
# in processing script, also add binary data to factor data and create new variables for individual levels
# start with linear and logistic regressions to see if there are any significant relationships between variables and to see if there are any potentially strong models

### End Exploratory Analysis ###

# This is an incredibly interesting and helpful start for me. 
#Seeing that increasing my stride length and increasing my cadence (number of times my feet hit the ground in a minute) is correlatd with an increased average pace shows that I can improve if I have better turn-over in my legs

# In future analysis, I'm curious to see how my shoes affect my stride and cadence (I think lighter, responsive shoes improve both)
# I know my watch also has an anaerobic value. I wonder if that's available somewhere in my dataset. THat would be another important performance indicator