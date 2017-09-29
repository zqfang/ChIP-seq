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
p300="GSM602291_ESC_hg19_p300_calls.bed"
h3k4me3="FinalIDR_hESC_H3K4me3_macs2.regionPeak.narrowpeak"
h3k4me1="hESC_H3K4me1_peakSet_qval_005_FC_1_5.bed"
h3k27me3="hESC_H3K27me3_peakSet_qval_005_FC_1_5.bed"
h3k27ac="FinalIDR_hESC_H3K27ac_macs2.regionPeak.narrowpeak"
h3k27ac_diff="FinalIDR_NE_H3K27ac_macs2.regionPeak.narrowpeak"

#### ouput bed file names ###########

poiEns="enhancers.poised.bed"
actEns="enhancers.active.bed"
primedEns="enhancers.primed.bed"
poi2act="enhancers.poised2active.bed"


### promoters

# regions contains -a only
# bedtools window -a hg19.tss.bed \
#                 -b macs_out_q0.01/SOX21_peaks.narrowPeak \
#                 -w 2000 -u > enhancers/SOX21.peaks.tss.bed
# # regions contains -a -b, need cut
# bedtools window -a hg19.tss.bed \
#                  -b macs_out_q0.01/SOX21_peaks.narrowPeak \
#                  -w 2000  > enhancers/SOX21.peaks.2kb.window.tss.bed
# # get -b regions
# cut -f 7- SOX21.peaks.2kb.window.tss.bed > SOX21.peaks.only.2kb.tss.bed


# ### ehancers

# # get enhancers by subtracting tss regions
# bedtools subtract -a ../macs_out_q0.01/SOX21_peaks.narrowPeak \
#                    -b SOX21.peaks.only.2kb.tss.bed \
#                     > SOX21.peaks.only.enhancers.bed



######### extract bound regions in tss 2kb window ###############


# bedtools window -a hg19.tss.bed \
#                 -b macs_out_q0.01/SOX21_peaks.narrowPeak -w 2000 -u > enhancers/SOX21.peaks.tss.bed


# p300 enhancer locations
# sed '1d' GSM602291_ESC_hg18_p300_calls.bed | cut -f 1,2,3,4,5 > GSM602291_ESC_hg18_p300_calls.temp.bed

# bedtools required
log "enhancers extraction start"
############################### poised enhancer ###########################################

#p300 regions within 1kb of h3k27me3 and not enriched in h3k27ac within 1kb
tempdir="temp_poised"
mkdir -p ${tempdir}
# p300 in h3k27me3 1000bp window 
cut -f 1,2,3 ${p300} > p300cut.bed
cut -f 1,2,3 ${h3k27me3} > h3k27me3cut.bed
cut -f 1,2,3 ${h3k4me1} > h3k4me1cut.bed
cut -f 1,2,3 ${h3k4me3} > h3k4me3cut.bed
cut -f 1,2,3 ${h3k27ac} > h3k27accut.bed
cut -f 1,2,3 ${h3k27ac_diff} > h3k27ac_diffcut.bed
cut -f 1,2,3 ${tss} > tsscut.bed

bedtools window -a h3k27me3cut.bed \
                -b p300cut.bed  \
                -w 1000 | cut -f 4- > ${tempdir}/p300.in.h3k27me3.1000.window.bed

# bedtools substract -a ${p300} \
#                    -b ${tempdir}/p300.in.h3k27me3.1000.window.bed \
#                    -F 0.9 -A > ${tempdir}/p300.not.in.h3k27me3.1000.window.bed

# p300 not in h3k27ac window
bedtools window -a h3k27accut.bed \
                -b ${tempdir}/p300.in.h3k27me3.1000.window.bed \
                -w 1000 | cut -f 4- > ${tempdir}/p300.in.h3k27me3.in.h3k27ac.1000.window.bed

bedtools subtract -a ${tempdir}/p300.in.h3k27me3.1000.window.bed \
                   -b ${tempdir}/p300.in.h3k27me3.in.h3k27ac.1000.window.bed \
                   -A  > ${tempdir}/p300.in.h3k27me3.not.in.h3k27ac.1000.window.bed

#not enrich in h3k4me3 and located > 2.5 kb upstream tss 
## not in k3k4me3, define -F ? -f?

tempa="${tempdir}/p300.in.h3k27me3.not.in.h3k27ac.1000.window.bed"
bedtools subtract -a ${tempa} \
               -b h3k4me3cut.bed -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw | cut -f 7- > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A  > ${poiEns}

log "poised enhancers save to: ${poiEns} "

###############################  active enhancers ############################################

#p300 regions within 1kb of h3k27ac and not enriched in h3k27me3 within 1kb
tempdir="temp_act"
mkdir -p ${tempdir}
# p300 in h3k27ac 1000 window 
bedtools window -a h3k27accut.bed \
                -b p300cut.bed  \
                -w 1000 | cut -f 4- > ${tempdir}/p300.in.h3k27ac.1000.window.bed

# not in h3k27me3 1000bp window 
bedtools window -a h3k27me3cut.bed \
                -b ${tempdir}/p300.in.h3k27ac.1000.window.bed  \
                -w 1000 | cut -f 4- > ${tempdir}/p300.in.h3k27ac.in.h3k27me3.1000.window.bed

bedtools subtract -a ${tempdir}/p300.in.h3k27ac.1000.window.bed \
                   -b ${tempdir}/p300.in.h3k27ac.in.h3k27me3.1000.window.bed \
                   -A  > ${tempdir}/p300.in.h3k27ac.not.in.h3k27me3.1000.window.bed

tempa="${tempdir}/p300.in.h3k27ac.not.in.h3k27me3.1000.window.bed"
bedtools subtract -a ${tempa} \
                   -b h3k4me3cut.bed -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw | cut -f 7-  > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A > ${actEns}

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
bedtools window -a h3k27me3cut.bed \
                -b h3k4me1cut.bed  \
                -w 1000 | cut -f 4- > ${tempdir}/h3k4me1.in.h3k27me3.1000.window.bed

bedtools subtract -a h3k4me1cut.bed \
                   -b ${tempdir}/h3k4me1.in.h3k27me3.1000.window.bed \
                   -A > ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed

# p300 not in h3k27ac 1000bp window 
bedtools window -a h3k27accut.bed \
                -b ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed  \
                -w 1000 | cut -f 4- > ${tempdir}/h3k4me1.not.in.h3k27me3.but.in.h3k27ac.1000.window.bed
bedtools subtract -a ${tempdir}/h3k4me1.not.in.h3k27me3.1000.window.bed \
                   -b ${tempdir}/h3k4me1.not.in.h3k27me3.but.in.h3k27ac.1000.window.bed \
                   -A > ${tempdir}/h3k4me1.not.in.both.h3k27me3.h3k27ac.1000.window.bed

tempa="${tempdir}/h3k4me1.not.in.both.h3k27me3.h3k27ac.1000.window.bed"
bedtools subtract -a ${tempa} \
                   -b h3k4me3cut.bed -A >  ${tempa}.not.h3k4me3
# exclude tss regions 2.5 kb?
bedtools window -a ${tss} \
                -b ${tempa}.not.h3k4me3 \
                -l 2500 -r 0 -sw | cut -f 7- > ${tempa}.not.h3k4me3.within.tss2500
bedtools subtract -a ${tempa}.not.h3k4me3 \
                   -b ${tempa}.not.h3k4me3.within.tss2500 \
                   -A  > ${primedEns}

log "primed enhancers save to: ${primedEns} "

################### poised become active when differentiated or condition changed ##############

# poised enhancers located within 1kb of h3k27ac generated from other conditions
# e.g. h3k27ac regions of differented cells 

bedtools window -a h3k27ac_diffcut.bed \
                -b ${poiEns} \
                -w 1000 | cut -f 4-  > ${poi2act}

log "poised to active enhancers save to: ${poi2act} "

log "finished"

