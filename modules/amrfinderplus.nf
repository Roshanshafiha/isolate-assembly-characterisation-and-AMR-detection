process Amrfinderplus {
    conda '/home/ubuntu/miniconda3/envs/amrfinderplus-v3.10.45'

		tag "$sample_id"
		publishDir "${params.outputDir}/Amrfinder/$sample_id", mode: params.saveMode

		input: 
		tuple val(sample_id), path(fna),path(faa),path(gff)

    	output:
        tuple val(sample_id), path("*.tsv"), emit: results

		script:
        """
        amrfinder \\
        -p ${faa} \\
        -g ${gff} \\
        -n ${fna} \\
        --threads ${params.amr_threads} \\
        -o ${sample_id}.output.tsv
        """
}