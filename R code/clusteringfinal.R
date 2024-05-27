library(ClusterR) 
library(cluster) 
library(factoextra)
install.packages("rstatix")


# load in data
preclusterdata<-read.csv(file=file.choose())
colnames(preclusterdata)
tail(preclusterdata)

#only select relevant columns
clusterdata <- preclusterdata[c(9,13:42)]

#convert percentages to decimals
clusterdata$Zone.<- as.numeric(sub("%", "", clusterdata$Zone.)) / 100


#elbow method
fviz_nbclust(
  clusterdata,
  kmeans,
  method = "wss",
  k.max = 25,
  verbose = FALSE
)
# 7... but it could be 13, 21...


# cluster
kmeans.re <- kmeans(clusterdata, centers = 7, nstart = 20) 
kmeans.re 

#add clusters to data
Data3 <- preclusterdata
Data3$realclusters <- kmeans.re$cluster

Data4 <- clusterdata
Data4$realclusters <- kmeans.re$cluster

# Cluster identification for  
# each observation 
kmeans.re$cluster 



#export data
write.csv(Data2, file = "CLUSTEREDmlb.csv")


# Calculate means and medians of each variable for each cluster
cluster_means <- Data4 %>%
  group_by(realclusters) %>%
  summarise_all(mean)

cluster_medians <- Data4 %>%
  group_by(realclusters) %>%
  summarise_all(median)

# Print the cluster means
print(cluster_means)
View(cluster_means)

View(Data3)
table(Data3$realclusters)

# convert percents to decimals, get data ready for export
Data3$Zone.<- as.numeric(sub("%", "", Data3$Zone.)) / 100
Data3$GB.<- as.numeric(sub("%", "", Data3$GB.)) / 100
Data3$K.<- as.numeric(sub("%", "", Data3$K.)) / 100
Data3$BB.<- as.numeric(sub("%", "", Data3$BB.)) / 100
finalpostcluster= subset(Data3, select = -c(Cluster) )

#export data
write.csv(finalpostcluster, "final_post_cluster.csv")
write.csv(cluster_means, "cluster_means.csv")
write.csv(cluster_medians, "cluster_medians.csv")

