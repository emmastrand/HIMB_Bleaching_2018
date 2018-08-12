#http://166.122.78.194:80/cgi-bin/datalog.xml?sdate=1806030000&days=2
#http://www.informit.com/articles/article.aspx?p=2215520

# BLEACHING EXP 2018 HIMB


library("XML")
library("plyr")

#############################################################
setwd("~/MyProjects/HIMB_Bleaching_2018/") #set working directory
#############################################################

xmlfile <- xmlParse("http://166.122.78.55:80/cgi-bin/datalog.xml?sdate=1808090000&days=4") #read in the date (180620) plus # days (days=4) of Apex data

Apex.Data <- ldply(xmlToList(xmlfile), data.frame) #convert xml to dataframe

Apex.Data2 <- Apex.Data[4:nrow(Apex.Data),] #remove extra metadata from top
Apex.Data2 <- head(Apex.Data2,-2) #remove extra metadata from bottom

write.csv(Apex.Data2, "Apex_Data_All.csv", row.names=FALSE) # use this to check which columns desired for Apex_Data_Output.csv

#keep columnes with data of interest. This needs to be changed as it will be specific to the Apex configuration
Probe.Data <- Apex.Data2[,c(3,6,69)] #select columns
colnames(Probe.Data ) <- c("Date.Time", "Tmp_H1", "Tmp_H2")  #rename columns
Probe.Data$Date.Time <- as.POSIXct(Probe.Data$Date.Time, format = "%m/%d/%Y %H:%M:%S", tz="HST") #convert date to HI time
write.csv(Probe.Data, "~/MyProjects/HIMB_Bleaching_2018/Apex_Data_Output.csv") #write file to save data

#plot Temp and pH and save to output
pdf("~/MyProjects/HIMB_Bleaching_2018/Output/Apex_Output.pdf")
par(mfrow=c(2,1))
plot(as.numeric(as.character(Tmp_H1)) ~ Date.Time, Probe.Data, col = "blue", type="l", ylim=c(25.5, 34),  xlab="Time", ylab="Temperature °C")
lines(as.numeric(as.character(Tmp_H2)) ~ Date.Time, Probe.Data, col = "red")
axis.POSIXct(side=1, Probe.Data$Date.Time)

All.Data <- read.csv("Apex_Data_Output.csv", header=TRUE, sep=",", na.string="NA", as.is=TRUE)
All.Data$Date.Time <- as.POSIXct(All.Data$Date.Time, format = "%m/%d/%Y %H:%M", tz="HST") #convert date to HI time


