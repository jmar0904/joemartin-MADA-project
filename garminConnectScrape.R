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

pacman::p_load(pacman,tidyverse,RSelenium)

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
username_input$sendKeysToElement(list("jmmartin0904@gmail.com"))

pw_input <- remDr$findElement(using = "id", value = "password")
pw_input$sendKeysToElement(list("GARbrook$ghost11"))

submit <- remDr$findElement(using = "class", value = "btn1")
submit$clickElement()

#after logging in, navigate to running section in account
remDr$navigate("https://connect.garmin.com/modern/activities?activityType=running")

first_run <- remDr$findElement(using = "link text", value = "Athens Running")
first_run$clickElement()

remDr$getCurrentUrl()


# Run loop to get data

d_b <- c() # data bit elements
d_l <- c() # data labels
d_t <- c() # date data for matching
while (page_status < 1000){
  date_time <- remDr$findElement(using="class", value="activity-detail-title")
  speed <- remDr$findElement(using = "id", value = "btn-speed")
  speed$clickElement()
  dataBits <- remDr$findElements(using="class", value = "data-bit")
  dataLabels <- remDr$findElements(using="class", value = "data-label")
  prev_page <- remDr$findElement(using="class", value = "icon-arrow-left")
  prev_page$clickElement()
  for(i in dataBits){
    d <- i$getElementText()
    d_b <- append(d_b,d)
  }
  for(j in dataLabels){
    l <- j$getElementText()
    d_l <- append(d_l,l)
  }
  d_t <- append(d_t,date_time)
  prev_page <- remDr$findElement(using="class name", value = "page-navigation-action")
  x <- prev_page$getElementLocation()
  page_status <- as.numeric(unlist(x[1]))
  prev_page$clickElement()
}




labs <- c("title",d_l)
labs <- unlist(labs)
rows <- unlist(d_b)

df <- data.frame(labs,rows)

speed <- remDr$findElement(using = "id", value = "btn-speed")
speed$clickElement()

# Close the remote driver session. Don't forget to end the session in Docker
remDr$close()
