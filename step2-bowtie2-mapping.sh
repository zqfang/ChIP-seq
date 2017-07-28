#!bin/zsh

# log
log () {
    echo
    echo "[`date`] Step: $1"
    echo
}


#fastqc
#log "fastqc"
#ls *.fq.gz | while read id ; do fastqc $id;done

#mkdir QC_results
#mv *zip *html QC_results/
 
#mapping to reference genome

log "bowtie2 mapping"
outbamdir=" ../bowtie_out"
mkdir -p ${outbamdir}
index="~/genome/Human_hg19/bowtie2Indexes_hg19/hg19"

threads=6
sample=(CHG023811 CHG023812 CHG023813 CHG023814 CHG023815 CHG023816)
sample_alias=(WT-CTNNB-ChIP WT-SOX21-ChIP SK13-CTNNB-ChIP WT-CTNNB-Input WT-S21-Input SK13-CTNNB-Input)


ch11r1=S548_12A_CHG023811-TCCGGAGA_L001_R1_paried.trim.fastq.gz
ch11r2=S548_12A_CHG023811-TCCGGAGA_L001_R2_paired.trim.fastq.gz
ch12r1=S548_12A_CHG023812-CGCTCATT_L001_R1_paried.trim.fastq.gz
ch12r2=S548_12A_CHG023812-CGCTCATT_L001_R2_paired.trim.fastq.gz
ch13r1=S548_12A_CHG023813-GAGATTCC_L001_R1_paried.trim.fastq.gz
ch13r2=S548_12A_CHG023813-GAGATTCC_L001_R2_paired.trim.fastq.gz

ch14r1=S556_06A_CHG023814-ATTCAGAA_L005_R1_paried.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L006_R1_paried.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L007_R1_paried.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L008_R1_paried.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L001_R1_paried.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L002_R1_paried.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L003_R1_paried.trim.fastq.gz
ch14r2=S556_06A_CHG023814-ATTCAGAA_L005_R2_paired.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L006_R2_paired.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L007_R2_paired.trim.fastq.gz,S556_06A_CHG023814-ATTCAGAA_L008_R2_paired.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L001_R2_paired.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L002_R2_paired.trim.fastq.gz,S556_06B_CHG023814-ATTCAGAA_L003_R2_paired.trim.fastq.gz
ch15r1=S550_10A_CHG023815-GAATTCGT_L007_R1_paried.trim.fastq.gz
ch15r2=S550_10A_CHG023815-GAATTCGT_L007_R2_paired.trim.fastq.gz
ch16r1=S556_06A_CHG023816-CTGAAGCT_L005_R1_paried.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L006_R1_paried.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L007_R1_paried.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L008_R1_paried.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L001_R1_paried.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L002_R1_paried.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L003_R1_paried.trim.fastq.gz
ch16r2=S556_06A_CHG023816-CTGAAGCT_L005_R2_paired.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L006_R2_paired.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L007_R2_paired.trim.fastq.gz,S556_06A_CHG023816-CTGAAGCT_L008_R2_paired.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L001_R2_paired.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L002_R2_paired.trim.fastq.gz,S556_06B_CHG023816-CTGAAGCT_L003_R2_paired.trim.fastq.gz

log "mapping start"

(bowtie2 -p ${threads} -x ${index} -1 $ch11r1 -2 $ch11r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023811.highQuality.bam - ) 2> ${outbamdir}/CHG023811.align.log
(bowtie2 -p ${threads} -x ${index} -1 $ch12r1 -2 $ch12r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023812.highQuality.bam - ) 2> ${outbamdir}/CHG023812.align.log
(bowtie2 -p ${threads} -x ${index} -1 $ch13r1 -2 $ch13r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023813.highQuality.bam - ) 2> ${outbamdir}/CHG023813.align.log
(bowtie2 -p ${threads} -x ${index} -1 $ch14r1 -2 $ch14r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023814.highQuality.bam - ) 2> ${outbamdir}/CHG023814.align.log
(bowtie2 -p ${threads} -x ${index} -1 $ch15r1 -2 $ch15r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023815.highQuality.bam - ) 2> ${outbamdir}/CHG023815.align.log
(bowtie2 -p ${threads} -x ${index} -1 $ch16r1 -2 $ch16r2 | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/CHG023816.highQuality.bam - ) 2> .${outbamdir}/CHG023816.align.log



log "keep the high mapping quality reads, and sorting"

for var in ${sample_alias[@]}
do
    
    samtools sort  -@ 6  ${outbamdir}/${var}.highQuality.bam  > ${outbamdir}/${var}.highQuality.sorted.bam
    samtools index ${outbamdir}/${var}.highQuality.sorted.bam  
    log "sorting and index $var, finished"
done

#samtools sort  -@ 6  ../bowtie_out/CHG023816.highQuality.bam  > ../bowtie_out/CHG023816.highQuality.sorted.bam
#samtools index ../bowtie_out/CHG023816.highQuality.sorted.bam

#rm ../bowtie_out/*highQuality.bam
## firstly we just keep the high mapping quality reads according to ENCODE project guideline.
#samtools view -bhS -@ 12 -q 30  ${id%%.*}.sam > ${id%%.*}.highQuality.bam  
#samtools view -@ 6 -bhS -q 25 ./bowtie_out/${id%%.*}.sam | samtools sort -@ 6  -T ./bowtie_out/${id%%.*} > ./bowtie_out/${id%%.*}.highQuality.sorted.bam
## -F 1548 https://broadinstitute.github.io/picard/explain-flags.html 
#samtools sort -@ 12  ${id%%.*}.highQuality.bam ${id%%.*}.highQuality.sorted  ## prefix for the output   


## Then we just keep the unique mapping reads according to the majority tutorial.
#grep -v "XS:i:" ./bowtie_out/${id%%.*}.sam | samtools view -bhS -@ 6  > ./bowtie_out/${id%%.*}.unique.bam
#samtools sort  -@ 6  ./bowtie_out/${id%%.*}.unique.bam > ./bowtie_out/${id%%.*}.unique.sorted.bam  ## prefix for the output   
#samtools index ./bowtie_out/${id%%.*}.unique.sorted.bam 

# Often it is hard to see where you have datain IGV
# We have to zoom in to see it. It is handy to build
# a file that shows the coverage (bedgraph).

log "generating bigwig for igv"
ls ${outbamdir}/*.highQuality.sorted.bam | while read id;
do
#bedtools genomecov -ibam $id -g ~/genome/Human_hg19/hg19.chrom.sizes -split -bg |  sort -k1,1 -k2,2n  > ../bowtie_out/${id%%.bam}.bedgraph

# Bedgraph is inefficient for large files.
# What we typically use are so called bigWig files that are built to load much faster.
#bedGraphToBigWig ../bowtie_out/${id%%.bam}.bedgraph ~/genome/Human_hg19/hg19.chrom.sizes  ../bowtie_out/${id%%.bam}.bw

bamCoverage -b $id -e 200 --normalizeUsingRPKM -o ${outbamdir}/${id%%.bam}.bw 

done

#rm ../bowtie_out/${id%%.bam}.bedgraph
log "all work done"

#for transcription factor
#macs2 callpeak -t ./bowtie_out/ESC_Jmjd1c_ChIP.sam  -c ./bowtie_out/ESC_input.sam -f SAM -g mm --outdir macs_out -n ESC_Jmjd1c_ChIP -B --SPMR --call-summits -q 0.1
#for histone
#macs2 callpeak -t ./bowtie_out/ESC_H3K9me2_ChIP.sam  -c ./bowtie_out/ESC_input.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/Jmjd1c_KD_H3K9me2_ChIP.sam  -c ./bowtie_out/Jmjd1c_KD_input.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


