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
rq4.dataframe <- experiment.source.strategy_accuracy()

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################

print("Phase 1. Data exploration")

################################  Phase 1a Descriptive statistics ###############################
keep_min_max_mean <- c(2, 3, 5)
keep_min_max_median <- c(2, 4, 5)

# Per treatment
print("Descriptive statistics per treatment")
rq4.summary.treatment.f1_score <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "f1_score", digits = 2)
rq4.summary.treatment.f1_score <- rq4.summary.treatment.f1_score[-rows_to_drop_from_summary,]
experiment.write.latex(rq = 4,
                       digits = 2,
                       dataframe = rq4.summary.treatment.f1_score,
                       filename = "summary_treatment_f1_score.tex",
                       caption = "Overview of the F1 Score per treatment.",
                       label = "tab:results:rq4:summary:treatment:f1_Score")
rownames(rq4.summary.treatment.f1_score) <- paste("F1-Score", rownames(rq4.summary.treatment.f1_score))

rq4.summary.treatment.precision <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "precision", digits = 2)
rq4.summary.treatment.precision <- rq4.summary.treatment.precision[-rows_to_drop_from_summary,]
rownames(rq4.summary.treatment.precision) <- paste("Precision", rownames(rq4.summary.treatment.precision))

rq4.summary.treatment.recall <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "recall", digits = 2)
rq4.summary.treatment.recall <- rq4.summary.treatment.recall[-rows_to_drop_from_summary,]
rownames(rq4.summary.treatment.recall) <- paste("Recall", rownames(rq4.summary.treatment.recall))

rq4.summary.treatment.tp <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "true_positive", digits = 2)
rq4.summary.treatment.tp <- rq4.summary.treatment.tp[-rows_to_drop_from_summary,]
rownames(rq4.summary.treatment.tp) <- paste("TP", rownames(rq4.summary.treatment.tp))

rq4.summary.treatment.fp <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "false_positive", digits = 2)
rq4.summary.treatment.fp <- rq4.summary.treatment.fp[-rows_to_drop_from_summary,]
rownames(rq4.summary.treatment.fp) <- paste("FP", rownames(rq4.summary.treatment.fp))

rq4.summary.treatment.fn <- experiment.treatment.summary(dataframe = rq4.dataframe, property = "false_negative", digits = 2)
rq4.summary.treatment.fn <- rq4.summary.treatment.fn[-rows_to_drop_from_summary,]
rownames(rq4.summary.treatment.fn) <- paste("FN", rownames(rq4.summary.treatment.fn))

rq4.summary.treatment.aggregate <- rbind(rq4.summary.treatment.f1_score, rq4.summary.treatment.recall, rq4.summary.treatment.precision, rq4.summary.treatment.tp, rq4.summary.treatment.fp, rq4.summary.treatment.fn)
rq4.summary.treatment.aggregate

experiment.write.latex(rq = 4,
                       digits = 2,
                       dataframe = rq4.summary.treatment.aggregate,
                       filename = "summary_treatment.tex",
                       caption = "Overview of the user navigation prediction accuracy per treatment.",
                       label = "tab:results:rq4:summary:treatment")

# Subject summary
print("Descriptive statistics per subject")
rq4.summary.subject.f1_score <- experiment.subject.summary(dataframe = rq4.dataframe, property = "f1_score", digits = 2)
rq4.summary.subject.f1_score <- rq4.summary.subject.f1_score[-rows_to_drop_from_summary,]
experiment.write.latex(rq = 4,
                       digits = 2,
                       dataframe = t(rq4.summary.subject.f1_score),
                       filename = "summary_subject_f1_score.tex",
                       caption = "Overview of the F1 Score per subject.",
                       label = "tab:results:rq4:summary:subject:f1_score")
rownames(rq4.summary.subject.f1_score) <- paste("F1-Score", rownames(rq4.summary.subject.f1_score))

rq4.summary.subject.precision <- experiment.subject.summary(dataframe = rq4.dataframe, property = "precision", digits = 2)
rq4.summary.subject.precision <- rq4.summary.subject.precision[-rows_to_drop_from_summary,]
rownames(rq4.summary.subject.precision) <- paste("Precision", rownames(rq4.summary.subject.precision))

rq4.summary.subject.recall <- experiment.subject.summary(dataframe = rq4.dataframe, property = "recall", digits = 2)
rq4.summary.subject.recall <- rq4.summary.subject.recall[-rows_to_drop_from_summary,]
rownames(rq4.summary.subject.recall) <- paste("Recall", rownames(rq4.summary.subject.recall))

rq4.summary.subject.tp <- experiment.subject.summary(dataframe = rq4.dataframe, property = "true_positive", digits = 2)
rq4.summary.subject.tp <- rq4.summary.subject.tp[-rows_to_drop_from_summary,]
rownames(rq4.summary.subject.tp) <- paste("TP", rownames(rq4.summary.subject.tp))

rq4.summary.subject.fp <- experiment.subject.summary(dataframe = rq4.dataframe, property = "false_positive", digits = 2)
rq4.summary.subject.fp <- rq4.summary.subject.fp[-rows_to_drop_from_summary,]
rownames(rq4.summary.subject.fp) <- paste("FP", rownames(rq4.summary.subject.fp))

rq4.summary.subject.fn <- experiment.subject.summary(dataframe = rq4.dataframe, property = "false_negative", digits = 2)
rq4.summary.subject.fn <- rq4.summary.subject.fn[-rows_to_drop_from_summary,]
rownames(rq4.summary.subject.fn) <- paste("FN", rownames(rq4.summary.subject.fn))

rq4.summary.subject.aggregate <- rbind(rq4.summary.subject.f1_score, rq4.summary.subject.recall, rq4.summary.subject.precision, rq4.summary.subject.tp, rq4.summary.subject.fp, rq4.summary.subject.fn)
rq4.summary.subject.aggregate

experiment.write.latex(rq = 4,
                       digits = 2,
                       dataframe = t(rq4.summary.subject.aggregate),
                       filename = "summary_subject.tex",
                       caption = "Overview of the user navigation prediction accuracy per subject.",
                       label = "tab:results:rq4:summary:subject")

#######################################  Phase 1b Plots ########################################
print("Generating plots")

# Filters
rq4.filter.non_zero_f1_score <- rq4.dataframe$f1_score != 0
rq4.filter.part1 <- rq4.dataframe$experiment.part == 1
rq4.filter.part2 <- rq4.dataframe$experiment.part == 2
rq4.filter.part3 <- rq4.dataframe$experiment.part == 3
rq4.filter.antennaPod <- rq4.dataframe$subject.name == "Antenna Pod"
rq4.filter.hillfair <- rq4.dataframe$subject.name == "Hill'Fair"
rq4.filter.materialistic <- rq4.dataframe$subject.name == "Materialistic"

# Boxplot
my_plot <- experiment.plot.boxplot(rq4.dataframe,
                                   "f1_score",
                                   "F1 Score",
                                   "F1 Score (All subjects)") +
  expand_limits(y = c(0, 1))
experiment.write.plot(filename = "boxplot_all_f1_score.png", rq = 4)

my_plot <- experiment.plot.boxplot(rq4.dataframe[rq4.filter.non_zero_f1_score,],
                                   "f1_score",
                                   "F1 Score",
                                   "F1 Score (Subjects with score above 0)") +
  expand_limits(y = c(0, 1))
experiment.write.plot(filename = "boxplot_above_zero_f1_score.png", rq = 4)

for (subject in c("Antenna Pod", "Hill'Fair", "Materialistic")) {
  my_plot <- experiment.plot.boxplot(rq4.dataframe[rq4.dataframe$subject.name == subject,],
                                     fill = "subject.treatment.name.long",
                                     "f1_score",
                                     "F1 Score",
                                     paste(subject, "~", "F1 Score"))
  experiment.write.plot(filename = paste0("boxplot_f1_score_", subject, ".png"), rq = 4)
}

# F1 Score over time
for (subject in c("Antenna Pod", "Hill'Fair", "Materialistic")) {
  for (part in c(1, 2, 3)) {
    my_plot <- experiment.plot.line(dataframe = rq4.dataframe[rq4.dataframe$experiment.part == part &
                                                                rq4.dataframe$subject.name == subject,],
                                    title = paste("F1-Score over runs", subject, paste0("(part ", part, ")")),
                                    axis_y_column = "f1_score",
                                    axis_y_legend = "F1-Score") +
      expand_limits(y = c(0, 1))
    experiment.write.plot(filename = paste0("f1_score_over_runs_", subject, "_part_", part, ".png"), rq = 4)
  }
}

for (part in c(1, 2, 3)) {
  my_plot <- experiment.plot.line(dataframe = rq4.dataframe[rq4.dataframe$experiment.part == part &
                                                              rq4.dataframe$subject.name == "Materialistic",],
                                  title = paste("F1-Score over runs", subject, paste0("(part ", part, ")")),
                                  axis_y_column = "f1_score",
                                  axis_y_legend = "F1-Score") +
    expand_limits(y = 0)
  experiment.write.plot(filename = paste0("f1_score_over_runs_zoom", subject, "_part_", part, ".png"), rq = 4)
}

# Violin plot
my_plot <- experiment.plot.violin(rq4.dataframe[rq4.filter.non_zero_f1_score,],
                                  "f1_score",
                                  "F1 Score",
                                  "F1 Score (Subjects with score above 0)") +
  expand_limits(y = c(0, 1))
experiment.write.plot(filename = "violin_above_zero_f1_score.png", rq = 4)

my_plot <- experiment.plot.violin(rq4.dataframe,
                                  "f1_score",
                                  "F1 Score",
                                  "F1 Score (All subjects)") +
  expand_limits(y = c(0, 1))
experiment.write.plot(filename = "violin_all_f1_score.png", rq = 4)

# Frequency
my_plot <- experiment.plot.freqpoly(rq4.dataframe[rq4.filter.non_zero_f1_score,],
                                    "f1_score",
                                    "F1 Score",
                                    "F1 Score (Subjects with score above 0)") +
  expand_limits(x = c(0, 1))
experiment.write.plot(filename = "freqpoly_above_zero_f1_score.png", rq = 4)

my_plot <- experiment.plot.freqpoly(rq4.dataframe,
                                    "f1_score",
                                    "F1 Score",
                                    "F1 Score (All subjects)") +
  expand_limits(x = c(0, 1))
experiment.write.plot(filename = "freqpoly_all_f1_score.png", rq = 4)


#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
#################################################################################################
print("Phase 2. Normality Check and Data Transformation")

# Metric          Method        p-value     is normal (p-value > 0.05)
# -----           ------        -------     --------------------------
# F1 Score (all)  N/A           2.2e-16     no
# F1 Score (all)  all           2.2e-16     no
# F1 Score (> 0)  N/A           1.158e-15   no
# F1 Score (> 0)  squared       2.733e-14   no

##################################  Phase 2a Normality check ####################################
print("Check normality")

# Non zero
my_plot <- experiment.plot.qqplot(rq4.dataframe[rq4.filter.non_zero_f1_score,],
                                  "f1_score",
                                  "F1 Score",
                                  "F1 Score (Subjects with score above 0)")
experiment.write.plot(filename = "qqplot_above_zero_f1_score.png", rq = 4)

shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score)
# W = 0.76581, p-value = 1.158e-15
experiment.write.text(data = shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score),
                      filename = "test_shapiro_above_zero_f1_score.txt",
                      rq = 4)

# All
my_plot <- experiment.plot.qqplot(rq4.dataframe,
                                  "f1_score",
                                  "F1 Score",
                                  "F1 Score (All subjects)")
experiment.write.plot(filename = "qqplot_all_f1_score.png", rq = 4)

shapiro.test(rq4.dataframe$f1_score)
# W = 0.61996, p-value < 2.2e-16
experiment.write.text(data = shapiro.test(rq4.dataframe$f1_score),
                      filename = "test_shapiro_all_f1_score.txt",
                      rq = 4)

##################################  Phase 2a Data Transformation ####################################

# F1 Score ~ Natural log
rq4.dataframe$f1_score.log <- log(rq4.dataframe$f1_score)
#shapiro.test(rq4.dataframe$f1_score.log)
# not suitable for data with 0
shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score.log)
#W = 0.66554, p-value < 2.2e-16

# F1 Score ~ squared
rq4.dataframe$f1_score.squared <- rq4.dataframe$f1_score^2
shapiro.test(rq4.dataframe$f1_score.squared)
#W = 0.60301, p-value < 2.2e-16
shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score.squared)
#W = 0.80362, p-value = 2.733e-14

# F1 Score ~ square root
rq4.dataframe$f1_score.sqrt <- sqrt(rq4.dataframe$f1_score)
shapiro.test(rq4.dataframe$f1_score.sqrt)
#W = 0.65904, p-value < 2.2e-16
shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score.sqrt)
#W = 0.71667, p-value < 2.2e-16

# F1 Score ~ cube root
rq4.dataframe$f1_score.cube <- sign(rq4.dataframe$f1_score) * abs(rq4.dataframe$f1_score)^(1 / 3)
shapiro.test(rq4.dataframe$f1_score.cube)
#W = 0.68893, p-value < 2.2e-16
shapiro.test(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score.cube)
#W = 0.69855, p-value < 2.2e-16

# F1 Score ~ inverse
#rq4.dataframe$f1_score.inverse <- 1 / rq4.dataframe$f1_score
#shapiro.test(rq4.dataframe$f1_score.inverse)
# not suitable for data with 0

# F1 Score ~ Tukey’s Ladder of Powers transformation
rq4.dataframe$f1_score.tukey <- transformTukey(rq4.dataframe$f1_score, plotit = FALSE)
#    lambda      W Shapiro.p.value
#408  0.175 0.7067       1.905e-26
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(rq4.dataframe$f1_score.tukey)
#W = 0.70667, p-value < 2.2e-16
my_data <- transformTukey(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score, plotit = FALSE)
#    lambda      W Shapiro.p.value
#479   1.95 0.8036       2.724e-14
shapiro.test(my_data)
#W = 0.80358, p-value = 2.724e-14


# F1 Score ~ Box–Cox transformation
#Box <- boxcox(rq4.dataframe$f1_score ~ 1, lambda = seq(-6, 6, 0.1))
#Cox <- data.frame(Box$x, Box$y)
#Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
#Cox2[1,]
##   Box.x     Box.y
#lambda <- Cox2[1, "Box.x"]
#rq4.dataframe$f1_score.box <- (rq4.dataframe$f1_score^lambda - 1) / lambda
#shapiro.test(rq4.dataframe$f1_score.box)
# Fails due to data becoming negative
Box <- boxcox(rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
#   Box.x     Box.y
#66   0.5 -533.1367
lambda <- Cox2[1, "Box.x"]
my_data <- (rq4.dataframe[rq4.filter.non_zero_f1_score,]$f1_score^lambda - 1) / lambda
shapiro.test(my_data)
#W = 0.71667, p-value < 2.2e-16


#################################################################################################
#################################### Phase 3: Hypothesis Test ###################################
#################################################################################################
print("Phase 3. Hypothesis Test")

# Hypothesistest
# Metric          Test              p-value     is H0 rejected (p-value < 0.05)
# -----           ------            -------     --------------------------
# F1 Score (All)  Mann-Whitney      0.9968      no
# F1 Score (> 0)  Mann-Whitney      0.9894      no


rq4.filter.greedy <- rq4.dataframe$subject.treatment.id == "nappagreedy"
rq4.filter.tfpr <- rq4.dataframe$subject.treatment.id == "nappatfpr"

####################################### 3a: F1 Score (All) ######################################

# F1 Score (All) ~ not normal ~ Mann-Whitney
rq4.hypothesis.f1_score_all.whitney <- wilcox.test(rq4.dataframe[rq4.filter.greedy,]$f1_score,
                                                   rq4.dataframe[rq4.filter.tfpr,]$f1_score)
#	Wilcoxon rank sum test with continuity correction
#
#data:  rq4.dataframe[rq4.filter.greedy, ]$f1_score and rq4.dataframe[rq4.filter.tfpr, ]$f1_score
#W = 22045, p-value = 0.9968
#alternative hypothesis: true location shift is not equal to 0
experiment.write.text(data = rq4.hypothesis.f1_score_all.whitney,
                      rq = 4,
                      filename = "hypothesis_all_f1_score_whitney.txt")

cliff.delta(
  rq4.dataframe[rq4.filter.greedy, ]$f1_score,
  rq4.dataframe[rq4.filter.tfpr, ]$f1_score)
#Cliff's Delta
#
#delta estimate: -0.0002267574 (negligible)
#95 percent confidence interval:
#      lower       upper
#-0.09950464  0.09905559


####################################### 3a: F1 Score (> 0) ######################################

# F1 Score (> 0) ~ not normal ~ Mann-Whitney
rq4.hypothesis.f1_score_above_zero.whitney <- wilcox.test(rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.greedy,]$f1_score,
                                                   rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.tfpr,]$f1_score)
#	Wilcoxon rank sum test with continuity correction
#
#data:  rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.greedy, ]$f1_score and rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.tfpr, ]$f1_score
#W = 4045, p-value = 0.9894
#alternative hypothesis: true location shift is not equal to 0
experiment.write.text(data = rq4.hypothesis.f1_score_above_zero.whitney,
                      rq = 4,
                      filename = "hypothesis_above_zero_f1_score_whitney.txt")

cliff.delta(
  rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.greedy, ]$f1_score,
  rq4.dataframe[rq4.filter.non_zero_f1_score & rq4.filter.tfpr, ]$f1_score)
#Cliff's Delta
#
#delta estimate: -0.001234568 (negligible)
#95 percent confidence interval:
#     lower      upper
#-0.1640062  0.1616025
