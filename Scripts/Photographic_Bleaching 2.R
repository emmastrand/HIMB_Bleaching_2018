#Title: Bleaching estimates from pictures
#Author: HM Putnam
#Date Last Modified: 20180807
#See Readme file for details

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries

library("vegan")

#Required Data files

# Set Working Directory:
setwd("~/MyProjects/HIMB_Bleaching_2018/") #set working

Data <- read.csv("Color_Score_Data.csv", header=T, sep=",", na.string="NA") #read in data fil

Data <- subset(Data, Date!="20180802")
# Data <- subset(Data, Treatment!="Ambient1")
#Data <- subset(Data, Side=="Front")
#Data <- subset(Data, Side=="Back")

Colors <- as.data.frame(aggregate(Red.Coral~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- cbind(Colors, aggregate(Green.Coral~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- cbind(Colors, aggregate(Blue.Coral~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- cbind(Colors, aggregate(Red.Standard~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- cbind(Colors, aggregate(Green.Standard~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- cbind(Colors, aggregate(Blue.Standard~TimePoint*Fragment.ID, data=Data, FUN=mean))
Colors <- Colors[,-c(4,5,7,8, 10,11,13,14,16,17)]
Colors$Group <- paste(Colors$TimePoint, Colors$Fragment.ID)

Colors$Red.Norm.Coral <- Colors$Red.Coral/Colors$Red.Standard #normalize to color standard
Colors$Green.Norm.Coral <- Colors$Green.Coral/Colors$Green.Standard #normalize to color standard
Colors$Blue.Norm.Coral <- Colors$Blue.Coral/Colors$Blue.Standard #normalize to color standard

blch.scor <- as.matrix(Colors[,c("Red.Norm.Coral","Green.Norm.Coral","Blue.Norm.Coral")])
rownames(blch.scor) <- Colors$Group #name columns in dataframe


dist <- vegdist(blch.scor, method="euclidean") #calculate distance matrix of color scores

PCA.color <- princomp(dist) #run principal components Analysis
summary(PCA.color) # view variance explained by PCs

Blch <- as.data.frame(PCA.color$scores[,1]) #extract PC1
trts <- unique(Data[,c('TimePoint','Fragment.ID','Treatment')])
Blch <- cbind(Blch, trts[order(trts$Fragment.ID, trts$TimePoint),])
colnames(Blch) <- c("Bleaching.Score", "Timepoint", "Fragment.ID", "Treatment") #name columns

Blch$Timepoint  = factor(Blch$Timepoint, levels=c("Day1", "Day4", "Day6", "Day8", "Day11"))

pdf("~/MyProjects/HIMB_Bleaching_2018/Output/Photographic_Bleaching.pdf")
par(mar=c(8,5,2,2))
boxplot(Bleaching.Score ~ Treatment*Timepoint, data = Blch, lwd = 1, ylab = 'PC1Color', las=2) #plot boxplot of PC1 color score by Genotype and timepoint
stripchart(Bleaching.Score ~ Treatment*Timepoint, vertical = TRUE, data = Blch, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue') #include all datapoints in blue overlaid on boxplots
text(x= 0.5, y= max(Blch$Bleaching.Score-0.3), labels= "pale") #add text to indicate dark and pale on graphic
text(x= 0.5, y= min(Blch$Bleaching.Score+0.5), labels= "dark") #add text to indicate dark and pale on graphic
dev.off()

summary(aov(Bleaching.Score ~ Treatment*Timepoint, data=Blch)) #run an ANOVA by Genotype
hist(Blch$Bleaching.Score) #look at normality of data
boxplot(Blch$Bleaching.Score) #look at normality of data

