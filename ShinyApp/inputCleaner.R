################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                 Maximilian H. Nierhoff (http://nierhoff.info)              ##
##                                                                            ##
##           Github Repo: https://github.com/mhnierhoff/CapstoneCoursera      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

suppressPackageStartupMessages(c(
        library(shinythemes),
        library(shiny),
        library(tm),
        library(stringr),
        library(stylo)))

finalData <- readRDS(file="./data/finalData.RData")

dataCleaner<-function(text){
        
        cleanText <- tolower(text)
        cleanText <- removePunctuation(cleanText)
        cleanText <- removeNumbers(cleanText)
        cleanText <- str_replace_all(cleanText, "[^[:alnum:]]", " ")
        cleanText <- stripWhitespace(cleanText)

        return(cleanText)
}

cleanInput <- function(text){
        
        textInput <- dataCleaner(text)
        textInput <- txt.to.words.ext(textInput, 
                                      language="English.all", 
                                      preserve.case = TRUE)
        
        return(textInput)
}


nextWordPrediction <- function(wordCount,textInput){
        
        if (wordCount>=3) {
                textInput <- textInput[(wordCount-2):wordCount] 
                
        }
        
        else if(wordCount==2) {
                textInput <- c(NA,textInput)   
                
        }
        else {
                textInput <- c(NA,NA,textInput)
        }
        
        wordPrediction <- as.character(finalData[finalData$unigram==textInput[1] & 
                                        finalData$bigram==textInput[2] & 
                                        finalData$trigram==textInput[3],][1,]$quadgram)
        
        if(is.na(wordPrediction)) {
                wordPrediction <- as.character(finalData[finalData$bigram==textInput[2] & 
                                        finalData$trigram==textInput[3],][1,]$quadgram)
        
                if(is.na(wordPrediction)) {
                wordPrediction <- as.character(finalData[finalData$trigram==textInput[3],][1,]$quadgram)
                }
        } 
        
        print(wordPrediction)
        
}