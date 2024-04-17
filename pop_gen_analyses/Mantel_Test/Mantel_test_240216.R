load("genlight_mantel.Rdata")
library(poppr)
library(adegenet)
library(dartR)
library(tidyverse)
library(geosphere)
library(data.table)

#Genetic distance matrix
genind<-gl2gi(gl.mantel)
inddist<-as.matrix(dist(genind))
genpop<-genind2genpop(genind)
gendist<-as.matrix(dist.genpop(genpop, method=5))
colorder<-c("Aquatica_species", "Bass Lake", "Clearwater River", "Dahler Lake", "Decker Lake","Garfield Lake", "Mud Hen Lake", "Necktie River", "Ottertail River", "Phantom Lake", "Plantagenet", "Shell Lake", "Upper Rice Lake","NCROC")
gendist<-gendist[colorder, colorder]

#Exclude 0s which are just comparing the same population to itself
gendist[gendist == 0] <- NA
write.csv(gendist,file="gen_dist_mat_240216.csv")
write.csv(inddist, file="ind_dist_240222.csv")

data_table <- read.csv("Location_latANDlong.csv")

# Function to calculate distance matrix
calculate_geodist <- function(data_table) {
  num_locations <- nrow(data_table)
  geodist <- matrix(NA, nrow = num_locations, ncol = num_locations)

  for (i in 1:num_locations) {
    for (j in 1:num_locations) {
      # Use distm() to calculate the distance between coordinates i and j
      geodist[i, j] <- distm(
        c(data_table[i, "longitude"], data_table[i, "latitude"]),
        c(data_table[j, "longitude"], data_table[j, "latitude"]), fun=distHaversine
      )/ 1000
    }
  }

  rownames(geodist) <- colnames(geodist) <- 1:num_locations
  return(geodist)
}

# Calculate the distance matrix
geodist <- calculate_geodist(data_table)
row.names(geodist)<-colorder
colnames(geodist)<-colorder
geodist[geodist == 0] <- NA

# Write to CSV file
write.csv(distance_matrix, file = "240220_geographical_distance_between_lakes.csv")

#Calculate mantel test
dgendist<-dist(gendist)
dgeodist<-dist(geodist)
mantel <- mantel.rtest(dgeodist, dgendist, nrepet = 1000)
summary(lm(dgendist ~ dgeodist))

#Histogram
pdf("240229_hist_for_mantel.pdf")
plot(mantel, xlab = "Simulated correlation", main = "Mantel test", las = 1)
dev.off()

#Combine data into one data frame for easier plotting
df<-data.frame(as.vector(geodist),as.vector(gendist))
colnames(df)<-c("geodist","gendist")

#Calculate a line based on the comparison of gendist and geodist
mod<-lm(gendist ~ geodist, data = na.omit(df))
summary(mod)

dotplot<-ggplot(data=na.omit(df),aes(geodist, gendist))+geom_point()+geom_smooth(method="lm", show.legend = TRUE, se=FALSE)+scale_x_continuous(breaks=seq(0,300,50), name="Geographic Distance (km)")+scale_y_continuous(breaks=seq(0,0.2, 0.01), name="Genetic Distance") +geom_text(aes(x = 50, y = 0.163),size=5, label= "y = 0.1 + 0.0002x")+geom_text(aes(x = 50, y = 0.160),size=5, label= expression(italic("R")^"2" ~ " = 0.4011"))+ theme(panel.background=element_rect(fill="white"),panel.border = element_blank(), axis.line = element_line(),axis.text=element_text(size=14), axis.title.y=element_text(size=16,margin=margin(t = 0, r = 15, b = 0)),axis.title.x=element_text(size=16, margin=margin(t = 15, r = 0, b = 0)))
dotplot

ggsave("Mantel_dotplot_240221.png", dotplot, width=12, height=10)
