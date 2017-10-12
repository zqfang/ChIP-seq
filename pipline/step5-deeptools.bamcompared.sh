bamCompare  -b1 treatment.bam -b2 control.bam -o log2ratio.bw
bamCoverage -b test.bam -o test.bw
## both -R and -S can accept multiple files
computeMatrix reference-point  --referencePoint TSS   -b 10000 -a 10000    \
                              -R ~/annotation/CHIPseq/mm10/ucsc.refseq.bed  \
                              -S  test.bw  --skipZeros  -o matrix1_test_TSS.gz  \
                              --outFileSortedRegions regions1_test_genes.bed
##  both plotHeatmap and plotProfile will use the output from   computeMatrix
plotHeatmap -m matrix1_test_TSS.gz  -out test.png
plotHeatmap -m matrix1_test_TSS.gz  -out test.pdf --plotFileFormat pdf  --dpi 720
plotProfile -m matrix1_test_TSS.gz  -out test.png
plotProfile -m matrix1_test_TSS.gz  -out test.pdf --plotFileFormat pdf --perGroup --dpi 720
multiBigwigSummary bins -b *.bw  -out scores_per_bin.npz --outRawCounts scores_per_bin.tab
multiBamSummary  bins -b *.bam  -out scores_per_bin.npz --outRawCounts scores_per_bin.tab
## both plotCorrelation and plotPCA will use the output from  multiBamSummary or multiBigwigSummary.
plotPCA -in scores_per_bin.npz  -o PCA_readCounts.png
## most of time, we don't need plotCoverage and computeGCBias,while both of them use the sorted bam file as input
plotCorrelation -in scores_per_bin.npz  \
                --corMethod pearson --skipZeros  --whatToPlot scatterplot \
                -o scatterplot_PearsonCorr_bigwigScores.png
                plotCorrelation -in scores_per_bin.npz  \
                --corMethod pearson --skipZeros    \
                --whatToPlot heatmap --colorMap RdYlBu --plotNumbers \
                -o heatmap_SpearmanCorr_readCounts.png   \
                --outFileCorMatrix SpearmanCorr_readCounts.tab
