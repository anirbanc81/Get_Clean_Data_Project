#setwd("F:/Coursera/Data Science/Getting and Cleaning Data/get_clean_data")
trainFileNames <- c("UCI HAR Dataset/train/subject_train.txt", "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/train/X_train.txt")
testFileNames <- c("UCI HAR Dataset/test/subject_test.txt", "UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/test/X_test.txt")
featuresFileName <- "UCI HAR Dataset/features.txt"
activityFileName <- "UCI HAR Dataset/activity_labels.txt"

filesFound <- file.exists(c(trainFileNames, testFileNames, featuresFileName, activityFileName))
if (length(filesFound[filesFound==FALSE]) == 0) {
    message(paste(Sys.time(), "- All inputs files found, data processing starting now..."))
    features <- read.table(featuresFileName)
    grep_idx <- grep("(mean|std)", features[,2], ignore.case=TRUE, value=FALSE)
    activities <- read.table(activityFileName)
    
    dfNames <- c("sub", "y", "x")
    
    for (i in 1:3)
    {
        assign(paste("train.", dfNames[i], sep=""), read.table(trainFileNames[i]))
        assign(paste("test.", dfNames[i], sep=""), read.table(testFileNames[i]))
    }
    
    train.x <- train.x[, grep_idx]
    test.x <- test.x[, grep_idx]
    
    train.y <- merge(train.y, activities, x.by=train.y[,1], y.by=activities[,1])
    test.y <- merge(test.y, activities, x.by=test.y[,1], y.by=activities[,1])
    
    train.final <- cbind(train.sub, train.y[,2], train.x)
    test.final <- cbind(test.sub, test.y[,2], test.x)

    message(paste(Sys.time(), "- Processing complete, merging all subsets and creating final output..."))
    names(test.final) <- names(train.final)
    data.all <- rbind(train.final, test.final)
    colnames(data.all) <- c("Subject_ID", "Activity", paste(features[grep_idx,2]))
    
    if(!require(reshape2, quietly=TRUE, warn.conflicts=FALSE)) {
        install.packages("reshape2")
    }
    library(reshape2)
    
    data.all.melt <- melt(data.all, id=1:2, measure.vars=3:ncol(data.all))
    tidy.data <- dcast(data.all.melt, Subject_ID + Activity ~ variable, mean)
    
    write.table(tidy.data, "Getting_Cleaning_Data_Project_OutData.txt", row.names=FALSE)
    message(paste(Sys.time(), " - Output written to file : ", getwd(), "/Getting_Cleaning_Data_Project_OutData.txt", sep=""))

    detach(package:reshape2)
    rm(trainFileNames, testFileNames, featuresFileName, activityFileName, filesFound)
    rm(features, grep_idx, activities, dfNames, i)
    rm(train.sub, train.y, train.x, test.sub, test.y, test.x, train.final, test.final)
    message(paste(Sys.time(), "- Removed all temp files and cleaned up workspace...Now exiting"))
    message("P.S.: Remember to use header=TRUE in read.table for the tidy data frame")
} else {
    errMessage <- ""
    if (length((filesFound[1:3])[filesFound[1:3]==FALSE]) > 0) errMessage <- "Please store all training data in your working dir in UCI HAR Dataset/train/\n"
    if (length((filesFound[4:6])[filesFound[4:6]==FALSE]) > 0) errMessage <- paste(errMessage, "Please store all test data in your working dir in UCI HAR Dataset/test/\n")
    if (filesFound[length(filesFound)-1] == FALSE) errMessage <- paste(errMessage, "Please store in your working dir the attribute file", featuresFileName, "\n")
    if (filesFound[length(filesFound)] == FALSE) errMessage <- paste(errMessage, "Please store in your working dir the activity labels file", activityFileName)
    rm(trainFileNames, testFileNames, featuresFileName, activityFileName, filesFound)
    stop(errMessage)
}