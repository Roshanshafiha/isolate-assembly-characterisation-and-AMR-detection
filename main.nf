#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Isolate assembly characterisation and AMR prediction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

// Global params
params.saveMode         = "copy"

// Input options
params.inputDir         = "$projectDir/input-seqs/"
params.outputDir        = "$projectDir/pipeline-run/"
params.workDir          = "$projectDir/work/"
params.mapping_file     = "$projectDir/mapping.csv"
params.study_details    = "$projectDir/StudyDetails.json"
params.reads            = "$projectDir/input-seqs/Sample*/Sample*_R{1,2}.fastq.gz"

// Parameters FastQC
params.fastqc_cpus     = 1
params.min_seq_length = 70

//Fastp parameters
params.fastp_threads = 10

//Megahit parameters
params.megahit_threads = 10
params.megahit_mem = 107374182400 // 100GB in bytes


//Prokka parameters
params.prokka_threads = 10

//AMRfinderplus parameters
params.amr_threads = 10

//Eggnog parameters
params.emapper_threads = 10

//Antismash parameters
params.antismash_threads = 10


//Functional Descriptions - Paths to files
params.go_metadata = "$projectDir/resources/GO_terms.csv"
params.ec_metadata = "$projectDir/resources/EC_description.txt"
params.kegg_module_metadata = "$projectDir/resources/kegg_module.tsv"
params.kegg_pathway_metadata = "$projectDir/resources/kegg_pathway"


log.info """\
        I S O L A T E  A S S E M B L Y  Eagle  Genomics  Pipeline
         =================================================================
         Inputs: ${params.inputDir}
         Outputs: ${params.outputDir}
         WorkDir: ${params.workDir}
         """
         .stripIndent()

include { FASTQC as FastQCRaw } from './modules/fastqc'
include { MultiQC as MultiQCRaw } from './modules/multiqc'
include { FASTQC as FastQCQuality } from './modules/fastqc'
include { MultiQC as MultiQCQuality } from './modules/multiqc'
include { FastQCfilter } from './modules/fastqc_filter'
include { Fastp } from './modules/fastp'
include { Megahit } from './modules/megahit'
include { Prokka } from './modules/prokka'
include { emapper } from './modules/emapper'
include { Antismash } from './modules/antismash'
include { metabolite_descriptions } from './modules/metabolite_descriptions'
include { modifiedgff } from './modules/modified_gff'
include { gfftable } from './modules/gff_table'
include { Amrfinderplus} from './modules/amrfinderplus'

import groovy.json.JsonSlurper

class WorkflowVerification {

    //
    // Function that parses json output file to check for exit status
    //
    public static Integer validateInput(json_file) {
        def Map json = (Map) new JsonSlurper().parseText(json_file.text)
        if (!json['error-message'].isEmpty()) {
            log.error json['error-message']
            sleep(10000)
            // System.exit(1)
        }
    }
}

// WORKFLOW: Executes the full workflow by default
// nextflow run main.nf
workflow {
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    input_ch = Channel.fromPath(params.inputDir, checkIfExists: true)
    mapping_file_ch = Channel.fromPath( params.mapping_file)
    study_details_file_ch = Channel.fromPath( params.study_details)

    // Quality control
    FastQCRaw( reads_ch )
    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix( FastQCRaw.out.zip.collect{it[1]}.ifEmpty([]) )
    MultiQCRaw( ch_multiqc_files )

    Fastp( reads_ch )
    FastQCQuality( Fastp.out.reads )
    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix( FastQCQuality.out.zip.collect{it[1]}.ifEmpty([]) )
    MultiQCQuality( ch_multiqc_files )
    
    FastQCfilter( FastQCQuality.out.zip )
    join_ch = ( FastQCfilter.out.manifest ).join( Fastp.out.reads )

    final_reads_ch = join_ch.map { sample, csv_files, fastq_files -> tuple( sample, fastq_files ) }
    
    // Assembly
    Megahit (final_reads_ch)
    
    // Functional annotation
    Prokka (Megahit.out.assembly)
    emapper (Prokka.out.protein)
    Antismash (Prokka.out.gbk)
    modifiedgff (Prokka.out.gff)
    gfftable (Prokka.out.gff)
    join_ch_prokka_gff = ( Prokka.out.amr_input ).join( modifiedgff.out.gff_files )
    Amrfinderplus (join_ch_prokka_gff)


}

workflow.onComplete {
	log.info ( workflow.success ? "Done!" : "Oops .. something went wrong" )
}