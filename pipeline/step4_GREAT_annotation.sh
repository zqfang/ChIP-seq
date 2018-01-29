#!bin/bash

cut -f 1,2,3  macs_highQuality_out/SOX1_CT1.0_ChIP_peaks.narrowPeak >./macs_highQuality_out/SOX1-great.bed
cut -f 1,2,3  macs_highQuality_out/SOX21_2i_ChIP_peaks.narrowPeak > ./macs_highQuality_out/SOX21-great.bed


