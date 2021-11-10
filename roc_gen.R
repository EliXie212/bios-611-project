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


### Variable selection using BIC
### Define min and max model
colnames(train_dat)
formula.full =formula("target ~ (age + sex + cp + trestbps + chol + fbs + restecg + thalach + exang + oldpeak + slope + ca + thal)^2")

mod.minimal <- glm(target ~ 1, data = train_dat, family = "binomial")
mod.full <- glm(formula.full, data = train_dat, family = "binomial")



### BIC
k_num <- log(nrow(train_dat))
bic.forward = step(mod.minimal, direction = 'forward',
                   scope = list(upper = mod.full,
                                lower = mod.minimal), k = k_num, trace=0)

### Choosing the final model
final.formula = bic.forward$formula
final.model <- glm(final.formula, data = train_dat, family = "binomial")


#final.formula


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


### Choose the threshold (ROC Curve)
png(filename="figures/roc.png") ## Save the figure

par(mfrow =c(1, 2))

val_pred = predict(final.model, val_dat, type='response')
pred.confusion = ROCR::prediction(val_pred, val_dat$target)
perf.acc = ROCR::performance(pred.confusion, "acc")
plot(perf.acc, cex.lab = 0.7)
abline(v = 0.31)


perf.roc = ROCR::performance(pred.confusion,"fnr","fpr")
plot(perf.roc, colorize = T, lwd = 2, cex.lab = 0.7)
abline(a = 0, b = 1)
abline(a = 0.05, b = 0)


final.threshold = 0.31


final.pred.val = predict(final.model, val_dat, type='response') > final.threshold
cal.accuracy(final.pred.val, val_dat$target)
cal.fp(final.pred.val, val_dat$target)
cal.fn(final.pred.val, val_dat$target)



### Test the final model against the test set
final.model.plus.val = glm(final.formula, data = train.val.dat, family = "binomial")
final.pred.test = predict(final.model, test_dat, type='response') > final.threshold
cal.accuracy(final.pred.test, test_dat$target)
cal.fp(final.pred.test, test_dat$target)
cal.fn(final.pred.test, test_dat$target)
