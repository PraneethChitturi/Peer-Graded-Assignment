
if(!file.exists("./Data")){
  dir.create("./Data")
}

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = './Data/Dat.zip')

unzip(zipfile = "./Data/Dat.zip",exdir = "./Data")

setwd("./Data/UCI HAR Dataset/")

features <- read.table("features.txt", col.names = c("n","functions"))

activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

a <- rbind(x_test,x_train)
b <- rbind(y_test,y_train)
c <- rbind(subject_test,subject_train)

MergedD <- cbind(c, b, a)

library(dplyr)

MnSTD <- select(MergedD,subject,code,contains("mean"),contains("std"))

MnSTD$code <- activities[MnSTD$code, 2]
names(MnSTD)<-gsub("Acc", "Accelerometer", names(MnSTD))
names(MnSTD)<-gsub("Gyro", "Gyroscope", names(MnSTD))
names(MnSTD)<-gsub("BodyBody", "Body", names(MnSTD))
names(MnSTD)<-gsub("Mag", "Magnitude", names(MnSTD))
names(MnSTD)<-gsub("^t", "Time", names(MnSTD))
names(MnSTD)<-gsub("^f", "Frequency", names(MnSTD))
names(MnSTD)<-gsub("tBody", "TimeBody", names(MnSTD))
names(MnSTD)<-gsub("-mean()", "Mean", names(MnSTD), ignore.case = TRUE)
names(MnSTD)<-gsub("-std()", "STD", names(MnSTD), ignore.case = TRUE)
names(MnSTD)<-gsub("-freq()", "Frequency", names(MnSTD), ignore.case = TRUE)
names(MnSTD)<-gsub("angle", "Angle", names(MnSTD))
names(MnSTD)<-gsub("gravity", "Gravity", names(MnSTD))

FinalData <- MnSTD %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(FinalData, "FinalData.txt", row.name=FALSE)
