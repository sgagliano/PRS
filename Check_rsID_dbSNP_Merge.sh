#DESCRIPTION
#1. Identify rsIDs that have differing chromsomes in the summary statistics (b37) and dbSNP (b38) in the output of ConvertSummaryStats2b38.sh (e.g. myfile_dbSNPmerge.sumstats); 
#assumes rsID is in the first column; prints out these rsIDs to mismatch_rsID.txt
#2. Remove these rsIDs from the output of ConvertSummaryStats2b38.sh (e.g. myfile_dbSNPmerge.sumstats)
#prints out the new file to myfile_dbSNPmerge.sumstats-clean

#Arguments
######
INPUT=$1 # myfile_dbSNPmerge.sumstats, output from Merge_rsID_dbSNP.sh
COLa=$2 #e.g. 2; column number for summary stats chr from merged file
COLb=$3 #e.g. 14; column number for dbSNP chr from merged file
######

cut -d " " -f ${COLa} ${INPUT} >  chrA
cut -d " " -f ${COLb} ${INPUT} >  chrB

diff chrA chrB | grep -v ">" | grep -v "<" | grep -v "-" | cut -d "c" -f 1 > mismatched_lines.txt

while read i; do
  echo "Appending rsID for mismatched line $i to mismatch_rsID.txt"
  head -n ${i} ${INPUT} | tail -n1 | cut -d " " -f 1 >> mismatch_rsID.txt
done <mismatched_lines.txt

LC_ALL=C; export LC_ALL
sort mismatch_rsID.txt > mismatch_rsID.txt-sort
sort ${INPUT} > ${INPUT}-sort
join mismatch_rsID.txt-sort ${INPUT}-sort | sort | uniq | join -v 2 mismatch_rsID.txt-sort ${INPUT}-sort > ${INPUT}-clean
cat ../output/header ${INPUT}-clean > ${INPUT}-clean-head 
mv ${INPUT}-clean-head ${INPUT}-clean

#remove intermediate files
rm chrA 
rm chrB
rm mismatched_lines.txt
rm mismatch_rsID.txt-sort
rm ${INPUT}-sort
