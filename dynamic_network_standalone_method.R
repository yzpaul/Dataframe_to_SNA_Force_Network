# library(igraph)
# library(networkD3)
# csv<-read.csv("C:\\Users\\King\\Desktop\\campbell\\minecraftdatapuller\\Analysis\\minecraft_with_0_and_MI.csv")
# dtm2<-data.frame(csv$stat.damageDealt,csv$stat.deaths,csv$stat.mob)#damage delt on deaths, mob kills (is color)
# #write.csv(dtm2,"output_df_for_jason.csv",row.names=F)
# #adding UNIQUE names column
# dtm2$names<-1:length(dtm2[,1]) 
# dtm2$names<-paste("uniqueID_",dtm2$names,sep="")
# 
# dtm2$colors <- ifelse(is.na(dtm2[,3]), 999, 
#                  ifelse(as.numeric(dtm2[,3]) < 10, 1, 
#                         ifelse(as.numeric(dtm2[,3]) >= 30, 3, 2)))
# #reorder columns so unique id is next to kills. uniqueID will be source and target will be kills 
# dtm2<-dtm2[,c(4,2,5,1)]
# #add lineweights to dataframe
# dtm2$lineWeights<-3
# #run function and display forceNetwork in browser
# res<-forceNetwork_from_dataframe(dtm2)
# htmltools::html_print(res, viewer = utils::browseURL)

####################################################################################################################################

#dataframe col1=source(aka unique id). col2=target to link source to. col3=color atttribute. col4=vertex labels, col5=line weights
#d3 color group order: blue, orange, green, red
forceNetwork_from_dataframe<-function(dtm2){
set.seed(42)
g<-graph.data.frame(dtm2[,1:ncol(dtm2)], directed=TRUE) #directed=TRUE because one unique_id (aka source) only points to one target
V(g)$type <- V(g)$name %in% dtm2[,1] #purpose is to give true and false for node and community?????

i<-table(V(g)$type)[2]#captures number of unique actors in dtm2.... is 15
j<-table(V(g)$type)[1]#gets number of communities in dtm2


V(g)$name<-1:length(V(g)) #numbers each node as unique number. is source for links
V(g)$label<-paste("name:",V(g)$name,"_dmgDealt:",dtm2[,4],sep="")
V(g)$label[i+1:j]<-"community" #label communities as community. syntax when end num in : less then beginning do repeat for end number times
#V(g)$label<-V(g)$name

links<-as.data.frame(get.edgelist(g))
links$V1<-as.numeric(as.character(links$V1))
#links

links$V2<-as.numeric(as.character(links$V2))
#str(links)

colnames(links)<-c("source","target")
#links
links<-(links-1)#can show all links (start count from 0)
links$value <- dtm2[,5] 
#links


#add communities to color list.
groupings<-c(dtm2[,3],rep(999,j))#j is number of communities

#nodes <- data.frame(name=V(g)$label, group=c(rep(1,i),rep(2,(j))))#change group numbers####CLASS CODE
nodes <- data.frame(name=V(g)$label, group=groupings)
nodes #shows actors and group

nothingbutnet<-forceNetwork(Links = links, Nodes = nodes,
             Source = "source", Target = "target",
             NodeID = "name", Value = "value",
             Group = "group", opacity = 0.8, colourScale = "d3.scale.category10()")

return(nothingbutnet)
}
