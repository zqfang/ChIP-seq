#!bin/bash

# query transcription start site from ucsc genome browser 


# install mysql first if you don't have one
# see here
# https://genome.ucsc.edu/goldenPath/help/mysql.html


# mac mysql:command not found
#  因为mysql命令的路径在/usr/local/mysql/bin下面,所以你直接使用mysql命令时,
#  系统在/usr/bin下面查此命令,所以找不到了 
 
#    解决办法是：
 
#  ln -s /usr/local/mysql/bin/mysql /usr/bin　做个链接即可





#First, we must create a BED file of the TSSs. 
#To do this, we will query the UCSC Genome Browser and choose the correct TSS based on the transcript's strand.

# -N : no headers
# -B : tab-delimted output
# uniq to remove duplicate TSSs across tmultiple transcripts
# grep -v "_" to remove unplaced contigs
/usr/local/mysql/bin/mysql --user genome \
      --host genome-mysql.cse.ucsc.edu \
      -N \
      -B \
      -D hg19 \
      -e  "SELECT chrom, txStart, txEnd, \
                  X.geneSymbol, 1, strand \
           FROM knownGene as K, kgXref as X \
           WHERE txStart != txEnd \
           AND X.kgID = K.name" \
| awk 'BEGIN{OFS=FS="\t"} \
       { if ($6 == "+") \
         { print $1,$2,$2+1,$4,$5,$6 } \
         else if ($6 == "-") \
         { print $1,$3-1,$3,$4,$5,$6 } \
       }' \
| sort -k1,1 -k2,2n \
| uniq \
| grep -v "_" \
> tss.bed


#Now, let's add 1000 bp upstream and downstream of each TSS. To do this, we use the bedtools "slop" command.
    # bedtools slop \
    #          -b 1000 \
    #          -i tss.bed \
    #          -g hg19.chromsizes \
    # > tss.plusminus.1000bp.bed