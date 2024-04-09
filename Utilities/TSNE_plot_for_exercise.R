library(scater)

sce <- readRDS("R_objects/Caron_batch_corrected.all_cells.rds")

plotReducedDim(sce, dimred="TSNE_corrected") +
  geom_point(aes(x=X, y=Y), fill="#5161E0", shape=21)
ggsave("Clustering_Exercise_TSNE.png", width=7, height=7)


plotReducedDim(sce, dimred="TSNE_corrected", colour_by="CD3D") 

plotReducedDim(sce, dimred="UMAP_corrected") +
  geom_point(aes(x=X, y=Y), fill="#5161E0", shape=21)
ggsave("Clustering_Exercise_UMAP.png", width=7, height=7)

plotReducedDim(sce, dimred="UMAP_corrected", colour_by="CD3D") 
