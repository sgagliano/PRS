#InPSYght plink files already have duplicates removed, but we also want to remove one person in 1st and 2nd degree relative pairs
grep -v "DUP/MZ" /net/inpsyght/disk2/sarahgag/InPSYght-6i/relatedness-InPSYght-Hyun.txt | cut -f 3 | sort | uniq | grep -v "FID2" > /net/inpsyght/disk2/sarahgag/InPSYght-6i/1st2nd-remove.txt #n=159
#add FID of 0 to file
R
x<-read.table("/net/inpsyght/disk2/sarahgag/InPSYght-6i/1st2nd-remove.txt", as.is=T)
x$zero=0
write.table(x[,c(2,1)], "../input/1st2nd-remove.txt", row.names=F, col.names=F, quote=F, sep="\t")
#get list of inds with phenos (e.g. duplicates, disqualified controls, sex-mismatches removed)
cut -f 1,2 ../../lassosum/input/inpsyght.pheno.txt | tail -n+2 > ../input/withpheno

#Remove these relateds and only keep those with phenos
#also cannot have missingness; so add --geno 0
plink-1.9 --bfile /net/inpsyght/disk2/sarahgag/PRS/plink/output/geno-Autosomes-maf0.01 --remove ../input/1st2nd-remove.txt --keep ../input/withpheno --geno 0 --make-bed --out ../input/geno-Autosomes-maf0.01-unrelated
#728789 variants and 7545 people pass filters and QC.
#Update pheno column in .fam to include phenotypes
R
fam<-read.table("../input/geno-Autosomes-maf0.01-unrelated.fam", as.is=T)
pheno<-read.table("../../lassosum/input/inpsyght.pheno.txt", h=T, as.is=T)
merge<-merge(fam, pheno, by.x="V2", by.y="IID")
write.table(merge[,c(2,1,3,4,5,8)], "../input/geno-Autosomes-maf0.01-unrelated.fam", row.names=F, col.names=F, quote=F)
