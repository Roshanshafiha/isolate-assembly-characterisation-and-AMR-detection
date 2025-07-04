process Antismash {
    conda '/home/ubuntu/miniconda3/envs/antismash-v6.1.1'
    tag "$sample_id"
	publishDir "${params.outputDir}/Antismash/$sample_id", mode: params.saveMode
    
    input:
    tuple val(sample_id), path(gbk)

    output:
    tuple val(sample_id), path("${sample_id}.json"), emit: json
    path("*.json"), emit: json_ch

    script:
    """
    antismash   \
    --cpus ${params.antismash_threads} \
    --taxon bacteria \
    --genefinding-tool none \
    --minimal \
    --output-dir antismash \
    --output-basename ${sample_id} \
    ${gbk}
    mv antismash/${sample_id}.json ./
    """
}