################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                 Maximilian H. Nierhoff (http://nierhoff.info)              ##
##                                                                            ##
##           Github Repo: https://github.com/mhnierhoff/CapstoneCoursera      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

library(RWekajars)
library(qdapDictionaries)
library(qdapRegex)
library(qdapTools)
library(RColorBrewer)
library(qdap)
library(NLP)
library(tm)
library(SnowballC)
library(slam)
library(RWeka)
library(rJava)
library(dplyr)

## Building a clean corpus

theSampleCon <- file("./newTextSample.txt")
theSample <- readLines(theSampleCon)
close(theSampleCon)

profanityWords <- read.table("./profanityfilter.txt", header = FALSE)

## Build the corpus, and specify the source to be character vectors 
cleanSample <- Corpus(VectorSource(theSample))

##
rm(theSample)

## Make it work with the new tm package
cleanSample <- tm_map(cleanSample,
                      content_transformer(function(x) 
                              iconv(x, to="UTF-8", sub="byte")),
                      mc.cores=2)

## Convert to lower case
cleanSample <- tm_map(cleanSample, content_transformer(tolower), lazy = TRUE)

## remove punction, numbers, URLs, stop, profanity and stem wordson
cleanSample <- tm_map(cleanSample, content_transformer(removePunctuation))
cleanSample <- tm_map(cleanSample, content_transformer(removeNumbers))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x) 
cleanSample <- tm_map(cleanSample, content_transformer(removeURL))
cleanSample <- tm_map(cleanSample, stripWhitespace)
cleanSample <- tm_map(cleanSample, removeWords, stopwords("english"))
cleanSample <- tm_map(cleanSample, removeWords, profanityWords)
cleanSample <- tm_map(cleanSample, stemDocument)
cleanSample <- tm_map(cleanSample, stripWhitespace)

## Saving the final corpus
saveRDS(cleanSample, file = "./ShinyApp/finalCorpus.RData")

## Load the final Corpus
theCorpus <- readRDS(file = "./finalCorpus.RData")
sampleTDM <- TermDocumentMatrix(theCorpus)
saveRDS(sampleTDM, file = "./sampleTDM.RData")
