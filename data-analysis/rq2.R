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
#y = "response.length.from_header.b",
x = "subject.id"
)


theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

labs <- labs(

)

rq2.index.has_length_from_okhttp <- rq2.dataframe$response.length.from_okhttp.b >= 0
rq2.index.has_length_from_header <- rq2.dataframe$response.length.from_header.b >= 0
rq2.index.length_from_okhttp_is_below_1_MB <- rq2.dataframe$response.length.from_okhttp.b <= 10^6
rq2.index.length_from_okhttp_is_below_100_KB <- rq2.dataframe$response.length.from_okhttp.b <= 100* 10^3

ggplot(rq2.dataframe[rq2.index.has_length_from_okhttp & rq2.index.length_from_okhttp_is_below_100_KB ,], aes) +
  geom_boxplot() +
  labs +
  theme