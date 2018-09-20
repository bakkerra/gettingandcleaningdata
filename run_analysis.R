run_analysis<-function(){
##this function requires the UCI HAR dataset to be downloaded and unzipped in the wd
  
##load data set features
test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
train_x<-read.table("UCI HAR Dataset/train/X_train.txt")

test_y<-read.table("UCI HAR Dataset/test/y_test.txt")
train_y<-read.table("UCI HAR Dataset/train/y_train.txt")

subjects_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
subjects_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
  
##extract indices of mean and std features for data set
features<-read.table("UCI HAR Dataset/features.txt")
grep("-mean\\(",features[[2]])->meanindices
grep("-std\\(",features[[2]])->stdindices
indices<-c(meanindices,stdindices)

test_x_trim<-test_x[indices]
train_x_trim<-train_x[indices]

#Uses descriptive activity names to name the activities in the data set
combined_y<-rbind(train_y,test_y)
labeled_y<-as.character(combined_y[[1]])
gsub("1","walking",labeled_y)->labeled_y
gsub("2","walking_upstairs",labeled_y)->labeled_y
gsub("3","walking_downstairs",labeled_y)->labeled_y
gsub("4","sitting",labeled_y)->labeled_y 
gsub("5","standing",labeled_y)->labeled_y 
gsub("6","laying",labeled_y)->labeled_y 

##Merges the training and the test sets to create one data set.
combined_x<-rbind(train_x_trim,test_x_trim)
combined_subjects<-rbind(subjects_train,subjects_test)
activity_data_good<-cbind(combined_subjects,labeled_y,combined_x)

#Appropriately labels the data set with descriptive variable names.
names_features<-features[indices,]
namesoffeatures<-as.character(names_features[[2]])
namesoffeatures<-gsub("\\(\\)","",namesoffeatures)
namesoffeatures<-gsub("-","_",namesoffeatures)
tolower(namesoffeatures)->namesoffeatures
namesoffeatures<-gsub("^t","time_",namesoffeatures)
namesoffeatures<-gsub("^f","frequency_",namesoffeatures)
namesoffeatures<-gsub("acc","_accelerometer",namesoffeatures)
namesoffeatures<-gsub("gyro","_gyroscope",namesoffeatures)
namesoffeatures<-gsub("jerk","_jerk",namesoffeatures)
namesoffeatures<-gsub("mag","_magnitude",namesoffeatures)
names(activity_data_good)<-c("subject","activity",namesoffeatures)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
activity_summary<-tbl_df(activity_data_good)%>%
  group_by(activity,subject)%>%
  summarise_all(mean)

print(activity_summary)
}