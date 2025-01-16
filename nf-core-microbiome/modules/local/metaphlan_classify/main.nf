process METAPHLAN_CLASSIFY {
    tag "$sample"
    label 'process_medium'
    
    input:
    tuple val(sample), path(concatenated_read)

    output:
    tuple val(sample), path(concatenated_read), path("${sample}_output.tsv"), emit: metaphlan_output
    
    script:
    """
    metaphlan $concatenated_read \
    --input_type fastq \
    -o ${sample}_output.tsv
    """
}

//metaphlan M00574-TRU-20230125_L001_R1_001.fastq.gz,M00574-TRU-20230125_L001_R2_001.fastq.gz --bowtie2out metagenome.bowtie2.bz2 --input_type fastq -o profiled_metagenome.txt


 
