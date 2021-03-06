# import data.table package
library(data.table)

# get column names
dt_uci_5rows <- fread("../household_power_consumption.txt", sep="auto", 
                      nrows=5, header=TRUE)
print(dt_uci_5rows)

# get target records first position and length
dt_uci_date <- fread("../household_power_consumption.txt", sep="auto", nrows=-1, 
                     header=TRUE, na.strings="?", select=1)
dt_uci_date[, index:=.I]
setkey(dt_uci_date, Date)
row_skip <- dt_uci_date[c("1/2/2007", "2/2/2007"),]$index[1]
count_rows <- nrow(dt_uci_date[c("1/2/2007", "2/2/2007"),])

# obtain target records
dt_uci_target <- fread("../household_power_consumption.txt", sep="auto",
                       nrows=count_rows, header=FALSE, skip=row_skip, 
                       na.strings="?")

# assign column names
setnames(dt_uci_target, names(dt_uci_5rows))

# combine Date and Time to datetime in type POSIXct 
dt_uci_target[, datetime := as.POSIXct(paste(Date, Time, sep = " "),
                                     format = "%d/%m/%Y %H:%M:%S")]

# import dataset package
#library(dataset)

# output as png
png("figure/plot2.png")

# plot 2
with(dt_uci_target, plot(datetime, Global_active_power, type = "l",
                         xlab = "", ylab = "Global Active Power (kilowatts)"))

# turn off device
dev.off()
