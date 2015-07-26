

# Introduction.

This code book is a companion to the R code which is part of submission of assignment for the course "Getting and Cleaning Data" which is part of the "Data Science" specializaion from John Hopkins University through Coursera. It describes the variables, the data, and any transformations or work that was performed to clean up the data and product the final tidy data set.

# Original Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Source of above information : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Source of above information : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Features of the Dataset.


The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean



# Transformations.

The following steps were done to convert the data obtained above to the final tidy data set.

## Step 1.

Data from Training and Test folders were merged to give 3 datasets listed below.
- Experimental Data
- Activity Data
- Subject Data

R code to perform the above step is listed below.

```
Training_Data <- read.table("UCI HAR Dataset/train/X_train.txt")
Test_Data <- read.table("UCI HAR Dataset/test/X_test.txt")
Experimental_Data <- rbind(Training_Data, Test_Data)

Activity_Identifier_TrainingData <- read.table("UCI HAR Dataset/train/y_train.txt")
Activity_Identifier_TestData <- read.table("UCI HAR Dataset/test/y_test.txt")
Activity_Identifier_Data <- rbind(Activity_Identifier_TrainingData, Activity_Identifier_TestData)

Subject_Identifier_TrainingData <- read.table("UCI HAR Dataset/train/subject_train.txt")
Subject_Identifier_TestData <- read.table("UCI HAR Dataset/test/subject_test.txt")
Subject_Identifier_Data <- rbind(Subject_Identifier_TrainingData, Subject_Identifier_TestData)

```


## Step 2

We want only the mean and standard deviation for each measurement. This is done by extracting the list of varaibles from features.txt. The variable list is imported in a data frame. Another list is then derived from the Variable list which contains variables which have "mean" and "std" words in them. This is done using the grep function. After that we filter our "Experimental_Data" dataset to contain only the mean and std varaibles.  

Code block for the above step is as below.
```
List_Of_Variables <- read.table("UCI HAR Dataset/features.txt")
Required_Variables <- grep("-(mean|std)\\(\\)", List_Of_Variables[, 2])
Experimental_Data <- Experimental_Data[, Required_Variables]
```

## Step 3

We assign Activity Labels in the Activity dataset using the file "activity_labels.txt". We also name the sole column in the Activity_Identifier_Data and Subject_Identifier_Data to "activity" and "subject" respectively.

Code block for the above step is given below.

```
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity_Identifier_Data[, 1] <- activities[Activity_Identifier_Data[, 1], 2]

names(Activity_Identifier_Data) <- "activity"
names(Subject_Identifier_Data) <- "subject"
```

## Step 4


We now give variable names derived in step 2 to our Experimental data set.

Code block for above step is as follows.

```
names(Experimental_Data) <- List_Of_Variables[Required_Variables, 2]
```


## Step 5 
We now merge all the 3 datasets from step 1 into one dataset. This final dataset will have the required measurements (mean and standard deviation) along with that it will have two more columns for Subject and Activity. 

Code block for above step is as follows.

```
Final_data <- cbind(Experimental_Data, Activity_Identifier_Data, Subject_Identifier_Data)
```

## Step 6

From the data set of step 5, we creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```
Tidy_data <- ddply(Final_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(Tidy_data, "tidy_data.txt", row.name=FALSE)

```




## List of columns in the tidy data set.



Sr. No. | Column Name                      | Description   |
--------|--------------------|------------------------------   |
1 | subject          | Numeric identifier for the Subject (Human) performing the experiment. |
2 | activity             | Text Identifier for the Activity being performed by the Subject. Possible values are "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING". |                                 
3 | tBodyAcc-mean()-X  |  Present in original dataset. Refer section above.   |
4 | tBodyAcc-mean()-Y  | Present in original dataset. Refer section above.   |
5 | tBodyAcc-mean()-Z  | Present in original dataset. Refer section above.   |
6 | tBodyAcc-std()-X  | Present in original dataset. Refer section above.   |
7 | tBodyAcc-std()-Y  | Present in original dataset. Refer section above.   |
8 | tBodyAcc-std()-Z  | Present in original dataset. Refer section above.   |
9 | tGravityAcc-mean()-X    |   Present in original dataset. Refer section above.   |
10 | tGravityAcc-mean()-Y    |   Present in original dataset. Refer section above.   |
11 | tGravityAcc-mean()-Z    |   Present in original dataset. Refer section above.   |
12 | tGravityAcc-std()-X    |   Present in original dataset. Refer section above.   |
13 | tGravityAcc-std()-Y    |   Present in original dataset. Refer section above.   |
14 | tGravityAcc-std()-Z    |   Present in original dataset. Refer section above.   |
15 | tBodyAccJerk-mean()-X    |   Present in original dataset. Refer section above.   |
16 | tBodyAccJerk-mean()-Y    |   Present in original dataset. Refer section above.   |
17 | tBodyAccJerk-mean()-Z    |   Present in original dataset. Refer section above.   |
18 | tBodyAccJerk-std()-X    |   Present in original dataset. Refer section above.   |
19 | tBodyAccJerk-std()-Y    |   Present in original dataset. Refer section above.   |
20 | tBodyAccJerk-std()-Z    |   Present in original dataset. Refer section above.   |
21 | tBodyGyro-mean()-X    |   Present in original dataset. Refer section above.   |
22 | tBodyGyro-mean()-Y    |   Present in original dataset. Refer section above.   |
23 | tBodyGyro-mean()-Z    |   Present in original dataset. Refer section above.   |
24 | tBodyGyro-std()-X    |   Present in original dataset. Refer section above.   |
25 | tBodyGyro-std()-Y    |   Present in original dataset. Refer section above.   |
26 | tBodyGyro-std()-Z    |   Present in original dataset. Refer section above.   |
27 | tBodyGyroJerk-mean()-X    |   Present in original dataset. Refer section above.   |
28 | tBodyGyroJerk-mean()-Y    |   Present in original dataset. Refer section above.   |
29 | tBodyGyroJerk-mean()-Z    |   Present in original dataset. Refer section above.   |
30 | tBodyGyroJerk-std()-X    |   Present in original dataset. Refer section above.   |
31 | tBodyGyroJerk-std()-Y    |   Present in original dataset. Refer section above.   |
32 | tBodyGyroJerk-std()-Z    |   Present in original dataset. Refer section above.   |
33 | tBodyAccMag-mean()    |   Present in original dataset. Refer section above.   |
34 | tBodyAccMag-std()    |   Present in original dataset. Refer section above.   |
35 | tGravityAccMag-mean()    |   Present in original dataset. Refer section above.   |
36 | tGravityAccMag-std()    |   Present in original dataset. Refer section above.   |
37 | tBodyAccJerkMag-mean()    |   Present in original dataset. Refer section above.   |
38 | tBodyAccJerkMag-std()    |   Present in original dataset. Refer section above.   |
39 | tBodyGyroMag-mean()    |   Present in original dataset. Refer section above.   |
40 | tBodyGyroMag-std()    |   Present in original dataset. Refer section above.   |
41 | tBodyGyroJerkMag-mean()    |   Present in original dataset. Refer section above.   |
42 | tBodyGyroJerkMag-std()    |   Present in original dataset. Refer section above.   |
43 | fBodyAcc-mean()-X    |   Present in original dataset. Refer section above.   |
44 | fBodyAcc-mean()-Y    |   Present in original dataset. Refer section above.   |
45 | fBodyAcc-mean()-Z    |   Present in original dataset. Refer section above.   |
46 | fBodyAcc-std()-X    |   Present in original dataset. Refer section above.   |
47 | fBodyAcc-std()-Y    |   Present in original dataset. Refer section above.   |
48 | fBodyAcc-std()-Z    |   Present in original dataset. Refer section above.   |
49 | fBodyAccJerk-mean()-X    |   Present in original dataset. Refer section above.   |
50 | fBodyAccJerk-mean()-Y    |   Present in original dataset. Refer section above.   |
51 | fBodyAccJerk-mean()-Z    |   Present in original dataset. Refer section above.   |
52 | fBodyAccJerk-std()-X    |   Present in original dataset. Refer section above.   |
53 | fBodyAccJerk-std()-Y    |   Present in original dataset. Refer section above.   |
54 | fBodyAccJerk-std()-Z    |   Present in original dataset. Refer section above.   |
55 | fBodyGyro-mean()-X    |   Present in original dataset. Refer section above.   |
56 | fBodyGyro-mean()-Y    |   Present in original dataset. Refer section above.   |
57 | fBodyGyro-mean()-Z    |   Present in original dataset. Refer section above.   |
58 | fBodyGyro-std()-X    |   Present in original dataset. Refer section above.   |
59 | fBodyGyro-std()-Y    |   Present in original dataset. Refer section above.   |
60 | fBodyGyro-std()-Z    |   Present in original dataset. Refer section above.   |
61 | fBodyAccMag-mean()    |   Present in original dataset. Refer section above.   |
62 | fBodyAccMag-std()    |   Present in original dataset. Refer section above.   |
63 | fBodyBodyAccJerkMag-mean()       |   Present in original dataset. Refer section above.   |
64 | fBodyBodyAccJerkMag-std()       |   Present in original dataset. Refer section above.   |
65 | fBodyBodyGyroMag-mean()       |   Present in original dataset. Refer section above.   |
66 | fBodyBodyGyroMag-std()        |   Present in original dataset. Refer section above.   |
67 | fBodyBodyGyroJerkMag-mean()      |   Present in original dataset. Refer section above.   |
68 | fBodyBodyGyroJerkMag-std()       |   Present in original dataset. Refer section above.   |







