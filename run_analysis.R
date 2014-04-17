
## Set working directory if needed
# setwd("YOUR_WORKING_DIRECTORY_PATH")


# 1. Merge the training and the test sets to create one data set.
x.test <- read.table("test/X_test.txt")
x.train <- read.table("train/X_train.txt")

## Check if there are any incomplete cases (uncomment if needed)
# length(complete.cases(x.test)) == nrow(x.test)
# length(complete.cases(x.train)) == nrow(x.train)

## Merge and free memory
## We can also add Subjects and Activities, but will do it later to optimize memory usage
x.all <- rbind(x.test, x.train)
rm(x.test)
rm(x.train)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

## Find all *mean() and *std() names
features <- read.table("features.txt", stringsAsFactors=FALSE)
features.mean.std <- features[grepl("mean\\(\\)|std\\(\\)", features[,2]),]
rm(features)

## do extraction
x.mean.std <- x.all[,features.mean.std$V1]

# 3. Use descriptive activity names to name the activities in the data set

## Read activity labels
activity.labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)

## Read activities and merge them
activities.test <- read.table("test/y_test.txt", stringsAsFactors=FALSE)
activities.train <- read.table("train/y_train.txt", stringsAsFactors=FALSE)
activities.all <- rbind(activities.test, activities.train)
rm(activities.test)
rm(activities.train)

## Substitute labels and merge them to main dataset
activities.all.labeled <- lapply(activities.all, function(x){activity.labels[x,2]} ) 
x.mean.std.activities <- cbind(activities.all.labeled, x.mean.std)

# 4. Appropriately label the data set with descriptive variable or feature (column) names 
names(x.mean.std.activities) <- c('Activity', features.mean.std$V2)

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Read subjects and merge them
subjects.test <- read.table("test/subject_test.txt", stringsAsFactors=FALSE)
subjects.train <- read.table("train/subject_train.txt", stringsAsFactors=FALSE)
subjects.all <- rbind(subjects.test, subjects.train)
rm(subjects.test)
rm(subjects.train)

## Merge with the main dataset and assign column name
x.complete <- cbind(subjects.all, x.mean.std.activities)
colnames(x.complete)[1] <- 'Subject'

## Create tidy data set with activity first, subject - second
x.complete.means <- aggregate(x.complete[3:68], by = x.complete[1:2], FUN=mean)
x.complete.means <- subset(x.complete.means, select=c(2,1,3:68))

## Apply new variable names
names(x.complete.means)[3:68] <- c(paste0(names(x.complete.means)[3:68], "-average"))
x.complete.means

## Uncomment this to save result data into file
# write.table(x.complete.means, file = "result.txt")
