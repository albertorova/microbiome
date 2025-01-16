process KNEADDATA {icarus_pipeline
    tag "KNEADDATA"
    label 'process_medium'
    
    input:
    tuple val(sample), val(lane), path(reads1), path(reads2)
    
    output:
    path("*.log"), emit: log
    
    
    script:
    """
    kneaddata --trimmomatic /home/hp/Escritorio/nextflow/trimmomatic/Trimmomatic-0.39 \
    --input1 $reads1 \
    --input2 $reads2 \
    --reference-db /home/hp/Escritorio/nextflow/kneedata/database/hg37dec_v0.1.2.bt2 \
    --output ./ \
    --bypass-trf
    """
}

