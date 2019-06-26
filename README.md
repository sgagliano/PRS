# InPSYght-PRS

Workflow

A. Prepare genetic data for RFMix
1. RemoveMultiAllelic.sh #preprocess VCFs
2. PhasePrepScript.R #prepare script for phasing
3. Phase_tt.sh #output from PhasePrepScript.R for phasing

B. Run RFMix

C. Determine which variants to include in PRS via published GWAS summary statistics

D. Compute PRS in genetic data
