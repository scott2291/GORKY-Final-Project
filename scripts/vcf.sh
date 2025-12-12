#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-vcf-%j.out
set -euo pipefail

# Load Modules

module load htslib/1.20
module load samtools/1.21

# Constants

bcftools=oras://community.wave.seqera.io/library/bcftools:1.22--1a919f5a53001c39

# Input variables

ref_genome="$1"
mapped_sorted_bam="$2"
outdir="$3"
file_name=$(basename "$ref_genome")

# Initial Logging

echo "# Starting script vcf.sh"
date
echo "# Input Reference Genome:                      $ref_genome"
echo
echo "# Input Mapped and Sorted BAM file:            $mapped_sorted_bam"
echo
echo "# Output dir:                      $outdir"
echo

# Create the output for vcf and logs

mkdir -p "$outdir"vcf
mkdir -p "$outdir"vcf/logs

# Generate a multiway pileup that pipes into a line responsible for variant calling

apptainer exec "$bcftools" bcftools mpileup -Ou -f "$ref_genome" "$mapped_sorted_bam" | \
apptainer exec "$bcftools" bcftools call -mv -Oz -o "$outdir"vcf/"$file_name".vcf.gz

# index the VCF file for querying

apptainer exec "$bcftools" bcftools index "$outdir"vcf/"$file_name".vcf.gz

# Final logging

echo
echo "# Used bcftools version:"
apptainer exec "$bcftools" bcftools --version
echo "# Successfully finished script vcf.sh"
date