# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title,
                                    axis_y_max = NA,
                                    axis_x_column = "subject.id",
                                    fill = "subject.name",
                                    axis_x_legend = "Subjects ~ Treatments") {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_boxplot() +
    expand_limits(y = c(0, axis_y_max)) +
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
                                   axis_y_max = NA,
                                   axis_x_column = "subject.treatment.name.long",
                                   fill = "subject.treatment.name.long",
                                   axis_x_legend = "Treatments") {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    fill = fill
  )) +
    geom_violin() +
    geom_boxplot(
      width = 0.2
    ) +
    expand_limits(y = c(0, axis_y_max)) +
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