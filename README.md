# InPSYght-PRS

**Workflow**

A. Prepare genetic data
1. `RemoveMultiAllelic.sh` #preprocess VCFs
2. `PhasePrepScript.R` #prepare script for phasing (be sure to tabix the output too)
3. `Phase_tt.sh` #output from `PhasePrepScript.R` for phasing; can use `Commands2Array.py` to submit these tasks as an array on a cluster

B. Prepare reference genetic
1. `1000G_prep.sh` #prepare 1000G b38 VCFs by adding chr prefix (be sure to tabix the output too)
2. `1000G-ConvertVCFtoPLINK.sh` #convert 1000G VCFs to PLINK 

C. Run Admixture
1. `prep4admixture.sh` #merge 1000G and own genetic data together
2. `admixture.sh` #run admixture

D. Convert GWAS summary statistics to b38 (using rsID)
1. `ConvertSummaryStats2b38.sh` #if build for summary stats is on b37 & genetic data is on b38, convert summary stats via dbSNP rsID to b38
2. `Check_rsID_dbSNP_Merge.sh` #check that output of `Merge_rsID_dbSNP` aligns by chromosome, and remove mismatched rsIDs
3. `Add_dbSNP_id.sh` #Add chr:bp:ref:alt id (in b38 coordinates) to the summary stats, assuming target data for PRS uses those ids too

E. Compute PRS in genetic data
1. `ConvertVCFtoPLINK.sh` #if PLINK format rather than VCF/BCF is needed
2. `PRS.sh` #Use PrSice to compute PRS from base (summary statistics) in b38 target (raw data)
