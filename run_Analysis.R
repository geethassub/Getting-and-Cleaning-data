fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f<-file.path(getwd(), "cleaning.zip")

fd <- download.file(fileurl,f)

#unzip the files

unzip(zipfile = "cleaning.zip", exdir = "D:/Geetha/Coursera/R/Quiz/cleaningfinal")

#read activity files

readactivitytest <- read.csv(file.path(getwd(), "test", "y_test.txt"),header = FALSE)
readactivitytrain <- read.csv(file.path(getwd(), "train", "y_train.txt"),header = FALSE)

#read subject files

readsubjecttest <- read.csv(file.path(getwd(), "test", "subject_test.txt"),header = FALSE)
readsubjecttrain <- read.csv(file.path(getwd(), "train", "subject_train.txt"),header = FALSE)

#read feature files

readfeaturetest <- read.csv(file.path(getwd(), "test", "X_test.txt"),header = FALSE,sep ="")
readfeaturetrain <- read.csv(file.path(getwd(), "train", "X_train.txt"),header = FALSE, sep = "")

#row bind the data

activitybind <- rbind(readactivitytest,readactivitytrain)
subjectbind <- rbind(readsubjecttrain,readsubjecttest)
featurebind <- rbind(readfeaturetest,readfeaturetrain)


#read feature text

fettext <- read.csv(file.path(getwd(), "features.txt"), header = FALSE, sep = "")
names(featurebind) <- fettext[,2]
names(activitybind) <- "ActivityNum"
names(subjectbind) <- "Subject"

#merge the columns

mergeddata <- cbind(activitybind,subjectbind,featurebind)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

featurenames <- fettext$V2[grep(("mean\\(\\)|std\\(\\)"), fettext$V2)]
selectednames <- c(as.character(featurenames), "Subject", "ActivityNum")

data <- subset(mergeddata, select = selectednames)


#acitivit labels

activitylabels <- read.csv(file.path(getwd(), "activity_labels.txt"), header = FALSE,sep ="")
names(activitylabels) <- c("ActivityNum", "Activity")

Mergenames <- merge(data,activitylabels, by = "ActivityNum")

#Descriptive Varibale names


names(Mergenames)<-gsub("^t", "Time",names(Mergenames))
names(Mergenames)<-gsub("^f", "frequency", names(Mergenames))
names(Mergenames)<-gsub("Acc", "Accelerometer", names(Mergenames))
names(Mergenames)<-gsub("Gyro", "Gyroscope", names(Mergenames))
names(Mergenames)<-gsub("Mag", "Magnitude", names(Mergenames))
names(Mergenames)<-gsub("BodyBody", "Body", names(Mergenames))

#create tidy dataset

library(plyr)

Mergenames2 <- aggregate(. ~Subject+Activity, Mergenames, mean)
tidydata <- Mergenames2[order(Mergenames2$Subject, Mergenames2$Activity),]
write.table(tidydata, file = "Tidydata.txt", row.names = FALSE)



