# Code Book

This document describes the code inside `run_analysis.R`.

The code is splitted (by comments) in some sections:

* Download and unzip
* Read data from files
* Create data.table for final analysis
* Group by subject and activity
* Write to output file

## Download and unzip

In this part zip file is downloaded and uziped

## Read data from files

Necessary files are read into memory. Some basic operations are performed (like setting column names)

## Create data.table for final analysis

* Both test data ('testData') and train data ('trainData') were merged to 'mergedData'
* Subset of all rows and grouping columns together with mean and std columns is created ('mean_std_variables')

## Group by subject and activity

In this section the required operations are performed. The data is grouped by subject and activity. The mean value of all other variables is computed. Result is saved as 'avg_by_subject_activity'

## Write to output file

Creates the output csv file ('output.csv') in the working directory

# Units
Main units have not been changed. Mean value has been computed for each (subject, activity) group.
