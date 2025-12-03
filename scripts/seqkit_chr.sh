#!/bin/bash
set -euo pipefail

# Constants

seqkit=oras://community.wave.seqera.io/library/seqkit:2.11.0--b6acc663486362a3

# Input variables

ref_heinz_2="$1"
ref_heinz_3="$2"
ref_heinz_4="$3"
ref_m82="$4"
heinz_2_chr_name="$5"
heinz_3_chr_name="$6"
heinz_4_chr_name="$7"
m82_chr_name="$8"
outdir="$9"

# Inital Logging

echo "# Starting script seqkit_chr.sh"
date
echo "# Input Heinz 1706.2 SL2.50 Ref Genome:            $ref_heinz_2"
echo
echo "#Input Heinz 1707.3 SL2.50 Ref Genome:              $ref_heinz_3"
echo
echo "# Input Heinz 1706 SL4.0 Ref Genome                  $ref_heinz_4"
echo
echo "# Input M82 ref genome:               $ref_m82"
echo
echo "# Name of Chromosome 3 Heinz 1706.2 SL2.50 Ref Genome: :       $heinz_2_chr_name"
echo
echo "# Name of Chromosome 3 Heinz 1706.3 SL2.50 Ref Genome:              $heinz_3_chr_name"
echo
echo "# Name of Chromosome 3 Heinz 1706 SL4.0 Ref Genome: :       $heinz_4_chr_name"
echo
echo "# Name of Chromosome 3 M82 Ref Genome:              $m82_chr_name"
echo
echo "# Output dir:                      $outdir"
echo

# Create the output dir with a subdir to store new files

mkdir -p "$outdir"fasta_chromosome

# Use seqkit to create a new file that only contains the specified region for Heinz 1706.2 SL2.50 Ref Genome

apptainer exec "$seqkit" seqkit grep -p "$heinz_2_chr_name"  "$ref_heinz_2" > "$outdir"fasta_chromosome/Heinz1706.2_SL2.50_"$heinz_2_chr_name".fna

# Use seqkit to create a new file that only contains the specified region for Heinz 1706.3 SL2.50 Ref Genome

apptainer exec "$seqkit" seqkit grep -p "$heinz_3_chr_name"  "$ref_heinz_3" > "$outdir"fasta_chromosome/Heinz1706.3_SL2.50_"$heinz_3_chr_name".fna

# Use seqkit to create a new file that only contains the specified region for Heinz 1706 SL4.0 Ref Genome

apptainer exec "$seqkit" seqkit grep -p "$heinz_4_chr_name"  "$ref_heinz_4" > "$outdir"fasta_chromosome/Heinz1706_SL4.0_"$heinz_4_chr_name".fna

# Use seqkit to create a new file that only contains the specified region for M82 Ref Genome

apptainer exec "$seqkit" seqkit grep -p "$m82_chr_name"  "$ref_m82" > "$outdir"fasta_chromosome/M82_"$m82_chr_name".fna

# Final logging

echo
echo "# Used seqkit version:"
apptainer exec "$seqkit" seq --version
echo "# Successfully finished script seqkit_chr.sh"
date