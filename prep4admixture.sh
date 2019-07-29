for CHR in `seq 1 22`
do
        sbatch --mem=30G --job-name=merge${CHR} --time=200:00:00 --wrap="plink-1.9 --bfile ../1000g_b38/output/chr${CHR}-b38-withchrprefix-HGDPsnps --bmerge ../../plink/output/geno-chr${CHR}.bed ../../plink/output/geno-chr${CHR}.bim ../../plink/output/geno-chr${CHR}.fam --geno 0.05 --make-bed --out ../input/chr${CHR}-1000G_MyData" -o ../logs/merge.${CHR}.log -o ../logs/merge.${CHR}.err
done

#merge for Admixture
plink-1.9 --bfile ../input/chr1-1000G_MyData --merge-list ../input/mergelist.txt --geno 0.05 --make-bed --out ../input/1000G_MyData-4Admixture
