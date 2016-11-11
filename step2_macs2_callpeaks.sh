#! bin/bash
mkdir -p macs_out_highQuality

#for transcription factor
macs2 callpeak -t ./bowtie_out/clip_trim_q20_CT10ChIP.highQuality.sorted.bam  -c ./bowtie_out/clip_trim_q20_CT10Input.highQuality.sorted.bam -f BAM -g hs --outdir macs_out_highQuality -n SOX1_CT1.0_ChIP -B --SPMR --call-summits --nomodel --extsize 220 

macs2 callpeak -t ./bowtie_out/clip_trim_q20_S2iDiffChIP.highQuality.sorted.bam  -c ./bowtie_out/clip_trim_q20_S2iDiffInput.highQuality.sorted.bam -f BAM -g hs --outdir macs_out_highQuality -n SOX21_2i_ChIP -B --SPMR --call-summits --nomodel --extsize 220
#for histone
#macs2 callpeak -t ./bowtie_out/WTme2ChIP.sam  -c ./bowtie_out/ESCInput.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/KDme2ChIP.sam  -c ./bowtie_out/KDinput.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


