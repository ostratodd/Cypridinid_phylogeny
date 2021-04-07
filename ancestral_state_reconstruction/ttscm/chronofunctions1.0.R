chronoSimmap<-function(simtree,rev.order=TRUE,depth) {
	if(class(simtree)=="multiSimmap"){	
        for(treeno in 1:length(simtree)) {
 			if(rev.order){
				curtree <- (chronoSimmap(simtree[[treeno]],rev.order=TRUE,depth))           
			}else{
				curtree <- (chronoSimmap(simtree[[treeno]],rev.order=FALSE,depth))
			}
            if(!exists("firstthru")) {
				out <- curtree
				firstthru <- 2
			}			
			out <- data.frame(rbind(curtree,out))
		}
		return(out)
	}else{

#	allchanges <- matrix(ncol=2)

	nbranches <- dim(simtree$edge)[1];
	nstates <- dim(simtree$edge)[2];
	firsttimethru <- 1
	if(firsttimethru == 1){

	#reverse order of maps due to 2 different conventions in phytools and Simmap
    		if(rev.order==TRUE){
        		    simtree$maps<-lapply(simtree$maps,function(x) x<-x[length(x):1])
     		}
	}
	for(i in 1:nbranches){				#checks each branch i 
		nchanges <- length(simtree$maps[[i]])
		if(nchanges > 1) {				#if >1 state changes
			#calculate total time up to currentnode
			time2node <- timebeforenode(simtree,i)
			time2currentchange <- 0
			for(j in 1:(nchanges-1) ) {
				if(firsttimethru==1){
					allchanges <- cbind(names(simtree$maps[[i]])[j], (time2node+simtree$maps[[i]][[j]]+time2currentchange), depth-(time2node+simtree$maps[[i]][[j]]+time2currentchange) )
					firsttimethru <- 2
				}else{
					#print state that is changed to, then time of change after root, then tip-change
					nextdelta <- cbind(names(simtree$maps[[i]])[j], (time2node+simtree$maps[[i]][[j]]+time2currentchange),  depth-(time2node+simtree$maps[[i]][[j]]+time2currentchange))
					allchanges <- rbind(allchanges,nextdelta)
				}
				time2currentchange <- time2currentchange + simtree$maps[[i]][[j]]
			}
		}
	}
	
	changesdataframe <- data.frame(cbind(allchanges[,1]),as.numeric(allchanges[,2]),as.numeric(allchanges[,3]))
	colnames(changesdataframe) <- c("ChangeToState","AtTime","BeforePresent")
	return(changesdataframe)
	#return(allchanges)
}
}#extra bracket since multiphylo not indented at beginning


findancestorbranch<-function(simtree,branch){
	Nbranches <- dim(simtree$edge)[1];
	ancestor <- simtree$edge[branch,1]
	for(i in 1:Nbranches) {
		if(ancestor == simtree$edge[i,2]) {
			return(i)
		}		
	}
	#if no ancestor, we are at root, then return 1+total number of branches
	return(Nbranches+1)
}


#*************************************************
timebeforenode<-function(simtree,curbranch){
	#function to count time from node to ancestorbranch
	sumtime <- 0 
	Nbranches <- dim(simtree$edge)[1];

	for(i in 1:Nbranches) {
		previousbranch <- findancestorbranch(simtree,curbranch)
			if(previousbranch == Nbranches+1) {
				return(sumtime)
			}else{
				sumtime <- sumtime + simtree$edge.length[previousbranch]
				curbranch <- previousbranch
		}
	}
}

#*************************************************
rootdepth<-function(simtree){
	#function to count time from node to ancestorbranch
	Nbranches <- dim(simtree$edge)[1];
	maxdepth <- 0
	for(i in 1:Nbranches) {
		sumtime <- 0 
		curbranch <- i
		reachedroot <- 0
		for(j in 1:Nbranches) {
			curbranchlen <- simtree$edge.length[curbranch]
			previousbranch <- findancestorbranch(simtree,curbranch)
			if(previousbranch == Nbranches+1) {
				#At root branch
				sumtime <- sumtime + curbranchlen
				if(sumtime > maxdepth){
					if(reachedroot ==0){
						maxdepth <- sumtime
					}
				}
				reachedroot <- 1
			}else{
				sumtime <- sumtime + curbranchlen
				curbranch <- previousbranch
				if(sumtime > maxdepth){
					maxdepth <- sumtime
				}
			}
		}
	}
	print("")
	return(maxdepth)
}



#*************************************************
plotchanges <-function(simtree,rev.order=TRUE){
	if(rev.order){
		data <- chronoSimmap(simtree, rev.order=TRUE)
	}else{
		data <- chronoSimmap(simtree, rev.order=FALSE)
	}
	ggplot(data, aes(x =(as.numeric(AtTime)), fill = ChangeToState)) + geom_histogram() + scale_x_continuous("Time Since Root of Tree") + 	scale_y_continuous("Number of State Changes")
}

#*************************************************
countLineages<-function(simtree, depth) {
	if(class(simtree)=="multiSimmap"){
		for(treeno in 1:length(simtree)) {
			curtree <- (countLineages(simtree[[treeno]],depth))
			if(!exists("firstthru")) {
				out <- curtree
				firstthru <- 2
			}			
			out <- data.frame(rbind(curtree,out))
		}
		return(out)
	}else{
	
	
#	allchanges <- matrix(ncol=2)
	nbranches <- dim(simtree$edge)[1];
	nstates <- dim(simtree$edge)[2];
	firsttimethru <- 1
	for(i in 1:nbranches){				#checks each branch i 
		time2node <- timebeforenode(simtree,i)
		time2node <- depth - time2node
		if(firsttimethru==1){
			allchanges <- cbind(time2node)
			firsttimethru <- 2
		}else{
			#print time of new lineage
			nextdelta <- cbind(time2node)
		allchanges <- rbind(nextdelta,allchanges)
		}
	}
	
	branchesdataframe <- data.frame(allchanges)
	colnames(branchesdataframe) <- c("NewBranchTime")
	return(branchesdataframe)
	#return(allchanges)
}
}#extra bracket since multiphylo not indented at beginning

#*************************************************
comparePlots<-function(simulation,rev.order=TRUE){

	countdata<-countLineages(simulation)
	branchtimehist <-hist(countdata$NewBranchTime)
	cumhist<-branchtimehist

	#make cumulative distribution
	cumhist$counts <- cumsum(branchtimehist$counts)
	cumhist$density <- cumsum(branchtimehist$density)
	cumhist$intensities <- cumsum(branchtimehist$intensity)

	plot(cumhist)

	if(rev.order){
		changedata<-chronoSimmap(simulation, rev.order=TRUE)
	}else{
		changedata<-chronoSimmap(simulation, rev.order=FALSE)
	}

	#Make a histogram of state changes using the same break points as used in branch 	counts
	changedatahist <- hist(changedata$AtTime, breaks=cumhist$breaks)

	#Now divide to get average changes per branch
	avehist<-changedatahist

	avehist$counts <- changedatahist$counts/cumhist$counts
	avehist$density <-changedatahist$density/cumhist$density
	avehist$intensities <- changedatahist$intensity/cumhist$intensity

	par(mfrow=c(3,1))
	plot(changedatahist, main = "Total state changes")
	plot(avehist, main = "State changes per branch")
	plot(cumhist, main = "Lineages per time")
}
