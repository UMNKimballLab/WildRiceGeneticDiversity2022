library(vcfR)
library(poppr)
library(ape)
library(RColorBrewer)

allvcf<-read.vcfR("~/Genetic_Diversity/notemporal.vcf")
samp<-read.csv("/panfs/jay/groups/21/jkimball/garbe047/Genetic_Diversity/SampleKey_Notemporal_240205.csv")
#exclude<-c("Sample_0896", "Sample_0825", "Sample_0670", "Sample_0645", "Sample_0692", "Sample_0402", "Sample_0381", "Sample_0151", "Sample_0104", "Sample_0136", "Sample_0782", "Sample_0791", "Sample_0742", "Sample_0045", "Sample_0681", "Sample_0458", "Sample_0442", "Sample_0421", "Sample_0408", "Sample_0420", "Sample_0419", "Sample_0387", "Sample_0376", "Sample_0418", "Sample_0560")
#samp2<-samp[!(samp$Sample_number %in% exclude),]

#Make sure number of samples match up
all(colnames(allvcf@gt)[-1] == samp$sample_ID_simplified)

#Make genlight object
gl.allvcf <- vcfR2genlight(allvcf)
ploidy(gl.allvcf) <- 2

#Add population data from sample key
pop(gl.allvcf) <- samp$Sample_ID

#Make a tree for all except temporal with 1000 bootstraps, prevosti's distance, cutoff of 50, upgma algorithm
alltree<-aboot(gl.allvcf, tree="upgma", distance = bitwise.dist, sample = 1000, showtree=F, cutoff= 50)

save(gl.allvcf, alltree, file="~/Genetic_Diversity/genlight_all.Rdata")