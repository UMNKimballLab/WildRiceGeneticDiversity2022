#!/bin/bash -l

# Include path to the working directory
cd ~/plink_incl_nonbiallelic_snps

# Filter VCF file (already pre-filtered, but includes non-biallelic SNPs) for biallelic sites only
~/vcftools/bin/vcftools --vcf original.vcf  --min-alleles 2 --max-alleles 2  --recode --recode-INFO-all --out biallelic_snps_only
