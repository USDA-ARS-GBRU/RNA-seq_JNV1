args <- commandArgs(TRUE)
timePlotOutDir <- "report"
#colData <- read.csv("experimentDesign_4level.txt",sep="\t",row.names=1)
colData <- read.csv(args[1],sep="\t",row.names=1)
summary(colData)
head(colData)
countData <- as.matrix(read.csv("estCountsFixCtrl.csv",sep="\t",row.names="geneID"))
summary(countData)
#countData["FVEG_10402","tg1b4hrOpen_42738000"]
sink("temp.txt")
sort(rownames(colData))
"#########"
sort(colnames(countData))
sink()

all(rownames(colData) %in% colnames(countData)) #make sure names match
countData <- countData[, rownames(colData)] #reorder count data
all(rownames(colData) == colnames(countData)) #check order

library("DESeq2")
dds <- DESeqDataSetFromMatrix(countData = countData,colData = colData,design = ~ time + condition + time:condition)

dds <- DESeq(dds, test="LRT", reduced = ~ time + condition)
results1 <- results(dds, alpha=.01)
head(results1)
resultsNames(dds)

# sink("summary.txt")
# summary(results1)
# sink()
# #results2 <- lfcShrink(dds, coef=12, res=results1) not in this version
# resOrdered <- results1[order(results1$padj),]
# resDF <- as.data.frame(resOrdered)
# write.csv(resDF,file="timeByCondition_results.csv")

clist <- c("AT3G48560")

library("ggplot2")
for (i in clist) {
   d <- plotCounts(dds, gene=as.character(i),intgroup=c("time","condition"),returnData=TRUE) #should be simply normalized by depth and log2(x + .5)
   #print(d)
   write.table(d, file = paste("timePlot_",i,".txt", sep=""))
   pdf(paste("timePlot_",i,".pdf", sep=""))
   print(ggplot(d, aes(x=time, y=count, color = condition, group = condition)) + geom_point() + geom_smooth(se = FALSE, method = "loess") + geom_smooth(se = FALSE, method = "loess") + scale_y_log10()) #totally bizarre, but ggplot needs a print statement inside a loop
   dev.off()
}





