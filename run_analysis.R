## Program:  run_analysis.R
## Author:   palindrome11@github.ccom
## Date:     Feb 13, 2016

#
#Two tables are returned after this program is run:
#       1. full_data_p  - This dataset represents all of the sample data as described below for both the train and the test groups
#       merged together. See below and the referenced docuements below for the details.
#       2. fdpa - This dataset represents the sum of all the means and std deviations for each of the subjects and their individual 
#       activities.
#
#       View the datasets with the View command ... View(full_data_p) View(fdpa)
#
#
#This program loads and merges the two data sets "test" and "train" collected from the sampling of accelerometer 
#and gyroscope 3-axial raw signals  as described in the file features_info.txt from the data descriptions found 
#here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
#
#A new dataset, called full_data_p is returned which includes only the meassurments for mean and standard deviation from the various
#x-y-z spatial samplings collected. 
#
#The selected fields can be reviewed in the function 'processTable()' below. 
#The processTable functions also relabels the fields so they are more meaningful to the analyst. The names are taken from 
#the field deinfintions obtained from the features.txt file that comes with the above referenced data set.
#
#This program also converts the numeric designations for the various activities being measured into the more easily understood 
#WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING verbs descriving the actual mesured activities,
#
#The program also adds the field 'dataset' to the merged version which tracks whether the subject's data was collected as
#the test data or the train data orginally.
#
#Finally the program merges the subject IDs (1-30) for each of the records that were collected.

options(warn=-1)

#Libraries
library(data.table)
library(dplyr)
library(tidyr)
library(gdata)  #drop.levels
library(reshape2)

### Functions

#Function to select the fields and name the fields with meaningful names for the data sets.
processTable <- function(data) {
        
        data_p <- select(data, subject,activity,V1,V2,V3,V4,V5,V6,V41,V42,V43,V44,V45,V46,V81,V82,V83,V84,V85,V86,
                         V121,V122,V123,V124,V125,V126,V161,V162,V163,V164,V165,V166,V201,V202,
                         V214,V215,V227,V228,V240,V241,V253,V254,V266,V267,V268,V269,V270,V271,
                         V345,V346,V347,V348,V349,V350,V424,V425,V426,V427,V428,V429,V503,V504,
                         V516,V517,V529,V530,V542,V543)

        #Rename fields to names that are more intuitively recognizeable and can be understood using the Codebook.
        data_p <-rename(data_p, 
                        #Time Domain - Time Body Acceleration
                        tBodyAccelMean_X=V1,
                        tBodyAccelMean_Y=V2,
                        tBodyAccelMean_Z=V3,
                        tBodyAccelStd_X=V4,
                        tBodyAccelStd_Y=V5,
                        tBodyAccelStd_Z=V6,
                        #Time Domain - Time Gravity Acceleration
                        tGravityAccelMean_X=V41,
                        tGravityAccelMean_Y=V42,
                        tGravityAccelMean_Z=V43,
                        tGravityAccelStd_X=V44,
                        tGravityAccelStd_Y=V45,
                        tGravityAccelStd_Z=V46,
                        #Time Domain - Accleration Jerk Component
                        tBodyAccelJerkMean_X=V81,
                        tBodyAccelJerkMean_Y=V82,
                        tBodyAccelJerkMean_Z=V83,
                        tBodyAccelJerkStd_X=V84,
                        tBodyAccelJerkStd_Y=V85,
                        tBodyAccelJerkStd_Z=V86,
                        #Time Domain - Gyro Component
                        tBodyGyroMean_X=V121,
                        tBodyGyroMean_Y=V122,
                        tBodyGyroMean_Z=V123,
                        tBodyGyroStd_X=V124,
                        tBodyGyroStd_Y=V125,
                        tBodyGyroStd_Z=V126,
                        #Time Domain - Gyro Jerk Component
                        tBodyGyroJerkMean_X=V161,
                        tBodyGyroJerkMean_Y=V162,
                        tBodyGyroJerkMean_Z=V163,
                        tBodyGyroJerkStd_X=V164,
                        tBodyGyroJerkStd_Y=V165,
                        tBodyGyroJerkStd_Z=V166,
                        #Time Domain (TD) Magnitude Calculations(Using Euclidian Norm)
                        ##TD Body Acceleration Magnitude
                        tBodyAccelMagMean=V201,
                        tBodyAccelMagStd=V202,
                        ##TD Gravity Acceleration Magnitude
                        tGravityAccelMagMean=V214,
                        tGravityAccelMagStd=V215,
                        ##TD Body Acceleration Jerk Magnitude
                        tBodyAccelJerkMagMean=V227,
                        tBodyAccelJerkMagStd=V228,
                        ##TD Body Gyro Magnitude
                        tBodyGyroMagMean=V240,
                        tBodyGyroMagStd=V241,
                        ##TD Body Gyro Jerk Magnitude
                        tBodyGyroJerkMagMean=V253,
                        tBodyGyroJerkMagStd=V254,
                        #Frequency Domain - Body Acceleration
                        fBodyAccelMean_X=V266,
                        fBodyAccelMean_Y=V267,
                        fBodyAccelmean_Z=V268,
                        fBodyAccelStd_X=V269,
                        fBodyAccelStd_Y=V270,
                        fBodyAccelStd_Z=V271,
                        #Frequency Domain - Body Acceleration Jerk
                        fBodyAccelJerkMean_X=V345,
                        fBodyAccelJerkMean_Y=V346,
                        fBodyAccelJerkMean_Z=V347,
                        fBodyAccelJerkStd_X=V348,
                        fBodyAccelJerkStd_Y=V349,
                        fBodyAccelJerkStd_Z=V350,
                        #Frequency Domain - Gyroscopic Component 
                        fBodyGyroMean_X=V424,
                        fBodyGyroMean_Y=V425,
                        fBodyGyroMean_Z=V426,
                        fBodyGyroStd_X=V427,
                        fBodyGyroStd_Y=V428,
                        fBodyGyroStd_Z=V429,
                        #Frequency Domain (FD) Magnitude Calculations(Using Euclidian Norm)
                        ##FD Body Acceleration Magnitude
                        fBodyAccelMagMean=V503,
                        fBodyAccelMagStd=V504,
                        ##FD Body Acceleration Jerk
                        fBodyBodyAccelJerkMagMean=V516,
                        fBodyBodyAccelJerkMagStd=V517,
                        ##FD Body Gyro Magnitude 
                        fBodyBodyGyroMagMean=V529,
                        fBodyBodyGyroMagStd=V530,
                        ##FD Body Gyro Jerk Magnitude
                        fBodyBodyGyroJerkMagMean=V542,
                        fBodyBodyGyroJerkMagStd=V543
                        
        )
        return(data_p)
        
}

#Function to changel levels to more meaningful representation based on levels
#   Level Activity
#       1 WALKING
#       2 WALKING_UPSTAIRS
#       3 WALKING_DOWNSTAIRS
#       4 SITTING
#       5 STANDING
#       6 LAYING
#
change_levels <- function(data_p) {
        levels(data_p$activity)[1] <- "WALKING"
        levels(data_p$activity)[2] <- "WALKING_UPSTAIRS"
        levels(data_p$activity)[3] <- "WALKING_DOWNSTAIRS"
        levels(data_p$activity)[4] <- "SITTING"
        levels(data_p$activity)[5] <- "STANDING"
        levels(data_p$activity)[6] <- "LAYING"
        
        return(data_p)

}

#Function to process a subset of the data and sum the means for all the variables.
#This returns a numeric vector with the summed means for each variable
process_means <- function(sdata){
        
        find.numeric<-sapply(sdata, is.numeric)
        subrec <- colMeans(sdata[,find.numeric])
        return(subrec)
}

#============  Load Data Files  ==========

#Path to => Data Files for the test and training groups... These contain the accelermometer and gyroscopic measurements
#and the various derived values from the collected data points.
test_data_fn <- "./data/UCI HAR Dataset/test/X_test.txt"
train_data_fn <- "./data/UCI HAR Dataset/train/X_train.txt"

#Path to => Subject File.... These files (one for the test group and the other for the training group) contain references (1-30)
#that correspond to the 30 test participants. The numbers 1-30 correspond to the subjects and they are randomly assigned 
#to either the test or training group. These files contain a number designating the participant for each row in the data 
#file(s) above. 
test_subject_fn <- "./data/UCI HAR Dataset/test/subject_test.txt"
train_subject_fn <- "./data/UCI HAR Dataset/train/subject_train.txt"

#Path to => Activity File.... These files (one for the test group and the other for the training group) contain references to 
#the measured activities.
test_activity_fn <- "./data/UCI HAR Dataset/test/y_test.txt"
train_activity_fn <- "./data/UCI HAR Dataset/train/y_train.txt"

#============ Load Data Structures   ===================

#Read in the data files to table stuctures for for management and processing with table manipulation packages,
test_data <- fread(test_data_fn)
train_data <- fread(train_data_fn)

#Read in the activity files 
test_activity <- factor(readLines(test_activity_fn))
train_activity <- factor(readLines(train_activity_fn))


#Read in the subject files to factor vectors. Using factor vectors so I can easily change the names of the values to make them
#more user friendly later.
test_subject <- factor(readLines(test_subject_fn))  #read in as factors in order to validate levels and rows
train_subject <- factor(readLines(train_subject_fn)) #read in as factors in order to validate levels and rows

#Read in the activity files to factor vectors
test_activity <- factor(readLines(test_activity_fn))
train_activity <- factor(readLines(train_activity_fn))

#Drop the levels from the factor renditions in order to allow an easy add as columns to the main data files
test_subject <-drop.levels(test_subject) #drop levels from test_subject
test_activity <-drop.levels(test_activity) #drop levels from test_activity

#Add subject records and activity records to the two datafiles (test and train)
test_data$subject <- test_subject #add the subject records to the test_data frame....
test_data$activity <- test_activity #add the activity records to the test_data frame....
train_data$subject <- train_subject #add the subject records to the test_data frame....
train_data$activity <- train_activity #add the activity records to the test_data frame....




#============ Select the fields of interest for the analysis  ============
test_data_p <- processTable(test_data)          # test data
train_data_p <-processTable(train_data)         # train data 

#Add a field as a flag to designate whether it is test data or train data. This could be used after the merge
#to differentiate the sets.

test_data_p <- mutate(test_data_p, dataset = "Test" )
train_data_p <- mutate(train_data_p, dataset = "Train")

#Join the Data Tables
full_data_p <- suppressMessages(full_join(test_data_p,train_data_p))

#Change the levels of the Activity column to make them more easily understood
full_data_p <- change_levels(full_data_p)

#Create a separate dataset with the average of each variable for each activity and each subject.
max_subjects <- max(as.numeric(full_data_p$subject)) #How many participants.. loop through each on up to max_subjects
fdpa<- full_data_p[0,] #clone the structure of the dataframe
for(i in 1:max_subjects) {
        for(j in 1:length(levels(full_data_p$activity))) {  #For each subject loop thorugh each of his/her activities
                asub <- filter(full_data_p, subject==i, activity==levels(full_data_p$activity)[j])
                new_rec <- process_means(asub) #pass to the process means to get a numeric vector with all means summed for each activity
                a.tm <- t(new_rec) #transpose the row names to columns from the numeric vector
                a.tmd <- data.table(a.tm) #Make this a data.table so we can merge the data into rows for each sum
                fdpa <- rbind(fdpa, a.tmd, fill=TRUE) # here is the bind to add the sums to a table
                fdpa[nrow(fdpa),1]=i #Mark the record with the participant ID
                fdpa[nrow(fdpa),2]=j #Mark the record wit the participant activity
        }
} 



