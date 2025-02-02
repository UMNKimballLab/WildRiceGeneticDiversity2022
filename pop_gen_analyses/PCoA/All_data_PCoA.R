library(vcfR)    
library(vegan)
library(tidyverse)
library(ggplot2)
library(ggpubr)

vcf<-read.vcfR("biallelic_snps_only.recode.vcf", convertNA =TRUE)

#Extract numeric genotype data and convert to matrix
vcf_num<-extract.gt(vcf, element = "GT", IDtoRowNames  = F, as.numeric = T, convertNA = T, return.alleles = F)

#transpose so snps are columns
vcf_num_t <- t(vcf_num)
#back to data frame for easier manipulation
vcf_num_df <- data.frame(vcf_num_t) 

#read in sample info, I am using this edited sample key from the R file 230804_samplekey_edited_mainGBS.Rdata
samp<-load("230804_samplekey_edited_mainGBS.Rdata")

#make sure both sample data and snp table have sample column and that the sample names are the same
sample_data<-sample_data %>% rename("sample" ="sample_number")
row.names(vcf_num_df)<-gsub("/.*", "", rownames(vcf_num_df))
samples <- row.names(vcf_num_df)
vcf_sample_df <- data.frame(samples, vcf_num_df)
vcf_num_df2 <- merge(sample_data, vcf_sample_df, by = "samples")
row.names(vcf_num_df2)<-vcf_num_df2$samples

#Convert to matrix to input into vegdist() from vegan package
drop<-c("ID","sample_ID_simplified","sample_ID_extended", "class","samples")
vcf_num_df3<-vcf_num_df2[,!(names(vcf_num_df2) %in% drop)]
vcfmat<-as.matrix(sapply(vcf_num_df3, as.numeric))
names<-row.names(vcf_num_df3)
row.names(vcfmat)<-names

#making dissimilarity matrix, using pairwise deletion of missing values (na.rm=T)
dist<-vegdist(vcfmat, method="jaccard",na.rm=TRUE)

#Running PcoA with cmdscale(), eig=T returns eigen values and add=T adds a constant so we don't have negative values.
pcoa <- cmdscale(dist, eig=TRUE, add=TRUE,k=4)

save(vcfmat, dist, pcoa, file ="230814_Pcoadat.Rdata")

