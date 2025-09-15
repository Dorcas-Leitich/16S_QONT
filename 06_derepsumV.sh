#!/bin/bash
set -euo pipefail

qiime feature-table summarize \
  --i-table 5_derep-table.qza \
  --o-visualization 5_derep-table.qzv

qiime feature-table tabulate-seqs \
  --i-data 5_derep-seqs.qza \
  --o-visualization 5_derep-seqs.qzv

