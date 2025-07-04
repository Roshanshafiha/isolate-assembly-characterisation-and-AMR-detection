process FASTQC {
    conda '/home/ubuntu/miniconda3/envs/fastqc-v0.11.9'
    tag "$sample_id"
    publishDir "$params.outputDir/fastqc/", mode: params.saveMode
    

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*.html"), emit: html
    tuple val(sample_id), path("*.zip") , emit: zip

    script:
    """
    fastqc --threads ${params.fastqc_cpus} ${reads[0]} ${reads[1]}
    """
}

