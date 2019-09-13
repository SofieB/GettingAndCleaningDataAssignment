
The run_analysis.R script performs getting and cleaning data.

### Preparation

1. Library settings  
	library (dplyr)  
	library (data.table)

2. Getting data  
	Download dataset, unzip  
	Folder: UCI HAR Dataset  
	
3. Reading data, assigning to variables, adding column names  

| file                    | variables       | rows | columns | contains                                             | column names            |
|-------------------------|-----------------|------|---------|------------------------------------------------------|-------------------------|
| features.txt            | features        | 561  | 2       | integer, factor w 477 levels (see features_info.txt) |                         |
| activity_labels.txt     | activity_labels | 6    | 2       | integer, factor w 6 levels (labels activity)         | activity_code, activity |
| test/subject_test.txt   | subject_test    | 2947 | 1       | integer (subjects being observed)                    | subject                 |
| test/X_test.txt         | x_test          | 2947 | 561     | numeric (recorded features test data)                | features[,2]            |
| test/y_test.txt         | y_test          | 2947 | 1       | integer (test data of activities code labels)        | activity_code           |
| train/subject_train.txt | subject_train   | 7352 | 1       | integer (subjects being observed)                    | subject                 |
| train/X_test.txt        | x_train         | 7352 | 561     | numeric (recorded features traindata)                | features[,2]            |
| train/y_test.txt        | y_train         | 7352 | 1       | integer (train data of activities code labels)       | activity_code           |



### Assignment steps:

1. Merge the training and the test sets to create one data set  
	* merged by row:  
		* subject = subject_test + subject_train  
		* activities = y_test + y-train  
		* features = x_test + x_train  
	* merged by column:  
		* merged_data = subject + activities + features  
		* 10299 rows,  563 columns  
	
2. Extract only the measurements on the mean and standard deviation for each measurement.  
	mean_std_data (10299 rows, 81 columns) is created by subsetting merged_data, selecting only columns: subject, activity_code and the measurements on the mean and standard deviation for each measurement  
	
3. Use descriptive activity names to name the activities in the data set  
	activity_data: (10299 rows, 82 columns) is created by merging mean_std_data with activity_labels  

4. Appropriately label the data set with descriptive variable names.  
	Names of features are  labelled using descriptive variable names.  
* prefix t = Time
* Acc = Accelerometer
* Gyro = Gyroscope
*	prefix f = Frequency
* Mag = Magnitude
* BodyBody = Body

5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.  
* average_data (180 rows, 88 columns) 
* Export average_data into average_data.txt file
