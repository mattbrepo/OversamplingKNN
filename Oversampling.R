library(caret)
library(class)
library(data.table)

#
# Experiment on oversampling with KNN model for binary classification
#

# create data with one item clearly in the wrong place
countA = 12
countB = 4
countBWrong = 2
df <- data.frame (X1 = c(rnorm(countA + countBWrong, mean=1, sd=0.1), rnorm(countB - countBWrong, mean=2, sd=0.1)),
                  X2 = c(rnorm(countA + countBWrong, mean=1, sd=0.1), rnorm(countB - countBWrong, mean=2, sd=0.1)),
                  Label = c(rep("A", countA), rep("B", countB))
)
df$LabelInt = 1
df[df$Label == "B", "LabelInt"] = -1

# plot the data
plot(x = df$X1, y = df$X2, xlab = "X1", ylab = "X2", cex = 2, col = "black", pch = ifelse(df$Label == "A", 1, 4), main="Class A: circle, Class B: cross")

# KNN classification
myMtxX = as.matrix(df[c("X1", "X2")])
myMtxY = as.matrix(df["LabelInt"])
yPred <- class::knn(myMtxX, myMtxX, cl=myMtxY, k=3) 

# plot the data (with color prediction)
plot(x = df$X1, y = df$X2, xlab = "X1", ylab = "X2", cex = 3, col = ifelse(yPred == myMtxY, "black", "red"), pch = ifelse(df$Label == "A", 21, 4), main="Class A: circle, Class B: cross, Red: wrong prediction")

# confusion matrix
cm = caret::confusionMatrix(as.factor(yPred), as.factor(df$LabelInt), positive="1") # NB: in caret the second parameter is the reference!
t(cm$table)

# random oversampling
countSampB = countA - countB
dfOS = data.frame(df)
dfOS$CountLabel = "" # add a string column containing the number of duplicates

dfB = dfOS[dfOS$Label == "B", ]
sampleBs = sample(nrow(dfB), countSampB, replace = TRUE)

tableBs = as.data.frame(table(sampleBs))
dfB[sampleBs, "CountLabel"] = tableBs[sampleBs, "Freq"] # number of duplicates

dfBOS = dfB[sampleBs, ]
dfOS = rbind(dfOS, dfBOS) # df OverSampled

# KNN classification of oversampled data
myMtxX2 = as.matrix(dfOS[c("X1", "X2")])
myMtxY2 = as.matrix(dfOS["LabelInt"])
yPredOS <- class::knn(myMtxX2, myMtxX2, cl=myMtxY2, k=3)

# plot the data (including the number of repetition)
plot(x = dfOS$X1, y = dfOS$X2, xlab = "X1", ylab = "X2", cex = 2, col = ifelse(yPredOS == myMtxY2, "black", "red"), pch = ifelse(dfOS$Label == "A", 21, 4), main="Red: wrong prediction, Num: count of oversampled duplicates")
text(dfOS$X1, dfOS$X2, labels = dfOS$CountLabel, pos = 4)

# confusion matrix of oversampled data
cmOS = caret::confusionMatrix(as.factor(yPredOS), as.factor(dfOS$LabelInt), positive="1") # NB: in caret the second parameter is the reference!
t(cmOS$table)


