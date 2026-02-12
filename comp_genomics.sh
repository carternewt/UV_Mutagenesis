#!/bin/bash
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=1:00:00
#SBATCH --mail-user=carter.newton@uga.edu
#SBATCH --mail-type=START,END,FAIL
#SBATCH --error=/work/lylab/cjn40747/UV_comp/logs/%j.err
#SBATCH --output=/work/lylab/cjn40747/UV_comp/logs/%j.out

ml ncbi-genome-download/0.3.3-GCCcore-12.3.0

OUT='/work/lylab/cjn40747/UV_comp'
HOME='/home/cjn40747/UV_Mutagenesis'

mkdir -p $OUT/orig_genome
ncbi-genome-download --assembly-accessions $HOME/accessions_ID.csv --output-folder $OUT/orig_genome -formats fasta bacteria
