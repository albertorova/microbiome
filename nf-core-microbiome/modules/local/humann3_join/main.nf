process HUMANN3_JOIN {
    tag "join_humann3_tables"
    label 'process_medium'

    input:
    path humann3_dirs

    output:
    path("joined_humann3_tables.tsv"), emit: joined_table


    script:
    """
    mkdir -p temp_joined
    cp ${humann3_dirs}/*/*concatenated*.tsv temp_joined/
    humann_join_tables -i temp_joined -o joined_humann3_tables.tsv --file_name concatenated
    """
}
