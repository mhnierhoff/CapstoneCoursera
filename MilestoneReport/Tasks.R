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
library(wordcloud)
library(stringr)
library(DT)
library(stringi)

################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

## Data acquisition

## Loading the dataset

#--!! fileURL <- "http://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
#--!! download.file(fileURL, destfile = "Dataset.zip", method = "curl")
#--!! unlink(fileURL)
#--!! unzip("Dataset.zip")

## Sampeling

## Loading the original data set
blogs <- readLines("./final/en_US/en_US.blogs.txt", 
                   encoding = "UTF-8", skipNul=TRUE)
news <- readLines("./final/en_US/en_US.news.txt", 
                  encoding = "UTF-8", skipNul=TRUE)
twitter <- readLines("./final/en_US/en_US.twitter.txt", 
                     encoding = "UTF-8", skipNul=TRUE)

## Generating a random sapmle of all sources
sampleTwitter <- twitter[sample(1:length(twitter),10000)]
sampleNews <- news[sample(1:length(news),10000)]
sampleBlogs <- blogs[sample(1:length(blogs),10000)]
textSample <- c(sampleTwitter,sampleNews,sampleBlogs)

## Save sample
writeLines(textSample, "./MilestoneReport/textSample.txt")

################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

## Checking the size and length of the files and calculate the word count
blogsFile <- file.info("./final/en_US/en_US.blogs.txt")$size / 1024.0 / 1024.0
newsFile <- file.info("./final/en_US/en_US.news.txt")$size / 1024.0 / 1024.0
twitterFile <- file.info("./final/en_US/en_US.twitter.txt")$size / 1024.0 / 1024.0
sampleFile <- file.info("./MilestoneReport/textSample.txt")$size / 1024.0 / 1024.0

blogsLength <- length(blogs)
newsLength <- length(news)
twitterLength <- length(twitter)
sampleLength <- length(theSample)

blogsWords <- sum(sapply(gregexpr("\\S+", blogs), length))
newsWords <- sum(sapply(gregexpr("\\S+", news), length))
twitterWords <- sum(sapply(gregexpr("\\S+", twitter), length))
sampleWords <- sum(sapply(gregexpr("\\S+", theSample), length))

fileSummary <- data.frame(
        fileName = c("Blogs","News","Twitter", "Aggregated Sample"),
        fileSize = c(round(blogsFile, digits = 2), 
                     round(newsFile,digits = 2), 
                     round(twitterFile, digits = 2),
                     round(sampleFile, digits = 2)),
        lineCount = c(blogsLength, newsLength, twitterLength, sampleLength),
        wordCount = c(blogsWords, newsWords, twitterWords, sampleLength)                  
)

colnames(fileSummary) <- c("File Name", "File Size in Megabyte", "Line Count", "Word Count")

saveRDS(fileSummary, file = "./MilestoneReport/fileSummary.Rda")

fileSummaryDF <- readRDS("./MilestoneReport/fileSummary.Rda")

################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

## Building a clean corpus

theSampleCon <- file("./MilestoneReport/textSample.txt")
theSample <- readLines(theSampleCon)
close(theSampleCon)

profanityWords <- read.table("./MilestoneReport/profanityfilter.txt", header = FALSE)

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
saveRDS(cleanSample, file = "./MilestoneReport/finalCorpus.RDS")


################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

## Exploratory analysis 

## Budilding the n-grams

finalCorpus <- readRDS("./MilestoneReport/finalCorpus.RDS")
finalCorpusDF <-data.frame(text=unlist(sapply(finalCorpus,`[`, "content")), 
                           stringsAsFactors = FALSE)

## Building the tokenization function for the n-grams
ngramTokenizer <- function(theCorpus, ngramCount) {
        ngramFunction <- NGramTokenizer(theCorpus, 
                                Weka_control(min = ngramCount, max = ngramCount, 
                                delimiters = " \\r\\n\\t.,;:\"()?!"))
        ngramFunction <- data.frame(table(ngramFunction))
        ngramFunction <- ngramFunction[order(ngramFunction$Freq, 
                                             decreasing = TRUE),][1:10,]
        colnames(ngramFunction) <- c("String","Count")
        ngramFunction
}

trigram <- ngramTokenizer(finalCorpusDF, 1)
saveRDS(trigram, file = "./MilestoneReport/trigram.RDS")
bigram <- ngramTokenizer(finalCorpusDF, 2)
saveRDS(bigram, file = "./MilestoneReport/bigram.RDS")
trigram <- ngramTokenizer(finalCorpusDF, 3)
saveRDS(trigram, file = "./MilestoneReport/trigram.RDS")

## trigram plot
trigram <- readRDS("./MilestoneReport/trigram.RDS")
trigramPlot <- gvisColumnChart(trigram, "String", "Count",                  
                            options=list(legend="none"))

## bigram plot
bigram <- readRDS("./MilestoneReport/bigram.RDS")
bigramPlot <- gvisColumnChart(bigram, "String", "Count",                  
                               options=list(legend="none"))


## trigram plot
trigram <- readRDS("./MilestoneReport/trigram.RDS")
trigramPlot <- gvisColumnChart(trigram, "String", "Count",                  
                               options=list(legend="none"))


## Creating a wordcloud


trigramTDM <- TermDocumentMatrix(finalCorpus)
wcloud <- as.matrix(trigramTDM)
v <- sort(rowSums(wcloud),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
wordcloud(d$word,d$freq,
          c(5,.3),50,
          random.order=FALSE,
          colors=brewer.pal(8, "Dark2"))

