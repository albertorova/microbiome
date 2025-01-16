process METAPHLAN_ABUNDANCE {
    tag "$METAPHLAN_ABUNDANCE"
    label 'process_medium'
     
    script:
    """
    metaphlan --version
    """
}



