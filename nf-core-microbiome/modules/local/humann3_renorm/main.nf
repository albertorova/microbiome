process HUMANN3_RENORM {
    tag "renorm_humann3_tables"
    label 'process_medium'

    input:
    path joined_table

    output:
    path("normalized_cpm.tsv"), emit: normalized_table1
    path("normalized_relab.tsv"), emit: normalized_table2

    script:
    """
    humann_renorm_table -i ${joined_table} -u cpm -o normalized_cpm.tsv
    
    humann_renorm_table -i ${joined_table} -u relab -o normalized_relab.tsv
    """
}
