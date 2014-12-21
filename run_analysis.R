if(!file.exists("./assignment")){dir.create("./assignment")}

# Read all the required files
activity<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/activity_labels.txt")
feature<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/features.txt")
featurename=feature[,2]
## Read the subject id's of the training and testing data

subjecttrain<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/train/subject_train.txt")
colnames(subjecttrain)<-"subject_id"
subjecttest<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/test/subject_test.txt")
colnames(subjecttest)<-"subject_id"

## Read the activity id's of the training and testing data
train<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/train/y_train.txt")
colnames(train)<-"activity_id"
test<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/test/y_test.txt")
colnames(test)<-"activity_id"

## Read the data set of the training and testing data
traindata<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/train/X_train.txt")
colnames(traindata) <- featurename
testdata<- read.table("C:/2014/Coursera/Clean data/UCI HAR Dataset/test/X_test.txt")
colnames(testdata) <- featurename
## 1. Merges the training and the test sets to create one data set.

#combine train subject id, actity id with data
traindataset<-cbind(subjecttrain,train,traindata)

#combine test subject id, actity id with data
testdataset<-cbind(subjecttest,test,testdata)

#Make a single data set for training and testing
dataset<-rbind(traindataset,testdataset)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

extractedmean<-dataset[,grep("mean",names(dataset))]
extractedstd<-dataset[,grep("std",names(dataset))]
extractmeanstd<-cbind(dataset[,c("subject_id" ,"activity_id")],extractedmean,extractedstd)


# 3. Uses descriptive activity names to name the activities in the data set

# assign names to activity column
colnames(activity)<-c("activity_id","actvity")
# merge with activity names
final_data<-merge( activity, extractmeanstd, by.x = "activity_id", by.y = "activity_id", all = TRUE)

# 4. Appropriately labels the data set with descriptive variable names.

#final_data<-final_data[-1]
names(final_data) <- gsub("-()","", names(final_data), perl = TRUE)
write.table(final_data,"C:/2014/Coursera/Clean data/UCI HAR Dataset/Merged_data.txt")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
X<-final_data[,3:dim(final_data)[2]]
X<-aggregate(X, list(final_data$activity_id,final_data$subject_id),"mean")
names(X)[1] <- c('activity')
X<-X[-2]
write.table(X,"C:/2014/Coursera/Clean data/UCI HAR Dataset/test/Reduced_data.txt")



