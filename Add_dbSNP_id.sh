chr=$1 #col num for dbSNP chr
bp=$2  #col num for dbSNP pos
ref=$3 #col num for dbSNP ref allele
alt=$4 #col num for dbSNP alt allele
prefix=$5 #space-delimited output file (prefix only) from Check_rsID_dbSNP_Merge.sh; e.g. script will add _dbSNPmerge.sumstats-clean suffix

LC_ALL=C; export LC_ALL

#extract dbSNP columns; assumes file is tab-delimited
cut -d " " -f ${chr},${bp},${ref},${alt}  ../output/${prefix}_dbSNPmerge.sumstats-clean  > ../output/${prefix}_dbSNPmerge.sumstats-clean_ids 
#add chr prefix to agree with raw data b38 notation
sed -i -e 's/^/chr/' ../output/${prefix}_dbSNPmerge.sumstats-clean_ids 
#remove header and add ids as header
touch ../output/newcolhead
echo ids > ../output/newcolhead
tail -n+2 ../output/${prefix}_dbSNPmerge.sumstats-clean_ids  > ../output/${prefix}_dbSNPmerge.sumstats-clean_ids-nohead
paste ../output/newcolhead ../output/${prefix}_dbSNPmerge.sumstats-clean_ids-nohead > ../output/${prefix}_dbSNPmerge.sumstats-clean_ids 
#change delimiter to space
perl -p -i -e 's/\t/ /g' ../output/${prefix}_dbSNPmerge.sumstats-clean_ids 

#remove intermediate files
rm ../output/newcolhead
rm ../output/${prefix}_dbSNPmerge.sumstats-clean_ids-nohead
