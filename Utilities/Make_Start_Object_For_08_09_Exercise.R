#!/usr/bin/env Rscript

# This script starts with the full filtered object from the main scRNAseq course
# materials. It subsets it to just a 7 samples and filters out genes with less
# than 50 total counts. It then normalises, runs dimension reduction and then
# batch correction.

library(scater)
library(scran)
library(batchelor)
library(bluster)
library(magrittr)
library(BiocParallel)

bpp <- MulticoreParam(16)

set.seed(1704)

merge_order <- list(
          list("ETV6-RUNX1_1", "ETV6-RUNX1_2", "ETV6-RUNX1_3", "ETV6-RUNX1_4"),
          list("PBMMC_1", "PBMMC_2", "PBMMC_3"))

sce_all <- readRDS("R_objects/Caron_filtered.full.rds")
sce <- sce_all[,colData(sce_all)$SampleName%in%unlist(merge_order)]

# Filter out lowly expressed genes
sce <- sce[rowSums(counts(sce)) > 50, ]

sce
message("Normalise")

# cluster cells
set.seed(100) 
clust <- quickCluster(sce) 

# calculate size factors 
sce <- computePooledFactors(sce, cluster=clust, min.mean=0.1)

# log Normalize the Counts
sce <- logNormCounts(sce)

# save normalised object
saveRDS(sce, "R_objects/Caron_normalized.all_cells.rds")

# use common gene names instead of Ensembl gene IDs
rownames(sce) <- uniquifyFeatureNames(rownames(sce), rowData(sce)$Symbol)

# Identify highly variable genes
gene_var <- modelGeneVar(sce)
hvgs <- getTopHVGs(gene_var, prop=0.1)

# PCA 
sce <- runPCA(sce, subset_row = hvgs)

# tSNE
sce <- runTSNE(sce, dimred="PCA", n_dimred=10, BPPARAM = bpp)

# UMAP

sce <- runUMAP(sce, dimred="PCA", n_dimred=10, BPPARAM = bpp)

# save object

saveRDS(sce, "R_objects/Caron_dimRed.all_cells.rds")


# Reduced dims

sce_corrected <- quickCorrect(sce,
                                  batch = sce$SampleName,
                                  PARAM = FastMnnParam(merge.order = merge_order)
                                  )$corrected

# add the corrected matrix to the original object - to keep it all together
reducedDim(sce, "corrected") <- reducedDim(sce_corrected, "corrected")

#  add a tSNE using the corrected data
set.seed(323)
sce <- runTSNE(sce, 
                   dimred = "corrected",
                   name = "TSNE_corrected")


sce <- runUMAP(sce, 
                   dimred = "corrected",
                   name = "UMAP_corrected")

# Save object

saveRDS(sce, "R_objects/Caron_batch_corrected.all_cells.rds")
