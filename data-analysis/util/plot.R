# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column) {
  aes <- aes_string(
    x = "subject.id",
    y = axis_y_column
  )

  theme <- theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

  ggplot(dataframe, aes) +
    geom_boxplot() +
    theme
}