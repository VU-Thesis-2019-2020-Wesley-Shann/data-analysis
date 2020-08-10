# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

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
rq1.dataframe <- experiment.source.runtime()

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################


################################  Phase 1a Descriptive statistics ###############################
print("Phase 1. Data exploration")

rq1.filter.non_zero_battery <- rq1.dataframe$trepn.battery.nonzero.joule != 0

rq1.summary.treatment.duration <- experiment.treatment.summary(dataframe = rq1.dataframe, property = "run.duration.s", digits = 2)
rq1.summary.treatment.duration <- rq1.summary.treatment.duration[-c(2, 3, 4, 5),]
rownames(rq1.summary.treatment.duration) <- paste("Duration (s)", rownames(rq1.summary.treatment.duration))

rq1.summary.treatment.battery <- experiment.treatment.summary(dataframe = rq1.dataframe[rq1.filter.non_zero_battery,], property = "trepn.battery.nonzero.joule", digits = 2)
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.treatment.battery),
                       filename = "summary-treatment_battery.tex",)
rownames(rq1.summary.treatment.battery) <- paste("Battery consumtpion (J)", rownames(rq1.summary.treatment.battery))

rq1.summary.treatment.cpu <- experiment.treatment.summary(dataframe = rq1.dataframe, property = "trepn.cpu", digits = 2)
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.treatment.cpu),
                       filename = "summary-treatment_cpu.tex",)
rownames(rq1.summary.treatment.cpu) <- paste("CPU load (%)", rownames(rq1.summary.treatment.cpu))

rq1.summary.treatment.memory <- experiment.treatment.summary(dataframe = rq1.dataframe, property = "android.memory.mb", digits = 4)
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.treatment.memory),
                       filename = "summary-treatment_mmeory.tex",)
rownames(rq1.summary.treatment.memory) <- paste("Memory consumption (MB)", rownames(rq1.summary.treatment.memory))

rq1.summary.treatment.aggregate <- rbind(
  rq1.summary.treatment.duration,
  rq1.summary.treatment.battery,
  rq1.summary.treatment.memory,
  rq1.summary.treatment.cpu
)
rq1.summary.treatment.aggregate

experiment.write.latex(rq = 1,
                       dataframe = rq1.summary.treatment.aggregate,
                       filename = "summary_treatment.tex",
                       caption = "Overview of the runtime overhead per treatment.",
                       label = "tab:results:rq1:summary:treatment")

# Take the duration time per subject and write to file
print("Summarizing runtime duration")
rq1.summary.run.duration <- experiment.subject.summary(dataframe = rq1.dataframe, property = "run.duration.s")
rq1.summary.run.duration <- rq1.summary.run.duration[-c(2, 3, 4, 5),]
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.run.duration),
                       filename = "summary-duration.tex",
                       caption = "Overview of the runtime duration.",
                       label = "tab:results:rq1:summary:duration")
rownames(rq1.summary.run.duration) <- paste("Duration (s)", rownames(rq1.summary.run.duration))

# Take the duration time per subject and write to file
print("Summarizing battery consumption")
rq1.summary.trepn.battery.nonzero.joule <- experiment.subject.summary(dataframe = rq1.dataframe[rq1.filter.non_zero_battery,],
                                                                      property = "trepn.battery.nonzero.joule")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.battery.nonzero.joule),
                       filename = "summary-battery.tex",
                       caption = "Overview of the battery consumption.",
                       label = "tab:results:rq1:summary:battery")
rownames(rq1.summary.trepn.battery.nonzero.joule) <- paste("Battery consumtpion (J)", rownames(rq1.summary.trepn.battery.nonzero.joule))

# Take the duration time per subject and write to file
print("Summarizing CPU load")
rq1.summary.trepn.cpu <- experiment.subject.summary(dataframe = rq1.dataframe, property = "trepn.cpu")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.trepn.cpu),
                       filename = "summary-cpu.tex",
                       caption = "Overview of the CPU load.",
                       label = "tab:results:rq1:summary:cpu")
rownames(rq1.summary.trepn.cpu) <- paste("CPU load (%)", rownames(rq1.summary.trepn.cpu))

# Take the duration time per subject and write to file
print("Summarizing memory consumption")
rq1.summary.android.memory.mb <- experiment.subject.summary(dataframe = rq1.dataframe, property = "android.memory.mb")
experiment.write.latex(rq = 1,
                       dataframe = t(rq1.summary.android.memory.mb),
                       filename = "summary-memory.tex",
                       caption = "Overview of the memory consumption.",
                       label = "tab:results:rq1:summary:memory")
rownames(rq1.summary.android.memory.mb) <- paste("Memory consumption (MB)", rownames(rq1.summary.android.memory.mb))

rq3.summary.subject.aggregate <- rbind(
  rq1.summary.run.duration,
  rq1.summary.trepn.battery.nonzero.joule,
  rq1.summary.android.memory.mb,
  rq1.summary.trepn.cpu

)
rq3.summary.subject.aggregate

experiment.write.latex(rq = 1,
                       digits = 2,
                       dataframe = rq3.summary.subject.aggregate,
                       filename = "summary_subject.tex",
                       caption = "Overview of the runtime overhead per subject.",
                       label = "tab:results:rq3:summary:subject")

#######################################  Phase 1b Plots ########################################
print("Generating plots")
# Battery
my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                   "trepn.battery.nonzero.joule",
                                   "Energy consumption (J)",
                                   "Energy consumption") +
  expand_limits(x = 0)
experiment.write.plot(filename = "boxplot_battery.png", rq = 1)


my_plot <- experiment.plot.violin(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Energy consumption (J)",
                                  "Energy consumption") +
  expand_limits(x = 0)
experiment.write.plot(filename = "violin_battery.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe[rq1.filter.non_zero_battery,],
                                    "trepn.battery.nonzero.joule",
                                    "Energy consumption (J)",
                                    "Energy consumption")
experiment.write.plot(filename = "freqpoly_battery.png", rq = 1)


# CPU
my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "trepn.cpu",
                                   "CPU load (%)",
                                   "CPU load") +
  expand_limits(x = c(0, 100))
experiment.write.plot(filename = "boxplot_cpu.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load") +
  expand_limits(x = c(0, 100))
experiment.write.plot(filename = "violin_cpu.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "trepn.cpu",
                                    "CPU load (%)",
                                    "CPU load")
experiment.write.plot(filename = "freqpoly_cpu.png", rq = 1)

# Memory
my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption") +
  expand_limits(x = 0)
experiment.write.plot(filename = "boxplot_memory.png", rq = 1)

my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.dataframe$android.memory.mb < 200,],
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption")
experiment.write.plot(filename = "boxplot_memory_below_200.png", rq = 1)

my_plot <- experiment.plot.boxplot(rq1.dataframe[rq1.dataframe$android.memory.mb > 200,],
                                   "android.memory.mb",
                                   "Memory consumption (MB)",
                                   "Memory consumption")
experiment.write.plot(filename = "boxplot_memory_above_200.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "android.memory.mb",
                                  "Memory consumption (MB)",
                                  "Memory consumption") +
  expand_limits(x = 0)
experiment.write.plot(filename = "violin_memory.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "android.memory.mb",
                                    "Memory consumption (MB)",
                                    "Memory consumption")
experiment.write.plot(filename = "freqpoly_memory.png", rq = 1)

for (subject in levels(rq1.dataframe$subject.name)) {
  for (part in c(1, 2, 3)) {
    my_plot <- experiment.plot.line(dataframe = rq1.dataframe[rq1.dataframe$experiment.part == part &
                                                                rq1.dataframe$subject.name == subject,],
                                    axis_y_column = "android.memory.mb",
                                    axis_y_legend = "Memory consumption (MB)")
    experiment.write.plot(filename = paste0("memory_over_runs_", subject, "_part_", part, ".png"), rq = 1)
  }
}


#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
#################################################################################################
print("Phase 2. Normality Check and Data Transformation")

##################################  Phase 2a Normality check ####################################
print("Check normality")
# Battery
my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Energy consumption (J)",
                                  "Energy consumption")
experiment.write.plot(filename = "qqplot_battery.png", rq = 1)

shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule)
#W = 0.96404, p-value = 2.743e-11

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule),
                      filename = "test_shapiro_battery.txt",
                      rq = 1)

# CPU
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load")
experiment.write.plot(filename = "qqplot_cpu.png", rq = 1)

shapiro.test(rq1.dataframe$trepn.cpu)
#W = 0.90465, p-value < 2.2e-16

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu),
                      filename = "test_shapiro_cpu.txt",
                      rq = 1)

# Memory
#W = 0.68972, p-value < 2.2e-16
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "android.memory.mb",
                                  "Memory consumption (MB)",
                                  "Memory consumption")
experiment.write.plot(filename = "qqplot_memory.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$android.memory.mb),
                      filename = "test_shapiro_memory.txt",
                      rq = 1)

##################################  Phase 2a Data Transformation ####################################
print("Transform data")
# https://www.datanovia.com/en/lessons/transform-data-to-normal-distribution-in-r/
# https://rcompanion.org/handbook/I_12.html

# Metric      Method        p-value     is normal (p-value > 0.05)
# -----       ------        -------     --------------------------
# Battery     N/A           2.743e-11   no
# Battery     sqrt          0.5963      yes
# CPU         N/A           2.2e-16     no
# CPU         tukey         4.159e-06   no
# Memory      N/A           2.2e-16     no
# Memory      cube root     4.445e-12   no

# Battery ~ Natural log
rq1.dataframe$trepn.battery.nonzero.joule.log <- log(rq1.dataframe$trepn.battery.nonzero.joule)
shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.log)
# W = 0.95054, p-value = 1.138e-13

# Battery ~ squared
rq1.dataframe$trepn.battery.nonzero.joule.square <- rq1.dataframe$trepn.battery.nonzero.joule^2
shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.square)
# W = 0.78785, p-value < 2.2e-16

# Battery ~ square root
rq1.dataframe$trepn.battery.nonzero.joule.sqrt <- sqrt(rq1.dataframe$trepn.battery.nonzero.joule)
shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.sqrt)
# W = 0.99781, p-value = 0.5963

# Battery ~ cube root
rq1.dataframe$trepn.battery.nonzero.joule.cube <- sign(rq1.dataframe$trepn.battery.nonzero.joule) * abs(rq1.dataframe$trepn.battery.nonzero.joule)^(1 / 3)
shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.cube)
# W = 0.99345, p-value = 0.007739

# Battery ~ inverse
rq1.dataframe$trepn.battery.nonzero.joule.inverse <- 1 / rq1.dataframe$trepn.battery.nonzero.joule
shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.inverse)
# W = 0.48163, p-value < 2.2e-16

# Battery ~ Tukey’s Ladder of Powers transformation
# https://rcompanion.org/handbook/I_12.html#_Toc459550901
my_data <- transformTukey(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule, plotit = FALSE)
# We are dropping the row with 0 reading, so we can't return this to the original dataframe
#    lambda      W Shapiro.p.value
#437    0.9 0.9978          0.5687
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(my_data)
# W = 0.99766, p-value = 0.533

Box <- boxcox(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
#   Box.x     Box.y
#66   0.5 -1717.346
lambda <- Cox2[1, "Box.x"]
my_data <- (rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule^lambda - 1) / lambda
shapiro.test(my_data)
#W = 0.99781, p-value = 0.5963


# CPU ~ Natural log
rq1.dataframe$trepn.cpu.log <- log(rq1.dataframe$trepn.cpu)
shapiro.test(rq1.dataframe$trepn.cpu.log)
# W = 0.97682, p-value = 1.951e-08

# CPU ~ squared
rq1.dataframe$trepn.cpu.squared <- rq1.dataframe$trepn.cpu^2
shapiro.test(rq1.dataframe$trepn.cpu.squared)
# W = 0.79024, p-value < 2.2e-16

# CPU ~ square root
rq1.dataframe$trepn.cpu.sqrt <- sqrt(rq1.dataframe$trepn.cpu)
shapiro.test(rq1.dataframe$trepn.cpu.sqrt)
# W = 0.94853, p-value = 5.342e-14

# CPU ~ cube root
rq1.dataframe$trepn.cpu.cube <- sign(rq1.dataframe$trepn.cpu) * abs(rq1.dataframe$trepn.cpu)^(1 / 3)
shapiro.test(rq1.dataframe$trepn.cpu.cube)
# W = 0.96004, p-value = 4.762e-12

# CPU ~ inverse
rq1.dataframe$trepn.cpu.inverse <- 1 / rq1.dataframe$trepn.cpu
shapiro.test(rq1.dataframe$trepn.cpu.inverse)
# W = 0.96685, p-value = 9.854e-11

# CPU ~ Tukey’s Ladder of Powers transformation
rq1.dataframe$trepn.cpu.tukey <- transformTukey(rq1.dataframe$trepn.cpu, plotit = FALSE)
#    lambda      W Shapiro.p.value
#384 -0.425 0.9849       4.159e-06
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(rq1.dataframe$trepn.cpu.tukey)
# W = 0.98488, p-value = 4.159e-06

# CPU ~ Box–Cox transformation
# https://rcompanion.org/handbook/I_12.html#_Toc459550904
Box <- boxcox(rq1.dataframe$trepn.cpu ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
#   Box.x     Box.y
#57  -0.4 -1241.318
lambda <- Cox2[1, "Box.x"]
rq1.dataframe$trepn.cpu.box <- (rq1.dataframe$trepn.cpu^lambda - 1) / lambda
shapiro.test(rq1.dataframe$trepn.cpu.box)
# W = 0.98487, p-value = 4.128e-06


# Memory ~ Natural log
rq1.dataframe$android.memory.mb.log <- log(rq1.dataframe$android.memory.mb)
shapiro.test(rq1.dataframe$android.memory.mb.log)
# W = 0.73568, p-value < 2.2e-16

# Memory ~ squared
rq1.dataframe$android.memory.mb.squared <- rq1.dataframe$android.memory.mb^2
shapiro.test(rq1.dataframe$android.memory.mb.squared)
# W = 0.64154, p-value < 2.2e-16

# Memory ~ square root
rq1.dataframe$android.memory.mb.sqrt <- sqrt(rq1.dataframe$android.memory.mb)
shapiro.test(rq1.dataframe$android.memory.mb.sqrt)
# 0.71323, p-value < 2.2e-16

# Memory ~ cube root
rq1.dataframe$android.memory.mb.cube <- sign(rq1.dataframe$android.memory.mb) * abs(rq1.dataframe$trepn.cpu)^(1 / 3)
shapiro.test(rq1.dataframe$android.memory.mb.cube)
# 0.95994, p-value = 4.445e-12

# Memory ~ inverse
rq1.dataframe$android.memory.mb.inverse <- 1 / rq1.dataframe$android.memory.mb
shapiro.test(rq1.dataframe$android.memory.mb.inverse)
# 0.77604, p-value < 2.2e-16

# Memory ~ Tukey’s Ladder of Powers transformation
rq1.dataframe$android.memory.mb.tukey <- transformTukey(rq1.dataframe$android.memory.mb, plotit = FALSE)
#    lambda      W Shapiro.p.value
#110 -7.275 0.8828       2.019e-21
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(rq1.dataframe$android.memory.mb.tukey)
# W = 0.88275, p-value < 2.2e-16

# Memory ~ Box–Cox transformation
# https://rcompanion.org/handbook/I_12.html#_Toc459550904
Box <- boxcox(rq1.dataframe$android.memory.mb ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
#   Box.x     Box.y
#25  -3.6 -1036.238
lambda <- Cox2[1, "Box.x"]
rq1.dataframe$android.memory.mb.box <- (rq1.dataframe$android.memory.mb^lambda - 1) / lambda
shapiro.test(rq1.dataframe$android.memory.mb.box)
# W = 0.84861, p-value < 2.2e-16

# Plot best cases

# Battery ~ sqrt
my_plot <- experiment.plot.freqpoly(rq1.dataframe[rq1.filter.non_zero_battery,],
                                    "trepn.battery.nonzero.joule.sqrt",
                                    "Energy consumption (J) (square root)",
                                    "Transformed (square root) Energy consumption")
experiment.write.plot(filename = "freqpoly_battery_sqrt.png", rq = 1)

my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule.sqrt",
                                  "Energy consumption (J) (square root)",
                                  "Transformed (square root) Energy consumption")
experiment.write.plot(filename = "qqplot_battery_sqrt.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule.sqrt),
                      filename = "test_shapiro_battery_sqrt.txt",
                      rq = 1)


# CPU ~ tukey
my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "trepn.cpu.tukey",
                                    "CPU load (%) (Tukey's)",
                                    "Transformed (Tukey's) CPU load")
experiment.write.plot(filename = "freqpoly_cpu_tukey.png", rq = 1)

my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu.tukey",
                                  "CPU load (%) (Tukey's)",
                                  "Transformed (Tukey's) CPU load")
experiment.write.plot(filename = "qqplot_cpu_tukey.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu.tukey),
                      filename = "test_shapiro_cpu_tukey.txt",
                      rq = 1)


# Memory ~ cube root
my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "android.memory.mb.cube",
                                    "Memory consumption (MB) (cube root)",
                                    "Transformed (cube root) Memory consumption")
experiment.write.plot(filename = "freqpoly_memory_cube_root.png", rq = 1)

my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "android.memory.mb.cube",
                                  "Memory consumption (MB) (cube root)",
                                  "Transformed (cube root) Memory consumption")
experiment.write.plot(filename = "qqplot_memory_cube_root.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$android.memory.mb.cube),
                      filename = "test_shapiro_memory_cube_root.txt",
                      rq = 1)

#################################################################################################
#################################### Phase 3: Hypothesis Test ###################################
#################################################################################################
print("Phase 3. Hypothesis Test")

# Green Lab 2019-202 edition, slide 9A
# http://www.sthda.com/english/wiki/wiki.php?title=one-way-anova-test-in-r
# http://www.sthda.com/english/wiki/kruskal-wallis-test-in-r
# https://stats.stackexchange.com/questions/360496/how-do-you-interpret-the-cliffs-delta-95-confidence-interval-2%E2%88%92tailed-grap

# Hypothesistest
# Metric      Test              p-value     is H0 rejected (p-value < 0.05)
# -----       ------            -------     --------------------------
# Battery     One way ANOVA     0.7757      no
# CPU         Kruskal-Wallis    0.6747      no
# Memory      Kruskal-Wallis    3.122e-11   yes (baseline ~ greedy; baseline ~ TFPR)

########################################## 3a: Battery #########################################

# Battery ~ sqrt ~ normal ~ ANOVA
rq1.hypothesis.battery.aov <- aov(trepn.battery.nonzero.joule.sqrt ~ subject.treatment.id, data = rq1.dataframe[rq1.filter.non_zero_battery,])
summary(rq1.hypothesis.battery.aov)
#                      Df Sum Sq Mean Sq F value Pr(>F)
#subject.treatment.id   2      7   3.294   0.254  0.776
#Residuals            626   8114  12.961
#The p-value for testing H_0: mu_1 = mu_2 = mu_3 is 0.776: H_0 is not rejected
experiment.write.latex(dataframe = summary(rq1.hypothesis.battery.aov),
                       rq = 1,
                       digits = 4,
                       filename = "hypothesis_battery_anova.tex",
                       label = "tab:hypothesis:battery:anova",
                       caption = "Analysis of Variance for the linear model explaining the transformed (square root) battery consumption (J) using the prefetching treatment.")


TukeyHSD(rq1.hypothesis.battery.aov)
#  Tukey multiple comparisons of means
#    95% family-wise confidence level
#
#Fit: aov(formula = trepn.battery.nonzero.joule.sqrt ~ subject.treatment.id, data = rq1.dataframe[rq1.filter.non_zero_battery, ])
#
#$subject.treatment.id
#                             diff        lwr       upr     p adj
#nappagreedy-baseline   0.23466031 -0.5917385 1.0610592 0.7826854
#nappatfpr-baseline     0.04050116 -0.7849109 0.8659133 0.9927008
#nappatfpr-nappagreedy -0.19415915 -1.0205580 0.6322397 0.8455113

#diff: difference between means of the two groups
#lwr, upr: the lower and the upper end point of the confidence interval at 95% (default)
#p adj: p-value after adjustment for the multiple comparisons.

experiment.write.text(data = TukeyHSD(rq1.hypothesis.battery.aov),
                      rq = 1,
                      filename = "hypothesis_battery_tukey.tex")

############################################ 3b: CPU ###########################################

# CPU ~ not normal ~ Kruskal-Wallis
rq1.hypothesis.cpu.result <- kruskal.test(trepn.cpu ~ subject.treatment.id, data = rq1.dataframe)
#	Kruskal-Wallis rank sum test
#
#data:  trepn.cpu by subject.treatment.id
#Kruskal-Wallis chi-squared = 0.78683, df = 2, p-value = 0.6747
# kruskal.test performs the Kruskal-Wallis test and yields a p-value.
# The p-value for testing H_0 : F_1 = F_2 = F_3 is 0.6747: H_0 is not rejected.
experiment.write.text(data = rq1.hypothesis.cpu.result,
                      rq = 1,
                      filename = "hypothesis_cpu_kruskal.txt")


# From the output of the Kruskal-Wallis test,
# we know that there is a significant difference between groups,
# but we don’t know which pairs of groups are different.
# It’s possible to use the function pairwise.wilcox.test()
# to calculate pairwise comparisons between group levels with corrections for multiple testing.
rq1.hypothesis.cpu.holm <- pairwise.wilcox.test(rq1.dataframe$trepn.cpu, rq1.dataframe$subject.treatment.id)
#	Pairwise comparisons using Wilcoxon rank sum test with continuity correction
#
#data:  rq1.dataframe$android.memory.mb and rq1.dataframe$subject.treatment.id
#
#            baseline nappagreedy
#nappagreedy 1.8e-08  -
#nappatfpr   2.5e-09  0.14
#
#P value adjustment method: holm
# The pairwise comparison shows that,
#   baseline and greedy are differet (p < 0.05).
#   baseline and TFPR are differet (p < 0.05).

experiment.write.text(data = rq1.hypothesis.cpu.holm,
                      rq = 1,
                      filename = "hypothesis_cpu_holm.txt")

rq1.hypothesis.cpu.bonferroni <- pairwise.wilcox.test(rq1.dataframe$trepn.cpu, rq1.dataframe$subject.treatment.id, p.adjust.method = "bonferroni")
#
#	Pairwise comparisons using Wilcoxon rank sum test with continuity correction
#
#data:  rq1.dataframe$trepn.cpu and rq1.dataframe$subject.treatment.id
#
#            baseline nappagreedy
#nappagreedy 1        -
#nappatfpr   1        1
#
#P value adjustment method: bonferroni

experiment.write.text(data = rq1.hypothesis.cpu.bonferroni,
                      rq = 1,
                      filename = "hypothesis_cpu_bonferroni.txt")


########################################### 3c: Memory ##########################################

# Memory ~ not normal ~ Kruskal-Wallis
rq1.hypothesis.memory.result <- kruskal.test(android.memory.mb ~ subject.treatment.id, data = rq1.dataframe)
#	Kruskal-Wallis rank sum test
#
#data:  android.memory.mb by subject.treatment.id
#Kruskal-Wallis chi-squared = 48.38, df = 2, p-value = 3.122e-11
experiment.write.text(data = rq1.hypothesis.memory.result,
                      rq = 1,
                      filename = "hypothesis_memory_kruskal.txt")

# www.sthda.com/english/wiki/kruskal-wallis-test-in-r
# From the output of the Kruskal-Wallis test,
# we know that there is a significant difference between groups,
# but we don’t know which pairs of groups are different.
# It’s possible to use the function pairwise.wilcox.test()
# to calculate pairwise comparisons between group levels with corrections for multiple testing.
rq1.hypothesis.memory.holm <- pairwise.wilcox.test(rq1.dataframe$android.memory.mb, rq1.dataframe$subject.treatment.id)
#	Pairwise comparisons using Wilcoxon rank sum test with continuity correction
#
#data:  rq1.dataframe$android.memory.mb and rq1.dataframe$subject.treatment.id
#
#            baseline nappagreedy
#nappagreedy 1.8e-08  -
#nappatfpr   2.5e-09  0.14
#
#P value adjustment method: holm
# The pairwise comparison shows that,
#   baseline and greedy are differet (p < 0.05).
#   baseline and TFPR are differet (p < 0.05).

experiment.write.text(data = rq1.hypothesis.memory.holm,
                      rq = 1,
                      filename = "hypothesis_memory_holm.txt")

rq1.hypothesis.memory.bonferroni <- pairwise.wilcox.test(rq1.dataframe$android.memory.mb, rq1.dataframe$subject.treatment.id, p.adjust.method = "bonferroni")
#	Pairwise comparisons using Wilcoxon rank sum test with continuity correction
#
#data:  rq1.dataframe$android.memory.mb and rq1.dataframe$subject.treatment.id
#
#            baseline nappagreedy
#nappagreedy 2.7e-08  -
#nappatfpr   2.5e-09  0.42
#
#P value adjustment method: bonferroni

experiment.write.text(data = rq1.hypothesis.memory.bonferroni,
                      rq = 1,
                      filename = "hypothesis_memory_bonferroni.txt")


# Computes the Cliff's Delta effect size for ordinal variables with the related confidence interval using efficient algorithms.
rq1.hypothesis.memory.cliff.baseline_greedy <- cliff.delta(
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "baseline", "android.memory.mb"],
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "nappagreedy", "android.memory.mb"])
#Cliff's Delta
#
#delta estimate: -0.3243537 (small)
#95 percent confidence interval:
#     lower      upper
#-0.4311086 -0.2086435

rq1.hypothesis.memory.cliff.baseline_tfpr <- cliff.delta(
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "baseline", "android.memory.mb"],
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "nappatfpr", "android.memory.mb"])
#Cliff's Delta
#
#delta estimate: -0.3461678 (medium)
#95 percent confidence interval:
#     lower      upper
#-0.4510444 -0.2318614

rq1.hypothesis.memory.cliff.greedy_tfpr <- cliff.delta(
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "nappagreedy", "android.memory.mb"],
  rq1.dataframe[rq1.dataframe$subject.treatment.id == "nappatfpr", "android.memory.mb"])
#Cliff's Delta
#
#delta estimate: -0.08353741 (negligible)
#95 percent confidence interval:
#      lower       upper
#-0.19135289  0.02626994

experiment.write.text(data = rq1.hypothesis.memory.cliff.baseline_greedy,
                      rq = 1,
                      filename = "hypothesis_memory_cliff_baseline_greedy.txt")

experiment.write.text(data = rq1.hypothesis.memory.cliff.baseline_tfpr,
                      rq = 1,
                      filename = "hypothesis_memory_cliff_baseline_tfpr.txt")

experiment.write.text(data = rq1.hypothesis.memory.cliff.greedy_tfpr,
                      rq = 1,
                      filename = "hypothesis_memory_cliff_greedy_tfpr.txt")
