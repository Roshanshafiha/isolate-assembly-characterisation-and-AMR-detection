process Megahit {
    conda '/home/ubuntu/miniconda3/envs/Megahit-v1.2.9'
    tag "$sample_id"
    publishDir "$params.outputDir/Megahit/$sample_id", mode: params.saveMode, pattern: "*.contigs.fa"
    //publishDir "$params.outputDir/megahit/", mode: params.saveMode, pattern: "*.log"
    //container "docker.io/eaglegenomics/megahit:latest"
    
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.contigs.fa")   , emit: assembly
    path "${sample_id}.log"                               , emit: log
    tuple val(sample_id), path("*.gz")   , emit: gzip
    
    script:
    """
    megahit \
    -t "${params.megahit_threads}" \
    -m ${params.megahit_mem} \
    -1 "${reads[0]}" -2 "${reads[1]}" \
    --out-prefix "${sample_id}"
    mv megahit_out/${sample_id}.contigs.fa ./
    cp ${sample_id}.contigs.fa ${sample_id}.contigs.fna
    gzip ${sample_id}.contigs.fna
    mv megahit_out/${sample_id}.log ./
    """
}