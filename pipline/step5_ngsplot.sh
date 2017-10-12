#!bin/bash
#Usage: ngs.plot.r -G genome -R region -C [cov|config]file -O name [Options]
## Mandatory parameters:
#  -G   Genome name. Use ngsplotdb.py list to show available genomes.
#  -R   Genomic regions to plot: tss, tes, genebody, exon, cgi, enhancer, dhs or bed
#  -C   Indexed bam file or a configuration file for multiplot
#  -O   Name for output: multiple files will be generated


names=(CT1.0-D4 CT1.0-D8 IWP2-D8)

#for region in tss tes genebody exon cgi enhancer
#    doi
        region2="macs_out/merge.summit.bed"
        region="called.peaks"
        mkdir -p ngs.plot/SOX1.${region}
        mkdir -p ngs.plot/SOX1.no.input.${region}
        mkdir -p ngs.plot/SOX1.minus.input.${region}
        ngs.plot.r -G hg19 -E ${region2} -C config.SOX1.txt -O ngs.plot/SOX1.${region} -L 3000 -FL 300 -FS 18 -RR 90 -GO km -MIT 100 -R bed
        ngs.plot.r -G hg19 -E ${region2} -C config.SOX1.no.input.txt -O ngs.plot/SOX1.no.input.${region} -L 3000 -FL 300 -FS 18 -MIN 100 -RR 90 -GO km -R bed
        ngs.plot.r -G hg19 -E ${region2} -C config.SOX1.minus.input.txt -O ngs.plot/SOX1.minus.input.${region} -L 3000 -FL 300 -GO km -FS 18 -MIN 100 -RR 90 -R bed
#done
