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
rq2.dataframe <- experiment.source.network_request_execution_time()

nrow(rq2.dataframe)
#34334

# Remove row containing extreme runtime duartion outlier
rq2.dataframe <- rq2.dataframe[!(rq2.dataframe$subject.id == "NewsBlur (G)" &
  rq2.dataframe$run.number == 9 &
  rq2.dataframe$experiment.part == 1),]

nrow(rq2.dataframe)
#34320

#################################################################################################
#####################################  Phase 1: Exploration #####################################
#################################################################################################
# Filters
rq2.filter.no_uob <- rq2.dataframe$subject.name != "UOB Timetable"
rq2.filter.no_materialistic <- rq2.dataframe$subject.name != "Materialistic"
rq2.filter.with_prefetch_only <- rq2.dataframe$subject.name %in% c("Materialistic", "Antenna Pod", "Hill'Fair")
rq2.filter.response.length.below_1000kb <- rq2.dataframe$response.length.from_okhttp.kb <= 1000
rq2.filter.valid_response_length <- rq2.dataframe$response.length.from_okhttp.b > -1

################################  Phase 1a Descriptive statistics ###############################
print("Phase 1. Data exploration")

keep_min_max_mean <- c(2, 3, 5)
keep_min_max_median <- c(2, 4, 5)
kepp_min_max_mean_median <- c(2, 5)

# Datapoints per subject ~ treatment
rq2.summary.subject.datapoints <- data.frame(matrix(ncol = 3, nrow = 0))
for (subject in levels(rq2.dataframe$subject.id)) {
  subject_datapoints <- rq2.dataframe[rq2.dataframe$subject.id == subject,]
  rq2.summary.subject.datapoints <- rbind(
    rq2.summary.subject.datapoints,
    c(subject,
      nrow(subject_datapoints),
      ceiling(nrow(subject_datapoints) / 30),
      length(unique(subject_datapoints$request.url))
    )
  )
}
# The avg for newsblur greedy is wrong as the avg is the total / 29 runs, not 30 runs
colnames(rq2.summary.subject.datapoints) <- c("Subject", "Total requests", "Average requests per run", "Total unique requests")
experiment.write.latex(rq = 2,
                       dataframe = rq2.summary.subject.datapoints,
                       filename = "summary-treatment_subject_datapoints.tex")

# Per treatment
print("Descriptive statistics per treatment")
rq2.summary.treatment.request_duration <- experiment.treatment.summary(dataframe = rq2.dataframe, property = "request.duration.from_system.ms", digits = 2)
experiment.write.latex(rq = 2,
                       dataframe = t(rq2.summary.treatment.request_duration),
                       filename = "summary-treatment_request_duration.tex")

# without materialistic
rq2.summary.treatment.request_duration_without_materialistic <- experiment.treatment.summary(dataframe = rq2.dataframe[rq2.filter.no_materialistic,], property = "request.duration.from_system.ms", digits = 2)
experiment.write.latex(rq = 2,
                       dataframe = t(rq2.summary.treatment.request_duration_without_materialistic),
                       filename = "summary-treatment_request_duration_without_materialistic.tex")

rq2.summary.treatment.response_length <- experiment.treatment.summary(dataframe = rq2.dataframe[rq2.filter.valid_response_length,], property = "response.length.from_okhttp.kb", digits = 2)
experiment.write.latex(rq = 2,
                       dataframe = t(rq2.summary.treatment.response_length),
                       filename = "summary-treatment_request_length.tex")

rq2.summary.treatment.url <- data.frame(matrix(ncol = 3, nrow = 0))
for (treatment in levels(rq2.dataframe$subject.treatment.name.long)) {
  rq2.summary.treatment.url <- rbind(
    rq2.summary.treatment.url,
    c(treatment,
      length(unique(rq2.dataframe[rq2.dataframe$subject.treatment.name.long == treatment,]$request.url)),
      length(rq2.dataframe[rq2.dataframe$subject.treatment.name.long == treatment,]$request.url)
    )
  )
}
colnames(rq2.summary.treatment.url) <- c("Treatent", "Unique URLs", "Total URLs")
experiment.write.latex(dataframe = rq2.summary.treatment.url,
                       rq = 2,
                       filename = "summary_treatment_url.tex",
                       caption = "Count of unique requested URL per treatment",
                       label = "tab:results:rq2:summary:treatment:url")


# Per subject
print("Descriptive statistics per subject")
rq2.summary.subject.request_duration <- experiment.subject.summary(dataframe = rq2.dataframe, property = "request.duration.from_system.ms", digits = 2)
experiment.write.latex(rq = 2,
                       digits = 2,
                       dataframe = t(rq2.summary.subject.request_duration),
                       filename = "summary_subject_url_duration.tex")
#rq2.summary.subject.request_duration <- rq2.summary.subject.request_duration[-kepp_min_max_mean_median,]
rownames(rq2.summary.subject.request_duration) <- paste("Request duration (ms)", rownames(rq2.summary.subject.request_duration))

rq2.summary.subject.response_length <- experiment.subject.summary(dataframe = rq2.dataframe[rq2.filter.valid_response_length,], property = "response.length.from_okhttp.kb", digits = 2)
experiment.write.latex(rq = 2,
                       digits = 2,
                       dataframe = t(rq2.summary.subject.response_length),
                       filename = "summary_subject_url_length.tex")
#rq2.summary.subject.response_length <- rq2.summary.subject.response_length[-kepp_min_max_mean_median,]
rownames(rq2.summary.subject.response_length) <- paste("Response length (KB)", rownames(rq2.summary.subject.response_length))

#######################################  Phase 1b Plots ########################################
print("Generating plots")

# Boxplot
my_plot <- experiment.plot.boxplot(rq2.dataframe,
                                   "request.duration.from_system.ms",
                                   "Request duration (ms)",
                                   "Request duration")
experiment.write.plot(filename = "boxplot_request_duration.png", rq = 2)

my_plot <- experiment.plot.boxplot(rq2.dataframe,
                                   "response.length.from_okhttp.kb",
                                   "Response length (KB)",
                                   "Response length")
experiment.write.plot(filename = "boxplot_response_length.png", rq = 2)

my_plot <- experiment.plot.boxplot(rq2.dataframe[rq2.filter.no_uob,],
                                   "response.length.from_okhttp.kb",
                                   "Response length (KB)",
                                   "Response length (Without UOB)")
experiment.write.plot(filename = "boxplot_response_length_no_uob.png", rq = 2)

# Violin plot
my_plot <- experiment.plot.violin(rq2.dataframe,
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration")
experiment.write.plot(filename = "violin_request_duration.png", rq = 2)

my_plot <- experiment.plot.violin(rq2.dataframe[rq2.filter.no_materialistic,],
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration (Without Materialistic)")
experiment.write.plot(filename = "violin_request_duration_no_materialistic.png", rq = 2)

# Frequency
my_plot <- experiment.plot.freqpoly(rq2.dataframe,
                                    "request.duration.from_system.ms",
                                    "Request duration (ms)",
                                    "Request duration")
experiment.write.plot(filename = "freqpoly_request_duration.png", rq = 2)

my_plot <- experiment.plot.freqpoly(rq2.dataframe[rq2.filter.no_materialistic,],
                                    "request.duration.from_system.ms",
                                    "Request duration (ms)",
                                    "Request duration (Without Materialistic)")
experiment.write.plot(filename = "freqpoly_request_duration_no_materialistic.png", rq = 2)

rq2.dataframe_no_materialistic <- rq2.dataframe[rq2.filter.no_materialistic,]

#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
######################################  With Materialistic ######################################
#################################################################################################

print("Phase 2. Normality Check and Data Transformation (with Materialistic)")

# Metric                  Method        p-value     is normal (p-value > 0.05)
# -----                   ------        -------     --------------------------
# Request duration        N/A           2.2e-16     no
# Request duration        all           2.2e-16     no

##################################  Phase 2a Normality check ####################################
print("Check normality")

# All
my_plot <- experiment.plot.qqplot(rq2.dataframe,
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration")
experiment.write.plot(filename = "qqplot_request_duration.png", rq = 2)

my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]

my_plot <- experiment.plot.qqplot(my_sample,
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration")
experiment.write.plot(filename = "qqplot_request_duration_sampled.png", rq = 2)

ks.test(rq2.dataframe$request.duration.from_system.ms, y="pnorm")
#	One-sample Kolmogorov-Smirnov test
#
#data:  rq2.dataframe$request.duration.from_system.ms
#D = 0.97364, p-value < 2.2e-16
#alternative hypothesis: two-sided

shapiro.test(my_sample$request.duration.from_system.ms)
#	Shapiro-Wilk normality test
#
#data:  my_sample$request.duration.from_system.ms
#W = 0.83658, p-value < 2.2e-16

experiment.write.text(data = shapiro.test(my_sample$request.duration.from_system.ms),
                      filename = "test_shapiro_request_duration_sampled.txt",
                      rq = 2)

##################################  Phase 2a Data Transformation ####################################

# Request duration ~ Natural log
rq2.dataframe$request.duration.from_system.ms.log <- log(rq2.dataframe$request.duration.from_system.ms)
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.log)
#W = 0.8662, p-value < 2.2e-16

# Request duration ~ squared
rq2.dataframe$request.duration.from_system.ms.squared <- rq2.dataframe$request.duration.from_system.ms^2
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.squared)
# W = 0.9266, p-value = 2.2e-16

# Request duration ~ square root
rq2.dataframe$request.duration.from_system.ms.sqrt <- sqrt(rq2.dataframe$request.duration.from_system.ms)
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.sqrt)
# W = 0.97621, p-value < 2.2e-16

# Request duration ~ cube root
rq2.dataframe$request.duration.from_system.ms.cube <- sign(rq2.dataframe$request.duration.from_system.ms) * abs(rq2.dataframe$request.duration.from_system.ms)^(1 / 3)
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.cube)
#W = 0.98571, p-value < 2.2e-16

# Request duration ~ inverse
rq2.dataframe$request.duration.from_system.ms.inverse <- 1 / rq2.dataframe$request.duration.from_system.ms
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.inverse)
#W = 0.32345, p-value < 2.2e-16

# Request duration ~ Tukey’s Ladder of Powers transformation
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
my_sample_tukey <- transformTukey(my_sample$request.duration.from_system.ms, plotit = FALSE)
#    lambda     W Shapiro.p.value
#416  0.375 0.9854       2.659e-22
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(my_sample_tukey)
#W = 0.986, p-value < 2.2e-16

# Request duration ~ Box–Cox transformation
Box <- boxcox(rq2.dataframe$request.duration.from_system.ms ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
lambda <- Cox2[1, "Box.x"]
rq2.dataframe$request.duration.from_system.ms.box <- (rq2.dataframe$request.duration.from_system.ms^lambda - 1) / lambda
my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.box)
#W = 0.98396, p-value < 2.2e-16

#################################################################################################
#######################  Phase 2: Normality Check and Data Transformation #######################
####################################  Without Materialistic #####################################
#################################################################################################

print("Phase 2. Normality Check and Data Transformation (without Materialistic)")

# Metric                  Method        p-value     is normal (p-value > 0.05)
# -----                   ------        -------     --------------------------
# Request duration        N/A           2.2e-16     no
# Request duration        All           2.2e-16     no

##################################  Phase 2a Normality check ####################################
print("Check normality")

# All
my_plot <- experiment.plot.qqplot(rq2.dataframe_no_materialistic,
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration")
experiment.write.plot(filename = "qqplot_request_duration_without_materialistic.png", rq = 2)

my_sample <- rq2.dataframe[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]

my_plot <- experiment.plot.qqplot(my_sample,
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration")
experiment.write.plot(filename = "qqplot_request_duration_without_materialistic_sampled.png", rq = 2)

ks.test(rq2.dataframe_no_materialistic$request.duration.from_system.ms, y="pnorm")
#	One-sample Kolmogorov-Smirnov test
#
#data:  rq2.dataframe$request.duration.from_system.ms
#D = 0.97166, p-value < 2.2e-16
#alternative hypothesis: two-sided

shapiro.test(my_sample$request.duration.from_system.ms)
#	Shapiro-Wilk normality test
#
#data:  my_sample$request.duration.from_system.ms
#W = 0.76782, p-value < 2.2e-16

experiment.write.text(data = shapiro.test(my_sample$request.duration.from_system.ms),
                      filename = "test_shapiro_request_duration_without_materialistic_sampled.txt",
                      rq = 2)

##################################  Phase 2a Data Transformation ####################################

# Request duration ~ Natural log
rq2.dataframe_no_materialistic$request.duration.from_system.ms.log <- log(rq2.dataframe_no_materialistic$request.duration.from_system.ms)
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.log)
#W = 0.76521, p-value < 2.2e-16

# Request duration ~ squared
rq2.dataframe_no_materialistic$request.duration.from_system.ms.squared <- rq2.dataframe_no_materialistic$request.duration.from_system.ms^2
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.squared)
# W = 0.50405, p-value < 2.2e-16

# Request duration ~ square root
rq2.dataframe_no_materialistic$request.duration.from_system.ms.sqrt <- sqrt(rq2.dataframe_no_materialistic$request.duration.from_system.ms)
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.sqrt)
# W = 0.96983, p-value < 2.2e-16

# Request duration ~ cube root
rq2.dataframe_no_materialistic$request.duration.from_system.ms.cube <- sign(rq2.dataframe_no_materialistic$request.duration.from_system.ms) * abs(rq2.dataframe_no_materialistic$request.duration.from_system.ms)^(1 / 3)
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.cube)
#W = 0.93996, p-value < 2.2e-16

# Request duration ~ inverse
rq2.dataframe_no_materialistic$request.duration.from_system.ms.inverse <- 1 / rq2.dataframe_no_materialistic$request.duration.from_system.ms
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.inverse)
#W = 0.39763, p-value < 2.2e-16

# Request duration ~ Tukey’s Ladder of Powers transformation
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
my_sample_tukey <- transformTukey(my_sample$request.duration.from_system.ms, plotit = FALSE)
#    lambda     W Shapiro.p.value
#424  0.575 0.9722       4.172e-30
#
#if (lambda >  0){TRANS = x ^ lambda}
#if (lambda == 0){TRANS = log(x)}
#if (lambda <  0){TRANS = -1 * x ^ lambda}
shapiro.test(my_sample_tukey)
#W = 0.9722, p-value < 2.2e-16

# Request duration ~ Box–Cox transformation
Box <- boxcox(rq2.dataframe_no_materialistic$request.duration.from_system.ms ~ 1, lambda = seq(-6, 6, 0.1))
Cox <- data.frame(Box$x, Box$y)
Cox2 <- Cox[with(Cox, order(-Cox$Box.y)),]
Cox2[1,]
#   Box.x     Box.y
#65   0.4 -118324.9
lambda <- Cox2[1, "Box.x"]
rq2.dataframe_no_materialistic$request.duration.from_system.ms.box <- (rq2.dataframe_no_materialistic$request.duration.from_system.ms^lambda - 1) / lambda
my_sample <- rq2.dataframe_no_materialistic[sample(nrow(rq2.dataframe_no_materialistic), 5000, replace = FALSE),]
shapiro.test(my_sample$request.duration.from_system.ms.box)
#W = 0.95695, p-value < 2.2e-16


#################################################################################################
#################################### Phase 3: Hypothesis Test ###################################
#################################################################################################
print("Phase 3. Hypothesis Test")


####################################### 3a: duration (all) ######################################

# Request duration ~ not normal ~ Kruskal-Wallis
rq2.hypothesis.request.duration.result <- kruskal.test(request.duration.from_system.ms ~ subject.treatment.id, data = rq2.dataframe)
#	Kruskal-Wallis rank sum test
#
#data:  request.duration.from_system.ms by subject.treatment.id
#Kruskal-Wallis chi-squared = 1002.6, df = 2, p-value < 2.2e-16
experiment.write.text(data = rq2.hypothesis.request.duration.result,
                      rq = 2,
                      filename = "hypothesis_request_duration_kruskal.txt")


rq2.hypothesis.request.duration.holm <- pairwise.wilcox.test(rq2.dataframe$request.duration.from_system.ms, rq2.dataframe$subject.treatment.id)
#            baseline nappagreedy
#nappagreedy <2e-16   -
#nappatfpr   <2e-16   0.65
#
#P value adjustment method: holm

experiment.write.text(data = rq2.hypothesis.request.duration.holm,
                      rq = 2,
                      filename = "hypothesis_request_duration_holm.txt")

rq2.hypothesis.request.duration.bonferroni <- pairwise.wilcox.test(rq2.dataframe$request.duration.from_system.ms, rq2.dataframe$subject.treatment.id, p.adjust.method = "bonferroni")
#            baseline nappagreedy
#nappagreedy <2e-16   -
#nappatfpr   <2e-16   1
#
#P value adjustment method: bonferroni

experiment.write.text(data = rq2.hypothesis.request.duration.bonferroni,
                      rq = 2,
                      filename = "hypothesis_request_duration_bonferroni.txt")


# Computes the Cliff's Delta effect size for ordinal variables with the related confidence interval using efficient algorithms.
rq2.hypothesis.request.duration.cliff.baseline_greedy <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "baseline", "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappagreedy", "request.duration.from_system.ms"])
#Cliff's Delta
#
#delta estimate: -0.1988665 (small)
#95 percent confidence interval:
#     lower      upper
#-0.2157985 -0.1818150

rq2.hypothesis.request.duration.cliff.baseline_tfpr <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "baseline", "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappatfpr", "request.duration.from_system.ms"])
#Cliff's Delta
#
#delta estimate: -0.1983843 (small)
#95 percent confidence interval:
#     lower      upper
#-0.2153942 -0.181254

rq2.hypothesis.request.duration.cliff.greedy_tfpr <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappagreedy", "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappatfpr", "request.duration.from_system.ms"])
#Cliff's Delta
#
#delta estimate: -0.004197311 (negligible)
#95 percent confidence interval:
#      lower       upper
#-0.02255092  0.01415913

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.baseline_greedy,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_baseline_greedy.txt")

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.baseline_tfpr,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_baseline_tfpr.txt")

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.greedy_tfpr,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_greedy_tfpr.txt")

####################################### 3b: duration (prefetch only) ######################################

# Request duration ~ not normal ~ Kruskal-Wallis
rq2.hypothesis.request.duration.result2 <- kruskal.test(request.duration.from_system.ms ~ subject.treatment.id, data = rq2.dataframe[rq2.filter.with_prefetch_only,])
#	Kruskal-Wallis rank sum test
#
#data:  request.duration.from_system.ms by subject.treatment.id
#Kruskal-Wallis chi-squared = 1287.5, df = 2, p-value < 2.2e-16
experiment.write.text(data = rq2.hypothesis.request.duration.result2,
                      rq = 2,
                      filename = "hypothesis_request_duration_kruskal_prefetch_only.txt")


rq2.hypothesis.request.duration.holm2 <- pairwise.wilcox.test(rq2.dataframe[rq2.filter.with_prefetch_only,]$request.duration.from_system.ms,
                                                              rq2.dataframe[rq2.filter.with_prefetch_only,]$subject.treatment.id)
#            baseline nappagreedy
#nappagreedy <2e-16   -
#nappatfpr   <2e-16   0.7

experiment.write.text(data = rq2.hypothesis.request.duration.holm2,
                      rq = 2,
                      filename = "hypothesis_request_duration_holm_prefetch_only.txt")

rq2.hypothesis.request.duration.bonferroni2 <- pairwise.wilcox.test(rq2.dataframe[rq2.filter.with_prefetch_only,]$request.duration.from_system.ms,
                                                                    rq2.dataframe[rq2.filter.with_prefetch_only,]$subject.treatment.id, p.adjust.method = "bonferroni")
#            baseline nappagreedy
#nappagreedy <2e-16   -
#nappatfpr   <2e-16   1
#
#P value adjustment method: bonferroni

experiment.write.text(data = rq2.hypothesis.request.duration.bonferroni2,
                      rq = 2,
                      filename = "hypothesis_request_duration_bonferroni_prefetch_only.txt")


# Computes the Cliff's Delta effect size for ordinal variables with the related confidence interval using efficient algorithms.
rq2.hypothesis.request.duration.cliff.baseline_greedy2 <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "baseline" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappagreedy" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"])
#Cliff's Delta
#
#delta estimate: -0.3429637 (medium)
#95 percent confidence interval:
#     lower      upper
#-0.3699669 -0.3153814

rq2.hypothesis.request.duration.cliff.baseline_tfpr2 <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "baseline" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappatfpr" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"])
#Cliff's Delta
#
#delta estimate: -0.3458323 (medium)
#95 percent confidence interval:
#     lower      upper
#-0.3730045 -0.3180674

rq2.hypothesis.request.duration.cliff.greedy_tfpr2 <- cliff.delta(
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappagreedy" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"],
  rq2.dataframe[rq2.dataframe$subject.treatment.id == "nappatfpr" & rq2.filter.with_prefetch_only, "request.duration.from_system.ms"])
#delta estimate: -0.006435663 (negligible)
#95 percent confidence interval:
#      lower       upper
#-0.03879629  0.02593845

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.baseline_greedy2,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_baseline_greedy_prefetch_only.txt")

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.baseline_tfpr2,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_baseline_tfpr_prefetch_only.txt")

experiment.write.text(data = rq2.hypothesis.request.duration.cliff.greedy_tfpr2,
                      rq = 2,
                      filename = "hypothesis_request_duration_cliff_greedy_tfpr_prefetch_only.txt")
