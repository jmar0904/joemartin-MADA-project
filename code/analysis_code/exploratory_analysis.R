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


### Average Pace ###
average_pace_1321 <- run_df %>% ggplot(aes(x=date, y= avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")
average_pace_1321

#From this, it looks like I'm getting slower. This doesn't show the extra distance I go or the type of run
average_pace_1821 <- run_df %>% filter(date >= "2018-01-01") %>%
  ggplot(aes(x=date,y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

average_pace_1821

# Long Disance Runs
ld <- run_df %>%
  filter(distance >= 12) %>%
  filter(date >= "2018-01-01") %>%
  ggplot(aes(x=date,y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

ld

# Effect of Cadence on Average Pace
cad_ap <-garminRun %>% ggplot(aes(x=avg_run_cadence, y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

cad_ap

# Effect of Harder Aerobic Effort on Average Pace
ae_ap<- garminRun %>% ggplot(aes(x=aerobic_TE, y=avg_pace))+
  geom_point()+
  geom_smooth()

ae_ap

# Average Pace and Average Heart Rate
hr_ap <- garminRun %>% ggplot(aes(x=avg_hr, y = avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

hr_ap

# Stride and Average Pace
garminRun %>% ggplot(aes(x=avg_stride, y = avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")


# Temperature
# I'm less likely to run far when it gets hot out. 
fit1 <- lm(distance ~ temperature, run_df)
summary(fit1)

run_df %>% ggplot(aes(x=temperature, y = distance))+
  geom_point()+
  geom_smooth(method = "lm")

# Ascent
#avg_hr, total_ascent
hr_ascent <- lm(avg_hr~total_ascent,garminRun)
summary(hr_ascent)

hr_ascent_plot <-garminRun %>% ggplot(aes(x=avg_hr, y = total_ascent))+
  geom_point()+
  geom_smooth(method = "lm")

hr_ascent_plot

ae_ta <- garminRun %>% ggplot(aes(x=aerobic_TE, y=total_ascent))+
  geom_point()+
  geom_smooth(method = "lm")

ae_ta

cadence_aerobicTE <- lm(avg_run_cadence~aerobic_TE, garminRun)
summary(cadence_aerobicTE)

ca_at <- garminRun %>% ggplot(aes(x=avg_run_cadence, y=aerobic_TE))+
  geom_point()+
  geom_smooth(method = "lm")

ca_at

stride <- garminRun %>% ggplot(aes(x=avg_run_cadence, y=avg_stride))+
  geom_point()+
  geom_smooth(method = "lm")

stride

### Save Plots ###

save_data_location <- here::here("data","processed_data","run_data_clean.rds")
saveRDS(run_df, file = save_data_location) #clean data without NA dates


### End Exploratory Analysis ###

# Extras - unused plots - left for future reference
#shoes and average pace
run_df %>% ggplot(aes(x=date, y=avg_pace))+
  geom_point()+
  facet_wrap(~shoes)

#From this, it looks like I'm getting slower. This doesn't show the extra distance I go or the type of run
run_df %>% filter(date >= "2018-01-01") %>%
  ggplot(aes(x=date,y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

# Maybe I am just getting slower
run_df %>% filter(run_type != "Recovery") %>%
  filter(datetime >= "2018-01-01") %>%
  ggplot(aes(x=date,y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

#Garmin Data

#cadence

garminRun %>% ggplot(aes(x=max_run_cadence, y=avg_pace))+
  geom_point()+
  geom_smooth(method = "lm")

garminRun %>% ggplot(aes(x=datetime, y=aerobic_TE))+
  geom_point()+
  geom_smooth(method = "lm")

# This is an incredibly interesting and helpful start for me. 
#Seeing that increasing my stride length and increasing my cadence (number of times my feet hit the ground in a minute) is correlatd with an increased average pace shows that I can improve if I have better turn-over in my legs

# In future analysis, I'm curious to see how my shoes affect my stride and cadence (I think lighter, responsive shoes improve both)
# I know my watch also has an anaerobic value. I wonder if that's available somewhere in my dataset. THat would be another important performance indicator

