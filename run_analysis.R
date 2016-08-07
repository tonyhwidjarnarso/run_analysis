# Peer reviewed project - run_analysis.R

# 1.Installs the necessary packages & loads them into the environment
# Downloads & set the working directory to where the data is extracted
# Creates a "data" folder within the working directory and sets the newly
# created folder to be the working directory
# -----------------------------------------------------------------------------------------
install.packages(dplyr);install.packages(plyr)
library(dplyr);library(plyr)
Originalwd<-getwd()

if(!file.exists("./data")){
    dir.create("./data")
URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,"./data/Human_Activity_Recognition.zip")
unzip("./data/Human_Activity_Recognition.zip",junkpaths = TRUE,exdir = "./data")
setwd("./data")

}

# 2.Temporarily set the wd to the "./data" folder 
# Reads all the required variables into the environment, before
# switching back to the original wd, where the source file is located
# -----------------------------------------------------------------------------------------
setwd("./data")

features <- read.table("features.txt",
                       col.names = c("FeatureID","FeatureName"),stringsAsFactors = FALSE)

# Read the training data set, and loads them into R
train_subject_ID<-read.table("subject_train.txt")
train_x<-read.table("X_train.txt")
train_y<-read.table("y_train.txt")

# Read the test data set, and loads them into R
test_subject_ID<-read.table("subject_test.txt")
test_x<-read.table("X_test.txt")
test_y<-read.table("y_test.txt")

# 3.Combine the test data & training data together, first to a separate 
# dataframe then together in "combinedData". Cleans up the environment 
# by removing objects that are no longer necessary.
# -----------------------------------------------------------------------------------------

testData <- data.frame(test_subject_ID,test_y,test_x)
trainingData <- data.frame(train_subject_ID,train_y,train_x)
combinedData<-rbind(testData,trainingData)

colnames(combinedData) <- c("subject_ID","test_train_y",features[,2])

# removes objects that are no longer necessary
rm(test_subject_ID,test_x,test_y,train_subject_ID,train_x,train_y
   ,testData,trainingData)

# Sets the working directory back to where the source file is
setwd(Originalwd)

# 4.Extracts the necessary column (mean & standard deviation) from 
# the merged column into the "Extracted object". Renames the activity
# and column variables for ease of reading
# -----------------------------------------------------------------------------------------

Extracted<-combinedData[,grep("test/train|subject_ID|test_train_y|mean|std",
                              colnames(combinedData))]
# Renames the activity column
Activitylabel<-Extracted$test_train_y; id<-1:length(Activitylabel)
Activity <- vector()
for (i in id){
    temp<-Activitylabel[i]
    if (temp == 1){z = "Walking"}
    else if (temp == 2){z = "Walking Upstairs"}
    else if (temp == 3){z = "Walking Downstairs"}
    else if (temp == 4){z = "Sitting"}
    else if (temp == 5){z = "Standing"}
    else if (temp == 6){z = "Laying"}
    Activity<-c(Activity,z)
}
rm(z,i,id,temp,Activitylabel)
Extracted$test_train_y<-Activity

# Rename the variable / column names for better readability
names(Extracted) <-gsub("Acc"," Accelerometer",names(Extracted))
names(Extracted) <-gsub("Gyro"," Gyrometer",names(Extracted))
names(Extracted) <-gsub("^fBody","Frequency ",names(Extracted))
names(Extracted) <-gsub("Mag","Magnitude ",names(Extracted))
names(Extracted) <-gsub("^tBody","Time ",names(Extracted))
names(Extracted)[2] <- "Activity"

# 5. Takes the mean average of each variable for each activity 
# & each subject. Exports the resulting data to the "tidydata.txt" file
# in the working directory
# -----------------------------------------------------------------------------------------

tidydata<-summarise_each(group_by(Extracted,Activity,subject_ID),funs(mean))
write.table(tidydata,"tidydata.txt",row.names = FALSE)
View(tidydata)
setwd(Originalwd)