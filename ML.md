---
title: "Human Activity Recognition Model""
author: "Holger Laschewski
date: "Thursday, 8 January, 2014""
output:
  html_document:
    theme: spacelab
---
# Executive Summary
My aim in  this report was to use data from accelerometers placed on the belr, forearm, arm, and dumbell of six participants to predict how they were doing the exercise in terms of the classification in the data

### Libraries
Used the following libs

```r
library(caret)
library(corrplot)
```

```
## Error in library(corrplot): there is no package called 'corrplot'
```

```r
library(kernlab)
```

```
## Error in library(kernlab): there is no package called 'kernlab'
```

```r
library(knitr)
library(randomForest)
```


### Loading and first processing of the data
Two csv files contatining the training and test data was downloaded from the cloudfront on the 07.01.2015 into a data folder.


```r
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
```

Load of the training data


```r
# read outer data 
data_training <- read.csv("./data/pml-training.csv", na.strings= c("NA",""," "))
```

```
## Warning in file(file, "rt"): cannot open file './data/pml-training.csv':
## No such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

Removing of NAs


```r
# cleaning an removing NAS
data_training_NAs <- apply(data_training, 2, function(x) {sum(is.na(x))})
```

```
## Error in apply(data_training, 2, function(x) {: object 'data_training' not found
```

```r
data_training_clean <- data_training[,which(data_training_NAs == 0)]
```

```
## Error in eval(expr, envir, enclos): object 'data_training' not found
```

```r
# eliminate and remove the rest
data_training_clean <- data_training_clean[8:length(data_training_clean)]
```

```
## Error in eval(expr, envir, enclos): object 'data_training_clean' not found
```

### Model Creation
The test data set was split up into training and cross validation sets in a 70:30 ratio in order to train the model and then test it against data it was not specifically fitted to.


```r
# cross and train evaluation split
inTrain <- createDataPartition(y = data_training_clean$classe, p = 0.7, list = FALSE)
```

```
## Error in createDataPartition(y = data_training_clean$classe, p = 0.7, : object 'data_training_clean' not found
```

```r
training <- data_training_clean[inTrain, ]
```

```
## Error in eval(expr, envir, enclos): object 'data_training_clean' not found
```

```r
crossval <- data_training_clean[-inTrain, ]
```

```
## Error in eval(expr, envir, enclos): object 'data_training_clean' not found
```

A random forest model was selected to predict the classification because it has methods for balancing error in class population unbalanced data sets. The correlation between any two trees in the forest increases the forest error rate. Therefore, a correllation plot was produced in order to see how strong the variables relationships are with each other.


```r
# show a correlation matrix
correlMatrix <- cor(training[, -length(training)])
```

```
## Error in is.data.frame(x): object 'training' not found
```

```r
corrplot(correlMatrix, order = "FPC", method = "circle", type = "lower", tl.cex = 0.8,  tl.col = rgb(0, 0, 0))
```

```
## Error in eval(expr, envir, enclos): could not find function "corrplot"
```

In this type of plot the dark red and blue colours indicate a highly negative and positive relationship respectively between the variables. There isn't much concern for highly correlated predictors which means that all of them can be included in the model.

Then a model was fitted with the outcome set to the training class and all the other variables used to predict.


```r
# fit a model to predict the classe using everything else as a predictor
model <- randomForest(classe ~ ., data = training)
```

```
## Error in eval(expr, envir, enclos): object 'training' not found
```

```r
model
```

```
## Error in eval(expr, envir, enclos): object 'model' not found
```

The model produced a very small OOB error rate of .56%. This was deemed satisfactory enough to progress the testing.

### Cross-validation
The model was then used to classify the remaining 30% of data. The results were placed in a confusion matrix along with the actual classifications in order to determine the accuracy of the model.


```r
# crossvalidation with 30% 
predictCrossVal <- predict(model, crossval)
```

```
## Error in predict(model, crossval): object 'model' not found
```

```r
confusionMatrix(crossval$classe, predictCrossVal)
```

```
## Error in confusionMatrix(crossval$classe, predictCrossVal): object 'crossval' not found
```

This model yielded a 99.3% prediction accuracy. Again, this model proved very robust and adequete to predict new data.

### Predictions
A separate data set was then loaded into R and cleaned in the same manner as before. The model was then used to predict the classifications of the 20 results of this new data.


```r
# final data get the same treatment
data_test <- read.csv("./data/pml-testing.csv", na.strings= c("NA",""," "))
```

```
## Warning in file(file, "rt"): cannot open file './data/pml-testing.csv': No
## such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
data_test_NAs <- apply(data_test, 2, function(x) {sum(is.na(x))})
```

```
## Error in apply(data_test, 2, function(x) {: object 'data_test' not found
```

```r
data_test_clean <- data_test[,which(data_test_NAs == 0)]
```

```
## Error in eval(expr, envir, enclos): object 'data_test' not found
```

```r
data_test_clean <- data_test_clean[8:length(data_test_clean)]
```

```
## Error in eval(expr, envir, enclos): object 'data_test_clean' not found
```

```r
# prediction and benediction :-)
predictTest <- predict(model, data_test_clean)
```

```
## Error in predict(model, data_test_clean): object 'model' not found
```

```r
predictTest
```

```
## Error in eval(expr, envir, enclos): object 'predictTest' not found
```

### Conclusion
With the abundance of information given from multiple measuring instruments it's possible to accurately predict how well a person is preforming an excercise using a relatively simple model. 
