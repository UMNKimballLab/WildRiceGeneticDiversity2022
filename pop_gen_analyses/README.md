# README

## Directory
1. [STRUCTURE analysis](#STRUCTURE-analysis)
2. [Analysis of Molecular Variance](#Analysis-of-Molecular-Variance)
3. [Mantel test](#Mantel-test)
4. [Similarity](#Similarity)
5. [_D_-statistics (ABBA-BABA)](#D-statistics)
6. [Linkage Disequilibrium](#Linkage-Disequilibrium)
7. [XP-CLR](#XP-CLR)



## Analysis of Molecular Variance
The Rscript [AMOVA.R](AMOVA.R) conducts the Analysis of Molecular Variance analysis. The R script uses the [```poppr.amova()```](https://search.r-project.org/CRAN/refmans/poppr/html/poppr.amova.html) function from the [_poppr_](https://cran.r-project.org/web/packages/poppr/index.html) R package. We used the "farthest neighbor" algorithm because it is the most strict option. The ```poppr.amova()``` function gives users the choice between the [_ade4_](https://cran.r-project.org/web/packages/ade4/index.html) implementation or the [_pegas_](https://cran.r-project.org/web/packages/pegas/index.html) implementation. We chose to use the _ade4_ implementation. To correct for non-Euclidean distance, we used the ```quasieuclid``` correction. We chose this over the ```lingoes``` or ```cailliez``` correction methods because ```quasieuclid``` does not introduce a modification of the original distances like the other two methods. The [AMOVA.R](AMOVA.R) script is launched using the shell script [run_AMOVA.sh](run_AMOVA.sh).

## Mantel test
The Mantel test was conducted using the R script ```mantel_test.R```. The script uses the implementation of the Mantel test in the R package [_ade4_](https://cran.r-project.org/web/packages/ade4/index.html). Geographical and genetic distances are loaded into the R environment from their own CSV files (geo_distances.csv for geographic distances and genetic_distances.csv for genetic distances). Both tables need to be converted into an object of ```dist``` class before the ```mantel.rtest()``` can be used. From a practical purpose, this modifies the original values but it appears to change them all equally.

## Similarity
The script [similarity.py](similarity.py) was written to calculate pairwise similarity between each sample in our dataset. The script creates two identical lists containing each of the sample names in order to compare two variables simultaneously (in a nested for loop). The genotype calls (SNPs) are stored in lists and compared to one another by counting the number of occurrence where the _i_-th genotype call in one sample matches the _i_-th genotype call in the seond sample in the comparison. The count is then divided by 5,955 (the total number of SNPs--note that this is hard-coded) to yield a similarity value (which should be between 0 and 1). The results are then written to a CSV file in a three-column format. The first two columns give the two samples being compared and the third column gives the similarity value.

## _D_-statistics
There is a lot to unpack with the _D_-statistics. I tried two approaches here. The first approach was relatively simple and involved a program called D-suite.

The second approach was using AdmixTools2. This program was a bit more involved to use. Population membership comes in a the form of a plink family (.fam) file. The first few lines of my `plink.fam` file look something like this:
```bash
Sample_0001/Sample_0001_sorted.bam Sample_0001/Sample_0001_sorted.bam 0 0 0 -9
Sample_0002/Sample_0002_sorted.bam Sample_0002/Sample_0002_sorted.bam 0 0 0 -9
Sample_0003/Sample_0003_sorted.bam Sample_0003/Sample_0003_sorted.bam 0 0 0 -9
```
That is, each line contains sample names exactly as they were recorded in the VCF file. It works just fine within plink for making PCA plots, etc. However, AdmixTools2 requires each of these lines to contain info about population membership. I tried writing some simple `awk` or `sed` one-liners, but nothing ended up working. (Code given below partially works-but it only returns one column in the output file and I need 6 so that it resembles the excerpt above).
```awk
awk -F':' 'NR==FNR{a[$1]=$2} NR>FNR{$1=a[$1];print}' plink_binary.fam genetic_diversity_key_for_AdmixTools.txt > plink_edited.fam
```

So, I ended up using the `VLOOKUP` function in Excel to replace each sample name with their STRUCTURE-defined population (where _K_=4). This is important because I initially started replacing sample names with the identity of that sample (e.g., lake/river of origin or cultivar/breeding line). _D_-statistics/ABBA-BABA analysis uses 4 groups so our grouping of samples into four populations (Natural Stands I, Natural Stands II, Cultivated Material, _Z. aquatica_) works out nicely.

The R script that does the analysis is [admixTools.R](admixTools.R) and is launched by [run_admixtools.sh](run_admixtools.sh).

## Linkage Disequilibrium
I used the R script [find_LD_decay.R](pop_gen_analyses/find_LD_decay.R) to calculate Linkage Disequilibrium (LD) Decay. It requires two inputs: **the first file** contains the SNP data. My data are organized in a CSV file so that rows represent individual SNPs and columns represent individuals. However, the [`The LD.decay()`](https://rdrr.io/cran/sommer/man/LD.decay.html#heading-5) function requires that the data are organized so that rows are _individuals_ and columns are _SNPs_. It also requires that the data are in a matrix rather than a data.table (or data.frame, if you're old school).

The code block shown below is how I converted the data from data.table to matrix.
```R
# Transpose data so that columns are markers and rows are individuals
data_t <- t(data)
# Convert data to matrix
data_t_m <- as.matrix(data_t)
```
This isn't a complete summary of how I processed my data, but it's enough for the README file.<br>

**The second input file** contains the map data with three columns. The first column contains the SNP names (which are somewhat arbitrary); the second column contains the chromosome/linkage group names; and the third column contains the position of the SNP (either in basepairs as in our data or in centiMorgans).

## XP-CLR
The XP-CLR analysis (Cross-Population Composite Likelihood Ratio) analysis tests for selective sweeps. The method we used was implemented by [Chen et al. 2010](https://genome.cshlp.org/content/20/3/393.short). The README can be found [here](https://vcru.wisc.edu/simonlab/bioinformatics/programs/xpclr/README.txt).<br>
The basic pattern for the code looks like this:<br>
```bash
XPCLR -xpclr genofile1 genofile2 mapfile outputFile -w1 snpWin gridSize chrN -p corrLevel
```
where:<br>
genofile1 (cultivated material) is the genotype input for _object_ population<br>
genofile2 (natural stands) is the genotype input for _reference_ population<br>
mapfile contains snp information file (**for SNPs from a single chromosome**)<br>

**Note:** One thing to pay particularly close attention to is the fact that the analysis needs to be run separately for each chromosome. This is why each file (genofile1, genofile2, and the mapfile) have numbers as suffixes (".1", ".2", ".3", ... , ".17"). The ".17" corresponds to ZPchr0458. I used 17 rather than .458 for consistency with the other input files (and because when I did some other analyses such as the LD decay analysis, when there was a jump between "chromosome 16" and "chromosome 458", the program/function `LD.decay()` in R thought there should be additional chromosomes for each number between 16 and 458. The output file for "chromosome 17" reverts back to ZPchr0458 so it doesn't interfere with our consistent usage of the nomenclature elsewhere.

**For the input file:** I opened the SNP matrix (CSV format) in Excel and converted the genotype calls to the format required by the XP-CLR program. The "0" that represents a _homozygous reference_ SNP call becomes "0 0"; the "1" that represents the _heterozygous_ SNP call becomes "0 1" and the "2" that representes the _homozygous alternate_ SNP call becomes "1 1". Then, because each genotype is in its own cell (being in comma-separated format), I decided to concatenate each of the individual SNP calls so that they were all in a single cell in Excel (separated by a single whitespace character). To do this, I used a custom Excel function called `CONCATENATEMULTIPLE` that allowed me to select an array/range of cells in Excel and concatenate them all, separated by a character of my choice. So, I chose a single white space character (`sep = " "`). Then, I copy and pasted the results _for each chromosome_ into their own text (.txt) files (but with a suffix that corresponds to the chromosome that they represent) and uploaded them all to the MSI system to run the analysis. This was done separately for the cultivated material (genofile1) and the natural stands (genofile2).

-----------------------------
_The information below is related to using Arlequin which we have more or less abandoned because it didn't seem useful for high-throughput SNP data_

**Prep files for input into Arlequin**<br>
The script [convert_csv_to_arlequin_input_format.py](convert_csv_to_arlequin_input_format.py) was written to convert the SNP matrix from the comma-separated value (CSV) format to Arlequin input format. Arlequin requires somewhat unique formatting. For a diploid individual, each locus requires two lines. There needs to be a name for the haplotype, the number of individuals with that haplotype, followed by the SNP calls. The second line only need the SNP calls. For homozygous calls (0 or 1), the ref (0) or alt (2) calls are used for both lines.

The basic code for running the script is:<br>
```python convert_csv_to_arlequin_input_format.py BassLake_snp_matrix.csv BassLake_arlequin_input.arp```<br>
The script needs to be run for each lake.

The input files are:
* BassLake_snp_matrix.csv
* ClearwaterRiver_snp_matrix.csv
* DahlerLake_snp_matrix.csv
* DeckerLake_snp_matrix.csv
* GarfieldLake_snp_matrix.csv
* MudhenLake_snp_matrix.csv
* NecktieRiver_snp_matrix.csv
* OttertailRiver_snp_matrix.csv
* PhantomLake_snp_matrix.csv
* Plantagenet_snp_matrix.csv
* ShellLake_snp_matrix.csv
* UpperRiceLake_snp_matrix.csv
* ZizaniaAquatica_snp_matrix.csv

They were created by opening the original SNP matrix (with rows=SNPs and columsn=individuals) in Excel and separating the SNP data accrording to which lake/river they come from. The data were then transposed (so that rows=individuals and columns=SNPs) as required for Arlequin format.<br>

Some post-processing is required at the moment. For example, Arlequin format requires 2 rows for each haplotype, but only the first one needs a name and number of occurrence. So, I need to find a way to skip those first two columns/fields for the second row to ensure that the loci align properly. There are also extra loci for the last individual and I'm not quite sure why. <br>

I am considering each individual to have its own haplotype. We would likely see many shared haplotypes if we were using imputed data, but for now I haven't tried to reduce the number of haplotypes. I think there is too much missing data for the combination of haplotypes to be possible.

Arlequin can be difficult to work with sometimes. Here are the settings that I used to make it work:
* Each lake in its own group
    * e.g., Group 1 = Bass Lake, Group 2 = Clearwater River
* Project information (all of this is greyed out)
    * Filename: C:/Users/haasx092/Documents/wild_rice/genetic_diversity/Arlequin_files/natural_stands_fst.arp
    * Ploidy: Genotypic data
    * Gametic Phase: Unknown
    * Dominance: Codominant
    * Data type: DNA
    * Recessive allele: null
    * Locus separator: WHITESPACE
    * Missing data: ?
* Population comparisons
    * :heavy_check_mark: Compute pairwise FST
* Genetic distance settings
    * :heavy_check_mark: Slatkin's distance
    * :heavy_check_mark: Reynold's distance
    * :heavy_check_mark: Compute pairwise differences (pi)
    * No. of permutations: 100
    * Significance level: 0.05
    * Use conventional F-statistics (haplotype frequencies only)
    * Pairwise difference
    * Gamma a value: 0 
* Population differentiation
    * :heavy_check_mark: Exact test of population differentiation
    * Exact test settings
        * No. of steps in Markov chain: 100,000
        * No. of dememorization steps: 10,000
        * :heavy_check_mark: Generate histogram and table
        * Significance level: 0.05
* Project Wizard
    * Data type: FREQUENCY
    * Genotypic data: NOT CHECKED
    * Known gametic phase: GREY AND NOT CHECKED
    * Recessive data: GREY AND NOT CHECKED
    * Controls:
        * No. of samples: 2
        * Locus separator: WHITESPACE
        * Missing data: ?
    * Optional sections
        * Include haplotype list: UNCHECKED
        * Include distance matrix: UNCHECKED
        * Include genetic structure: UNCHECKED
