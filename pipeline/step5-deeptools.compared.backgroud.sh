#!bin/sh

CTNNB_SKO_IP="bowtie_out/SK13-CTNNB-ChIP.highQuality.sorted.bw"
CTNNB_WT_IP="bowtie_out/WT-CTNNB-ChIP.highQuality.sorted.bw"
S21_WT_Input="bowtie_out/WT-S21-Input.highQuality.sorted.bw"
CTNNB_SKO_Input="bowtie_out/SK13-CTNNB-Input.highQuality.sorted.bw"
CTNNB_WT_Input="bowtie_out/WT-CTNNB-Input.highQuality.sorted.bw"
S21_WT_IP="bowtie_out/WT-SOX21-ChIP.highQuality.sorted.bw"

region="macs_out/SOX21_peaks.narrowPeak"

#neural diff epigenome bigwigs dir
bwdir="/Users/bioninja/projects/SOX21_ChIP/bigwig_out"
bamdir="/Users/bioninja/projects/SOX21_ChIP/bowtie_out"

mkdir -p $bwdir

#for samp in WT-CTNNB SK13-CTNNB WT-SOX21
#do

# bamCompare  -b1 ${bamdir}/SK13-CTNNB-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/SK13-CTNNB-Input.highQuality.sorted.bam \
#             --normalizeUsingRPKM --ratio subtract \
#             -o ${bwdir}/SK13-CTNNB.subtract.bw
# bamCompare  -b1 ${bamdir}/WT-CTNNB-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/WT-CTNNB-Input.highQuality.sorted.bam \
#             --normalizeUsingRPKM --ratio subtract \
#             -o ${bwdir}/WT-CTNNB.subtract.bw
# bamCompare  -b1 ${bamdir}/WT-SOX21-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/WT-S21-Input.highQuality.sorted.bam \
#             --normalizeUsingRPKM --ratio subtract \
#             -o ${bwdir}/WT-SOX21.subtract.bw
# #done
# bamCompare  -b1 ${bamdir}/SK13-CTNNB-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/SK13-CTNNB-Input.highQuality.sorted.bam \
#             -o ${bwdir}/SK13-CTNNB.log2ratio.bw
# bamCompare  -b1 ${bamdir}/WT-CTNNB-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/WT-CTNNB-Input.highQuality.sorted.bam \
#             -o ${bwdir}/WT-CTNNB.log2ratio.bw
# bamCompare  -b1 ${bamdir}/WT-SOX21-ChIP.highQuality.sorted.bam \
#             -b2 ${bamdir}/WT-S21-Input.highQuality.sorted.bam \
#             -o ${bwdir}/WT-SOX21.log2ratio.bw

deptdir="deeptools_out"
mkdir -p ${deptdir}
region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.tss.bed"
region2="/Users/bioninja/projects/SOX21_ChIP/macs_out/SOX21_summits.bed"
computeMatrix reference-point \
          -S  ${S21_WT_Input} ${S21_WT_IP}\
          -R ${region2} \
          --referencePoint center \
          -bs 50 \
          -a 3000 -b 3000 \
          -out ${deptdir}/matrix_SOX21_peaks.tab.gz \
          --skipZeros


## make one image per BED file instead of per bigWig file, -perGroup
plotProfile -m ${deptdir}/matrix_SOX21_peaks.tab.gz \
            --refPointLabel center \
            --perGroup \
            -out ${deptdir}/matrix_SOX21_peaks.profile.pdf


computeMatrix reference-point \
          -S  ${bwdir}/WT-CTNNB.subtract.bw ${bwdir}/SK13-CTNNB.subtract.bw \
          -R ${region2} \
          --referencePoint center \
          -bs 50 \
          -a 3000 -b 3000 \
          -out ${deptdir}/matrix_CTNNB_profile.subtract.around.SOX21.tab.gz \
          --skipZeros

plotProfile -m ${deptdir}/matrix_CTNNB_profile.subtract.around.SOX21.tab.gz \
            --refPointLabel center \
            --perGroup \
            -out ${deptdir}/matrix_CTNNB_profile.subtract.around.SOX21.profile.pdf



plotHeatmap -m ${deptdir}/matrix_CTNNB_profile.subtract.around.SOX21.tab.gz \
             -out ${deptdir}/matrix_CTNNB_profile.subtract.around.SOX21.heatmap.pdf \
             --colorMap Reds \
            --heatmapHeight 15  \
            --refPointLabel center \
            --regionsLabel "SOX21 Peaks" \
            --samplesLabel WT SOX21KO \
            --whatToShow "heatmap and colorbar" \
            --plotTitle "CTNNB Profile in SOX21 KO cells" \
            --boxAroundHeatmaps no \
            --dpi 600
