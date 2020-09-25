################## Import libraries ##################

import pandas as pd
import os
import sys
from subprocess import call
import itertools
from snakemake.utils import R


################## Configuration file and PATHS##################

configfile: "config.yaml"
WORKING_DIR         = config["working_dir"]    # where you want to store your intermediate files (this directory will be cleaned up at the end)
RESULT_DIR          = config["result_dir"]      # what you want to keep


GENOME_FASTA_URL    = config["refs"]["genome_url"]
GENOME_FASTA_FILE   = os.path.basename(config["refs"]["genome_url"])
GFF_URL             = config["refs"]["gff_url"]
GFF_FILE            = os.path.basename(config["refs"]["gff_url"])

################## Helper functions ##################

def get_fastq(wildcards):
    return units.loc[(wildcards.sample), ["fq1", "fq2"]].dropna()

def get_samples_per_treatment(input_df="units.tsv",colsamples="sample",coltreatment="condition",treatment="control"):
    """This function returns a list of samples that correspond to the same experimental condition"""
    df = pd.read_table(input_df)
    df = df.loc[df[coltreatment] == treatment]
    filtered_samples = df[colsamples].tolist()
    return filtered_samples

################## Definition of Samples ##################

units = pd.read_table(config["units"], dtype=str).set_index(["sample"], drop=False)

SAMPLES = units.index.get_level_values('sample').unique().tolist()

CASES = get_samples_per_treatment(treatment="treatment")
CONTROLS = get_samples_per_treatment(treatment="control")

GROUPS = {
    "group1" : ["ChIP1", "ChIP2", "ChIP3", "ChIP4"],
    "group2" : ["ChIP5"]
}
#I used this dictionnary to define the group of sample used in the multiBamSummary, might be improved a lot


################## CONTAINER ##################

singularity :shub://JihedC/ChIP_seq_PE_Snakemake


################## DESIRED OUTPUT ##################

SORTED  =     expand(RESULT_DIR + "mapped/{sample}.sorted.rmdup.bam", sample=SAMPLES)


################## RULE ALL ##################

rule all:
    input:
        SORTED
        ""
    message : "Analysis is complete!"
    shell:""


################## INCLUDE RULES ##################


include: "rules/retrieveData.smk"
include: "rules/retrieveGenomaData.smk"
include: "rules/preprocess.smk"
include: "rules/mapping.smk"
include: "rules/QC.smk"
include: "rules/centrifuge.smk"
include: "rules/callPeaks.smk"
