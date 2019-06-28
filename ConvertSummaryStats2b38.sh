SUMSTATS=$1 #prefix for summary statistics file on b37, assumes sumstats file ends with .sumstats suffix
COL=$2 #column number with rsIDs in summary statistics file

#DESCRIPTION
#Convert summary statistics (with rsID) on b37 to b38 by matching rsID from dbSNP

#download human genome b38 VCF from dbSNP
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/All_20180418.vcf.gz

#get the first five columns: chr, pos, rsID, ref, alt
gzip -dc All_20180418.vcf.gz | grep -v "^#" | cut -f 1-5 > dbSNP-5cols.txt

LC_ALL=C; export LC_ALL

#sort summary stats (b37) and the dbSNP (b38) by rsID
sort -k2 ${SUMSTATS}.sumstats > ${SUMSTATS}.sumstats-sortbyrs
sort -k3 dbSNP-5cols.txt > dbSNP-5cols.txt-sortbyrs

#join the sorted fies by rs
join -1 2 -2 ${COL} ${SUMSTATS}.sumstats-sortbyrs dbSNP-5cols.txt-sortbyrs | sort | uniq > ${SUMSTATS}_dbSNPmerge.sumstats

#create text file, header, with the appropriate header
cat header ${SUMSTATS}_dbSNPmerge.sumstats > ${SUMSTATS}_dbSNPmerge.sumstats-header
mv ${SUMSTATS}s_dbSNPmerge.sumstats-header ${SUMSTATS}_dbSNPmerge.sumstats

#remove intermediate files
rm dbSNP-5cols.txt-sortbyrs
rm ${SUMSTATS}.sumstats-sortbyrs
