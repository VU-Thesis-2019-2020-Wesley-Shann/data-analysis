# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

# Load required libraries
library(dplyr)
library(ggsci)
library(ggplot2)
library(xtable)

# Load utility files
source("util/subject.R")
source("util/read_data.R")
source("util/write_data.R")
source("util/plot.R")

print("===================")
print("Running RQ 1 script")

# Read data
print("Reading data")
rq1.dataframe <- experiment.source.runtime()

# Take the duration time per subject and write to file
print("Summarizing runtime duration")
rq1.summary.run.duration <- experiment.subject.summary(dataframe = rq1.dataframe, property = "run.duration.s")
rq1.summary.run.duration <- rq1.summary.run.duration[-c(2, 3, 5),]
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.run.duration),
                       file_name = "summary-duration.tex",
                       caption = "Overview of the runtime duration.",
                       label = "tab:results:rq1:summary:duration")

# Take the duration time per subject and write to file
print("Summarizing battery consumption")
rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.nonzero.joule != 0
rq1.summary.trepn.battery.nonzero.joule <- experiment.subject.summary(dataframe = rq1.dataframe[rq1.filter.non_zero_battery,],
                                                                      property = "trepn.battery.nonzero.joule")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.battery.nonzero.joule),
                       file_name = "summary-battery.tex",
                       caption = "Overview of the battery consumption.",
                       label = "tab:results:rq1:summary:battery")

# Take the duration time per subject and write to file
print("Summarizing CPU load")
rq1.summary.trepn.cpu <- experiment.subject.summary(dataframe = rq1.dataframe, property = "trepn.cpu")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.cpu),
                       file_name = "summary-cpu.tex",
                       caption = "Overview of the CPU load.",
                       label = "tab:results:rq1:summary:cpu")

# Take the duration time per subject and write to file
print("Summarizing memory consumption")
rq1.summary.android.memory.mb <- experiment.subject.summary(dataframe = rq1.dataframe, property = "android.memory.mb")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.android.memory.mb),
                       file_name = "summary-memory.tex",
                       caption = "Overview of the memory consumption.",
                       label = "tab:results:rq1:summary:memory")

# Make plots of the data
print("Generating plots")

my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                   "trepn.battery.nonzero.joule",
                                   "Battery comsumption (J)",
                                   "Battery comsumption per subject")
experiment.write.plot(filename = "boxplot_battery_per_subject_treatment.png", rq = 1)


my_plot <- experiment.plot.violin(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Battery comsumption (J)",
                                  "Battery comsumption per treatment")
experiment.write.plot(filename = "violin_battery_per_treatment.png", rq = 1)

my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "trepn.cpu",
                                   "CPU load (%)",
                                   "CPU load per subject",
                                   axis_y_max = 100)
experiment.write.plot(filename = "boxplot_cpu_per_subject_treatment.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load per treatment",
                                  axis_y_max = 100)
experiment.write.plot(filename = "violin_cpu_per_treatment.png", rq = 1)