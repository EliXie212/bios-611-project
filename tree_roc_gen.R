library(lattice)
library(leaps)
library(magrittr)
library(caret)
library(tidyverse)
library(corrgram)
library(ROCR)
library(pracma)
library(party)
library(glmnet)
library(tinytex)

train_dat = read.csv('derived_data/train_val_dat.csv')
test_dat = read.csv('derived_data/test_dat.csv')


## Decision Tree
tree <- ctree(target~. ,data=train_dat, control=ctree_control(maxdepth=10))

### Error criteria helper functions
## Calculate false positive rate
cal.fp <- function(pred, observation) {
  num.fp = sum((pred == 1) & (observation == 0))
  return(num.fp / sum(observation == 0))
}


## Calculate false negative rate
cal.fn <- function(pred, observation) {
  num.fn = sum((pred == 0) & (observation == 1))
  return (num.fn / sum(observation == 1))
}


## Calculate accuracy
cal.accuracy <- function(pred, observation) {
  num.acc = sum(pred == observation)
  return (num.acc / length(observation))
}

## Generate relevant Graphs
png(filename="figures/tree_roc.png") ## Save the figure
par(mfrow =c(1, 2))

# plot(tree)

pred.confusion.tree = ROCR::prediction(predict(tree, train_dat), train_dat$target)
perf.acc = ROCR::performance(pred.confusion.tree, "acc")
plot(perf.acc, cex.lab=0.7)
abline(v = 0.42)


perf.roc = ROCR::performance(pred.confusion.tree,"fnr","fpr")
plot(perf.roc, colorize = T, lwd = 2, cex.lab=0.7)
abline(a = 0, b = 1)
abline(a = 0.05, b = 0)


tree.threshold = 0.37

tree.pred.train.val = predict(tree, train_dat)
cal.accuracy(tree.pred.train.val > tree.threshold, train_dat$target)
cal.fp(tree.pred.train.val > tree.threshold, train_dat$target)
cal.fn(tree.pred.train.val > tree.threshold, train_dat$target)

tree.pred.test = predict(tree, test_dat)
cal.accuracy(tree.pred.test > tree.threshold, test_dat$target)
cal.fp(tree.pred.test > tree.threshold, test_dat$target)
cal.fn(tree.pred.test > tree.threshold, test_dat$target)
