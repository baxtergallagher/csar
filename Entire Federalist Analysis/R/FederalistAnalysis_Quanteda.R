library(quanteda)
library(tidyverse)
library(readtext)
library(textdata)
library(reshape2)
library(ggplot2)

# read text file
text <- readtext("~/csar/Civics_texts/The Federalist Papers (1787-88).txt")

# make corpus
corp2 <- corpus(text)

# tokenize the corpus
tokens <- tokens(corp2, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE)

# remove stopwords
tokens <- tokens_select(tokens, pattern = stopwords("en"), selection = "remove")

# create DFM
dfm <- dfm(tokens)

# load NRC
nrc <- textdata::lexicon_nrc()

# Convert NRC lexicon to a dictionary
nrc_dict <- dictionary(list(
  anger = nrc %>% filter(sentiment == "anger") %>% pull(word),
  anticipation = nrc %>% filter(sentiment == "anticipation") %>% pull(word),
  disgust = nrc %>% filter(sentiment == "disgust") %>% pull(word),
  fear = nrc %>% filter(sentiment == "fear") %>% pull(word),
  joy = nrc %>% filter(sentiment == "joy") %>% pull(word),
  sadness = nrc %>% filter(sentiment == "sadness") %>% pull(word),
  surprise = nrc %>% filter(sentiment == "surprise") %>% pull(word),
  trust = nrc %>% filter(sentiment == "trust") %>% pull(word),
  negative = nrc %>% filter(sentiment == "negative") %>% pull(word),
  positive = nrc %>% filter(sentiment == "positive") %>% pull(word)
))

# NRC analysis
sentiment_dfm <- dfm_lookup(dfm, dictionary = nrc_dict)

# head
head(sentiment_dfm)

sentiment_scores <- convert(sentiment_dfm, to = "data.frame")

sentiment_scores$docs <- rownames(sentiment_scores)

sentiment_scores <- melt(sentiment_scores, id.vars = "docs", variable.name = "Sentiment", value.name = "Count")

sentiment_scores$Count <- as.numeric(sentiment_scores$Count)

# Create a summary table of sentiment counts
summary_table <- sentiment_scores %>%
  group_by(Sentiment) %>%
  summarise(Total = sum(Count, na.rm = TRUE)) %>%
  arrange(desc(Total))

#print table
print(summary_table)

summary_table <- summary_table %>%
  mutate(Rank = row_number()) %>%
  select(Rank, everything())

# directory creation
dir.create("~/csar/summary tables", showWarnings = FALSE)
dir.create("~/csar/sentiment_graphs", showWarnings = FALSE)

# save table as file
write.csv(summary_table, "~/csar/summary tables/sentiment_summary_table_quanteda.csv", row.names = FALSE)

# plot scores
sentiment_plot <- ggplot(sentiment_scores, aes(x = Sentiment, y = Count, fill = Sentiment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Analysis of The Federalist Papers",
       x = "Sentiment",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# save plot as file
library_name <- "quanteda"
ggsave(paste0("~/csar/sentiment_graphs/sentiment_analysis_plot_", library_name, ".png"), plot = sentiment_plot)
