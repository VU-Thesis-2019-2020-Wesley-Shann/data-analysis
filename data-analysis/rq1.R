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

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################


################################  Phase 1a Descriptive statistics ###############################
print("Phase 1. Data exploration")
# Take the duration time per subject and write to file
print("Summarizing runtime duration")
rq1.summary.run.duration <- experiment.subject.summary(dataframe = rq1.dataframe, property = "run.duration.s")
rq1.summary.run.duration <- rq1.summary.run.duration[-c(2, 3, 5),]
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.run.duration),
                       filename = "summary-duration.tex",
                       caption = "Overview of the runtime duration.",
                       label = "tab:results:rq1:summary:duration")

# Take the duration time per subject and write to file
print("Summarizing battery consumption")
rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.nonzero.joule != 0
rq1.summary.trepn.battery.nonzero.joule <- experiment.subject.summary(dataframe = rq1.dataframe[rq1.filter.non_zero_battery,],
                                                                      property = "trepn.battery.nonzero.joule")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.battery.nonzero.joule),
                       filename = "summary-battery.tex",
                       caption = "Overview of the battery consumption.",
                       label = "tab:results:rq1:summary:battery")

# Take the duration time per subject and write to file
print("Summarizing CPU load")
rq1.summary.trepn.cpu <- experiment.subject.summary(dataframe = rq1.dataframe, property = "trepn.cpu")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.cpu),
                       filename = "summary-cpu.tex",
                       caption = "Overview of the CPU load.",
                       label = "tab:results:rq1:summary:cpu")

# Take the duration time per subject and write to file
print("Summarizing memory consumption")
rq1.summary.android.memory.mb <- experiment.subject.summary(dataframe = rq1.dataframe, property = "android.memory.mb")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.android.memory.mb),
                       filename = "summary-memory.tex",
                       caption = "Overview of the memory consumption.",
                       label = "tab:results:rq1:summary:memory")

#######################################  Phase 1b Plots ########################################
print("Generating plots")
# Battery
my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                   "trepn.battery.nonzero.joule",
                                   "Battery comsumption (J)",
                                   "Battery comsumption per subject")
experiment.write.plot(filename = "boxplot_battery_per_subject_treatment.png", rq = 1)


my_plot <- experiment.plot.violin(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Battery comsumption (J)",
                                  "Battery comsumption") +
  expand_limits(y = 0)
experiment.write.plot(filename = "violin_battery_per_treatment.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe[rq1.filter.non_zero_battery,],
                                    "trepn.battery.nonzero.joule",
                                    "Battery comsumption (J)",
                                    "Battery comsumption")
experiment.write.plot(filename = "freqpoly_battery_per_treatment.png", rq = 1)


# CPU
my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "trepn.cpu",
                                   "CPU load (%)",
                                   "CPU load per subject") +
  expand_limits(y = c(0, 100))
experiment.write.plot(filename = "boxplot_cpu_per_subject_treatment.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load") +
  expand_limits(y = c(0, 100))
experiment.write.plot(filename = "violin_cpu_per_treatment.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "trepn.cpu",
                                    "CPU load (%)",
                                    "CPU load")
experiment.write.plot(filename = "freqpoly_cpu_per_treatment.png", rq = 1)

# Memory
my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption per subject")
experiment.write.plot(filename = "boxplot_memory_per_subject_treatment.png", rq = 1)

my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.dataframe$android.memory.mb < 200,],
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption per subject")
experiment.write.plot(filename = "boxplot_memory_per_subject_treatment_below_200.png", rq = 1)

my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.dataframe$android.memory.mb > 200,],
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption per subject")
experiment.write.plot(filename = "boxplot_memory_per_subject_treatment_above_200.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "android.memory.mb",
                                  "Memory consumption (MB)",
                                  "Memory consumption") +
  expand_limits(y = 0)
experiment.write.plot(filename = "violin_memory_per_treatment.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "android.memory.mb",
                                    "Memory consumption (MB)",
                                    "Memory consumption")
experiment.write.plot(filename = "freqpoly_memory_per_treatment.png", rq = 1)


#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
#################################################################################################
print("Phase 2. Normality Check and Data Transformation")

##################################  Phase 2a Normality check ####################################
print("Check normality")
# Battery
my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Battery comsumption (J)",
                                  "Battery comsumption")
experiment.write.plot(filename = "qqplot_battery_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule),
                      filename = "test_shapiro_battery.txt",
                      rq = 1)

# CPU
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load")
experiment.write.plot(filename = "qqplot_cpu_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu),
                      filename = "test_shapiro_cpu.txt",
                      rq = 1)

# Memory
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "android.memory.mb",
                                  "Memory consumption (MB)",
                                  "Memory consumption")
experiment.write.plot(filename = "qqplot_memory_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$android.memory.mb),
                      filename = "test_shapiro_memory.txt",
                      rq = 1)

##################################  Phase 2a Data Transformation ####################################
print("Transform data")

# Battery ~ log
rq1.dataframe$trepn.battery.nonzero.joule.log <- log(rq1.dataframe$trepn.battery.nonzero.joule)
my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule.log",
                                  "Battery comsumption (J) (logarithm)",
                                  "Transformed (logarithm) Battery comsumption")
experiment.write.plot(filename = "qqplot_battery_log_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.log),
                      filename = "test_shapiro_battery_log.txt",
                      rq = 1)
# Battery ~ squared
rq1.dataframe$trepn.battery.nonzero.joule.square <- rq1.dataframe$trepn.battery.nonzero.joule^2
my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule.square",
                                  "Battery comsumption (J) (squared)",
                                  "Transformed (squared) Battery comsumption")
experiment.write.plot(filename = "qqplot_battery_square_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.square),
                      filename = "test_shapiro_battery_square.txt",
                      rq = 1)



# Battery ~ square root
rq1.dataframe$trepn.battery.nonzero.joule.sqrt <- sqrt(rq1.dataframe$trepn.battery.nonzero.joule)
my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule.log",
                                  "Battery comsumption (J) (square root)",
                                  "Transformed (square root) Battery comsumption")
experiment.write.plot(filename = "qqplot_battery_sqrt_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.sqrt),
                      filename = "test_shapiro_battery_sqrt.txt",
                      rq = 1)

# CPU ~ log
rq1.dataframe$trepn.cpu.log <- log(rq1.dataframe$trepn.cpu)
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu.log",
                                  "CPU load (%) (logarithm)",
                                  "Transformed (logarithm) CPU load")
experiment.write.plot(filename = "qqplot_cpu_log_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu.log),
                      filename = "test_shapiro_cpu_log.txt",
                      rq = 1)
# CPU ~ squared
rq1.dataframe$trepn.cpu.squared <- rq1.dataframe$trepn.cpu^2
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu.squared",
                                  "CPU load (%) (squared)",
                                  "Transformed (squared) CPU load")
experiment.write.plot(filename = "qqplot_cpu_squared_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu.squared),
                      filename = "test_shapiro_cpu_squared.txt",
                      rq = 1)

# CPU ~ square root
rq1.dataframe$trepn.cpu.sqrt <- sqrt(rq1.dataframe$trepn.cpu)
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu.sqrt",
                                  "CPU load (%) (square root)",
                                  "Transformed (square root) CPU load")
experiment.write.plot(filename = "qqplot_cpu_sqrt_per_treatment.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu.sqrt),
                      filename = "test_shapiro_cpu_sqrt.txt",
                      rq = 1)