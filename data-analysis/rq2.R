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


################################  Phase 1a Descriptive statistics ###############################
print("Phase 1. Data exploration")

keep_min_max_mean <- c(2, 3, 5)
keep_min_max_median <- c(2, 4, 5)
kepp_min_max_mean_median <- c(2, 5)

rq2.filter.valid_response_length <- rq2.dataframe$response.length.from_okhttp.b > -1

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

rq2.summary.subject.url <- data.frame(matrix(ncol = 2, nrow = 0))
for (subject in levels(rq2.dataframe$subject.name)) {
  rq2.summary.subject.url <- rbind(
    rq2.summary.subject.url,
    c(subject, length(unique(rq2.dataframe[rq2.dataframe$subject.name == subject,]$request.url)))
  )
}
colnames(rq2.summary.subject.url) <- c("Subject", "Unique URLs")
experiment.write.latex(dataframe = rq2.summary.subject.url,
                       rq = 2,
                       filename = "summary_subject_url",
                       caption = "Count of unique requested URL per subject",
                       label = "tab:results:rq2:summary:subject:url")