cp uniclock.run1.t test.run1.t
cp uniclock.run2.t test.run2.t

#echo "end;" >> test.run1.t
#echo "end;" >> test.run2.t

rm test.con.tre	
rm test.trprobs	
rm test.vstat
rm test.parts	
rm test.tstat

mb < check.nex
