
## loading packages
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
library(clusterProfiler)
library(ggplot2)
peakFile = "./macs_out_highQuality/NANOG_ChIP_peaks.narrowPeak"
peakFile2 = "./macs_out_highQuality/OCT4_ChIP_peaks.narrowPeak"
peak_nanog <- readPeakFile("./macs_out_highQuality/NANOG_ChIP_peaks.narrowPeak",header=0)
peak_oct4 <- readPeakFile("./macs_out_highQuality/OCT4_ChIP_peaks.narrowPeak",header=0)
peak_nanog

par(ps = 8, cex.axis = 0.2)
chrp = covplot(peak_oct4, weightCol="V5")


chrp = chrp+theme(text = element_text(size=12), axis.text.y  = element_text(size=6))
chrp

peakBoth = GenomicRanges::GRangesList(NANOG=readPeakFile(peakFile, header=0),
                                      OCT4=readPeakFile(peakFile2,header=0))

p <- covplot(peakBoth)
print(p)

p = p+theme(text = element_text(size=12), axis.text.y  = element_text(size=6))
p

ggsave("peaks-over-chromosomes.pdf")



peakAnno_nanog <- annotatePeak(peakFile, tssRegion=c(-3000, 3000),
                         TxDb=txdb, annoDb="org.Hs.eg.db")
peakAnno_oct4 <- annotatePeak(peakFile2, tssRegion=c(-3000, 3000),
                               TxDb=txdb, annoDb="org.Hs.eg.db")

par(ps = 12, cex = 2, cex.main = 1)
plotAnnoPie(peakAnno_nanog)
ggsave("NANOG.pie.pdf",device = 'pdf')

par(ps = 12, cex = 2, cex.main = 1)
plotAnnoPie(peakAnno_oct4)
ggsave("OCT4.pie.pdf",device = 'pdf')

help(ggsave)

options(repr.plot.width=5, repr.plot.height=3)
par(ps = 4, cex = .1, cex.main = .1)
plotAnnoBar(peakAnno_nanog)

ggsave("NANOG.bar.pdf",device = 'pdf',width = 5, height = 3)

options(repr.plot.width=5, repr.plot.height=5)
#par(ps = 1, cex = .1, cex.main = .1)
vennpie(peakAnno)
ggsave("NANOG.venn.pdf",device = 'pdf',width = 5, height = 3)

upsetplot(peakAnno_nanog)
upsetplot(peakAnno_oct4)
vennpie(peakAnno_nanog)
upsetplot(peakAnno_nanog, vennpie=TRUE)
upsetplot(peakAnno_oct4, vennpie=TRUE)

options(repr.plot.width=5, repr.plot.height=3)
#par(ps = 4, cex = .1, cex.main = .1)
plotDistToTSS(peakAnno,
              title="Distribution of transcription factor-binding loci\nrelative to TSS")

nanog = c(peakFile)
oct4 = c(peakFile2)
files = list(nanog=nanog, oct4=oct4)
files

peakAnnoList <- lapply(files, annotatePeak, TxDb=txdb,
                       tssRegion=c(-3000, 3000), verbose=FALSE)
plotAnnoBar(peakAnnoList)

options(repr.plot.width=5, repr.plot.height=3)
plotDistToTSS(peakAnnoList)

genes = lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
names(genes) = sub("_", "\n", names(genes))
compKEGG <- compareCluster(geneCluster   = genes,
                           fun           = "enrichKEGG",
                           pvalueCutoff  = 0.05,
                           pAdjustMethod = "BH")
plot(compKEGG, showCategory = 15, title = "KEGG Pathway Enrichment Analysis")

genes= lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
vennplot(genes)

help(par)

help(covplot)


