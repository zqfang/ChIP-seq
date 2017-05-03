#!bin/bash

mkdir ngs.plot
regoin=(tss tes genebody exon cgi enhancer)
for rg in ${regoin[@]}
do
    ngs.plot.r -G hg19 -R ${rg} -C ngs.plot.config.txt -O ./ngs.plot/NANOG-OCT4.ChIP.${rg} -GO km -L 3000
done


