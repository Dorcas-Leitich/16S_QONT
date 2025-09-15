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
**Script:** `01_nanoplot_qc.sh`  
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
**Script:** `02_QClengthTrim.sh`  
Filters out low-quality and too-short/too-long reads.
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
```
```
##Step03.Primer Trimming
**Script:** `03_PrimTrim.sh`
This script removes primer sequences and filters reads by length/quality using Trimmomatic.
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
```
```
##Step04.importing the quality checked and primertrimmed fastq files into qiime.
**Script:** `04importq.sh`
This script imports the primer-trimmed FASTQ files into QIIME2 and generates a summary visualization

#!/bin/bash
set -euo pipefail

in_dir="3_primerTrimmed"

echo "Looking for input files in $in_dir ..."
if [ -d "$in_dir" ]; then
    echo "Using '$in_dir' folder to import single-end reads ..."
    qiime tools import \
        --type 'SampleData[SequencesWithQuality]' \
        --input-path "$in_dir" \
        --input-format CasavaOneEightSingleLanePerSampleDirFmt \
        --output-path 4_single-end-demux.qza
else
    echo "Input directory not found: $in_dir"
    exit 1
fi

if [ -f "4_single-end-demux.qza" ]; then
    qiime demux summarize \
        --i-data 4_single-end-demux.qza \
        --o-visualization 4_single-end-demux.qzv
else
    echo "Reads failed to import!"
    exit 1
fi

echo "Import completed."
```
```
##Step05. Dereplication
**Script:** `05_derep.sh`
uses QIIME2’s vsearch dereplicate-sequences to remove redundancy in the dataset by collapsing identical sequences.
#!/bin/bash
set -euo pipefail

qiime vsearch dereplicate-sequences \
  --i-sequences 4_single-end-demux.qza \
  --o-dereplicated-table 5_derep-table.qza \
  --o-dereplicated-sequences 5_derep-seqs.qza
```
```
##Step06.summary visualization of dereplication outputs






  

