#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --reservation=chilam01_101 # reservation only applicable to this course
#SBATCH -o CR_mkref.%j.out
#SBATCH -e CR_mkref.%j.err
#SBATCH -J CR_mkref

export PATH=/mnt/scratcha/bioinformatics/chilam01/Bitesize_SingleCell_2024/software/cellranger-7.2.0/bin:${PATH}

cellranger mkref --genome=GRCh38_custom_10X \
                 --fasta=references/combined.fa \
                 --genes=references/combined.gtf \
                 --memgb=32 \
                 --nthreads=8
