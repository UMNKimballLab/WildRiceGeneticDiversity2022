#!/bin/bash -l

# Include path to the working directory
cd ~/main_GBS/210306_samtools

# Filter VCF files for missing data (20%), no indels, and a depth of 4, minor allele frequency minimum of 0.05
for i in $(cat vcf_file_list.txt)
do
STEM=$(echo ${i} | cut -f 1 -d ".")
~/vcftools/bin/vcftools --gzvcf  $i --max-missing 0.80 --min-alleles 2 --maf 0.05 --remove-indels --minDP 4 --recode --recode-INFO-all --out ${STEM}_filtered_20_NA_incl_nonbiallelic_snps
done
