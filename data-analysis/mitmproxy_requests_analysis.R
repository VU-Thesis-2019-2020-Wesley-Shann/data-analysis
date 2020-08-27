# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 27-08-20

# Load required libraries
library(dplyr)
library(ggsci)
library(ggplot2)
library(xtable)
library(rcompanion)
library(MASS)
library(effsize)

# Load utility files
source("util/write_data.R")
source("util/plot.R")

experiment.mitmproxy.dir.root <- "/home/sshann/Documents/thesis/experiments/mitmproxy-5.2-linux"
experiment.mitmproxy.dir.output <- paste(experiment.mitmproxy.dir.root, 'output', sep = '/')
experiment.mitmproxy.dir.flows <- paste(experiment.mitmproxy.dir.root, 'flows', sep = '/')

experiment.mitmproxy.flows.dataframe.antenna <- read.csv(paste(experiment.mitmproxy.dir.flows, "antennapod_2.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.antenna$app <- "Antenna Pod"

experiment.mitmproxy.flows.dataframe.hillfair <- read.csv(paste(experiment.mitmproxy.dir.flows, "hillffair.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.hillfair$app <- "Hill'Fair"

experiment.mitmproxy.flows.dataframe.materialistic <- read.csv(paste(experiment.mitmproxy.dir.flows, "materialistic_2.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.materialistic$app <- "Materialistic"

experiment.mitmproxy.flows.dataframe.newsblur <- read.csv(paste(experiment.mitmproxy.dir.flows, "newsblur.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.newsblur$app <- "NewsBlur"

experiment.mitmproxy.flows.dataframe.redreader <- read.csv(paste(experiment.mitmproxy.dir.flows, "redreader.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.redreader$app <- "RedReader"

experiment.mitmproxy.flows.dataframe.travelmate <- read.csv(paste(experiment.mitmproxy.dir.flows, "travelmate_2.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.travelmate$app <- "Travel Mate"

experiment.mitmproxy.flows.dataframe.uob <- read.csv(paste(experiment.mitmproxy.dir.flows, "uob.csv", sep = "/"))
experiment.mitmproxy.flows.dataframe.uob$app <- "UOB Timetable"

experiment.mitmproxy.flows.dataframe <- rbind(
  experiment.mitmproxy.flows.dataframe.antenna,
  experiment.mitmproxy.flows.dataframe.hillfair,
  experiment.mitmproxy.flows.dataframe.materialistic,
  experiment.mitmproxy.flows.dataframe.newsblur,
  experiment.mitmproxy.flows.dataframe.redreader,
  experiment.mitmproxy.flows.dataframe.travelmate,
  experiment.mitmproxy.flows.dataframe.uob
)

experiment.mitmproxy.flows.dataframe$response_size_kb <- experiment.mitmproxy.flows.dataframe$response_size / 1024
#experiment.mitmproxy.flows.dataframe <- replace(experiment.mitmproxy.flows.dataframe, experiment.mitmproxy.flows.dataframe == "NA", NA)

# OK
ggplot(data = experiment.mitmproxy.flows.dataframe, aes(y = app, fill = app)) +
  geom_bar() +
  geom_text(stat = 'count', aes(label = ..count..), hjust = -1) +
  labs(
    y = "Subject",
    x = "Count of network requests"
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_fill_tron() +
  expand_limits(x = 850)
experiment.write.plot(filename = "mitmproxy_network_requent_number.png", rq = 0)


ggplot(data = experiment.mitmproxy.flows.dataframe, aes(y = response_header_content_type, fill = response_header_content_type)) +
  geom_bar() +
  geom_text(stat = 'count', aes(label = ..count..), hjust = -1) +
  labs(
    y = "Response content type",
    x = "Count"
  ) +
  theme(
    legend.position = "none"
  ) +
  scale_fill_tron() +
  expand_limits(x = 850)
experiment.write.plot(filename = "mitmproxy_network_response_content_type.png", rq = 0)

# Doesn't look right
experiment.plot.boxplot(experiment.mitmproxy.flows.dataframe[experiment.mitmproxy.flows.dataframe$response_duration >= 0,],
                        "response_duration",
                        "Response duration (ms)",
                        fill = "app",
                        axis_x_column = "app",
                        axis_x_legend = "Application")
# OK
experiment.plot.boxplot(experiment.mitmproxy.flows.dataframe,
                        "response_size_kb",
                        "Response size (KB)",
                        fill = "app",
                        axis_x_column = "app",
                        axis_x_legend = "Subject")
experiment.write.plot(filename = "mitmproxy_network_response_length.png", rq = 0)


experiment.mitmproxy.flows.dataframe_no_na <- experiment.mitmproxy.flows.dataframe[!is.na(experiment.mitmproxy.flows.dataframe$response_size_kb),]
dataframe_summary.data <- NULL
dataframe_summary.columns <- NULL
for (app in unique(experiment.mitmproxy.flows.dataframe_no_na$app)) {
  print(app)
  dataframe_summary.data <- cbind(dataframe_summary.data,
                                  as.matrix(summary(experiment.mitmproxy.flows.dataframe_no_na[experiment.mitmproxy.flows.dataframe_no_na$app == app, "response_size_kb"])))
  dataframe_summary.columns <- cbind(dataframe_summary.columns, app)
}
colnames(dataframe_summary.data) <- dataframe_summary.columns

dataframe_summary.data
experiment.write.latex(rq = 0,
                       dataframe = t(dataframe_summary.data),
                       filename = "summary_mitmproxy_network_response_size.tex")

summary(experiment.mitmproxy.flows.dataframe[experiment.mitmproxy.flows.dataframe$app == "RedReader", "response_size_kb"])

experiment.plot.boxplot(experiment.mitmproxy.flows.dataframe_no_na[experiment.mitmproxy.flows.dataframe$response_size_kb < 100,],
                        "response_size_kb",
                        "Response size (BB)",
                        fill = "app",
                        axis_x_column = "app",
                        axis_x_legend = "Application")


experiment.mitmproxy.output.dataframe.part1 <- read.csv(paste(experiment.mitmproxy.dir.output, "part1_flows_20.08.04_223600.flow.csv", sep = "/"))
experiment.mitmproxy.output.dataframe.part1$experiment_part <- as.factor(1)
experiment.mitmproxy.output.dataframe.part2 <- read.csv(paste(experiment.mitmproxy.dir.output, "part2_flows_20.08.05_002520.flow.csv", sep = "/"))
experiment.mitmproxy.output.dataframe.part2$experiment_part <- as.factor(2)

experiment.mitmproxy.output.dataframe <- rbind(
  experiment.mitmproxy.output.dataframe.part1,
  experiment.mitmproxy.output.dataframe.part2
)

experiment.mitmproxy.output.dataframe$response_size_kb <- experiment.mitmproxy.output.dataframe$response_size / 1024
experiment.mitmproxy.output.dataframe <- replace(experiment.mitmproxy.output.dataframe, experiment.mitmproxy.output.dataframe == "NA", NA)


experiment.plot.boxplot(experiment.mitmproxy.output.dataframe[!is.na(experiment.mitmproxy.output.dataframe$request_header_x_requested_with),],
                        "response_size_kb",
                        "Response size (KB)",
                        fill = "request_header_x_requested_with",
                        axis_x_column = "request_header_x_requested_with",
                        axis_x_legend = "Subject")