


# You should create one R script called run_analysis.R that does the following. 

# You should create one R script called run_analysis.R that does the following. 
# Task 1: Merges the training and the test sets to create one data set.
# Task 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
# Task 3: Uses descriptive activity names to name the activities in the data set
# Task 4: Appropriately labels the data set with descriptive variable names. 
# Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#         for each activity and each subject.



library(plyr)


################       Task 1 (Partial)     #######################################################

# Merges the training and the test sets to create one data set.

Training_Data <- read.table("UCI HAR Dataset/train/X_train.txt")
Test_Data <- read.table("UCI HAR Dataset/test/X_test.txt")
Experimental_Data <- rbind(Training_Data, Test_Data)

Activity_Identifier_TrainingData <- read.table("UCI HAR Dataset/train/y_train.txt")
Activity_Identifier_TestData <- read.table("UCI HAR Dataset/test/y_test.txt")
Activity_Identifier_Data <- rbind(Activity_Identifier_TrainingData, Activity_Identifier_TestData)

Subject_Identifier_TrainingData <- read.table("UCI HAR Dataset/train/subject_train.txt")
Subject_Identifier_TestData <- read.table("UCI HAR Dataset/test/subject_test.txt")
Subject_Identifier_Data <- rbind(Subject_Identifier_TrainingData, Subject_Identifier_TestData)


# Note: At this stage we will not merge the 3 datasets from above. This is because it helps to optimize the further steps.



################   Task 2              ############################################################

# Extracts only the measurements on the mean and standard deviation for each measurement. 


List_Of_Variables <- read.table("UCI HAR Dataset/features.txt")
Required_Variables <- grep("-(mean|std)\\(\\)", List_Of_Variables[, 2])
Experimental_Data <- Experimental_Data[, Required_Variables]




#Note: At this stage we only have mean and standard deviation in Experimental_Data.

################   Task 3        ##################################################################


# Uses descriptive activity names to name the activities in the data set



activities <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity_Identifier_Data[, 1] <- activities[Activity_Identifier_Data[, 1], 2]


names(Activity_Identifier_Data) <- "activity"
names(Subject_Identifier_Data) <- "subject"


#Note : At this stage all our variables are properly named.


################   Task 4       ###################################################################

# Task 4: Appropriately labels the data set with descriptive variable names. 


names(Experimental_Data) <- List_Of_Variables[Required_Variables, 2]


#############      Task 1 (Final merger of datasets)  #############################################

# bind all the data in a single data set
Final_data <- cbind(Experimental_Data, Activity_Identifier_Data, Subject_Identifier_Data)


################   Task 5 (final step) ###########################################################


# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.


Tidy_data <- ddply(Final_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(Tidy_data, "tidy_data.txt", row.name=FALSE)



