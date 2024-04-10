[Alignment to the Zizania palustris genome](run_bwa.sh) was done with the bwa mem function.

[Variant calling](scythe_mpileup.sh) was done with SAMtools mpileup.

The resulting vcf files were initially [filtered](filter_with_vcftools_incl_non_biallelic_snps.sh) with VCFtools using the parameters:
* --max-missing 0.80
* --min-alleles 2 
* --maf 0.05 
* --remove-indels 
* --minDP 4

and then [concatenated](concat_filtered_vcfs.sh) with BCFtools.

The concatenated file was [further filtered](filter_biallelic_only.sh) to include only biallelic SNPs.

**Transition and Transversion ratios**<br>
The transition/transverion (TsTv) ratio was calculated via VCFtools using the script [calculate_TsTv_vcftools.sh](calculate_TsTv_vcftools.sh). The script features two basic lines of code with two VCFtools options: 1) ```--TsTv 1000000``` and 2) ```--TsTv summary```. The first calculates SNP count and TsTv ratios for each bin of the size specified (1 Mb in our case). The second is a summary and presents the overall results for each type of transition or transversion. These are the numbers that we put into Table 1 of our manuscript. The script was run multiple times, changing the ```--chr``` option for each of the 17 major scaffolds (ZPchr0001 through ZPchr0016 and ZPchr0458) as well as without the ```--chr``` option to get the genome-wide stats. 
