# Getting And Cleaning Data

## Introduction

This repo contains my project for 'Getting and Cleaning Data' course in Coursera.

The script called `run_analysis.R` contains all functions and code to do the following:

1. Download UCI HAR zip file and unzip in into './UCI HAR Dataset' directory
2. Read data
3. Do some transformations
4. Write output data to a CSV file inside working directory.

The `CodeBook.md` provides more information about the script itself.


## Run from command line

1. Clone this repo
2. Run the script:

       $ Rscript run_analysis.R

3. Look for the final dataset at `./output.csv`

       $ head -3 output.csv