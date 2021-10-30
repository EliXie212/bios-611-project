library(tidyverse)
library(corrgram)

train_dat = read.csv('derived_data/train_dat.csv')


png(filename="figures/corrgram.png")

corrgram(train_dat, order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt,
         main="Heart Disease Data Corrgram")