#!/bin/bash
#SBATCH --job-name=r_chr
#SBATCH --array=1-22
#SBATCH --output=../logs/r_chr%a.slurm.log
#SBATCH --error=../logs/r_chr%a.slurm.err
#SBATCH --ntasks=22

#add chr prefix to 1000G b38 files so that it agrees with the fasta file
zcat ALL.chr"$SLURM_ARRAY_TASK_ID".phase3_shapeit2_mvncall_integrated_v3plus_nounphased.rsID.genotypes.GRCh38_dbSNP_no_SVs.vcf.gz | sed 's/^/chr/' | sed 's/chr#/#/' | bgzip -c  > ../output/chr"$SLURM_ARRAY_TASK_ID"-b38-withchrprefix.vcf.gz
