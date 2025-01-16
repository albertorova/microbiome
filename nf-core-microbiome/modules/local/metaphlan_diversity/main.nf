process METAPHLAN_DIVERSITY {
    tag "metaphlan_diversity"
    label 'process_medium'
    
    input:
    path merged_table
    
    output:
    path "diversity_analysis/*", emit: diversity_results
    
    script:
    """
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d alpha -m richness
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d alpha -m shannon
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d alpha -m simpson
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d alpha -m gini
    
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d beta -m bray-curtis
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d beta -m jaccard
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -t /home/hp/Escritorio/nextflow/metaphlan/mpa_vJan21_CHOCOPhlAnSGB_202103.nwk -d beta -m weighted-unifrac 
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -t /home/hp/Escritorio/nextflow/metaphlan/mpa_vJan21_CHOCOPhlAnSGB_202103.nwk -d beta -m unweighted-unifrac   
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d beta -m clr
    Rscript /home/hp/Escritorio/nextflow/metaphlan/calculate_diversity.R -f $merged_table -d beta -m aitchison

    """
}
