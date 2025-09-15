#!/bin/bash
set -euo pipefail

echo ""
echo "OTU clustering at 85%"

OUT_DIR="9_otu-cluster"
mkdir -p $OUT_DIR

qiime vsearch cluster-features-de-novo \
  --i-table 7_chimera-ref-out/table-nonchimeric.qza \
  --i-sequences 7_chimera-ref-out/rep-seqs-nonchimeric.qza \
  --p-perc-identity 0.85 \
  --p-threads 8 \
  --o-clustered-table $OUT_DIR/table-op_ref-85.qza \
  --o-clustered-sequences $OUT_DIR/rep-seqs-op_ref-85.qza

