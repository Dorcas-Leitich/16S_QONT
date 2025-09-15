#!/bin/bash
set -euo pipefail 

# Input files
DEREP_TABLE="5_derep-table.qza"
DEREP_SEQS="5_derep-seqs.qza"
REFERENCE_SEQS="ref/silva-138-99-seqs.qza"    
THREADS=8

# Output directory
OUT_DIR="7_chimera-ref-out"

echo ""
echo "" 
echo "  Screening for chimeric sequences"  

qiime vsearch uchime-ref \
  --i-table $DEREP_TABLE \
  --i-sequences $DEREP_SEQS \
  --i-reference-sequences $REFERENCE_SEQS \
  --p-threads $THREADS \
  --output-dir $OUT_DIR

if [ -d "$OUT_DIR" ]; then
  echo ""
  echo "Chimeric sequences detected and mapped!" 
  echo ""
  echo "" 
  echo " Visualizing chimera statistics"  

  qiime metadata tabulate \
    --m-input-file $OUT_DIR/stats.qza \
    --o-visualization $OUT_DIR/stats.qzv

  echo ""
  echo "Chimera screening complete!" 
  echo "   Results saved in: $OUT_DIR"
else
  echo ""
  echo " FAILED to detect or map chimeric sequences!" 
  exit 1
fi

