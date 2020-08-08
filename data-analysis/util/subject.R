# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

experiment.subject.summary <- function(dataframe, property) {
  dataframe_summary.data <- NULL
  dataframe_summary.columns <- NULL
  for (subject_id in unique(dataframe$subject.id)) {
    dataframe_summary.data <- cbind(
      dataframe_summary.data,
      as.matrix(summary(dataframe[dataframe$subject.id == subject_id, property]))
    )
    dataframe_summary.columns <- cbind(dataframe_summary.columns, subject_id)
  }
  colnames(dataframe_summary.data) <- dataframe_summary.columns

  dataframe_summary.data
}