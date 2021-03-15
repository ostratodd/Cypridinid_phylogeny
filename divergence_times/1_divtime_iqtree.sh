#This is a partitioned analysis to obtain the tree for concatenated data from Hamster
#iqtree2 -s ../files/concatmat.phy -spp ../files/partition_modified.nex -st AA -bb 1000 -bnni -alrt 1000 -T AUTO -ntmax 12


#divtime analysis with iqtree2
iqtree2 -s ../files/concatmat.phy -spp ../files/partition_modified.nex --date dates_file.txt -te euph_rooted_concat.tre --date-tip 0 --date-ci 100 --redo-tree
