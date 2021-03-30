#!/bin/bash

rm clock_concat.phytab
for FILENAME in clockgenes/*.raln.fa
do
	../../scripts/fasta2phytab.pl $FILENAME >> clock_concat.phytab
done

#use phylocatenator to create concatenated newick file
../../scripts/phylocatenator.pl clock_concat.phytab 4 4 100 None None clock_concat.phyx None clock_concat.html clock_concat2.html

#remove empty lines
sed -i "" '/^[[:space:]]*$/d' clock_concat.phyx

seqmagick convert clock_concat.phyx clock_concat.nex --alphabet protein

#mrbayes doesn't like Roatan name dash
perl -p -i -e "s/\'RO\-AG\_S10\'/RO\_AG\_S10/g" clock_concat.nex

mb < mbclock.nex
