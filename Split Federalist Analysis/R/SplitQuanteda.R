library(quanteda)
library(tidyverse)
library(readtext)
library(textdata)
library(reshape2)
library(ggplot2)

# Set directories
input_dir <- "~/csar/Split Federalist Analysis/Individual Federalists/"
output_dir_graphs <- "~/csar/Split Federalist Analysis/Sentiment Graphs/"
output_dir_tables <- "~/csar/Split Federalist Analysis/Summary Tables/"

# Read and process each file
file_list <- list.files(input_dir, full.names = TRUE)
