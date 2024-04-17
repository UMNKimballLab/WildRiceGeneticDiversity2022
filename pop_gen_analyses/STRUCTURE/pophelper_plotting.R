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
fig3<-plotQ(fig3list, returnplot=T,exportpath=getwd(),imgoutput="join",grplab=glabs,outputfilename=c("240220_fig3"),imgtype="png", grplabangle=25, grplabsize=1.1, divtype=1, divsize=0.5, splab=c("K=2", "K=3","K=4","K=5"), grplabheight=5, grplabpos=0.5, grplabspacer=0, showlegend=TRUE)

#Figure S4 
figS4<-plotQ(slist[c(4,9,13)], returnplot=T,exportpath=getwd(),imgoutput="join",grplab=glabs,outputfilename=c("240220_figs4"),imgtype="png", grplabangle=25, grplabsize=1.1, divtype=1, divsize=0.5, splab=c("K=5", "K=10","K=14"), grplabheight=5, grplabpos=0.5, grplabspacer=0, showlegend=TRUE)
