#
## usage: Rscript  peakView.R  peaks.bed  IP.sorted.bam  input.sorted.bam  10
#options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
if(length(args) == 0 ){
    print("Required args missing !!!")
    print(" usage: Rscript  beta-input-from-deseq2.R  input.deseq2.txt outdir")
    quit(save = "no", status = 1, runLast = FALSE)  
}

deseq2File = args[1]
outdir=args[2]

suppressMessages(library("org.Hs.eg.db"))
#library('EnsDb.Hsapiens.v86')

degs <- read.table(deseq2File, row.names = 1, stringsAsFactors = F)
rownames(degs) <- gsub('\\.[0-9]+', '', rownames(degs))
anno_cols=c( "TXBIOTYPE","ENTREZID","SYMBOL") #column=anno_cols[i],
maps_anno2 <- mapIds(org.Hs.eg.db, keys = rownames(degs), column="SYMBOL",
                    keytype =  "ENSEMBL" , multiVals = "first")  
degs_new <- cbind(maps_anno2, degs)
names(degs_new)[1] = 'GeneName'
#degs should not contains na values, or beta-plus will no work
degs_new2 = na.omit(degs_new)
#degs_new2 = degs_new[complete.cases(degs_new[ , 1]),]

outname = gsub(".txt",".genename.txt", deseq2File)
#set row.names = F, or the args in beta-plus --info should set to 2,4,8
# and remove header, seq='\t'
write.table(degs_new2, file=paste(outdir,outname,sep="/"),
            row.names = F, col.names=F, sep='\t', quote = F, na="")