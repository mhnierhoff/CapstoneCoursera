################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################
##                                                                            ##
##                        Data Science Capstone Project                       ##
##                                                                            ##            
##                 Maximilian H. Nierhoff (http://nierhoff.info)              ##
##                                                                            ##
##           Github Repo: https://github.com/mhnierhoff/CapstoneCoursera      ##
##                                                                            ##
################# ~~~~~~~~~~~~~~~~~ ######## ~~~~~~~~~~~~~~~~~ #################

source("installpack.R")


#load data
dat<- read.csv("data/train.csv", header=TRUE)
#dat_test <- read.csv("data/test.csv", header=TRUE)

sampleSize=61878
trainSize=58000



#get developing dataset sets
sample_idx <- sample(1:nrow(dat),sampleSize,replace=FALSE)
sample <- dat[sample_idx,] # select all these rows

train_idx <- sample(1:nrow(sample),trainSize,replace=FALSE)
train <- sample[train_idx,]
test <- sample[-train_idx,] # select all but these rows


#write new data
write.table(train,file="data/prac_train.csv",quote=F,col.names=T,row.names=F,sep=",")
write.table(test,file="data/prac_test.csv",quote=F,col.names=T,row.names=F,sep=",")


#h2o deep learning

library(h2o)
localH2O = h2o.init()

#load data to h2o
trData<-h2o.importFile(localH2O,path = "data/prac_train.csv")
tsData<-h2o.importFile(localH2O,path = "data/prac_test.csv")


#,epsilon = 1e-8,autoencoder=TRUE
#validation=tsData,
#grid search
grid_search <- h2o.deeplearning(x=c(1:94), y=95, data=trData, ,classification=TRUE,validation=tsData,
                                hidden=list(c(100,100,100),c(150,150,150),c(180,180,180),c(120,120,120)), epochs=0.1,
                                activation=c("Tanh", "Rectifier"), l1=c(0,1e-5))
best_model <- grid_search@model[[1]]
best_model
best_params <- best_model@model$params
best_params$activation
best_params$hidden
best_params$l1


#Hyper-parameter Tuning with Random Search

models <- c()
for (i in 1:10) {
  rand_activation <- c("TanhWithDropout", "RectifierWithDropout")[sample(1:2,1)]
  rand_numlayers <- sample(2:5,1)
  rand_hidden <- c(sample(10:50,rand_numlayers,T))
  rand_l1 <- runif(1, 0, 1e-3)
  rand_l2 <- runif(1, 0, 1e-3)
  rand_dropout <- c(runif(rand_numlayers, 0, 0.6))
  rand_input_dropout <- runif(1, 0, 0.5)
  dlmodel <- h2o.deeplearning(x=1:94, y=95, data=trData, validation=tsData, ,classification=TRUE,epochs=0.1,
                              activation=rand_activation, hidden=rand_hidden, l1=rand_l1, l2=rand_l2,
                              input_dropout_ratio=rand_input_dropout, hidden_dropout_ratios=rand_dropout)
  models <- c(models, dlmodel)
}


best_err <- best_model@model$valid_class_error #best model from grid search above


for (i in 1:length(models)) {
  err <- models[[i]]@model$valid_class_error
  if (err < best_err) {
    best_err <- err
    best_model <- models[[i]]
  }
}
best_model
best_params <- best_model@model$params
best_params$activation
best_params$hidden
best_params$l1
best_params$l2
best_params$input_dropout_ratio
best_params$hidden_dropout_ratios




dlmodel_continued <- h2o.deeplearning(x=c(2:94), y=95, data=trData, validation=tsData,,classification=TRUE,
                                      checkpoint = best_model, l1=best_params$l1, l2=best_params$l2, epochs=0.5)

dlmodel_continued@model$valid_class_error


#train further
dlmodel_continued_again <- h2o.deeplearning(x=c(2:94), y=95, data=trData, validation=tsData,,classification=TRUE,
                                            checkpoint = dlmodel_continued, l1=best_params$l1, epochs=0.5)

dlmodel_continued_again@model$valid_class_error



#save model
#h2o.saveModel(object = dlmodel_continued_again)
h2o.saveModel(object = dlmodel_continued_again, dir = "models", save_cv = TRUE, force = TRUE)

dat_test<- read.csv("data/test.csv", header=TRUE)

write.table(dat_test,file="data/pred_test.csv",quote=F,col.names=T,row.names=F,sep=",")

predictData<-h2o.importFile(localH2O,path = "data/pred_test.csv")

#Kaggle predictions
#raw_sub<- as.matrix(h2o.predict(dlmodel_continued_again, predictData))

#write.table(raw_sub,file="data/predictions.csv",quote=F,col.names=T,row.names=T,sep=",")


##Submission ########

## Predictions: label + 9 per-class probabilities
pred <- h2o.predict(dlmodel_continued_again, predictData)
head(pred)

## Remove label
pred <- pred[,-1]
head(pred)

## Paste the ids (first col of test set) together with the predictions
submission <- cbind(predictData[,1], pred)
head(submission)

## Save submission to disk
h2o.exportFile(submission,"submission.csv",force = TRUE)

