echo "use conda activate phylogeny"
rm -rf sortadate
mkdir sortadate
cp ../orthologs/phylopydir/phylopypruner_output/output_alignments/*.treefile ./sortadate/
cp ../orthologs/phylopydir/phylopypruner_output/output_alignments/*.raln.fa ./sortadate/

cd sortadate
#this removes OG and Gene ID from treefile to have multi-mapped genetrees (only species names remain)
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_DN[0-9]+//g' *.treefile
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_DN[0-9]+//g' *.raln.fa
#Darwinula genome has different gene numbers that are not DN  #OG0000001_CADxxxxxx
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_CAD[0-9]+//g' *.treefile
perl -p -i -e 's/\|OG\d\d\d\d\d\d\d\_CAD[0-9]+//g' *.raln.fa
cd ..


#Now root the trees

for FILENAME in sortadate/*.pppft.treefile
do
  orthogroup="${FILENAME:10:9}"
  if grep -q Dstev_ENA "$FILENAME"; then
    echo "Rooting $orthogroup saving to file"
    pxrr -t $FILENAME -g Dstev_ENA -o sortadate/$orthogroup.rooted.tre
  fi

done

#and run sortadate
python /Users/oakley/Documents/GitHub/SortaDate/src/get_var_length.py ./sortadate --flend rooted.tre --outf sortadateresult --outg Dstev_ENA


#Next run concordance with species tree
#root the species tree and save in sortadate directory
pxrr -t ../orthologs/astral.tre -g Dstev_ENA -o sortadate/astral-pro.rooted.treefile

python /Users/oakley/Documents/GitHub/SortaDate/src/get_bp_genetrees.py sortadate/ sortadate/astral-pro.rooted.treefile --flend rooted.tre --outf concordance


python /Users/oakley/Documents/GitHub/SortaDate/src/combine_results.py sortadateresult concordance --outf sorted

python /Users/oakley/Documents/GitHub/SortaDate/src/get_good_genes.py sorted --outf goodgenes --max 15

#script uses goodgenes and pulls trees into one file
#this script also creates directory called clockgenes and copies files 
../../scripts/gg2tree.pl goodgenes
cat clocktrees/*.treefile > clockgenes.treefile

java -D"java.library.path=/Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/lib/" -jar /Users/oakley/Documents/GitHub/A-pro/ASTRAL-MP/astral.1.1.5.jar -i clockgenes.treefile -o astral_clockgenes.tre 



