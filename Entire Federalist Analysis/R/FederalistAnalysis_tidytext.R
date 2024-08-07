library(tidytext)
library(tidyverse)
library(readtext)
library(textdata)
library(reshape2)
library(ggplot2)

# Read text file
text <- readtext("~/csar/Civics_texts/The Federalist Papers (1787-88).txt")

# Create a tibble from the text
text_tbl <- tibble(text = text$text)

# Tokenize the text
tokens <- text_tbl %>%
  unnest_tokens(word, text)

# Get NRC sentiment lexicon
nrc_sentiments <- get_sentiments("nrc")

# Perform sentiment analysis
sentiment_scores <- tokens %>%
  inner_join(nrc_sentiments, by = "word") %>%
  count(sentiment, sort = TRUE) %>%
  rename(Sentiment = sentiment, Count = n)

# Add document identifiers
sentiment_scores$docs <- 1:nrow(sentiment_scores)

# Create a summary table of sentiment counts
summary_table <- sentiment_scores %>%
  group_by(Sentiment) %>%
  summarise(Total = sum(Count, na.rm = TRUE)) %>%
  arrange(desc(Total))

# Print the summary table
print(summary_table)

# Add row numbers to the summary table
summary_table <- summary_table %>%
  mutate(Rank = row_number()) %>%
  select(Rank, everything())

# Create the directories if they do not exist
dir.create("~/csar/summary tables", showWarnings = FALSE)
dir.create("~/csar/sentiment_graphs", showWarnings = FALSE)

# Save the summary table to a file in the new folder
write.csv(summary_table, "~/csar/summary tables/sentiment_summary_table_tidytext.csv", row.names = FALSE)

# Plot the sentiment scores
sentiment_plot <- ggplot(sentiment_scores, aes(x = Sentiment, y = Count, fill = Sentiment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Analysis of The Federalist Papers (tidytext)",
       x = "Sentiment",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save the plot to a file in the new folder with the library name in the file name
library_name <- "tidytext"
ggsave(paste0("~/csar/sentiment_graphs/sentiment_analysis_plot_", library_name, ".png"), plot = sentiment_plot)
