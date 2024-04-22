library(vcfR)
library(poppr)
library(ape)
library(RColorBrewer)

tempvcf<-read.vcfR("~/Genetic_Diversity/temporal.vcf")
samp<-read.csv("SampleKey_OnlyTemporal_240205.csv")

#Make sure number of samples match up
all(colnames(tempvcf@gt)[-1] == samp$sample_ID_simplified)

#Make genlight object
gl.tempvcf <- vcfR2genlight(tempvcf)
ploidy(gl.tempvcf) <- 2

#Add population data from sample key
pop(gl.tempvcf) <- samp$Sample_ID

#Make a tree for all except temporal with 1000 bootstraps, prevosti's distance, cutoff of 50, upgma algorithm
temptree<-aboot(gl.tempvcf, tree="upgma", distance = bitwise.dist, sample = 1000, showtree=F, cutoff= 50)

save(gl.tempvcf, temptree, file="genlight_temp.Rdata")
