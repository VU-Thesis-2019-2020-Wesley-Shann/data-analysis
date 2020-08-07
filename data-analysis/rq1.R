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
print("Reading data")
rq1.dataframe <- experiment.source.runtime()

# Take summary from the data and write to file
print("Summarizing data")
rq1.columns_to_take_summary <- c("run.duration.s", "android.memory.mb", "trepn.cpu")
rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.joule != 0
rq1.summary <- cbind(
  as.matrix(summary(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule)),
  summary(rq1.dataframe[rq1.columns_to_take_summary])
)
colnames(rq1.summary)[1] <- "trepn.battery.nonzero.joule"
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary),
                       file_name = "data-summary.tex",
                       caption = "Overview of the runtime metrics per subject and treatment.",
                       label = "tab:results:rq1:summary:all")

# Take the duration time per subject and write to file
print("Summarizing duration data")
rq1.summary.duration <- experiment.subject.summary(dataframe = rq1.dataframe, property = "run.duration.s")
rq1.summary.duration <- rq1.summary.duration[-c(2, 3, 5),]
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.duration),
                       file_name = "duration_per_subject_treatment-summary.tex",
                       caption = "Overview of the runtime duration per subject and treatment.",
                       label = "tab:results:rq1:summary:duration")

# Make plots of the data
print("Generating plots")

experiment.plot.boxplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                        "trepn.battery.nonzero.joule",
                        "Battery comsumption (J)",
                        "Boxplot: battery comsumption per subject")