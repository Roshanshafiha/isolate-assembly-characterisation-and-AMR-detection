process metabolite_descriptions {

	tag "$sample_id"
	publishDir "${params.outputDir}/metabolite_descriptions/", mode: params.saveMode
    conda '/home/ubuntu/miniconda3/envs/python'

	input: 
	tuple val(sample_id), path(antismash)

    output:
    path("*.tsv"), emit: metabolites

	script:
    """
    python3 /home/ubuntu/pipelines/nf-isolate-assembly-characterisation/bin/metabolite_descriptions.py \\
        --sample ${sample_id} \\
        --antismash ${antismash}
    """
}