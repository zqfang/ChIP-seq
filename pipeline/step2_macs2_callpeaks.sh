#! bin/bash
#for transcription factor
# log
log () {
    echo
    echo "[`date`] Step: $1"
    echo
}

treat=(CT1-0-D4-soxlchip CT1-0-d8-elute_combined_R1 IWP2-d8-elute_combined_R1)
input=(CT1-0-D4-input CT1-0-d8-input_combined_R1 IWP2-d8-input_combined_R1)
name=(CT1.0-D4-SOX1 CT1.0-D8-SOX1 IWP2-D8-SOX1)
outdir="macs_out"
outdir2="macs_out_nomodel"


chrominfo="/Users/bioninja/genome/Human_hg19/hg19.chrom.sizes"
mkdir -p $outdir
mkdir -p $outdir2

for idx in 0 1 2  
    do
        #default parameters, add --call-summits if needed
        #macs2 callpeak -t ./bowtie_out/${treat[idx]}.highQuality.sorted.bam  -c ./bowtie_out/${input[idx]}.highQuality.sorted.bam -f BAM -g hs --outdir ${outdir} -n ${name[idx]} -B  -q 0.05
        # --nomodel
        #macs2 callpeak -t ./bowtie_out/${treat[idx]}.highQuality.sorted.bam  -c ./bowtie_out/${input[idx]}.highQuality.sorted.bam -f BAM -g hs --outdir ${outdir2} -n ${name[idx]} -B -q 0.05 --nomodel --extsize 200 
        echo $idx
done



find . -name "*.bdg" | while read var;
do
    log "convert bdg to bw, $var"
    LC_COLLATE=C sort -k1,1 -k2,2n $var > ${var}.sorted 
    bash step3_bigwig_coversion_from_macs2_bdg.sh ${var}.sorted $chrominfo 
done

find . -name "*bdg.sorted" | xargs rm
log "bw conversion done"

#for histone
#macs2 callpeak -t ./bowtie_out/WTme2ChIP.sam  -c ./bowtie_out/ESCInput.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/KDme2ChIP.sam  -c ./bowtie_out/KDinput.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


