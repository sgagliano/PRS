chr=$1 #col num for dbSNP chr
bp=$2  #col num for dbSNP pos
ref=$3 #col num for dbSNP ref allele
alt=$4 #col num for dbSNP alt allele
prefix=$5 #tab-delimited output file (prefix only) from Check_rsID_dbSNP_Merge.sh; e.g. ../output/MySumstatsPrefix

LC_ALL=C; export LC_ALL

#extract dbSNP columns; assumes file is tab-delimited
cut -f ${chr},${bp},${ref},${alt}  ${prefix}_dbSNPmerge-clean  > ${prefix}_dbSNPmerge-clean_ids 
#add chr prefix to agree with raw data b38 notation
sed -i -e 's/^/chr/' ${prefix}_dbSNPmerge-clean_ids 
#remove header and add ids as header
touch newcolhead
echo ids > newcolhead
tail -n+2 ${prefix}_dbSNPmerge-clean_ids  > ${prefix}_dbSNPmerge-clean_ids -nohead
paste newcolhead ${prefix}_dbSNPmerge-clean_ids-nohead > ${prefix}_dbSNPmerge-clean_ids 
#change delimiter to space
perl -p -i -e 's/\t/ /g' ${prefix}_dbSNPmerge-clean_ids 

#remove intermediate files
rm newcolhead
rm ${prefix}_dbSNPmerge-clean_ids-nohead
