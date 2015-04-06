################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                 Maximilian H. Nierhoff (http://nierhoff.info)              ##
##                                                                            ##
##           Github Repo: https://github.com/mhnierhoff/CapstoneCoursera      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

## Loading the sample
theSampleCon <- file("./ShinyApp/textSample.txt")
theSample <- readLines(theSampleCon)
close(theSampleCon)

readFile <- function(filename){
        library(stringr);
        con <- file(filename);
        pars <- readLines(con);
        pars <- pars[-grep("^(\\s+)?$", pars)];
        
        sentences <- list();  
        for (i in 1:length(pars)){
                sentIndex <- 1;
                sents <- strsplit(pars[i], ".", fixed=TRUE)[[1]];
                sentences[[i]] <- array();
                #sents <- paste(sents, " ", sep="");
                for (s in 1:length(sents)){
                        #get sentiment analysis for this sentence
                        
                        strlen <- str_length(paste(sents[s], ""));
                        if (strlen > 6){
                                sentences[[i]][sentIndex] <- sents[s];
                                sentIndex <- sentIndex + 1;
                        }
                }
        }
        
        close(con);
        
        return(sentences);    
}
