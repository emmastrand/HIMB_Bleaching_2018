#Title: Bleaching estimates from pictures
#Author: HM Putnam
#Date Last Modified: 20170626
#See Readme file for details

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries

library("vegan")

#Required Data files

# Set Working Directory:
setwd("~/MyProjects/HIMB_Bleaching_2018/") #set working

Data <- read.csv("Color_Score_Data.csv", header=T, sep=",", na.string="NA") #read in data fil

Red.Norm.Coral <- Data$Red.Coral/Data$Red.Standard #normalize to color standard
Green.Norm.Coral <- Data$Green.Coral/Data$Green.Standard #normalize to color standard
Blue.Norm.Coral <- Data$Blue.Coral/Data$Blue.Standard #normalize to color standard

blch.scor <- as.matrix(cbind(Red.Norm.Coral,Green.Norm.Coral,Blue.Norm.Coral)) #create matrix
rownames(blch.scor) <- Data$Fragment.ID #name columns in dataframe

dist <- vegdist(blch.scor, method="euclidean") #calculate distance matrix of color scores

PCA.color <- princomp(dist) #run principal components Analysis
summary(PCA.color) # view variance explained by PCs

Blch <- as.data.frame(PCA.color$scores[,1]) #extract PC1
Blch  <- cbind(Blch, rownames(Blch), Data$Date, Data$Side, Data$Treatment) #make a dataframe of PC1 and experiment factors
colnames(Blch) <- c("Bleaching.Score", "Fragment.ID", "Date", "Side","Treatment") #name columns

pdf("~/MyProjects/HIMB_Bleaching_2018/Photographic_Bleaching.pdf")
boxplot(Bleaching.Score ~ Treatment*Date, data = Blch, lwd = 1, ylab = 'PC1Color') #plot boxplot of PC1 color score by Genotype and timepoint
stripchart(Bleaching.Score ~ Treatment*Date, vertical = TRUE, data = Blch, 
           method = "jitter", add = TRUE, pch = 20, col = 'blue') #include all datapoints in blue overlaid on boxplots
text(x= 0.5, y= 0.5, labels= "dark") #add text to indicate dark and pale on graphic
text(x= 0.5, y= -1.5, labels= "pale") #add text to indicate dark and pale on graphic
dev.off()

summary(aov(Bleaching.Score ~ Treatment, data=Blch)) #run an ANOVA by Genotype
hist(Blch$Bleaching.Score) #look at normality of data
boxplot(Blch$Bleaching.Score) #look at normality of data

