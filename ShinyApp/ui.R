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

shinyUI(navbarPage("Coursera Data Science Capstone", 
                   
                   theme = shinytheme("flatly"),
                   
############################### ~~~~~~~~~~~~~~~~~ ##############################  
     
tabPanel("Next Word Prediction",
         
         tags$head(includeScript("./js/ga-shinyapps-io.js")),
         
         fluidRow(
                 
                 column(3),
                 column(6,
                        tags$div(textInput("text", 
                                  label = h3("Enter your text here:"),
                                  value = ),
                        br(),
                        tags$hr(),
                        h3("The predicted next word:"),
                        tags$strong(tags$h3(textOutput("predictedWord"))),
                        br(),
                        tags$hr(),
                        h5("What you have entered:"),
                        tags$em(textOutput("enteredWords")),
                        align="center")
                        ),
                 column(3)
         )
),

tabPanel("About This Application"),

############################### ~~~~~~~~F~~~~~~~~ ##############################

## Footer

tags$hr(),

tags$br(),

tags$span(style="color:grey", 
          tags$footer(("© 2015 - "), 
                      tags$a(
                              href="http://nierhoff.info",
                              target="_blank",
                              "Maximilian H. Nierhoff."), 
                      tags$br(),
                      ("Built with"), tags$a(
                              href="http://www.r-project.org/",
                              target="_blank",
                              "R,"),
                      tags$a(
                              href="http://shiny.rstudio.com",
                              target="_blank",
                              "Shiny"),
#                       ("&"), tags$a(
#                               href="http://www.rstudio.com/products/shiny/shiny-server",
#                               target="_blank",
#                               "Shiny Server."),
#                       ("Hosted on"), tags$a(
#                               href="https://www.digitalocean.com/?refcode=f34ade566630",
#                               target="_blank",
#                               "DigitalOcean."),
                      
                      align = "center"),
          
          tags$br()
)
)
)
