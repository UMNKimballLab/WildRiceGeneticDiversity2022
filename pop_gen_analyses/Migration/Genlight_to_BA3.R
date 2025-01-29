library(dartR.base)
load("Fstgenlight.Rdata")

#Shorten sample names in genlight objects
indNames(gl.fstvcf)<- sub("/.*","" , indNames(gl.fstvcf))
indNames(gl.fstvcf)<- sub("_","" , indNames(gl.fstvcf))

#Make FST pared down data genlight into BA3 format
pop(gl.fstvcf)<-sub("-","" , pop(gl.fstvcf))
pop(gl.fstvcf)<-sub("_","" , pop(gl.fstvcf))
pop(gl.fstvcf)<-gsub(" ","" , pop(gl.fstvcf))
locNames(gl.fstvcf)<-gsub("_","x", locNames(gl.fstvcf))
gl2bayesAss(gl.fstvcf, ploidy=2, outfile="input_BA3_lim_250114.txt", outpath="Genetic Diversity/BayesAss")
