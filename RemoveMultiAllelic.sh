
wget -O- ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz | \
  gzip -d > GCA_000001405.15_GRCh38_no_alt_analysis_set.fna
samtools faidx GCA_000001405.15_GRCh38_no_alt_analysis_set.fna

dir=/net/inpsyght/disk2/InPSYght/WGS/InPSYght-6i/DP0/PASS
for chr in {1..22} X; do
  (bcftools view --no-version -h $dir/inpsyght.chr${chr}.gtonly.minDP0.filtered.PASS.rehdr.vcf.gz | \
    grep -v "^##contig=<ID=[GNh]" | sed 's/^##contig=<ID=MT/##contig=<ID=chrM/;s/^##contig=<ID=\([0-9XY]\)/##contig=<ID=chr\1/'; \
  bcftools view --no-version -H -c 2 $dir/inpsyght.chr${chr}.gtonly.minDP0.filtered.PASS.rehdr.vcf.gz) | \
  bcftools norm --no-version -Ou -m -any | \
  bcftools norm --no-version -Ob -o ../output/chr${chr}_GRCh38.genotypes.inpsyght.bcf -d none -f ../input/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna && \
  bcftools index -f ../output/chr${chr}_GRCh38.genotypes.inpsyght.bcf
done
