
process Prokka {
    conda '/home/ubuntu/miniconda3/envs/Prokka-v1.14.6'
    tag "$sample_id"
    publishDir "${params.outputDir}/Prokka/$sample_id/", mode: params.saveMode
    //container "docker.io/eaglegenomics/prokka:latest"

    input:
        tuple val(sample_id), path(contigs)

    output:
        tuple val(sample_id), path("*.fna"), emit: cds
        tuple val(sample_id), path("*.faa"), emit: protein 
        tuple val(sample_id), path("*.gbk"), emit: gbk 
        tuple val(sample_id), path("*.gff"), emit: gff
        tuple val(sample_id), path("*.txt"), emit: stats 
        tuple val(sample_id), path("*.fna"), path("*.faa") , emit: amr_input
        path("*.txt"), emit: stats_ch
    
    script:
    """
    prokka --cpus ${params.prokka_threads} \
            ${contigs} \
            --prefix ${sample_id} \
            --strain ${sample_id} \
            --outdir . \
            --force
    """
}
