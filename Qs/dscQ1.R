## Quiz 1

## Q1

q1q1 <- file.info("datasets/en_US/en_US.blogs.txt")
MB <- (q1q1$size)/1000000

## Q2

q1q2Input <- file("datasets/en_US/en_US.twitter.txt", "r")
q1q2 <- readLines(q1q2Input, skipNul=TRUE)
length(q1q2)
close(q1q2Input)

## Q3

q1q3Input <- paste0("datasets/en_US/",
                    c("en_US.blogs.txt","en_US.news.txt","en_US.twitter.txt"))
for(q1q3 in q1q3Input) {
        print(q1q3)
        con <- file(q1q3,"r")
        texts <- readLines(con, n=-1, skipNul=TRUE)
        close(con)
        print(max(sapply(texts,nchar)))
        print(length(texts))
}


## Q4

q1q4Input <- "datasets/en_US/en_US.twitter.txt"
con <- file(q1q4Input,"r")
tweets <- readLines(q1q4Input, n=-1, skipNul=TRUE)
love <- length(grep("love",tweets))
hate <- length(grep("hate",tweets))
theThinLine <- love/hate
close(con)


## Q5

q1q5Input <- "datasets/en_US/en_US.twitter.txt"
con <- file(q1q5Input,"r")
tweets <- readLines(q1q5Input, n=-1, skipNul=TRUE)
biostatsTweet <- tweets[grep("biostats",tweets)]
close(con)

## Q6

# counted "manually" with CDM+F ;(