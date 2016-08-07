---
title: "Codebook"
author: "TonyHW"
date: "August 6, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Codebook (run_analysis)

## Environment preparation

Deals with installation & loading of required packages, as well as working directory setups, so that the unzipped files in the "./data" folder can be read. (The download and folder creation process is skipped if a "./data" folder is detected within the working directory)

* Installs the necessary packages & loads them into the environment: "dplyr" and "plyr"
* Saves the original working directory path in the object Originalwd
* Downloads & set the working directory to where the data is extracted "./data"
* Temporarily sets the newly created folder to be the working directory "./data"

## Data reading & individual objects creation

If a "./data" folder is detected in the working directory, the code assumes the required data had already been downloaded, and sets the working directory to the "./data" folder to read the extracted data.

* Read the training data set:
    train_subject_id, train_x, train_y
    train_subject_id; contains a unique ID number that is used to identify individual subjects
    train_x; contains the training set data
    train_y; contains the types of activity conducted for a particular training subject
* Read the test data set:
    test_subject_id, test_x, test_y
        test_subject_id; contains a unique ID number that is used to identify individual subjects
    test_x; contains test set data
    test_y; contains the types of activity conducted for a particular test subject

## Data combining between the test & training data set

Combines each the training, and test data into two separate dataframe objects (trainingData & testData), and merges them together into the "combinedData" data set. Removes objects that are no longer necessary at the end of this step, and sets the working directory back to the path stored in Originalwd object

* trainingData & testData created by combining each of the "subject_ID", "test/train_x", and "test/train_y" together
* Combines the trainingData & testData together into a single data set
* Rename the variable name "Subject_ID", and "test_train_y", and labels the 561 activities according to the "features" data set
* Remove the data sets that are no longer necessary in the environment (test_subject_ID,test_x,test_y,train_subject_ID,train_x,train_y,testData,trainingData)
* Sets the working directory back to Originalwd

## Extracts the mean & standard deviation column. 

Merges the mean and standard deviation values into a more compact table. Also renames the activities for easier reading by replacing integer-coded activity names with their actual activity names, and by using a label's full name rather than its shortened version.

* Chooses and stores the relevant column, by selecting those columns whose name contains the string "mean" and "std" (standard deviation)
* Rename the test_train_y column, from integers 1 to 6, into descriptive activity names, e.g: "walking", "sitting", "standing"
* Rename the variable names, removes shortened variable names, and substitutes them with their full names, e.g: "Acc" to "Accelerometer"

## Final Summary & Data Exporting

Takes the mean average of each variable for each activity and each subjects. Followed by exporting the resulting data to the "tidydata.txt"" file. Also added the View(tidydata) line to allow for immediate visual checking in R.

* summarise_each() to the grouped data, and stores its results in an object called tidydata
* exports the resulting tidydata file to the "tidydata.txt"
* views the resulting tidydata file in the R-Studio Environment