library("data.table")
library("knitr")
library("agricolae")
library("plyr")
library("dplyr")
library("ggplot2")
library("markdown")
library("cowplot")
load("220420_nucleotide_diversity_data.Rdata")
combined -> nucleotideDiv
load("220622_Fst_genome-wide_plot_cultivated_vs_natural_stands.Rdata")
x -> Fst
load("220420_XP-CLR_plotting_data.Rdata")

#Checking to see the range of POS values per chromosome/class
Snuc<- ddply(nucleotideDiv, c("CHROM", "CLASS"), summarise,
             N = length(PI),
            mean= mean(PI),
            minpos= min(POS),
            maxpos= max(POS),
            midpos= mean(POS))
Snuc

#subsetting data by class, then binning and averaging, then recombining data into one frame
natnuc<-subset(nucleotideDiv, CLASS == "natural stands")
cultnuc<-subset(nucleotideDiv, CLASS == "cultivated")
avnat<- natnuc %>%
  group_by(POS=cut(POS, breaks =seq(0, 12.2, 0.1))) %>%
  summarise(PI = mean(PI))
avnat
avcult<- cultnuc %>%
  group_by(POS=cut(POS, breaks =seq(0, 12.2, 0.1))) %>%
  summarise(PI = mean(PI))
avcult
avnat$CLASS<-"Wild NWR"
avcult$CLASS<-"Cultivated NWR"
newnuc<-merge(avnat, avcult, all=TRUE)

#Binned Nucleotide diversity plot, chromosome names placed at midpoint calculated in the summary
nucplot<-ggplot(data=newnuc, aes(x=POS,  y=PI, color=CLASS, group=1))+geom_point()+geom_line()+scale_y_continuous(name="Average Nucleotide Diversity (PI)", breaks= seq(0,0.5, 0.1), limits=c(0,0.5))+scale_color_manual(values=c("maroon","blue3"))+scale_x_discrete(name="Chromosome",breaks=c("(0.4,0.5]","(1.4,1.5]","(2.2,2.3]","(3,3.1]","(3.8,3.9]","(4.8,4.9]","(5.5,5.6]","(6.2,6.3]","(7,7.1]","(8,8.1]","(8.9,9]","(9.7,9.8]","(10.8,10.9]","(11.5,11.6]","(11.7,11.8]","(12,12.1]","(12.1,12.2]"), labels=unique(nucleotideDiv$CHROM))+theme( text=element_text(family='serif'), axis.text.x=element_text(angle=45, vjust=1, hjust=1),axis.title.x=element_text(size=16, margin=margin(t = 15, r = 0, b = 0)), axis.title.y=element_text(size=18,margin=margin(t = 0, r = 15, b = 0)), axis.text=element_text(size=12),panel.background=element_rect(fill="white"),legend.text=element_text(size=14),legend.title=element_blank(), legend.position = "none",panel.border = element_blank(), axis.line = element_line())
nucplot
ggsave("221128_nucdivplot.png", nucplot, width=15, height=8)

#Summarizing to find midpoints then plotting fst and using midpoints as location for chromosome names
Sfst<- ddply(Fst, c("CHROM"), summarise,
            midpos= mean(POS_new))
Sfst

fstplot<-ggplot(data=Fst, aes(x=POS_new,y=WEIR_AND_COCKERHAM_FST))+geom_point(color=Fst$COL)+scale_x_continuous(name="Chromosome", breaks=Sfst$midpos, labels=Sfst$CHROM, expand=c(0.01,0.01))+scale_y_continuous(name="Weir and Cockerham Fst", breaks=seq(0,0.7,0.1), limits=c(-0.01,0.7), expand=c(0,0))+theme( text=element_text(family='serif'), axis.text.x=element_text(angle=45, vjust=1, hjust=1),axis.title.x=element_text(size=16, margin=margin(t = 15, r = 0, b = 0)), axis.title.y=element_text(size=18,margin=margin(t = 0, r = 15, b = 0)), axis.text=element_text(size=12),panel.background=element_rect(fill="white"),legend.text=element_text(size=14),legend.title=element_blank(),panel.border = element_blank(), axis.line = element_line())
fstplot
ggsave("221128_fstplot.png", fstplot, width=15, height=7)

#Summarizing to find midpoints then plotting xpclr and using midpoints as location for chromosome names
Sxpclr<- ddply(combined, c("chr_num"), summarise,
            midpos= mean(genetic_pos))
Sxpclr
xpclrplot<-ggplot(data=combined, aes(x=genetic_pos,y=XPCLR_score))+geom_point(color=combined$col)+scale_x_continuous(name="Chromosome", breaks=Sxpclr$midpos, labels=Sfst$CHROM, expand=c(0.01,0.01))+scale_y_continuous(name="XP-CLR Score", breaks=seq(0,100,20), limits=c(-0.01,100), expand=c(0,0))+theme( text=element_text(family='serif'), axis.text.x=element_text(angle=45, vjust=1, hjust=1),axis.title.x=element_text(size=16, margin=margin(t = 15, r = 0, b = 0)), axis.title.y=element_text(size=18,margin=margin(t = 0, r = 15, b = 0)), axis.text=element_text(size=12),panel.background=element_rect(fill="white"),legend.text=element_text(size=14),legend.title=element_blank(),panel.border = element_blank(), axis.line = element_line())
xpclrplot
ggsave("221128_xpclrplot.png", xpclrplot, width=15, height=7)

#Combined figure
plotlist<-list(nucplot, fstplot,xpclrplot)
combplot<-plot_grid(plotlist=plotlist, align=c("v"), nrow=3)
ggsave("221125_figure5.png", combplot, width=18, height=15)
ggsave("221125_figure5.tiff", combplot, width=18, height=15)
