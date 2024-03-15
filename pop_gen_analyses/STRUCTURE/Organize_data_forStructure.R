library(data.table)
library(tidyverse)

#loading in snp table and edited sample key with cultivated lines separated
dat<-read.csv("210908_normalize_incl_nonbiallelic_STRUCTURE_format_PCA_subset.csv")
csamp<-read.csv("/home/jkimball/garbe047/Genetic_Diversity/Sample_Key_with_cultivated_231003.csv", header=TRUE)

#Merging snp table with sample info  and creating data sets for each sorting parameter 

dat<-dat %>% rename("samples" ="X")
datapc<-merge(csamp, dat, by="samples")
datawat<-datapc

#Order samples based on PCOA groupings

PCOAorder<-c("Aquatica_species","Mud Hen Lake", "Phantom Lake", "Bass Lake", "Dahler Lake", "Decker Lake", "Upper Rice Lake", "Clearwater River","Ottertail River","Shell Lake", "Plantagenet","Garfield Lake", "Necktie River","FY-C20","Itasca-C12","Itasca Haploid","Itasca-C20","PBML-C20","PM3/3*PBM-C3","PM3E","Barron","K2B-C16","K2EFBP-C1","K2EF-C16","VE/2*14WS/*4K2EF","VN/3*K2EF","PM3/7*K2EF","14PD-C10","14S*PS","14S-PS","14S*PM3/PBM-C3","KPVN-C4","KSVN-C4","GPB/K2B-C2","GPN-1.20","GPP-1.20","PLaR-C20")
datapc$sample_ID_simplified<-factor(datapc$sample_ID_simplified, levels= PCOAorder, ordered=TRUE)
datapc<-datapc[order(datapc$sample_ID_simplified),]

#Saving as text files without extra columns 
row.names(datapc)<-datapc$samples
datapc2=datapc[,-c(1,2,3,4,5,6)]
write.csv(datapc2, "231025_Structure_data_bypcoa.csv", row.names=TRUE)
save(csamp, dat, datapc,datawat,datapc2,datawat2,PCOAorder, Waterorder, justcultord,  file="/home/jkimball/garbe047/Genetic_Diversity/231025_structuredat.Rdata")

#Open in excel and save it as a text tab delimited file then create a new project and import it into STRUCTURE
#Data appears to be set up as haploid since we don't have two allele calls so it was put into structure as haploid, 769 individuals, 1565 loci and -9 as missing value, has row of marker names and column of individual names and data has individuals in a single line. 
#Set up a project for each of the data orders with same parameters 
#Parameters were set to 1000 burn in and 10,000 iterations using admixture model, allele frequencies correlated - named Matthew parameters
#Clicked project, start a job, picked the made parameter and ran K 2-15, 3 iterations of each
