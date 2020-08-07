# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

experiment.subject.filter_per_name <- function(dataframe, subject_name) {
  dataframe$subject.name == subject_name
}

experiment.subject.filter_per_id <- function(dataframe, subject_id) {
  dataframe$subject.id == subject_id
}