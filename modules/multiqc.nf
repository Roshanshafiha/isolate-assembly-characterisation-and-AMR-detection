process MultiQC {

    conda '/home/ubuntu/miniconda3/envs/multiqc-1.6'

    publishDir "${params.outputDir}/MultiQC/", mode: params.saveMode

    input:
    path(zip)

    output:
    path('*.html')              , emit: report
    path('*_data')              , emit: data

    script:

    """
    multiqc ${zip}
    """
}