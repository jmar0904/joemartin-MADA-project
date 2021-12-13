#########################################################
# This script isn't reproducible without considerable work. 
# In addition to the instructions below, it requires access to a Garmin Connect account.
## To try running the script, please use the following instructions. 
## They are required in addition to the RSelenium package. 
#########################################################

# Instructions for reproducing Selenium scrape
   # For Windows and Linux. Separate instructions may be required for Mac users.

# Access to my particular Garmin Connect account is obviously unavailable for this project.

# However, users with Garmin Connect accounts are able to reproduce this scrape by inputting their username and password in the script below. 

# This script requires Docker to run. Docker is free and available for download at Docker.com

# If using Linux, you're all set! For Windows users, follow Docker's documentation to switch to Linux containers: https://docs.docker.com/desktop/windows/
    # The simple explanation: find the Docker Whale icon in your tool bar at the bottom right. 
    # Right click on the icon. If the menu shows the option "Switch to Windows Containers," Docker is ready.
    # If the menu shows "Switch to Linux Containers," select this option and wait for Docker to load. 

# After following these steps, simply launch Docker like any other application on your computer.
# Once Docker is running, uncomment the following line to run the shell that installs Selenium:

# shell('docker pull selenium/standalone-firefox')

# I recommend using Firefox for scraping purposes. The Chrome version has low smh, which causes Selenium to crash frequently. 

# After following the above instructions, you should be able to run this script successfully. 

pacman::p_load(pacman,tidyverse,RSelenium, stringr, lubridate, here)

### Shell to download selenium
# shell('docker pull selenium/standalone-firefox') # Uncomment this line to pull the Docker container needed to run this script
# shell('docker pull selenium/standalone-chrome')  # Docker pull command from chrome browsing. Chrome browsing caused tabs to crash due to low smh

#shell to run selenium
shell('docker run -d -p 4445:4444 selenium/standalone-firefox')

RSelenium::rsDriver()

# Start remote driver
remDr <- remoteDriver(remoteServerAddr = "localhost",
                      port = 4445L,
                      browserName = "firefox")

remDr$open()

# Send Remote Driver to Garmin Connect login
remDr$navigate("https://sso.garmin.com/sso/signin?service=https%3A%2F%2Fconnect.garmin.com%2Fmodern%2F&webhost=https%3A%2F%2Fconnect.garmin.com%2Fmodern%2F&source=https%3A%2F%2Fconnect.garmin.com%2Fsignin%2F&redirectAfterAccountLoginUrl=https%3A%2F%2Fconnect.garmin.com%2Fmodern%2F&redirectAfterAccountCreationUrl=https%3A%2F%2Fconnect.garmin.com%2Fmodern%2F&gauthHost=https%3A%2F%2Fsso.garmin.com%2Fsso&locale=en_US&id=gauth-widget&cssUrl=https%3A%2F%2Fconnect.garmin.com%2Fgauth-custom-v1.2-min.css&privacyStatementUrl=https%3A%2F%2Fwww.garmin.com%2Fen-US%2Fprivacy%2Fconnect%2F&clientId=GarminConnect&rememberMeShown=true&rememberMeChecked=false&createAccountShown=true&openCreateAccount=false&displayNameShown=false&consumeServiceTicket=false&initialFocus=true&embedWidget=false&socialEnabled=false&generateExtraServiceTicket=true&generateTwoExtraServiceTickets=true&generateNoServiceTicket=false&globalOptInShown=true&globalOptInChecked=false&mobile=false&connectLegalTerms=true&showTermsOfUse=false&showPrivacyPolicy=false&showConnectLegalAge=false&locationPromptShown=true&showPassword=true&useCustomHeader=false&mfaRequired=false&performMFACheck=false&rememberMyBrowserShown=true&rememberMyBrowserChecked=false#")

# Select username and password fields. Enter username/pw

username_input <- remDr$findElement(using = "id", value = "username")
username_input$sendKeysToElement(list("")) #Input username

pw_input <- remDr$findElement(using = "id", value = "password")
pw_input$sendKeysToElement(list("")) #Input Password

submit <- remDr$findElement(using = "class", value = "btn1")
submit$clickElement()

#after logging in, navigate to running section in account
remDr$navigate("https://connect.garmin.com/modern/activities?activityType=running")

# Navigate to first run link. The commented-out url above is a placeholder for the URL the script leaves off on when it crashes, which happed a few times.
first_run <- remDr$findElement(using = "link text", value = "Athens Running")
first_run$clickElement()

remDr$getCurrentUrl() #Check to make sure you're on a page
#prev_page$getElementLocation()

# the following two lines of code determine if the loop moves forward
# when the "previous" arrow goes away, the attribute text will become "icon-arrow-right" and the loop will stop
page_check <- remDr$findElement(using="xpath", value = '//*[contains(concat( " ", @class, " " ), concat( " ", "icon-arrow-left", " " ))]')
attribute <- page_check$getElementAttribute(attrName = "class")
attribute <- unlist(attribute)

# Run loop to get data

d_b <- c() # data bit elements
d_l <- c() # data labels
d_t <- c() # date data for matching
while (attribute == "icon-arrow-left"){
  Sys.sleep(runif(1, min=5, max=12))
  date_time <- remDr$findElement(using="class", value="activity-detail-title")
  dt_text <- date_time$getElementText()
  speed <- remDr$findElement(using = "id", value = "btn-speed")
  speed$clickElement()
  dataBits <- remDr$findElements(using="class", value = "data-bit")
  dataLabels <- remDr$findElements(using="class", value = "data-label")
  # use IF statement to only scrape results from running pages
  if(grepl("^RUNNING",dt_text)){
    d_l <- append(d_l,"title")
  for(i in dataBits){
    d <- i$getElementText()
    d_b <- append(d_b,d)
  }
  for(j in dataLabels){
    l <- j$getElementText()
    d_l <- append(d_l,l)
  }
  d_t <- append(d_t,dt_text)# append list and navigate to next page  
  page_check <- remDr$findElement(using="xpath", value = '//*[contains(concat( " ", @class, " " ), concat( " ", "icon-arrow-left", " " ))]')
  attribute <- page_check$getElementAttribute(attrName = "class")
  attribute <- unlist(attribute)
  prev_page <- remDr$findElement(using="class name", value = "page-navigation-action")
  prev_page$clickElement()  
  current <- remDr$getCurrentUrl()
  print(current)  
  }else{
  page_check <- remDr$findElement(using="xpath", value = '//*[contains(concat( " ", @class, " " ), concat( " ", "icon-arrow-left", " " ))]')
  attribute <- page_check$getElementAttribute(attrName = "class")
  attribute <- unlist(attribute)
  prev_page <- remDr$findElement(using="class name", value = "page-navigation-action")
  prev_page$clickElement()  
  current <- remDr$getCurrentUrl()
  print(current)    
  }
}


labs <- unlist(d_l)
rows <- unlist(d_b)
all_dates <- unlist(d_t)
df <- data.frame(labs,rows)


# Save checkpoint
write.csv(df,"garminScrape-final.csv")
write.csv(all_dates,"garminScrape1dates-final.csv")

#create a clean dataframe
df1 <- df %>% pivot_wider(names_from = "labs", values_from = "rows")

# Tried creating a new dataframe directly from results, but it seems my scrape was imperfect and caused issues. 
# Unlisted elements below to create vectors and see exactly how many elements were in each. I can conclude that I do not care about the 
## variables which have unequal data. Most of them are already in my Garmin export or have little meaning to the scope of this project.
  l1 <- unlist(df1$title)
  l2 <- unlist(df1$Distance)
  l3 <- unlist(df1$`Calories Burned`)
  l4 <- unlist(df1$`Calories Consumed`)
  l5 <- unlist(df1$`Calories Net`)
  l6 <- unlist(df1$`Est. Sweat Loss`)
  l7 <- unlist(df1$`Fluid Consumed`)
  l8 <- unlist(df1$`Fluid Net`)
  l9 <- unlist(df1$Aerobic)
  l10 <- unlist(df1$Anaerobic)
  l11 <- unlist(df1$`Avg HR`)
  l12 <- unlist(df1$`Max HR`)
  l13 <- unlist(df1$Time)
  l14 <- unlist(df1$`Moving Time`) 
  l15 <- unlist(df1$`Elapsed Time`) 
  l16 <- unlist(df1$`Avg Speed`)
  l17 <- unlist(df1$`Avg Moving Speed`) 
  l18 <- unlist(df1$`Max Speed`)
  l19 <- unlist(df1$`Total Ascent`) 
  l20 <- unlist(df1$`Total Descent`)
  l21 <- unlist(df1$`Min Elev`) 
  l22 <- unlist(df1$`Max Elev`)
  l23 <- unlist(df1$`Avg Run Cadence`) 
  l24 <- unlist(df1$`Max Run Cadence`)
  l25 <- unlist(df1$`Avg Stride Length`)
  l26 <- unlist(df1$Moderate)
  l27 <- unlist(df1$Vigorous)
  l28 <- unlist(df1$Total)

# create dataframe without l26,l27,l28,l22,l21,l20,and l19                  
df2 <- data.frame(l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l23,l24,l25)
df2$date_info <- all_dates  

#rename variables
df2 <- df2 %>% rename("title" = l1,
                      "distance" = l2,
                      "calories_burned" = l3,
                      "cal_consumed" = l4,
                      "cal_net" = l5,
                      "sweat_loss(ml)" = l6, 
                      "fluid_in" = l7,
                      "fluid_net" = l8,
                      "aerobic" = l9, 
                      "anaerobic" = l10,
                      "avg_hr" = l11,
                      "max_hr" = l12,
                      "time" = l13,
                      "moving_time" = l14,
                      "elapsed_time" = l15,
                      "avg_spd" = l16,
                      "avg_moving_spd" = l17,
                      "max_spd" = l18,
                      "avg_cadence" = l23,
                      "max_cadence" = l24,
                      "avg_stride" = l25)
  
# many of these variable are unnecessary. Some are repeats of what I have from previous exports. Some are just empty or not useful
# delete title, cal_consumed, cal_net, fluid_in,fluid_net
df3 <- df2 %>% select(-title, -cal_consumed, -cal_net, - fluid_in, -fluid_net)

# I only want the date from date_info. This is what I'm using for matching
# I'm going to split the time away then get rid of the text up to "on"
df3 <- separate(df3, col = "date_info", into = c("date","time"), sep = " @ ")
df3$date <- str_remove(df3$date, "RUNNING\nBY JOE MARTIN ON ")

df3$date <- str_replace(df3$date, "TODAY", "SATURDAY")
df4 <- bind_rows(addedEntry,df3)

df4$date <- str_replace(df4$date, "TODAY", "OCTOBER 24, 2021")
df4$date <- str_replace(df4$date, "SATURDAY", "OCTOBER 23, 2021")
df4$date <- str_replace(df4$date, "THURSDAY", "OCTOBER 21, 2021")
df4$date <- str_replace(df4$date, "WEDNESDAY", "OCTOBER 20, 2021")
df4$date <- str_replace(df4$date, "TUESDAY", "OCTOBER 19, 2021")
df4$date <- str_replace(df4$date, "SUNDAY", "OCTOBER 17, 2021")

df4$date <- lubridate::mdy(df4$date)

df4 <- df4 %>% unique()

#save checkpoint
write.csv(df4, "garminScrapedf.csv")

garmin <- read_rds(here::here("data","processed_data","garmin_data.rds"))

# Close the remote driver session. Don't forget to end the session in Docker
remDr$close()

# There are a few more items I need to update in order to complete this new dataset
# remove units from values (calories burned, sweat loss, speed)
# split anaerobic and aerobic values into numeric value and factor value

# remove units and coerce into new data types
garmin2$calories_burned <- str_remove(garmin2$calories_burned, " C")
garmin2$calories_burned <- as.numeric(str_remove(garmin2$calories_burned, ","))

garmin2$`sweat_loss(ml)` <- as.numeric(str_remove(garmin2$`sweat_loss(ml)`, " ml"))

garmin2$avg_spd <- as.numeric(str_remove(garmin2$avg_spd, " mph"))
garmin2$avg_moving_spd <- as.numeric(str_remove(garmin2$avg_moving_spd, " mph"))
garmin2$max_spd <- as.numeric(str_remove(garmin2$max_spd, " mph"))

# split numeric values from text values
garmin2 <- separate(garmin2, col = "aerobic", into = c("aerobic_value", "aerobic_fct"), sep = " ", extra = "merge")
garmin2 <- separate(garmin2, col = "anaerobic", into = c("anaerobic_value", "anaerobic_fct"), sep = " ", extra = "merge")
garmin2$aerobic_value <- as.numeric(garmin2$aerobic_value)
garmin2$anaerobic_value <- as.numeric(garmin2$anaerobic_value)

#save checkpoint
write_rds(garmin2, here::here("data","processed_data","garmin_data.rds"))
