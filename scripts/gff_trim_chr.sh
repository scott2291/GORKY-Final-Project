#!/bin/bash
set -euo pipefail

# Constants

gffread=oras://community.wave.seqera.io/library/gffread:0.12.7--b08e770b84a4a126

# Input variables

input_gff="$1"
chr_name="$2"
filename=$(basename "$input_gff")

# Inital Logging

echo "# Starting script gff_trim_chr.sh"
date
echo "# Input GFF file:            $input_gff"
echo
echo "# Input Chromosome Name     $chr_name"
echo

# Make output directory

mkdir -p data/gff/trimmed

# Trim the GFF file to only include chromosome 3 using awk

apptainer exec "$gffread" gffread "$input_gff" -o- \
  | awk -v c="$chr_name" '
      BEGIN { FS="\t"; fasta=0 }
      /^##FASTA/ { fasta=1; next }
      fasta==1 { next }
      /^#/ { print; next }
      $1==c { print }
    ' \
  > "data/gff/trimmed/${filename}_${chr_name}.gff"


# Final logging

echo
echo "# Successfully finished script gff_trim_chr.sh"
date