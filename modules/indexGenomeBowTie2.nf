/*
 * Define the indexGenome process that creates a BWA index
 * given the genome fasta file
 */
process indexGenomeBowTie2 {
    
    container 'growland1/bowtie2:2.5.4'
    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_medium'
    }
    
    // Publish indexed files to the specified directory
    publishDir("$params.outdir/GENOME_IDX", mode: "copy")

    input:
    path genomeFasta

    output:
    tuple path(genomeFasta), path("*.bt2")

    script:
    """
    echo "Running Index Genome"
    BASENAME=\$(basename "${genomeFasta}" .fasta)

    # Generate BWA index
    bowtie2-build --threads 8 "${genomeFasta}" \$BASENAME

    echo "Genome Indexing complete."
    """
}
