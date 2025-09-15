#!/bin/bash
set -euo pipefail

merged_dir="/home/dochebet/16S_dataset/QONT/merged"
out_dir="/home/dochebet/16S_dataset/QONT/qc_nanoplot"

mkdir -p "$out_dir"

echo ">>> Running NanoPlot QC on merged fastq files..."

NanoPlot --fastq "$merged_dir"/*.fastq.gz \
         --outdir "$out_dir" \
         --threads 4 \
         --plots hex dot

echo ">>> QC done. Results saved in $out_dir"

