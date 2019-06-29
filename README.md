# InPSYght-PRS

**Workflow**

A. Prepare genetic data for RFMix
1. `RemoveMultiAllelic.sh` #preprocess VCFs
2. `PhasePrepScript.R` #prepare script for phasing
3. `Phase_tt.sh` #output from `PhasePrepScript.R` for phasing; can use `Commands2Array.py` to submit these tasks as an array on a cluster

B. Run RFMix
1. ...

C. Determine which variants to include in PRS via published GWAS summary statistics
1. `ConvertSummaryStats2b38.sh` #if build for summary stats is on b37 & genetic data is on b38, convert summary stats via dbSNP rsID to b38
2. `Check_rsID_dbSNP_Merge.sh` #check that output of `Merge_rsID_dbSNP` aligns by chromosome, and remove mismatched rsIDs

D. Compute PRS in genetic data
1. `ConvertVCFtoPLINK.sh` #if PLINK format rather than VCF/BCF is needed
