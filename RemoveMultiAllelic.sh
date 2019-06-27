##DESCRIPTION
#Processing to remove multi-allelic variants and duplicate variants before running Eagle (i.e. to phase). 
#The following adapts a pipeline for 1000G (by Giulio Genovese) that normalizes variants using the version of the GRCh38 fasta reference
#I've added a line to remove monomorphic variants
#Reference: https://data.broadinstitute.org/alkesgroup/Eagle/#x1-320005.3.2

#get GRCh38 fasta reference
#wget -O- ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz | \
#  gzip -d > GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
#samtools faidx GCA_000001405.15_GRCh38_no_alt_analysis_set.fna

dir= <path to directory with the VCFs>
input= <path to GCA_000001405.15_GRCh38_no_alt_analysis_set.fna>
output= <path to directory where you want the processed bcfs to be outputted>

for chr in {1..22} X; do
  (bcftools view --no-version -h $dir/inpsyght.chr${chr}.gtonly.minDP0.filtered.PASS.rehdr.vcf.gz | \
    grep -v "^##contig=<ID=[GNh]" | sed 's/^##contig=<ID=MT/##contig=<ID=chrM/;s/^##contig=<ID=\([0-9XY]\)/##contig=<ID=chr\1/'; \
  bcftools view --no-version -H -c 2 $dir/inpsyght.chr${chr}.gtonly.minDP0.filtered.PASS.rehdr.vcf.gz) | \
  bcftools norm --no-version -Ou -m -any | \
  bcftools norm --no-version -Ob -o $output/chr${chr}_GRCh38.genotypes.inpsyght.bcf -d none -f $input/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna && \
  bcftools index -f $output/chr${chr}_GRCh38.genotypes.inpsyght.bcf
done
