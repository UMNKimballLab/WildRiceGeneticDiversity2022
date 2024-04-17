library(vcfR)
library(poppr)
library(ape)

allvcf<-read.vcfR("notemporal.vcf")

samp<-read.csv("SampleKey_Notemporal_240205.csv")

#Change Sample_ID of Cultivated samples to NCROC instead of genotype name

samp2<-samp
samp2$Sample_ID<-ifelse(samp2$Class == "Breeding line", "NCROC", samp2$Sample_ID)

#Make sure number of samples match up
all(colnames(allvcf@gt)[-1] == samp2$sample_ID)

#Make genlight object
gl.mantel <- vcfR2genlight(allvcf)
ploidy(gl.mantel) <- 2

#Add population data from sample key
pop(gl.mantel) <- samp2$Sample_ID


save(gl.mantel,  file="genlight_mantel.Rdata")
