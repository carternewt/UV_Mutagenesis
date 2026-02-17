#!/bin/bash
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=carter.newton@uga.edu
#SBATCH --mail-type=START,END,FAIL
#SBATCH --error=/work/lylab/cjn40747/UV_comp/logs/%j.err
#SBATCH --output=/work/lylab/cjn40747/UV_comp/logs/%j.out

ml ncbi-genome-download/0.3.3-GCCcore-12.3.0
ml bakta/1.11
ml QUAST/5.2.0
ml CheckM/1.2.2-foss-2022a

OUT='/work/lylab/cjn40747/UV_comp'
HOME='/home/cjn40747/UV_Mutagenesis'
ACCESSIONS=$(paste -sd, $HOME/accessions_ID.txt)

mkdir -p $OUT/orig_genome
ncbi-genome-download --section refseq --assembly-accessions $ACCESSIONS --output-folder $OUT/orig_genome --formats fasta bacteria

mkdir -p $OUT/bakta
find $OUT/orig_genome/refseq/bacteria -name GCF*.gz -type f | while read -r file; do
    dir=$(dirname "$file")
    out_dir="$OUT/bakta/$(basename "$dir")"
    name=$(basename "$dir")
    mkdir -p $out_dir
    bakta --db $OUT/bakta/db --verbose --output $out_dir --prefix $name --genus Paenibacillus --threads 8 "$file" --force
done

mkdir -p $OUT/QC
mkdir -p $OUT/QC/genomes
find $OUT/orig_genome/refseq/bacteria -name GCF*.gz -type f | while read -r file; do
    out=$(basename "${file%.gz}")
    gunzip -c "$file" > $OUT/QC/genomes/$out
done

mkdir -p $OUT/QC/checkm
checkm lineage_wf -t 8 $OUT/QC/genomes $OUT/QC/checkm

find $OUT/orig_genome/refseq/bacteria -name GCF*.gz -type f | while read -r file; do
    dir=$(dirname "$file")
    out_dir="$OUT/QC/$(basename "$dir")"
    mkdir -p $out_dir
    quast -o $out_dir -b -t 8 "$file"
done