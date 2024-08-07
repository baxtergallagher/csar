library(sentimentr)
library(tidyverse)
library(readtext)
library(reshape2)
library(ggplot2)

# read text file
text <- readtext("~/csar/Civics_texts/The Federalist Papers (1787-88).txt")

# split text into sentences
sentences <- get_sentences(text$text)

# perform sentiment analysis
sentiment_scores <- sentiment(sentences)

# categorize sentiments
sentiment_scores <- sentiment_scores %>%
  mutate(Sentiment = case_when(
    sentiment > 0 ~ "positive",
    sentiment < 0 ~ "negative",
    TRUE ~ "neutral"
  ))

# aggregate sentiment counts
sentiment_counts <- sentiment_scores %>%
  count(Sentiment) %>%
  rename(Count = n)

# create a summary table of sentiment counts
summary_table <- sentiment_counts %>%
  arrange(desc(Count))

# print the summary table
print(summary_table)

# add row numbers to the summary table
summary_table <- summary_table %>%
  mutate(Rank = row_number()) %>%
  select(Rank, everything())

# create directories
dir.create("~/csar/summary tables", showWarnings = FALSE)
dir.create("~/csar/sentiment_graphs", showWarnings = FALSE)

# save summary table to file
write.csv(summary_table, "~/csar/summary tables/sentiment_summary_table_sentimentr.csv", row.names = FALSE)

# plot sentiment scores
sentiment_plot <- ggplot(summary_table, aes(x = Sentiment, y = Count, fill = Sentiment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Analysis of The Federalist Papers (sentimentr)",
       x = "Sentiment",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save plot to file
library_name <- "sentimentr"
ggsave(paste0("~/csar/sentiment_graphs/sentiment_analysis_plot_", library_name, ".png"), plot = sentiment_plot)
