
#    BED/GFF/VCF +reference --> fasta 


beds=(SOX21_peaks.narrowPeak)
beddir="macs_out_q0.01"
genome_seq="$HOME/genome/Human_hg19/hg19.fa"
genome_size="$HOME/genome/Human_hg19/hg19.chrom.sizes"
mkdir -p peaks_fasta

for bed in ${beds[@]} 
    do
        cut -f 1-5 ${beddir}/${bed} | bedtools slop -i stdin -g ${genome_size} -b 100 | \
        bedtools getfasta -fi ${genome_seq} -bed stdin -bedOut > peaks_fasta/${bed}.slop100.fasta.bed

        annotatePeaks.pl peaks_fasta/${bed}.slop100.fasta.bed hg19  > peaks_fasta/${bed}.slop100.fasta.annotated.txt

        python step7-mergeFastaAndAnnotation.py \
               peaks_fasta/${bed}.slop100.fasta.bed \
               peaks_fasta/${bed}.slop100.fasta.annotated.txt \
               peaks_fasta/${bed}.slop100.fasta.annotated.full.txt
    done
