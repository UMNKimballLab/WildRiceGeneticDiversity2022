library(dplyr)
library(pophelper)
load("231025_structuredat.Rdata")
sfiles <- list.files(path= "~/STRUCTURE/Figure", full.names=T)
slist<-readQ(files=sfiles)

#Labels for the figures
glabs<-as.data.frame(as.character(datapc$sample_ID_simplified))
names(glabs)<-"population"
glabs <- glabs %>% 
  mutate(population=ifelse(population %in% justcultord, "Cultivated Material", population))%>% 
  mutate(population=ifelse(population == "Aquatica_species","Z. aquatica", population))

#Figure 3
fig3list<-alignK(slist[1:4])
fig3<-plotQ(fig3list, returnplot=T,exportpath=getwd(),imgoutput="join",grplab=glabs,outputfilename=c("250120_fig3"),imgtype="png", grplabangle=25, grplabsize=1.3, divtype=1, divsize=0.5, splab=c("K=2", "K=3","K=4","K=5"),splabsize=5.2, grplabheight=8, grplabpos=0.5, grplabspacer=0, showlegend=TRUE,legendkeysize=5, legendtextsize=4, height=0.8,clustercol=c("#000000", "#E69F00","#56B4E9","#009E73","#F0E442"))
#Figure S5 
figS5<-plotQ(slist[c(4,9,13)], returnplot=T,exportpath=getwd(),imgoutput="join",grplab=glabs,outputfilename=c("250120_figs5"),imgtype="png", grplabangle=25, grplabsize=1.3, divtype=1, divsize=0.5, splab=c("K=5", "K=10","K=14"), splabsize=5.2,grplabheight=4.6, grplabpos=0.5, grplabspacer=0, showlegend=TRUE,legendkeysize=5, legendtextsize=4, clustercol=c("#000000", "#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7","#73030F","#230786","#EBF72D","#F72D44","#02440F","#08ECE0"))
