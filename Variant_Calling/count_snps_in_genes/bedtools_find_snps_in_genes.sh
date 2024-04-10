#!/bin/bash -l

cd ~/plink_incl_nonbiallelic_snps

module load bedtools

VCF_INFILE='biallelic_snps_only.recode.vcf'
GFF_INFILE='out.gff'

bedtools intersect -a $VCF_INFILE -b $GFF_INFILE -header -wa > snps_in_genes.vcf
