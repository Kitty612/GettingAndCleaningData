
# Download file from website

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip")
if (!file.exists("UCI HAR Dataset")) {
  unzip("dataset.zip")
}

# Read data from .txt files
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("UCI HAR Dataset/train/x_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")

colnames(activityLabels) <- c("activityID", "activityType")
colnames(subjectTrain) <- "subjectID"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityID"

train <- cbind(yTrain, subjectTrain, xTrain)

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("UCI HAR Dataset/test/x_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")

colnames(subjectTest) <- "subjectID"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityID"

test <- cbind(yTest, subjectTest, xTest)

all_data <- rbind(train, test)

# Filter by column names to get the desired columns
colNames <- colnames(all_data)

v <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl(".*mean.*|.*std.*",colNames))

data <- all_data[v == TRUE]

finalData <- merge(data, activityLabels, by = "activityID")

colNames <- colnames(finalData)

colNames <- gsub("-mean", "Mean", colNames)
colNames <- gsub("-std", "Std", colNames)
colNames <- gsub("\\()", "", colNames)
colNames <- gsub("^(t)", "time", colNames)
colNames <- gsub("^(f)", "freq", colNames)

colnames(finalData) = colNames


# Generate tidy dataset
finalData2  = finalData[,names(finalData) != "activityType"]

tidyData = aggregate(finalData2[,names(finalData2) != "activityID"],by=list(activityID=finalData2$activityID,subjectID = finalData2$subjectID),mean);

tidyData = merge(tidyData,activityLabels,by='activityID')

write.table(tidyData, './tidyData.txt',row.names=FALSE)



