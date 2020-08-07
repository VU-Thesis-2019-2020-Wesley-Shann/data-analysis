# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

library(plyr)
library(ggplot2)

source("util/read_data.R")

rq2.dataframe <- experiment.source.network_request_execution_time()

aes <- aes_string(
  #y = "request.duration.from_system.ms",
  y = "response.length.from_okhttp.b",
  x = "subject.id"
)


theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

labs <- labs(

)

ggplot(rq2.dataframe, aes) +
  geom_boxplot() +
  labs +
  theme