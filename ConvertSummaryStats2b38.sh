#DESCRIPTION
#Convert summary statistics (with rsID) on b37 to b38

#download human genome b38 VCF from dbSNP
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/All_20180418.vcf.gz

#get the first five columns: chr, pos, rsID, ref, alt
gzip -dc All_20180418.vcf.gz | grep -v "^#" | cut -f 1-5 > dbSNP-5cols.txt

LC_ALL=C; export LC_ALL

#sort summary stats (b37) and the dbSNP (b38) by rsID
sort -k2 sumstats.sumstats > sumstats.sumstats-sortbyrs
sort -k3 input/dbSNP-5cols.txt > dbSNP-5cols.txt-sortbyrs

#join the sorted fies by rs
join -1 2 -2 3 sumstats.sumstats-sortbyrs dbSNP-5cols.txt-sortbyrs | sort | uniq > sumstats_dbSNPmerge.sumstats

#create text file, header, with the appropriate header
cat header sumstats_dbSNPmerge.sumstats > sumstats_dbSNPmerge.sumstats-header
mv sumstats_dbSNPmerge.sumstats-header sumstats_dbSNPmerge.sumstats
