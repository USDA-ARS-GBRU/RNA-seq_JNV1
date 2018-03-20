args <- commandArgs(TRUE)

library("keggseq")

genThresh <- 1.0
pathThresh <- 0.07

pathway <- "00290"

d <- read.csv(args[1], row.names=1)
de <- d[which(d$padj<genThresh),]
#setwd("./pathway_files/")

pathway_ids <- c(pathway)

newNames <- paste("ath:",row.names(de), sep="")
row.names(de) <- newNames
kset <- grep_datasets("ath")
#write.csv(kset,file="keggATH.csv")
# #quit()
result <- calculate_kegg(kset, newNames)
#head(result)
pathway_ids
# write.csv(result,file="kegg_results_WithGenes.csv")
# quit()
# kegSum <- kegg_summary(result)
# write.csv(kegSum,file="kegg_results.csv")
# pdf("kegg_scatter.pdf")
# create_filtered_plot(kegSum,"qvalue",paste("<",pathThresh,sep=""))
# dev.off()
# pdf("kegg_Map.pdf")
# create_kegg_map("ath",result,deNew,"04712")
# dev.off()
# 

de2 <- d[which(d$padj<genThresh),]
diff <- de2["log2FoldChange"]
summary(diff)



library("pathview")
sapply(pathway_ids, function(pid) pathview(gene.data = diff,
                                           pathway.id = pid,
                                           species = "ath",
                                           kegg.native=T,
                                           sign.pos="bottomleft",
                                           gene.annotpkg="org.At.tair.db",
                                           out.suffix = pid,
                                           gene.idtype = "KEGG"))
sapply(pathway_ids, function(pid) pathview(gene.data = diff,
                                           pathway.id = pid,
                                           species = "ath",
                                           kegg.native=F,
                                           sign.pos="bottomleft",
                                           gene.annotpkg="org.At.tair.db",
                                           out.suffix = pid,
                                           gene.idtype = "KEGG"))



