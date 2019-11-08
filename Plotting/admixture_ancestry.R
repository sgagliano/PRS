##Description: visualize global ancestry components
#modified code from Jionming Wang
#input: tab-delimited ADMIXTURE output file, where IID has been added as the first row, and also a header has been added
#output: `ancestry_component.png`

library(ggplot2)
library(RColorBrewer)
br_pal <- brewer.pal(9, "Set1")

###customize these options###
ancestry <- read.table("/net/inpsyght/disk2/sarahgag/PRS/admixture/scripts/InPSYght-4Admixture.5.Q-withIDs-nocovars", sep="\t",h=T) #first row is IID, second row and onwards are the global ancestries
labels=c("European","East Asian","Admixed American","South Asian","African") #specify ancestries in your file,rows 2-k
column_name_to_sort="AFR"

###the rest shouldn't need modifications###
k=length(labels)
ancestry_sorted <- ancestry[order(column_name_to_sort), ] 
ancestry_sorted_v2 <- ancestry_sorted[ ,-1]
anc_final <- t(ancestry_sorted_v2)

ancestry_cumulative <- apply(anc_final, 2, function(x) {
  for (i in 2:k) 
    x[i] = x[i-1]+x[i]
  return(x)
})

new_df <- data.frame(x=rep(1:nrow(ancestry), each=k),
                     ystart=c(rbind(rep(0, nrow(ancestry)), ancestry_cumulative[1:k-1, ])),
                     yend=c(ancestry_cumulative),
                     pop=factor(rep(1:k, nrow(ancestry))))

gp <- ggplot(new_df, aes(x=x, y=ystart, color=pop)) +
  geom_segment(aes(xend=x, yend=yend), alpha=0.5) +
  scale_colour_manual(name="Ancestry",
                      labels=labels,
                      values=br_pal[c(2, 5, 3, 1, 4)])+
  
  theme_bw()+
  guides(colour=guide_legend(override.aes=list(size=10, alpha=1), reverse=TRUE))+
  labs(x = "Sample", y = "Ancestry Composition") +
  theme(text=element_text(size=25), panel.grid=element_blank(), axis.text.x=element_text(size=20), axis.text.y=element_text(size=20))
ggsave("ancestry_component.png", width = 40, height = 20, units = "cm")
