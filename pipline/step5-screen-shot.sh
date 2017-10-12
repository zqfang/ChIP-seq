#!bin/sh

##
CTNNB_SKO_IP="bowtie_out/SK13-CTNNB-ChIP.highQuality.sorted.bw"
CTNNB_WT_IP="bowtie_out/WT-CTNNB-ChIP.highQuality.sorted.bw"
S21_WT_Input="bowtie_out/WT-S21-Input.highQuality.sorted.bw"
CTNNB_SKO_Input="bowtie_out/SK13-CTNNB-Input.highQuality.sorted.bw" 
CTNNB_WT_Input="bowtie_out/WT-CTNNB-Input.highQuality.sorted.bw"
S21_WT_IP="bowtie_out/WT-SOX21-ChIP.highQuality.sorted.bw"

# WNT1 chr12:49,371,258-49,382,975
fluff profile -i chr12:49371258-49382975 -d ${CTNNB_WT_IP} ${CTNNB_SKO_IP} ${S21_WT_IP} -a ~/genome/rseqc_ann/hg19_RefSeq.bed  -s -o WNT1.pdf 
