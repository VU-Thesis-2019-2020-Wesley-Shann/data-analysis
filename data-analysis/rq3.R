# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

# Load required libraries
library(dplyr)
library(ggsci)
library(ggplot2)
library(xtable)
library(rcompanion)
library(MASS)
library(effsize)

# Load utility files
source("util/subject.R")
source("util/read_data.R")
source("util/write_data.R")
source("util/plot.R")

print("===================")
print("Running RQ 1 script")

# Read data
print("Reading data")
rq3.dataframe <- experiment.source.prefetching_accuracy()

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################

print("Phase 1. Data exploration")

################################  Phase 1a Descriptive statistics ###############################
keep_min_max_mean <- c(2, 3, 5)
keep_min_max_median <- c(2, 4, 5)

# Per treatment
print("Descriptive statistics per treatment")
rq3.summary.treatment.f1_score <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "f1_score", digits = 2)
rq3.summary.treatment.f1_score <- rq3.summary.treatment.f1_score[-rows_to_drop_from_summary,]
experiment.write.latex(rq = 3,
                       digits = 2,
                       dataframe = rq3.summary.treatment.f1_score,
                       filename = "summary_treatment_f1_score.tex",
                       caption = "Overview of the F1 Score per treatment.",
                       label = "tab:results:rq3:summary:treatment:f1_Score")
rownames(rq3.summary.treatment.f1_score) <- paste("F1-Score", rownames(rq3.summary.treatment.f1_score))

rq3.summary.treatment.precision <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "precision", digits = 2)
rq3.summary.treatment.precision <- rq3.summary.treatment.precision[-rows_to_drop_from_summary,]
rownames(rq3.summary.treatment.precision) <- paste("Precision", rownames(rq3.summary.treatment.precision))

rq3.summary.treatment.recall <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "recall", digits = 2)
rq3.summary.treatment.recall <- rq3.summary.treatment.recall[-rows_to_drop_from_summary,]
rownames(rq3.summary.treatment.recall) <- paste("Recall", rownames(rq3.summary.treatment.recall))

rq3.summary.treatment.tp <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "true_positive", digits = 2)
rq3.summary.treatment.tp <- rq3.summary.treatment.tp[-rows_to_drop_from_summary,]
rownames(rq3.summary.treatment.tp) <- paste("TP", rownames(rq3.summary.treatment.tp))

rq3.summary.treatment.fp <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "false_positive", digits = 2)
rq3.summary.treatment.fp <- rq3.summary.treatment.fp[-rows_to_drop_from_summary,]
rownames(rq3.summary.treatment.fp) <- paste("FP", rownames(rq3.summary.treatment.fp))

rq3.summary.treatment.fn <- experiment.treatment.summary(dataframe = rq3.dataframe, property = "false_negative", digits = 2)
rq3.summary.treatment.fn <- rq3.summary.treatment.fn[-rows_to_drop_from_summary,]
rownames(rq3.summary.treatment.fn) <- paste("FN", rownames(rq3.summary.treatment.fn))

rq3.summary.treatment.aggregate <- rbind(rq3.summary.treatment.f1_score, rq3.summary.treatment.recall, rq3.summary.treatment.precision, rq3.summary.treatment.tp, rq3.summary.treatment.fp, rq3.summary.treatment.fn)
rq3.summary.treatment.aggregate

experiment.write.latex(rq = 3,
                       digits = 2,
                       dataframe = rq3.summary.treatment.aggregate,
                       filename = "summary_treatment.tex",
                       caption = "Overview of the prefetching accuracy per treatment.",
                       label = "tab:results:rq3:summary:treatment")

# Subject summary
print("Descriptive statistics per subject")
rq3.summary.subject.f1_score <- experiment.subject.summary(dataframe = rq3.dataframe, property = "f1_score", digits = 2)
rq3.summary.subject.f1_score <- rq3.summary.subject.f1_score[-rows_to_drop_from_summary,]
experiment.write.latex(rq = 3,
                       digits = 2,
                       dataframe = t(rq3.summary.subject.f1_score),
                       filename = "summary_subject_f1_score.tex",
                       caption = "Overview of the F1 Score per subject.",
                       label = "tab:results:rq3:summary:subject:f1_score")
rownames(rq3.summary.subject.f1_score) <- paste("F1-Score", rownames(rq3.summary.subject.f1_score))

rq3.summary.subject.precision <- experiment.subject.summary(dataframe = rq3.dataframe, property = "precision", digits = 2)
rq3.summary.subject.precision <- rq3.summary.subject.precision[-rows_to_drop_from_summary,]
rownames(rq3.summary.subject.precision) <- paste("Precision", rownames(rq3.summary.subject.precision))

rq3.summary.subject.recall <- experiment.subject.summary(dataframe = rq3.dataframe, property = "recall", digits = 2)
rq3.summary.subject.recall <- rq3.summary.subject.recall[-rows_to_drop_from_summary,]
rownames(rq3.summary.subject.recall) <- paste("Recall", rownames(rq3.summary.subject.recall))

rq3.summary.subject.tp <- experiment.subject.summary(dataframe = rq3.dataframe, property = "true_positive", digits = 2)
rq3.summary.subject.tp <- rq3.summary.subject.tp[-rows_to_drop_from_summary,]
rownames(rq3.summary.subject.tp) <- paste("TP", rownames(rq3.summary.subject.tp))

rq3.summary.subject.fp <- experiment.subject.summary(dataframe = rq3.dataframe, property = "false_positive", digits = 2)
rq3.summary.subject.fp <- rq3.summary.subject.fp[-rows_to_drop_from_summary,]
rownames(rq3.summary.subject.fp) <- paste("FP", rownames(rq3.summary.subject.fp))

rq3.summary.subject.fn <- experiment.subject.summary(dataframe = rq3.dataframe, property = "false_negative", digits = 2)
rq3.summary.subject.fn <- rq3.summary.subject.fn[-rows_to_drop_from_summary,]
rownames(rq3.summary.subject.fn) <- paste("FN", rownames(rq3.summary.subject.fn))

rq3.summary.subject.aggregate <- rbind(rq3.summary.subject.f1_score, rq3.summary.subject.recall, rq3.summary.subject.precision, rq3.summary.subject.tp, rq3.summary.subject.fp, rq3.summary.subject.fn)
rq3.summary.subject.aggregate

experiment.write.latex(rq = 3,
                       digits = 2,
                       dataframe = t(rq3.summary.subject.aggregate),
                       filename = "summary_subject.tex",
                       caption = "Overview of the prefetching accuracy per subject.",
                       label = "tab:results:rq3:summary:subject")

#######################################  Phase 1b Plots ########################################
print("Generating plots")

# Filters
rq3.filter.non_zero_f1_score <- rq3.dataframe$f1_score != 0
rq3.filter.part1 <- rq3.dataframe$experiment.part == 1
rq3.filter.part2 <- rq3.dataframe$experiment.part == 2
rq3.filter.part3 <- rq3.dataframe$experiment.part == 3
rq3.filter.antennaPod <- rq3.dataframe$subject.name == "Antenna Pod"
rq3.filter.hillfair <- rq3.dataframe$subject.name == "Hill'Fair"
rq3.filter.materialistic <- rq3.dataframe$subject.name == "Materialistic"

# Boxplot
my_plot <- experiment.plot.boxplot(rq3.dataframe[rq3.filter.non_zero_f1_score,],
                                   "f1_score",
                                   "F1 Score",
                                   "F1 Score") +
      expand_limits(y = c(0, 1))
experiment.write.plot(filename = "boxplot_f1_score.png", rq = 3)

for (subject in c("Antenna Pod", "Hill'Fair", "Materialistic")) {
  my_plot <- experiment.plot.boxplot(rq3.dataframe[rq3.dataframe$subject.name == subject,],
                                     fill = "subject.treatment.name.long",
                                     "f1_score",
                                     "F1 Score",
                                     paste(subject, "~", "F1 Score"))
  experiment.write.plot(filename = paste0("boxplot_f1_score_", subject, ".png"), rq = 3)
}

# F1 Score over time
for (subject in c("Antenna Pod", "Hill'Fair", "Materialistic")) {
  for (part in c(1, 2, 3)) {
    my_plot <- experiment.plot.line(dataframe = rq3.dataframe[rq3.dataframe$experiment.part == part &
                                                                rq3.dataframe$subject.name == subject,],
                                    title = paste("F1-Score over runs", subject, paste0("(part ", part, ")")),
                                    axis_y_column = "f1_score",
                                    axis_y_legend = "F1-Score") +
      expand_limits(y = c(0, 1))
    experiment.write.plot(filename = paste0("f1_score_over_runs_", subject, "_part_", part, ".png"), rq = 3)
  }
}

for (part in c(1, 2, 3)) {
  my_plot <- experiment.plot.line(dataframe = rq3.dataframe[rq3.dataframe$experiment.part == part &
                                                              rq3.dataframe$subject.name == "Materialistic",],
                                  title = paste("F1-Score over runs", subject, paste0("(part ", part, ")")),
                                  axis_y_column = "f1_score",
                                  axis_y_legend = "F1-Score") +
    expand_limits(y = 0)
  experiment.write.plot(filename = paste0("f1_score_over_runs_zoom", subject, "_part_", part, ".png"), rq = 3)
}

# Violin plot
my_plot <- experiment.plot.violin(rq3.dataframe[rq3.filter.non_zero_f1_score,],
                                   "f1_score",
                                   "F1 Score",
                                   "F1 Score") +
      expand_limits(y = c(0, 1))
experiment.write.plot(filename = "violin_f1_score.png", rq = 3)