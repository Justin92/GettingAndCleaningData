##Coursera Project Getting and Cleaning Data

library(stringr)
library(dplyr)
library(dtplyr)




##First step is to bring in both the data sets: Training Set and the Test Set
##Assuming that you are in directory where linked folder *****getdata%2FProjectfiles%2FUCI HAR Dataset**** is 

##TRAINING SET

TrainingLabels <- read.table(
  "getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", 
  header = F, stringsAsFactors = F)

TrainingSet <- read.table(
  "getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",
  header = F, stringsAsFactors = F)


##TEST SET

TestLabels <- read.table(
  "getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", 
  header = F, stringsAsFactors = F)

TestSet <- read.table(
  "getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",
  header = F, stringsAsFactors = F)


#Label indicating the group from which the data came using the addition of a new column "Group"
TrainingDataFrame <- cbind(rep("Train", 7352), TrainingLabels, TrainingSet)
TestDataFrame <- cbind((rep("Test", 2947)), TestLabels, TestSet)

colnames(TestDataFrame) <- c("Group", colnames(TestDataFrame[2:563]))
colnames(TrainingDataFrame) <- c("Group", colnames(TrainingDataFrame[2:563]))



#Combine the datasets using rbind
CombinedData <- rbind(TestDataFrame, TrainingDataFrame)



##Loading in the feature labels for the 561 element vector
setwd("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/")
FeatureLabels <- read.table("features.txt", header = F, stringsAsFactors = F)


#Combine the Test and Training Datasets
colnames(CombinedData) <- c("Group", "Activity", FeatureLabels[,2])
TrainSubjectLabels <- read.table("train/subject_train.txt", header = F)

TestSubjectLabels <- read.table("test/subject_test.txt", header = F)

AllSubjectLabels <- rbind(TestSubjectLabels, TrainSubjectLabels)

CombinedData <- cbind(AllSubjectLabels, CombinedData)

ActivityLabels <- read.table("activity_labels.txt", header = F, stringsAsFactors = F)

#Change activity labels from integers to corresponding strings
CombinedData$Activity <- gsub(5, "Standing", CombinedData$Activity)
CombinedData$Activity <- gsub(6, "Laying", CombinedData$Activity)
CombinedData$Activity <- gsub(4, "Sitting", CombinedData$Activity)
CombinedData$Activity <- gsub(3, "Walking Down", CombinedData$Activity)
CombinedData$Activity <- gsub(2, "Walking Up", CombinedData$Activity)
CombinedData$Activity <- gsub(1, "Walking", CombinedData$Activity)

#Select all the columns that are standard deviations or means as well as the label columns
SelectCol <- c(1, 2, 3, grep("std", colnames(CombinedData)), grep("mean", colnames(CombinedData)))
SelCombinedData <- CombinedData[, SelectCol]
colnames(SelCombinedData) <- c("Subject", colnames(SelCombinedData[2:82]))



#Transform column labels from abbreviations to full statement descriptions then attach that to the data frame
NewColumns <- gsub("fBody(Body)?", "Frequency Body ", colnames(SelCombinedData))
NewColumns <- gsub("tBody", "Time Body ", NewColumns)
NewColumns <- gsub("Gyro", "Gyroscope  ", NewColumns)
NewColumns <- gsub("Acc", "Accelerometer  ", NewColumns)
NewColumns <- gsub("Jerk", "Jerk signal  ", NewColumns)
NewColumns <- gsub("Mag", "Magnitude  ", NewColumns)
NewColumns <- gsub("tGravity", "Time Gravity  ", NewColumns)
NewColumns <- gsub("-meanFreq\\(\\)", "Mean Frequency", NewColumns)
NewColumns <- gsub("-mean\\(\\)", "Mean", NewColumns)
NewColumns <- gsub("-std\\(\\)", "Standard Deviation", NewColumns)

colnames(SelCombinedData) <- NewColumns



#SelCombinedData is a dataframe that contains the values of the standard deviation and means for all of the variables collected in the 561 metric
##vectors
#Write that to a table
write.table(SelCombinedData, file = "Measurement_MeansAndStandardDeviations.txt", row.names = FALSE)


#Transform that data frame to tbl_df and group by the subject and activity before calculating means
SelCombinedData_tbl <- tbl_df(SelCombinedData)
GroupedMeans <- SelCombinedData_tbl %>% group_by(Subject, Activity) %>% summarize_at(.funs = mean, .vars = 4:82)


##GroupedMeans variable holds the means of all the variables from SelCombinedData but grouped by both subject and activity
write.table(GroupedMeans, file = "Measurement_Means_GroupedByActivityAndSubject.txt", row.names = FALSE)


