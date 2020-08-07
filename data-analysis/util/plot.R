# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title) {
  aes <- aes_string(
    x = "subject.id",
    y = axis_y_column
  )

  labs <- labs(
    title = title,
    x = "Subjects ~ Treatments",
    y = axis_y_legend
  )

  theme <- theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

  ggplot(dataframe, aes) +
    geom_boxplot() +
    labs +
    theme
}