# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 09-08-20

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

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################

rq4_2.dataframe <- experiment.source.prefetching_strategy_execution_time()

nrow(rq4_2.dataframe)
#[1] 9589

rq4_2.dataframe <- rq4_2.dataframe[!(rq4_2.dataframe$subject.id == "NewsBlur (G)" &
  rq4_2.dataframe$run.number == 9 &
  rq4_2.dataframe$experiment.part == 1),]

nrow(rq4_2.dataframe)
#[1] 9569

# Runs per subject~treatment
rq4_2.runs <- data.frame(matrix(ncol = 3))
for (subject in levels(rq4_2.dataframe$subject.name)) {
  rq4_2.runs <- rbind(
    rq4_2.runs,
    c(subject,
      nrow(rq4_2.dataframe[rq4_2.dataframe$subject.name == subject & rq4_2.dataframe$subject.treatment.id == "nappagreedy",]),
      nrow(rq4_2.dataframe[rq4_2.dataframe$subject.name == subject & rq4_2.dataframe$subject.treatment.id == "nappatfpr",])
    )
  )
}
colnames(rq4_2.runs) <- c("Subject", "Greedy", "TFPR")
#        Subject Greedy TFPR
#1          <NA>   <NA> <NA>
#2   Antenna Pod    659  660
#3     Hill'Fair   1050 1050
#4 Materialistic    809  810
#5      NewsBlur    580  600
#6     RedReader    780  780
#7   Travel Mate    651  660
#8 UOB Timetable    240  240

################################  Phase 1a Descriptive statistics ###############################

rq0.summary.treatment.duration <- experiment.treatment.summary(dataframe = rq4_2.dataframe, property = "strategy.duration.ms", digits = 2)

experiment.write.latex(rq = "4_2",
                       dataframe = t(rq0.summary.treatment.duration),
                       filename = "summary-duration.tex",
                       caption = "Overview of the strategy duration.",
                       label = "tab:results:rq0:summary:duration")

rq0.summary.subject.duration <- experiment.subject.summary(dataframe = rq4_2.dataframe, property = "strategy.duration.ms", digits = 2)

experiment.write.latex(rq = "4_2",
                       dataframe = t(rq0.summary.subject.duration),
                       filename = "summary-duration_subject.tex",
                       caption = "Overview of the strategy duration.",
                       label = "tab:results:rq0:summary:duration_subject")

#######################################  Phase 1b Plots ########################################
print("Generating plots")

my_plot <- experiment.plot.boxplot(rq4_2.dataframe,
                                   "strategy.duration.ms",
                                   "Strategy duration (ms)",
                                   "Strategy duration")
experiment.write.plot(filename = "boxplot_duration.png", rq = "4_2")

my_plot <- experiment.plot.violin(rq4_2.dataframe,
                                  "strategy.duration.ms",
                                  "Strategy duration (ms)",
                                  "Strategy duration")
experiment.write.plot(filename = "violin_duration.png", rq = "4_2")

my_plot <- experiment.plot.freqpoly(rq4_2.dataframe,
                                    "strategy.duration.ms",
                                    "Strategy duration (ms)",
                                    "Strategy duration")
experiment.write.plot(filename = "freqpoly_duration.png", rq = "4_2")


#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
#################################################################################################

print("Phase 2. Normality Check and Data Transformation")

# Metric    Method        p-value     is normal (p-value > 0.05)
# -----     ------        -------     --------------------------
# Duration  N/A           2.2e-16     no
# Duration  all           2.2e-16     no

##################################  Phase 2a Normality check ####################################
my_plot <- experiment.plot.qqplot(rq4_2.dataframe,
                                  "strategy.duration.ms",
                                  "Strategy duration (ms)",
                                  "Strategy duration")
experiment.write.plot(filename = "qqplot_duration.png", rq = "4_2")

my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms)
#W = 0.46567, p-value < 2.2e-16

experiment.write.text(data = shapiro.test(my_sample$strategy.duration.ms),
                      filename = "test_shapiro_duration_sample.txt",
                      rq = "4_2")

##################################  Phase 2a Data Transformation ####################################

# Duration ~ Natural log
rq4_2.dataframe$strategy.duration.ms.log <- log(rq4_2.dataframe$strategy.duration.ms)
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.log)
#W = 0.9156, p-value < 2.2e-16

# Duration ~ squared
rq4_2.dataframe$strategy.duration.ms.squared <- rq4_2.dataframe$strategy.duration.ms^2
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.squared)
#W = 0.19135, p-value < 2.2e-16

# Duration ~ square root
rq4_2.dataframe$strategy.duration.ms.sqrt <- sqrt(rq4_2.dataframe$strategy.duration.ms)
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.sqrt)
#W = 0.80326, p-value < 2.2e-16

# Duration ~ cube root
rq4_2.dataframe$strategy.duration.ms.cube <- sign(rq4_2.dataframe$strategy.duration.ms) * abs(rq4_2.dataframe$strategy.duration.ms)^(1 / 3)
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.cube)
# W = 0.90358, p-value < 2.2e-16

# Duration ~ inverse
rq4_2.dataframe$strategy.duration.ms.inverse <- 1 / rq4_2.dataframe$strategy.duration.ms
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.inverse)
# W = 0.59104, p-value < 2.2e-16

# Duration ~ Tukey’s Ladder of Powers transformation
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
my_sample_tukey <- transformTukey(my_sample$strategy.duration.ms, plotit = FALSE)
#    lambda      W Shapiro.p.value
#407   0.15 0.9499       2.671e-38
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(my_sample_tukey)
#W = 0.94987, p-value < 2.2e-16

# Duration ~ Box–Cox transformation
Box <- boxcox(rq4_2.dataframe$strategy.duration.ms ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
lambda <- Cox2[1, "Box.x"]
rq4_2.dataframe$strategy.duration.ms.box <- (rq4_2.dataframe$strategy.duration.ms^lambda - 1) / lambda
my_sample <- rq4_2.dataframe[sample(nrow(rq4_2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.box)
# W = 0.94699, p-value < 2.2e-16

#################################################################################################
#################################### Phase 3: Hypothesis Test ###################################
#################################################################################################
print("Phase 3. Hypothesis Test")

# Hypothesistest
# Metric          Test              p-value     is H0 rejected (p-value < 0.05)
# -----           ------            -------     --------------------------
# Duration        Mann-Whitney      0.0001294   yes


rq0.filter.greedy <- rq4_2.dataframe$subject.treatment.id == "nappagreedy"
rq0.filter.tfpr <- rq4_2.dataframe$subject.treatment.id == "nappatfpr"

######################################### 3a: Duration  ########################################

# Duration  ~ not normal ~ Mann-Whitney
rq0.hypothesis.duration_all.whitney <- wilcox.test(rq4_2.dataframe[rq0.filter.greedy,]$strategy.duration.ms,
                                                   rq4_2.dataframe[rq0.filter.tfpr,]$strategy.duration.ms)
#	Wilcoxon rank sum test with continuity correction
#
#data:  rq4_2.dataframe[rq0.filter.greedy, ]$strategy.duration.ms and rq4_2.dataframe[rq0.filter.tfpr, ]$strategy.duration.ms
#W = 12012386, p-value = 0.0001294
#alternative hypothesis: true location shift is not equal to 0
experiment.write.text(data = rq0.hypothesis.duration_all.whitney,
                      rq = "4_2",
                      filename = "hypothesis_duration_whitney.txt")

cliff.delta(
  rq4_2.dataframe[rq0.filter.greedy,]$strategy.duration.ms,
  rq4_2.dataframe[rq0.filter.tfpr,]$strategy.duration.ms)
#Cliff's Delta
#
#delta estimate: 0.0451369 (negligible)
#95 percent confidence interval:
#     lower      upper
#0.01836770 0.07184144