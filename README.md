# gettingandcleaningdata
Class Project for Getting and Cleaning Data

# Getting and Cleaning Data Final Project
## Rachael Bakker

The project goal was to generate a tidy data set from the UCI Activity Dataset.

## Included files:
  * **ReadMe.md**
  * **activity_summary.txt**  A tidy data set
  * **run_analysis.R**  Function that can reproduce my data set, provided the original unzipped data folder is in the working directory
  * **codebook.md**: A written description of the data and my process to obtain the tidy data set

To read activity_summary.txt into R, use the following command:
```r
activity_summary<-read.table("activity_summary.txt")
```
To reproduce this data set:
```r
source('run_analysis.R')
activity_summary<-run_analysis()
```

# Why is this data tidy?

1. Each observation in one row
  * One row = one activity, one subject, and their average measurement for every feature 
2. Each variable in one column
  * Every column is a unique attribute of the observation:  activity, subject (indicated by a number), and each feature
3. One table for each kind of variable
  * We were asked to deliver only one table of tidy data for the assignment in my understanding of the instructions.
4. Descriptive variable names
  * The names of each feature were changed to include less abbreviations.  Characters such as "-" and "()" that might confuse R were removed in order to make working with the column names easy.
  * Activities were changed from a number code in the raw data to a description
5. One file/table
This table is a single file

# How did I fulfill the requirements?

1. Merge training and test sets
  * I used rbind() to combine the training and test sets vertically for each component: subject, activity, and features
  Then I used cbind() to combine subject, activity and features horizontally.
2. Extract mean and standard deviation
  * I used grep() on a list of the feature names to find the index numbers for features that contained the characters "mean()" or "std()"
  Prior to merging the data, I subsetted the feature data to included only columns with these index numbers. 
3. Include descriptive activity names
  * Prior to merging the data, I used gsub() to find and replace the numbers in the activity dataset with corresponding descriptors.  
4. Include appropriate variable names 
  * I used gsub() on the list of feature names (subsetted to include only mean and std) in order to:
      * Remove problematic characters such as "()" and "-"
      * Change abbreviations to full words and separate them with underscores
      * Change everything to lower case to prevent confusion
5. Make new data set with average of each variable for each activity and subject 
  * I used dplyr to make a grouped table by activity and subject, I then used the summaize_each function to give a mean for every other       column in the data frame.
