library(caret)
library(kernlab)
library(randomForest)
library(corrplot)

# Data Folder <> create
if (!file.exists("data")) {dir.create("data")}

# define source
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
destfile1 <- "./data/pml-training.csv"
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
destfile2 <- "./data/pml-testing.csv"

# download source
download.file(fileUrl1, destfile = destfile1)
download.file(fileUrl2, destfile = destfile2)
dateDownloaded <- date()

# read outer file
data_training <- read.csv("./data/pml-training.csv", na.strings= c("NA",""," "))

# cleaning and remove NAS
data_training_NAs <- apply(data_training, 2, function(x) {sum(is.na(x))})
data_training_clean <- data_training[,which(data_training_NAs == 0)]

# eliminate and remove the rest
data_training_clean <- data_training_clean[8:length(data_training_clean)]

# cross and train evaluation split
inTrain <- createDataPartition(y = data_training_clean$classe, p = 0.7, list = FALSE)
training <- data_training_clean[inTrain, ]
crossval <- data_training_clean[-inTrain, ]

# show correlation matrix
correlMatrix <- cor(training[, -length(training)])
corrplot(correlMatrix, order = "FPC", method = "circle", type = "lower", tl.cex = 0.8,  tl.col = rgb(0, 0, 0))

# fit a model to predict the classe using everything else as a predictor
model <- randomForest(classe ~ ., data = training)

# crossvalidation with 30%
predictCrossVal <- predict(model, crossval)
confusionMatrix(crossval$classe, predictCrossVal)

# final data get the same treatment
data_test <- read.csv("./data/pml-testing.csv", na.strings= c("NA",""," "))
data_test_NAs <- apply(data_test, 2, function(x) {sum(is.na(x))})
data_test_clean <- data_test[,which(data_test_NAs == 0)]
data_test_clean <- data_test_clean[8:length(data_test_clean)]

# prediction and benediction :-)
predictTest <- predict(model, data_test_clean)
