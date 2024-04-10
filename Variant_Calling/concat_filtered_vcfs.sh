#!/bin/bash

# Include path to the working directory
cd ~/main_GBS/210624_samtools

module load bcftools

chr1='210624_samtools_ZPchr0001_filtered_20_NA_dp4.recode.vcf'
chr2='210624_samtools_ZPchr0002_filtered_20_NA_dp4.recode.vcf'
chr3='210624_samtools_ZPchr0003_filtered_20_NA_dp4.recode.vcf'
chr4='210624_samtools_ZPchr0004_filtered_20_NA_dp4.recode.vcf'
chr5='210624_samtools_ZPchr0005_filtered_20_NA_dp4.recode.vcf'
chr6='210624_samtools_ZPchr0006_filtered_20_NA_dp4.recode.vcf'
chr7='210624_samtools_ZPchr0007_filtered_20_NA_dp4.recode.vcf'
chr8='210624_samtools_ZPchr0008_filtered_20_NA_dp4.recode.vcf'
chr9='210624_samtools_ZPchr0009_filtered_20_NA_dp4.recode.vcf'
chr10='210624_samtools_ZPchr0010_filtered_20_NA_dp4.recode.vcf'
chr11='210624_samtools_ZPchr0011_filtered_20_NA_dp4.recode.vcf'
chr12='210624_samtools_ZPchr0012_filtered_20_NA_dp4.recode.vcf'
chr13='210624_samtools_ZPchr0013_filtered_20_NA_dp4.recode.vcf'
chr14='210624_samtools_ZPchr0014_filtered_20_NA_dp4.recode.vcf'
chr15='210624_samtools_ZPchr0015_filtered_20_NA_dp4.recode.vcf'
scf16='210624_samtools_ZPchr0016_filtered_20_NA_dp4.recode.vcf'
scf458='210624_samtools_ZPchr0458_filtered_20_NA_dp4.recode.vcf'

bcftools concat $chr1 $chr2 $chr3 $chr4 $chr5 $chr6 $chr7 $chr8 $chr9 $chr10 $chr11 $chr12 $chr13 $chr14 $chr15 $scf16 $scf458 > filt_20_NA_vcf_files_concat.vcf
