#!bin/sh
siteprot="/Users/bioninja/program/CEAS-Package-1.0.2/bin/sitepro"


peakbed=(macs_out/CT1.0-D4-SOX1_summits.bed macs_out/CT1.0-D8-SOX1_summits.bed macs_out/IWP2-D8-SOX1_summits.bed)
outname=(CT1.0-D4-SOX1 CT1.0-D8-SOX1 IWP2-D8-SOX1)
hisModifPath="/Volumes/G-DRIVE/public-seq/epigenome_roadmap/H9_cell_line"
wkdir="/Users/bioninja/projects/SOX1_ChIP"
h3k4me1BW="GSM667626_UCSD.H9.H3K4me1.YL123.bw"
h3k4me3BW="GSM605316_UCSD.H9.H3K4me3.SK101.bw"
h3k27me3BW="GSM667622_UCSD.H9.H3K27me3.SK99.bw"
h3k27acBW="GSM605307_UCSD.H9.H3K27ac.YL237.bw"

# for idx in 0 1 2
#     do 
#      sitepro --wig ${hisModifPath}/H3K4me1/${h3k4me1BW} --label H3K4me1 \
#                            --wig ${hisModifPath}/H3K4me3/${h3k4me3BW} --label H3K4me3 \
#                            --wig ${hisModifPath}/H3K27ac/${h3k27me3BW} --label H3K27ac \
#                            --wig ${hisModifPath}/H3K27me3/${h3k27me3BW} --label H3K27me3 \
#                            --bed ${peakbed[idx]} --name ${outname[idx]}
#     done

for idx in 0 1 2
    do 
     docker run -v ${hisModifPath}:/bw -v ${wkdir}:/data quay.io/biocontainers/ceas:1.0.2--py27_0 \
                   sitepro --wig /bw/H3K4me1/${h3k4me1BW} --label H3K4me1 \
                           --wig /bw/H3K4me3/${h3k4me3BW} --label H3K4me3 \
                           --wig /bw/H3K27ac/${h3k27acBW} --label H3K27ac \
                           --wig /bw/H3K27me3/${h3k27me3BW} --label H3K27me3 \
                           --bed /data/${peakbed[idx]} --name ${outname[idx]}
    done