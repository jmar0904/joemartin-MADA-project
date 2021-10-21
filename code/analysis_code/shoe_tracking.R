# Produces a simple dataframe to track my shoe mileage
pacman::p_load(pacman,tidyverse,here,lubridate)

run_file <- here::here("data","processed_data","run_data_clean.rds")
df <- read_rds(run_file)

shoe_df <- df %>% 
  select(shoes,distance) %>% 
  drop_na(distance) %>% 
  group_by(shoes) %>% 
  summarize("miles" = sum(distance))

# monthly mileage

df$month <- month(df$date)
df$year <- year(df$date)
df$mmyyyy <- paste(df$month,"/",df$year, sep = "")
df$mmyyyy <- my(df$mmyyyy)

monthly_mileage <- df %>%
  select(mmyyyy, distance) %>%
  drop_na(distance) %>%
  group_by(mmyyyy) %>%
  summarize(miles = sum(distance))

# plot monthly mileage
monthly <- monthly_mileage %>%
  ggplot(aes(x=mmyyyy,y=miles))+
  geom_line()
monthly

# Weekly Mileage
weekly_mileage <- df %>%
  select(week,year,distance) %>%
  drop_na(distance) %>%
  group_by(year,week) %>%
  summarize(miles = sum(distance))

weekly_mileage$week <- as.factor(weekly_mileage$week)

## Recode 1-9 to be 01-09

weekly_mileage$precise_week <- paste(weekly_mileage$year,weekly_mileage$week, sep = "")
weekly_mileage$precise_week <- as.numeric(weekly_mileage$precise_week)

#plot weekly mileage

weekly <- weekly_mileage %>%
  ggplot(aes(x=precise_week, y=miles))+
  geom_line()
weekly
