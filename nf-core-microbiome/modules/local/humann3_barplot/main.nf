process HUMMAN3_BARPLOT {
    tag "HUMMAN3_BARPLOT"
    label 'process_medium'

script:
    """
    humann3 --version
    """
}
