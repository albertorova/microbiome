process HUMANN3_REGROUP {
    tag "HUMANN3_REGROUP"
    label 'process_medium'

script:
    """
    humann3 --version
    """
}
