#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=24:00:00
#SBATCH --mem=30g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=haasx092@umn.edu
#SBATCH -p amdsmall
#SBATCH --account=jkimball
#SBATCH -o calculate_Fst_Vcftools_natural_stands_vs_cultivated_2022.out
#SBATCH -e calculate_Fst_Vcftools_natural_stands_vs_cultivated_2022.err

cd /home/jkimball/haasx092/Fst_Vcftools

~/vcftools/bin/vcftools --gzvcf natural_stands_and_breeding_lines.recode.vcf --weir-fst-pop cultivated.txt --weir-fst-pop natural_stands.txt
