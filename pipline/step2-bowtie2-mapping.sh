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
outbamdir="bowtie_out"
mkdir -p ${outbamdir}
index="~/genome/Human_hg19/bowtie2Indexes_hg19/hg19"

threads=12
sample=(CHG023811 CHG023812 CHG023813 CHG023814 CHG023815 CHG023816)
sample_alias=(WT-CTNNB-ChIP WT-SOX21-ChIP SK13-CTNNB-ChIP WT-CTNNB-Input WT-S21-Input SK13-CTNNB-Input)

log "mapping start"
ls fastq_raw/*_1.fastq.gz | while read id;
do
      id3=${id%%_1.fastq.gz}
      id2=${id3##*/}
      (bowtie2 -p ${threads} -x ${index} -U ${id} | samtools view -Sbh -q 25 -@ ${threads}  -o ${outbamdir}/${id2}.highQuality.bam - ) 2> ${outbamdir}/${id2}.align.log

  done

log "keep the high mapping quality reads, and sorting"

ls ${outbamdir}/*bam | while read id;
do
    var=${id%%.highQuality.bam}
    samtools sort  -@ ${threads}  ${var}.highQuality.bam  > ${var}.highQuality.sorted.bam
    samtools index ${var}.highQuality.sorted.bam  
    log "sorting and index $var, finished"
done

#rm ../bowtie_out/*highQuality.bam
## firstly we just keep the high mapping quality reads according to ENCODE project guideline.
#samtools view -bhS -@ 12 -q 30  ${id%%.*}.sam > ${id%%.*}.highQuality.bam  
#samtools view -@ 6 -bhS -q 25 ./bowtie_out/${id%%.*}.sam | samtools sort -@ 6  -T ./bowtie_out/${id%%.*} > ./bowtie_out/${id%%.*}.highQuality.sorted.bam
## -F 1548 https://broadinstitute.github.io/picard/explain-flags.html 

# Often it is hard to see where you have data in IGV
# We have to zoom in to see it. It is handy to build
# a file that shows the coverage (bedgraph).
log "generating bigwig for igv"
ls ${outbamdir}/*.highQuality.sorted.bam | while read id;
do
#bedtools genomecov -ibam $id -g ~/genome/Human_hg19/hg19.chrom.sizes -split -bg |  sort -k1,1 -k2,2n  > ../bowtie_out/${id%%.bam}.bedgraph

# Bedgraph is inefficient for large files.
# What we typically use are so called bigWig files that are built to load much faster.
#bedGraphToBigWig ../bowtie_out/${id%%.bam}.bedgraph ~/genome/Human_hg19/hg19.chrom.sizes  ../bowtie_out/${id%%.bam}.bw

#use deeptools for easy useage
bamCoverage -b $id -e 200 --normalizeUsingRPKM --centerReads -o ${id%%.bam}.bw 
log "convert $id to bigwig, done!"

done

#rm ../bowtie_out/${id%%.bam}.bedgraph
log "all work done"

log "please proceed to peaks calling step"

