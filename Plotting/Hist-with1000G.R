library(devtools)
suppressPackageStartupMessages(require(RColorBrewer))
suppressPackageStartupMessages(require(ggplot2))

prs<-read.table("1000G_study.splitvalidate.results.txt", as.is=T, h=T) #lassosum results run on 1000G+study pop'ns 
pop<-read.table("1000g_inpsyght.txt", as.is=T, h=T) #Two column text file with headers IID and Group, listing sample id and corresponding category
dat<-merge(prs, pop, by.x="IID", by.y="IID")

#adapted from https://stackoverflow.com/questions/6957549/overlaying-histograms-with-ggplot2-in-r
plot_multi_histogram <- function(df, feature, label_column, xlab) {
    plt <- ggplot(df, aes(x=eval(parse(text=feature)), fill=eval(parse(text=label_column)))) +
    geom_histogram(alpha=0.7, position="identity", aes(y = ..density..), color="black") +
    geom_density(alpha=0.7) +
    #geom_vline(aes(xintercept=mean(eval(parse(text=feature)))), color="black", linetype="dashed", size=1) +
    labs(x=xlab, y = "Density")
    plt + guides(fill=guide_legend(title=label_column))
}
tiff("Hist.tiff", width=6.5, height=4.5, unit="in", res=300)
options(repr.plot.width = 20, repr.plot.height = 8)
plot_multi_histogram(dat, 'best.pgs', 'Group', 'PRS')
dev.off()
