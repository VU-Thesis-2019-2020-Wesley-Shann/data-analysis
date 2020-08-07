# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

experiment.write.base_dir <- "/home/sshann/Documents/thesis/experiments/data-analysis/output"

experiment.write.latex <- function(rq, dataframe, file_name) {
  print(xtable(dataframe, type = "latex"),
        file = paste(experiment.write.base_dir, paste0("rq", rq), file_name, sep = "/"))
}