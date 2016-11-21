
#	 BED/GFF/VCF +reference --> fasta 
#	http://bedtools.readthedocs.io/en/latest/content/tools/bamtobed.html
#	http://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html
bedtools genomecov  -bg -i E001-H3K4me1.tagAlign -g mygenome.txt >E001-H3K4me1.bedGraph
bedtools genomecov  -bg -i E001-Input.tagAlign -g mygenome.txt >E001-Input.bedGraph

#slop 100 bp
bedtools slop -i ../macs_out/S21_2i_ChIP_summits.bed -g ~/genome/hg19/hg19.chrom.size.txt -b 100 | bedtools getfasta -fi ~/genome/hg19/hg19_fasta/hg19.fa -name -bedOut -bed - > S21_peaks_fasta_slop100bp.bed
