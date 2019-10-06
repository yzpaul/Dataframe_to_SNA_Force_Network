library(igraph)
library(networkD3)

dtm2<-data.frame("source"=c(1,2,3,4,5,6,7,8,9),
                 "target"=c(8,2,8,8,1,5,4,3,7))

#This graph assumes the link value is 1 by default. You can change it here.
#In the example graph below it is used to set the line width
dtm2$val<-1

#this graph assumes none of the nodes are grouped into communites, but you can specify groupings here:
dtm2$community<-1:dim(dtm2)[1]

####################################################################################
# 1) Generate basic graph object:
####################################################################################
  g<-graph.data.frame(dtm2[,1:ncol(dtm2)], directed=TRUE) #directed=TRUE because one unique_id (aka source) only points to one target
  V(g)$type <- V(g)$name %in% dtm2[,1] #true if node, false if community

  numact<-table(V(g)$type)[2]#captures number of unique actors in dtm2
  numcom<-table(V(g)$type)[1]#gets number of communities in dtm2
####################################################################################
# 2) Calculate node (vertex) labels:
####################################################################################
  V(g)$label<-V(g)$name #numbers each node as unique number. is source for links
  
  #make sure to set the lowest label value to 0. Because R starts indexes at 1, 
  #but JavaScript (which actually builds the graph) starts them at 0
  V(g)$label<-as.character(as.numeric(V(g)$label)-min(as.numeric(V(g)$label)))
  
  #V(g)$label[numact+1:numcom]<-"community" #to make some nodes communities
  
####################################################################################
# 3) Count number of communities and actors: 
####################################################################################
  numact<-table(V(g)$type)[2]#captures number of unique actors that arent in community
  numcom<-table(V(g)$type)[1]#gets number of communities in dtm2

####################################################################################  
# 4) generate list of links  
####################################################################################
  links<-as.data.frame(get.edgelist(g))
  
  #make sure to set the lowest label value to 0. R starts indexes at 1, 
  #but JavaScript (which actually builds the graph) starts them at 0
  links<-apply(links,2,as.numeric)
  minlink<-min(links)
  links<-as.data.frame(apply(links,2,function(x){x-minlink}))
  
  colnames(links)<-c("source","target")
  links$value <- dtm2$val

####################################################################################
# 5) generate list of nodes
####################################################################################
  #if you get an error here make sure there are no duplicate source/target pairs in original data 
  #then run this at start of your code:
  #dtm2<-dtm2 %>% distinct(source, target, .keep_all = TRUE)
  nodes <- data.frame(name=V(g)$label, group=dtm2$community)#label and color value of each node

####################################################################################  
# 6) pass params into forcenetwork to complete example
#################################################################################### 
forceNetwork(Links = links, Nodes = nodes,Source = "source", Target = "target",
          NodeID = "name", Value = "value",Group = "group", opacity = 0.8)
