#!bin/bash
awk '{print $4"\t"$1"\t"$2"\t"$3"\t+"}' ./macs_out_highQuality/NANOG_ChIP_peaks.narrowPeak  > ./findMotif/NANOG_homer_peaks.bed
awk '{print $4"\t"$1"\t"$2"\t"$3"\t+"}' ./macs_out_highQuality/OCT4_ChIP_peaks.narrowPeak  > ./findMotif/OTC4_homer_peaks.bed

findMotifsGenome.pl ./findMotif/NANOG_homer_peaks.bed hg19 ./findMotif/NANOG_motif -len 8,10,12 -fdr 100 -p 6 -size given
findMotifsGenome.pl ./findMotif/OCT4_homer_peaks.bed hg19 ./findMotif/OCT4_motif -len 8,10,12 -fdr 100 -p 6 -size given
#annotatePeaks.pl    sox21_homer_peaks.bed hg19 1>peakAnn.xls 2>annLog.txt    #-go GODir


