
setwd("O:/Jacob/Coursera/Course3 - Data Cleaning/Project")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile="Dataset.zip",method="curl")

unzip(zipfile="Dataset.zip",exdir="./data")

 
filepath <- file.path("./data" , "UCI HAR Dataset")


vdataActivityTest  <- read.table(file.path(filepath, "test" , "Y_test.txt" ),header = FALSE)
vdataActivityTrain <- read.table(file.path(filepath, "train", "Y_train.txt"),header = FALSE)
vdataSubjectTrain <- read.table(file.path(filepath, "train", "subject_train.txt"),header = FALSE)
vdataSubjectTest  <- read.table(file.path(filepath, "test" , "subject_test.txt"),header = FALSE)
vdataFeaturesTest  <- read.table(file.path(filepath, "test" , "X_test.txt" ),header = FALSE)
vdataFeaturesTrain <- read.table(file.path(filepath, "train", "X_train.txt"),header = FALSE)


vdataSubject <- rbind(vdataSubjectTrain, vdataSubjectTest)
vdataActivity<- rbind(vdataActivityTrain, vdataActivityTest)
vdataFeatures<- rbind(vdataFeaturesTrain, vdataFeaturesTest)


names(vdataSubject)<-c("subject")
names(vdataActivity)<- c("activity")
vdataFeaturesNames <- read.table(file.path(filepath, "features.txt"),head=FALSE)
names(vdataFeatures)<- vdataFeaturesNames$V2


vdataCombine <- cbind(vdataSubject, vdataActivity)
vData <- cbind(vdataFeatures, vdataCombine)


vsubdataFeaturesNames<-vdataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", vdataFeaturesNames$V2)]

vselectedNames<-c(as.character(vsubdataFeaturesNames), "subject", "activity" )
vData<-subset(vData,select=vselectedNames)



vactivityLabels <- read.table(file.path(filepath, "activity_labels.txt"),header = FALSE)


vData$activity <- as.character(vData$activity)
for (i in 1:6){
vData$activity[vData$activity == i] <- as.character(vactivityLabels[i,2])
}

vData$activity <- as.factor(vData$activity)


names(vData)<-gsub("Acc", "Accelerometer", names(vData))
names(vData)<-gsub("Gyro", "Gyroscope", names(vData))
names(vData)<-gsub("BodyBody", "Body", names(vData))
names(vData)<-gsub("Mag", "Magnitude", names(vData))
names(vData)<-gsub("^t", "Time", names(vData))
names(vData)<-gsub("^f", "Frequency", names(vData))
names(vData)<-gsub("tBody", "TimeBody", names(vData))
names(vData)<-gsub("-mean()", "Mean", names(vData), ignore.case = TRUE)
names(vData)<-gsub("-std()", "STD", names(vData), ignore.case = TRUE)
names(vData)<-gsub("-freq()", "Frequency", names(vData), ignore.case = TRUE)
names(vData)<-gsub("angle", "Angle", names(vData))
names(vData)<-gsub("gravity", "Gravity", names(vData))


vData$subject <- as.factor(vData$subject)
vData <- data.table(vData)


library(dplyr)

vData2<-aggregate(. ~subject + activity, vData, mean)
vData2<-vData2[order(vData2$subject,vData2$activity),]
write.table(vData2, file = "tidydata.txt",row.name=FALSE)





