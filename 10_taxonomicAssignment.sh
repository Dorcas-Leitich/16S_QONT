#!/bin/bash
set -euo pipefail

echo ""
echo "Assigning taxonomy..."
echo ""

# Input classifier and representative sequences
CLASSIFIER="ref/silva-138-99-nb-classifier.qza"
REP_SEQS="9_otu-cluster/rep-seqs-op_ref-85.qza"

# Output 
OUT_DIR="10_taxonomy"
THREADS=8   # adjust based on available CPUs
mkdir -p "${OUT_DIR}"

# Step 1: Assign taxonomy
qiime feature-classifier classify-sklearn \
  --i-classifier "${CLASSIFIER}" \
  --i-reads "${REP_SEQS}" \
  --p-reads-per-batch 5000 \
  --p-n-jobs "${THREADS}" \
  --o-classification "${OUT_DIR}/taxonomy-sklearn.qza"

# Check if output file was created
if [ -f "${OUT_DIR}/taxonomy-sklearn.qza" ]; then
  echo "Taxonomy successfully assigned"
else 
  echo "Taxonomy FAILED!"
  exit 1
fi
