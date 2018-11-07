##Coursera Project Getting and Cleaning Data

library(stringr)
library(dplyr)
library(dtplyr)




##First step is to bring in both the data sets: Training Set and the Test Set


##TRAINING SET

TrainingLabels <- read.table(
  "C:/Users/jmcketney.AD/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", 
  header = F, stringsAsFactors = F)

TrainingSet <- read.table(
  "C:/Users/jmcketney.AD/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",
  header = F, stringsAsFactors = F)


##TEST SET

TestLabels <- read.table(
  "C:/Users/jmcketney.AD/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", 
  header = F, stringsAsFactors = F)

TestSet <- read.table(
  "C:/Users/jmcketney.AD/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",
  header = F, stringsAsFactors = F)


#Label indicating the group from which the data came using the addition of a new column "Group"


TrainingDataFrame <- cbind(rep("Train", 7352), TrainingLabels, TrainingSet)
TestDataFrame <- cbind((rep("Test", 2947)), TestLabels, TestSet)

colnames(TestDataFrame) <- c("Group", colnames(TestDataFrame[2:563]))
colnames(TrainingDataFrame) <- c("Group", colnames(TrainingDataFrame[2:563]))

#Combine the datasets using rbind
CombinedData <- rbind(TestDataFrame, TrainingDataFrame)



##Loading in the feature labels for the 561 element vector
setwd("C:/Users/jmcketney.AD/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/")
FeatureLabels <- read.table("features.txt", header = F, stringsAsFactors = F)


colnames(CombinedData) <- c("Group", "Activity", FeatureLabels[,2])
TrainSubjectLabels <- read.table("train/subject_train.txt", header = F)

TestSubjectLabels <- read.table("test/subject_test.txt", header = F)

AllSubjectLabels <- rbind(TestSubjectLabels, TrainSubjectLabels)

CombinedData <- cbind(AllSubjectLabels, CombinedData)

ActivityLabels <- read.table("activity_labels.txt", header = F, stringsAsFactors = F)


CombinedData$Activity <- gsub(5, "Standing", CombinedData$Activity)
CombinedData$Activity <- gsub(6, "Laying", CombinedData$Activity)
CombinedData$Activity <- gsub(4, "Sitting", CombinedData$Activity)
CombinedData$Activity <- gsub(3, "Walking Down", CombinedData$Activity)
CombinedData$Activity <- gsub(2, "Walking Up", CombinedData$Activity)
CombinedData$Activity <- gsub(1, "Walking", CombinedData$Activity)


SelectCol <- c(1, 2, 3, grep("std", colnames(CombinedData)), grep("mean", colnames(CombinedData)))

SelCombinedData <- CombinedData[, SelectCol]

colnames(SelCombinedData) <- c("Subject", colnames(SelCombinedData[2:82]))

NewColumns <- gsub("fBody(Body)?", "Full Body ", colnames(SelCombinedData))


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
##vector

SelCombinedData_tbl <- tbl_df(SelCombinedData)

GroupedMeans <- SelCombindedData_tbl %>% group_by(Subject, Activity) %>% summarize_at(.funs = mean, .vars = 4:82)

##GroupedMeans variable holds the means of all the variables from SelCombinedData but grouped by both subject and activity

