process HUMANN3_PROFILING {
    tag "${sample}"
    label 'process_large'

    input:
    tuple val(sample), path(reads), path(metaphlan_output)

    output:
    path("${sample}_humann3"), emit: output

    script:
    """
    humann3 -i $reads \
    --taxonomic-profile $metaphlan_output \
    --nucleotide-database /home/hp/Escritorio/nextflow/humann3/database/chocophlan/ \
    --protein-database /home/hp/Escritorio/nextflow/humann3/database/uniref/ \
    -o ${sample}_humann3
    """
}

