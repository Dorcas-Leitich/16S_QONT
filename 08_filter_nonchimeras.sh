#!/bin/bash
set -euo pipefail

# Filtering out chimeric sequences and features
echo ""
echo "Filtering chimeric sequences..."

qiime feature-table filter-features \
  --i-table 5_derep-table.qza \
  --m-metadata-file 7_chimera-ref-out/nonchimeras.qza \
  --o-filtered-table 7_chimera-ref-out/table-nonchimeric.qza

qiime feature-table filter-seqs \
  --i-data 5_derep-seqs.qza \
  --m-metadata-file 7_chimera-ref-out/nonchimeras.qza \
  --o-filtered-data 7_chimera-ref-out/rep-seqs-nonchimeric.qza

if [ -f "7_chimera-ref-out/rep-seqs-nonchimeric.qza" ]; then
  echo "Chimeric sequences successfully filtered!" 
  echo ""
  echo "Visualizing non-chimeric data..."

  qiime feature-table summarize \
    --i-table 7_chimera-ref-out/table-nonchimeric.qza \
    --o-visualization 7_chimera-ref-out/table-nonchimeric.qzv
else
  echo "FAILED to filter out chimeric sequences!" 
fi

