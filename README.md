# Tidy_assignment

EXPLANATION OF "run_analysis.R":

What the code in the file "run_analysis.R" does is fulfill the Week 4 Getting and Cleaning Data Coursera assignment.

First the training and test sets are loaded into R. Then the subjects and the activities.
This is done using read.table( ). 
The column names are taken from the "features.txt" file.

When everything is loaded, the data sets are merged appropriately. 

Then, the variable names containing "mean()" or "std()" are identified. A new data set is extracted containing only the
measurements on the mean and standard deviation, as well as the identifiers on activity and subject.

The next step is to substitute the activity numbers by activity names, which is done using sapply.

Lastly, dplyr package is loaded to group the data by subject and activities and summarize all other variables according 
to their mean.

The resulting data set is returned.

