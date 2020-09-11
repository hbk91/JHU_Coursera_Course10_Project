library(stringi); library(tm); library(data.table); library(textclean); library(tokenizers)

# ----------------------------------------
# 1. Reading the Data
# ----------------------------------------

url <- 'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip'
destination <- paste0(getwd(),'/Project_Data.zip')

if(!file.exists(destination)){
    download.file(url=url, destfile=destination, method='curl')
    unzip(zipfile=destination, exdir='.')    
}

file_blogs <- file(paste0(getwd(),'/final/en_US/en_US.blogs.txt'))
data_blogs <- readLines(file_blogs,encoding = "UTF-8",skipNul = TRUE)
close(file_blogs)

file_news <- file(paste0(getwd(),'/final/en_US/en_US.news.txt'),'rb')
data_news <- readLines(file_news,encoding = "UTF-8",skipNul = TRUE)
close(file_news)

file_twitter <- file(paste0(getwd(),'/final/en_US/en_US.twitter.txt'))
data_twitter <- readLines(file_twitter,encoding = "UTF-8",skipNul = TRUE)
close(file_twitter)

# ----------------------------------------
# 2. Sampling the Data
# ----------------------------------------

set.seed(12354)
sample_size <- 10000

dataset <- c(sample(data_blogs, size=sample_size),
             sample(data_news, size=sample_size),
             sample(data_twitter, size=sample_size))

remove(data_blogs, data_news, data_twitter) # Freeing up memory

#-------------------------------------------------------------------------------
# 3. Clean Data
#-------------------------------------------------------------------------------

banned_words <- c('fuck','dick','motherfucker','dick','bastard', 'asshole', 
                  'wanker', 'fucking')

dataset <- replace_non_ascii(dataset)
dataset <- VCorpus(VectorSource(dataset))
dataset <- tm_map(dataset, removeNumbers)
dataset <- tm_map(dataset, removePunctuation, preserve_intra_word_dashes=TRUE)
dataset <- tm_map(dataset, content_transformer(tolower))
dataset <- tm_map(dataset, removeWords, banned_words)
dataset <- tm_map(dataset, stripWhitespace)
dataset <- data.table(rawtext = sapply(dataset, as.character))
dataset <- dataset[!is.na(rawtext)]

# ----------------------------------------
# 4 Creating Fourgrams
# ----------------------------------------

fourgrams <- tokenize_ngrams(dataset$rawtext,n = 4,n_min = 4)
fourgrams <- table(unlist(fourgrams))
fourgrams <- data.table(fourgrams)

fourgrams[, paste0('Word', 1:4) := tstrsplit(V1,' ')][, V1:=NULL]
setorder(fourgrams,-N)
saveRDS(fourgrams, file = "fourgrams.rds")

# ----------------------------------------
# 5 Creating Trigrams
# ----------------------------------------

trigrams <- data.table(table(unlist(tokenize_ngrams(dataset$rawtext,n = 3,n_min = 3))))
trigrams[, paste0('Word', 1:3) := tstrsplit(V1,' ')][, V1:=NULL]
setorder(trigrams,-N)
saveRDS(trigrams, file = "trigrams.rds")

# ----------------------------------------
# 6 Creating Bigrams
# ----------------------------------------

bigrams <- data.table(table(unlist(tokenize_ngrams(dataset$rawtext,n = 2,n_min = 2))))
bigrams[, paste0('Word', 1:2) := tstrsplit(V1,' ')][, V1:=NULL]
setorder(bigrams,-N)
saveRDS(bigrams, file = "bigrams.rds")

