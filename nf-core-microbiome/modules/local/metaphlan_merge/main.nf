process METAPHLAN_MERGE {
    tag "merging_metaphlan_tables"
    label 'process_medium'
    
    input:
    path metaphlan_files
    
    output:
    path("merged_abundance_table.tsv"), emit: merged_output

    script:
    def inputs = metaphlan_files.join(' ')
    """
    merge_metaphlan_tables.py $inputs > merged_abundance_table.tsv
    """
}
