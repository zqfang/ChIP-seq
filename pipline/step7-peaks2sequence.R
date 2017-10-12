## usage: Rscript  peakView.R  peaks.bed  IP.sorted.bam  input.sorted.bam  10
#options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 1 ){
	print(" usage: Rscript  peakAnno.R  peaks.bed ")
}

bedPeaksFile 		= args[1] ;
#bedPeaksFile 		= 'Hek-Ip_peaks.bed'; 

#bedFiles=list.files(pattern = '*bed')
# [1] "BAF180_CT10_summits.bed"    "BAF180_CT22_summits.bed"   
# [3] "BAF180_CT22AM_summits.bed"  "SRC2mutREV-ERB_summits.bed"
# [5] "WT_REV-ERB_summits.bed"  
library(BSgenome.Hsapiens.UCSC.hg19)

bedPeaksFile=bedFiles[2]
sampleName=strsplit(bedPeaksFile,'\\.')[[1]][1]
peak <- toGRanges(bedPeaksFile, format="BED") 
keepChr= !grepl('_',seqlevels(peak))
seqlevels(peak, force=TRUE) <- seqlevels(peak)[keepChr]

seq <- getAllPeakSequence(peak, upstream=20, downstream=20, genome=Hsapiens)

write2FASTA(seq,  paste0(sampleName,'.fa'))