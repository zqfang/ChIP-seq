# For Paired-end Sequencing, STAR is a good choice. 
# Usuallly, Bowtie and BWA is better choice for short reads alignment for genome alignment

#You can disable spliced alignments with --alignIntronMax 1 (setting the max intron to a value less than the minimum intron). 
#I agree that you should discard non-unique alignments unless you have some compelling reason to try to use them.


#You can enforce "end-to-end" alignment with --alignEndsType EndToEnd .
#This will prohibit soft-clipping of the reads and is beneficial if you have short (<50b) reads;
#it will make alignments more similar to bowtie1/BWA. 
#If your reads are shorted than 50b, you can also increase sensitivity with --seedSearchStartLmax 30 
#at the cost of mild mapping speed decrease.


STAR --genomeDir ~/project-yxing/genome/STARhg19_GRCh37.75_length_50 --readFilesIn ../raw_data/H9AM-cut1_filter.fq --alignEndsType EndToEnd --alignIntronMax 1 --seedSearchStartLmax 30 --genomeLoad LoadAndKeep --runThreadN 20 --outSAMtype BAM Unsorted --outFileNamePrefix ../H9_SOX2
