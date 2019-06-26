#DESCRIPTION
#This script prepares a bash script with the list of eagle phasing jobs

DIR <- "<directory where the bcfs to be phased are located>"
INPUT <- "<directory where the genetic map is located>"
LOGS <- "<../logs>"
EAGLE <- "<path to eagle executable>"

options(scipen=999)
tt=NULL

for(CHR in 1:22)
{

OUTPREFIX="<my_Output_prefix"

tt=c(tt,paste("",EAGLE," --geneticMapFile ",INPUT,"/genetic_map_hg38_withX.txt.gz --bcf ",DIR,"/chr",CHR,"_GRCh38.genotypes.inpsyght.bcf --numThreads 8 --outPrefix ",OUTPREFIX,".phased-chr",CHR," > ",LOGS,"/",OUTPREFIX,".phased-chr",CHR,".LOG

/usr/cluster/bin/bcftools index -f ",OUTPREFIX,".phased-chr",CHR,".vcf.gz ",sep=""))

}

write(tt, "Phase_tt.sh")
