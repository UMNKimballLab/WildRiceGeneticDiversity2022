#Shape files can be downloaded from https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
library(sf)
library(sp)
library(ggplot2)
library(raster)
library(ggspatial)
library(grid)
library(gridExtra)
library(cowplot)
library(magick)

#Read in data
#You must have both the shape file (.shp) and (.shx) in the source folder

##Watershed shape files for figure 1
MNwat<-st_read("G:/My Drive/Kimball lab/Projects/Genetic Diversity/Figure1_map/MN_HUC4_WGS84_UTM15.shp")
WIwat<-st_read("G:/My Drive/Kimball lab/Projects/Genetic Diversity/Figure1_map/WI_HUC4_WGS84_UTM15.shp")
combwat<-st_union(MNwat, WIwat)

##County map shapefile for figure S1
States<-st_read("G:/My Drive/Kimball lab/Projects/Genetic Diversity/Figure1_map/cb_2018_us_county_500k.shp")
MN<-subset(States, STATEFP == "27")
WI<-subset(States, STATEFP =="55")

###Separate counties to highlight 
highlight<-c("Lake of the Woods","Beltrami","Koochiching","Pennington", "Red Lake", "Polk","Clearwater","Itasca", "Aitkin", "Crow Wing")
high<-subset(MN, subset = NAME %in% highlight)
combcount<-st_union(MN[10],WI[10])

##Read in Sample information
co<-read.csv("200224_wild_rice_samples.csv")

#Make custom legend 
ncgrob<- grid.legend(labels=c("NCROC"), pch=8, gp=gpar(col=c("black"), fontsize=11.5),byrow=TRUE, draw=TRUE)
leg1grob<-grid.legend(labels=c(expression(italic("Z. aquatica")), "Bass Lake", "Dahler Lake", "Decker Lake", "Garfield Lake",
                   "Necktie River", "Plantagenet", "Shell Lake"), pch= c(17, 16, 16, 16, 16, 16, 16, 16), gp=gpar(col=c("red3", "red", "yellow3", "yellow", "green3", "blue4", "violet", "purple4"), fontsize=11.5), byrow=TRUE, draw=TRUE)

leg2grob<-grid.legend(labels=c("Clearwater River", "Ottertail River", "Upper Rice Lake"), pch= 15, gp=gpar(col=c("orange", "blue", "purple"), fontsize=11.5), byrow=TRUE, draw=TRUE)

leg3grob<-grid.legend(labels=c("Mud Hen Lake", "Phantom Lake"), pch= 18, gp=gpar(col=c("green3", "violetred3"), fontsize=11.5), byrow=TRUE, draw=TRUE)

plotlist<-list(ncgrob, leg1grob, leg2grob ,leg3grob)
comblegnat<-plot_grid(plotlist=plotlist, labels=c(NA,"Upper Mississippi River","Red River of the North", "St. Croix River"),align = 'h',rel_heights=c(0.3,2.4,1,0.7), ncol=1, axis='lt', hjust=0.1, label_x=0.20, label_size=12)+theme(panel.background=element_rect(fill=alpha("white", 0.8), colour = "gray"), plot.margin=margin(0,0,0,0))
ggsave("legend.png", comblegnat, width=4, height=6)

#Making the base of figure 1
fig1<-ggplot(data=combwat)+geom_sf(fill=NA)+geom_point(data=co, size=3, aes(x=UTM_easting, y=UTM_northing, color=Location, shape=Location))+scale_color_manual(values=c("Aquatica_species"="#cd0000", "Bass Lake"="#ff0000","Clearwater River"="orange",  "Dahler Lake"="yellow3","Decker Lake"="yellow","Garfield Lake"="green3","Mud Hen Lake" ="green","Necktie River" ="blue4", "Ottertail River"="blue", "Phantom Lake"="violetred3","Plantagenet"="violet","Shell Lake"="purple4","Upper Rice Lake"="purple","NCROC"="black"))+scale_shape_manual(values=c(`Aquatica_species` = 17,`Bass Lake` = 16,`Clearwater River` = 15,`Dahler Lake` = 16,`Decker Lake` = 16,`Garfield Lake` = 16,`Mud Hen Lake` = 18,`Necktie River` = 16,`Ottertail River` = 15,`Phantom Lake` = 18,`Plantagenet` = 16,`Shell Lake` = 16,`Upper Rice Lake` = 15,`NCROC` = 8 ))+theme(panel.background=element_rect(fill="white"), axis.line = element_blank(), axis.text=element_blank(), axis.title=element_blank(), legend.position="none", axis.ticks=element_blank())+annotation_scale()
fig1
ggsave("231115_Figure1base.png", fig1, height=10, width=8)

#Combining the legend and base of figure 1
legend_file <- file.path("G:/My Drive/Kimball lab/Projects/Genetic Diversity/Figure1_map/legend.png")
combfig1<-ggdraw(fig1)+ draw_image(legend_file, scale=0.5, x=0.85,y=-0.2, hjust=1, halign=1)
ggsave("231120_fig1.png", combfig1, height=10, width=10)

#Making the base of figure S1
figs1<-ggplot(combcount)+geom_sf(fill=NA)+geom_sf(data=high[10], fill="aquamarine3")+geom_point(data=co,size=3, aes(x=Long, y=Lat, color=Location, shape=Location))+scale_color_manual(values=c("Aquatica_species"="#cd0000", "Bass Lake"="#ff0000","Clearwater River"="orange",  "Dahler Lake"="yellow3","Decker Lake"="yellow","Garfield Lake"="green3","Mud Hen Lake" ="green","Necktie River" ="blue4", "Ottertail River"="blue", "Phantom Lake"="violetred3","Plantagenet"="violet","Shell Lake"="purple4","Upper Rice Lake"="purple","NCROC"="black"))+scale_shape_manual(values=c(`Aquatica_species` = 17,`Bass Lake` = 16,`Clearwater River` = 15,`Dahler Lake` = 16,`Decker Lake` = 16,`Garfield Lake` = 16,`Mud Hen Lake` = 18,`Necktie River` = 16,`Ottertail River` = 15,`Phantom Lake` = 18,`Plantagenet` = 16,`Shell Lake` = 16,`Upper Rice Lake` = 15,`NCROC` = 8 ))+theme(panel.background=element_rect(fill="white"), axis.line = element_blank(), legend.position="none", axis.text=element_blank(), axis.title=element_blank(), axis.ticks=element_blank())+annotation_scale()
figs1
ggsave("231115_FigureS1base.png", figs1, height=12, width=8)

#Combining the legend with the base of figure S1
legend_file <- file.path("legend.png")
combfigs1<-ggdraw(figs1)+ draw_image(legend_file, scale=0.5, x=0.85,y=-0.2, hjust=1, halign=1)
ggsave("231128_figs1.png", combfigs1, height=10, width=10)
