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

formula.full =formula("target ~ (age + sex + cp + trestbps + chol + fbs +
                        restecg + thalach + exang + oldpeak + slope +
                        ca + thal)^2")

heart.regsub <- regsubsets(formula.full, data = train_dat, nvmax = 100,
                            method = "forward")
regsub.summary <- summary(heart.regsub)

cp.forward = regsub.summary$which[which.min(regsub.summary$cp), ]

### Generate formula
regsubset_to_formula.str <- function(features.logical) {
  cols = names(which(features.logical))
  cols = cols[2:length(cols)]

  return(paste0('target ~ ', paste(cols, collapse=" + " )))
}

cp.formula = formula(regsubset_to_formula.str(cp.forward))

cp.model <- glm(cp.formula, data = train_dat, family = "binomial")

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
png(filename="figures/mallow_roc.png") ## Save the figure
par(mfrow =c(1, 2))

cp.val_pred = predict(cp.model, val_dat, type='response')
pred.confusion = ROCR::prediction(cp.val_pred, val_dat$target)
perf.acc = ROCR::performance(pred.confusion, "acc")
plot(perf.acc, cex.lab=0.7)
abline(v = 0.33)


perf.roc = ROCR::performance(pred.confusion,"fnr","fpr")
plot(perf.roc, colorize = T, lwd = 2, cex.lab=0.7)
abline(a = 0, b = 1)
abline(a = 0.05, b = 0)


cp.threshold = 0.33

cp.pred.val = predict(cp.model, val_dat, type='response') > cp.threshold
cal.accuracy(cp.pred.val, val_dat$target)
cal.fp(cp.pred.val, val_dat$target)
cal.fn(cp.pred.val, val_dat$target)
