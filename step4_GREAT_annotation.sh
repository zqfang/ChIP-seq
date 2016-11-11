#!bin/bash

cut -f 1,2,3,4,5  macs_highQuality_out/CT1.0_ChIP_peaks.narrowPeak >./macs_highQuality_out/S1-great.bed
cut -f 1,2,3,4,5  macs_highQuality_out/2i_ChIP_peaks.narrowPeak > ./macs_highQuality_out/S21-great.bed


