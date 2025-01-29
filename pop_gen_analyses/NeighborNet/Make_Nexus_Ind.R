library(dartR)
library(dartR.base)
library(phangorn)
library(adegenet)
library(poppr)
library(ape)
library(dplyr)
library(tidyr)

load("genlight_all.Rdata")

#Shorten sample names in genlight object
indNames(gl.allvcf)<- sub("/.*","" , indNames(gl.allvcf))
indNames(gl.allvcf)<- sub("_","" , indNames(gl.allvcf))

#Calculate distance matrix
dist<-bitwise.dist(gl.allvcf, mat=TRUE, scale_missing=TRUE, euclidean=FALSE)
write.csv(dist, file="distbit_250107.csv")

#make nexus file to use in splits tree app
sample_names <- indNames(gl.allvcf)
if (!is.null(pop(gl.allvcf))) {
  sample_names <- paste(sample_names, pop(gl.allvcf), sep = "_")}
##Replace spaces in sample names with underscores
sample_names <- gsub(" ", "_", sample_names)
##Export distance matrix to NEXUS format
rownames(dist)<-colnames(dist)<-sample_names
write.nexus.dist(as.dist(dist), file = "distance_matrix.nex")
