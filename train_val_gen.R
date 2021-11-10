library(tidyverse)


set.seed(123)
dat <- read.csv("source_data/heart.csv", sep = ",")

## Split data into train_val and test
split_dummy.1 <- sample(c(rep(0, 9/10 * nrow(dat)),
                          rep(1, 1/10 * nrow(dat))))


train.val.dat <- dat[split_dummy.1 == 0, ]
test_dat <- dat[split_dummy.1 == 1, ]


## Split train_val into train and validatioin
split_dummy.2 <- sample(c(rep(0, 8/9 * nrow(train.val.dat)),
                          rep(1, 1/9 * nrow(train.val.dat))))


train_dat <- train.val.dat[split_dummy.2 == 0, ]
val_dat <- train.val.dat[split_dummy.2 == 1, ]


write.csv(train_dat, 'derived_data/train_dat.csv')
write.csv(val_dat, 'derived_data/val_dat.csv')
write.csv(test_dat, 'derived_data/test_dat.csv')
write.csv(train.val.dat, 'derived_data/train_val_dat.csv')
