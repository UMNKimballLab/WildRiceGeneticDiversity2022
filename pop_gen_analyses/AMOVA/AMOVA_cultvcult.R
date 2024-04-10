library(vcfR)
library(poppr)
library(ape)
library(RColorBrewer)
library(data.table)
library(adegenet)
library("openxlsx")

#Read in cultivated only VCF file and sample key that has cultivated groupings according to PCoA
vcult<-read.vcfR("cultivated_only.vcf", convertNA =TRUE)
sampc<-read.csv("Cultivated_samplekey_groupings.csv", header=TRUE)

#Value in genlight but not sample key: Sample_1039
#Make Genlight object from vcf file, shorten ind.names to match sample key, then remove sample that isn't in key
gen_cult<-vcfR2genlight(vcult)
gen_cult$ind.names<-substr(gen_cult$ind.names,1,11)
gen_cult<-gen_cult[gen_cult$ind.names != "Sample_1039"]

#Remove samples from key that are not part of vcf
new<-setdiff(sampc$ind.names,gen_cult$ind.names)
sampc2<-sampc[!(sampc$ind.names %in% new),]

#Add strata based on groupings from sample file

gen_cult2<-strata(gen_cult, value=sampc2, formula= ~population)

# Run AMOVA
# quasieuclid method is the default correction for non-euclidean distance, but is explicitly included to remove all doubt from the mind of anyone who may read this code
cultivated_AM <- poppr.amova(gen_cult2, hier = ~population, algorithm = "farthest_neighbor", within = FALSE, method = "ade4", correction = "quasieuclid")

#Signficance testing
set.seed(999)
cultivated_sig <- randtest(cultivated_AM, nrepet = 999)
plot(cultivated_sig)
