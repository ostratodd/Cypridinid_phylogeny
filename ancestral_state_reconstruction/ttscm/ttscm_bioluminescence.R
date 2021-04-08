
#laptop
setwd("~/Documents/GitHub/Cypridinid_phylogeny/ancestral_state_reconstruction/ttscm/")
#desktop
setwd("~/Documents/GitHub/Cypridinidae_phylogeny/ancestral_state_reconstruction/ttscm/")

library(ape);
library(phytools)
library(ggplot2)
source(file="chronofunctions1.0.R")
#read trees and parameters
read.nexus(file="../../mb_clock.tre") -> consensus
read.nexus(file="../../mcmctrees2.tre") -> mcmc
read.table(file="../../mcmctrees.p", sep="\t", comment.char="[", header=TRUE) -> params

#Set up character states
data.frame(read.csv(file="character_states.csv", header=FALSE), row.names=TRUE) -> chars
names(chars) <- c("biolum", "court")
biolum <-chars$biolum
names(biolum) <- row.names(chars)

court <- chars$court
names(court) <- row.names(chars)



##Plot tree to check character states -- Uncomment to plot tree
#plotTree(mcmc[[4500]],fsize=0.8,ftype="i")
#cols<-setNames(palette()[1:length(unique(biolum))],sort(unique(biolum)))
#tiplabels(pie=to.matrix(biolum,sort(unique(biolum))),piecol=cols,cex=0.3)
#add.simmap.legend(colors=cols,prompt=FALSE,x=0.9*par()$usr[1],
#   y=-max(nodeHeights(tree)),fsize=0.8)
    
    



dataset <- biolum
#dataset <- court
 

	rm(changedata)
	rm(countdata)
	firsttimethru <- 1
	for(i in 4500:4600) {
	 print("calculating tree:")
	 print(i)

	   #MrBayes mcmc file does not have absolute branch lengths
		clockrate <- params$clockrate[[i]]
		mcmc[[i]]$edge.length = mcmc[[i]]$edge.length / clockrate
	
	
	simulation <- make.simmap(mcmc[[i]], dataset, model="SYM", nsim=100)
	 	treedepth <- rootdepth(simulation[[1]])
	    print("  Clockrate")
	    print(clockrate)
		print("  Tree Depth")
		print(treedepth)
	
	if(firsttimethru==1){
						changedata<-chronoSimmap(simulation, rev.order=TRUE,treedepth)
						countdata<-countLineages(simulation, treedepth)
						firsttimethru <- 2
					}else{
	 					changedata <- rbind(changedata,chronoSimmap(simulation, 		rev.order=TRUE,treedepth))
 						countdata <- rbind(countdata,countLineages(simulation,treedepth))
 					}
	}

	branchtimehist <-hist(countdata$NewBranchTime) 
	cumhist<-branchtimehist 
	bth <- branchtimehist$counts
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


	#subdivide state changes -- make a different histogram for each state
	#change to state 1
	chto1hist <- 	hist(subset(changedata,ChangeToState==1)$BeforePresent,plot=FALSE,breaks=cumhist$breaks)
	#Now divide to get average changes per branch for changes to state 1
	avehist1<-chto1hist
	avehist1$counts <- chto1hist$counts/cumhist$counts
	avehist1$density <-chto1hist$density/cumhist$density
	avehist1$intensities <- chto1hist$intensity/cumhist$intensity

	plot(chto1hist, main = "Total state changes to 1", xlab="Time Before Present")


	plot(avehist1, ylim=c(0, 1.3), main = "State changes to Bioluminescence per branch", xlab="Time Before Present")
	to1 <- subset(changedata,ChangeToState==1)
	abline(v=median(to1$BeforePresent), col="purple")
	label <- paste("Median: ", toString(round(median(to1$BeforePresent))), "MYA")
	text(360, 1, label, col="purple")


#Find 95 CI from simulation
require(Rmisc)
CI(changedata$BeforePresent, .95)


