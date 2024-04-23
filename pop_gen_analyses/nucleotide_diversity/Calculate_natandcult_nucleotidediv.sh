#!/bin/bash -l


~/vcftools/bin/vcftools --gzvcf filt_20_NA_vcf_files_concat_incl_nonbiallelic_snps_and_indels.vcf --keep barron.txt --keep fy-c20.txt --keep itasca-c12.txt --keep itasca-c20.txt --keep k2ef-c16.txt --keep pm3e.txt --site-pi --out nucleotide_diversity_cultivated

~/vcftools/bin/vcftools --gzvcf filt_20_NA_vcf_files_concat_incl_nonbiallelic_snps_and_indels.vcf --keep bass_lake.txt --keep clearwater_river.txt --keep dahler_lake.txt --keep decker_lake.txt --keep garfield_lake.txt --keep mudhen_lake.txt --keep necktie_river.txt --keep ottertail_river.txt --keep phantom_lake.txt --keep plantagenet.txt --keep shell_lake.txt --keep upper_rice_lake.txt --site-pi --out nucleotide_diversity_natural_stands
