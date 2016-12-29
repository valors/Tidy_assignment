#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#   each variable for each activity and each subject.

# I used the following code to download and start exploring the readme files:
#   url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#   download.file(url,destfile="data.zip",method="curl")
#   unzip("data.zip")
#   setwd("UCI HAR Dataset")
#   readme<-readLines("Readme.txt")
#   features_info<-readLines("features_info.txt")

# 1: Merges the training and the test sets to create one data set.
# load the training and test sets. Load the subjects and the activities. Merge everything.

X_train<-read.table("train/X_train.txt",na.strings="")
X_test<-read.table("test/X_test.txt",na.strings="")

features<-read.table("features.txt",na.strings="")

colnames(X_test)<-features$V2
colnames(X_train)<-features$V2

y_train<-read.table("train/y_train.txt",na.strings="")
y_test<-read.table("test/y_test.txt",na.strings="")

colnames(y_train)<-"activities"
colnames(y_test)<-"activities"

subject_train<-read.table("train/subject_train.txt",na.strings="")
subject_test<-read.table("test/subject_test.txt",na.strings="")

colnames(subject_train)<-"subject"
colnames(subject_test)<-"subject"

X_train<-cbind(subject_train,y_train,X_train)
X_test<-cbind(subject_test,y_test,X_test)

X<-rbind(X_train,X_test)

rm(X_train,X_test,y_train,y_test,subject_test,subject_train,features)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

# For this we need a regular expression that identifies column names containing either "mean()" or "std()", and also
# "activities" or "subject"

mean_std_names<-grepl("mean\\(\\)|std\\(\\)|activities|subject",colnames(X))
X_extract<-X[,mean_std_names]

rm(X,mean_std_names)

#Part 3:# Uses descriptive activity names to name the activities in the data set

activities<-read.table("activity_labels.txt", stringsAsFactors=FALSE)

# We will use the sapply function, which should do the following, for each observation:
# Find observation of x_extract, and pass observation value to activities$V2[]
# collect resulting value of activities$V2[x] and use it to modify X_extract$activities
# The result is an X_extract vector with a descriptive activity name for each observation.

X_extract$activities<-sapply(X_extract$activities,function(x){activities$V2[x]})

rm(activities)

#4. Appropriately labels the data set with descriptive variable names. We use gsub to substitute the abbreviations by proper words.

names(X_extract)<-gsub("Acc","Acceleration",names(X_extract))
names(X_extract)<-gsub("^t","TimeDomain",names(X_extract))
names(X_extract)<-gsub("^f","FrequencyDomain",names(X_extract))
names(X_extract)<-gsub("-mean\\(\\)","Mean",names(X_extract))
names(X_extract)<-gsub("-std\\(\\)","StandardDeviation", names(X_extract))
names(X_extract)<-gsub("Mag","Magnitude",names(X_extract))
names(X_extract)<-gsub("Gyro","Gyroscope",names(X_extract))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.

library(dplyr)
X_averages<-
  X_extract %>%
  group_by(subject,activities) %>%
  summarize_all(mean)

rm(X_extract)

write.table(X_averages,file="tidy_assignment.txt",row.names=FALSE)

X_averages
