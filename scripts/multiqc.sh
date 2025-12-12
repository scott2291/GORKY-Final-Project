#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-multiqc-%j.out

set -euo pipefail

# Constants

multiqc=oras://community.wave.seqera.io/library/multiqc:1.31--e111a2e953475c51

# Load Modules

module load samtools/1.21

# Copy placeholder variables

input="$1"
outdir="$2"

# Initial logging

echo "# Starting script multiqc.sh"
date
echo "# Input Directory:                 $input"
echo
echo "# Output Directory:                $outdir"
echo

# Create the output dir (with a subdir for Slurm logs)

mkdir -p "$outdir"multiqc/logs
mkdir -p "$outdir"multiqc/stats

# Generate stats for MultiQC

for input_file in "$input"/*.bam; do
    filename=$(basename "$input_file")
    echo " # Running Analysis on $input_file"
    echo " # File basename  $filename"
    samtools stats "$input_file" > "$outdir"multiqc/stats/"$filename".stats
    samtools flagstat "$input_file" > "$outdir"multiqc/stats/"$filename".flagstat
    samtools  idxstats "$input_file".bai > "$outdir"multiqc/stats/"$filename".idxstats
done

# Run MultiQC

apptainer exec "$multiqc" multiqc --outdir "$outdir"multiqc "$outdir"multiqc/stats/

# Final logging
echo
echo "# Used MultiQC version:"
apptainer exec "$multiqc" multiqc --version
echo "# Successfully finished script multiqc.sh"
date
