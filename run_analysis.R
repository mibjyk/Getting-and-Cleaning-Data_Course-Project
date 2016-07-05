
### Part 1: Getting Data ###

## Unzipped files are in the folder "UCI HAR Dataset".
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
# Get the list of the files
files


### Part 2: Reading Data - Only some of them will be used ###

## 1. Read data from the files into the variables
# Read the Activity files
dataActivityTest  <- read.table(file.path(path_rf , "Y_test.txt"),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "Y_train.txt"),header = FALSE)
# Read the Subject files
dataSubjectTest  <- read.table(file.path(path_rf, "subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "subject_train.txt"),header = FALSE)
# Read Fearures files
dataFeaturesTest  <- read.table(file.path(path_rf, "X_test.txt"),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "X_train.txt"),header = FALSE)

## 2. Look at the properties of the above varibles
str(dataActivityTest)
str(dataActivityTrain)

str(dataSubjectTest)
str(dataSubjectTrain)

str(dataFeaturesTest)
str(dataFeaturesTrain)


### Part 3: Merges the training and the test sets to create one data set ###

## 1.Concatenate the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## 2.set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## 3.Merge columns to get the data frame "Data" for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


### Part 4: Extracts only the measurements on the mean and standard deviation for each measurement ###

## 1. Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## 2. Subset the data frame Data by seleted names of Features
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data <- subset(Data,select=selectedNames)


### Part 5: Uses descriptive activity names to name the activities in the data set ###

## 1. Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## 2. facorize Variable "activity" in the data frame "Data" using descriptive activity names
Data$activity <- factor(Data$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
head(Data$activity,30)


### Part 6: Appropriately labels the data set with descriptive variable names ###
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)


### Part 7: Creates a second,independent tidy data set and ouput it ###
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

