    # -N : no headers
        # -B : tab-delimted output
            # uniq to remove duplicate TSSs across tmultiple transcripts
                # grep -v "_" to remove unplaced contigs
                    mysql --user genome \
                                      --host genome-mysql.cse.ucsc.edu \
                                                -N \
                                                          -B \
                                                                    -D hg19 \
                                                                              -e  "SELECT chrom, txStart, txEnd, \
                                                                                                    X.geneSymbol, 1, strand \
                                                                                                                   FROM knownGene as K, kgXref as X \
                                                                                                                                  WHERE txStart != txEnd \
                                                                                                                                                 AND X.kgID = K.name" \
                                                                                                                                                     | awk 'BEGIN{OFS=FS="\t"} \
                                                                                                                                                                { if ($6 == "+") \
                                                                                                                                                                             { print $1,$2,$2+1,$4,$5,$6 } \
                                                                                                                                                                                          else if ($6 == "-") \
                                                                                                                                                                                                       { print $1,$3-1,$3,$4,$5,$6 } \
                                                                                                                                                                                                                  }' \
                                                                                                                                                                                                                      | sort -k1,1 -k2,2n \
                                                                                                                                                                                                                          | uniq \
                                                                                                                                                                                                                              | grep -v "_" \
                                                                                                                                                                                                                                  > tss.bed
