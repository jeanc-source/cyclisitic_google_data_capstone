### Divvy_Exercise_Full_Year_Analysis ###

# This analysis is based on the Divvy case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: “In what ways do members and casual riders use Divvy bikes differently?”

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

# Load packages set directory ---------------------------------------------


library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd("/Users/jeancrudden/Downloads/trip_data") #sets your working directory 

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here
nov<-read_csv("202211-divvy-tripdata.csv")
oct<-read_csv("202210-divvy-tripdata.csv")
sep<-read_csv("202209-divvy-tripdata.csv")
aug<-read_csv("202208-divvy-tripdata.csv")
jul<-read_csv("202207-divvy-tripdata.csv")
jun<-read_csv("202206-divvy-tripdata.csv")
may<-read_csv("202205-divvy-tripdata.csv")
apr<-read_csv("202204-divvy-tripdata.csv")
mar<-read_csv("202203-divvy-tripdata.csv")
feb<-read_csv("202202-divvy-tripdata.csv")
jan<-read_csv("202201-divvy-tripdata.csv")
dec<-read_csv("202112-divvy-tripdata.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(nov)
colnames(oct)
colnames(sep)
colnames(aug)
colnames(jul)
colnames(jun)
colnames(may)
colnames(apr)
colnames(mar)
colnames(feb)
colnames(jan)
colnames(dec)

# Inspect the dataframes and look for incongruencies
str(nov)
str(oct)
str(sep)
str(aug)
str(jul)
str(jun)
str(may)
str(apr)
str(mar)
str(feb)
str(jan)

# Stack all data frames into one big data frame
all_trips <- bind_rows(nov, oct, sep, aug, jul, jun, may, apr, mar, feb, jan, dec)

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# There are a few problems we will need to fix:
# (1) The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (2) We will want to add a calculated field for length of ride since the 2020Q1 data did not have the "tripduration" column. We will add "ride_length" to the entire dataframe for consistency.
# (3) There are some rides where tripduration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.

# 1. Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link
all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# 2. Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

# Inspect the structure of the columns
str(all_trips)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# 3. # Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]


# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
# N.B.: This file location is for a Mac. If you are working on a PC, change the file location accordingly (most likely "C:\Users\YOUR_USERNAME\Desktop\...") to export the data. You can read more here: https://datatofish.com/export-dataframe-to-csv-in-r/
day_of_week <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(day_of_week, file = '/Users/jeancrudden/Downloads/trip_data/day_of_week.csv')

month <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$month, FUN = mean)
write.csv(month, file = '/Users/jeancrudden/Downloads/trip_data/month.csv')

start_station_name <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$start_station_name, FUN = mean)
write.csv(start_station_name, file = '/Users/jeancrudden/Downloads/trip_data/start_station_name.csv')

end_station_name <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$end_station_name, FUN = mean)
write.csv(end_station_name, file = '/Users/jeancrudden/Downloads/trip_data/end_station_name.csv')

start_lat <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$start_lat, FUN = mean)
write.csv(start_lat, file = '/Users/jeancrudden/Downloads/trip_data/start_lat.csv')

end_lat <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$end_lat, FUN = mean)
write.csv(end_lat, file = '/Users/jeancrudden/Downloads/trip_data/end_lat.csv')

rideable_type <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$rideable_type , FUN = mean)
write.csv(rideable_type , file = '/Users/jeancrudden/Downloads/trip_data/rideable_type .csv')

cleaned_data <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week + all_trips_v2$month + all_trips_v2$start_station_name + all_trips_v2$end_station_name + all_trips_v2$start_lat + all_trips_v2$end_lat + all_trips_v2$rideable_type, FUN = mean)
write.csv(cleaned_data, file = '/Users/jeancrudden/Downloads/trip_data/cleaned_data.csv')

#with longitude values, missing from cleaned_data
cleaned_data_v2 <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week + all_trips_v2$month + all_trips_v2$start_station_name + all_trips_v2$end_station_name + all_trips_v2$start_lat + all_trips_v2$start_lng + all_trips_v2$end_lat + all_trips_v2$end_lng + all_trips_v2$rideable_type, FUN = mean)
write.csv(cleaned_data_v2, file = '/Users/jeancrudden/Downloads/trip_data/cleaned_data_v2.csv')


colnames(all_trips_v2)
#You're done! Congratulations!

