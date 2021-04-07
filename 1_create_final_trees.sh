#******
#Cannot run this since conda doesn't seem to play well in bash scripts but can run each step 
#sequentially, and comment out the rest


##*******
##The first step downloads transcriptomes from Google Drive links
##Transcriptomes already assembled using croco and trinity and proteins
##predicted using trinity
##then runs orthofinder
##this requires orthofinder installation e.g. conda activate phylogeny
##...................
##....Step 1
#cd orthologs
#./1_DownloadNorth.sh > ../orthofinderrun.log
#cd ..

##....Step 2
#cd orthologs
#./2_CreateSQL.sh > ../sqladd.log
#cd ..

##....Step 3
#cd orthologs
#./3_genetrees.sh > ../genetrees.log
#cd ..

**************************
#.....Step 4 ---- Create astral tree from paralogs
#
#cd orthologs
#./4_paralog_astral.sh > ../astral_paralogs.log
#cd ..
#	#finalize species names Astral-pro species tree using fasttree for gene trees 
../scripts/searchrepsp.pl SSC.tab orthologs/astral.tre > astral_pro.tre
echo "***********ASTRAL-PRO TREE********************"
cat astral_pro.tre


**************************
#.....Step 5 ---- phylopypruner
#
#cd orthologs
#./5_phylopypruner.sh > ../ppp.log
#cd ..

#*****************************
#step 6 concatenated genes from ppp with tree
#cd orthologs
#./6_concatIQ.sh > ../concat_ppp.log
#cd ..
../scripts/searchrepsp.pl SSC.tab orthologs/concat_og_fasttree.tre > concat_paralogs_fasttree.tre
cat concat_paralogs_fasttree.tre

#*****************************
#step 7 realign ppp orthologs
#cd orthologs
#./7_ppp_genetrees.sh > ../ppp_genetrees.log
#cd..
	

##******************************
##Step 9 - use sortadate to find clock-like genes
##--------------------
##conda activate phylogeny
#echo "Running sortadate to find most clock-like genes"
#cd divergence_times
#./2_sortadate.sh > ../sortadate.log
#cd ..
#../scripts/searchrepsp.pl SSC.tab divergence_times/astral_clockgenes.tre > astral_10_clockgenes.tre
#echo "Astral with only 10 clockiest genes"
#cat astral_10_clockgenes.tre

##**********
##Step 10
##mrbayes divergence times
#echo "running mr bayes for divergence time analysis"
#cd divergence_times
#./4_mrbayes.sh > mbclock.log
#cd ..


##final MrBayes tree with 8 sortadate genes and divergence times
cd divergence_times
rm aauniclock.con.tre
rm aauniclock.trprobs	
rm aauniclock.vstat
rm aauniclock.parts	
rm aauniclock.tstat


mb < check.nex
cd ..
echo "Bayes relaxed clock"
../scripts/searchrepsp.pl SSC.tab divergence_times/aauniclock.con.tre > mb_clock.tre
cat mb_clock.tre

