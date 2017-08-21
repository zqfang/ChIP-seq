#!bin/env python

"""
Our goal is to look at the ChIP-seq signal over transcription start sites (TSSes) of genes. 
Typically in this sort of analysis we start with annotations; here we’re using the annotations from Ensembl. 
If we’re lucky, TSSes will already be annotated. 
Failing that, perhaps 5’UTRs are annotated, 
so we could take the 5’ end of the 5’UTR as the TSS. Let’s see what the Ensembl data gives us.
GTF files have the feature type in the 3rd field.


~/genome/Human_hg19 » cut -f 3 gencode.v19.annotation.gtf | sort | uniq -c    

   1 ##date: 2013-12-05
   1 ##description: evidence-based annotation of the human genome (GRCh37), version 19 (Ensembl 74)
   1 ##format: gtf
   1 ##provider: GENCODE
723784 CDS
 114 Selenocysteine
284573 UTR
1196293 exon
57820 gene
84144 start_codon
76196 stop_codon
196520 transcript

With only these featuretypes to work with, we would need to do the following to 
identify the TSS of each transcript: 
* find all exons for the transcript 
* sort the exons by start position 
* if the transcript is on the “+” strand, TSS is the start position of the first exon 
* if the transcript is on the “-” strand, TSS is the end position of the last exon

Luckily, ``gffutils`` is able to infer transcripts and genes from a GTF file. 
"""


import os, sys
import gffutils
import pybedtools
from pybedtools.featurefuncs import TSS
from gffutils.helpers import asinterval

fname=sys.argv[1]
oname=sys.argv[2] 

outdb=data_dir.replace(".gtf", ".gffutils.db")

#create database
#db = gffutils.create_db(fname, dbfn='test.db', force=True, keep_order=True, merge_strategy='merge', sort_attribute_values=True)

db = gffutils.create_db(fname, dbfn=outdb, keep_order=False, sort_attribute_values=False,
                        id_spec={'gene': 'gene_id', 'transcript': 'transcript_id'},
                        verbose=True, merge_strategy='merge', 
                        #you have specifiy gene id and transcripts. disable this two to speed up
                        disable_infer_genes=True, disable_infer_transcripts=True)
#db = gffutils.FeatureDB(db)

def tss_generator():
    """
    Generator function to yield TSS of each annotated transcript
    """
    for transcript in db.features_of_type('transcript'):
        yield TSS(asinterval(transcript), upstream=1, downstream=0)

        
# A BedTool made out of a generator, and saved to file.
tsses = pybedtools.BedTool(tss_generator()).saveas('tsses.gtf')
# add 1kb to either side of the TSS. This uses the BEDTools slop routine;
tsses_1kb = tsses.slop(b=1000, genome='hg19', output='tsses-1kb.gtf')

