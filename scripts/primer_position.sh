#!/bin/bash
#SBATCH --account=PAS2880
#SBATCH --mail-type=FAIL
#SBATCH --output=slurm-primer_position-%j.out
set -euo pipefail

# Constants

seqkit=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3

# Input Variables

ref_genome="$1"
primer1="$2"
primer2="$3"
outdir="$4"
filename=$(basename "$ref_genome")

# Inital logging

echo "# Starting script primer_position.sh"
date
echo "# Input Refenerce Genome:            $ref_genome"
echo
echo "# Forward Primer Sequence:       $primer1"
echo
echo "# Reverse Primer Sequence:              $primer2"
echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store

mkdir -p "$outdir"primer_region
mkdir -p "$outdir"primer_region/logs

# Locate primers within the Heinz 1706.2 reference genome using seqkit

apptainer exec "$seqkit" seqkit locate -i -p "$primer1" "$ref_genome" > "$outdir"/primer_region/"$filename"_forward.tsv
apptainer exec "$seqkit" seqkit locate -i -p "$primer2" "$ref_genome" > "$outdir"/primer_region/"$filename"_reverse.tsv


echo
echo "# Used seqkit version:"
apptainer exec "$seqkit" seq --version
echo "# Successfully finished script primer_position.sh"
date