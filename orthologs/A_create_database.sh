#!/bin/bash

echo "uses bioperl which is only in base conda"

#First pull current names of orthogroups into file
../../scripts/og2txt.pl > og.txt

rm database/transcriptomes.fa

input="og.txt"
while IFS= read -r line
do
  echo "$line"
  
  #Number in next command is minimum number of species to include ortholog
  perl ../../scripts/ogsql2fasta.pl $line 20 database/$line.fa
  cat database/$line.fa >> database/transcriptomes.fa
  rm database/$line.fa

done < "$input"
