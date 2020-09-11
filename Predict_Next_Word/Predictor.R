# Loading Libraries

library(tm); library(data.table); library(textclean)

# Loading Prediction N-Gram Models

fourgrams <- readRDS('fourgrams.rds')
trigrams <- readRDS('trigrams.rds')
bigrams <- readRDS('bigrams.rds')

#-------------------------------------------------------------------------------
# Prediction Functions
#-------------------------------------------------------------------------------

fourgram_predict <- function(x){
    len_x <- length(x)
    fourgrams[Word1 == x[len_x-2] & Word2 == x[len_x-1] & Word3 == x[len_x], Word4][1]
}

trigram_predict <- function(x){
    len_x <- length(x)
    trigrams[Word1 == x[len_x-1] & Word2 == x[len_x], Word3][1]
}

bigram_predict <- function(x){
    len_x <- length(x)
    bigrams[Word1 == x[len_x], Word2][1]
}

generic_predict <- function(x){'welcome'}

#-------------------------------------------------------------------------------
# Preprocess Input
#-------------------------------------------------------------------------------

clean_xtest <- function(x_test){
    
    banned_words <- c('fuck','dick','motherfucker','dick','bastard', 'asshole', 
                      'wanker', 'fucking')
    x_test <- replace_non_ascii(x_test)
    x_test <- VCorpus(VectorSource(x_test))
    x_test <- tm_map(x_test, removeNumbers)
    x_test <- tm_map(x_test, removePunctuation, preserve_intra_word_dashes=TRUE)
    x_test <- tm_map(x_test, content_transformer(tolower))
    x_test <- tm_map(x_test, removeWords, banned_words)
    x_test <- tm_map(x_test, stripWhitespace)
    x_test <- sapply(x_test, as.character)
    as.character(unlist(strsplit(x_test, ' ')))
} 

#-------------------------------------------------------------------------------
# Prediction Match from Fourgrams, Trigrams and Bigrams
#-------------------------------------------------------------------------------

predict_match <- function(x_test){
    
    len_xtest <- length(x_test)
    if(len_xtest == 0){
        return(generic_predict(x_test))
    }
    
    else if(len_xtest == 1){
        return(bigram_predict(x_test))
    }
    
    else if(len_xtest == 2){
        temp_pred <- trigram_predict(x_test)
        if(is.na(temp_pred)){
            temp_pred <- bigram_predict(x_test)
        }
        return(temp_pred)
    }
    
    else if(len_xtest > 2){
        temp_pred <- fourgram_predict(x_test)
        if(is.na(temp_pred)){
            temp_pred <- trigram_predict(x_test)
            if(is.na(temp_pred)){
                temp_pred <- bigram_predict(x_test) 
            }
        }
        return(temp_pred)
    }
}

#-------------------------------------------------------------------------------
# Predicted Next Word
#-------------------------------------------------------------------------------

next_word <- function(x_test){
    x_test <- clean_xtest(x_test)
    y_pred <- predict_match(x_test)
    ifelse(is.na(y_pred), generic_predict(x_test), y_pred)
}

input_string = 'I will eat'
next_word(input_string)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
