#!bin/sh

##
CTNNB_SKO_IP="bowtie_out/SK13-CTNNB-ChIP.highQuality.sorted.bw"
CTNNB_WT_IP="bowtie_out/WT-CTNNB-ChIP.highQuality.sorted.bw"
S21_WT_Input="bowtie_out/WT-S21-Input.highQuality.sorted.bw"
CTNNB_SKO_Input="bowtie_out/SK13-CTNNB-Input.highQuality.sorted.bw" 
CTNNB_WT_Input="bowtie_out/WT-CTNNB-Input.highQuality.sorted.bw"
S21_WT_IP="bowtie_out/WT-SOX21-ChIP.highQuality.sorted.bw"

region="macs_out/SOX21_peaks.narrowPeak"

#neural diff epigenome bigwigs dir
bwdir="/Volumes/G-DRIVE/public-seq/Neural_diff_roadmap/bowtie_out"

# hESCs 
h3k4me1="${bwdir}/SRR1608984.ESC_rep1_H3K4me1.highQuality.sorted.bw"
h3k4me3="${bwdir}/SRR1608985.ESC_rep1_H3K4me3.highQuality.sorted.bw"
h3k27ac="${bwdir}/SRR1608982.ESC_rep1_H3K27ac.highQuality.sorted.bw"
h3k27me3="${bwdir}/SRR1608983.ESC_rep1_H3K27me3.highQuality.sorted.bw"


# NPCs
nh3k4me1="${bwdir}/SRR1608993.NE_rep1_H3K4me1.highQuality.sorted.bw"
nh3k4me3="${bwdir}/SRR1608994.NE_rep1_H3K4me3.highQuality.sorted.bw"
nh3k27ac="${bwdir}/SRR1608991.NE_rep1_H3K27ac.highQuality.sorted.bw"
nh3k27me3="${bwdir}/SRR1608992.NE_rep1_H3K27me3.highQuality.sorted.bw"


### input bed files #################

tss="hg19.tss.bed"
#p300="GSM602291_ESC_hg19_p300_calls.bed"
#p300="GSM1003513_hg19_wgEncodeBroadHistoneH1hescP300kat3bPk.broadPeak"

#h3k4me3="FinalIDR_hESC_H3K4me3_macs2.regionPeak.narrowpeak"
#h3k4me3="GSM605316_UCSD.H9.H3K4me3.SK101.bed"

#h3k4me1="hESC_H3K4me1_peakSet_qval_005_FC_1_5.bed"
#h3k4me1="GSM667626_UCSD.H9.H3K4me1.YL123.bed"

#h3k27me3="hESC_H3K27me3_peakSet_qval_005_FC_1_5.bed"
#h3k27me3="GSM667622_UCSD.H9.H3K27me3.SK99.bed"

#h3k27ac="FinalIDR_hESC_H3K27ac_macs2.regionPeak.narrowpeak"
#h3k27ac="GSM605307_UCSD.H9.H3K27ac.YL237.bed"

#h3k27ac_diff="FinalIDR_NE_H3K27ac_macs2.regionPeak.narrowpeak"



## regions before and after the enhancer centers -a -b
# computeMatrix reference-point \
#           -S  ${h3k4me1} ${h3k4me3} ${h3k27me3} ${h3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_hESCs_histone.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESCs_histone.tab.gz \
#              -out SOX21.histone.hESCs.heatmap.pdf \
#              --colorMap Reds \
#             --whatToShow 'heatmap and colorbar' \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Peaks" \
#             --samplesLabel  h3k4me1 h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in hESCs" \
#             --kmeans 4 \
#             --boxAroundHeatmaps no \
#             --dpi 300 

# #NPC
# computeMatrix reference-point \
#           -S ${nh3k4me1} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_NPCs_histone.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_NPCs_histone.tab.gz \
#              -out SOX21.histone.NPCs.heatmap.pdf \
#              --colorMap Reds \
#              --whatToShow 'heatmap and colorbar' \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Peaks" \
#             --samplesLabel h3k4me1 h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in NPCs" \
#             --boxAroundHeatmaps no \
#             --dpi 300 


# ## regions before and after the enhancer centers -a -b
# computeMatrix reference-point \
#           -S  ${CTNNB_WT_IP} ${CTNNB_SKO_IP} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_CTNNB.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_CTNNB.tab.gz \
#              -out SOX21.CTNNB.heatmap.pdf \
#              --colorMap Reds \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Peaks" \
#             --samplesLabel  WT-CTNNB SKO-CTNNB \
#             --plotTitle "CTNNB Distribution" \
#             --boxAroundHeatmaps no 

#NPC
# computeMatrix reference-point \
#           -S ${S21_WT_IP} ${h3k4me1} ${h3k4me3} ${h3k27me3} ${h3k27ac} ${nh3k4me1} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_hESC2NPCs_histone.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.tab.gz \
#              -out SOX21.histone.hESC2NPCs.heatmap.pdf \
#              --colorMap Reds \
#              --whatToShow 'heatmap and colorbar' \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Peaks" \
#             --samplesLabel SOX21 h3k4me1 h3k4me3 h3k27me3 h3k27ac h3k4me1 h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in hESC to NPCs" \
#             --boxAroundHeatmaps no \
#             --dpi 600 
# NPC

region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.tss.bed"
computeMatrix reference-point \
          -S ${S21_WT_IP} ${h3k4me1} ${h3k4me3} ${h3k27me3} ${h3k27ac} ${nh3k4me1} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
          -R ${region} \
          --referencePoint center \
          -bs 50 \
          -a 5000 -b 5000 \
          -out matrix_SOX21_hESC2NPCs_histone.tss.tab.gz \
          --skipZeros 


plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.tss.tab.gz \
             -out SOX21.histone.hESC2NPCs.tss.heatmap.pdf \
             --colorMap Reds \
             --whatToShow 'heatmap and colorbar' \
            --heatmapHeight 15  \
            --refPointLabel center \
            --regionsLabel "SOX21 Peaks" \
            --samplesLabel SOX21 h3k4me1 h3k4me3 h3k27me3 h3k27ac h3k4me1 h3k4me3 h3k27me3 h3k27ac \
            --plotTitle "Histone modification in hESC to NPCs" \
            --boxAroundHeatmaps no \
            --dpi 600 
