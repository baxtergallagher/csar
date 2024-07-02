# libraries
library(tidyverse)
library(tidytext)

# read text file into a vector
path_to_file <- "The Federalist Papers (1787-88).txt"
t1 <- readLines(path_to_file)

# convert to tidy format
# create data frame from text lines
t1_df <- tibble(line = 1:length(t1), text = t1)

# tokenize text to words
t1_words <- t1_df %>%
  unnest_tokens(word, text)

# basic text analysis
# remove stop words
data("stop_words")
t1_cleaned <- t1_words %>%
  anti_join(stop_words)

# word frequencies
word_counts <- t1_cleaned %>%
  count(word, sort = TRUE)

# top 10 most frequent words
print(word_counts %>% top_n(10))

# visualizing and graphing
word_counts %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 20 Most Frequent Words in The Federalist Papers",
       x = "Words",
       y = "Frequency") +
  theme_minimal()
