library(vcfR)
library(poppr)
library(ape)
library(RColorBrewer)

allvcf<-read.vcfR("notemporal.vcf")
samp<-read.csv("SampleKey_Notemporal_240205.csv")

#Make sure number of samples match up
all(colnames(allvcf@gt)[-1] == samp$sample_ID_simplified)

#Make genlight object
gl.allvcf <- vcfR2genlight(allvcf)
ploidy(gl.allvcf) <- 2

#Add population data from sample key
pop(gl.allvcf) <- samp$Sample_ID

#Make a tree for all except temporal with 1000 bootstraps, prevosti's distance, cutoff of 50, upgma algorithm
alltree<-aboot(gl.allvcf, tree="upgma", distance = bitwise.dist, sample = 1000, showtree=F, cutoff= 50)

save(gl.allvcf, alltree, file="genlight_all.Rdata")
