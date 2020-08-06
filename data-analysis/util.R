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
    "Treatment" = "subject.treatment",
    "Subject" = "subject.id",
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

  # Set factors
  dataframe$subject.treatment <- as.factor(dataframe$subject.treatment)
  dataframe$subject.id <- as.factor(dataframe$subject.id)
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

  dataframe
}

experiment.source.android <- function() {
  dataframe <- experiment.source.csv("Aggregate-Android.csv")

  dataframe <- rename(dataframe, c(
    "cpu" = "android.cpu",
    "mem" = "android.memory"
  ))

  dataframe
}

experiment.source.runtime <- function() {
  dataframe <- cbind(experiment.source.trepn(), experiment.source.android())
  dataframe <- dataframe[, !duplicated(names(dataframe))]

  dataframe
}