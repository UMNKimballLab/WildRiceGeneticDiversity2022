# _D_-statistics (ABBA-BABA analysis)
# AdmixTools

## Installation
[AdmixTools2](https://github.com/uqrmaie1/admixtools) was used for the ABBA-BABA/_D_-statistics analysis. The original AdmixTools can be found [here](https://github.com/DReichLab/AdmixTools/tree/master/src). I chose to go with AdmixTools2 because it has the same functionality but is more user-friendly, thanks to the R interface. **Note:** I did the installation and carried out the analysis on the Minnesota Supercomputing Institute servers rather than on my personal device.

I followed the instructions to install AdmixTools [here](https://github.com/uqrmaie1/admixtools). Initially, I had issues getting `tidyverse` and `plotly` installed. The final solution that enabled me to install them was to switch from `R/3.6.0` to `R/4.1.0`.

Since I did not already have these R packages installed, I needed to install them so that I could use them in my analysis. The `Rcpp` package was already installed.
```R
install.packages("tidyverse")
install.packages("igraph")
install.packages("plotly")
```
**Note:** the R package `devtools` is also requried, but I didn't need to install it because it was already installed.
```R
devtools::install_github("uqrmaie1/admixtools")
library("admixtools")
```
**Note:** You do not need to carry out these installation steps every time you open R. Once they are installed, you're good to go.

## Getting the program up and running

AdmixTools can take genotype data in binary plink format. In order to convert my existing plink files into binary format, I used the following code. Make sure you use `module load plink` first!
```bash
plink --file plink_incl_nonbiallelic --make-bed --allow-extra-chr --out plink_binary
```

Perhaps a more descriptive name would be useful, but for now I just wanted to get this up and working. Inside your R script, you can use the following command to load the genotypic data:
```R
geno = read_plink("plink_binary")
```
Voilà! Works like a charm.

Calculate allele frequencies.
```R
afs = plink_to_afs("plink_binary")
```

_D_-statistics are calculated with the following code:
```R
out = f4(data, f4mode = FALSE)
```

One of the challenges here is how to assign population membership. It was relatively simple with Dsuite but is not as clear with AdmixTools. I think this is because they assume population/family membership is already embedded into the plink data which it is not for me. However, I think I can assign population membership within R. I used the following code to pull population membership from a text file because the sample names are long and convoluted. This is something that could be addressed by shortening the sample names within the VCF file before converting to a plink object, but for now this is what I am doing to solve the issue.
```R
cluster1 <- scan("cluster_1.txt", character())
aquatica <- scan("aquatica.txt", character())
cultivated <- scan("cultivated_material.txt", character())
cluster4 <- scan("cluster_4.txt", character())
```

I may have a problem with my approach. It's currently not working, so something is off with my understanding. The `sure = TRUE` setting was suggested by the program, but it needs to be submtited to the queue because it consumes too much memory. Casts doubt on whether this is actually what I want to do.
```R
f4(geno, cluster1, aquatica, cultivated, cluster4, f4mode = FALSE, sure = TRUE)
```
