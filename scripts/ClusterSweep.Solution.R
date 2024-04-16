#!/usr/bin/env Rscript
#SBATCH --nodes=1
#SBATCH --mincpus 16 
#SBATCH --mem=64G
#SBATCH --time=28:00:00
#SBATCH -o clusterSweep.%j.out
#SBATCH -e clusterSweep.%j.err
#SBATCH -J clusterSweep 

library(scater)
library(scran)
library(bluster)
library(BiocParallel)
library(tidyverse)
bpp <- BiocParallel::MulticoreParam(16)

# set the working directory to the Course_Materials directory
workingDir <- "/mnt/scratcha/bioinformatics/sawle01/Course_Materials"
setwd(workingDir)

# load the data
message("Load Data")
sce <- readRDS("R_objects/Caron_batch_corrected.all_cells.rds")

# run cluster sweep
message("Run ClusterSweep")
print(date())
out <- clusterSweep(reducedDim(sce, "corrected"), 
                       NNGraphParam(), 
                       k=as.integer(c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)),
                       cluster.fun=c("louvain", "walktrap", "leiden"),
                       BPPARAM=bpp)
print(date())


# save the cluster sweep results
saveRDS(out, "R_objects/clusterSweep.out.rds")

# add the clusters to the sce object and save that
colData(sce) <- cbind(colData(sce), DataFrame(out$clusters))
saveRDS(sce, "R_objects/clusterSweep.sce.rds")

# create a data frame with cluster behaviour metrics

message("Create metrics data frame")
df <- as.data.frame(out$parameters)

## add count of clusters
df$num.clusters <- apply(out$clusters, 2, max)

## add mean silhouette width
all.sil <- lapply(as.list(out$clusters), function(cluster) {
    sil <- approxSilhouette(reducedDim(sce, "corrected"), cluster)
    mean(sil$width)
})
df$silhouette <- unlist(all.sil)

## add sum of Within-cluser sum of squares
all.wcss <- lapply(as.list(out$clusters), function(cluster) {
  sum(clusterRMSD(reducedDim(sce, "corrected"), cluster, sum=TRUE), na.rm=TRUE)
})
df$wcss <- unlist(all.wcss)

# save the dataframe
write_tsv(df, "R_objects/clusterSweep.metrics_df.tsv")

message("Done")
print(date())

