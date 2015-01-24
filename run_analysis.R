#before running the script, make sure you are in the working directory
# setwd("../Projects/RTests/")
#-----------------------------

library(data.table)
library(dplyr)
library(utils)

#------------------------------------
#   Download and unzip
#------------------------------------
#set some constans
uciHarUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
uciHarZipfile <- "./uci_har_dataset.zip"

#download the zip archive
download.file(uciHarUrl, uciHarZipfile, method = "auto")

#unzip the archive
unzip(zipfile = uciHarZipfile,exdir =".",overwrite = T)

#------------------------------------
#   Read data from files
#------------------------------------


#Read column names
colNames<- read.table(file="./UCI HAR Dataset/features.txt", header=F,sep = " ",stringsAsFactors=FALSE)

#Update names - remove brackets, replace minus and coma
colNames[[2]]<-gsub("-|,", "_", colNames[[2]])
colNames[[2]]<-gsub("\\(|\\)", "", colNames[[2]])


#Read X_TEST data file
x_test_df<-read.fwf(file = "./UCI HAR Dataset/test/X_test.txt",
                    buffersize = 50,
                    widths = rep(16,561),
                    header = F,
                    skip = 0,
                    sep="")

# Convert to data.table
testData<-as.data.table(x_test_df)

#remove old data.frame
rm(x_test_df)

#set column names for the data.table
setnames(testData,colNames[[2]])

#Read activity codes and bind it with testData
activityCodes<-read.table(file="./UCI HAR Dataset/test/Y_test.txt",
                          header = F,
                          skip = 0,
                          sep="")

activityCodes<-as.list(activityCodes)
testData[,activity:=as.integer(activityCodes[[1]])]

#read subject codes for test data and bind it with testData
subjectTest<-read.table(file="./UCI HAR Dataset/test/subject_test.txt",
                        header = F,
                        skip = 0,
                        sep=" ")

subjectTest<-as.list(subjectTest)
testData[,subject:=as.integer(subjectTest[[1]])]


#Read train data
x_train_df<-read.fwf(file = "./UCI HAR Dataset/train/X_train.txt",
                     buffersize = 50,
                     widths = rep(16,561),
                     header = F,
                     skip = 0,
                     sep="")

#convert to data.table
trainData<-as.data.table(x_train_df)

#remove old data.frame
rm(x_train_df)

#set column names for train data
setnames(trainData,colNames[[2]])

#read activity codes for train data and bind it with trainData
activityCodes<-read.table(file="./UCI HAR Dataset/train/Y_train.txt",
                          header = F,
                          skip = 0,
                          sep="")
activityCodes<-as.list(activityCodes)
trainData[,activity:=as.integer(activityCodes[[1]])]

#read subject codes for train data and bind it with trainData
subjectTrain<-read.table(file="./UCI HAR Dataset/train/subject_train.txt",
                         header = F,
                         skip = 0,
                         sep=" ")
subjectTrain<-as.list(subjectTrain)
trainData[,subject:=subjectTrain[[1]]]


#read dictionary for activity codes
activityNames<-read.table(file="./UCI HAR Dataset/activity_labels.txt",
                          header = F,
                          skip = 0,
                          sep=" ")
activityNames[[1]]<-as.integer(activityNames[[1]])

#---------------------------------------
# create data.table for final analysis
#---------------------------------------

#merge both data.tables
mergedData<-rbind(testData,trainData)

#pick indices of column names that fulfill the grep filter condition
idc<-unique(grep("_mean|_std|activity|subject",names(mergedData),ignore.case = T))

#create a subset of mergedData with picked indices
mean_std_variables<-mergedData[,idc, with=F]

#set factor labels for activityNames
mean_std_variables[,activity:=factor(mean_std_variables$activity, levels=activityNames[[1]], labels=activityNames[[2]])]

#-----------------------------------
# group by subject and activity
#-----------------------------------

#group by subject and activity, compute mean value for all other columns
avg_by_subject_activity<- mean_std_variables[, lapply(.SD,mean), by=eval(colnames(mean_std_variables)[80:81])]

#-----------------------------------
# write to output file
#-----------------------------------

#write output to file
write.table(x = avg_by_subject_activity, file = "output.csv",append = F,row.names = F,col.names = T, sep=",") 

