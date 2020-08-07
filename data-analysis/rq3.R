# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20


source("util/read_data.R")

rq3.dataframe <- experiment.source.prefetching.accuracy()

aes <- aes_string(
  y = "f1.score",
  x = "subject.id"
)


theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

labs <- labs(

)

rq3.subjects.above.0 <- c("Antenna Pod", "Hill'Fair", "Materialistic")
ggplot(rq3.dataframe[rq3.dataframe$subject.name %in% rq3.subjects.above.0,], aes) +
  geom_boxplot() +
  labs +
  theme