library("ape")
load("genlight_all.Rdata")
load("genlight_temp.Rdata")

#All tree plot
alltree$tip.label<-as.character(gl.allvcf$pop)
png(filename = "alltreeplot_240212.png",  width = 25, height = 100, units = "cm", res = 300)
cols<-c("grey","grey","grey" ,"red3","grey","red","orange","yellow3","yellow","grey", "green3","grey","grey","grey","grey","grey","grey","grey","grey","grey", "green", "blue4", "blue","grey", "violetred3","violet","grey","grey","grey","grey","purple4", "purple","grey","grey")
plot.phylo(alltree,cex = 0.6, font = 2, adj = 0, tip.color=cols[pop(gl.allvcf)])
nodelabels(alltree$node.label, adj = c(1.3, -0.5), frame = "n", cex = 0.7,font = 3, xpd = TRUE)
axis(side = 1)
dev.off()

#Temp tree plot
temptree$tip.label<-as.character(gl.tempvcf$pop)
png(filename = "temptreeplot_240205.png",  width = 25, height = 75, units = "cm", res = 300)
cols<-c("green3", "burlywood", "purple4", "hotpink")
plot.phylo(temptree,cex = 0.7, font = 2, adj = 0, tip.color=cols[pop(gl.tempvcf)])
nodelabels(temptree$node.label, adj = c(1.3, -0.5), frame = "n", cex = 0.7,font = 3, xpd = TRUE)
axis(side = 1)
dev.off()
