/*
 * Align reads to the indexed genome
 */
process alignReadsBowTie2 {

    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_high'
    }
    container 'growland1/bowtie2:2.5.4'

    tag "$sample_id"
    cpus 8

    input:
    tuple val(sample_id), path(reads)   // reads is a tuple of paths for paired-end reads
    path requiredIndexFiles

    output:
    tuple val(sample_id), file("${sample_id}.bam")

    script:
    """
    echo "Running Align Reads"

    filename=\$(find -L ./ -name "*.bt2*" | head -n 1)
    INDEX_PREFIX=\$(basename \$filename | cut -f1 -d'.')

    # Check if the input FASTQ files exist
    if [ -f "${reads[0]}" ]; then
        if [ -f "${reads[1]}" ]; then
            # Paired-end mode
            bowtie2 -p 8 -x \$INDEX_PREFIX -1 ${reads[0]} -2 ${reads[1]} --rg-id ${sample_id} --rg SM:${sample_id} --rg LB:lib1 --rg PL:ILLUMINA | samtools view -b -o ${sample_id}.bam
            
        else
            # Single FASTQ mode
            bowtie2 -p 8 -x \$INDEX_PREFIX -U ${reads[0]} --rg-id ${sample_id} --rg SM:${sample_id} --rg LB:lib1 --rg PL:ILLUMINA | samtools view -b -o ${sample_id}.bam
        fi
    else
        echo "Error: Read file ${reads[0]} does not exist for sample ${sample_id}."
        exit 1
    fi

    echo "Alignment complete"
    """
}
