# Load Packages
library(data.table)
library(dplyr)
library(tidyr)

## Read Data
#  Activity labels
activity_labels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))
setnames(activity_labels, names(activity_labels), c("Activity", "Activity Name"))
#  Features
features <- tbl_df(read.table("./UCI HAR Dataset/features.txt")[,2])
setnames(features, names(features), "feature")
#  Test data
test_subject <- tbl_df(read.table("./UCI HAR Dataset/test/subject_test.txt"))
test_activity <- tbl_df(read.table("./UCI HAR Dataset/test/y_test.txt"))
test_data <- tbl_df(read.table("./UCI HAR Dataset/test/X_test.txt"))
#  Train data
train_subject <- tbl_df(read.table("./UCI HAR Dataset/train/subject_train.txt"))
train_activity <- tbl_df(read.table("./UCI HAR Dataset/train/y_train.txt"))
train_data <- tbl_df(read.table("./UCI HAR Dataset/train/X_train.txt"))

## 1. Merge the training and the test sets to create one data set
dataDF <- bind_rows(test_data, train_data)
colnames(dataDF) <- features$feature

## 2. Extracts only the measurements on the mean and standard deviation for each measurement
features_meanstd <- grep("mean|std", features$feature)
dataDF <- dataDF[,features_meanstd]
#  Merge Subject and Activities 
dataSubject <- bind_rows(test_subject, train_subject)
colnames(dataSubject) <- "Subject"
dataActivity <- bind_rows(test_activity, train_activity)
colnames(dataActivity) <- "Activity"
dataDF <- bind_cols(dataSubject, dataActivity, dataDF)

## 3. Uses descriptive activity names to name the activities in the data set
dataDF <- merge(activity_labels, dataDF, by = "Activity")

## 4. Appropriately labels the data set with with descriptive variable names
names(dataDF) <- gsub("^t", "time", names(dataDF))
names(dataDF) <- gsub("^f", "frequency", names(dataDF))
names(dataDF) <- gsub("Acc", "Accelerometer", names(dataDF))
names(dataDF) <- gsub("Gyro", "Gyroscope", names(dataDF))
names(dataDF) <- gsub("Mag", "Magnitude", names(dataDF))
names(dataDF) <- gsub("mean()", "Mean", names(dataDF))
names(dataDF) <- gsub("std()", "StdDev", names(dataDF))
names(dataDF) <- gsub("Freq()", "Frequency", names(dataDF))

## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyDF <- dataDF[-1]
colnames(tidyDF)[1] <- "Activity"
tidyDF <- tidyDF[, c(2,1,3:ncol(tidyDF))]

#  Reshape data
gather_DF <- gather(tidyDF, feature, value, -Subject, -Activity)
tidyDF <- gather_DF %>% 
  group_by(Subject, Activity, feature) %>% 
  summarize(meanVal = mean(value)) %>%
  spread(feature, meanVal)
View(tidyDF)

#  Write to table
write.table(tidyDF, file = "TidyData.txt", row.names = FALSE)


