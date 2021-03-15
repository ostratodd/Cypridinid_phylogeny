#!/bin/bash

echo "uses bioperl which is only in base conda"

echo "previous runs found gene trees with all paralogs. Then ppp pruned to find only orthologs"
echo "this script re-aligns and re-estimates gene trees for those"


for FILENAME in /Users/oakley/Documents/GitHub/Cypridinidae_phylogeny/orthologs/phylopydir/phylopypruner_output/output_alignments/*.aln_pruned.fa
do
  #assumes path and filename are all same length which is reasonable assumption
  path="${FILENAME:0:114}"
  orthogroup="${FILENAME:114:9}"

  mafft $FILENAME > $path$orthogroup.raln.fa

  fasttree $path$orthogroup.raln.fa > $path$orthogroup.pppft.treefile
#  iqtree -s genetrees/$line.iq.fa -nt 4 --redo

done
