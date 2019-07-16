#Description
#run PRSice (https://github.com/choishingwan/PRSice) on prepared summary stats (base) and plink-formatted raw data (target) to get PRS
#this script isn't pre-generalizable; go through and adjust values based on your base and target data and phenotype file(s)

sumstats=$1 prepared sumstats file
output=$2 #output prefix

#unhash to download PRSice:
#mkdir PRSice_linux
#cd PRSice_linux
#wget https://github.com/choishingwan/PRSice/releases/download/2.2.2/PRSice_linux.zip 
#unzip PRSice_linux.zip

Rscript PRSice_linux/PRSice.R \
--seed 1234 \
--quantile 10 --quant-ref 1 \
-b ${sumstats} \
--stat OR --pval P --A1 A1 --A2 A2 --snp ids --chr dbSNP_CHR_b38 --bp dbSNP_BP_b38 \ #replace with appropriate column names from sumstats
--prsice PRSice_linux/PRSice_linux \
--target geno-chr# --type bed \
--pheno-file MyPhenoFile.txt \ #file has sample IDs and the phenotype of interest
--cov-file MyCovariateFile.txt \ #file has sample IDs and the covariates (if both pheno and covariates are in same file, refer to that file here and line above)
--pheno-col Pheno \ #replace with column header for phenotype column in MyPhenoFile.txt
--cov-col Wave,Sex \ #replace with column headers for covariate column(s) in MyCovariateFile.txt
--print-snp \ 
--binary-target T --ignore-fid \
--perm 10000 \
--out ${output}
