#!/bin/bash

#Put all genetrees and maps into a single file each after removing old file
rm combined_ft_astral.treefile 

for FILENAME in genetrees/*.treefile
do
     echo "combining $FILENAME"
     cat $FILENAME >> combined_ft_astral.treefile
done



#this removes OG and Gene ID from treefile to have multi-mapped genetrees (only species names remain)
perl -p -i -e 's/\_OG\d\d\d\d\d\d\d\_DN[0-9]+//g' combined_ft_astral.treefile
#Darwinula genome has different gene numbers that are not DN  #OG0000001_CADxxxxxx
perl -p -i -e 's/\_OG\d\d\d\d\d\d\d\_CAD[0-9]+//g' combined_ft_astral.treefile

##DANGER DANGER -- THIS IS FOR DEBUGGING -- NOT ENOUGH DATA FOR JAMESCASEI SO ARBITRARILY SWAP TO PHOTEROS
#Do not leave this uncommented accidentally
##This is for early in gene tree calculation
#perl -p -i -e 's/BothJamescasei/Gruber_Pannecohenae/g' combined_ft_astral.treefile;
#perl -p -i -e 's/Jp_Melavar22/PSKO/g' combined_ft_astral.treefile;


#astral call for not using map file (requires perl command above to remove unique gene names and only have spp names)
java -D"java.library.path=/Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/lib/" -jar /Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/astral.1.1.5.jar -i combined_ft_astral.treefile -a combined_ft_astral.map -o astral.tre 2>astral.log

