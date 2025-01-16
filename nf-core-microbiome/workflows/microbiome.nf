/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    PRINT PARAMS SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { paramsSummaryLog; paramsSummaryMap } from 'plugin/nf-validation'

def logo = NfcoreTemplate.logo(workflow, params.monochrome_logs)
def citation = '\n' + WorkflowMain.citation(workflow) + '\n'
def summary_params = paramsSummaryMap(workflow)

// Print parameter summary log to screen
log.info logo + paramsSummaryLog(workflow) + citation

WorkflowMicrobiome.initialise(params, log)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

ch_multiqc_config          = Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)
ch_multiqc_custom_config   = params.multiqc_config ? Channel.fromPath( params.multiqc_config, checkIfExists: true ) : Channel.empty()
ch_multiqc_logo            = params.multiqc_logo   ? Channel.fromPath( params.multiqc_logo, checkIfExists: true ) : Channel.empty()
ch_multiqc_custom_methods_description = params.multiqc_methods_description ? file(params.multiqc_methods_description, checkIfExists: true) : file("$projectDir/assets/methods_description_template.yml", checkIfExists: true)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
include { INPUT_CHECK         } from '../subworkflows/local/input_check'
//include { KNEADDATA           } from '../modules/local/kneaddata/main'
include { CAT                 } from '../modules/local/cat/main'
include { METAPHLAN_CLASSIFY  } from '../modules/local/metaphlan_classify/main'
include { METAPHLAN_MERGE     } from '../modules/local/metaphlan_merge/main'
include { METAPHLAN_DIVERSITY } from '../modules/local/metaphlan_diversity/main'
include { HUMANN3_PROFILING   } from '../modules/local/humann3_profiling/main'
//include { METAPHLAN_ABUNDANCE } from '../modules/local/metaphlan_abundance/main'
include { HUMANN3_JOIN        } from '../modules/local/humann3_join/main'
include { HUMANN3_RENORM      } from '../modules/local/humann3_renorm/main'
include { PHYLOSEQ_PLOTS      } from '../modules/local/phyloseq_plots/main'
//include { HUMANN3_REGROUP     } from '../modules/local/humann3_regroup/main'
//include { SELECT              } from '../modules/local/select/main'
//include { HUMANN3_BARPLOT     } from '../modules/local/humann3_barplot/main'
//include { HUMANN3_LEFSE       } from '../modules/local/humann3_lefse/main'
//include { MAASLIN2            } from '../modules/local/maaslin2/main'



/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { FASTQC                      } from '../modules/nf-core/fastqc/main'
include { SEQTK_SAMPLE                } from '../modules/nf-core/seqtk/sample/main'
include { MULTIQC                     } from '../modules/nf-core/multiqc/main'
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Info required for completion email and summary
def multiqc_report = []

workflow MICROBIOME {

    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //
    INPUT_CHECK (
        file(params.input)
    )
    ch_versions = ch_versions.mix(INPUT_CHECK.out.versions)
    // TODO: OPTIONAL, you can use nf-validation plugin to create an input channel from the samplesheet with Channel.fromSamplesheet("input")
    // See the documentation https://nextflow-io.github.io/nf-validation/samplesheets/fromSamplesheet/
    // ! There is currently no tooling to help you write a sample sheet schema
    
    // INPUT
    Channel
    .fromPath(params.input)
    .splitCsv(header: true, sep: ',', strip: true)
    .map { row -> [row.sample, file(row.fastq_1), file(row.fastq_2)] }
    .set { ch_reads }


    //
    // MODULE: FASTQC
    //
    //FASTQC (INPUT_CHECK.out.reads)
    
    //ch_versions = ch_versions.mix(FASTQC.out.versions.first())

    //CUSTOM_DUMPSOFTWAREVERSIONS (ch_versions.unique().collectFile(name: 'collated_versions.yml'))
    
    
    //
    // MODULE: Kneaddata
    //
    //KNEADDATA(ch_reads)
    
    
    //
    // MODULE: CAT
    // Concatenate FASTQ files with cat
    CAT(ch_reads)
    
    CAT.out.output.set { ch_concatenated_reads }
    
    //
    // MODULE: SEQTK
    // Subsample reads from FASTQ files  -> DEJAR COMENTADO SI YA SE HA HECHO EL DOWNSAMPLING ANTES
    //SEQTK()

    //
    // MODULE: METAPHLAN_CLASSIFY
    //
    METAPHLAN_CLASSIFY(ch_concatenated_reads)
    
    METAPHLAN_CLASSIFY.out.metaphlan_output.set { metaphlan_output_for_merging_and_profiling }
    
    METAPHLAN_CLASSIFY.out.metaphlan_output.map { it[2] }.collect().set { metaphlan_profiles_for_merging }
    
    //
    // MODULE: METAPHLAN_MERGE
    //
    METAPHLAN_MERGE(metaphlan_profiles_for_merging)
    
    METAPHLAN_MERGE.out.merged_output.set { tables_merged }
    
    //
    // MODULE: METAPHLAN_DIVERSITY
    // 
    METAPHLAN_DIVERSITY (tables_merged)
    
    //
    // MODULE: HUMMAN3_PROFILING
    // 
    //HUMANN3_PROFILING(metaphlan_output_for_merging_and_profiling)

    //HUMANN3_PROFILING.out.output.collect().set { humann3_output_for_join }
    
    //
    // MODULE: METAPHLAN_ABUNDANCE
    //
    
    //
    // MODULE: google-charts
    //
    
    //
    // MODULE: HUMANN3_JOIN
    //
    //HUMANN3_JOIN(humann3_output_for_join)
    
    //HUMANN3_JOIN.out.joined_table.set { joined_table_for_renorm }
    
    //
    // MODULE: HUMANN3_RENORM
    //	
    //HUMANN3_RENORM(joined_table_for_renorm)


    //
    // MODULE: HUMANN3_REGROUP
    //
    
    //
    // MODULE: PHYLOSEQ_PLOTS
    //
    PHYLOSEQ_PLOTS (tables_merged)
    
    //
    // MODULE SELECT
    //

    //
    // MODULE: HUMMAN3_BARPLOT
    //
    
    //
    // MODULE: HUMMAN3_LEFSE
    //
    
    //
    // MODULE: LEFSE
    //
    
    //
    // MODULE: MAASLIN2
    //

    //
    // ...
    //
    
    
    

    //
    // MODULE: MultiQC
    //
    // workflow_summary    = WorkflowMicrobiome.paramsSummaryMultiqc(workflow, summary_params)
    // ch_workflow_summary = Channel.value(workflow_summary)

    // methods_description    = WorkflowMicrobiome.methodsDescriptionText(workflow, ch_multiqc_custom_methods_description, params)
    // ch_methods_description = Channel.value(methods_description)

    // ch_multiqc_files = Channel.empty()
    // ch_multiqc_files = ch_multiqc_files.mix(ch_workflow_summary.collectFile(name: 'workflow_summary_mqc.yaml'))
    // ch_multiqc_files = ch_multiqc_files.mix(ch_methods_description.collectFile(name: 'methods_description_mqc.yaml'))
    // ch_multiqc_files = ch_multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml.collect())
    // ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]}.ifEmpty([]))

    // MULTIQC (
    // ch_multiqc_files.collect(),
    // ch_multiqc_config.toList(),
    // ch_multiqc_custom_config.toList(),
    // ch_multiqc_logo.toList()
    // )
    // multiqc_report = MULTIQC.out.report.toList()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    COMPLETION EMAIL AND SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow.onComplete {
    if (params.email || params.email_on_fail) {
        NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
    }
    NfcoreTemplate.dump_parameters(workflow, params)
    NfcoreTemplate.summary(workflow, params, log)
    if (params.hook_url) {
        NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
