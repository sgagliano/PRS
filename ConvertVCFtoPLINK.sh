#DESCRIPTION
#Convert a VCF file to PLINK binary format

#Adapted from http://apol1.blogspot.com/2014/11/best-practice-for-converting-vcf-files.html
#Takes the VCF file, extracts specified samples, strips the variant IDs, splits multi-allelic sites into bi-allelic sites, assigns names to make sure indels will not become ambiguous, and finally converts to plink format
#download a copy of the GrCh38 reference fasta file

CHR=$1 #chr number, e.g. 1
FASTA=$2 #human genome .fa file for GrCh38
SAMPLES=$3 #list of samples to keep from chr${CHR}.InputData-PASS-bgzip.vcf.gz, one sample ID per row

mkdir output

bcftools view --samples-file ${SAMPLES} --force-samples chr${CHR}.InputData-PASS-bgzip.vcf.gz | 
  bcftools norm -Ou -m -any |
  bcftools norm -Ou -f ${FASTA} |
  bcftools annotate -Ob -x ID \
    -I +'%CHROM:%POS:%REF:%ALT' |
  plink-1.9 --bcf /dev/stdin \
    --keep-allele-order \
    --vcf-idspace-to _ \
    --const-fid \
    --allow-extra-chr 0 \
    --split-x b38 no-fail \
    --make-bed \
    --out output/chr${CHR}
