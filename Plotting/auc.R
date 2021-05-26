#area under the receiver operator characteristic curve

y<-read.table("X.profile", as.is=T,h=T) #plink --score output
x<-read.table("phenotypes.txt", as.is=T, h=T)
prs_pheno<-merge(x, y, by.x="IID", by.y="IID")
yourData=prs_pheno
out<-"CV"

#add YOUR column names as  strings
pheno<-"Pheno" #phenotype header name of interest
score<-"SCORE" #column name for PRS_score
#Note: if your column name is the same as one of the variable names above you will get an error

library(pROC)
library(RColorBrewer)
library("colorspace")
trait_glm <-glm(Pheno ~ SCORE, data = prs_pheno, family = "binomial")
roc(prs_pheno$Pheno, trait_glm$fitted.values, plot=TRUE)

#number of folds
k<-10

#Randomly shuffle the data after setting seed
set.seed(1234)
yourData<-yourData[sample(nrow(yourData)),]

#Create 10 equally size folds
folds <- cut(seq(1,nrow(yourData)),breaks=k,labels=FALSE)

#make list
roc_list<-rep(NA,k)

                                   
#Perform 10 fold cross validation
for(i in 1:k){
    #Segement your data by fold using the which() function 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- yourData[testIndexes, ]
    trainData <- yourData[-testIndexes, ]
        #fit model on training data
        glm.obj <-glm(Pheno ~ SCORE, data = trainData, family = "binomial")
        #use on testing
        testpredict<-predict(glm.obj, newdata=testData)
#       pdf(file=paste0(out,"ROC",i,".pdf"),height=6,width=6)
        roc.obj<-roc(testData$Pheno, testpredict, plot=TRUE)
#       dev.off()
        roc_list[i]<-roc.obj$auc                                          
}
#make a plot of all CVs together
#pick k colors for plots
#you can pick different palette here: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf
#colors<-brewer.pal(k, "Set2")
colors<-rainbow_hcl(k)
pdf(file=paste0(out,"_ROC_all_folds.pdf"),height=6,width=6)
for(i in 1:k){
    #Segment your data by fold using the which() function
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- yourData[testIndexes, ]
    trainData <- yourData[-testIndexes, ]
        #fit model on training data
        glm.obj<-glm(get(pheno) ~ get(score), data = trainData, family = "binomial")
        #use on testing data
        testPreds<-predict(glm.obj,testData)
        if (i==1){
                roc(testData[[pheno]], testPreds, plot=TRUE,ci=TRUE,col=colors[i],print.auc=TRUE,print.auc.col=colors[i],print.auc.y=0.5-(i*0.05))
        } else {
                roc(testData[[pheno]], testPreds, plot=TRUE,ci=TRUE,add=TRUE,col=colors[i],print.auc=TRUE,print.auc.col=colors[i],print.auc.y=0.5-(i*0.05))
        }
}
dev.off()

mean(roc_list) #print out mean area under the curve for the 10 subsets

roc_list #print out the mean area under the curve for each of the 10 subsets
