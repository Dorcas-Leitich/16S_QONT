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

