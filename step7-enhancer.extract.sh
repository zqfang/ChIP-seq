#!bin/sh

# use for extract poised, active, primed, poised2active,primed2active enhancer extraction
#

set -e

# log
log () {
    echo
    echo "[`date`] Step: $1"
    echo
}


### input bed files #################

tss="hg19.tss.bed"
#p300="GSM602291_ESC_hg19_p300_calls.bed"
p300="GSM1003513_hg19_p300.bed"
h3k4me3="FinalIDR_hESC_H3K4me3_macs2.regionPeak.narrowpeak"
h3k4me1="hESC_H3K4me1_peakSet_qval_005_FC_1_5.bed"
h3k27me3="hESC_H3K27me3_peakSet_qval_005_FC_1_5.bed"
h3k27ac="FinalIDR_hESC_H3K27ac_macs2.regionPeak.narrowpeak"
h3k27ac_diff="FinalIDR_hESC_H3K27ac_macs2.regionPeak.narrowpeak"

#### ouput bed file names ###########

poiEns="enhancers.poised.bed"
actEns="enhancers.active.bed"
primedEns="enhancers.primed.bed"
poi2act="enhancers.poised2active.bed"



######### extract bound regions in tss 2kb window ###############


bedtools window -a hg19.tss.bed -b macs_out_q0.01/SOX21_peaks.narrowPeak -w 2000 -u > enhancers/SOX21.peaks.tss.bed

bedtools window -a hg19.tss.bed -b macs_out_q0.01/SOX21_peaks.narrowPeak -w 2000  > enhancers/SOX21.peaks.2kb.window.tss.bed
cut -f 1,2,3,4,5,6 --complement enhancers/SOX21.peaks.2kb.window.tss.bed 















# p300 enhancer locations
# sed '1d' GSM602291_ESC_hg18_p300_calls.bed | cut -f 1,2,3,4,5 > GSM602291_ESC_hg18_p300_calls.temp.bed

# bedtools required
log "enhancers extraction start"
############################### poised enhancer ###########################################

#p300 regions within 1kb of h3k27me3 and not enriched in h3k27ac within 1kb
tempdir="temp_poised"
mkdir -p ${tempdir}
# p300 in h3k27me3 1000bp window 
bedtools window -a ${h3k27me3} \
                -b ${p300}  \
                -w 1000 > ${tempdir}/p300.in.h3k27me3.1000.window.bed

# bedtools substract -a ${p300} \
#                    -b ${tempdir}/p300.in.h3k27me3.1000.window.bed \
#                    -F 0.9 -A > ${tempdir}/p300.not.in.h3k27me3.1000.window.bed

# p300 not in h3k27ac window
bedtools window -a ${h3k27ac} \
                -b ${tempdir}/p300.in.h3k27me3.1000.window.bed \
                -w 1000 > ${tempdir}/p300.in.h3k27me3.in.h3k27ac.1000.window.bed
bedtools subtract -a ${tempdir}/p300.in.h3k27me3.1000.window.bed \
                   -b ${tempdir}/p300.in.h3k27me3.in.h3k27ac.1000.window.bed \
                   -A  > ${tempdir}/p300.in.h3k27me3.not.in.h3k27ac.1000.window.bed

#not enrichr in h3k4me3 and located > 2.5 kb upstream tss 
## not in k3k4me3, define -F ? -f?

tempa="${tempdir}/p300.in.h3k27me3.not.in.h3k27ac.1000.window.bed"
bedtools subtract -a ${tempa} \
                   -b ${h3k4me3} -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A | cut -f 1,2,3,4,5,6 > ${poiEns}

log "poised enhancers save to: ${poiEns} "

###############################  active enhancers ############################################

#p300 regions within 1kb of h3k27ac and not enriched in h3k27me3 within 1kb
tempdir="temp_act"
mkdir -p ${tempdir}
# p300 in h3k27ac 1000 window 
bedtools window -a ${h3k27ac} \
                -b ${p300}  \
                -w 1000 > ${tempdir}/p300.in.h3k27ac.1000.window.bed

# not in h3k27me3 1000bp window 
bedtools window -a ${h3k27me3} \
                -b ${tempdir}/p300.in.h3k27ac.1000.window.bed  \
                -w 1000 > ${tempdir}/p300.in.h3k27ac.in.h3k27me3.1000.window.bed

bedtools subtract -a ${tempdir}/p300.in.h3k27ac.1000.window.bed \
                   -b ${tempdir}/p300.in.h3k27ac.in.h3k27me3.1000.window.bed \
                   -A  > ${tempdir}/p300.in.h3k27ac.not.in.h3k27me3.1000.window.bed

tempa="${tempdir}/p300.in.h3k27ac.not.in.h3k27me3.1000.window.bed"
bedtools subtract -a ${tempa} \
                   -b ${h3k4me3} -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A | cut -f 1,2,3,4,5,6 > ${actEns}

log "active enhancers save to: ${actEns} "

####################### primed enhancers ##################################################

# h3k4me1 regions not enriched in h3k27me3 or h3k27ac within 1kb
tempdir="temp_primed"
mkdir -p ${tempdir}
# # p300 in h3k27ac 1000 window 
# bedtools window -a ${h3k4me1} \
#                 -b ${p300}  \
#                 -w 1000 > ${tempdir}/p300.in.h3k4me1.1000.window.bed
# not within h3k27me3 1000 window

# h3k4me1 not in h3k27me3 1000bp window 
bedtools window -a ${h3k27me3} \
                -b ${h3k4me1}  \
                -w 1000 > ${tempdir}/h3k4me1.in.h3k27me3.1000.window.bed

bedtools subtract -a ${h3k4me1} \
                   -b ${tempdir}/h3k4me1.in.h3k27me3.1000.window.bed \
                   -A > ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed

# p300 not in h3k27ac 1000bp window 
bedtools window -a ${h3k27ac} \
                -b ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed  \
                -w 1000 > ${tempdir}/h3k4me1.not.in.h3k27me3.but.in.h3k27ac.1000.window.bed
bedtools subtract -a ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed \
                   -b ${tempdir}/h3k4me1.not.in.h3k27me3.but.in.h3k27ac.1000.window.bed \
                   -A > ${tempdir}/h3k4me1.not.in.both.h3k27me3.h3k27ac.1000.window.bed

tempa="${tempdir}/h3k4me1.not.in.both.h3k27me3.h3k27ac.1000.window.bed"
bedtools subtract -a ${tempa} \
                   -b ${h3k4me3} -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A | cut -f 1,2,3,4,5,6 > ${primedEns}

log "primed enhancers save to: ${primedEns} "

################### poised become active when differentiated or condition changed ##############

# poised enhancers located within 1kb of h3k27ac generated from other conditions
# e.g. h3k27ac regions of differented cells 

bedtools window -a ${h3k27ac_diff} \
                -b ${poiEns} \
                -w 1000 | cut -f 1,2,3,4,5,6 > ${poi2act}

log "poised to active enhancers save to: ${poiEns} "

log "finished"

