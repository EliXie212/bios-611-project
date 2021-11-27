library(glmnet)

train_dat = read.csv('derived_data/train_val_dat.csv')
test_dat = read.csv('derived_data/test_dat.csv')

features = model.matrix(target ~ (age + sex + cp + trestbps + chol + fbs +
                          restecg + thalach + exang + oldpeak + slope + ca
                          + thal)^2, train_dat)

response = train_dat$target


#perform k-fold cross-validation to find optimal lambda value
lasso.model <- cv.glmnet(features, response, family="binomial", alpha = 1)

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
png(filename="figures/lasso_roc.png") ## Save the figure
### Choose the threshold (ROC Curve)
par(mfrow =c(1,3))

plot(lasso.model)

lasso.train.pred = predict(lasso.model, newx=features, type='response')
pred.confusion = ROCR::prediction(lasso.train.pred, train_dat$target)
perf.acc = ROCR::performance(pred.confusion, "acc")
plot(perf.acc, cex.lab=0.7)
abline(v = 0.47)


perf.roc = ROCR::performance(pred.confusion,"fnr","fpr")
plot(perf.roc, colorize = T, lwd = 2, cex.lab=0.7)
abline(a = 0, b = 1)
abline(a = 0.05, b = 0)


lasso.threshold = 0.47


lasso.pred.train = predict(lasso.model, features, type='response') > lasso.threshold
cal.accuracy(lasso.pred.train, train_dat$target)
cal.fp(lasso.pred.train, train_dat$target)
cal.fn(lasso.pred.train, train_dat$target)


features.test = model.matrix(target ~ (age + sex + cp + trestbps + chol + fbs + restecg + thalach + exang + oldpeak + slope + ca + thal)^2, test_dat)

lass.pred.test = predict(lasso.model, features.test, type='response') > lasso.threshold
cal.accuracy(lass.pred.test, test_dat$target)
cal.fp(lass.pred.test, test_dat$target)
cal.fn(lass.pred.test, test_dat$target)
