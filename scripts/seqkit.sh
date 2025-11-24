#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-fastqc-%j.out
set -euo pipefail

# Constants

seqkit_container=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3

#


# Run seqkit

apptainer exec "$seqkit_contatiner"