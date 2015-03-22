# download zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "dataset.zip"
download.file(url, dest)

# unzip files
unzip(dest, exdir = ".")

# directory of the file after unzip
dir <- "UCI HAR Dataset"

# Step1. Merges the training and the test sets to create one data set

## load data
X_train <- read.table(paste(dir,"train/X_train.txt", sep ='/'))
y_train <- read.table(paste(dir,"train/y_train.txt", sep ='/'))
subject_train <- read.table(paste(dir,"train/subject_train.txt", sep ='/'))

X_test <- read.table(paste(dir,"test/X_test.txt", sep ='/'))
y_test <- read.table(paste(dir,"test/y_test.txt", sep ='/'))
subject_test <- read.table(paste(dir,"test/subject_test.txt", sep ='/'))

## merge
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 2
## Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table(paste(dir,"features.txt", sep ='/'))
meanorstd <- grep("mean\\(\\)|std\\(\\)", features[, 2])

## get subset data
X_data <- X_data[, meanorstd]

## rename columns
names(X_data) <- features[meanorstd, 2]


# Step3. Uses descriptive activity names to name the activities in the data set

activities <- read.table(paste(dir,"activity_labels.txt", sep ='/'))
## extract corresponding names
activityLabel <- activities[y_data[, 1], 2]

## Uses descriptive activity names to name the activities in the data set
y_data[, 1] <- activityLabel

## rename the columns
names(y_data) <- "Activity"

# Step4. Appropriately labels the data set with descriptive activity names.
names(subject_data) <- "Subject"
all_data <- cbind(X_data, y_data, subject_data)

# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(plyr)

average <- ddply(all_data, .(Subject, Activity), function(x) { colMeans(x[,1:66]) })
write.table(average, "average.txt", row.names = FALSE)
