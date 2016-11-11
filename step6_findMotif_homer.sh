#!bin/bash
awk '{print $4"\t"$1"\t"$2"\t"$3"\t+"}' ./macs_out/CT1.0_ChIP_summits.bed  > ./findMotif/s1_homer_peaks.bed
awk '{print $4"\t"$1"\t"$2"\t"$3"\t+"}' ./macs_out/2i_ChIP_summits.bed  > ./findMotif/s21_homer_peaks.bed

findMotifsGenome.pl ./findMotif/s1_homer_peaks.bed hg19 ./findMotif/SOX1_motif -len 8,10,12
findMotifsGenome.pl ./findMotif/s21_homer_peaks.bed hg19 ./findMotif/SOX21_motif -len 8,10,12
#annotatePeaks.pl    s21_homer_peaks.bed hg19 1>peakAnn.xls 2>annLog.txt    #-go GODir


