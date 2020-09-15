rule trimGalorePE:
	input:
		getFastq
	output:
		R1="analysis/filteredDataDir/{sample}_R1_val_1.fq.gz",
		R2="analysis/filteredDataDir/{sample}_R2_val_2.fq.gz"

	message: "TrimGalore on {wildcards.sample} "
	log:
		"analysis/log/trimGalorePE/{sample}.log"
	shell:
		"trim_galore --fastqc --gzip --paired -o analysis/filteredDataDir {input} &>{log}"





rule adaptNames:
	input:
	        R1="analysis/filteredDataDir/{sample}_R1_val_1.fq.gz",
            R2="analysis/filteredDataDir/{sample}_R2_val_2.fq.gz"
	output:
            R1="analysis/finalDataDir/{sample}_R1.fastq.gz",
            R2="analysis/finalDataDir/{sample}_R2.fastq.gz"
	message: "Adapt names of {sample} for the rest of the analysis"
	shell:
		"""
		mv {input.R1} {output.R1}
		mv {input.R2} {output.R2}
		"""


rule index:
    input:
        WORKING_DIR + "genome.fasta"
    output:
        [WORKING_DIR + "genome." + str(i) + ".bt2" for i in range(1,5)],
        WORKING_DIR + "genome.rev.1.bt2",
        WORKING_DIR + "genome.rev.2.bt2"
    message:"Indexing Reference genome"
	log:
		"analysis/log/bowtie_index/indexGenome.log"
    params:
        WORKING_DIR + "genome"
    threads: 10
    shell:"bowtie2-build --threads {threads} {input} {params}"
