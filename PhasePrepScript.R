#DESCRIPTION
#This script prepares a bash script with the list of eagle phasing jobs

DIR <- "<path to directory where the bcfs, split by chromosome, to be phased are located>"
MAP <- "<version of genetic map to use from eagle; e.g. genetic_map_hg38_withX.txt.gz>"
LOGS <- "<path to directory to write out logs>"
EAGLE <- "<eagle executable>"

options(scipen=999)
tt=NULL

for(CHR in 1:22)
{

OUTPREFIX="<my_Output_prefix"

tt=c(tt,paste("",EAGLE," --geneticMapFile ",MAP," --bcf ",DIR,"/chr",CHR,"_GRCh38.genotypes.inpsyght.bcf --numThreads 8 --outPrefix ",OUTPREFIX,".phased-chr",CHR," > ",LOGS,"/",OUTPREFIX,".phased-chr",CHR,".LOG

/usr/cluster/bin/bcftools index -f ",OUTPREFIX,".phased-chr",CHR,".vcf.gz ",sep=""))

}

write(tt, "Phase_tt.sh")
