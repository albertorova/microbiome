process HUMANN3_LEFSE {
    tag "HUMANN3_LEFSE"
    label 'process_medium'

script:
    """
    humann3 --version
    """
}
