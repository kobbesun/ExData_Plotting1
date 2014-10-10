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

# import dataset package
#library(dataset)

# output as png
png("figure/plot1.png")

# Plot 1
hist(dt_uci_target$Global_active_power, 
     freq = TRUE, col="red", 
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# turn off device
dev.off()