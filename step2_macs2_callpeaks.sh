#! bin/bash
mkdir -p macs_out_highQuality

#for transcription factor
macs2 callpeak -t ./bowtie_out/S486_03A_CHG020746-CHG021929-CGCTCATT_L003_R1.highQuality.sorted.bam  -c ./bowtie_out/S486_03A_CHG020744-ATTACTCG_L003_R1.highQuality.sorted.bam -f BAM -g hs --outdir macs_out_highQuality -n NANOG_ChIP  -B --SPMR --call-summits 
# --nomodel --extsize 220 

macs2 callpeak -t ./bowtie_out/S486_03A_CHG020747-CHG021930-GAGATTCC_L003_R1.highQuality.sorted.bam  -c ./bowtie_out/S486_03A_CHG020745-TCCGGAGA_L003_R1.highQuality.sorted.bam -f BAM -g hs --outdir macs_out_highQuality -n OCT4_ChIP  -B --SPMR --call-summits 
#--nomodel --extsize 220
#for histone
#macs2 callpeak -t ./bowtie_out/WTme2ChIP.sam  -c ./bowtie_out/ESCInput.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/KDme2ChIP.sam  -c ./bowtie_out/KDinput.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


