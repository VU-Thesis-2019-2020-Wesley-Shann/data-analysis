# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

# Load required libraries
library(dplyr)
library(ggplot2)
library(xtable)

# Load utility files
source("util/subject.R")
source("util/read_data.R")
source("util/write_data.R")
source("util/plot.R")

# Read data
rq1.dataframe <- experiment.source.runtime()

# Take summary from the data and write to file
rq1.columns_to_take_summary <- c("run.duration.s", "android.memory.mb", "trepn.cpu")
rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.joule != 0
rq1.summary <- cbind(
  summary(rq1.dataframe[rq1.columns_to_take_summary]),
  as.matrix(summary(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule))
)
colnames(rq1.summary)[4] <- "trepn.battery.nonzero.joule"
experiment.write.latex(1, t(rq1.summary), "data-summary.tex")

# Take the duration time per subject and write to file
rq1.summary.duration_per_subject_treatment <- NULL
rq1.summary.duration_per_subject_treatment.columns <- NULL
for (subject_id in unique(rq1.dataframe$subject.id)) {
  print(subject_id)
  rq1.summary.duration_per_subject_treatment <- cbind(
    rq1.summary.duration_per_subject_treatment,
    as.matrix(summary(rq1.dataframe[experiment.subject.filter_per_id(rq1.dataframe, subject_id),]$run.duration.s))
  )
  rq1.summary.duration_per_subject_treatment.columns <- cbind(rq1.summary.duration_per_subject_treatment.columns, subject_id)
}
colnames(rq1.summary.duration_per_subject_treatment) <-rq1.summary.duration_per_subject_treatment.columns
experiment.write.latex(1, t(rq1.summary.duration_per_subject_treatment), "duration_per_subject_treatment-summary.tex")

# Make plots of the data
aes <- aes_string(
  x = "subject.id",
  #y = "android.memory.mb",
  #  y = "trepn.battery.joule",
  y = "trepn.battery.nonzero.joule"
)

theme <- theme(
  axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
)

ggplot(rq1.dataframe, aes) + geom_boxplot()