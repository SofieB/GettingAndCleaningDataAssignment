# Library settings

library(dplyr)
library(data.table)

# Downloading and unzipping dataset

filename <- "MyData.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Reading the data

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# Assigning column names

colnames(x_train) <- features[,2]
colnames(y_train) <-"activity_code"
colnames(subject_train) <- "subject"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_code"
colnames(subject_test) <- "subject"
colnames(activity_labels) <- c('activity_code','activity')

# Merge data to 1 dataset

subject <- rbind(subject_test, subject_train)
activities <- rbind(y_test, y_train)
featuredata <- rbind(x_test,x_train)
merged_data <- cbind(subject, activities, featuredata)

# Reading column names

column_names <- colnames(merged_data)

# Creating vector for defining mean and standard deviation for each measurement

mean_std <- (grepl("subject" , column_names) | 
                   grepl("activity_code" , column_names) | 
                   grepl("mean.." , column_names) | 
                   grepl("std.." , column_names) 
)

# Subsetting from merged_data

mean_std_data <- merged_data[, mean_std==TRUE]

# Subsetting from merged_data

activity_data <- merge(mean_std_data, activity_labels,
                              by="activity_code",
                              all.x=TRUE)

# Labeling the data set with descriptive variable names

names(activity_data)<-gsub("^t", "time", names(activity_data))
names(activity_data)<-gsub("^f", "frequency", names(activity_data))
names(activity_data)<-gsub("Acc", "Accelerometer", names(activity_data))
names(activity_data)<-gsub("Gyro", "Gyroscope", names(activity_data))
names(activity_data)<-gsub("Mag", "Magnitude", names(activity_data))
names(activity_data)<-gsub("BodyBody", "Body", names(activity_data))

# Dropping the activity_code column and reordering for a better overview

activity_data <- activity_data[,c(2,82,3:81)]

# Creating second data set data set with the average of each variable for each activity and each subject

average_data <- aggregate(. ~subject + activity, activity_data, mean)

# Export second data set

write.table(average_data, "average_data.txt", row.name=FALSE)
                                 
