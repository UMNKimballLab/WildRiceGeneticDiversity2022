#Using cultivated_only.vcf and naturalstand_only.vcf
library(vcfR)    
library(vegan)
library(tidyverse)
library(stats)

#Read in vcf
vcf<-read.vcfR("biallelic_snps_only.recode.vcf", convertNA =TRUE)
vcfn<-read.vcfR("naturalstand_only.vcf", convertNA =TRUE)
vcfc<-read.vcfR("cultivated_only.vcf", convertNA =TRUE)
#Extract numeric genotype data and convert to matrix
vcf_num<-extract.gt(vcf, element = "GT", IDtoRowNames  = F, as.numeric = T, convertNA = T, return.alleles = F)
vcfn_num<-extract.gt(vcfn, element = "GT", IDtoRowNames  = F, as.numeric = T, convertNA = T, return.alleles = F)
vcfc_num<-extract.gt(vcfc, element = "GT", IDtoRowNames  = F, as.numeric = T, convertNA = T, return.alleles = F)

#transpose so snps are columns
vcf_num_t <- t(vcf_num)
vcfn_num_t <- t(vcfn_num)
vcfc_num_t <- t(vcfc_num)

#back to data frame for easier manipulation
vcf_num_df <- data.frame(vcf_num_t) 
vcfn_num_df <- data.frame(vcfn_num_t) 
vcfc_num_df <- data.frame(vcfc_num_t) 

#Fix rownames to be just the sample number
row.names(vcf_num_df)<-gsub("/.*", "", rownames(vcf_num_df))
row.names(vcfn_num_df)<-gsub("/.*", "", rownames(vcfn_num_df))
row.names(vcfc_num_df)<-gsub("/.*", "", rownames(vcfc_num_df))

#read in sample info, I am using my previously edited sample key and create separate sample keys for cutlivated and natural stand 
#I'm dropping sample 1045 from the key because we don't have data for it
sample_data<-read.csv("Updated_Sample_Key_230822.csv")
sampn<-sample_data[sample_data$class == "Natural stand",]
sampc<-sample_data[sample_data$class == "Breeding line",]


#Make a samples column from the row names and join the vcf data with the sample key information
samplesa <- row.names(vcf_num_df)
vcf_sample_df <- data.frame(samples=samplesa, vcf_num_df)
vcf_num_df2 <- merge(sample_data, vcf_sample_df, by = "samples")
row.names(vcf_num_df2)<-row.names(vcf_num_df)

samplesn <- row.names(vcfn_num_df)
vcfn_sample_df <- data.frame(samples=samplesn, vcfn_num_df)
vcfn_num_df2 <- merge(sampn, vcfn_sample_df, by = "samples")
row.names(vcfn_num_df2)<-samplesn

samplesc <- row.names(vcfc_num_df)
vcfc_sample_df <- data.frame(samples=samplesc, vcfc_num_df)
vcfc_num_df2 <- merge(sampc, vcfc_sample_df, by = "samples")
row.names(vcfc_num_df2)<-samplesc


#Convert to matrix to input into vegdist() from vegan package
drop<-c("X","ID","sample_ID_simplified","sample_ID_extended", "class","samples","pch", "col")
vcf_num_df3<-vcf_num_df2[,!(names(vcf_num_df2) %in% drop)]
vcfmat<-as.matrix(sapply(vcf_num_df3, as.numeric))
row.names(vcfmat)<-samples

vcfn_num_df3<-vcfn_num_df2[,!(names(vcfn_num_df2) %in% drop)]
vcfnmat<-as.matrix(sapply(vcfn_num_df3, as.numeric))
row.names(vcfnmat)<-samplesn

vcfc_num_df3<-vcfc_num_df2[,!(names(vcfc_num_df2) %in% drop)]
vcfcmat<-as.matrix(sapply(vcfc_num_df3, as.numeric))
row.names(vcfcmat)<-samplesc

#making dissimilarity matrix, using pairwise deletion of missing values (na.rm=T)
dist<-vegdist(vcfmat, method="jaccard",na.rm=TRUE)
distn<-vegdist(vcfnmat, method="jaccard",na.rm=TRUE)
distc<-vegdist(vcfcmat, method="jaccard",na.rm=TRUE)

#Running PcoA with cmdscale(), eig=T returns eigen values and add=T adds a constant so we don't have negative values.
pcoa <- cmdscale(dist, eig=TRUE, add=TRUE,k=4)
pcoan <-cmdscale(distn, eig=TRUE, add=TRUE, k=4)
pcoac<-cmdscale(distc, eig=TRUE, add=TRUE, k=4)

save(vcf_num_df3, vcfn_num_df3,vcfc_num_df3, vcfmat, vcfnmat, vcfcmat, distn, distc, pcoan, pcoac,file=230929_PCOAdat.Rdata")


