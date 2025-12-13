#!/bin/bash
set -euo pipefail

# Constants

gffread=oras://community.wave.seqera.io/library/gffread:0.12.7--b08e770b84a4a126

# Input Variables

input_gbff="$1"
filename=$(basename "$input_gbff")

# Initial Logging

echo "# Starting script gbff_to_gff.sh"
date
echo "# Input file:                      $input_gbff"
echo 
echo "# File basename:              $filename"

# Make subdir to hold gff3 files

mkdir -p  data/gff/gff3

# Extract the gff3 file from the gbff file

apptainer exec "$gffread" gffread "$input_gbff" -o data/gff/gff3/"$filename".gff3

# Final logging
echo
echo "# Used gffread version:"
apptainer exec "$gffread" gffread --version
echo "# Successfully finished script gbff_to_gff.sh"
date