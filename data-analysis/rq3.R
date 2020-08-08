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