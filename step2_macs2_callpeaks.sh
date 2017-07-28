#! bin/bash
#for transcription factor
# log
log () {
    echo
    echo "[`date`] Step: $1"
    echo
}

sample=(CHG023811 CHG023812 CHG023813 CHG023814 CHG023815 CHG023816)
sample_alias=(WT-CTNNB-ChIP WT-SOX21-ChIP SK13-CTNNB-ChIP WT-CTNNB-Input WT-S21-Input SK13-CTNNB-Input)




treat=(WT-CTNNB-ChIP WT-SOX21-ChIP SK13-CTNNB-ChIP)
input=(WT-CTNNB-Input WT-S21-Input SK13-CTNNB-Input)
name=(WT-CTNNB SOX21 SK13-CTNNB)
outdir="macs_out_q0.01"
outdir2="macs_out_nomodel"


chrominfo="/Users/bioninja/genome/Human_hg19/hg19.chrom.sizes"
mkdir -p $outdir
mkdir -p $outdir2

for idx in 0 1 2  
    do
        #default parameters, add --call-summits if needed, use -f BAMPE for paired reads
        macs2 callpeak -t ./bowtie_out/${treat[idx]}.highQuality.sorted.bam  -c ./bowtie_out/${input[idx]}.highQuality.sorted.bam -f BAMPE -g hs --outdir ${outdir} -n ${name[idx]} -B  -q 0.01
        # --nomodel
        #macs2 callpeak -t ./bowtie_out/${treat[idx]}.highQuality.sorted.bam  -c ./bowtie_out/${input[idx]}.highQuality.sorted.bam -f BAMPE -g hs --outdir ${outdir2} -n ${name[idx]} -B -q 0.05 --nomodel --extsize 200 
        echo $idx
done



find . -name "*.bdg" | while read var;
do
    log "convert bdg to bw, $var"
    svar=${var%%.bdg}
    LC_COLLATE=C sort -k1,1 -k2,2n $var > ${svar}.sorted.bdg
    bash step3_bigwig_coversion_from_macs2_bdg.sh ${svar}.sorted.bdg $chrominfo 
done

find . -name "*.sorted.bdg" | xargs rm
log "bw conversion done"

#for histone
#macs2 callpeak -t ./bowtie_out/WTme2ChIP.sam  -c ./bowtie_out/ESCInput.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/KDme2ChIP.sam  -c ./bowtie_out/KDinput.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


