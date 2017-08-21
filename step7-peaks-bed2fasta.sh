
#	 BED/GFF/VCF +reference --> fasta 
#	http://bedtools.readthedocs.io/en/latest/content/tools/bamtobed.html
#	http://bedtools.readthedocs.io/en/latest/content/tools/getfasta.html
bedtools genomecov  -bg -i E001-H3K4me1.tagAlign -g mygenome.txt >E001-H3K4me1.bedGraph
bedtools genomecov  -bg -i E001-Input.tagAlign -g mygenome.txt >E001-Input.bedGraph
