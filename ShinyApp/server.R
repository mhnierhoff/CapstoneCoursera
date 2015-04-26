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

source("./inputCleaner.R")
finalData <- readRDS(file="./data/finalData.RData")


shinyServer(function(input, output) {
        
        wordPrediction <- reactive({
                text <- input$text
                textInput <- cleanInput(text)
                wordCount <- length(textInput)
                wordPrediction <- nextWordPrediction(wordCount,textInput)})
        
        output$predictedWord <- renderPrint(wordPrediction())
        output$enteredWords<- renderPrint({ input$text })
})