
import gffutils
gffutils.create_db(
    "gencode.v19.annotation.gtf",
    "gencode.v19.annotation.db",
    keep_order=False,
    sort_attribute_values=False,
    id_spec={'gene': 'gene_id', 'transcript': 'transcript_id'},
    verbose=True, merge_strategy='merge', infer_gene_extent=False,)
