#!/bin/bash
set -euo pipefail

basedir="/home/dochebet/16S_dataset"
outdir="$basedir/QONT/merged"
mkdir -p "$outdir"

cd "$basedir"

for d in barcode*; do
    [ -d "$d" ] || continue
    outfile="$outdir/${d}_merged.fastq.gz"
    cat "$d"/*.fastq.gz > "$outfile"
    echo "merged $d -> $(basename "$outfile")"
done

echo "all barcodes merged into $outdir"

