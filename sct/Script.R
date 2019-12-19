#outline of script from https://privefl.github.io/bigsnpr/articles/SCT.html
#Paper: https://www-sciencedirect-com.proxy.lib.umich.edu/science/article/pii/S0002929719304227?via%3Dihub

#load packages bigsnpr and bigstatsr
#remotes::install_github("privefl/bigsnpr")
library(bigsnpr)

#Read from bed/bim/fam, it generaes .bk and .rds files
#See PrepInPSYght.sh to create these plink files
snp_readBed("../input/geno-Autosomes-maf0.01-unrelated.bed")

#ERROR MESSAGE if run on snowwhite; solve by running on inpsyght machine:
#Error in getXPtrFBM(.self$bk, .self$nrow, .self$ncol, .self$type) :
#  Error when mapping file:
#  Cannot allocate memory.

#Attach the "bigSNP" object in R session
obj.bigSNP <- snp_attach("../input/geno-Autosomes-maf0.01-unrelated.rds")
# See how the file looks like
str(obj.bigSNP, max.level = 2, strict.width = "cut")

# Get aliases for useful slots
G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
y   <- obj.bigSNP$fam$affection #I coded it as 0 and 1 already
NCORES <- nb_cores()
# Check some counts for the 10 first variants
big_counts(G, ind.col = 1:10)

# Read external summary statistics
sumstats <- bigreadr::fread2("/net/inpsyght/disk2/sarahgag/PRS/summarystats/output/BDSCZvsCONT_dbSNPmerge.sumstats-clean_ids")
str(sumstats)

#We split genotype data using part of the data to learn parameters of stacking and another part of the data to evaluate statistical properties of polygenic risk score such as AUC. 
#Here we consider that there are 4500 individuals in the training set.
set.seed(1)
ind.train <- sample(nrow(G), 4500)
ind.test <- setdiff(rows_along(G), ind.train)

#matching variants between genotype data and summary statistics
names(sumstats) <- c("ids", "SNP", "oldchr", "oldbp", "oldA1", "oldA2", "FreqA", "FreqU", "INFO", "beta", "SE", "p", "Direction", "HetPVa", "chr", "pos", "a0", "a1")
#where chr=dbSNP_CHR_b38; pos=dbSNP_POS_b38; a0=A1(ref); a1=A2(derived); beta=OR
map <- obj.bigSNP$map[,-(2:3)]
names(map) <- c("chr", "pos", "a0", "a1")
info_snp <- snp_match(sumstats, map)
#8,666,886 variants to be matched.
#942,558 ambiguous SNPs have been removed.
#99,300 variants have been matched; 0 were flipped and 81,407 were reversed.
#since none were flipped, use strand_flip = FALSE
info_snp <- snp_match(sumstats, map, strand_flip = FALSE)
#114,531 variants have been matched; 0 were flipped and 93,972 were reversed.
beta <- info_snp$beta
lpval <- -log10(info_snp$p)

#Limit the size of G to only SNPs in sumstats
write.table(info_snp$ids, "../input/info_snp.ids", row.names=F, col.names=F, quote=F)

#G2 <- big_copy(X=G,ind.row=1:nrow(G),ind.col = match(info_snp$ids, obj.bigSNP$map$marker.ID),backingfile="./subset")
#check it worked
#dim(G)
#[1]   7545 728789
#length(beta)
#[1] 114531
#dim(G2)
#[1]   7545 114531
#good, but need to also change CHR and POS, but can't figure out how, so just go and create new plink files with the overlapping SNPs

#in terminal
#plink-1.9 --bfile ../input/geno-Autosomes-maf0.01-unrelated --extract ../input/info_snp.ids --make-bed --out ../input/geno-Autosomes-maf0.01-unrelated-subset

fam<-read.table("../input/geno-Autosomes-maf0.01-unrelated-subset.fam", as.is=T)
pheno<-read.table("../../lassosum/input/inpsyght.pheno.txt", h=T, as.is=T)
merge<-merge(fam, pheno, by.x="V2", by.y="IID")
write.table(merge[,c(2,1,3,4,5,8)], "../input/geno-Autosomes-maf0.01-unrelated-subset.fam", row.names=F, col.names=F, quote=F)

snp_readBed("../input/geno-Autosomes-maf0.01-unrelated-subset.bed")

#Attach the "bigSNP" object in R session
obj.bigSNP <- snp_attach("../input/geno-Autosomes-maf0.01-unrelated-subset.rds")
# See how the file looks like
str(obj.bigSNP, max.level = 2, strict.width = "cut")

# Get aliases for useful slots
G   <- obj.bigSNP$genotypes
CHR <- obj.bigSNP$map$chromosome
POS <- obj.bigSNP$map$physical.pos
y   <- obj.bigSNP$fam$affection - 1
NCORES <- nb_cores()
# Check some counts for the 10 first variants
big_counts(G, ind.col = 1:10)

##Computing C+T scores for a grid of parameters and chromosomes
#clumping
#By default, the function uses 28 (7 thresholds of correlation x 4 window sizes) different sets of hyper-parameters for generating sets of variants resulting from clumping.
all_keep <- snp_grid_clumping(G, CHR, POS, ind.row = ind.train,
                              lpS = lpval, ncores = NCORES)
attr(all_keep, "grid")

#thresholding
multi_PRS <- snp_grid_PRS(G, all_keep, beta, lpval, ind.row = ind.train,
                          backingfile = "../output/data-scores", 
                          n_thr_lpS = 50, ncores = NCORES)
dim(multi_PRS)  ## 30800 C+T scores for 4500 individuals
#4500 30800

##Stacking C+T predictions 
final_mod <- snp_grid_stacking(multi_PRS, y[ind.train], ncores = NCORES, K = 4)
summary(final_mod$mod)
## A tibble: 3 x 6
#   alpha validation_loss intercept beta           nb_var message  
#   <dbl>           <dbl>     <dbl> <list>          <int> <list>   
#1 0.0001           0.652     0.587 <dbl [25,984]>      0 <chr [4]>
#2 0.01             0.652     0.587 <dbl [25,984]>      0 <chr [4]>
#3 1                0.652     0.587 <dbl [25,984]>      0 <chr [4]>

#From stacking C+T scores, derive a unique vector of weights and compare effects resulting from stacking to the initial regression coefficients provided as summary statistics
new_beta <- final_mod$beta.G
ind <- which(new_beta != 0)

library(ggplot2)
tiff("../output/Effectsizes.tiff", width=6.5, height=4.5, unit="in", res=300)
ggplot(data.frame(y = new_beta, x = beta)[ind, ]) +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  geom_abline(slope = 0, intercept = 0, color = "blue") +
  geom_point(aes(x, y), size = 0.6) +
  theme_bigstatsr() +
  labs(x = "Effect sizes from GWAS", y = "Non-zero effect sizes from SCT")
dev.off()

#use this vector of variant weights to compute polygenic risk scores on the test set and evaluate the Area Under the Curve (AUC)
pred <- final_mod$intercept + 
  big_prodVec(G, new_beta[ind], ind.row = ind.test, ind.col = ind)
AUCBoot(pred, y[ind.test])
#        Mean         2.5%        97.5%           Sd 
#0.5002674416 0.5000000000 0.5013440860 0.0003682165

tiff("../output/Hist.tiff", width=6.5, height=4.5, unit="in", res=300)
ggplot(data.frame(
  Phenotype = factor(y[ind.test], levels = 0:1, labels = c("Control", "Case")),
  Probability = 1 / (1 + exp(-pred)))) + 
  theme_bigstatsr() +
  geom_density(aes(Probability, fill = Phenotype), alpha = 0.3)
dev.off()

# Best C+T predictions
#Instead of stacking, an alternative is to choose the best C+T score based on the computed grid.
#This procedure is appealing when there are not enough individuals to learn the stacking weights.
library(tidyverse)
grid2 <- attr(all_keep, "grid") %>%
  mutate(thr.lp = list(attr(multi_PRS, "grid.lpS.thr")), num = row_number()) %>%
  unnest()
## Warning: `cols` is now required.
## Please use `cols = c(thr.lp)`
s <- nrow(grid2)
grid2$auc <- big_apply(multi_PRS, a.FUN = function(X, ind, s, y.train) {
  # Sum over all chromosomes, for the same C+T parameters
  single_PRS <- rowSums(X[, ind + s * (0:21)])                                 
  bigstatsr::AUC(single_PRS, y.train)
}, ind = 1:s, s = s, y.train = y[ind.train],
a.combine = 'c', block.size = 1, ncores = NCORES)

max_prs <- grid2 %>% arrange(desc(auc)) %>% slice(1:10) %>% print() %>% slice(1)
## A tibble: 10 x 7
#    size thr.r2 grp.num thr.imp thr.lp   num   auc
#   <int>  <dbl>   <int>   <dbl>  <dbl> <int> <dbl>
# 1  4000   0.05       1       1   3.68     7 0.503
# 2  1000   0.05       1       1   3.68     5 0.503
# 3 10000   0.01       1       1   3.68     2 0.502
# 4 10000   0.05       1       1   3.68     8 0.502
# 5 20000   0.01       1       1   3.68     3 0.502
# 6  2000   0.05       1       1   3.68     6 0.502
# 7 50000   0.01       1       1   3.68     4 0.502
# 8 10000   0.01       1       1   3.30     2 0.502
# 9  1000   0.05       1       1   3.30     5 0.501
#10  4000   0.05       1       1   3.30     7 0.501

ind.keep <- unlist(map(all_keep, max_prs$num))
sum(lpval[ind.keep] > max_prs$thr.lp)
## [1] 551

AUCBoot(
  snp_PRS(G, beta[ind.keep], ind.test = ind.test, ind.keep = ind.keep,
          lpS.keep = lpval[ind.keep], thr.list = max_prs$thr.lp),
  y[ind.test]
)
#      Mean       2.5%      97.5%         Sd
#0.48373893 0.46205974 0.50535986 0.01094148

  
