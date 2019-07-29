#Run supervised Admixture (using 1000G 5 super-populations and 10 fold cross validation)
#assumes the file called 1000G_MyData-4Admixture.pop exists; it is in the same order as the .fam and contains the super-population for each sample or - for the non-1000G samples

../admixture_linux-1.3.0/admixture -B --seed=1234 --cv=10 --supervised 1000G_MyData-4Admixture.bed 5
