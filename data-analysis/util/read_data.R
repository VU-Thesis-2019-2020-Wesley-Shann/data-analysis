# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 06-08-20

library(plyr)

experiment.source.dir <- "/home/sshann/Documents/thesis/experiments/experiment-results"
experiment.source.parts.1 <- "part1_2020.08.03_230233"
experiment.source.parts.2 <- "part2_2020.08.05_002520"
experiment.source.parts.3 <- "part3_2020.08.05_223421"

subject.format.name <- function(dataframe) {
  dataframe$subject_name <- ifelse(iris$Sepal.Length >= 5, "UP", "DOWN")
  dataframe
}

# Open and concatenate the data of all three parts of the experiment
experiment.source.csv <- function(file) {
  # Read data
  part1 <- read.csv(paste(experiment.source.dir, experiment.source.parts.1, file, sep = "/"))
  part1$experiment.part <- as.factor(1)

  part2 <- read.csv(paste(experiment.source.dir, experiment.source.parts.2, file, sep = "/"))
  part2$experiment.part <- as.factor(2)

  part3 <- read.csv(paste(experiment.source.dir, experiment.source.parts.3, file, sep = "/"))
  part3$experiment.part <- as.factor(3)

  # Concat data
  dataframe <- rbind(part1, part2, part3)

  # Rename columns
  dataframe <- rename(dataframe, c(
    "App.package" = "subject.android.package",
    "Treatment" = "subject.treatment.id",
    "Subject" = "subject.id.long",
    "Run.number" = "run.number"
  ))

  # Set app name, not pretty, I know, but it works and we are short in time
  dataframe$subject.name <-
    ifelse(dataframe$subject.android.package == "io.github.hidroh.materialistic", "Materialistic",
           ifelse(dataframe$subject.android.package == "appteam.nith.hillffair", "Hill'Fair",
                  ifelse(dataframe$subject.android.package == "com.ak.uobtimetable", "UOB Timetable",
                         ifelse(dataframe$subject.android.package == "com.newsblur", "NewsBlur",
                                ifelse(dataframe$subject.android.package == "io.github.project_travel_mate", "Travel Mate",
                                       ifelse(dataframe$subject.android.package == "de.danoeh.antennapod.debug", "Antenna Pod",
                                              ifelse(dataframe$subject.android.package == "org.quantumbadger.redreader", "RedReader",
                                                     "Unkown subject name")))))))

  # Create additional data
  dataframe$subject.treatment.name.long <-
    ifelse(dataframe$subject.treatment.id == "baseline", "Baseline",
           ifelse(dataframe$subject.treatment.id == "nappagreedy", "Greedy",
                  ifelse(dataframe$subject.treatment.id == "nappatfpr", "TFPR",
                         "Unkown subject name")))
  dataframe$subject.treatment.name.short <-
    ifelse(dataframe$subject.treatment.id == "baseline", "B",
           ifelse(dataframe$subject.treatment.id == "nappagreedy", "G",
                  ifelse(dataframe$subject.treatment.id == "nappatfpr", "PR",
                         "Unkown subject name")))

  dataframe$subject.id.short <- paste0(dataframe$subject.name, " (", dataframe$subject.treatment.name.short, ")")

  # Set factors
  dataframe$subject.treatment.id <- as.factor(dataframe$subject.treatment.id)
  dataframe$subject.treatment.name.short <- as.factor(dataframe$subject.treatment.name.short)
  dataframe$subject.treatment.name.long <- as.factor(dataframe$subject.treatment.name.long)
  dataframe$subject.id.long <- as.factor(dataframe$subject.id.long)
  dataframe$subject.id.short <- as.factor(dataframe$subject.id.short)
  dataframe$subject.android.package <- as.factor(dataframe$subject.android.package)
  dataframe$experiment.part <- as.factor(dataframe$experiment.part)
  dataframe$run.number <- as.factor(dataframe$run.number)
  dataframe$subject.name <- as.factor(dataframe$subject.name)

  dataframe
}

experiment.source.trepn <- function() {
  dataframe <- experiment.source.csv("Aggregate-Trepn.csv")

  # Rename columns
  dataframe <- rename(dataframe, c(
    "Duration..ms." = "run.duration.ms",
    "Memory.Usage..KB." = "trepn.memory.kb",
    "Battery.Power..uW...Raw." = "trepn.battery.raw.uw",
    "Battery.Power..uW...Delta." = "trepn.battery.delta.uw",
    "CPU.Load...." = "trepn.cpu",
    "Battery.Power..uW...Raw...Non.zero." = "trepn.battery.nonzero.raw.uw",
    "Battery.Power..uW...Delta...Non.zero." = "trepn.battery.nonzero.delta.uw"
  ))

  # Parse power from watts to Joule
  dataframe$trepn.battery.joule <- (dataframe$trepn.battery.raw.uw / (10^6)) * (dataframe$run.duration.ms / 1000)
  dataframe$trepn.battery.nonzero.joule <- (dataframe$trepn.battery.nonzero.raw.uw / (10^6)) * (dataframe$run.duration.ms / 1000)

  # Parse duration from ms to s
  dataframe$run.duration.s <- dataframe$run.duration.ms / 1000

  dataframe
}

experiment.source.android <- function() {
  dataframe <- experiment.source.csv("Aggregate-Android.csv")

  # Rename columns
  dataframe <- rename(dataframe, c(
    "cpu" = "android.cpu",
    "mem" = "android.memory.kb"
  ))

  # Parse memory from KB to MB
  dataframe$android.memory.mb <- dataframe$android.memory.kb / 1000

  dataframe
}

experiment.source.runtime <- function() {
  dataframe <- cbind(experiment.source.trepn(), experiment.source.android())

  # Remove duplicated columns from aggregating trepn and android (rows matches the runs)
  dataframe <- dataframe[, !duplicated(names(dataframe))]

  # Sort dataframe columns by name
  dataframe <- dataframe[, order(colnames(dataframe))]

  # Sort dataframe rows by subject
  dataframe <- dataframe[order(dataframe$subject.name, dataframe$subject.treatment.id),]

  dataframe
}

experiment.source.prefetching_accuracy <- function() {
  dataframe <- experiment.source.csv("Aggregation-MetricPrefetchingAccuracy.csv")

  # Drop columns
  columns_to_drop <- c("F1_SCORE_2", "subject.id.long")
  dataframe <- dataframe[, !(names(dataframe) %in% columns_to_drop)]

  # Rename columns
  dataframe <- rename(dataframe, c(
    "F1_SCORE_1" = "f1_score",
    "FALSE_NEGATIVE" = "false_negative",
    "FALSE_POSITIVE" = "false_positive",
    "TRUE_POSITIVE" = "true_positive",
    "subject.id.short" = "subject.id"
  ))

  # Calculate other metrics
  dataframe$precision <- dataframe$true_positive / (dataframe$true_positive + dataframe$false_positive)
  dataframe$recall <- dataframe$true_positive / (dataframe$true_positive + dataframe$false_negative)
  dataframe$accuracy <- dataframe$true_positive / (dataframe$true_positive +
    dataframe$false_positive +
    dataframe$false_negative)

  # Sort dataframe columns by name
  dataframe <- dataframe[, order(colnames(dataframe))]

  # Sort dataframe rows by subject
  dataframe <- dataframe[order(dataframe$subject.name, dataframe$subject.treatment.id),]

  dataframe
}

experiment.source.strategy_accuracy <- function() {
  dataframe <- experiment.source.csv("Aggregation-MetricStrategyAccuracy.csv")

  # Drop columns
  columns_to_drop <- "subject.id.long"
  dataframe <- dataframe[, !(names(dataframe) %in% columns_to_drop)]

  # Rename columns
  dataframe <- rename(dataframe, c(
    "CASES_COUNT" = "count.cases",
    "EXCEPTION_COUNT" = "count.exception",
    "EXECUTION_COUNT" = "count.execution",
    "INSUFFICIENT_SCORE_COUNT" = "count.insufficient_score",
    "NO_SUCCESSOR_COUNT" = "count.no_sucessor",
    "HIT_COUNT" = "count.hits",
    "MISS_COUNT" = "count.misses",
    "HIT_PERCENTAGE_TOTAL" = "accuracy.total",
    "HIT_PERCENTAGE_WHEN_PREDICTED" = "accuracy.predicted",
    "subject.id.short" = "subject.id"
  ))

  ## Calculate other metrics
  dataframe$true_positive <- dataframe$count.hits
  dataframe$false_positive <- dataframe$count.misses
  dataframe$false_negative <- dataframe$count.execution -
    dataframe$true_positive -
    dataframe$false_positive
  dataframe$precision <- dataframe$true_positive / (dataframe$true_positive + dataframe$false_positive)
  dataframe$recall <- dataframe$true_positive / (dataframe$true_positive + dataframe$false_negative)
  dataframe$f1_score <- dataframe$true_positive / (dataframe$true_positive + 1 / 2 * (dataframe$false_positive + dataframe$false_negative))

  # Sort dataframe columns by name
  dataframe <- dataframe[, order(colnames(dataframe))]

  # Sort dataframe rows by subject
  dataframe <- dataframe[order(dataframe$subject.name, dataframe$subject.treatment.id),]

  dataframe
}

experiment.source.network_request_execution_time <- function() {
  dataframe <- experiment.source.csv("Aggregation-MetricNetworkRequestExecutionTime.csv")

  # Drop columns
  columns_to_drop <- "subject.id.long"
  dataframe <- dataframe[, !(names(dataframe) %in% columns_to_drop)]

  # Rename columns
  dataframe <- rename(dataframe, c(
    "REQUEST_DURATION_OKHTTP" = "request.duration.from_okhttp.ms",
    "REQUEST_DURATION_SYSTEM" = "request.duration.from_system.ms",
    "REQUEST_PROTOCOL" = "request.protocol",
    "REQUEST_SYNCHRONOUS" = "request.is_synchronous",
    "REQUEST_URL" = "request.url",
    "RESPONSE_CODE" = "response.code",
    "RESPONSE_LENGTH_HEADER" = "response.length.from_header.b",
    "RESPONSE_LENGTH_OKHTTP" = "response.length.from_okhttp.b",
    "RESPONSE_METHOD" = "response.method",
    "subject.id.short" = "subject.id"
  ))

  # Sort dataframe columns by name
  dataframe <- dataframe[, order(colnames(dataframe))]

  # Sort dataframe rows by subject
  dataframe <- dataframe[order(dataframe$subject.name, dataframe$subject.treatment.id),]

  dataframe
}