library(tidyverse)

# set directories
concordance_dir <- "~/csar/Split Federalist Analysis/Concordances/"
folders <- list.dirs(concordance_dir, recursive = FALSE)

for (folder in folders) {
  # fed paper numbers
  paper_number <- str_extract(basename(folder), "\\d+")
  
  # path to concordance file
  concordance_file <- file.path(folder, paste0("concordance_Federalist_", paper_number, ".csv"))
  
  # read concordance data
  concordance_data <- read.csv(concordance_file)
  
  # extract keyword from concordance data
  keyword <- unique(concordance_data$keyword)[1] # Assumes one keyword per file
  
  # count occurrences of the keyword
  keyword_counts <- concordance_data %>%
    group_by(docname) %>%
    summarise(count = n())
  
  # bar graph occurences
  plot <- keyword_counts %>%
    ggplot(aes(x = reorder(docname, count), y = count, fill = docname)) +
    geom_bar(stat = "identity") +
    labs(title = paste("Occurrences of '", keyword, "' in Federalist #", paper_number),
         x = "Document",
         y = paste("Frequency of '", keyword, "'", sep = "")) +
    theme_minimal() +
    theme(legend.position = "none")
  
  # save graph
  graph_file <- file.path(folder, paste0("occurrences_", keyword, "_Federalist_", paper_number, ".png"))
  ggsave(graph_file, plot)
}
