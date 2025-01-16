process CAT {
    tag "$sample"
    label 'process_medium'
    
    input:
    tuple val(sample), path(reads1), path(reads2)

    output:
    tuple val(sample), path("${sample}_concatenated.fastq.gz"), emit: output

    script:
    """
    cat $reads1 $reads2 > ${sample}_concatenated.fastq.gz
    """
}
