#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mincpus 16 
#SBATCH --mem=64G
#SBATCH --time=28:00:00
#SBATCH -o clusterSweep_%j.out
#SBATCH -e clusterSweep_%j.err
#SBATCH -J clusterSweep 
#SBATCH --reservation=chilam01_101

singularity exec \
  --bind ${PWD} \
  /home/software/images/rstudio-server/rstudio_scRNAseq_4.3.3.sif \
  "./scripts/ClusterSweep.Ash.R"
