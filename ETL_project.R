#Install if needed
install.packages("dplyr")

# Load libraries
library(DBI)
library(RMySQL)
library(readr)
library(dplyr)

#unique to my desktop project instead of changing server side settings
CLIENT_LOCAL_FILES <- 128

# MySQL connection config
host <- 'localhost'
port <- 3307
user <- 'admin'
password <- '92194Rd_18'
db_name <- 'arcade_db'

# Connect to MySQL
mydb <- dbConnect(
         RMySQL::MySQL(),
         user = user,
         password = password,
         dbname = db_name,
         host = host,
         port = port,
         client.flag = CLIENT_LOCAL_FILES #unique to this project
)

# Load CSVs
manufacturers <- read_csv('C:/Users/ryand/Desktop/Project/Raw Data/manufacturers.csv')
machines <- read_csv('C:/Users/ryand/Desktop/Project/Raw Data/machines.csv')
locations <- read_csv('C:/Users/ryand/Desktop/Project/Raw Data/locations.csv')
usage_logs <- read_csv('C:/Users/ryand/Desktop/Project/Raw Data/usage_logs.csv')
maintenance <- read_csv('C:/Users/ryand/Desktop/Project/Raw Data/maintenance.csv')

#Spot Check
head(machines)
nrow(machines)

#returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)


#Coalesce Function, handling NA values
coalesce <- function(...) {
  apply(cbind(...), 1, function(x) {
    x[which(!is.na(x))[1]]
  })
}

# Cleaning Date Functions
machines$is_multiplayer <- ifelse(machines$is_multiplayer == 'Yes', TRUE, FALSE)
usage_logs$date <- as.Date(usage_logs$date)
maintenance$service_date <- as.Date(maintenance$service_date)
maintenance$resolved_date <- as.Date(maintenance$resolved_date)
locations$install_date <- as.Date(locations$install_date)


# Upload tables to MySQL
dbWriteTable(mydb, 'manufacturers', manufacturers, overwrite = TRUE, row.names = FALSE)
dbWriteTable(mydb, 'machines', machines, overwrite = TRUE, row.names = FALSE)
dbWriteTable(mydb, 'locations', locations, overwrite = TRUE, row.names = FALSE)
dbWriteTable(mydb, 'usage_logs', usage_logs, overwrite = TRUE, row.names = FALSE)
dbWriteTable(mydb, 'maintenance', maintenance, overwrite = TRUE, row.names = FALSE)


# Close connection
dbDisconnect(mydb)
