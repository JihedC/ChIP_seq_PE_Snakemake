rule get_genome_fasta:
    output:
        WORKING_DIR + "genome.fasta"
    message:"Downloading {GENOME_FASTA_FILE} genomic fasta file"
    shell: "wget -O {output} {GENOME_FASTA_URL}"


rule get_gff:
    output:
        WORKING_DIR + "gene_model.gff"
    message:"Downloading {GFF_FILE} genomic fasta file"
    shell: "wget -O {output} {GFF_URL}"
