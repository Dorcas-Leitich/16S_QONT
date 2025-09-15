#!/bin/bash
set -euo pipefail

qiime vsearch dereplicate-sequences \
  --i-sequences 4_single-end-demux.qza \
  --o-dereplicated-table 5_derep-table.qza \
  --o-dereplicated-sequences 5_derep-seqs.qza

