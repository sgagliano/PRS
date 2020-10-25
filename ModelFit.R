#where X.profile is the output from --score flag in PLINK
dat<-read.table("X.profile", as.is=T,h=T)

model<-glm(dat$Pheno ~ dat$SCORE)

summary(model)

library('fmsb')
NagelkerkeR2(model)
