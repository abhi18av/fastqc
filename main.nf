#!/usr/bin/env nextflow

/*
#==============================================
code documentation
#==============================================
*/


/*
#==============================================
params
#==============================================
*/

params.saveMode = 'copy'
params.resultsDir = 'results/fastqc'
params.filePattern = "./*_{R1,R2}.fastq.gz"

Channel.fromFilePairs(params.filePattern)
        .set { ch_in_fastqc }


/*
#==============================================
fastqc
#==============================================
*/

process fastqc {
    publishDir params.resultsDir, mode: params.saveMode
    container 'quay.io/biocontainers/fastqc:0.11.9--0'


    input:
    set genomeFileName, file(genomeReads) from ch_in_fastqc

    output:
    tuple file('*.html'), file('*.zip') into ch_out_fastqc


    script:
    genomeName = genomeFileName.toString().split("\\_")[0]
    outdirName = genomeName

    """
    fastqc ${genomeReads[0]}
    fastqc ${genomeReads[1]}
    """
}

/*
#==============================================
# extra
#==============================================
*/
