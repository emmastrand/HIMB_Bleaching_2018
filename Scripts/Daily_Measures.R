#HIMB_Bleaching_2018
# Plotting daily measurements, not including Apex data

rm(list=ls()) # removes all prior objects

setwd("~/MyProjects/HIMB_Bleaching_2018/") #set working directory

##### DISCRETE pH CALCULATIONS #####
path <-("~/MyProjects/HIMB_Bleaching_2018/pH_Calibration_Files/")
file.names<-list.files(path = path, pattern = "csv$") #list all the file names in the folder to get only get the csv files
pH.cals <- data.frame(matrix(NA, nrow=length(file.names), ncol=3, dimnames=list(file.names,c("Date", "Intercept", "Slope")))) #generate a 3 column dataframe with specific column names

for(i in 1:length(file.names)) { # for every file in list start at the first and run this following function
  Calib.Data <-read.table(file.path(path,file.names[i]), header=TRUE, sep=",", na.string="NA", as.is=TRUE) #reads in the data files
  file.names[i]
  model <-lm(mVTris ~ TTris, data=Calib.Data) #runs a linear regression of mV as a function of temperature
  coe <- coef(model) #extracts the coeffecients
  summary(model)$r.squared
  plot(Calib.Data$mVTris, Calib.Data$TTris)
  pH.cals[i,2:3] <- coe #inserts them in the dataframe
  pH.cals[i,1] <- substr(file.names[i],1,8) #stores the file name in the Date column
}
colnames(pH.cals) <- c("Calib.Date",  "Intercept",  "Slope") #rename columns
pH.cals #view data

#constants for use in pH calculation 
R <- 8.31447215 #gas constant in J mol-1 K-1 
F <-96485.339924 #Faraday constant in coulombs mol-1

#read in probe measurements of pH, temperature, and salinity from tanks
daily <- read.csv("Daily_Temp_pH_Sal.csv", header=TRUE, sep=",", na.strings="NA") #load data with a header, separated by commas, with NA as NA

#merge with Seawater chemistry file
SW.chem <- merge(pH.cals, daily, by="Calib.Date")

mvTris <- SW.chem$Temperature*SW.chem$Slope+SW.chem$Intercept #calculate the mV of the tris standard using the temperature mv relationships in the measured standard curves 
STris<-35 #salinity of the Tris
phTris<- (11911.08-18.2499*STris-0.039336*STris^2)*(1/(SW.chem$Temperature+273.15))-366.27059+ 0.53993607*STris+0.00016329*STris^2+(64.52243-0.084041*STris)*log(SW.chem$Temperature+273.15)-0.11149858*(SW.chem$Temperature+273.15) #calculate the pH of the tris (Dickson A. G., Sabine C. L. and Christian J. R., SOP 6a)
SW.chem$pH.Total<-phTris+(mvTris/1000-SW.chem$pH.MV/1000)/(R*(SW.chem$Temperature+273.15)*log(10)/F) #calculate the pH on the total scale (Dickson A. G., Sabine C. L. and Christian J. R., SOP 6a)


pdf("~/MyProjects/HIMB_Bleaching_2018/Output/Daily_Treatment_Measures.pdf")
par(mfrow=c(2,2))
plot(SW.chem$Treatment, SW.chem$Temperature, xlab="Treatment", ylab="Temperature°C", ylim=c(23,33))
plot(SW.chem$Treatment, SW.chem$pH.Total, xlab="Treatment", ylab="pH Total Scale", ylim=c(7.0,8.2))
plot(SW.chem$Treatment, SW.chem$Salinity, xlab="Treatment", ylab="Salinity psu", ylim=c(30,37))
plot(SW.chem$Treatment, SW.chem$Light.Reading, xlab="Treatment", ylab="µmol m-2 s-1")
dev.off()

pdf("~/MyProjects/HIMB_Bleaching_2018/Output/Daily_Tank_Measures.pdf")
par(mfrow=c(2,2))
plot(SW.chem$Sample.ID, SW.chem$Temperature, xlab="Tank", ylab="Temperature°C", ylim=c(23,33),las=2)
plot(SW.chem$Sample.ID, SW.chem$pH.Total, xlab="Tank", ylab="pH Total Scale", ylim=c(7.0,8.2),las=2)
plot(SW.chem$Sample.ID, SW.chem$Salinity, xlab="Tank", ylab="Salinity psu", ylim=c(30,37),las=2)
plot(SW.chem$Sample.ID, SW.chem$Light.Reading, xlab="Treatment", ylab="µmol m-2 s-1")
dev.off()
