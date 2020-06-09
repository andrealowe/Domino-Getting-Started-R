library(tidyverse)
library(lubridate)

col_names <-  c('HDF', 'date', 'half_hour_increment',
                'CCGT', 'OIL', 'COAL', 'NUCLEAR',
                'WIND', 'PS', 'NPSHYD', 'OCGT',
                'OTHER', 'INTFR', 'INTIRL', 'INTNED',
                'INTEW', 'BIOMASS', 'INTEM')

#Load the data into a data frame
df <- read.csv('/domino/datasets/local/BMRS_Power-Generation-Data/data.csv',header = FALSE,col.names = col_names,stringsAsFactors = FALSE)

#remove the first and last row
df <- df[-1,]
df <- df[-nrow(df),]

#Preview the data
View(df)

df_tidy <- df %>% gather('CCGT', 'OIL', 'COAL', 'NUCLEAR',
                         'WIND', 'PS', 'NPSHYD', 'OCGT',
                         'OTHER', 'INTFR', 'INTIRL', 'INTNED',
                         'INTEW', 'BIOMASS', 'INTEM',key="fuel", value="megawatt" )

df_tidy <- df_tidy %>% mutate(datetime=as.POSIXct(as.Date(date, "%Y%m%d"))+minutes(30*(half_hour_increment-1)))

#plot the graph
p <- ggplot(data=df_tidy, aes(x=datetime, y=megawatt, group=fuel)) +
  geom_line(aes(color=fuel))

print(p)

#train model
df_CCGT <- df_tidy %>% filter(fuel=="CCGT") %>% select(datetime,megawatt)
names(df_CCGT) <- c("ds","y")

split_index <- round(nrow(df_CCGT)*.8)
df_CCGT_train <- df_CCGT[1:split_index,]
df_CCGT_test <- df_CCGT[(split_index+1):nrow(df_CCGT),]

library(prophet)
m <- prophet(df_CCGT_train)

predict_ln <- round(nrow(df_CCGT_test)/2)
future <- make_future_dataframe(m, periods = predict_ln,freq = 1800 )
forecast <- predict(m, future)

dyplot.prophet(m, forecast)

#export
saveRDS(m, file = "model.rds")
