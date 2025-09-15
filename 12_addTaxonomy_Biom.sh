#!/bin/bash
set -euo pipefail

# Fix taxonomy header for Phyloseq
if [ -f "exported/taxonomy.tsv" ]; then
  echo "Fixing taxonomy header for Phyloseq compatibility..."
  sed -i -e 's/Feature ID/#OTUID/g; s/Taxon/taxonomy/g; s/Confidence/confidence/g' exported/taxonomy.tsv
  echo "Taxonomy header fixed"
else
  echo "taxonomy.tsv not found!"
  exit 1
fi

# Add taxonomy to BIOM file
if [ -f "exported/feature-table.biom" ]; then
  echo "Adding taxonomy metadata to BIOM file..."
  biom add-metadata \
    -i exported/feature-table.biom \
    -o exported/table-with-taxonomy.biom \
    --observation-metadata-fp exported/taxonomy.tsv \
    --sc-separated taxonomy

  if [ -f "exported/table-with-taxonomy.biom" ]; then
    echo "BIOM file with taxonomy successfully generated: exported/table-with-taxonomy.biom"
  else
    echo "Failed to generate BIOM file with taxonomy"
    exit 1
  fi
else
  echo "feature-table.biom not found!"
  exit 1
fi

echo ""
echo "taxonomy formatted and added to BIOM file!"
