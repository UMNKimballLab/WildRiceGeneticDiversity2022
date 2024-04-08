#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#SBATCH -o bedtools_find_snps_in_genes.out
#SBATCH -e bedtools_find_snps_in_genes.err

cd /home/jkimball/haasx092/plink_incl_nonbiallelic_snps

module load bedtools

VCF_INFILE='biallelic_snps_only.recode.vcf'
GFF_INFILE='out.gff'

bedtools intersect -a $VCF_INFILE -b $GFF_INFILE -header -wa > snps_in_genes.vcf
