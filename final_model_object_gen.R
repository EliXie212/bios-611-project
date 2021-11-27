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
library(texreg)

train_dat <- read.csv('derived_data/train_dat.csv')
dat <- read.csv("source_data/heart.csv", sep = ",")

formula.full = formula("target ~ (age + sex + cp + trestbps +
                        chol + fbs + restecg + thalach + exang +
                        oldpeak + slope + ca + thal)^2")

mod.minimal <- glm(target ~ 1, data = train_dat, family = "binomial")
mod.full <- glm(formula.full, data = train_dat, family = "binomial")

### BIC
k_num <- log(nrow(dat))
bic.forward = step(mod.minimal, direction = 'forward',
                   scope = list(upper = mod.full,
                                lower = mod.minimal), k = k_num, trace=0)

### Choosing the final model
final.formula = bic.forward$formula
final.model <- glm(final.formula, data = train_dat, family = "binomial")

## Save the model as an R object
saveRDS(final.model, "derived_objects/final_model.rds")
