#!/bin/bash

#Put all genetreesinto a single file each after removing old file
rm combined_ft_orthologs_astral.treefile 

for FILENAME in phylopydir/phylopypruner_output/output_alignments/*.treefile
do
     echo "combining $FILENAME"
     cat $FILENAME >> combined_ft_orthologs_astral.treefile
done


#Note these are from phylopypruner so different format than previous astral run
#this removes OG and Gene ID from treefile to have multi-mapped genetrees (only species names remain)
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_DN[0-9]+//g' combined_ft_orthologs_astral.treefile
#Darwinula genome has different gene numbers that are not DN  #OG0000001_CADxxxxxx
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_CAD[0-9]+//g' combined_ft_orthologs_astral.treefile


#astral call for not using map file (requires perl command above to remove unique gene names and only have spp names)
java -D"java.library.path=/Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/lib/" -jar /Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/astral.1.1.5.jar -i combined_ft_orthologs_astral.treefile -o astral_orthologs.tre 
#2>astral_orthologs.log

