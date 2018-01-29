
mkdir -p peaks_anno
mkdir -p peaks_anno_nomodel


find macs_out -name "*.bed" | while read var;
do
    sname=${var##*/}
    snprefix=${sname%%_summits.bed}
    mkdir -p peaks_anno_nomodel/${snprefix}.GO
    annotatePeaks.pl ${var} hg19 -go peaks_anno/${snprefix}.GO > peaks_anno/${snprefix}.peaksAnnotate.txt

done

find macs_out_nomodel -name "*.bed" | while read var;
do
    sname=${var##*/}
    snprefix=${sname%%_summits.bed}
    mkdir -p peaks_anno_nomodel/${snprefix}.GO
    annotatePeaks.pl ${var} hg19 -go peaks_anno_nomodel/${snprefix}.GO > peaks_anno_nomodel/${snprefix}.peaksAnnotate.txt

done