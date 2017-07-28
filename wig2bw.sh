
#for linux
zcat *.wig.gz | wigToBigWig -clip stdin chromsizes.tab out.bw

#for mac
gzcat *.wig.gz | wigToBigWig -clip stdin chromsizes.tab out.bw

