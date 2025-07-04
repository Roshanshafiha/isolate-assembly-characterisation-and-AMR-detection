/*
#==============================================
Quality cotrol analysis - FastQC filtration
#==============================================
*/

process FastQCfilter {

    tag "$sample_id"
    publishDir "${params.outputDir}/FastQCfilter/$sample_id", mode: params.saveMode
    //container "docker.io/eaglegenomics/fastqc:latest"
    conda '/home/ubuntu/miniconda3/envs/python'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*.csv")    , optional:true, emit: manifest
    tuple val(sample_id), path("*.json")   , optional:true, emit: filter
    //tuple val(sample_id), path("bad-*.json") , optional:true, emit: bad
    path("*.json")                  , optional:true, emit: alljson                 
    

    script:

    """
    python3 /home/ubuntu/pipelines/pipeline-tools/fastqc/fastqcfilter.py \
    -s ${sample_id} \
    -r1 ${reads[0]} \
    -r2 ${reads[1]} \
    -ms $params.min_seq_length
    """
}