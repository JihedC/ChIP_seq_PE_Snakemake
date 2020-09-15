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


################## Definition of Samples ##################

tableSamples = pd.read_table(config["samples"],sep="\t",index_col=0)
samples=tableSamples.index
conditions = tableSamples.condition
conditionsUnique=set(conditions)

################## CONTAINER ##################

#singularity :


################## RULE ALL ##################

rule all:
    input:
        ""
    message : "Analysis is complete!"

################## INCLUDE RULES ##################


include: "rules/retrieveData.smk"
include: "rules/retrieveGenomaData.smk"
include: "rules/preprocess.smk"
include: "rules/mapping.smk"
include: "rules/QC.smk"
include: "rules/centrifuge.smk"
include: "rules/callPeaks.smk"
