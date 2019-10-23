
## Fast NGS
Make bioinfo uncool again

### 1. Linux command line 

a. OhMyZsh, make terminal cool
```bash
# install zsh
sudo apt-get install zsh # ubuntu
# change default shell to zsh
chsh -s /usr/bin/zsh
# install ohmyzsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

source ~/.zshrc
```

b. Terminal keyboard short cuts  
- skip to head: `Ctrl + a`  
- skip to end: `Ctrl + e`  
- delete whole line: `Ctrl + u`


c. Tips for command line  

* run cmd in background
```bash
nohup command [options] &
```
* some handy tricks for handling filepath

```bash
# e.g.
var=./home/fastq/filename_R1.fq.gz

# extract filename
var1=${var##*/} 
## the value of ${var1} is filename_R1.fq.gz

# remove file suffix
var2=${var1%%_R*} 
## the value of ${var2} is filename

```

### 2. Mapping

Step 0: install software 
```bash
conda install -c bioconda bowtie2 samtools deeptools
```

step 1: build index
```bash
bowtie2-build hg38.fa bowtie2_index/hg38
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


### 3. Down stream

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
conda install htseq hisat2 stringtie 
```

step 1: build index and extract splice sites

* indexing
```bash
hisat2-build -p {threads} genome/hg38.fa  hisat2_index/hg38

```

* extract known splice sites for alignmnet
```bash

hisat2_extract_splice_sites.py gencode.gtf > hisat2_index/splicesites.txt 
hisat2_extract_exons.py gencode.gtf > histat2_index/exon.txt
```



step2: mapping
```bash
hisat2 --dta --threads ${threads} \
             -x hisat2_index/hg38 \
             --known-splicesite-infile hisat2_index/splicesites.txt \
             -1 R1.fq.gz \
             -2 R2.fq.gz \
             -S output.sam
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
            -b input.sorted.bam \
            -o output.bw

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
