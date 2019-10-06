Dataframe_to_SNA_Force_Network

# What does this function do? #
This is a function to convert a dataframe of source/target node pairs to list of nodes and edges.

# Why is this useful? #
If you want to create a forceNetwork with only a list of sources/targets you no longer have to calculate the node and edge lists by hand

### But what about simpleNetwork? Isn't it designed for that? ###
Kind of- forceNetwork offers a far greater degree of customization (for example coloring individual nodes)

# How do I use it? #

fork this, replace your dataframe with dtm2 in the code and run it. The final output will be a forceNetwork.

### Dataframe specification ###

- source: aka unique node id)
- target: reference to another unique node id that is connected

- (optional) val: used to set the line widths
- (optional) community: used to set the node grouping value 
