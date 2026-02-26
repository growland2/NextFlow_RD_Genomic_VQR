/*
 * Run fastp on the read fastq files
 */
process FASTP {

    label 'process_single'

    container 'staphb/fastp'

    // Add a tag to identify the process
    tag "$sample_id"

    // Specify the output directory for the FASTP results
    publishDir("$params.outdir/FASTP", mode: "copy")

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}/*.fastq.gz"), emit: processed_reads
    path "${sample_id}/fastp_report.html", emit: fastp_report

    script:
    """
    echo "Running FASTP"
    
    mkdir -p ${sample_id}

    # Check the number of files in reads and run fastp accordingly
    if [ -f "${reads[0]}" ] && [ -f "${reads[1]}" ]; then
        fastp -i ${reads[0]} -I ${reads[1]} -o ${sample_id}/fastp_${reads[0]} -O ${sample_id}/fastp_${reads[1]} -h ${sample_id}/fastp_report.html

    elif [ -f "${reads[0]}" ]; then
        fastp -i ${reads[0]} -o ${sample_id}/fastp_${reads[0]} -h ${sample_id}/fastp_report.html
    else
        echo "No valid read files found for sample ${sample_id}"
        exit 1
    fi

    echo "FASTP Complete"
    """
}
