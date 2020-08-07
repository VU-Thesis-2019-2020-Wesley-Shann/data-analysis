# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

library(plyr)
library(ggplot2)

source("util/read_data.R")

rq1.dataframe <- experiment.source.runtime()

aes <- aes_string(
  y = "android.memory.mb",
  x = "subject.id.short"
)
ggplot(rq1.dataframe, aes) + geom_boxplot()

