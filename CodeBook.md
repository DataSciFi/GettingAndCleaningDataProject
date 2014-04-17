Code Book
=============================

This is an Code Book for the "Getting And Cleaning Data" course project at Coursera.org. The purpose of this project is to demonstrate collection, working with, and cleaning of a data set using the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Initial data set
-------------------------
All thorough details are provided at [Human Activity Recognition Using Smartphones Data Set Page](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) as of 2014-04-18

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. 

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. Preprocessing was done and the result data (we are interested in) consists of:

1. Sensors time domain signals, their FFT and a set of estimated variables like mean (suffix __mean()__), standard deviation (suffix __std()__), etc 
1. List of types of activities - WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
1. Lists of participants IDs for each case in the signals data set

Data Processing
-------------------------

### Merge the training and the test sets to create one data set 
```{r}
x.test <- read.table("test/X_test.txt")
x.train <- read.table("train/X_train.txt")
```

We can also add Subjects and Activities, but will do it later to optimize memory usage

```{r}
x.all <- rbind(x.test, x.train)
```

### Extract only the measurements on the mean and standard deviation for each measurement

Find all *mean() and *std() names and do extraction

```{r}
features <- read.table("features.txt", stringsAsFactors=FALSE)
features.mean.std <- features[grepl("mean\\(\\)|std\\(\\)", features[,2]),]
x.mean.std <- x.all[,features.mean.std$V1]
```
### Use descriptive activity names to name the activities in the data set

Read activity labels
```{r}
activity.labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
```

Read activities and merge them
```{r}
activities.test <- read.table("test/y_test.txt", stringsAsFactors=FALSE)
activities.train <- read.table("train/y_train.txt", stringsAsFactors=FALSE)
activities.all <- rbind(activities.test, activities.train)
```
Substitute labels and merge them to main dataset
```{r}
activities.all.labeled <- lapply(activities.all, function(x){activity.labels[x,2]} ) 
x.mean.std.activities <- cbind(activities.all.labeled, x.mean.std)
```

### Appropriately label the data set with descriptive variable or feature (column) names 
```{r}
names(x.mean.std.activities) <- c('Activity', features.mean.std$V2)
```

### Create a second, independent tidy data set with the average of each variable for each activity and each subject

Read subjects and merge them
```{r}
subjects.test <- read.table("test/subject_test.txt", stringsAsFactors=FALSE)
subjects.train <- read.table("train/subject_train.txt", stringsAsFactors=FALSE)
subjects.all <- rbind(subjects.test, subjects.train)
```

Merge with the main dataset and assign column name
```{r}
x.complete <- cbind(subjects.all, x.mean.std.activities)
colnames(x.complete)[1] <- 'Subject'
```

Create tidy data set with activity first, subject - second
```{r}
x.complete.means <- aggregate(x.complete[3:68], by = x.complete[1:2], FUN=mean)
x.complete.means <- subset(x.complete.means, select=c(2,1,3:68))
```
Apply new variable names
```{r}
names(x.complete.means)[3:68] <- c(paste0(names(x.complete.means)[3:68], "-average"))
```

Output Tidy Data Set
-------------------------
Output data set consists of 180 cases of 68 variables: __Activity__ (activity type), __Subject__ (Subject ID) and 66 variables (result averages) named in a format __INITIAL_NAME-average__ . All initial variable names are described in initial data set features_info.txt code book. Output data set is ordered by __Activity__ and then by __Subject__.

