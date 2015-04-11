
# plot4.R 
## used to load data from file household_power_consumption, only for days
# 01-02-2007 and 02-02-2007

options(stringsAsFactors = FALSE)

inputFile <- "household_power_consumption.txt"
con  <- file(inputFile, open = "r")

loadedDataList <- list()

loadedDF <- data.frame()

targetDates <- c (strptime("01/02/2007", "%d/%m/%Y"),
                  strptime("02/02/2007", "%d/%m/%Y"))

loadedDate <- NA

while (length(oneLine <- readLines(con, n = 1, warn = FALSE)) > 0 &
             (is.na(loadedDate) | loadedDate <= targetDates[2]) ) {
      
      loadedList <- strsplit(oneLine, ";")[[1]]
      
      
      if (loadedList[1] == "Date") {
            # if header line save as column names
            namesCol <- loadedList
            
      }
      else {
            
            
            loadedDate <- strptime(loadedList[1],format= "%d/%m/%Y")
            
            
            if ( !is.na(loadedDate) & 
                       sum(loadedDate == targetDates) >= 1 & 
                       sum(loadedList == "?") == 0 ) {
                  
                  loadedDF <- rbind(loadedDF, loadedList)
                  
                  
            }
      }
      
      
      
} 

# assign column names
colnames(loadedDF) <- namesCol

close(con)

loadedDF$date.time <- paste(loadedDF$Date,loadedDF$Time)


# convert to numeric
loadedDF[3:9]<-as.numeric(unlist(loadedDF[3:9]))

loadedDF$date.time <- strptime(loadedDF$date.time,format= "%d/%m/%Y %H:%M:%S")


### Plot

png('plot4.png')

# set window 
par(mfrow=c(2,2))

# First top left
plot(loadedDF$date.time, loadedDF$Global_active_power,
     xlab='', ylab='Global Active Power', type='l')


# Second top right
plot(loadedDF$date.time, loadedDF$Voltage, xlab='datetime', ylab='Voltage', type='l')


# Third down left
plot(loadedDF$date.time, loadedDF$Sub_metering_1, col='black', type='l', xlab='', ylab='Energy sub metering')
lines(loadedDF$date.time, loadedDF$Sub_metering_2, col='red')
lines(loadedDF$date.time, loadedDF$Sub_metering_3, col='blue')

legend('topright', legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
       col=c('black', 'red', 'blue'), lty='solid', bty='n')


# Last down right
plot(loadedDF$date.time, loadedDF$Global_reactive_power, xlab='datetime', ylab='Global_reactive_power', type='l')

dev.off()
