args <- commandArgs(TRUE)
colData <- read.csv("experimentDesign_4level.txt",sep="\t",row.names=1)
summary(colData)
head(colData)
countData <- as.matrix(read.csv("geneskallistoNoRiboRNACounts.txt",sep="\t",row.names="geneID"))
summary(countData)
#countData["FVEG_10402","tg1b4hrOpen_42738000"]
all(rownames(colData) %in% colnames(countData)) #make sure names match
countData <- countData[, rownames(colData)] #reorder count data
all(rownames(colData) == colnames(countData)) #check order

#s <- "-0.438185 -0.766791  0.695282\n0.759100  0.034400  0.524807"
#x <- lapply(strsplit(s, "\n")[[1]], function(x) {as.numeric(strsplit(x, '\\s+')[[1]])})
contrS <- "4h_control 4h_hypoxic\n24h_control 24h_hypoxic"
contr <- lapply(strsplit(contrS, "\n")[[1]], function(x) {strsplit(x, '\\s+')[[1]]})
contr

library("DESeq2")
dds <- DESeqDataSetFromMatrix(countData = countData,colData = colData,design = ~ group)

dds <- DESeq(dds)

# rawCounts <- counts(dds, normalized=FALSE)
# write.csv(as.data.frame(rawCounts),file="rawEstCounts.csv")
# normCounts <- counts(dds, normalized=TRUE)
# write.csv(as.data.frame(normCounts),file="normEstCounts.csv")

library("pheatmap")
rld <- rlog(dds, blind=FALSE)
sink("summary.txt")
for (i in contr) {
    name <- paste(i[2],"__",i[1], sep="")
    results1 <- results(dds, alpha=.01,contrast=c("group",as.character(i[2]),as.character(i[1])))
    #head(results1)
    print(name) #MUST USE PRINT
    summary(results1)
    resOrdered <- results1[order(results1$padj),]
    resDF <- as.data.frame(resOrdered)
    write.csv(resDF,file=paste(i[1],"__",i[2],"_results.csv", sep=""))
    sub <- subset(resOrdered, padj < .01)
    subDF <- as.data.frame(sub)
    print("absolute log2change average of significant")
    print(paste(name,mean(abs(subDF$log2FoldChange)), sep = " "))
    print("log2change average of significant")
    print(paste(name,mean(subDF$log2FoldChange), sep = " "))

    # clist <- head(row.names(resDF), n=200)
#     sub1Rld <- assay(rld)[clist,]
#     sub1RldNorm = t(apply(sub1Rld, 1, function(x)(x-min(x))/(max(x)-min(x))))
#     df <- as.data.frame(colData(dds)[,c("group")])
#     print(head(df))
#     pdf(paste(i[1],"_",i[2],"_heatmapCluster_Top500_AbsoluteScale", sep=""),height=20)
#     pheatmap(sub1Rld, cluster_rows=TRUE, cluster_cols=FALSE, show_colnames=FALSE, fontsize_row=3, annotation_col=df)
#     dev.off()
#     pdf(paste(i[1],"_",i[2],"_heatmapCluster_Top500_ZeroToOneScale", sep=""),height=20)
#     pheatmap(sub1RldNorm, cluster_rows=TRUE, cluster_cols=FALSE, show_colnames=FALSE, fontsize_row=3, annotation_col=df)
#     dev.off()
}
sink()

# 
# sampleDists <- dist(t(assay(rld)))
# library("RColorBrewer")
# sampleDistMatrix <- as.matrix(sampleDists)
# rownames(sampleDistMatrix) <- paste(rld$time, rld$condition, sep="_")
# colnames(sampleDistMatrix) <- NULL
# colors <- colorRampPalette(rev(brewer.pal(9,"Blues")))(255)
# pdf("heatMapSamples.pdf")
# pheatmap(sampleDistMatrix, clustering_distance_rows=sampleDists, clustering_distance_cols=sampleDists, col=colors)
# dev.off()
# pdf("pcaSamples.pdf")
# plotPCA(rld, intgroup=c("condition","time"))
# dev.off()
