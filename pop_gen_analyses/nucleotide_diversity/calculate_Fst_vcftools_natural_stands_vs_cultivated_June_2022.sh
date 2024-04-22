#!/bin/bash -l
cd ~/Fst_Vcftools

#Outputs to out.weir.fst
vcftools --gzvcf natural_stands_and_breeding_lines.recode.vcf --weir-fst-pop cultivated.txt --weir-fst-pop natural_stands.txt
