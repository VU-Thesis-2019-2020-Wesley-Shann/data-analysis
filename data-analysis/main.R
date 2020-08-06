# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 04-08-20

source("util.R")

rq1.data <- experiment.source.runtime()

#plot(rq1.android$mem)
#names(mydata.trepn)
#plot(mydata.trepn$subject.id, mydata.trepn$trepn.battery.nonzero.joule)
#experiment.source.android()

#e <- c("a", "b", "c")

#android <- read.csv(file = "../android-runner-configuration/output/experiment-output/part1_2020.08.03_230233/Aggregate-Android.csv")
##plot(android$mem)
##plot(android$cpu)
#
#trepn <- read.csv(file = "../android-runner-configuration/output/experiment-output/part1_2020.08.03_230233/Aggregate-Trepn.csv")
#trepn$Subject <- as.factor(trepn$Subject)
#trepn$App.package
#trepn_hillffair <- trepn[trepn$App.package == "appteam.nith.hillffair", ]
#trepn_hillffair$Subject <- as.factor(trepn_hillffair$Subject)
##plot(trepnHillffair$Subject, trepnHillffair$Battery.Power..uW...Delta.)
##trepn_hillffair$Subject
##plot(trepn$Run.number, trepn$Battery.Power..uW...Delta.)
##plot(trepn$Battery.Power..uW...Delta...Non.zero.)
##plot(trepn$CPU.Load....)
##plot(trepn$Duration..ms.)
##plot(trepn$Memory.Usage..KB.)
#
#prefetch_accuracy <- read.csv(file = "../android-runner-configuration/output/experiment-output/part1_2020.08.03_230233/Aggregation-MetricPrefetchingAccuracy.csv")
##plot(prefetch_accuracy$RUN_NUMBER, prefetch_accuracy$F1_SCORE_1)
#
#strategy_accuracy <- read.csv(file = "../android-runner-configuration/output/experiment-output/part1_2020.08.03_230233/Aggregation-MetricStrategyAccuracy.csv")
##plot(prefetch_accuracy$RUN_NUMBER, strategy_accuracy$HIT_PERCENTAGE_WHEN_PREDICTED)
##plot(prefetch_accuracy$RUN_NUMBER, strategy_accuracy$HIT_PERCENTAGE_TOTAL)
#
#strategy_time <- read.csv(file = "../android-runner-configuration/output/experiment-output/part1_2020.08.03_230233/Aggregation-MetricNappaPrefetchingStrategyExecutionTime.csv")
#strategy_time$SUBJECT_NAME <- as.factor(strategy_time$SUBJECT_NAME)
#strategy_time_hillffair <- strategy_time[strategy_time$SUBJECT_NAME == "Hillffair", ]
#strategy_time_hillffair$APP_PACKAGE <- as.factor(strategy_time_hillffair$APP_PACKAGE)
#strategy_time_hillffair$TREATMENT <- as.factor(strategy_time_hillffair$TREATMENT)
#plot(strategy_time_hillffair$TREATMENT, strategy_time_hillffair$DURATION)
##plot(strategy_time$SUBJECT_NAME, strategy_time$DURATION)
