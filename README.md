# cyclisitic_google_data_capstone
Google Analytics Capstone Project using Cyclistic (Divvy) bike data
# Objective (Ask)
This analysis was carried out to provide insights into the behavior of current annual memberships. Insights should inform the marketing strategy to convert casual riders to annual. 
# Prepare
## Source
Cyclistic trip data from company website.
## Period Covered
Previous 12 months, covering December 2021 to November 2022
## Limitations of Data
Connecting pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area, or if they have purchased multiple single passes was not available for analysis in line with PII privacy standards.

Further analysis of trip length needs to be carried out. Query with Cyclistic: do the docking stations fault sometimes? This could explain ride times of 0 seconds, and higher ride length time over days in length. 

# Process
The following steps were carried out to prepare the data for processing:

- File renamed from 202209-divvy-publictripdata.csv to 202209-divvy-tripdata.csv to align with the naming conventions of the rest of the monthly files in the folder which will allow for ease of calling the file name in the future as the naming convention can be followed.
- Monthly files were read and inspected for anomolies and inconsistencies across column names. Further checks were made to ensure congruency across data types and strucutres across files. Once the previous steps were satisfied, the files were stacked into a single dataframe to work from for the analysis. 
- Formatting was carried out on the 'started_at' column to allow for aggregation on date types; day, month, year.
- A calculated field was added 'ride_length', based on start and end times of trips. 
- Trips of length 0 or less seconds were removed. [need to check if that is correct]

# Analysis
Compare members and casual users
Compare day or week, month by user type
Compare type of bikes preferred by user
Compare station location hotspots for users

# Share
Powerpoint presentation outlining key findings and recommendations.

# Act
Top 3 recommendations based on analysis are found in powerpoint presentation. 
