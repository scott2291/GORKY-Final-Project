#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-multiqc-%j.out

set -euo pipefail

# Constants

multiqc=oras://community.wave.seqera.io/library/multiqc:1.31--e111a2e953475c51

# Copy placeholder variables

input_dir="$1"
outdir="$2"

# Initial logging
echo "# Starting script multiqc.sh"
date
echo "# Input directort:                 $input_dir"
echo
echo "# Output file:                    $outdir"
echo

# Create the output dir (with a subdir for Slurm logs)

mkdir -p "$outdir"multiqc/logs

# Run MultiQC

apptainer exec "$multiqc" multiqc --outdir "$outdir"multiqc "$input_dir"

# Final logging
echo
echo "# Used MultiQC version:"
apptainer exec "$multiqc" multiqc --version
echo "# Successfully finished script multiqc.sh"
date
