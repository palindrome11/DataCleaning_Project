# Data Cleaning Project

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. This is the final project in the 
Coursera 'Getting and Cleaning Data' course.

##Overview

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

There is one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Specifics 

The data for this implementaion included with this repository in the Data Subdirectory. Also, in this subdirectory are the support files and the description files from the original project.

The utility program (run_analysis.R) is designed to work with the data as it lays out in the subdirectory structure under ./data. If a different structure is needed, then the file paths in the program will need to be updated under the code block defined as "=========Load Data Files=========".

The Codebook for this implementation is called p11_CodeBook.txt and is available in the main directory of this repo. The data fields described in the codebook are directly taken as a subset from the original names assigned in the file features.txt from the original project mentioned above. The fields being subsetted here are strictly the mean and standard deviation data points for the motion time domain measurements in 3 dimensions (x,y,z) and the Fourier transforms of these various measurements recorded in the experiment. 

The subjects (1-30) and the activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) are recorded along with the source of the measurements as being from the "train" or "test" data groupings).

There is one utility program called "run_analysis.R" that returns two datasets as follows:

- 1. full_data_p  - This dataset represents all of the sample data as described below for both the train and the test groups merged together. 
- 2. fdpa - This dataset represents the sum of all the means and std deviations for each of the subjects and their individual activities.

View the datasets in RStudio with the View commands ... 
- View(full_data_p) 
- View(fdpa)



