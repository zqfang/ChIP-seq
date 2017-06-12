
#	 BED/GFF/VCF +reference --> fasta 
#	http://bedtools.readthedocs.io/en/latest/content/tools/bamtobed.html
#	http://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html
#bedtools genomecov  -bg -i E001-H3K4me1.tagAlign -g mygenome.txt >E001-H3K4me1.bedGraph
#bedtools genomecov  -bg -i E001-Input.tagAlign -g mygenome.txt >E001-Input.bedGraph
bedtools getfasta -fi ~/genome/hg19_ucsc_fasta/hg19.fa -bed macs_out_highQuality/NANOG_ChIP_peaks.narrowPeak -tab -bedOut > NANOG_ChIP_peaks.fasta.txt


