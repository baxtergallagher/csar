library(quanteda)
library(tidyverse)
library(readtext)

dir_created <- dir.create(file.path(output_dir_concordances, paste0("Federalist #", paper_number)), showWarnings = FALSE)
print(paste("Directory created:", dir_created))

# Set directories
input_dir <- "~/csar/Split Federalist Analysis/Individual Federalist Papers/"
output_dir_concordances <- "~/csar/Split Federalist Analysis/Concordances/"

# read each individual file
file_list <- list.files(input_dir, full.names = TRUE)

for (file in file_list) {
  # take out number from the file name
  paper_number <- str_extract(basename(file), "\\d+")
  
  # read file
  text <- readtext(file)
  
  # corpus
  corp <- corpus(text)
  
  # tokenize corpus
  tokens <- tokens(corp, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE)
  
  # phrase concordance
  concordance <- kwic(tokens, pattern = "liberty", window = 5) # Adjust the window size as needed
  
  # directory creation
  dir.create(file.path(output_dir_concordances, paste0("Federalist #", paper_number)), showWarnings = FALSE)
  
  # save as csv
  write.csv(concordance, file.path(output_dir_concordances, paste0("Federalist #", paper_number, "/concordance_Federalist_", paper_number, ".csv")), row.names = FALSE)
}
