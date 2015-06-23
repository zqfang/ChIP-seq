#!/usr/bin/env python



import sys

for line in sys.stdin:
    attr = dict(item.strip().split(' ')  for item in line.split('\t')[8].strip('\n').split(';') if item)
    print attr['gene_id'].strip('\"')+'\t'+ attr['gene_name'].strip('\"')
