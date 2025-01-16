process PHYLOSEQ_PLOTS {
    tag "phyloseq_plots"
    label 'process_medium'
     
    input:
    path merged_table

    output:
    path("*.pdf"), emit: plots

    script:
    """
    tail -n +2 $merged_table > temp_table.tsv

    Rscript /home/hp/Escritorio/nextflow/phyloseq/phyloseq_plot.R temp_table.tsv
    """
}


