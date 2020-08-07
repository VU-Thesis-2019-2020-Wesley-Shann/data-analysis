# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title,
                                    axis_x_column = "subject.id",
                                    fill = "subject.name",
                                    axis_x_legend = "Subjects ~ Treatments") {
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

experiment.plot.violin <- function(dataframe, axis_y_column, axis_y_legend, title,
                                   axis_x_column = "subject.treatment.name.long",
                                   fill = "subject.treatment.name.long",
                                   axis_x_legend = "Treatments") {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_violin(
      draw_quantiles = c(0.25, 0.5, 0.75)
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

experiment.plot.freqpoly <- function(dataframe, axis_x_column, axis_x_legend, title) {
  ggplot(dataframe, aes_string(
    axis_x_column,
    colour = "subject.treatment.name.long"
  )) +
    geom_freqpoly(
      bins = 30,
      size = 1
    ) +
    labs(
      title = title,
      x = axis_x_legend,
      y = "Count"
    ) +
    theme(
      legend.position = "bottom"
    ) +
    scale_color_tron()
}