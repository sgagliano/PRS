#Description
#run lassosum, stand-alone version (https://github.com/tshmak/lassosum/blob/master/lassosum_standalone.md#lassosum-standalone-version-for-linux) on prepared summary stats (base) and plink-formatted raw data (target) to get PRS
#this script isn't pre-generalizable; go through and adjust values based on your base and target data and phenotype file(s)

##INSTALL the lassosum R package and dependencies
#refer to https://github.com/tshmak/lassosum
#install.packages(c("RcppArmadillo", "data.table", "Matrix"), dependencies=TRUE)
#library(devtools)
#install_github("tshmak/lassosum")

sumstats=$1 prepared sumstats file
output=$2 #output prefix

PATH=<path to lassosum R file>/lassosum/:$PATH
#for instance, for me it is:
#PATH=/net/snowwhite/home/sarahgag/R/x86_64-pc-linux-gnu-library/3.3/lassosum/:$PATH

lassosum --data ${sumstats} \
        --chr dbSNP_CHR_b38 --pos dbSNP_BP_b38 \ #replace with appropriate column names from sumstats
        --A1 A1 --A2 A2 --pval P --n 107620 --OR OR \ #replace with appropriate column names from sumstats
        --test.bfile targetdataplinkprefix \
        --LDblocks EUR.hg38 --pheno pheno.txt --covar covar.txt \ #first file has FID, IID and pheno; second has FID, IID and covariates
        --ref refplinkprefix \
        --splitvalidate --nthreads 2 --out ${output}
