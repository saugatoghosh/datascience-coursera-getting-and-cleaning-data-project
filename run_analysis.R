# Download and unzip file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/Saugata/Documents/Coursera/datascience/RFiles/Dataset.zip")
unzip(zipfile="C:/Users/Saugata/Documents/Coursera/datascience/RFiles/Dataset.zip",exdir="C:/Users/Saugata/Documents/Coursera/datascience/RFiles")

# Get list of files

path_rf <- file.path("C:/Users/Saugata/Documents/Coursera/datascience/RFiles" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

# Read data from files into the variables
# Read activity files

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#Read subject files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

# Read Features files

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Explore properties of variables

str(dataActivityTest)
str(dataActivityTrain)

str(dataSubjectTrain)
str(dataSubjectTest)

str(dataFeaturesTest)
str(dataFeaturesTrain)

# Merge the training and test sets to create one data set

#Concatenate the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# Set names to variables

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

# Merged columns to get the data frame for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

str(Data)

# Extract only the measurements on the mean and standard deviation for each measurement
#Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
 
# Subset the data frame 'Data' by selected names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

str(Data)

#Use descriptive activity names to name the activities in the data set
#Read descriptive activity names from "activity_labels.txt"

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
head(activityLabels)

# Factorise variable "activity" in the dataframe "Data" using descriptive activity names
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
head(Data$activity,30)

#Appropriately label the data set with descriptive variable names
#In the former part, variables activity and subject and names of the activities have been labelled using descriptive names.In this part, Names of Feteatures will labelled using descriptive variable names.

prefix t is replaced by time
Acc is replaced by Accelerometer
Gyro is replaced by Gyroscope
prefix f is replaced by frequency
Mag is replaced by Magnitude
BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

#Create a second, independent tidy data set and output it

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

str(Data2)

#Produce codebook

library(knitr)
library(markdown)

knit('Codebook.Rmd')
