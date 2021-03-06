suppressPackageStartupMessages(require(ggplot2))

y<-read.table("../output/1000G_InPSYght.profile", as.is=T, h=T)
admix<-read.table("/net/inpsyght/disk2/sarahgag/PRS/admixture/scripts/InPSYght-4Admixture.5.Q-withIDs", as.is=T, h=T)
merge<-merge(y, admix, by.x="IID", by.y="IID")
x<-read.table("../../prs-norelateds/input/InPSYghtcasectrl-norelateds.txt", as.is=T, h=T)

data<-merge(merge, x, by.x="IID", by.y="IID")
subset=data
AFR_col=11
pheno_col=13
GRS_col=6
AFR_col=AFR_col
prev_col=pheno_col
GRS_col=GRS_col
df=subset
qtile=10

df_cases<-subset(df, df$Pheno.x==1)
df_controls<-subset(df, df$Pheno.x==0)

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
	prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
	prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalence
i=2
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=3
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=4
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=5
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=6
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=7
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=8
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=9
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=10
        prev_list<-subset(df_controls, df_controls[GRS_col] > tiles[i] & df_controls[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

    ##create object
    pq<-list(prev=prevalences,se=ses,i=index,n=ns,tiles=tiles)
    class(pq)<-"prev_quantile_obj"

#1-based indices for your grs and pheno column

pqdf1<-data.frame(prev=pq$prev,se=pq$se,i=pq$i,n=pq$n,tiles=pq$tiles)
pqdf1$Group="control"

i=1
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalence
i=2
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=3
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

i=4
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=5
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=6
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=7
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=8
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=9
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen
i=10
        prev_list<-subset(df_cases, df_cases[GRS_col] > tiles[i] & df_cases[GRS_col] <= tiles[i+1])
        prevalences[i]<-sum(prev_list[AFR_col])/nrow(prev_list) #how many affected in given quantile
        ns[i]<-nrow(prev_list)
        ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/nrow(prev_list)) #what is SE for this prevalen

    ##create object
    pq<-list(prev=prevalences,se=ses,i=index,n=ns,tiles=tiles)
    class(pq)<-"prev_quantile_obj"

#1-based indices for your grs and pheno column

pqdf2<-data.frame(prev=pq$prev,se=pq$se,i=pq$i,n=pq$n,tiles=pq$tiles)
pqdf2$Group<-"case"

pqdfboth<-rbind(pqdf1, pqdf2)

pqdf<-pqdfboth


#pqdf$frac=pqdf$i/100
pqdf$frac=seq(1,i+1,1)
#pqdf<-pqdf[pqdf$frac!=1.00,]
pqdf<-pqdf[pqdf$frac!=i+1,]
pqdf$ub<-pqdf$prev+(1.96*pqdf$se)
pqdf$lb<-pqdf$prev-(1.96*pqdf$se)
#ymax<-max(pqdf$prev) 
ymax<-max(pqdf$ub)
ymin<-min(pqdf$lb)


main<-"AFR % in PRS deciles"
xlab<-"PRS decile"
ylab<-"AFR Proportion"


pdf(file="AFR_plot-casecontrol.pdf",height=5,width=5,useDingbats=FALSE)
ggplot(pqdf,aes(x=frac,y=prev, group=Group, color=Group)) + geom_point() +
           #scale_color_manual(values=c("grey")) +
           geom_errorbar(aes(ymin=pqdf$lb,ymax=pqdf$ub))  +
              theme_bw() + labs(title=main) + xlab(xlab) + ylab(ylab)  + 
                     coord_cartesian(ylim=c(ymin,ymax)) +
                     scale_x_discrete(limits=c(pqdf$frac)) +
                     theme(legend.text=element_text(color = "black"), legend.title = element_text(color = "black"), legend.key = element_rect(fill = "white"))
 dev.off()
