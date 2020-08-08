# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

experiment.subject.summary <- function(dataframe, property, digits = NA) {
  dataframe_summary.data <- NULL
  dataframe_summary.columns <- NULL
  for (subject_id in unique(dataframe$subject.id)) {
    if (is.na(digits)) {
      data_summary <- summary(dataframe[dataframe$subject.id == subject_id, property])
    } else {
      data_summary <- summary(dataframe[dataframe$subject.id == subject_id, property], digits = digits)
    }
    dataframe_summary.data <- cbind(dataframe_summary.data, as.matrix(data_summary))
    dataframe_summary.columns <- cbind(dataframe_summary.columns, subject_id)
  }
  colnames(dataframe_summary.data) <- dataframe_summary.columns

  dataframe_summary.data
}

experiment.treatment.summary <- function(dataframe, property, digits = NA) {
  dataframe_summary.data <- NULL
  dataframe_summary.columns <- NULL
  for (tretament in levels(dataframe$subject.treatment.name.long)) {
    if (is.na(digits)) {
      data_summary <- summary(dataframe[dataframe$subject.treatment.name.long == tretament, property])
    } else {
      data_summary <- summary(dataframe[dataframe$subject.treatment.name.long == tretament, property], digits = digits)
    }
    dataframe_summary.data <- cbind(dataframe_summary.data, as.matrix(data_summary))
    dataframe_summary.columns <- cbind(dataframe_summary.columns, tretament)
  }
  colnames(dataframe_summary.data) <- dataframe_summary.columns

  dataframe_summary.data
}