# Codebook

# Source Data
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.
Source data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# The Dataset
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

# Required Packages
The following libraries are to be loaded: data.table, dyplr, and tidyr.

# Transformations
# 1. Merges the training and the test sets to create one data set.
Read into a dataframe tbl:
* activity_labels.txt: Class labels with activity name
* features.txt: List of all features.
* test/test_subject: Test subjects
* test/y_test.txt: Test activity
* test/X_test.txt: Test dataset
* train/train_subject: Training subjects
* train/y_train.txt: Training activity
* train/X_train.txt: Training dataset
Set column names and merge to create one data set.

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Use grep to extract feature column names for mean and std. Subset the dataframe for the extracted features.

# 3. Uses descriptive activity names to name the activities in the data set
Merges the activity label and dataframe to include the activity names in place of activity id in the main dataframe.

# 4. Appropriately labels the data set with descriptive variable names.
Use sub to replace variable names with more descriptive labels.

* t - time
* f - frequency
* Acc - Accelerometer
* Gyro - Gyroscope
* Mag - Magnitude
* mean() - Mean
* std() - StdDev
* Freq() - Frequency

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Reshapes the data by
* Gathering the data into key-value pairs based on feature
* Group data by subject, activity, and feature
* Create a variable for the average of each group of data
* Spread the key-value pairs to make the long data "wide"

The resulting tidy dataset is written to a new independent file "TidyData.txt"


