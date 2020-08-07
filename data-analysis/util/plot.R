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
                                   axis_x_legend = "Treatments",
                                   boxplot_width = 0.2) {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_violin() +
    geom_boxplot(
      width = boxplot_width
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