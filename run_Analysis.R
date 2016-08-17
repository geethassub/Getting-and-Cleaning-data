fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path <- file.path(getwd(), "Cleaning.zip")
file <- download.file(fileurl, path)
#unzip the files
unzip(zipfile = "Cleaning.zip", exdir = "D:/Geetha/Coursera/R/Quiz/cleaning")

#get list of files

path_a <- file.path("D:/Geetha/Coursera/R/Quiz/cleaning", "UCI HAR Dataset")
files <- list.files(path_a, recursive = TRUE)
files

#Read activity files
dataActivityTest  <- read.table(file.path(path_a, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_a, "train", "Y_train.txt"),header = FALSE)

# Read subject files
dataSubjectTrain <- read.table(file.path(path_a, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_a, "test" , "subject_test.txt"),header = FALSE)

#Read feature files
dataFeaturesTest  <- read.table(file.path(path_a, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_a, "train", "X_train.txt"),header = FALSE)

#Merge the data

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

str(Data)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

#Descriptive Varibale names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#In this part,a second, independent tidy data set will be created with the average of each variable for each activity and each subject based on the data set in step 4.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)



