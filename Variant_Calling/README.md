[Alignment to the Zizania palustris genome](run_bwa.sh) was done with the bwa mem function.

[Variant calling](scythe_mpileup.sh) was done with SAMtools mpileup.

The resulting vcf files were [filtered](filter_with_vcftools_incl_non_biallelic_snps.sh) so that sites with more than 2 alleles were permitted. The parameters include:
* --max-missing 0.80
* --min-alleles 2 
* --maf 0.05 
* --remove-indels 
* --minDP 4to no more than 20% missing data, no indels, and a depth of 4 using VCFtools

and then [concatenated](concat_filtered_vcfs.sh) with BCFtools.

The concatenated file was [further filtered](filter_biallelic_only.sh) to include only biallelic SNPs.
