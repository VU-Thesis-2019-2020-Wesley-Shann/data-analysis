# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title, axis_x_column, fill, axis_x_legend) {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_boxplot() +
    labs(
      title = title,
      x = axis_x_legend,
      y = axis_y_legend
    ) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "none"
    ) +
    scale_fill_tron()
}

experiment.plot.boxplot.subject <- function(dataframe, axis_y_column, axis_y_legend, title) {
  experiment.plot.boxplot(dataframe, axis_y_column, axis_y_legend, title,
                          axis_x_column = "subject.id",
                          fill = "subject.name",
                          axis_x_legend = "Subjects ~ Treatments")
}

experiment.plot.violin <- function(dataframe, axis_y_column, axis_y_legend, title, axis_x_column, fill, axis_x_legend) {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_violin() +
    geom_boxplot(
      width = 0.2
    ) +
    labs(
      title = title,
      x = axis_x_legend,
      y = axis_y_legend
    ) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "none"
    ) +
    scale_fill_tron()
}

experiment.plot.violin.treatment <- function(dataframe, axis_y_column, axis_y_legend, title) {
  experiment.plot.violin(dataframe, axis_y_column, axis_y_legend, title,
                         axis_x_column = "subject.treatment.name.long",
                         fill = "subject.treatment.name.long",
                         axis_x_legend = "Treatments")
}