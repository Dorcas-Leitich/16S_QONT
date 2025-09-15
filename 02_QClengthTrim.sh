#!/bin/bash
set -euo pipefail

threads=4
in_dir="/home/dochebet/16S_dataset/Q2_ONT/merged"
out_dir="/home/dochebet/16S_dataset/Q2_ONT/2_QC" 
mkdir -p "$out_dir"
cd "$in_dir"

for file in *.fastq.gz; do
    base=$(basename "$file" .fastq.gz)
    trimmomatic SE -threads $threads -phred33 \
        "$file" "$out_dir/${base}_trimmed.fastq.gz" MINLEN:700 CROP:1500
done

