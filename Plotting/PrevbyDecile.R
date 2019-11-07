#modified code from Brooke
#this code is hard-coded for InPSYght data, lassosum output. 

suppressPackageStartupMessages(require(ggplot2))

y<-read.table("../output/noref_inpsyght.splitvalidate.results.txt", as.is=T,h=T) #lassosum output
x<-read.table("../../prs/input/InPSYghtcasectrl-withSexWave.txt", as.is=T, h=T) #phenotype fle
data<-merge(x, y, by.x="IID", by.y="IID")
subset=data
grs_col=8
pheno_col=3
GRS_col=grs_col
prev_col=pheno_col
df=subset
qtile=10


    if (!sum(unique(df[[prev_col]])==c(0,1))==2) {
        print("Column for calculating prevalence of trait must be a binary variable. Expects 0 (controls) and 1 (cases).")
    }
    if (sum(qtile)<2*length(qtile)){ #check qtile
        print("q-quantiles should be number of divisions for data set and must be greater than 1")
    }
    
    ##initialize data structures
    p<-(100/qtile)/100
    index<-c(seq(from=0,to=1,by=p)*100)
    prevalences<-rep(NA,qtile+1) #initialize prevalence vector
    ns<-rep(NA,qtile+1) #initialize count vector
    ses<-rep(NA,qtile+1)#initialize se vector
    tiles<-quantile(df[[GRS_col]],seq(from=0,to=1,by=p)) #quantile values
    for (i in 1:length(index)-1) {
	print(i)
}
i=1
	prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
	prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalence
i=2
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=3
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=4
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=5
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=6
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=7
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=8
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=9
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=10
        prev_list<-subset(df, df[GRS_col] > tiles[i] & df[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[prev_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

    ##create object
    pq<-list(prev=prevalences,se=ses,i=index,n=ns,tiles=tiles)
    class(pq)<-"prev_quantile_obj"

#1-based indices for your grs and pheno column

pqdf<-data.frame(prev=pq$prev,se=pq$se,i=pq$i,n=pq$n,tiles=pq$tiles)

#pqdf$frac=pqdf$i/100
pqdf$frac=seq(1,i+1,1)
#pqdf<-pqdf[pqdf$frac!=1.00,]
pqdf<-pqdf[pqdf$frac!=i+1,]
pqdf$ub<-pqdf$prev+(1.96*pqdf$se)
pqdf$lb<-pqdf$prev-(1.96*pqdf$se)
#ymax<-max(pqdf$prev) 
ymax<-max(pqdf$ub)


main<-"Prevalence in GRS deciles"
xlab<-"PRS decile"
ylab<-"Phenotype prevalence"

pdf(file="noref_prev_plot.pdf",height=5,width=5,useDingbats=FALSE)
ggplot(pqdf,aes(x=frac,y=prev,color=as.factor(1))) + geom_point() +
           scale_color_manual(values=c("grey")) +
           geom_errorbar(aes(ymin=pqdf$lb,ymax=pqdf$ub),color="grey")  +
              theme_bw() + labs(title=main) + xlab(xlab) + ylab(ylab)  + 
                     coord_cartesian(ylim=c(0,ymax)) +
                     scale_x_discrete(limits=c(pqdf$frac)) +
                     theme(legend.text=element_text(color = "white"), legend.title = element_text(color = "white"), legend.key = element_rect(fill = "white"))
 dev.off()
