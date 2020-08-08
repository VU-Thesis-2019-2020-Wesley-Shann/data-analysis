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


# Per treatment
print("Descriptive statistics per treatment")
rq2.summary.treatment.request_duration <- experiment.treatment.summary(dataframe = rq2.dataframe, property = "request.duration.from_system.ms", digits = 2)
rq2.summary.treatment.request_duration <- rq2.summary.treatment.request_duration[-kepp_min_max_mean_median,]
rownames(rq2.summary.treatment.request_duration) <- paste("Request duration (ms)", rownames(rq2.summary.treatment.request_duration))

rq2.summary.treatment.response_length <- experiment.treatment.summary(dataframe = rq2.dataframe[rq2.filter.valid_response_length,], property = "response.length.from_okhttp.kb", digits = 2)
rq2.summary.treatment.response_length <- rq2.summary.treatment.response_length[-kepp_min_max_mean_median,]
rownames(rq2.summary.treatment.response_length) <- paste("Response length (KB)", rownames(rq2.summary.treatment.response_length))

rq2.summary.treatment.aggregate <- rbind(
  rq2.summary.treatment.request_duration,
  rq2.summary.treatment.response_length
)
rq2.summary.treatment.aggregate
experiment.write.latex(rq = 2,
                       digits = 2,
                       dataframe = rq2.summary.treatment.aggregate,
                       filename = "summary_treatment.tex",
                       caption = "Overview of the user perceived latency per treatment.",
                       label = "tab:results:rq2:summary:treatment")

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
rq2.summary.subject.request_duration <- rq2.summary.subject.request_duration[-kepp_min_max_mean_median,]
rownames(rq2.summary.subject.request_duration) <- paste("Request duration (ms)", rownames(rq2.summary.subject.request_duration))

experiment.write.latex(rq = 2,
                       digits = 2,
                       dataframe = rq2.summary.subject.request_duration,
                       filename = "summary_subject_url_duration.tex")

rq2.summary.subject.response_length <- experiment.subject.summary(dataframe = rq2.dataframe[rq2.filter.valid_response_length,], property = "response.length.from_okhttp.kb", digits = 2)
rq2.summary.subject.response_length <- rq2.summary.subject.response_length[-kepp_min_max_mean_median,]
rownames(rq2.summary.subject.response_length) <- paste("Response length (KB)", rownames(rq2.summary.subject.response_length))

experiment.write.latex(rq = 2,
                       digits = 2,
                       dataframe = rq2.summary.subject.response_length,
                       filename = "summary_subject_url_length.tex")

rq2.summary.subject.url <- data.frame(matrix(ncol = 3, nrow = 0))
for (subject in levels(rq2.dataframe$subject.name)) {
  rq2.summary.subject.url <- rbind(
    rq2.summary.subject.url,
    c(subject,
      length(unique(rq2.dataframe[rq2.dataframe$subject.name == subject,]$request.url)),
      length(rq2.dataframe[rq2.dataframe$subject.name == subject,]$request.url)
    )
  )
}
colnames(rq2.summary.subject.url) <- c("Subject", "Unique URLs", "Total URLs")
experiment.write.latex(dataframe = rq2.summary.subject.url,
                       rq = 2,
                       filename = "summary_subject_url",
                       caption = "Count of unique requested URL per subject",
                       label = "tab:results:rq2:summary:subject:url")

# Treatment ~ subject

rq2.summary.treatment_subject.url <- data.frame(matrix(ncol = 3, nrow = 0))
for (subject in levels(rq2.dataframe$subject.id)) {
  rq2.summary.treatment_subject.url <- rbind(
    rq2.summary.treatment_subject.url,
    c(subject,
      length(unique(rq2.dataframe[rq2.dataframe$subject.id == subject,]$request.url)),
      length(rq2.dataframe[rq2.dataframe$subject.id == subject,]$request.url)
    )
  )
}
colnames(rq2.summary.treatment_subject.url) <- c("Subject", "Unique URLs", "Total URLs")
experiment.write.latex(dataframe = rq2.summary.treatment_subject.url,
                       rq = 2,
                       filename = "summary_treatment_subject_url",
                       caption = "Count of unique requested URL per subject and treatment",
                       label = "tab:results:rq2:summary:treatment_subject:url")

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

my_plot <- experiment.plot.boxplot(rq2.dataframe[rq2.filter.response.length.below_1000kb,],
                                   "response.length.from_okhttp.kb",
                                   "Response length (KB)",
                                   "Response length (Below 1MB)")
experiment.write.plot(filename = "boxplot_response_length_below_1000kb.png", rq = 2)

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

my_plot <- experiment.plot.violin(rq2.dataframe[rq2.filter.with_prefetch_only,],
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration (Prefetching F1-Score>0)")
experiment.write.plot(filename = "violin_request_duration_with_prefetch_only.png", rq = 2)

my_plot <- experiment.plot.violin(rq2.dataframe[rq2.filter.with_prefetch_only & rq2.filter.no_materialistic,],
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration (Prefetching F1>0; No Materislistic)")
experiment.write.plot(filename = "violin_request_duration_with_prefetch_only_no_materialistic.png", rq = 2)

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

my_plot <- experiment.plot.freqpoly(rq2.dataframe[rq2.filter.with_prefetch_only,],
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration (Prefetching F1-Score>0)")
experiment.write.plot(filename = "freqpoly_request_duration_with_prefetch_only.png", rq = 2)

my_plot <- experiment.plot.freqpoly(rq2.dataframe[rq2.filter.with_prefetch_only & rq2.filter.no_materialistic,],
                                  "request.duration.from_system.ms",
                                  "Request duration (ms)",
                                  "Request duration (Prefetching F1>0; No Materislistic)")
experiment.write.plot(filename = "freqpoly_request_duration_with_prefetch_only_no_materialistic.png", rq = 2)


