rm(list=ls(all=TRUE))


# In order to save memory, only read a small portion of data set (Jan-Feb 2007)
con <- file("./household_power_consumption.txt")
open(con)
df<-read.table(file=con,header=TRUE,sep=";",stringsAsFactors=FALSE,skip=40000,
               nrow=60000)
close(con)


# name the columns
colnames(df) <- c("Date","Time","Global_active_power","Global_reactive_power",
               "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2",
               "Sub_metering_3")


# make sure there is no NA in the data
df <- df[complete.cases(df),]


# combine Date and Time into DateTime
DateTime<-as.POSIXct(paste(df$Date,df$Time),format="%d/%m/%Y %H:%M:%S")
df <- data.frame(DateTime=DateTime, df[,3:9])


# choose the data of 2007-02-01 and 2007-02-02 
df <- df[ (month(df$DateTime)==2) & (day(df$DateTime)==1 | day(df$DateTime)==2),]


# convert the rest of the data frame to numeric
temp <- as.data.frame(sapply(df[,2:8],as.numeric))
df <- data.frame(DateTime=df$DateTime, temp)


# plot 1
png(file="./plot1.png",width=480, height=480)
hist(df$Global_active_power,col="red",xlab="Global Active Power(Kilowatts)",
     main=NULL)
title("Global Active Power")
dev.off()

