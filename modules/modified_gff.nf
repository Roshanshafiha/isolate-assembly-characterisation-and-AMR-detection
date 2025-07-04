process modifiedgff {

		tag "$sample_id"
		publishDir "${params.outputDir}/modifiedgff/$sample_id", mode: params.saveMode

		input: 
		tuple val(sample_id),path(gff)

    	output:
        tuple val(sample_id), path("*_amr.gff"), emit: gff_files

		script:
        """
        gff_modification.sh ${gff} ${sample_id}_amr.gff 
        """
}