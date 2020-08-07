# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

library(dplyr)
library(ggplot2)

source("util/read_data.R")

rq4.dataframe <- experiment.source.strategy_accuracy()

aes <- aes_string(
  y = "f1_score",
  x = "subject.id"
)


theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

labs <- labs(

)

ggplot(rq4.dataframe, aes) +
  geom_boxplot() +
  labs +
  theme