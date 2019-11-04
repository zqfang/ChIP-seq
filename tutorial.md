
## Fast NGS
Make bioinfo uncool again

### 1. Linux command line tricks 

a. install `OhMyZsh`, make terminal cool
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

### 2. ChIP-seq
#### 2.1 Genome mapping

Step 0: install software 
```bash
# install miniconda, then call conda
conda install -c bioconda bowtie2 hisat2 samtools deeptools
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

#### 2.2 Peaks analysis

**note:**: macs2 (>v2.2.x) supports python 3.

step 0: install tools
```bash
conda install macs2 bedtools pygenometracks 
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

### 3. RNA-seq
#### 3.1 transcriptom mapping  
step 0: install tools
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


#### 3.2 Differentially expressed genes analysis
step 1: count reads

```bash
htseq-count -r pos -s no \
            --additional-attr gene_name \
            --additional-attr gene_type \
            -f bam input.sorted.bam  gencode.gtf  > output.count

```


step2: differentially expressed genes analysis

(1) construct read count table  

* option 1: HTSeq count file input 
```R
library("DESeq2")
directory <- "/path/to/your/readCountFiles/"
sampleFiles <- grep("count", list.files(directory), value=TRUE)
condition <- factor(c("KO","KO", "WT","WT"), levels = c("WT", "KO"))
# phenotable
sampleTable <- data.frame(sampleName = sampleFiles,
                          fileName = sampleFiles,
                          condition = condition)
# construct read count table
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                       directory = directory,
                                       design= ~ condition)
```

* option 2:  combined read count file into single table first, then run  
```R
library(DESeq2)
# 数据预处理
database <- read.table(file = "raw.counts.csv", sep = ",", header = TRUE, row.names = 1)
database <- round(as.matrix(database))

# 设置分组信息并构建dds对象
condition <- factor(c("KO","KO", "WT","WT"), levels = c("WT", "KO"))

coldata <- data.frame(row.names = colnames(database), condition)
dds <- DESeqDataSetFromMatrix(countData=database, colData=coldata, design=~condition + treatmement)
```


(2) run DESeq2 and get output  

```R
library(DESeq2)
dds <- dds[ rowSums(counts(dds)) > 1, ]   #过滤low count数据
dds <- DESeq(dds)     #差异分析
res <- results(dds)   #用result()函数获取结果
# summary(res)  #summary()函数统计结果
count_r <- counts(dds, normalized=T)  #提取normalized count matrix

# 最后设定阈值，筛选差异基因，导出数据(全部数据。包括标准化后的count数)
res <- res[order(res$padj),]
diff_gene <- subset(res, padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
diff_gene <- row.names(diff_gene)
resdata <- merge(as.data.frame(res), 
                 as.data.frame(counts(dds, normalized=TRUE)), 
                 by="row.names",
                 sort=FALSE)
write.csv(resdata, file = "DEGs.csv", row.names = FALSE)

```
#### 3.3 Gene set enrichrment analysis

GO
* clusterprofiler
* Enrichr (GSEApy)
* GSEA

#### 3.4 Alternative splicing analysis

rMATS





### 4. Fast RNA-seq

salmon or kaliosto 

step 0: install salmon and download transcriptome cdna from gencode
```bash
conda install salmon
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.transcripts.fa.gz
```

step 1. build salmon index
```bash
salmon index -p 8 --gencode -t gencode.v32.transcripts.fa.gz -i salmonIndex_hg38
```

step 2: quantification
```bash
salmon quant -i salmonIndex_hg38 -l A \
         -1 ${fn}/${samp}_1.fastq.gz \
         -2 ${fn}/${samp}_2.fastq.gz \
         -p 8 --validateMappings -o quants/${samp}_quant
```

step 3: merge quantification outputs

(1) use salmon quantmerge
```bash
salmon quantmerge

```
(2) use tximport in R
```R
  # R code
  library(tximport)
  library(readr)
  suppressMessages(library('EnsDb.Hsapiens.v86'))

  txdb <- EnsDb.Hsapiens.v86
  k <- keys(txdb, keytype = "GENEID")
  df <- select(txdb, keys = k, keytype = "GENEID", columns = c("TXID","GENEID"))
  tx2gene <- df[, 2:1]  # tx ID, then gene ID

  #tx2gene <- read.table(tx2gene, header= T, sep="\t", stringsAsFactors = F)
  samples <- unlist(strsplit(sample_ids,","))
  salmon.files <- file.path('salmon',samples, "quant.sf")
  names(salmon.files) <- samples
  all(file.exists(salmon.files))

  #aggregate transcripts to genes, and extract raw read counts  
  #add ignoreTxVersion to remove id versions
  #txi.salmon <- tximport(salmon.files, type = "salmon", 
  #                       tx2gene = tx2gene, countsFromAbundance = "no")
  txi.transcripts <- tximport(salmon.files, type = "salmon", 
                              txOut = TRUE, tx2gene = tx2gene,)
                         #     ignoreTxVersion = TRUE)

  txi.salmon <- summarizeToGene(txi.transcripts, tx2gene)

  #save raw counts 
  salmon.counts<- txi.salmon$counts
  salmon.counts<- as.data.frame(salmon.counts)
  write.table(salmon.counts, out_counts, sep="\t", quote=F)
  
  #save gene tpms
  salmon.TPM<- txi.salmon$abundance
  salmon.TPM<- as.data.frame(salmon.TPM)
  write.table(salmon.TPM, out_tpm, sep="\t", quote=F)
  #save transcripts tpms
  salmon.trans.TPM<- txi.transcripts$abundance
  salmon.trans.TPM<- as.data.frame(salmon.trans.TPM)
  write.table(salmon.trans.TPM, outTrans_tpm, sep="\t", quote=F)
   
  save(txi.salmon, file=out_image)

```



step 4: Differentially expressed gene analysis

DESeq2 pipeline