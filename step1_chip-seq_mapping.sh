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
mkdir -p bowtie_out

ls *.fastq.gz | while read id ; 
## if you do change the fq files by fastx tools, you need to ls *_clean.fq.gz
do  
echo $id
bowtie2 -p 12  -x ~/genome/bowtie2_index_hg19/hg19  -U $id -S ./bowtie_out/${id%%.*}.sam  2> ./bowtie_out/${id%%.*}.align.log;


log "keep the high mapping quality reads, and sorting"

## firstly we just keep the high mapping quality reads according to ENCODE project guideline.
#samtools view -bhS -@ 12 -q 30  ${id%%.*}.sam > ${id%%.*}.highQuality.bam  
samtools view -@ 6 -bhS -q 30 ./bowtie_out/${id%%.*}.sam | samtools sort -@ 6  -T ./bowtie_out/${id%%.*} > ./bowtie_out/${id%%.*}.highQuality.sorted.bam
## -F 1548 https://broadinstitute.github.io/picard/explain-flags.html 
#samtools sort -@ 12  ${id%%.*}.highQuality.bam ${id%%.*}.highQuality.sorted  ## prefix for the output   
samtools index ./bowtie_out/${id%%.*}.highQuality.sorted.bam 

## Then we just keep the unique mapping reads according to the majority tutorial.
grep -v "XS:i:" ./bowtie_out/${id%%.*}.sam | samtools view -bhS -@ 6  > ./bowtie_out/${id%%.*}.unique.bam
samtools sort  -@ 6  ./bowtie_out/${id%%.*}.unique.bam > ./bowtie_out/${id%%.*}.unique.sorted.bam  ## prefix for the output   
samtools index ./bowtie_out/${id%%.*}.unique.sorted.bam 

echo "done with sam sorting", $id

done



# Often it is hard to see where you have datain IGV
# We have to zoom in to see it. It is handy to build
# a file that shows the coverage (bedgraph).

log "generating bigwig for igv"
ls bowtie_out/*.highQuality.sorted.bam | while read id;
do
bedtools genomecov -ibam $id -g ~/genome/hg19/hg19.chrom.sizes -split -bg |  sort -k1,1 -k2,2n  > bowtie_out/${id%%.*}.highQuality.sorted.bedgraph


# Bedgraph is inefficient for large files.
# What we typically use are so called bigWig files that are built to load much faster.
bedGraphToBigWig ./bowtie_out/${id%%.*}.highQuality.sorted.bedgraph ~/genome/hg19/hg19.chrom.sizes  bowtie_out/${id%%.*}.highQuality.bw
done

log "all work done"

#for transcription factor
#macs2 callpeak -t ./bowtie_out/ESC_Jmjd1c_ChIP.sam  -c ./bowtie_out/ESC_input.sam -f SAM -g mm --outdir macs_out -n ESC_Jmjd1c_ChIP -B --SPMR --call-summits -q 0.1
#for histone
#macs2 callpeak -t ./bowtie_out/ESC_H3K9me2_ChIP.sam  -c ./bowtie_out/ESC_input.sam -f SAM -g mm --outdir macs_out -n WTme2ChIP -B --SPMR --nomodel --extsize 147 --broad

#macs2 callpeak -t ./bowtie_out/Jmjd1c_KD_H3K9me2_ChIP.sam  -c ./bowtie_out/Jmjd1c_KD_input.sam -f SAM -g mm --outdir macs_out -n KDme2ChIP -B --SPMR --nomodel --extsize 147 --broad


