##

library(dplyr)

####
# First download the archive .rar, later extract the data of archive.
###

# Read data of test and train
X_test<-read.csv("UCI HAR Dataset/test/X_test.txt",header = F,sep = "")
X_train<-read.csv("UCI HAR Dataset/train/X_train.txt",header = F,sep = "")

Y_test<-read.csv("UCI HAR Dataset/test/Y_test.txt",header = F,sep = "")
Y_train<-read.csv("UCI HAR Dataset/train/Y_train.txt",header = F,sep = "")

subject_test<-read.csv("UCI HAR Dataset/test/subject_test.txt",header = F,sep = "")
subject_train<-read.csv("UCI HAR Dataset/train/subject_train.txt",header = F,sep = "")


# bind data
test_total<-cbind(subject_test,Y_test,X_test)
train_total<-cbind(subject_train,Y_train,X_train)

# Remove data becouse not use
rm(X_test,X_train,Y_test,Y_train,subject_test,subject_train)

# merge data
Total<-rbind(train_total,test_total)

# Read labels
Etiquetas<-read.csv("UCI HAR Dataset/features.txt",sep = "",header = F)
Etiquetas<-Etiquetas[,2]

# add ID and activity to the labels
Etiquetas<-rbind(c("ID","Actividad",Etiquetas))

# Put labels to the data
names(Total)<-Etiquetas

# select labels of mean y std
col_mean<-grep("mean",names(Total))
col_std<-grep("std",names(Total))


# 1 and 2 is "ID" and "Actividad"
Total<-Total[,c(1,2,col_mean,col_std)]

# add "Activity_labels"
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
Total$Actividad<-factor(Total$Actividad,levels = activity_labels$V1,
                        labels = activity_labels$V2)

View(Total) 

### 4th finished
#write.table(Total,file = "data_4th_step.txt",row.names = FALSE)
##


########

# 5 step: creates a second data

# select labels of only mean and std
col_alone_mean<-grep("mean()",names(Total),fixed =T )
col_std<-grep("std",names(Total))

# add ID and Activity plus labels mean and std
second_data<-Total[,c(1,2,col_alone_mean,col_std)]


# Group data by Activity and ID
second_data <- second_data %>%
  group_by(ID,Actividad) %>%
  summarise_each(funs(mean))

View(second_data)

# save data in txt with name=coursera_project
write.table(second_data,file = "data_5th_step_finished.txt",row.names = FALSE)



