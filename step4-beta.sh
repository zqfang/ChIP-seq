#! bin/bash
#for transcription factor
# log
log () {
    echo
    echo "[`date`] Step: $1"
    echo
}

treat=(CT1-0-D4-soxlchip CT1-0-d8-elute_combined_R1 IWP2-d8-elute_combined_R1)
input=(CT1-0-D4-input CT1-0-d8-input_combined_R1 IWP2-d8-input_combined_R1)
name=(CT1.0-D4-SOX1 CT1.0-D8-SOX1 IWP2-D8-SOX1)
expression=(CT1.0d4_vs_S1K_CT1.0d4 CT1.0d8_vs_S1K_CT1.0d8 IWP2d8_vs_S1K_IWP2d8)
indir="macs_out"
outdir="macs_beta"
chrominfo="/Users/bioninja/genome/Human_hg19/hg19.chrom.sizes"
genome="/Users/bioninja/genome/Human_hg19/hg19.fa"
mkdir -p $outdir

for idx in 0 1 2  
    do
        log "start beta plus: ${name[idx]}"
        BETA plus -p macs_out/${name[idx]}_summits.bed -e expr_deseq2/diff_Ctrl_${expression[idx]}_results.genename.txt -k O --da 1 --df 0.05  --info 1,3,7 -g hg19  --gname2 --gs ${genome} --bl --mn 0.05 -c 0.01 -n ${expression[idx]}  -o beta_${name[idx]}_fdr0.05
        log "start beta plus on no model results: ${name[idx]}"
        #BETA plus -p macs_out_nomodel/${name[idx]}_summits.bed -e expr_deseq2/diff_Ctrl_${expression[idx]}_results.genename.txt -k O --info 1,3,7 -g hg19  --gname2 --gs ${genome} --bl -n ${expression[idx]} -o beta_nomodel_${name[idx]}
done

log "finished"

# use --gname2, so you could convert ensemble gene id to gene name in the expression file(-e)
#--gs required for motif scan, specifies a fasta format whole genome sequencing data.
#--bl is an optional parameters, it is on when some boundaries considered
#-p specifies the name of TF binding data
#-e specifies the name of the corresponding differential expression data
# -k LIM --info 1,3,7 is required
#-k LIM stand for the LIMMA Format, {LIM,CUF,BSF,O}, DESeq2: -k O --info 1,3,7
# --info specify the geneID, up/down status and statistcal values column of your expression data. 
#         for example: 1,2,6 means geneID in the 1st column, logFC in 2nd column and FDR in 6th column.
#-g specifies the genome of your data, hg19 for human and mm9 for mouse, others, ignore this one
#-n specifies the prefix of the output files, others, BETA will use ‘NA’ instead
#--da 500 means get top 500 most significant expression changed genes of up and down 