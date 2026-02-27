/*
 * Define the indexGenome process that creates a BWA index
 * given the genome fasta file
 */
process indexGenomeBwa {

    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_high'
    }
    container 'variantvalidator/indexgenome:1.1.0'


    // Publish indexed files to the specified directory
    publishDir("$params.outdir/GENOME_IDX", mode: "copy")

    input:
    path genomeFasta

    output:
    tuple path(genomeFasta), path("${genomeFasta}.{bwt,pac,ann,amb,sa}")

    script:
    """
    echo "Running Index Genome"

    # Generate BWA index
    bwa index "${genomeFasta}"
    
    echo "Genome Indexing complete."
    """
}
