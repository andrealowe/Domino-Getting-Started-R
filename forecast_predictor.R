library("prophet")
m<-readRDS(file = "model.rds")

model_api<-function(year, month, day, hour, minute){
    date <- paste(year,"-", month,"-", day," ",hour,":",minute, sep="")
    date= as.POSIXct(date, "%Y-%m-%d %H:%M")
    df_api <- data.frame(ds=date)
    df2<- predict(m,df_api)
    return(df2["yhat"])
}