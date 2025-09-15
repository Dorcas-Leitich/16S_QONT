# 16S_QONT
Pipeline for processing 16S rRNA Nanopore sequencing data using QIIME2.
```
##Step0. merging the fastq files
**Script:** `00_merge.sh`  
Merges all `.fastq.gz` files from each `barcode*` directory into one per barcode.  
Output files are saved in `QONT/merged/`
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
```

```
##Step01 quality check by nanoplot qc
Runs NanoPlot to generate QC reports of the raw Nanopore reads
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
```
```
##Step02. Quality and length trimming
Filters out low-quality and too-short/too-long reads.


