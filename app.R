library(tidyverse)
library(lubridate)
library(prophet)
library(dygraphs)

col_names <-  c('HDF', 'date', 'half_hour_increment',
                'CCGT', 'OIL', 'COAL', 'NUCLEAR',
                'WIND', 'PS', 'NPSHYD', 'OCGT',
                'OTHER', 'INTFR', 'INTIRL', 'INTNED',
                'INTEW', 'BIOMASS', 'INTEM')
df <- read.csv('data.csv',header = FALSE,col.names = col_names,stringsAsFactors = FALSE)

#remove the first and last row
df <- df[-1,]
df <- df[-nrow(df),]

fuels <- c('CCGT', 'OIL', 'COAL', 'NUCLEAR',
           'WIND', 'PS', 'NPSHYD', 'OCGT',
           'OTHER', 'INTFR', 'INTIRL', 'INTNED',
          'INTEW', 'BIOMASS', 'INTEM')

predict_ln <- round((nrow(df))*.2)

#Tidy the data and split by fuel
df_tidy <- df %>%
  mutate(ds=as.POSIXct(as.Date(date, "%Y%m%d"))+minutes(30*(half_hour_increment-1))) %>%
  select(-c('HDF', 'date', 'half_hour_increment')) %>%
  gather("fuel", "y", -ds) %>%
  split(.$fuel)

#remove unused column
df_tidy <- lapply(df_tidy, function(x) { x["fuel"] <- NULL; x })

#Train the model
m_list <- map(df_tidy, prophet)

#Create dataframes of future dates
future_list <- map(m_list, make_future_dataframe, periods = predict_ln,freq = 1800 )

#Pre-Calc yhat for future dates
#forecast_list <- map2(m_list, future_list, predict) # map2 because we have two inputs



ui <- fluidPage(
    verticalLayout(
      h2(textOutput("text1")),
     selectInput(inputId = "fuel_type",
                 label = "Fuel Type",
                 choices = fuels,
                 selected = "CCGT"),
      dygraphOutput("plot1")))

server <- function(input, output) {
output$plot1 <- renderDygraph({
  forecast <- predict(m_list[[input$fuel_type]],future_list[[input$fuel_type]] )
    dyplot.prophet(m_list[[input$fuel_type]], forecast)
     })
output$text1 <- renderText({ input$fuel_type })
}

shinyApp(ui = ui, server = server)