library(dartR)
library(dartR.base)
library(phangorn)
library(adegenet)
library(poppr)
library(ape)
library(dplyr)
library(tidyr)
load("genlight_all.Rdata")

#Shorten sample names in genlight object
indNames(gl.allvcf)<- sub("/.*","" , indNames(gl.allvcf))
indNames(gl.allvcf)<- sub("_","" , indNames(gl.allvcf))

#Group cultivated samples
cultivated<-c("14PD-C10","14S*PM3/PBM-C3","14S*PS", "Barron", "FY-C20","GPB/K2B-C2","GPN-1.20", "GPP-1.20","Itasca-C12","K2B-C16","K2EFBP-C1","K2EF-C16","KPVN-C4","KSVN-C4","PBML-C20","PLaR-C20","PM3/3*PBM-C3","PM3/7*K2EF","PM3E","VE/2*14WS/*4K2EF","VN/3*K2EF")
currentpops<-pop(gl.allvcf)
newpops<-ifelse(currentpops %in% cultivated, "Cultivated", as.character(currentpops))
pop(gl.allvcf)<-as.factor(newpops)

#Calculate distance matrix
dist2<-bitwise.dist(gl.allvcf, mat=TRUE, scale_missing=TRUE, euclidean=FALSE)
dist2_df<-as.data.frame(dist2)
dist2_df$Population <-pop(gl.allvcf)

#Make data table of mean distance by populations
pop_dist2_df <- dist2_df %>%
  mutate(Individual1 = rownames(.)) %>%
  pivot_longer(cols = -c(Population, Individual1), names_to = "Individual2", values_to = "Distance") %>%
  left_join(data.frame(Individual2 = rownames(dist2_df), Population2 = pop(gl.allvcf)), by = "Individual2") %>%
  group_by(Population, Population2) %>%
  summarise(Average_Distance = mean(Distance, na.rm = TRUE), .groups = "drop")
# Make it into a matrix
pop_levels <- levels(pop(gl.allvcf))
pop_dist2_matrix <- matrix(0, nrow = length(pop_levels), ncol = length(pop_levels))
rownames(pop_dist2_matrix) <- colnames(pop_dist2_matrix) <- pop_levels
for (i in seq_len(nrow(pop_dist2_df))) {
  pop_dist2_matrix[pop_dist2_df$Population[i], pop_dist2_df$Population2[i]] <- pop_dist2_df$Average_Distance[i]
}
# Replace spaces in row and column names of the population distance matrix
rownames(pop_dist2_matrix) <- gsub(" ", "_", rownames(pop_dist2_matrix))
colnames(pop_dist2_matrix) <- gsub(" ", "_", colnames(pop_dist2_matrix))

#Export for splitstree
write.nexus.dist(as.dist(pop_dist2_matrix), file = "Population_distance_matrix.nex")
