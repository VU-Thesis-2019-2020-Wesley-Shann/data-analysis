# Title     : TODO
# Objective : TODO
# Created by: sshann
# Created on: 07-08-20

experiment.write.base_dir <- "/home/sshann/Documents/thesis/experiments/data-analysis/output"

experiment.write.latex <- function(rq, dataframe, file_name, label = NULL, digits = NULL, caption = NULL) {
  print(
    xtable(
      dataframe,
      type = "latex",
      digits = digits,
      caption = caption,
      label = label),
    file = paste(experiment.write.base_dir, paste0("rq", rq), file_name, sep = "/"))
}

experiment.write.plot <- function(path, filename, rq, plot = last_plot()) {
  ggsave(plot = plot,
         path = paste(experiment.write.base_dir, paste0("rq", rq), sep = "/"),
         filename = filename)
}