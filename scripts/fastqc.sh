#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-fastqc-%j.out
set -euo pipefail

# Load the OSC module for FastQC

module load fastqc/0.12.1

# Load input variables

fastq_file="$1"
outdir="$2"

# Inital Logging

echo "Starting script fastqc.sh"
date
echo "# Input Fastq File:          $fastq_file"
echo
echo "# Output Directory:               $outdir"
echo

# Create Output Directory for slurm logs and for fastqc files


mkdir -p "$outdir"fastqc

mkdir -p "$outdir"fastqc/slurm_logs

# Run FastQC

fastqc --threads 3 --outdir "$outdir"fastqc "$fastq_file"

# Final Logging Statements

echo
echo "# Used FastQC version:"
fastqc --version
echo
echo "# Successfully finished script fastqc.sh"
date
