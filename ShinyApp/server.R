################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                 Maximilian H. Nierhoff (http://nierhoff.info)              ##
##                                                                            ##
##           Github Repo: https://github.com/mhnierhoff/CapstoneCoursera      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

library(shinythemes)
library(shiny)
library(tm)
library(stringr)

source("./inputCleaner.R")
finalData <- readRDS(file="./finalData.RData")


shinyServer(function(input, output) {
        
        wordPrediction <- reactive({
                text <- input$text
                textInput <- cleanInput(text)
                n <- length(textInput)
                wordPrediction <- nextWordPrediction(n,textInput)})
        
        output$predictedWord <- renderPrint(wordPrediction())
        output$enteredWords<- renderPrint({ input$text })
})