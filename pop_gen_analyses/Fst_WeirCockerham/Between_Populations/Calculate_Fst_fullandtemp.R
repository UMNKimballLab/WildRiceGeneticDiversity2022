library(StAMPP)
library(tidyverse)
library(ggplot2)

#Load genlight objects created previously
load("Fstgenlight.Rdata")
load("genlight_temp.Rdata")
tempsamp<-read.csv("SampleKey_OnlyTemporal_240205.csv")

allfst<-stamppFst(gl.fstvcf, nboots=1000, percent=95, nclusters=1 )
tempfst<-stamppFst(gl.tempvcf, nboots=1000, percent=95, nclusters=1)
save(allfst,tempfst, file="fstscores.Rdata")

#I exported the all fst values and organized them manually into a table for easier plotting, loading that in here
fstdat<-read.csv("allfst_table.csv")

#Put in the order that I want
fstdat$Pop1=factor(fstdat$Pop1, levels=c("Z. aquatica" , "Bass Lake", "Clearwater River","Dahler Lake","Decker Lake","Garfield Lake", "Mud Hen Lake","Necktie River", "Ottertail River", "Phantom Lake","Lake Plantagenet", "Shell Lake", "Upper Rice Lake","K2","Barron", "Itasca-C12", "Itasca-C20", "FY-C20","PM3E"))
fstdat$Pop2=factor(fstdat$Pop2, levels=c("Z. aquatica" , "Bass Lake", "Clearwater River","Dahler Lake","Decker Lake","Garfield Lake", "Mud Hen Lake","Necktie River", "Ottertail River", "Phantom Lake","Lake Plantagenet", "Shell Lake", "Upper Rice Lake","K2","Barron", "Itasca-C12", "Itasca-C20", "FY-C20","PM3E")) 

#Format  temp data as tibble
tempfsttib <-
  tempfst$Fsts %>%
  as_tibble(rownames="pop1")%>%
  gather(colnames(tempfst$Fsts), key="pop2", value="fst")
temppvalstib<-
  tempfst$Pvalues %>%
  as_tibble(rownames="pop1")%>%
  gather(colnames(tempfst$Pvalues), key="pop2", value="pval")

#heatmap of all samples
heatmap<-ggplot(aes(Pop2, Pop1), data=fstdat)+geom_tile(aes(fill=Fst), color="black")+geom_text(size= 2.5, aes(label=sprintf("%0.2f", round(Fst, digits = 2))))+scale_fill_gradient("Fst", low="white", high="#7b77b6")+ theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1), axis.title=element_blank(), panel.background=element_rect(fill="white"), axis.line = element_line())
heatmap
ggsave("all_fst_heatmap_240212.png", heatmap, width=12, height=10)
ggsave("all_fst_heatmap_240212.tiff", heatmap, width=12, height=10)

#heatmap of temp samples
heatmaptemp<-ggplot(aes(pop1, pop2), data=na.omit(tempfsttib))+geom_tile(aes(fill=fst), color="black")+geom_text(size= 2.5, aes(label=sprintf("%0.2f", round(fst, digits = 2))))+scale_fill_gradient("Fst", low="white", high="#7b77b6")+ theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1), axis.title=element_blank(), panel.background=element_rect(fill="white"), axis.line = element_line())
heatmaptemp
ggsave("temp_fst_heatmap_240215.png", heatmaptemp, width=12, height=10)
ggsave("temp_fst_heatmap_240215.tiff", heatmaptemp, width=12, height=10)
```
