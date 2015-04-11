
# plot2.R 
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

png('plot2.png')

plot(loadedDF$date.time, loadedDF$Global_active_power, xlab ='', ylab='Global Active Power (kilowatts)', type='l')


dev.off()

