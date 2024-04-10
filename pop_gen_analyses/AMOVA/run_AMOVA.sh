#!/bin/bash -l

cd ~/AMOVA

module load gcc/8.1.0
module load udunits/2.2.26_gcc8.1.0
module load proj/4.9.3
module load gdal/2.3.2
module load geos/3.7.1
module load R/3.6.0

Rscript AMOVA.R filtered_to_match_STRUCTURE_input.recode.vcf
