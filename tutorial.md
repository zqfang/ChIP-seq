
### 1. NGS pipeline

Tips: run command in background
```bash
nohup command [options] &
```

Step 0: install software 
```bash
conda install -c bioconda bowtie2 samtools deeptools
```



step 1: build index
```bash
bowtie2-build hg38.fa index/hg38
```
step 2: mapping

Unpaired data
```bash
bowtiwe2 -p ${threads} -x index/hg38 \
         -U input.fastq.gz \
         -S ouput.sam
```

Paired data
```bash
bowtiwe2 -p 4 -x index/hg38 \
         -1 input_R1.fastq.gz \
         -2 input_R2.fastq.gz \
         -S ouput.sam
```


step 3: sam to bam
```bash
samtools view -Sbh  -q 25 \
              -@ ${threads}  \
              -o ouput.bam \
              input.sam

```

step 4: bam sort and index
```bash
samtools sort -@ ${threads} input.bam > output.sorted.bam 
samtools index input.sorted.bam #generate input.sorted.bam.bai

```

step 5: bam to bigwig

```bash
bamCoverage -p ${threads} \
            --normalizeUsing RPKM \ # note: other normalization options 
            --centerReads  \
            -e 200 \
            -b input.sorted.bam \
            -o output.bw

```


### 2. Down stream

#### ChIP-seq


**note:**: macs2 (>v2.2.x) supports python 3.
tools your
step 0: tools
```bash
conda install macs2 bedtools
```

step 1: callpeaks
(1) narrow peaks, e.g. TFs, h3k4m3
```bash
# bam file input
macs2 callpeak -t ChIP.elute.sorted.bam  \
               -c ChIP.input.sorted.bam \
               -f BAM \
               -g hs # organism \ 
               -B  -q 0.05 \
               -n  ${outFileName}\
               --outdir macs_out
```

(2) Broad peaks, e.g. h3k27me3


```bash
# sam file also works fine
macs2 callpeak -t ./bowtie_out/WTme2ChIP.sam  \
               -c ./bowtie_out/ESCInput.sam \
               -f SAM \
               -g mm \
               -B --SPMR \
               --nomodel --extsize 147 \
               --broad
               -n WTme2ChIP
               --outdir macs_out
```



step 2: advanced analysis

* tools: bedtools, deeptools, pyGenomeTracks, igv
* genome algebra
  - overlap with other peaks: bedtools
  -   
* visualization
  - heatmap: deeptools
  - signal tracks: pyGenomeTracks, igv

#### RNA-seq

```bash
conda install htseq 
```


step 1: count reads

```bash
htseq-count -r pos -s no \
            -f bam input.sorted.bam  gencode.gtf  > output.count

```

step2: differentially expressed genes analysis

Raw read counts 
DESeq2 in R

```R
libary(DESeq2)
DESeq()

```
