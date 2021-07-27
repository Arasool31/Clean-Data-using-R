# Step 1: Downloading and Unzipping the data set

if(!file.exists("./data")){dir.create("./data")}

# Data for the project

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")

# Unzip the data to directory

unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

# Step 2: Merge training and test data sets

# Reading training tables 

x_train <- read.table("/data/UCI HAR Dataset/train/X_train")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train")

# Reading test tables

x_test <- read.table("./data/UCI HAR Dataset/train/X_test")
y_test <- read.table("./data/UCI HAR Dataset/train/y_test")
subject_test <- read.table("./data/UCI HAR Dataset/train/subject_test")

# Reading features vector

features <- read.table(".data/UCI HAR Dataset/features")

# Reading activity labels

activityLabels <- read.table(".data/UCI HAR Dataset/activity_labels")

# Assigning column names

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityid"
colnames(subject_train) <- "subjectid"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLables) <- c('activityId', 'activityType')

# Merge into one data set

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
Alltogether <- rbind(mrg_train, mrg_test)

# Step 3: Extract only the measurements on the mean and standard deviation for each measurement

# Reading column names

colNames <- colnames(Alltogether)

# Create vector for ID, mean and standard deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )

# Make necessary subset from Alltogether

setForMeanAndStd <- Alltogether[, mean_and_std == TRUE]

# Step 4: Use descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels, 
                              by = 'activityID', all.x = TRUE)

# Step 5: Appropriately labels the data set with descriptive variable names.

# Done previously

# Step 6: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Making a second tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing second tidy data set in text file

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)







