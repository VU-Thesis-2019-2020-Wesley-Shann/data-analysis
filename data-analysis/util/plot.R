# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

experiment.plot.boxplot <- function(dataframe, axis_y_column, axis_y_legend, title,
                                    axis_x_column = "subject.id",
                                    fill = "subject.name",
                                    axis_x_legend = "Subjects ~ Treatments") {
  # The x/y invertion is not an error,
  # I inverted them after the analysis because it easier to read the subjects in the Y axis
  ggplot(dataframe, aes_string(
    y = axis_x_column,
    x = axis_y_column,
    fill = fill
  )) +
    geom_boxplot() +
    labs(
      #title = paste("Boxplot:", title),
      y = axis_x_legend,
      x = axis_y_legend
    ) +
    theme(
      #axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "none"
    ) +
    scale_fill_tron()
}

experiment.plot.violin <- function(dataframe, axis_y_column, axis_y_legend, title,
                                   axis_x_column = "subject.treatment.name.long",
                                   fill = "subject.treatment.name.long",
                                   axis_x_legend = "Treatments") {
  ggplot(dataframe, aes_string(
    y = axis_x_column,
    x = axis_y_column,
    fill = fill
  )) +
    geom_violin(
      draw_quantiles = c(0.25, 0.5, 0.75)
    ) +
    labs(
      #title = paste("Violin plot:", title),
      y = axis_x_legend,
      x = axis_y_legend
    ) +
    theme(
      #axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
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
    theme(
      legend.position = "bottom"
    ) +
    labs(
      #title = paste("Frequency plot:", title),
      x = axis_x_legend,
      y = "Count",
      colour = "Treatments"
    ) +
    scale_color_tron()
}

experiment.plot.qqplot <- function(dataframe, sample_column, sample_legend, title) {
  ggplot(dataframe, aes_string(
    sample = sample_column,
    colour = "subject.treatment.name.long"
  )) +
    stat_qq() +
    stat_qq_line() +
    labs(
      #title = paste("QQ-Plot:", title),
      y = paste("Sample", sample_legend, sep = " ~ "),
      x = "Normal Theoretical Quantile",
      colour = "Treatments"
    ) +
    theme(
      legend.position = "bottom"
    ) +
    scale_color_tron()
}

experiment.plot.line <- function(dataframe, title, axis_y_column, axis_y_legend,
                                 axis_x_column = "run.number",
                                 axis_x_legend = "Run",
                                 group_by_column = "subject.id",
                                 group_by_legend = "Subject") {
  ggplot(dataframe, aes_string(
    x = axis_x_column,
    y = axis_y_column,
    colour = group_by_column,
    group = group_by_column
  )) +
    geom_line(
      linetype = "dashed"
    ) +
    geom_point() +
    labs(
      #title = title,
      x = axis_x_legend,
      y = axis_y_legend,
      colour = group_by_legend
    ) +
    theme(
      legend.position = "bottom"
    ) +
    scale_colour_tron()
}