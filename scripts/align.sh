#!/bin/bash
#SBATCH --job-name=align_reads
#SBATCH --output=align_reads.out
#SBATCH --account=PAS2880
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-fastqc-%j.out
set -euo pipefail

# Load Modules

module load htslib/1.20
module load bwa/0.7.17
module load samtools/1.21

# Input variables

ref_genome="$1"
fastq_R1="$2"
fastq_R2="$3"
outdir="$4"

# Inital Logging

echo "# Starting script align.sh"
date
echo "# Input Heinz 1706 Ref Genome:            $ref_genome"
echo
echo "# Input Fastq R1 file:               $fastq_R1"
echo
echo "# Input Fastq R2 file:                $fastq_R2"
echo
echo "# Output dir:                      $outdir"
echo

# Create an ouput directory for your bam files

mkdir -p "$outdir"aligned

# Create an index file for your reference genome

bwa index "$ref_genome"

# Use bwa to align paired-end reads to the Heinz reference genome and then pipe the command to samtools to name the file

bwa mem -t 8 "$ref_genome" "$fastq_R1" "$fastq_R2" | \
samtools view -Sb -@ 8> "$outdir"aligned/"$ref_genome".bam

# Sort the BAM file for future analysis

samtools sort -@ 8 "$outdir"aligned/"$ref_genome".bam -o "$outdir"aligned/"$ref_genome".sorted.bam

# Create an index for the BAM file

samtools index "$outdir"aligned/"$ref_genome".sorted.bam