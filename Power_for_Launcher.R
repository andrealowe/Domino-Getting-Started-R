library(tidyverse)
library(lubridate)

#Pass in commandline arguements
args <- commandArgs(trailingOnly = TRUE)
fuel_type <- args[1]

col_names <-  c('HDF', 'date', 'half_hour_increment',
                'CCGT', 'OIL', 'COAL', 'NUCLEAR',
                'WIND', 'PS', 'NPSHYD', 'OCGT',
                'OTHER', 'INTFR', 'INTIRL', 'INTNED',
                'INTEW', 'BIOMASS', 'INTEM')
                
df <- read.csv('data.csv', header = FALSE, col.names = col_names, stringsAsFactors = FALSE)

#remove the first and last row
df <- df[-1,]
df <- df[-nrow(df),]

#Tidy the data
df_tidy <- df %>% gather('CCGT', 'OIL', 'COAL', 'NUCLEAR',
                         'WIND', 'PS', 'NPSHYD', 'OCGT',
                         'OTHER', 'INTFR', 'INTIRL', 'INTNED',
                         'INTEW', 'BIOMASS', 'INTEM',key="fuel", value="megawatt" )

#Create a new column datetime that represents the starting datetime of the measured increment.
df_tidy <- df_tidy %>% mutate(datetime=as.POSIXct(as.Date(date, "%Y%m%d"))+minutes(30*(half_hour_increment-1)))

#Filter the data
df_fuel_type <- df_tidy %>% filter(fuel==fuel_type) %>% select(datetime,megawatt)

#Save out data as csv
write.csv(df_fuel_type, paste(fuel_type,"_", Sys.Date(),".csv",sep=""))

