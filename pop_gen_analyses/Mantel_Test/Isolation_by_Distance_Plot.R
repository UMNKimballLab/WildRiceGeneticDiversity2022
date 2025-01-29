library(poppr)
library(adegenet)
library(dartR)
library(tidyverse)
library(geosphere)
library(data.table)
library(reshape2)
library(ggplot2)
load("genlight_mantel.Rdata")
Fst<-fread("Natfst_table.csv")

#Add a column with the calculation for FST/(1-FST)
Fst$FSTNorm<-Fst$Fst/(1-Fst$Fst)
data_table <- read.csv("Location_latANDlong.csv")

# Make geographic distance table from long and lat data
calculate_geodist <- function(data_table) {
  num_locations <- nrow(data_table)
  geodist_table <- data.frame(Pop1 = integer(), Pop2 = integer(), GeoDistance = numeric())
  
  for (i in 1:(num_locations - 1)) {
    for (j in (i + 1):num_locations) {  # Avoid duplicates (i.e., calculate for i < j)
      # Calculate the distance between coordinates i and j
      distance <- distm(
        c(data_table[i, "longitude"], data_table[i, "latitude"]),
        c(data_table[j, "longitude"], data_table[j, "latitude"]),
        fun = distHaversine
      ) / 1000  # Convert to kilometers
      
      # Add a row to the data frame
      geodist_table <- rbind(geodist_table, data.frame(Pop1 = i, Pop2 = j, GeoDistance = distance))
    }
  }
  
  return(geodist_table)
}

geodist_table<- calculate_geodist(data_table)
geodist_table$Pop1 <- data_table$Location[geodist_table$Pop1]
geodist_table$Pop2 <- data_table$Location[geodist_table$Pop2]
#Remove cultivated
geodist_table<- subset(
  geodist_table,
  !(Pop1 == "NCROC" | Pop2 == "NCROC")
)

mod<-lm(Fst ~ GeoDistance, data = na.omit(combined_table))
summary(mod)

#Make dot plot
plot<-ggplot(aes(x=GeoDistance, y=FSTNorm), data=combined_table)+ geom_point()+ scale_x_continuous(name="Geographic Distance")+scale_y_continuous(name="Fst/(1-Fst)", breaks=seq(0,0.2,0.05), limits=c(0,0.2))+geom_text(aes(x = 50, y = 0.18),size=8, label= "y = 0.06 + 0.0002x")+geom_text(aes(x = 50, y = 0.17),size=8, label= expression(italic("R")^"2" ~ " = 0.2982"))+ theme(panel.background=element_rect(fill="white"),panel.border = element_blank(), axis.line = element_line(),axis.text=element_text(size=19), axis.title.y=element_text(size=22,margin=margin(t = 0, r = 15, b = 0)),axis.title.x=element_text(size=22, margin=margin(t = 15, r = 0, b = 0)))+geom_smooth(method="lm", show.legend = TRUE, se=FALSE)
plot

ggsave("Isolation_By_Distance_250117.png", plot, width=12, height=10)
