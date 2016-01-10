library("ggplot2", lib.loc="C:/Users/aeand/R/R-3.2.2/library")
library("knitr", lib.loc="C:/Users/aeand/R/R-3.2.2/library")
library("dplyr", lib.loc="C:/Users/aeand/R/R-3.2.2/library")
library("lattice", lib.loc="C:/Users/aeand/R/R-3.2.2/library")
##
##Download and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="repdata_data_activity.zip")
unzip(zipfile="repdata_data_activity.zip")

repdata <- read.csv("activity.csv")

repdata$date <- as.Date(as.character(repdata$date))
repdata$interval <- as.factor(repdata$interval)
daysteps <- tapply(repdata$steps, factor(repdata$date), sum)
x <- as.factor(unique(repdata$date))
daysum <- data.frame(x, daysteps)
names(daysum) <- c("Date", "Total Steps")

plot(daysum$Date, daysum$`Total Steps`)
lines(daysum$Date, daysum$`Total Steps`, type = "h")
meansteps <- mean(daysteps, na.rm = T)
medsteps <- median(daysteps, na.rm = T)
meansteps
medsteps
##
meanalldays <- data.frame(tapply(repdata$steps, factor(repdata$interval), mean,                                 na.rm = T))
names(meanalldays) <- c("Mean.All.Days")
labels <- c("2am", "4am", "6am", "8am", "10am", "12pm", "2pm", "4pm", "6pm", "8pm", 
            "10pm", "12am")
at <- seq(24, 288, by = 24)
plot(meanalldays, xlab = "Interval", ylab = "Mean Steps Across All Days", xrange 
     = meanalldays$Interval, type = "l", xaxt = "n")
axis(side = 1, at = at, labels = labels)
max <- max(meanalldays)
meanalldays[meanalldays$Mean.All.Days == max,]
##
sum(is.na(repdata))
intermeans <- meanalldays
intermeans$interval <- levels(repdata$interval)
nasub <- subset(repdata, is.na(repdata$steps))
nonnasub <- subset(repdata, !is.na(repdata$steps))
nasub$steps[nasub$interval == intermeans$interval] <- intermeans$Mean.All.Days
repdata.i <- rbind(nonnasub, nasub)                 
##
daysteps.i <- tapply(repdata.i$steps, factor(repdata.i$date), sum)
x.i <- as.factor(unique(repdata.i$date))
daysum.i <- data.frame(x.i, daysteps.i)
names(daysum.i) <- c("Date", "Total Steps")
plot(daysum.i$Date, daysum.i$`Total Steps`)
lines(daysum.i$Date, daysum.i$`Total Steps`, type = "h")
meansteps.i <- mean(daysteps.i)
medsteps.i <- median(daysteps.i)
meansteps.i
medsteps.i
meansteps.i - meansteps
medsteps.i - medsteps
##
repdata.i$wkdays <- weekdays(repdata.i$date, abbreviate = T)
d <- c("Mon", "Tue", "Wed", "Thu", "Fri")
wkdaydf <- subset(repdata.i, repdata.i$wkdays %in% d)
wkenddf <- subset(repdata.i, !repdata.i$wkdays %in% d)
wkdaydf$daytype <- "weekday"
wkenddf$daytype <- "weekend"

##panel plot repdata.i2 by factor daytype
meanwkdays <- data.frame(tapply(wkdaydf$steps, factor(wkdaydf$interval), mean))
names(meanwkdays) <- "Mean.Wk.Days"
meanwkdays$interval <- levels(repdata$interval)
wkdaydf$steps[wkdaydf$interval == meanwkdays$interval] <- meanwkdays$Mean.Wk.Days  

meanwkenddays <- data.frame(tapply(wkenddf$steps, factor(wkenddf$interval), mean))
names(meanwkenddays) <- "Mean.Wk.Days"
meanwkenddays$interval <- levels(repdata$interval)
wkenddf$steps[wkenddf$interval == meanwkenddays$interval] <- meanwkenddays$Mean.Wk.Days

repdata.i2 <- rbind(wkdaydf, wkenddf)
repdata.i2$daytype <- as.factor(repdata.i2$daytype)

xyplot(steps ~ interval | daytype, data = repdata.i2, type = "l", 
       scales = list(x=list(at = at, labels = labels)))


