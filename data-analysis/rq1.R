# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

library(plyr)
library(ggplot2)
library(xtable)

source("util/read_data.R")

rq1.dataframe <- experiment.source.runtime()

rq1.columns_to_take_summary <- c(
  "run.duration.s",
  "android.memory.mb",
  "trepn.cpu"
  #"trepn.battery.nonzero.joule" # contains 1 row with zero readings
)

rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.joule != 0

rq1.summary <- cbind(
  summary(rq1.dataframe[rq1.columns_to_take_summary]),
  as.matrix(summary(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule))
)

colnames(rq1.summary)[4] <- "trepn.battery.nonzero.joule"

print(xtable(t(rq1.summary), type = "latex"), file = )
#print(xtable(newobject2, type = "latex"), file = "filename2.tex")

aes <- aes_string(
  x = "subject.id.short",
  #y = "android.memory.mb",
  #  y = "trepn.battery.joule",
  y = "trepn.battery.nonzero.joule"
)

theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

ggplot(rq1.dataframe, aes) + geom_boxplot()