# 1. List the R packages required

## a) clone scRNAseq course git hub repo

```
git clone git@github.com:bioinformatics-core-shared-training/Bitesize_SingleCell_2024.git
```

## b) A get a list of required R packages

```
cat `find Bitesize_SingleCell_2024/ -regex .*Rmd` | 
    grep "library(" | 
    sort | 
    uniq | 
    sed -e 's/library(//' -e 's/)//' > list_of_rpackages
```

# 2. Build Singularity

Singularity recipe:
--> Singularity.def

```
sudo singularity build --force rstudio_scRNAseq_2024.sif Singularity.def
```
--> rstudio_scRNAseq_2024.sif

# 3. Shell and check R packages installed

```
singularity shell rstudio_scRNAseq_2024.sif
Rscript --vanilla rCheckPackages.R
```

