prs<-read.table("../output/1KG_InPSYght-AFREURsimilarMAF.splitvalidate.results.txt", as.is=T, h=T)
pop<-read.table("1000g_inpsyght.txt", as.is=T, h=T)
dat<-merge(prs, pop, by.x="IID", by.y="IID")

library(devtools)
suppressPackageStartupMessages(require(RColorBrewer))
suppressPackageStartupMessages(require(ggplot2))

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
