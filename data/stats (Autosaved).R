# Statistics

# Number of clicks per user
nc_A = length(ind_clA)
nc_B = length(ind_clB)

# Total clicks
total_nc = nc_A + nc_B

ind_Cros
ind_clA
ind_clB
ct_nco = 0;
stats = seq(1,length(ind_clA))   # sequence from 1 to 100 in steps of 2
stats.agentA = NULL
stats.agentB = NULL
stats.ct_nca = 0;
stats.ct_ncb = 0;
fps = 25			# frames per seconds in Processing 2.~
marg = round(1.25/(1/fps))+1		# 2 second of margin (user reaction) 

# Cuantos se han hecho en un agent

# Compare crosses and clicks from user A
for (i in 1:length(ind_clA) ) {
	for (j in 1:length(ind_Cros)){
		# Compare crosses and clicks with user A, with 
		if ((ind_clA[i]<ind_Cros[j]+marg)&&(ind_clA[i]>ind_Cros[j]-marg)){
    		stats.agentA[i] = x$nCrosses[i]-x$nCrosses[i+1]
    		stats.ct_nca = stats.ct_nca + 1
    	}
    }
}

# Compare crosses and clicks from user B
for (i in 1:length(ind_clB) ) {
	for (j in 1:length(ind_Cros)){
		# Compare crosses and clicks with user A
		if ((ind_clB[i]<ind_Cros[j]+13)&&(ind_clB[i]>ind_Cros[j]-13)){
    		stats.agentB[i] = x$nCrosses[i]-x$nCrosses[i+1]
    		stats.ct_ncb = stats.ct_ncb + 1
    	}
    }
}

stats.ct_nca	# number of clicks with agent (avatarA)
stats.ct_ncb	# number of clicks with agent (avatarB)


# Number of clicks in a shadow - User A

# shadow is located -70 pixels of avatar position. 
# So, we can do a for loop to evaluate the position of avatars in every click.

shd_pst = 70	# shadow position interval with Avatar
stats.shadowA = NULL
stats.ct_nc_sdwA = 0
for (i in 1:length(ind_clA) ) {
    # Compare with the the user B (reciprocal clicks)
 	if ((x$AvatarA[ind_clA[i]]<x$AvatarB[ind_clA[i]]+shd_pst+marg)&&
 	(x$AvatarA[ind_clA[i]]>x$AvatarB[ind_clA[i]] + shd_pst - marg)){
    	stats.shadowA[i] = x$AvatarB[ind_clA[i]]+shd_pst
    	stats.ct_nc_sdwA = stats.ct_nc_sdwA + 1 
	}    	  	
}
stats.ct_nc_sdwA


# Number of clicks in a shadow - User A
stats.shadowB = NULL
stats.ct_nc_sdwB = 0
for (i in 1:length(ind_clB) ) {
    # Compare with the the user B (reciprocal clicks)
 	if ((x$AvatarB[ind_clB[i]]<x$AvatarA[ind_clB[i]]+shd_pst+marg)&&
 	(x$AvatarB[ind_clB[i]]>x$AvatarA[ind_clB[i]] + shd_pst - marg)){
    	stats.shadowB[i] = x$AvatarA[ind_clB[i]]+shd_pst
    	stats.ct_nc_sdwB = stats.ct_nc_sdwB + 1 
	}    	  	
}
stats.ct_nc_sdwB


# Cuantos se han hecho en un object (static)

# Object A
objA_pst = width/4	# shadow position interval with Avatar
stats.objA = NULL
stats.ct_nc_objA = 0
for (i in 1:length(ind_clA) ) {
    # Compare with the the user B (reciprocal clicks)
 	if ((x$AvatarA[ind_clA[i]]<objA_pst+marg)&&
 	(x$AvatarA[ind_clA[i]]>objA_pst-marg)){
    	stats.objA[i] = ind_clA[i]
    	stats.ct_nc_objA = stats.ct_nc_objA + 1 
	}    	  	
}
stats.ct_nc_objA

# Object B
objB_pst = 3*width/4	# shadow position interval with Avatar
stats.objB = NULL
stats.ct_nc_objB = 0
for (i in 1:length(ind_clB) ) {
    # Compare with the the user B (reciprocal clicks)
 	if ((x$AvatarB[ind_clB[i]]<objB_pst+marg)&&
 	(x$AvatarB[ind_clB[i]]>objB_pst-marg)){
    	stats.objB[i] = ind_clB[i]
    	stats.ct_nc_objB = stats.ct_nc_objB + 1 
	}    	  	
}
stats.ct_nc_objB


# Cuantos clics han sido recíprocos

# Reciprocal response
stats.rcpcl = NULL
stats.ct_nc_rec = 0
for (i in 1:length(ind_clA) ) {
	for (j in 1:length(ind_clB)) {
    	# Compare with the the user B (reciprocal clicks)
 		if ((ind_clA[i]<ind_clB[j]+marg)&&
 			(ind_clA[i]>ind_clB[j]-marg)){
    		stats.rcpcl[i] = 1
    		stats.ct_nc_rec = stats.ct_nc_rec + 1 
		}
	}    	  	
}
stats.ct_nc_rec

# Print a table with the results for an experiment
table1 <- matrix(c(total_nc,nc_A,stats.ct_nca,stats.ct_nc_sdwA,stats.ct_nc_objA,nc_B,stats.ct_ncb,stats.ct_nc_sdwB,stats.ct_nc_objB,stats.ct_nc_rec))
colnames(table1) <- c("Experiment5")
rownames(table1) <- c("nclicks", "UserA","AgentA", "ShadowA", "ObjA", "UserB","AgentB", "ShadowB", "ObjB","Reciproc")
table1 <- as.table(table1)
table1

# The same should be done for each experiment and look for conclusions