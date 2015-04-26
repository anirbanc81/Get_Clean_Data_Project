# Get_Clean_Data_Project
## Reading the output 
### Use this script
	submission.url <- "https://s3.amazonaws.com/coursera-uploads/user-8498ef78c2220901111899e4/973500/asst-3/e618a550ebcf11e4a4cc73af37a052a5.txt"
	submission.url <- sub("^https", "http", submission.url)
	tidy.data <- read.table(url(submission.url), header=TRUE)
	View(tidy.data)
## Understanding the output
- Identifier variables
	- Subject_ID - tidy.data[,1]
	- Activity - tidy.data[,2]
- Measure variables : all other columns in tidy.data, tidy.data\[,3:ncol(tidy.data)\] (refer to the Codebook.md file for details)

## Understanding the run_analysis.R script
- lines 2:7 check for the existence of all the necessary input files (train and test data, features file, and activity labels)
- rest of the code is split on line 8 - if all files are found, processing continues; else missing files are pointed out and execution terminates
- lines 10:11 read the features file and gets the vector of indices of all the features containing "mean" or "std" using the <b>grep</b> function from the <b>base</b> package
- lines 12:20 read in all other required data
- lines 22:23 extract all the "mean" or "std" columns from the ".x" data sets using the indices vector from line 11
- lines 25:26 map the detailed activity name (from the activity labels file) to the ".y" data sets using the <b>merge</b> function from the <b>base</b> package
- lines 28:34 create the completed joined data set (from the train and test data) with subject number, activity name and the mean/std columns and provides descriptive names for the columns
- lines 36:42 create the final tidy.data data set using the <b>melt</b> and <b>dcast</b> functions from the <b>reshape2</b> package
- line 44 writes the tidy.data data set out as a txt file with row.names=FALSE
- lines 47:52 clean up all temp variables and keeps only 3 data sets in the current env : data.all, data.all.melt, and tidy.data
- lines 53:61 handle the case of when one or more of the required inputs files are not found, and exits execution gracefully
