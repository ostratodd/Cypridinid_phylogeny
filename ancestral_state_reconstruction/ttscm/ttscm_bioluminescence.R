setwd("~/Documents/GitHub/Cypridinid_phylogeny/ancestral_state_reconstruction/ttscm/")
require(ape);
library(phytools)
library(ggplot2)
source(file="chronofunctions1.0.R")
read.nexus(file="../../mb_clock.tre") -> consensus


read.nexus(file="~/Documents/GitHub/Cypridinid_phylogeny/divergence_times/aauniclock.run1.t") -> run1
read.nexus(file="~/Documents/GitHub/Cypridinid_phylogeny/divergence_times/aauniclock.run2.t") -> run2

data.frame(read.csv(file="character_states.csv", header=FALSE), row.names=TRUE) -> chars
names(chars) <- c("biolum", "court")
biolum <-chars$biolum
names(biolum) <- row.names(chars)

#Plot tree to check character states
plotTree(consensus,fsize=0.8,ftype="i")
cols<-setNames(palette()[1:length(unique(biolum))],sort(unique(biolum)))
tiplabels(pie=to.matrix(biolum,sort(unique(biolum))),piecol=cols,cex=0.3)
add.simmap.legend(colors=cols,prompt=FALSE,x=0.9*par()$usr[1],
    y=-max(nodeHeights(tree)),fsize=0.8)
    
    
#Set up character states

rm(changedata)
rm(countdata)
firsttimethru <- 1
for(i in 4000:4010) {
 print("calculating tree:")
 print(i)

simulation <- make.simmap(run1[[i]], biolum, model="SYM", nsim=100)
	treedepth <- rootdepth(simulation[[1]])
	print("  Tree Depth")
	print(treedepth)

if(firsttimethru==1){
					changedata<-chronoSimmap(simulation, rev.order=TRUE,treedepth)
					countdata<-countLineages(simulation, treedepth)
					firsttimethru <- 2
				}else{
 					changedata <- rbind(changedata,chronoSimmap(simulation, rev.order=TRUE,treedepth))
 					countdata <- rbind(countdata,countLineages(simulation,treedepth))
 				}

}






#**************************Salmonid migration3.R alexandrou et al
rm(changedata)
rm(countdata)
#rm(data)

firsttimethru <- 1
for(i in 1:150) {
 print("calculating tree:")
 print(i)
 names(migration)<-SalmonPruned[[i]]$tip.label
 simulation <- make.simmap(SalmonPruned[[i]], migration, model="SYM", nsim=100)
	treedepth <- rootdepth(simulation[[1]])
	print("  Tree Depth")
	print(treedepth)
if(firsttimethru==1){
					changedata<-chronoSimmap(simulation, rev.order=TRUE,treedepth)
					countdata<-countLineages(simulation, treedepth)
					firsttimethru <- 2
				}else{
 					changedata <- rbind(changedata,chronoSimmap(simulation, rev.order=TRUE,treedepth))
 					countdata <- rbind(countdata,countLineages(simulation,treedepth))
 				}
}
 
branchtimehist <-hist(countdata$NewBranchTime) cumhist<-branchtimehist bth <- branchtimehist$counts

#make cumulative distribution for branches. This will be the denominator for changes/branch. 
#***************** first, reverse order of branch times.
revbth <- rev(bth)
#next calculate cumulative sum to yield (backwards) total # of branches per bin.
crevbth <- cumsum(revbth)
#Now reverse the order to have yougest first, oldest last
cdist <- rev(crevbth) cumhist$counts <- cdist
#Not using density or intensity cumhist$density <- 
#max(cumsum(branchtimehist$density))-cumsum(branchtimehist$density)+.1 cumhist$intensities <- 
#cumsum(branchtimehist$intensity)
changedatahist <- hist(changedata$BeforePresent, breaks=cumhist$breaks)

#******************************
#subdivide state changes -- make a different histogram for each state
	#change to state 1
chto1hist <- hist(subset(changedata,ChangeToState==1)$BeforePresent,plot=FALSE,breaks=cumhist$breaks)
	#change to state 2
chto2hist <- hist(subset(changedata,ChangeToState==2)$BeforePresent,plot=FALSE,breaks=cumhist$breaks)

#Now divide to get average changes per branch for changes to state 2
avehist2<-chto1hist

avehist2$counts <- chto2hist$counts/cumhist$counts
avehist2$density <-chto2hist$density/cumhist$density
avehist2$intensities <- chto2hist$intensity/cumhist$intensity


#Now divide to get average changes per branch for changes to state 1
avehist1<-chto1hist

avehist1$counts <- chto1hist$counts/cumhist$counts
avehist1$density <-chto1hist$density/cumhist$density
avehist1$intensities <- chto1hist$intensity/cumhist$intensity

	#change to state 0
chto0hist <- hist(subset(changedata,ChangeToState==0)$BeforePresent,plot=FALSE,breaks=cumhist$breaks)
#Now divide to get average changes per branch

avehist0<-chto0hist
avehist0$counts <- chto0hist$counts/cumhist$counts
avehist0$density <-chto0hist$density/cumhist$density
avehist0$intensities <- chto0hist$intensity/cumhist$intensity

#****************************
#Now Calculate Total Changes Together, All States
#Now divide to get average changes per branch
avehist<-changedatahist

avehist$counts <- changedatahist$counts/cumhist$counts
avehist$density <-changedatahist$density/cumhist$density
avehist$intensities <- changedatahist$intensity/cumhist$intensity


#******************************
#Now Plot All
par(mfrow=c(2,4))
plot(chto2hist, main = "Total state changes to 2")
plot(avehist2, ylim=c(0, 0.070), main = "State changes to 2 per branch")
plot(chto1hist, main = "Total state changes to 1")
plot(avehist1, ylim=c(0, 0.070), main = "State changes to 1 per branch")
plot(cumhist, main = "Lineages per time")
plot(chto0hist, main = "Total state changes to 0")
plot(avehist0, ylim=c(0, 0.070), main = "State changes to 0 per branch")
plot(avehist, main = "Total State changes per branch")



#ggplot(data, aes(x =(as.numeric(BeforePresent)), fill = ChangeToState)) + geom_histogram() + scale_x_continuous("Time Since Root") + 	scale_y_continuous("State Changes per Branch")
