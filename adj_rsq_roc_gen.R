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

train_dat = read.csv('derived_data/train_dat.csv')
val_dat = read.csv('derived_data/val_dat.csv')
test_dat = read.csv('derived_data/test_dat.csv')
train.val.dat = read.csv('derived_data/train_val_dat.csv')

formula.full =formula("target ~ (age + sex + cp + trestbps + chol + fbs +
                        restecg + thalach + exang + oldpeak + slope +
                        ca + thal)^2")

heart.regsub <- regsubsets(formula.full, data = train_dat, nvmax = 100,
                            method = "forward")
regsub.summary <- summary(heart.regsub)

adjr2.forward = regsub.summary$which[which.max(regsub.summary$adjr2), ]

### Generate formula
regsubset_to_formula.str <- function(features.logical) {
  cols = names(which(features.logical))
  cols = cols[2:length(cols)]

  return(paste0('target ~ ', paste(cols, collapse=" + " )))
}

adjr2.formula = formula(regsubset_to_formula.str(adjr2.forward))

adjr2.model <- glm(adjr2.formula, data = train_dat, family = "binomial")

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
png(filename="figures/adjrsq_roc.png") ## Save the figure
par(mfrow =c(1, 2))

adjr2.val_pred = predict(adjr2.model, val_dat, type='response')
pred.confusion = ROCR::prediction(adjr2.val_pred, val_dat$target)
perf.acc = ROCR::performance(pred.confusion, "acc")
plot(perf.acc, cex.lab=0.7)
abline(v = 0.31)


perf.roc = ROCR::performance(pred.confusion,"fnr","fpr")
plot(perf.roc, colorize = T, lwd = 2, cex.lab=0.7)
abline(a = 0, b = 1)
abline(a = 0.05, b = 0)


adjr2.threshold = 0.31

adjr2.pred.val = predict(adjr2.model, val_dat, type='response') > adjr2.threshold
cal.accuracy(adjr2.pred.val, val_dat$target)
cal.fp(adjr2.pred.val, val_dat$target)
cal.fn(adjr2.pred.val, val_dat$target)


adjr2.model.plus.val = glm(adjr2.formula, data = train.val.dat, family = "binomial")
adjr2.pred.test = predict(adjr2.model.plus.val, test_dat, type='response') > adjr2.threshold
cal.accuracy(adjr2.pred.test, test_dat$target)
cal.fp(adjr2.pred.test, test_dat$target)
cal.fn(adjr2.pred.test, test_dat$target)
