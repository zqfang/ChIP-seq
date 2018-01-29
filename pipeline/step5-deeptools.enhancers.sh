#!bin/sh

### extract enhancers and promoters peaks ####


### promoters

# regions contains -a only
# bedtools window -a hg19.tss.bed \
#                 -b macs_out_q0.01/SOX21_peaks.narrowPeak \
#                 -w 2000 -u > enhancers/SOX21.peaks.tss.bed
# # regions contains -a -b, need cut
# bedtools window -a hg19.tss.bed \
#                  -b macs_out_q0.01/SOX21_peaks.narrowPeak \
#                  -w 2000  > enhancers/SOX21.peaks.2kb.window.tss.bed
# # get -b regions
# cut -f 7- SOX21.peaks.2kb.window.tss.bed > SOX21.peaks.only.2kb.tss.bed


# ### ehancers

# # get enhancers by subtracting tss regions
# bedtools subtract -a ../macs_out_q0.01/SOX21_peaks.narrowPeak \
#                    -b SOX21.peaks.only.2kb.tss.bed \
#                     > SOX21.peaks.only.enhancers.bed

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


# region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.tss.bed"

# computeMatrix reference-point \
#           -S ${S21_WT_IP} ${h3k4me1} ${h3k4me3} ${h3k27me3} ${h3k27ac} ${nh3k4me1} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 3000 -b 3000 \
#           -out matrix_SOX21_hESC2NPCs_histone.tss.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.tss.tab.gz \
#              -out SOX21.histone.hESC2NPCs.tss.heatmap.pdf \
#              --colorMap Reds \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Promoter Peaks" \
#             --samplesLabel SOX21 h3k4me1 h3k4me3 h3k27me3 h3k27ac h3k4me1 h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in hESC to NPCs" \
#             --boxAroundHeatmaps no \
#             --dpi 600 

# region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.only.enhancers.bed"

# computeMatrix reference-point \
#           -S ${S21_WT_IP} ${h3k4me1} ${h3k4me3} ${h3k27me3} ${h3k27ac} ${nh3k4me1} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_hESC2NPCs_histone.enhancers.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.enhancers.tab.gz \
#              -out SOX21.histone.hESC2NPCs.enhancers.heatmap.pdf \
#              --colorMap Reds \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Enhancer Peaks" \
#             --samplesLabel SOX21 h3k4me1 h3k4me3 h3k27me3 h3k27ac h3k4me1 h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in hESC to NPCs" \
#             --boxAroundHeatmaps no \
#             --kmeans 2 \
#             --dpi 600 


# region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.tss.bed"

# computeMatrix reference-point \
#           -S ${S21_WT_IP}  ${h3k4me3} ${h3k27me3} ${nh3k4me3} ${nh3k27me3}  \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 3000 -b 3000 \
#           -out matrix_SOX21_hESC2NPCs_histone.tss.bivalent.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.tss.bivalent.tab.gz \
#              -out SOX21.histone.hESC2NPCs.tss.bivalent.heatmap.pdf \
#              --colorMap Reds \
#             --heatmapHeight 15  \
#             --refPointLabel TSS \
#             --regionsLabel "SOX21 Promoter Peaks" \
#             --samplesLabel SOX21 h3k4me3 h3k27me3 h3k4me3 h3k27me3  \
#             --plotTitle "Histone modification in hESC to NPCs" \
#             --boxAroundHeatmaps no \
#             --dpi 600 

# region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.only.enhancers.bed"

# computeMatrix reference-point \
#           -S ${S21_WT_IP} ${h3k4me1} ${h3k27me3} ${h3k27ac} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
#           -R ${region} \
#           --referencePoint center \
#           -bs 50 \
#           -a 5000 -b 5000 \
#           -out matrix_SOX21_hESC2NPCs_histone.enhancers.2.tab.gz \
#           --skipZeros 


# plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.enhancers.2.tab.gz \
#              -out SOX21.histone.hESC2NPCs.enhancers.2.heatmap.pdf \
#              --colorMap Reds \
#             --heatmapHeight 15  \
#             --refPointLabel center \
#             --regionsLabel "SOX21 Enhancer Peaks" \
#             --samplesLabel SOX21 h3k4me1 h3k27me3 h3k27ac h3k4me3 h3k27me3 h3k27ac \
#             --plotTitle "Histone modification in hESC to NPCs" \
#             --boxAroundHeatmaps no \
#             --dpi 600 



region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.tss.bed"

computeMatrix reference-point \
          -S ${S21_WT_IP} ${h3k4me3} ${h3k27me3} ${h3k27ac} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
          -R ${region} \
          --referencePoint center \
          -bs 50 \
          -a 3000 -b 3000 \
          -out matrix_SOX21_hESC2NPCs_histone.tss.bivalent.2.tab.gz \
          --skipZeros 


plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.tss.bivalent.2.tab.gz \
             -out SOX21.histone.hESC2NPCs.tss.bivalent.2.heatmap.pdf \
             --colorMap Reds \
             --whatToShow 'heatmap and colorbar' \
            --heatmapHeight 15  \
            --refPointLabel TSS \
            --regionsLabel "SOX21 Promoter Peaks" \
            --samplesLabel SOX21 h3k4me3 h3k27me3 h3k27ac h3k4me3 h3k27me3 h3k27ac  \
            --plotTitle "Histone modification in hESC to NPCs" \
            --boxAroundHeatmaps no \
            --dpi 600 





region="/Users/bioninja/projects/SOX21_ChIP/enhancers/SOX21.peaks.only.enhancers.bed"

computeMatrix reference-point \
          -S ${S21_WT_IP} ${h3k4me1} ${h3k27me3} ${h3k27ac} ${nh3k4me3} ${nh3k27me3} ${nh3k27ac} \
          -R ${region} \
          --referencePoint center \
          -bs 50 \
          -a 5000 -b 5000 \
          -out matrix_SOX21_hESC2NPCs_histone.enhancers.3.tab.gz \
          --skipZeros 


plotHeatmap -m matrix_SOX21_hESC2NPCs_histone.enhancers.3.tab.gz \
             -out SOX21.histone.hESC2NPCs.enhancers.3.heatmap.pdf \
             --colorMap Reds \
            --heatmapHeight 15  \
            --refPointLabel center \
            --whatToShow 'heatmap and colorbar' \
            --regionsLabel "SOX21 Enhancer Peaks" \
            --samplesLabel SOX21 h3k4me1 h3k27me3 h3k27ac h3k4me1 h3k27me3 h3k27ac \
            --plotTitle "Histone modification in hESC to NPCs" \
            --boxAroundHeatmaps no \
            --dpi 600 