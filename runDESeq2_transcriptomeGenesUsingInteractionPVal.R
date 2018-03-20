args <- commandArgs(TRUE)
timePlotOutDir <- "report"
#colData <- read.csv("experimentDesign_4level.txt",sep="\t",row.names=1)
colData <- read.csv("experimentDesign.txt",sep="\t",row.names=1)
summary(colData)
head(colData)
countData <- as.matrix(read.csv("geneskallistoNoRiboRNACounts.txt",sep="\t",row.names="geneID"))
summary(countData)
#countData["FVEG_10402","tg1b4hrOpen_42738000"]
all(rownames(colData) %in% colnames(countData)) #make sure names match
countData <- countData[, rownames(colData)] #reorder count data
all(rownames(colData) == colnames(countData)) #check order

library("DESeq2")
dds <- DESeqDataSetFromMatrix(countData = countData,colData = colData,design = ~ time + condition + time:condition)

dds <- DESeq(dds, test="LRT", reduced = ~ time + condition)
results1 <- results(dds, alpha=.01)
head(results1)
resultsNames(dds)

sink("summary.txt")
summary(results1)
sink()
#results2 <- lfcShrink(dds, coef=12, res=results1) not in this version
resOrdered <- results1[order(results1$padj),]
resDF <- as.data.frame(resOrdered)
write.csv(resDF,file="timeByCondition_results.csv")

clist <- head(row.names(resDF), n=40)

library("ggplot2")
for (i in clist) {
   d <- plotCounts(dds, gene=as.character(i),intgroup=c("time","condition"),returnData=TRUE) #should be simply normalized by depth and log2(x + .5)
   #print(d)
   pdf(paste("timePlot_",i,".pdf", sep=""))
   print(ggplot(d, aes(x=time, y=count, color = condition, group = condition)) + geom_point() + geom_smooth(se = FALSE, method = "loess") + scale_y_log10()) #totally bizarre, but ggplot needs a print statement inside a loop
   dev.off()
}

clist <- head(row.names(resDF), n=200)

library("pheatmap")
rld <- rlog(dds, blind=FALSE)
sub1Rld <- assay(rld)[clist,]
sub1RldNorm = t(apply(sub1Rld, 1, function(x)(x-min(x))/(max(x)-min(x))))
df <- as.data.frame(colData(dds)[,c("condition","time")])
#pheatmap(sub1Rld, cluster_rows=FALSE, cluster_cols=FALSE, annotation_col=df)
pdf("heatmapCluster_Top200_AbsoluteScale.pdf",height=20)
pheatmap(sub1Rld, cluster_rows=TRUE, cluster_cols=FALSE, annotation_col=df, show_colnames=FALSE, fontsize_row=3)
dev.off()
pdf("heatmapCluster_Top200_ZeroToOneScale.pdf",height=20)
pheatmap(sub1RldNorm, cluster_rows=TRUE, cluster_cols=FALSE, annotation_col=df, show_colnames=FALSE, fontsize_row=3)
dev.off()

sampleDists <- dist(t(assay(rld)))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(rld$time, rld$condition, sep="_")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette(rev(brewer.pal(9,"Blues")))(255)
pdf("heatMapSamples.pdf")
pheatmap(sampleDistMatrix, clustering_distance_rows=sampleDists, clustering_distance_cols=sampleDists, col=colors)
dev.off()
pdf("pcaSamples.pdf")
plotPCA(rld, intgroup=c("condition","time"))
dev.off()



