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
                                   "Battery comsumption")
experiment.write.plot(filename = "boxplot_battery.png", rq = 1)


my_plot <- experiment.plot.violin(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule",
                                  "Battery comsumption (J)",
                                  "Battery comsumption") +
  expand_limits(y = 0)
experiment.write.plot(filename = "violin_battery.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe[rq1.filter.non_zero_battery,],
                                    "trepn.battery.nonzero.joule",
                                    "Battery comsumption (J)",
                                    "Battery comsumption")
experiment.write.plot(filename = "freqpoly_battery.png", rq = 1)


# CPU
my_plot <- experiment.plot.boxplot(rq1.dataframe,
                                   "trepn.cpu",
                                   "CPU load (%)",
                                   "CPU load") +
  expand_limits(y = c(0, 100))
experiment.write.plot(filename = "boxplot_cpu.png", rq = 1)

my_plot <- experiment.plot.violin(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load") +
  expand_limits(y = c(0, 100))
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
                                   "Memory consumption")
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
  expand_limits(y = 0)
experiment.write.plot(filename = "violin_memory.png", rq = 1)

my_plot <- experiment.plot.freqpoly(rq1.dataframe,
                                    "android.memory.mb",
                                    "Memory consumption (MB)",
                                    "Memory consumption")
experiment.write.plot(filename = "freqpoly_memory.png", rq = 1)


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
experiment.write.plot(filename = "qqplot_battery.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe[rq1.filter.non_zero_battery,]$trepn.battery.nonzero.joule),
                      filename = "test_shapiro_battery.txt",
                      rq = 1)

# CPU
my_plot <- experiment.plot.qqplot(rq1.dataframe,
                                  "trepn.cpu",
                                  "CPU load (%)",
                                  "CPU load")
experiment.write.plot(filename = "qqplot_cpu.png", rq = 1)

experiment.write.text(data = shapiro.test(rq1.dataframe$trepn.cpu),
                      filename = "test_shapiro_cpu.txt",
                      rq = 1)

# Memory
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
# Battery     sqrt          0.5963      yes
# CPU         tukey         4.159e-06   no
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
                                    "Battery comsumption (J) (square root)",
                                    "Transformed (square root) Battery comsumption")
experiment.write.plot(filename = "freqpoly_battery_sqrt.png", rq = 1)

my_plot <- experiment.plot.qqplot(rq1.dataframe[rq1.filter.non_zero_battery,],
                                  "trepn.battery.nonzero.joule.sqrt",
                                  "Battery comsumption (J) (square root)",
                                  "Transformed (square root) Battery comsumption")
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

# Metric      Test              p-value     is H0 rejected (p-value < 0.05)
# -----       ------            -------     --------------------------
# Battery     One way ANOVA     0.7757      no
# CPU         Kruskal-Wallis
# Memory      Kruskal-Wallis

########################################## 3a: Battery #########################################

# Battery ~ sqrt ~ normal ~ ANOVA
rq1.hypothesis.battery.aov <- lm(trepn.battery.nonzero.joule.sqrt ~ subject.treatment.id, data = rq1.dataframe[rq1.filter.non_zero_battery,])
# lm creates an object of type linear model. Its properties can be extracted with other functions.
# battery∼treatment is a model formula. Read it as: “explain battery using treatment”.

rq1.hypothesis.battery.result <-anova(rq1.hypothesis.battery.aov)
#Analysis of Variance Table
#
#Response: trepn.battery.nonzero.joule.sqrt
#                      Df Sum Sq Mean Sq F value Pr(>F)
#subject.treatment.id   2    6.6  3.2939  0.2541 0.7757
#Residuals            626 8113.9 12.9615
#The p-value for testing H_0: mu_1 = mu_2 = mu_3 is 0.7757: H_0 is not rejected
experiment.write.latex(dataframe = rq1.hypothesis.battery.result,
                       rq = 1,
                       digits = 4,
                       filename = "hypothesis_battery_anova.tex",
                       label = "tab:hypothesis:battery:anova",
                       caption = "Analysis of Variance for the linear model explaining the transformed (suqare root) battery consumption (J) using the prefetching treatment.")

summary(rq1.hypothesis.battery.aov)
#Residuals:
#    Min      1Q  Median      3Q     Max
#-9.7769 -2.4115  0.0797  2.5722 11.0381
#
#Coefficients:
#                                Estimate Std. Error t value Pr(>|t|)
#(Intercept)                      12.2480     0.2484  49.300   <2e-16 ***
#subject.treatment.idnappagreedy   0.2347     0.3518   0.667    0.505
#subject.treatment.idnappatfpr     0.0405     0.3513   0.115    0.908
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 3.6 on 626 degrees of freedom
#Multiple R-squared:  0.0008113,	Adjusted R-squared:  -0.002381
#F-statistic: 0.2541 on 2 and 626 DF,  p-value: 0.7757
# estimates:
#   mu_1 = 22.2480;
#   mu_2 - mu_1 = 0.2347;
#   mu_3 - mu_1 = 0405;
# p-values:
#   (H_0 : mu_1 = 0): 2e-16;
#   (H_0 : mu_2 - mu_1 ): 0.505;
#   (H_0 : mu_3 - mu_1 ): 0.908;
experiment.write.latex(dataframe = rq1.hypothesis.battery.aov,
                       rq = 1,
                       digits = 4,
                       filename = "hypothesis_battery_summary.tex",
                       label = "tab:hypothesis:battery:summary",
                       caption = "Overview of the linear model explaining the transformed (suqare root) battery consumption (J) using the prefetching treatment.")



confint(rq1.anova.battery_aov)
#                                     2.5 %    97.5 %
#(Intercept)                     11.7601590 12.735904
#subject.treatment.idnappagreedy -0.4561203  0.925441
#subject.treatment.idnappatfpr   -0.6494547  0.730457

############################################ 3b: CPU ###########################################

# CPU ~ not normal ~ Kruskal-Wallis
rq1.test.kruskal.cpu <- kruskal.test(trepn.cpu ~ subject.treatment.id, data = rq1.dataframe)
summary(rq1.test.kruskal.cpu)

########################################### 3c: Memory ##########################################

# Memory ~ not normal ~ Kruskal-Wallis