process gfftable {

		tag "$sample_id"
		publishDir "${params.outputDir}/gff_table/$sample_id", mode: params.saveMode

		input: 
		tuple val(sample_id),path(gff)

    	output:
        tuple val(sample_id), path("*_table.gff"), emit: gff_files_table

		script:
        """
        /bin/gff_table.sh ${gff} ${sample_id}_table.gff 
        """
}
