#!bin/sh

##
CTNNB_SKO_IP="bowtie_out/SK13-CTNNB-ChIP.highQuality.sorted.bw"
CTNNB_WT_IP="bowtie_out/WT-CTNNB-ChIP.highQuality.sorted.bw"
S21_WT_Input="bowtie_out/WT-S21-Input.highQuality.sorted.bw"
CTNNB_SKO_Input="bowtie_out/SK13-CTNNB-Input.highQuality.sorted.bw" 
CTNNB_WT_Input="bowtie_out/WT-CTNNB-Input.highQuality.sorted.bw"
S21_WT_IP="bowtie_out/WT-SOX21-ChIP.highQuality.sorted.bw"

region="macs_out/SOX21_peaks.narrowPeak"

## regions before and after the enhancer centers -a -b
computeMatrix reference-point \
          -S ${S21_WT_IP} ${CTNNB_WT_IP} ${CTNNB_SKO_IP} -R ${region} \
          --referencePoint center \
          -bs 50 \
          -a 3000 -b 3000 \
          -out matrix_SOX21_CTNNB_ChIP.tab.gz \
          --skipZeros 




plotHeatmap -m matrix_SOX21_CTNNB_ChIP.tab.gz \
             -out SOX21.CTNNB.heatmap.pdf \
             --colorMap Reds \ # Blues_r Greens
            --whatToShow 'heatmap and colorbar' \
            --heatmapHeight 15  \
            --refPointLabel center \
            --regionsLabel "SOX21 Peaks" \
            --samplesLabel "SOX21-WT" "CTNNB-WT" "CTNNB-S21KO" \
            --plotTitle 'SOX21 Peaks heatmap' \ #--kmeans 4 
            --boxAroundHeatmaps no 
