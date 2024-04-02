#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#SBATCH -o filter_for_biallelic_only_with_vcftools.out
#SBATCH -e filter_for_biallelic_only_with_vcftools.err

# Include path to the working directory
cd /home/jkimball/haasx092/plink_incl_nonbiallelic_snps

# Filter VCF file (already pre-filtered, but includes non-biallelic SNPs) for biallelic sites only
~/vcftools/bin/vcftools --vcf original.vcf  --min-alleles 2 --max-alleles 2  --recode --recode-INFO-all --out biallelic_snps_only
