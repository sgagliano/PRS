#Modified from from http://apol1.blogspot.com/2014/11/best-practice-for-converting-vcf-files.html
#download a copy of the GrCh38 reference
#use: /net/mario/nodeDataMaster/local/ref/gotcloud.ref/hg38/hs38DH.fa

CHR=$1

#The following command will take the VCF file, strip the variant IDs, split multi-allelic sites into bi-allelic sites, assign names to make sure indels will not b$
#AND EXTRACT HGDP-SNPs listed HGDP.markers (from /net/topmed8/working/call_sets/freeze6i/hgdp/hgdp.auto.merged.2018_10_28.gtonly.minDP0.bim )

##hg38.fa === b38 fasta file wih chr prefix
##HGDP.markers === pruned set of markers (chr:pos:ref:alt one per line) to extract

bcftools norm -Ou -m -any ../output/chr${CHR}-b38-withchrprefix.vcf.gz | \
  bcftools norm -Ou -f hg38.fa |
  bcftools annotate -Ob -x ID \
    -I +'%CHROM:%POS:%REF:%ALT' |
  plink-1.9 --bcf /dev/stdin \
    --keep-allele-order \
    --vcf-idspace-to _ \
    --const-fid \
    --allow-extra-chr 0 \
    --split-x b38 no-fail \
    --extract HGDP.markers \
    --make-bed \
    --out ../output/chr${CHR}-b38-withchrprefix-HGDPsnps
