library(plyr)
library(dplyr)

featureNamesData<-read.csv("features.txt",sep=" ",header=F)
featureNames<-as.vector(as.matrix(featureNamesData[2]))

stds <- grepl("std",tolower(featureNames))
means <- grepl("mean",tolower(featureNames))
columns <- which(stds | means)

ytrain <- read.table("train/y_train.txt")
colnames(ytrain) <- "Activity"
xtrain <- read.table("train/X_train.txt")
colnames(xtrain) <- featureNames
xtrainSelected <- xtrain[columns]
subjTrain <- read.table("train/subject_train.txt")
colnames(subjTrain) <- "Subject"
training <- cbind(subjTrain,ytrain,xtrainSelected)

ytest <- read.table("test/y_test.txt")
colnames(ytest) <- "Activity"
xtest <- read.table("test/X_test.txt")
colnames(xtest) <- featureNames
xtestSelected <- xtest[columns]
subjTest <- read.table("test/subject_test.txt")
colnames(subjTest) <- "Subject"
test <- cbind(subjTest,ytest,xtestSelected)

merged<-rbind(test,training)

labels<-read.table("activity_labels.txt")
colnames(labels)<-c("Activity","ActivityLabel")

labeledData<-merge(labels,merged,by.x="Activity",by.y="Activity")

labeledDF <- tbl_df(labeledData)

grouped <- labeledDF %>% group_by(Activity) %>% summarise_each(funs(mean))

write.table(grouped, file = "tidy.txt", row.names = FALSE)

grouped
