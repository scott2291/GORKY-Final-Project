#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-fastqc-%j.out
set -euo pipefail

# Constants

bcftools=oras://community.wave.seqera.io/library/bcftools:1.22--1a919f5a53001c39

# Placeholder variables

inputvcf="$1"
outdir="$2"

# Initial Logging

echo "# Starting script indel_position.sh"
date
echo "# Input file:                      $inputvcf"
echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store
mkdir -p "$outdir"/indel_poistion

# Use bcftools to create a new vcf file that only contains indels from chromosome 3

apptainer exec "$bcftools" bcftools view -r chr3 -v indels "$inputvcf" > "$outdir"/indel_position/chr3_indels.vcf

# Extract coordinates of the beginning of indel 5 and the beginning of indel 6

# shellcheck disable=SC2037
start_pos=$(grep -v "^#" "$outdir"/indel_position/chr3_indels.vcf | sed -n '5p')

end_pos=$(awk '{ref_len=length($4); alt_len=length($5); if(ref_len>alt_len){end=$2+ref_len-alt_len}else{end=$2}')

# Print starting and ending position

echo
echo "Indel 5 starting position: $start_pos"
echo
echo "Indel 5 ending position: $end_pos"
echo

# Final logging
echo
echo "# Used bcftools version:"
apptainer exec "$bcftools" bcftools --version
echo "# Successfully finished script indel_position.sh"
date