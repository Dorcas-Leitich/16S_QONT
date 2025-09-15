#!/bin/bash
set -euo pipefail

threads=4
in_dir="/home/dochebet/16S_dataset/Q2_ONT/2_QC"        
out_dir="/home/dochebet/16S_dataset/Q2_ONT/3_primerTrimmed"
mkdir -p "$out_dir"
primers_fa="/home/dochebet/16S_dataset/Q2_ONT/adapters/primers.fa"
echo "primer trimming with Trimmomatic"
for file in "$in_dir"/*.fastq.gz; do
    base=$(basename "$file" .fastq.gz)
    echo "Processing $base"
        trimmomatic SE \
        -threads "$threads" \
        -phred33 \
        "$file" \
        "$out_dir/${base}_primerTrimmed_temp.fastq.gz" \
        ILLUMINACLIP:"$primers_fa":2:30:10 \
        MINLEN:700 \
        CROP:1500
mv "$out_dir/${base}_primerTrimmed_temp.fastq.gz" "$out_dir/${base}_primerTrimmed.fastq.gz"

    echo " Finished trimming $base"
done


