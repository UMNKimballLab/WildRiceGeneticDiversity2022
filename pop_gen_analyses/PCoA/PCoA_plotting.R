#Set directory and load required packages
setwd("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA")
library(tidyverse)
library(ggplot2)
library(ggpubr)
library(glue)
library(grid)
library(gridExtra)
library(cowplot)

#Load in data for all PCoAs
##all data PCA info
load("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/230814_Pcoadat.Rdata")
aPCOA<-pcoa

##temporal data PCA info
load("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/231003_Temporal_PCOAdat.Rdata")
tPCOA<-pcoa

##cultivated vs natural stand PCoA info
load("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/230929_PCOAdat.Rdata")

#Read in sample keys
sample_data<-read.csv("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/Updated_Sample_Key_231003.csv")
sample_data2<-read.csv("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/Sample_Key_with_cultivated_231003.csv")
load("G:/My Drive/Kimball lab/Projects/Genetic Diversity/PCOA/filtering_temporal_231003.Rdata")
nPCOA<-pcoan
cPCOA<-pcoac
sample_data$sample_ID_simplified=factor(sample_data$sample_ID_simplified,levels=c("Aquatica_species", "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))
sampn<-sample_data[sample_data2$class == "Natural stand",]
sampc<-sample_data2[sample_data$class == "Breeding line",]
Tsamp<-Temp


#All data PCoA
##Using dist matrices calculated in vegdist - see file All_data_PCoA.txt
positions <- aPCOA$points
colnames(positions) <- c("pcoa1", "pcoa2", "pcoa3","pcoa4")

##Setting up data into a tibble and merging it with the sample key to get group data
positions<-as_tibble(positions, rownames = "samples")
positions2 <-merge(sample_data, positions, by = "samples")
eig<-aPCOA$eig[1:20]
names<- c("PCo1", "PCo2", "PCo3", "PCo4", "PCo5", "PCo6", "PCo7", "PCo8", "PCo9", "PCo10", "PCo11", "PCo12", "PCo13",
          "PCo14", "PCo15", "PCo16", "PCo17", "PCo18", "PCo19", "PCo20")
shortdat<-data.frame(names, eig)
shortdat$names=factor(shortdat$names,levels=c("PCo1", "PCo2", "PCo3", "PCo4", "PCo5", "PCo6", "PCo7", "PCo8", "PCo9", "PCo10", "PCo11", "PCo12", "PCo13","PCo14", "PCo15", "PCo16", "PCo17", "PCo18", "PCo19", "PCo20"))
stib<-as_tibble(shortdat)
stib$pe<-stib$eig/sum(stib$eig) * 100
stib$pe <- format(round(stib$pe, digits =1), nsmall=1, trim=TRUE)

##Making labels for plots
labels1_2 <- c(glue("PCo Axis 1 ({stib[1,3]}%)"),
               glue("PCo Axis 2 ({stib[2,3]}%)"))
labels1_3 <-c(glue("PCo Axis 1 ({stib[1,3]}%)"),
              glue("PCo Axis 3 ({stib[3,3]}%)"))
labels2_3 <-c(glue("PCo Axis 2 ({stib[2,3]}%)"),
              glue("PCo Axis 3 ({stib[3,3]}%)"))

##Plot for PCo1 and PCo2
Pcoa1_2<-ggplot(positions2, aes(x=pcoa1, y=pcoa2, shape=sample_ID_simplified, color=sample_ID_simplified)) + geom_point(size=2.5) + labs(x=labels1_2[1], y=labels1_2[2])+ scale_color_manual(values=c("Aquatica_species"="#cd0000", "Bass Lake"="#ff0000","Clearwater River"="orange",  "Dahler Lake"="yellow3","Decker Lake"="yellow","Garfield Lake"="green3","Mud Hen Lake" ="green","Necktie River" ="blue4", "Ottertail River"="blue", "Phantom Lake"="violetred3","Plantagenet"="violet","Shell Lake"="purple4","Upper Rice Lake"="purple","Breeding line"="grey"), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))+ scale_shape_manual(values = c(`Aquatica_species` = 17,`Bass Lake` = 16,`Clearwater River` = 15,`Dahler Lake` = 16,`Decker Lake` = 16,`Garfield Lake` = 16,`Mud Hen Lake` = 18,`Necktie River` = 16,`Ottertail River` = 15,`Phantom Lake` = 18,`Plantagenet` = 16,`Shell Lake` = 16,`Upper Rice Lake` = 15,`Breeding line` = 16 ), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))+theme(panel.background=element_rect(fill="white"), axis.line = element_line(), legend.title=element_blank(), legend.key=element_rect(fill=NA), legend.text=element_text(size=10))

##Plot for PCo1 and PCo3
Pcoa1_3<-ggplot(positions2, aes(x=pcoa1, y=pcoa3, shape=sample_ID_simplified, color=sample_ID_simplified)) + geom_point(size=2.5) + labs(x=labels1_3[1], y=labels1_3[2])+ scale_color_manual(values=c("Aquatica_species"="#cd0000", "Bass Lake"="#ff0000","Clearwater River"="orange",  "Dahler Lake"="yellow3","Decker Lake"="yellow","Garfield Lake"="green3","Mud Hen Lake" ="green","Necktie River" ="blue4", "Ottertail River"="blue", "Phantom Lake"="violetred3","Plantagenet"="violet","Shell Lake"="purple4","Upper Rice Lake"="purple","Breeding line"="grey"), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))+ scale_shape_manual(values = c(`Aquatica_species` = 17,`Bass Lake` = 16,`Clearwater River` = 15,`Dahler Lake` = 16,`Decker Lake` = 16,`Garfield Lake` = 16,`Mud Hen Lake` = 18,`Necktie River` = 16,`Ottertail River` = 15,`Phantom Lake` = 18,`Plantagenet` = 16,`Shell Lake` = 16,`Upper Rice Lake` = 15,`Breeding line` = 16 ), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))+theme(panel.background=element_rect(fill="white"), axis.line = element_line(), legend.title=element_blank(), legend.key=element_rect(fill=NA), legend.text=element_text(size=10))


#Temporal PCoA 
##Setting up data into a tibble and merging it with the sample key to get group data
positionst <- tPCOA$points
colnames(positionst) <- c("pcoa1", "pcoa2", "pcoa3","pcoa4")
positionst<-as_tibble(positionst, rownames = "sample_number")
positionst2 <-merge(Tsamp, positionst, by = "sample_number")
shortt<-tPCOA$eig[1:20]
stibt<-as_tibble(shortt)
row.names(stibt)<-names
stibt$pe<-stibt$value/sum(stibt$value) * 100
stibt$pe <- format(round(stibt$pe, digits =1), nsmall=1, trim=TRUE)

##Making labels for plots
labelst1_2 <- c(glue("PCo Axis 1 ({stibt[1,2]}%)"),
                glue("PCo Axis 2 ({stibt[2,2]}%)"))

##Temporal plot for PCo1 an PCo2
tpcoaplot<-ggplot(positionst2, aes(x=pcoa1, y=pcoa2, shape=sample_ID_simplified, color=sample_ID_simplified)) + geom_point(size=2.5, pch=16) + labs(x=labelst1_2[1], y=labelst1_2[2])+ scale_color_manual(values=c("Garfield Lake"="green3","Garfield Lake Old"="khaki3","Shell Lake"="violet","Shell Lake Old"="purple4"), labels=c("Garfield Lake 2018","Garfield Lake 2010","Shell Lake 2018","Shell Lake 2010"))+theme(panel.background=element_rect(fill="white"), axis.line = element_line(), legend.title=element_blank(), legend.key=element_rect(fill=NA), legend.position="right" , legend.text=element_text(size=10))


#Natural stand PCoA
##Setting up data into a tibble and merging it with the sample key to get group data
positionsn <- nPCOA$points
colnames(positionsn) <- c("pcoa1", "pcoa2", "pcoa3","pcoa4")
positionsn<-as_tibble(positionsn, rownames = "samples")
positionsn2 <-merge(sampn, positionsn, by = "samples")
shortn<-nPCOA$eig[1:20]
stibn<-as_tibble(shortn)
row.names(stibn)<-names
stibn$pe<-stibn$value/sum(stibn$value) * 100
stibn$pe <- format(round(stibn$pe, digits =1), nsmall=1, trim=TRUE)

##Making labels for plots
labelsn1_2 <- c(glue("PCo Axis 1 ({stibn[1,2]}%)"),
                glue("PCo Axis 2 ({stibn[2,2]}%)"))

##Natural stand plot for PCo1 and PCo2
npcoaplot<-ggplot(positionsn2, aes(x=pcoa1, y=pcoa2, shape=sample_ID_simplified, color=sample_ID_simplified)) + geom_point(size=2) + labs(x=labelsn1_2[1], y=labelsn1_2[2])+ scale_color_manual(values=c("Aquatica_species"="#cd0000", "Bass Lake"="#ff0000","Clearwater River"="orange",  "Dahler Lake"="yellow3","Decker Lake"="yellow","Garfield Lake"="green3","Mud Hen Lake" ="green","Necktie River" ="blue4", "Ottertail River"="blue", "Phantom Lake"="violetred3","Plantagenet"="violet","Shell Lake"="purple4","Upper Rice Lake"="purple"), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake"))+ scale_shape_manual(values = c(`Aquatica_species` = 17,`Bass Lake` = 16,`Clearwater River` = 15,`Dahler Lake` = 16,`Decker Lake` = 16,`Garfield Lake` = 16,`Mud Hen Lake` = 18,`Necktie River` = 16,`Ottertail River` = 15,`Phantom Lake` = 18,`Plantagenet` = 16,`Shell Lake` = 16,`Upper Rice Lake` = 15,`Breeding line` = 16 ), labels=c( expression(paste(italic("Z.aquatica"))), "Bass Lake","Clearwater River","Dahler Lake","Decker Lake","Garfield Lake","Mud Hen Lake","Necktie River", "Ottertail River","Phantom Lake","Plantagenet","Shell Lake","Upper Rice Lake","Breeding line"))+theme(panel.background=element_rect(fill="white"), axis.line = element_line(), legend.position="none")
plotgrob <- ggplotGrob(npcoaplot)

##Building natural stand legend
leg1grob<-grid.legend(labels=c(expression(italic("Z. aquatica")), "Bass Lake", "Dahler Lake", "Decker Lake", "Garfield Lake",
                               "Necktie River", "Plantagenet", "Shell Lake"), pch= c(17, 16, 16, 16, 16, 16, 16, 16), gp=gpar(col=c("red3", "red", "yellow3", "yellow", "green3", "blue4", "violet", "purple4"), fontsize=10), byrow=TRUE, draw=TRUE)
leg2grob<-grid.legend(labels=c("Clearwater River", "Ottertail River", "Upper Rice Lake"), pch= 15, gp=gpar(col=c("orange", "blue", "purple"), fontsize=10), byrow=TRUE, draw=TRUE)

leg3grob<-grid.legend(labels=c("Mud Hen Lake", "Phantom Lake"), pch= 18, gp=gpar(col=c("green3", "violetred3"), fontsize=10), byrow=TRUE, draw=TRUE)
plotlist<-list(leg1grob, leg2grob ,leg3grob)
comblegnat<-plot_grid(plotlist=plotlist, labels=c("Upper Mississippi River","Red River of the North", "St. Croix River"),align = 'h',rel_heights=c(2,1,0.75), ncol=1, axis='l', hjust=0, label_x=0.20, label_size=11)
grid.draw(comblegnat)

##Combining plot and legend
nat2<-list(plotgrob, comblegnat)
npcoaplot2<-grid.arrange(plotgrob, comblegnat, ncol=2, widths=c(2,0.75))

#Cultivated PCoA
##Setting up data into a tibble and merging it with the sample key to get group data
positionsc <- cPCOA$points
colnames(positionsc) <- c("pcoa1", "pcoa2", "pcoa3","pcoa4")
positionsc<-as_tibble(positionsc, rownames = "samples")
positionsc2 <-merge(sampc, positionsc, by = "samples")
shortc<-cPCOA$eig[1:20]
stibc<-as_tibble(shortc)
row.names(stibc)<-names
stibc$pe<-stibc$value/sum(stibc$value) * 100
stibc$pe <- format(round(stibc$pe, digits =1), nsmall=1, trim=TRUE)

##Making labels for plots
labelsc1_2 <- c(glue("PCo Axis 1 ({stibc[1,2]}%)"),
                glue("PCo Axis 2 ({stibc[2,2]}%)"))

##Structuring samples into family type classes
Barron<-c("Barron")
Barronk2<-c("VE/2*14WS/*4K2EF","VN/3*K2EF")
DwPM<-c("14S*PM3/PBM-C3")
K2DWBa<-c("KPVN-C4","KSVN-C4")
Dwarf<-c("14PD-C10","14S*PS","14S-PS")
FYC20<-c("FY-C20")
GP1<-c("GPB/K2B-C2")
GP2<-c("GPN-1.20","GPP-1.20")
GP3<-c("PLaR-C20")
ItascaC12<-c("Itasca-C12","Itasca Haploid")
ItascaC20<-c("Itasca-C20","PBML-C20")
K2<-c("K2B-C16","K2EFBP-C1","K2EF-C16")
PM3E<-c("PM3/3*PBM-C3","PM3E")
PM3EK2<-c("PM3/7*K2EF")
positionsc2$class2<- ifelse(positionsc2$sample_ID_simplified %in% Barron, "Barron",
                            ifelse(positionsc2$sample_ID_simplified %in% Barronk2, "Barron x K2",
                                   ifelse(positionsc2$sample_ID_simplified %in% DwPM, "Dwarf x PM3E",
                                          ifelse(positionsc2$sample_ID_simplified %in% K2DWBa, "K2 x Dwarf x Barron",
                                                 ifelse(positionsc2$sample_ID_simplified %in% Dwarf, "Dwarf",
                                                        ifelse(positionsc2$sample_ID_simplified %in% FYC20, "FY-C20",
                                                               ifelse(positionsc2$sample_ID_simplified %in% GP1, "GP-1",
                                                                      ifelse(positionsc2$sample_ID_simplified %in% GP2, "GP-2",
                                                                             ifelse(positionsc2$sample_ID_simplified %in% GP3, "GP-3",
                                                                                    ifelse(positionsc2$sample_ID_simplified %in% ItascaC12, "Itasca-C12",
                                                                                           ifelse(positionsc2$sample_ID_simplified %in% ItascaC20, "Itasca-C20",
                                                                                                  ifelse(positionsc2$sample_ID_simplified %in% K2, "K2",
                                                                                                         ifelse(positionsc2$sample_ID_simplified %in% PM3E, "PM3E",
                                                                                                                ifelse(positionsc2$sample_ID_simplified %in% PM3EK2, "PM3E x K2",""))))))))))))))
##Cultivated plot for PCo1 and PCo2
cpcoaplot<-ggplot(positionsc2, aes(x=pcoa1, y=pcoa2,color=class2)) + geom_point(size=2.5, shape=19) + labs(x=labelsc1_2[1], y=labelsc1_2[2])+ scale_color_manual(values=c("darkgoldenrod1","hotpink", "chocolate2", "blue4","cyan4","wheat4", "firebrick1","darksalmon","forestgreen", "darkviolet","violetred4","turquoise2","slategray4","lightgoldenrod1"))+theme(panel.background=element_rect(fill="white"), axis.line = element_line(), legend.title=element_blank(), legend.key=element_rect(fill=NA), legend.text=element_text(size=10))

#Combining all plots into one
lab1<-"A"
lab2<-"B"
lab3<-"C"
lab4<-"D"
row_heights <- unit(c(0.2, 1), c("null", "null"))
allplot<-grid.arrange(arrangeGrob(grobs = list(textGrob(lab1, x = 0.01, just = "left"),Pcoa1_2), heights = row_heights),arrangeGrob(grobs = list( textGrob(lab2, x = 0.01, just = "left"),npcoaplot2), heights = row_heights),arrangeGrob(grobs = list(textGrob(lab3, x = 0.01, just = "left"),cpcoaplot), heights = row_heights),arrangeGrob(grobs = list(textGrob(lab4, x = 0.01, just = "left"),tpcoaplot), heights = row_heights), ncol = 2)
grid.draw(allplot)
ggsave("231030_allplot.png", allplot, width =18, height=15)
ggsave("231030_allplot.tiff", allplot, width =18, height=15)
