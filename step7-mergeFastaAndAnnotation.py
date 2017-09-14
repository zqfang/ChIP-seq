#!bin/env python

'''
usage:
'''
import sys,os
import pandas as pd

if len(sys.argv) <= 3:
    print('''
        usage: python fasta2Anno.py bed txt outText
          ''')
    sys.exit(1)

bed=sys.argv[1]
txt=sys.argv[2]
out=sys.argv[3]

d1 = pd.read_table(bed, header=None)
d2 = pd.read_table(txt)

d1.columns=['chr','start','end','name','score','fasta']
merge=pd.merge(d2, d1, left_on=d2.columns[0], right_on='name', how='left')
merge.to_csv(out, sep="\t", index=False)




