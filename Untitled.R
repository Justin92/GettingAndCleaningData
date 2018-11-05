##Coursera Project Getting and Cleaning Data

##First step is to bring in boththe 

TrainingLabels <- read.delim(filepath, header = F, stringsAsFactors = F)

TrainingSet <- read.delim(filepath, header = F, stringsAsFactors = F)

##I think that we might want to read these tables in with different reader function

DataVector <- str_extract_all(TrainingSet[1,1], "(-)?[0-9]+\\.[0-9]+e(-)?[0-9]*")



TrainingSet_df <- data.frame()

for(i in 1:nrow(TrainingSet)){
  
  TempDataVector <- str_extract_all(TrainingSet[i,1], "(-)?[0-9]+\\.[0-9]+e")
  ExpandedDataFrame <- rbind(ExpandedDataFrame, TempDataVector)
}