#!/bin/bash -l

cd ~/main_GBS/210306_samtools

module load R/3.6.0
# args[1] is the input TSV file, args[2] is the output CSV file, and args[3] is the output Rdata file
# original output (from 13 July 2021) was missing ZPchr0010 ... because the Rscript had a typo (ZPChr0010...capitalized "C") ... so had to re-run this and save with new date
Rscript filter_snps_and_make_wide_format.R 210713_normalize_incl_nonbiallelic.tsv 210907_normalize_incl_nonbiallelic.csv 210907_normalize_incl_nonbiallelic.Rdata
