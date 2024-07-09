library(quanteda)
library(tidyverse)
library(readtext)
library(textdata)
library(reshape2)
library(ggplot2)

# read text file
text <- readtext("~/csar/Civics_texts/The Federalist Papers (1787-88).txt")

# corpus
corp2 <- corpus(text)

# tokenize
tokens <- tokens(corp2, remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE)

# no stopwords
tokens <- tokens_select(tokens, pattern = stopwords("en"), selection = "remove")

# (DFM)
dfm <- dfm(tokens)

# sentiment lexicon
nrc <- textdata::lexicon_nrc()

# NRC lexicon to dictionary 
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

# sentiment analysis
sentiment_dfm <- dfm_lookup(dfm, dictionary = nrc_dict)

# display head of sentiment scores
head(sentiment_dfm)

# convert to tidy
sentiment_scores <- convert(sentiment_dfm, to = "data.frame")

# doc identifier
sentiment_scores$docs <- rownames(sentiment_scores)

# reshaping the data for visualization
sentiment_scores <- melt(sentiment_scores, id.vars = "docs", variable.name = "Sentiment", value.name = "Count")

# plotting the sentiment scores
ggplot(sentiment_scores, aes(x = Sentiment, y = Count, fill = Sentiment)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Sentiment Analysis of The Federalist Papers",
       x = "Sentiment",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))