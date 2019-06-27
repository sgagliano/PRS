# InPSYght-PRS

**Workflow**

A. Prepare genetic data for RFMix
1. `RemoveMultiAllelic.sh` #preprocess VCFs
2. `PhasePrepScript.R` #prepare script for phasing
3. `Phase_tt.sh` #output from `PhasePrepScript.R` for phasing, can use `Commands2Array.py` to submit these tasks as an array on a cluster

B. Run RFMix

C. Determine which variants to include in PRS via published GWAS summary statistics

D. Compute PRS in genetic data
1. `ConvertSummaryStats2b38.sh` #Make sure build for summary statistics & genetic data match. If not, convert summary statistics build. 
