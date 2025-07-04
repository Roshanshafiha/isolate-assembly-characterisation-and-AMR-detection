process emapper { 
    conda '/home/ubuntu/miniconda3/envs/eggnog-v2.1.9'
    tag "$sample_id"
    publishDir "${params.outputDir}/Emapper/$sample_id/", mode: params.saveMode

    input:
    tuple val(sample_id), path(protein)
    

    output:
    tuple val(sample_id), path("*.annotations")         , emit: annotations
    tuple val(sample_id), path("*.hits")                , emit: hits
    tuple val(sample_id), path("*.seed_orthologs")      , emit: orthologs

    script:

    """
    emapper.py -m diamond --itype proteins -i ${protein} -o ${sample_id} --cpu ${params.emapper_threads}

    """



}