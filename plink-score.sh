#compute centred PRS

plink-1.9 --bfile myplinkfileprefix --score rps.scores_rsIDs-0.05 1 2 3 header center --out X

#where `head -n3 rps.scores_rsIDs-0.05`:
#ids	a1	or	snpid
#chr10:10011476:T:A	A	1.04844	rs1876067
#chr10:100151385:A:G	A	0.92008	rs12806
#and first column matches variant ID naming convention in myplinkfileprefix.bim

#hint to speed up: ensure `myplinkfileprefix` only contains variants in `rps.scores_rsIDs-0.05`
