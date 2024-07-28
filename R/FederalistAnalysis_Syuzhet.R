library(syuzhet)
library(tidyverse)
library(readtext)
library(reshape2)
library(ggplot2)

# read text file
text <- readtext("~/csar/Civics_texts/The Federalist Papers (1787-88).txt")

# perform sentiment analysis
sentiment_scores <- get_nrc_sentiment(text$text)

# convert the sentiment scores to a tidy data frame
sentiment_scores <- as.data.frame(sentiment_scores)
sentiment_scores$docs <- 1:nrow(sentiment_scores)

# reshape the data for visualization
sentiment_scores <- melt(sentiment_scores, id.vars = "docs", variable.name = "Sentiment", value.name = "Count")

# ensure 'Count' is numeric
sentiment_scores$Count <- as.numeric(sentiment_scores$Count)

# create a summary table of sentiment counts
summary_table <- sentiment_scores %>%
  group_by(Sentiment) %>%
  summarise(Total = sum(Count, na.rm = TRUE)) %>%
  arrange(desc(Total))

#print table
print(summary_table)

# add row numbers to the summary table
summary_table <- summary_table %>%
  mutate(Rank = row_number()) %>%
  select(Rank, everything())

# directory creation
dir.create("~/csar/summary tables", showWarnings = FALSE)
dir.create("~/csar/sentiment_graphs", showWarnings = FALSE)

# save table as file
write.csv(summary_table, "~/csar/summary tables/sentiment_summary_table_syuzhet.csv", row.names = FALSE)

# plot scores
sentiment_plot <- ggplot(sentiment_scores, aes(x = Sentiment, y = Count, fill = Sentiment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Analysis of The Federalist Papers",
       x = "Sentiment",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save plot as file
library_name <- "syuzhet"
ggsave(paste0("~/csar/sentiment_graphs/sentiment_analysis_plot_", library_name, ".png"), plot = sentiment_plot)
