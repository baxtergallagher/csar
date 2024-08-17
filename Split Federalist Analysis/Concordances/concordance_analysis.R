library(tidyverse)
library(igraph)
library(ggraph)

# directories
concordance_dir <- "~/csar/Split Federalist Analysis/Concordances/"
folders <- list.dirs(concordance_dir, recursive = FALSE)

for (folder in folders) {
  # numbers
  paper_number <- str_extract(basename(folder), "\\d+")
  
  if (is.na(paper_number)) next # Skip if the folder name does not contain a number
  
  # path to file
  concordance_file <- file.path(folder, paste0("concordance_Federalist_", paper_number, ".csv"))
  
  # read data
  if (!file.exists(concordance_file)) next # Skip if the file does not exist
  
  concordance_data <- read.csv(concordance_file)
  
  # determine most frequent keyword
  most_frequent_keyword <- concordance_data %>%
    group_by(keyword) %>%
    summarise(count = n()) %>%
    arrange(desc(count)) %>%
    slice(1) %>%
    pull(keyword)
  
  # analyze context words
  context_words <- concordance_data %>%
    filter(keyword == most_frequent_keyword) %>%
    select(pre, post) %>%
    gather(key = "position", value = "context") %>%
    separate_rows(context, sep = " ") %>%
    filter(context != "") %>%
    count(context) %>%
    arrange(desc(n))
  
  # create an edge list for the network graph
  edges <- context_words %>%
    filter(n > 1) %>%  # Filter to show only significant connections
    mutate(from = most_frequent_keyword, to = context)
  
  # create the network graph
  g <- graph_from_data_frame(edges, directed = FALSE)
  
  # plot network graph
  plot <- ggraph(g, layout = "fr") +
    geom_edge_link(aes(edge_alpha = n), show.legend = FALSE) +
    geom_node_point(color = "lightblue", size = 5) +
    geom_node_text(aes(label = name), repel = TRUE) +
    labs(title = paste("Keyword Context Network in Federalist #", paper_number)) +
    theme_void()
  
  # save graph
  graph_file <- file.path(folder, paste0("keyword_context_network_Federalist_", paper_number, ".png"))
  ggsave(graph_file, plot)
}
