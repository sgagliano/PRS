x<-read.table("myfile.txt", as.is=T, h=T)

#where x$AFR is the column with estimated %AFR genetic ancestry (e.g. from ADMIXTURE software)
#and x$SCORE is the PRS column
less0.5<-subset(x, x$AFR<=0.5) #122
part2<-subset(x, x$AFR>0.5 & x$AFR<=0.6) #105
part3<-subset(x, x$AFR>0.6 & x$AFR<=0.7) #317
part4<-subset(x, x$AFR>0.7 & x$AFR<=0.8) #955
part5<-subset(x, x$AFR>0.8 & x$AFR<=0.9) #2390
part6<-subset(x, x$AFR>0.9 & x$AFR<=0.99) #1801
great0.99<-subset(x, x$AFR>0.99) #272

pdf("vioplot.pdf")
library('vioplot')
vioplot(less0.5$SCORE, part2$SCORE, part3$SCORE, part4$SCORE, part5$SCORE, part6$SCORE, great0.99$SCORE, main="", xlab="AFR Proportion", ylab="PRS", ylim=c(-0.0055, 0.006), names=c("<=0.5", "(0.5, 0.6]", "(0.6, 0.7]", "(0.7, 0.8]","(0.8, 0.9]","(0.9, 0.99]",">0.99"), cex.names=0.8, col="lightgrey")
dev.off()
