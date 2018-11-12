# GettingAndCleaningData
## Markdown explanation and R script for assembling and parsing personal computing data and codebook explanation of variables

## Bringing in the Datasets:

  * TrainingLabels - frame containing labels for training dataset describing activity performed by integer code(1-6)
  * TrainingSet - frame containing 561 measurement vectors for each subject and activity from training dataset

  * TestLabels - frame containing labels for test dataset describing activity performed by integer code(1-6)
  * TestSet - frame containing 561 measurement vectors for each subject and activity from test dataset

  * TrainingDataFrame - data frame consisting of connected labels and measurement vector for training dataset
  * TestDataFrame - data frame consisting of connected labels and measurement vector for test dataset
  * CombinedData - data frame combining TrainingDataFrame and TestDataFrame

## Attaching Labels:

  * TrainSubjectLabels - single column data frame with integer value desctibing the associated subject
  * TrainSubjectLabels - single column data frame with integer value desctibing the associated subject
  * AllSubjectLabels - single column data frame combining Training and Testing Subject Labels
  * ActivtiyLabels - two column data frame indicating activity description associated with each integer code

## Extracting and Labeling Relevant Columns 

  * SelectCol - numeric vector indicating columns that describe mean an standard deviation as well as experimental information(subject,    group, activity)
  * SelCombinedData - data frame based on the above vector conaining the mean and standard deviation of all measurements for all subjects and activities
  * NewColumns - a character vector containing descriptive names that will be assigned to the column labels of the above data frame

## Finding Grouped Means

  * GroupedMeans - a tbl data frame that includes the means of all column variables in SelCombinedData grouped by subject and activity



