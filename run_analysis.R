library(plyr)
library(dplyr)
library(reshape2)

act <- read.table("activity_labels.txt")
lab <- read.table("features.txt")
lab <- lab$V2
  
xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/Y_test.txt")
subTest <- read.table("test/subject_test.txt")


xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/Y_train.txt")
subTrain <- read.table("train/subject_train.txt")

actTest <- join(yTest, act, by="V1")
actTrain <- join(yTrain, act, by="V1")

sub<- rbind(subTest, subTrain)
activ <- rbind(actTest, actTrain)
activ <- activ$V2
comb <- rbind(xTest, xTrain, make.row.names=FALSE)

names(comb) <- lab

iMean <- grep("\\mean()\\b", names(comb))
iStd <- grep("std()", names(comb))
index <- c(iMean, iStd)
new <- comb[,index]


title <- names(new)
title <- strsplit(title, "-")

title1 <- title2 <- title3 <- 0

for(i in 1:66){
  title1[i] <- title[[i]][1]
  title2[i] <- title[[i]][2]
  title3[i] <- title[[i]][3]
}

title3[is.na(title3)==TRUE] <- "Magnitude"

title2 <- gsub("mean", "Mean of", title2)
title2 <- gsub("std", "Standard Deviation of", title2)
title2 <- gsub("\\(|\\)", "", title2)


title1 <- gsub("tBodyAcc", "Body Acceleration", title1)
title1 <- gsub("tGravityAcc", "Gravity Acceleration", title1)
title1 <- gsub("tBodyGyro", "Angular Velocity", title1)

title1 <- gsub("fBodyAcc", "FFT Body Acceleration", title1)
title1 <- gsub("fGravityAcc", "FFT Gravity Acceleration", title1)
title1 <- gsub("fBodyGyro", "FFT Angular Velocity", title1)

title1 <- gsub("fBodyBodyGyro", "FFT Body x Angular Acceleration", title1)
title1 <- gsub("fBodyBodyAcc", "FFT Body x Body Acceleration", title1)
title1 <- gsub("fBodyGyro", "FFT Angular Velocity", title1)

title1 <- gsub("Body AccelerationJerk", "Linear Jerk", title1)
title1 <- gsub("Angular VelocityJerk", "Angular Jerk", title1)
title1 <- gsub("AccelerationJerk", "Jerk", title1)

title1 <- gsub("Mag", "", title1)

TIT <- paste(title2, " ", title1, "-", title3, sep="")

names(new) <- TIT
new$Activity <- activ 
new$Subject <- sub$V1

write.csv(new, "step4.csv")

melted <- melt(new, id=c("Subject", "Activity"))
averages <- dcast(melted, Subject + Activity ~ variable,mean)

write.csv(averages, "step5.csv")


