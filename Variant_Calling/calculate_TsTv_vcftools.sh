#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=15gb
#SBATCH --mail-type=ALL
#SBATCH --mail-user=garbe047@umn.edu
#SBATCH -p ag2tb
#SBATCH --account=jkimball
#SBATCH -o calculate_TsTv_vcftools.out
#SBATCH -e calculate_TsTv_vcftools.err

cd /scratch.global/garbe047

# This is the code that was run to get the genome-wide TsTv numbers
vcftools --gzvcf biallelic_snps_only.recode.vcf --TsTv 1000000 --out genome-wide
vcftools --gzvcf biallelic_snps_only.recode.vcf --TsTv-summary --out genome-wide

# The following code was used to get the chromosome-specific TsTv results 
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0001 --TsTv 1000000 --out ZPchr0001
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0001 --TsTv-summary --out ZPchr0001

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0002 --TsTv 1000000 --out ZPchr0002
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0002 --TsTv-summary --out ZPchr0002

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0003 --TsTv 1000000 --out ZPchr0003
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0003 --TsTv-summary --out ZPchr0003

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0004 --TsTv 1000000 --out ZPchr0004
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0004 --TsTv-summary --out ZPchr0004

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0005 --TsTv 1000000 --out ZPchr0005
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0005 --TsTv-summary --out ZPchr0005

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0006 --TsTv 1000000 --out ZPchr0006
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0006 --TsTv-summary --out ZPchr0006

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0007 --TsTv 1000000 --out ZPchr0007
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0007 --TsTv-summary --out ZPchr0007

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0008 --TsTv 1000000 --out ZPchr0008
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0008 --TsTv-summary --out ZPchr0008

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0009 --TsTv 1000000 --out ZPchr0009
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0009 --TsTv-summary --out ZPchr0009

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0010 --TsTv 1000000 --out ZPchr0010
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0010 --TsTv-summary --out ZPchr0010

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0011 --TsTv 1000000 --out ZPchr0011
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0011 --TsTv-summary --out ZPchr0011

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0012 --TsTv 1000000 --out ZPchr0012
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0012 --TsTv-summary --out ZPchr0012

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0013 --TsTv 1000000 --out ZPchr0013
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0013 --TsTv-summary --out ZPchr0013

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0014 --TsTv 1000000 --out ZPchr0014
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0014 --TsTv-summary --out ZPchr0014

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0015 --TsTv 1000000 --out ZPchr0015
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0015 --TsTv-summary --out ZPchr0015

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0016 --TsTv 1000000 --out ZPchr0016
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0016 --TsTv-summary --out ZPchr0016

vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0458 --TsTv 1000000 --out ZPchr0458
vcftools --gzvcf biallelic_snps_only.recode.vcf --chr ZPchr0458 --TsTv-summary --out ZPchr0458
