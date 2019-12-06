library(devtools)
suppressPackageStartupMessages(require(RColorBrewer))
suppressPackageStartupMessages(require(ggplot2))

prs<-read.table("1000G_study.splitvalidate.results.txt", as.is=T, h=T) #lassosum results run on 1000G+study pop'ns 
pop<-read.table("1000g_inpsyght.txt", as.is=T, h=T) #Two column text file with headers IID and Group, listing sample id and corresponding category
dat<-merge(prs, pop, by.x="IID", by.y="IID")

data_summary <- function(x) {
   m <- mean(x)
   ymin <- m-sd(x)
   ymax <- m+sd(x)
   return(c(y=m,ymin=ymin,ymax=ymax))
}

tiff("violinplot.tiff", width=6.5, height=4.5, unit="in", res=300)
ggplot(dat, aes(x=Group, y=best.pgs, color=Group)) + 
  geom_violin() +
stat_summary(fun.data=data_summary) +
theme(legend.position="right")

dev.off()
