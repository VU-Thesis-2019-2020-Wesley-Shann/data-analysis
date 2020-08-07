# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title) {
  ggplot(dataframe, aes_string(
    x = "subject.id",
    y = axis_y_column,
    fill = "subject.name"
  )) +
    geom_boxplot() +
    labs(
      title = title,
      x = "Subjects ~ Treatments",
      y = axis_y_legend
    ) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "none"
    ) +
    scale_fill_tron()
}