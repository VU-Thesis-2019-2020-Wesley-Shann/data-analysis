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

rq0.dataframe <- experiment.source.prefetching_strategy_execution_time()

################################  Phase 1a Descriptive statistics ###############################

rq0.summary.treatment.duration <- experiment.treatment.summary(dataframe = rq0.dataframe, property = "strategy.duration.ms", digits = 2)

experiment.write.latex(rq = 0,
                       dataframe = rq0.summary.treatment.duration,
                       filename = "summary-duration.tex",
                       caption = "Overview of the strategy duration.",
                       label = "tab:results:rq0:summary:duration")

#######################################  Phase 1b Plots ########################################
print("Generating plots")

my_plot <- experiment.plot.boxplot(rq0.dataframe,
                                   "strategy.duration.ms",
                                   "Strategy duration (ms)",
                                   "Strategy duration")
experiment.write.plot(filename = "boxplot_duration.png", rq = 0)

my_plot <- experiment.plot.violin(rq0.dataframe,
                                  "strategy.duration.ms",
                                  "Strategy duration (ms)",
                                  "Strategy duration")
experiment.write.plot(filename = "violin_duration.png", rq = 0)

my_plot <- experiment.plot.freqpoly(rq0.dataframe,
                                    "strategy.duration.ms",
                                    "Strategy duration (ms)",
                                    "Strategy duration")
experiment.write.plot(filename = "freqpoly_duration.png", rq = 0)


#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
#################################################################################################

print("Phase 2. Normality Check and Data Transformation")

# Metric    Method        p-value     is normal (p-value > 0.05)
# -----     ------        -------     --------------------------
# Duration  N/A           2.2e-16     no
# Duration  all           2.2e-16     no

##################################  Phase 2a Normality check ####################################
my_plot <- experiment.plot.qqplot(rq0.dataframe,
                                  "strategy.duration.ms",
                                  "Strategy duration (ms)",
                                  "Strategy duration")
experiment.write.plot(filename = "qqplot_duration.png", rq = 0)

my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms)
#W = 0.46567, p-value < 2.2e-16

experiment.write.text(data = shapiro.test(my_sample$strategy.duration.ms),
                      filename = "test_shapiro_duration_sample.txt",
                      rq = 0)

##################################  Phase 2a Data Transformation ####################################

# Duration ~ Natural log
rq0.dataframe$strategy.duration.ms.log <- log(rq0.dataframe$strategy.duration.ms)
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.log)
#W = 0.9156, p-value < 2.2e-16

# Duration ~ squared
rq0.dataframe$strategy.duration.ms.squared <- rq0.dataframe$strategy.duration.ms^2
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.squared)
#W = 0.19135, p-value < 2.2e-16

# Duration ~ square root
rq0.dataframe$strategy.duration.ms.sqrt <- sqrt(rq0.dataframe$strategy.duration.ms)
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.sqrt)
#W = 0.80326, p-value < 2.2e-16

# Duration ~ cube root
rq0.dataframe$strategy.duration.ms.cube <- sign(rq0.dataframe$strategy.duration.ms) * abs(rq0.dataframe$strategy.duration.ms)^(1 / 3)
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.cube)
# W = 0.90358, p-value < 2.2e-16

# Duration ~ inverse
rq0.dataframe$strategy.duration.ms.inverse <- 1 / rq0.dataframe$strategy.duration.ms
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$strategy.duration.ms.inverse)
# W = 0.59104, p-value < 2.2e-16

# Duration ~ Tukey’s Ladder of Powers transformation
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
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
Box <- boxcox(rq0.dataframe$strategy.duration.ms ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
lambda <- Cox2[1, "Box.x"]
rq0.dataframe$strategy.duration.ms.box <- (rq0.dataframe$strategy.duration.ms^lambda - 1) / lambda
my_sample <- rq0.dataframe[sample(nrow(rq0.dataframe), 5000, replace = FALSE),]
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


rq0.filter.greedy <- rq0.dataframe$subject.treatment.id == "nappagreedy"
rq0.filter.tfpr <- rq0.dataframe$subject.treatment.id == "nappatfpr"

######################################### 3a: Duration  ########################################

# Duration  ~ not normal ~ Mann-Whitney
rq0.hypothesis.duration_all.whitney <- wilcox.test(rq0.dataframe[rq0.filter.greedy,]$strategy.duration.ms,
                                                   rq0.dataframe[rq0.filter.tfpr,]$strategy.duration.ms)
#	Wilcoxon rank sum test with continuity correction
#
#data:  rq0.dataframe[rq0.filter.greedy, ]$strategy.duration.ms and rq0.dataframe[rq0.filter.tfpr, ]$strategy.duration.ms
#W = 12012386, p-value = 0.0001294
#alternative hypothesis: true location shift is not equal to 0
experiment.write.text(data = rq0.hypothesis.duration_all.whitney,
                      rq = 0,
                      filename = "hypothesis_duration_whitney.txt")

cliff.delta(
  rq0.dataframe[rq0.filter.greedy,]$strategy.duration.ms,
  rq0.dataframe[rq0.filter.tfpr,]$strategy.duration.ms)
#Cliff's Delta
#
#delta estimate: 0.0451369 (negligible)
#95 percent confidence interval:
#     lower      upper
#0.01836770 0.07184144