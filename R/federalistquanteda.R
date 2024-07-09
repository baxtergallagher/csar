library(quanteda)
library(tidyverse)
library(readtext)
library(textdata)

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
