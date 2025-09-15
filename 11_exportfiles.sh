#!/bin/bash
set -euo pipefail

# Make export directory
mkdir -p exported

# Export OTU table
echo "Exporting OTU table (table-op_ref-85.qza) to biom..."
qiime tools export \
  --input-path 9_otu-cluster/table-op_ref-85.qza \
  --output-path exported/
if [ -f "exported/feature-table.biom" ]; then
  echo "Biom file successfully exported"
else
  echo "Biom file FAILED TO EXPORT"
fi

# Export taxonomy
echo ""
echo "Exporting taxonomy (taxonomy-sklearn.qza) to taxonomy.tsv..."
qiime tools export \
  --input-path 10_taxonomy/taxonomy-sklearn.qza \
  --output-path exported/
if [ -f "exported/taxonomy.tsv" ]; then
  echo "Taxonomy file successfully exported"
else
  echo "Taxonomy file FAILED TO EXPORT"
fi

# Export representative sequences
echo ""
echo "Exporting representative sequences (rep-seqs-op_ref-85.qza) to fasta..."
qiime tools export \
  --input-path 9_otu-cluster/rep-seqs-op_ref-85.qza \
  --output-path exported/
if [ -f "exported/dna-sequences.fasta" ]; then
  echo "Fasta file successfully exported"
else
  echo "Fasta file FAILED TO EXPORT"
fi

echo ""
echo " Export completed!"
